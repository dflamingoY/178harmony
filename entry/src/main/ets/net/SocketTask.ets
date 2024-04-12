import webSocket from '@ohos.net.webSocket';
import emitter from '@ohos.events.emitter';
import { SocketData } from '../data/SocketData';
import LogUtil from '../utils/LogUtil';
import HttpIp from './HttpIP';
import IConstant from '../utils/IConstant';
import CryptoJS from '@ohos/crypto-js'
import { MsgBean } from '../data/MsgBean';
import Dao from '../db/Dao';

var defaultIpAddress = "wss://ws.gqj.live";

function initGlobal() {
  return "{\"event\":\"woker_internal:subscription_succeeded\", \"data\": \"{}\", \"channel\": \"global\"}"
}

function initUserSign(uid: string, sign: string) {
  return `{\"event\":\"woker:subscribe\",\"data\":{\"sign\":\"${sign}\",\"channel_data\":\"${uid}\",\"channel\":\"presence-${uid}\"}}`
}

function initUserGlobal(uid: string, sign: string) {
  return `{\"event\":\"woker:subscribe\",\"data\":{\"sign\":\"${sign}\",\"channel_data\":\"${uid}\",\"channel\":\"global\"}}`
}

//创建需要绑定socket的内容
function generatorBindMsg(groupId: string) {
  return `{\"event\": \"woker:subscribe\",\"data\": {\"channel\": \"${groupId}\"}}`
}

//解除群socket的绑定
function generatorUnbindGroup(groupId: string) {
  return `{\"event\": \"woker:unsubscribe\",\"data\": {\"channel\": \"${groupId}\"}}`
}

//创建回执数据
function generatorReceipt(list: String) {
  return `{\"event\":\"woker:message_ack\",\"data\":{\"mids\":${list}}}`
}

function generatorReceiptSingle(mid: string) {
  return `{\"event\":\"woker:message_ack\",\"data\":{\"mids\":[\"${mid}\"]}}`
}

export class SocketTask {
  roomId: string | null = null

  constructor() {
    emitter.on({
      eventId: IConstant.ROOM_WS_ID
    }, (event) => {
      if (event.data.roomId && event.data.roomId != null) {
        this.roomId = event.data.roomId
        this.ws?.send(generatorBindMsg(event.data.roomId))
      }
    })
    emitter.on({ eventId: IConstant.WS_GROUP_ID }, (event) => {
      if (event.data.type == 'init') {
        `${event.data.data}`.split(',').forEach((group) => {
          this.ws?.send(generatorBindMsg(group))
        })
      }
    })
  }

  private ping = "{\"event\":\"woker:ping\"}"
  private ws: webSocket.WebSocket | null = null;
  private pingTimerId: number = -1
  private timer: Function = () => {
    if (this.ws != null)
      this.ws?.send(this.ping).then((result) => {
        if (!result) {
          this.createWs()
        } else {
          this.pingTimerId = setTimeout(this.timer, 10_000)
        }
      })
  }

  createWs() {
    this.shutDownWs()
    this.ws = webSocket.createWebSocket()
    this.ws.on('open', (_err, value) => {
      LogUtil.d("Socket", "on open, status:" + value['status'] + ", message:" + value['message'])
      this.pingTimerId = setTimeout(this.timer, 10_000)
      //开启定时任务
    });
    this.ws.on('message', (_err, value) => {
      this.parseWs(value)
    });
    this.ws.on('close', (_err, value) => {
      this.clearTime()
      LogUtil.d("Socket", "on close, code is " + value.code + ", reason is " + value.reason)
    });
    this.ws.on('error', (err) => {
      this.clearTime()
      //断线重连
      if (globalThis.isFore) { //前台再去重连
        this.reConnect()
      }
      LogUtil.d("Socket", "on error, error:" + JSON.stringify(err))
    });
    let params = { header: { "Origin": HttpIp.origin, "clientType": 'android' } }
    this.ws.connect(defaultIpAddress, params, (err) => {
      if (!err) {
        LogUtil.d("Socket", "connect success")
      } else {
        LogUtil.d("Socket", "connect fail, err:" + JSON.stringify(err))
      }
    });
  }

  checkWs() {
    setTimeout(this.timer, 1_000)
  }

  receiptMsg(mid: string) {
    LogUtil.d("West", 'receipt  :' + mid)
    this.ws?.send(generatorReceipt(mid))
  }

  private shutDownWs() {
    this.ws?.close()
    this.ws = null
  }

  private reConnect() {
    setTimeout(() => {
      this.createWs()
    }, 2_000)
  }

  private clearTime() {
    if (this.pingTimerId != -1) {
      clearTimeout(this.pingTimerId)
    }
  }

  private parseWs(value: string | ArrayBuffer) {
    var respData: SocketData = JSON.parse(value.toString())
    LogUtil.d("Socket", "message:" + value + "  " + respData)
    switch (respData.event) {
      case "pushMatch": //match_type   match_id on_time away_score home_score
        let eventData = {
          data: {
            "data": respData.data
          } }
        let innerEvent = {
          eventId: IConstant.EVENT_ID_MATCH,
          priority: emitter.EventPriority.IMMEDIATE
        };
        emitter.emit(innerEvent, eventData)
        break;
      case "room": //"channel":"room-122968"
        let roomMsg = {
          data: {
            "data": respData.data,
            'roomId': respData.channel.replace("room-", ''),
            'type': 'msg'
          } }
        emitter.emit({
          eventId: IConstant.ROOM_MSG_ID,
          priority: emitter.EventPriority.IMMEDIATE
        }, roomMsg)
        break;
      case "delRoomMsg": //删除群消息
        emitter.emit({
          eventId: IConstant.ROOM_MSG_ID,
          priority: emitter.EventPriority.IMMEDIATE
        }, {
          data: {
            "data": respData.data,
            'type': 'delRoomMsg'
          } })
        break;
      case "disabledUser": //禁言用户 uid
        emitter.emit({
          eventId: IConstant.ROOM_MSG_ID,
          priority: emitter.EventPriority.IMMEDIATE
        }, {
          data: {
            "data": respData.data,
            'type': 'disabledUser'
          } })
        break;
      case "woker:connection_established": // 获取到socketId
        if (globalThis.token != null) {
          let data = JSON.parse(respData.data)
          let md5 = CryptoJS.MD5(data['socket_id'] + globalThis.uid + this.appSecret).toString()
          let sign = this.appKey + ":" + md5
          this.ws?.send(initUserSign(globalThis.uid, sign))
          this.ws?.send(initUserGlobal(globalThis.uid, sign))
        } else {
          this.ws?.send(initGlobal())
        }
        if (this.roomId != null) {
          this.ws?.send(generatorBindMsg(this.roomId))
        }
        break;
      case "message": //聊天消息
      //存入数据库
        let msg: MsgBean = JSON.parse(respData.data)
      //发送消息回执
        this.ws?.send(generatorReceiptSingle(msg.mid))
        msg.listId = msg.type + (IConstant.GROUP == msg.type || msg.from == globalThis.uid ? msg.to : msg.from)
        if (msg.from == globalThis.uid) { //自己发送
          //修改自己发送消息状态
          if (msg.sendId == '' || msg.sendId == null) {

          } else {

          }
        } else { //收到消息

          Dao.getRdbModel().insertMsg(msg)
        }
        emitter.emit({
          eventId: IConstant.WS_MSG_ID,
          priority: emitter.EventPriority.IMMEDIATE
        }, {
          data: {
            "data": respData.data,
          } })
        break;
      case 'message_froward':

        break;
      case 'addGroup':

        break;
      case 'group_del_msg':

        break;
      case 'supervise': //变更群成员身份
        break;
      case 'readMsg': //已读

        break;
      case 'pullMessage':

        break;
      case 'disturb':

        break;
      case 'outGroup':

        break;
      case 'friendApply':
      case 'addFriend':
      case 'removeFriend':
      case 'removeGroup':
      case 'revoke':
      case 'groupApply':


        break;
    }
  }

  private appKey = "5f88825c28c56763eb0d8b270646e4b1"
  private appSecret = "a2a906fe997867135886e5c4f62b03d2"

  destroy() {
    emitter.off(IConstant.ROOM_WS_ID)
  }
}

export default new SocketTask()
