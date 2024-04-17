import webSocket from '@ohos.net.webSocket';
import emitter from '@ohos.events.emitter';
import { SocketData } from '../data/SocketData';
import LogUtil from '../utils/LogUtil';
import HttpIp from './HttpIP';
import IConstant from '../utils/IConstant';
import CryptoJS from '@ohos/crypto-js'
import { MsgBean } from '../data/MsgBean';
import Dao from '../db/Dao';
import UserViewModel from '../pages/UserViewModel';

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
    this.ws?.close({ code: 1001, reason: 'shut down' })
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
    let respData: SocketData = JSON.parse(value.toString())
    // LogUtil.d("Socket", "message:" + value + "  " + respData)
    switch (respData.event) {
      case "pushMatch": { //match_type   match_id on_time away_score home_score
        this.sendEmit(IConstant.EVENT_ID_MATCH, {
          "data": respData.data
        })
        break;
      }
      case "room": { //"channel":"room-122968"
        this.sendEmit(IConstant.ROOM_MSG_ID, {
          "data": respData.data,
          'roomId': respData.channel.replace("room-", ''),
          'type': 'msg'
        })
        break;
      }
      case "delRoomMsg": { //删除群消息
        this.sendEmit(IConstant.ROOM_MSG_ID, {
          "data": respData.data,
          'type': 'delRoomMsg'
        })
        break;
      }
      case "disabledUser": { //禁言用户 uid
        this.sendEmit(IConstant.ROOM_MSG_ID, {
          "data": respData.data,
          'type': 'disabledUser'
        })
        break;
      }
      case "woker:connection_established": { // 获取到socketId
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
      }
      case "message": { //聊天消息
        //存入数据库
        let msg: MsgBean = JSON.parse(respData.data)
        //发送消息回执
        this.ws?.send(generatorReceiptSingle(msg.mid))
        UserViewModel.updateMid(msg.mid)
        msg.listId = msg.type + (IConstant.GROUP == msg.type || msg.from == globalThis.uid ? msg.to : msg.from)
        if (msg.from == globalThis.uid) { //自己发送
          //修改自己发送消息状态
          UserViewModel.inertVerifyMsg(msg)
        } else { //收到消息
          Dao.getRdbModel().insertMsg(msg)
        }
        this.sendEmit(IConstant.WS_MSG_ID,
          { "data": respData.data, })
        break;
      }
      case 'message_froward': { //批量处理转发消息
        let msg: Array<MsgBean> = JSON.parse(respData.data)
        UserViewModel.updateMids(msg.map((item) => {
          return item.mid
        }))
        msg.forEach((item) => {
          if (item.type == IConstant.GROUP || item.from == globalThis.uid) {
            item.listId = item.type + item.to
          } else {
            item.listId = item.type + item.from
          }
        })
        Dao.getRdbModel().insertMsgList(msg)
        //更新主界面
        let last = msg[msg.length-1]
        this.sendEmit(IConstant.MSG_OPERATOR_ID, {
          'id': last.type == IConstant.GROUP || last.from == globalThis.uid ? `${last.to}` : `${last.from}`,
          'length': msg.length,
          'type': 'message_froward',
          'chatType': last.type
        })
        //发送保存回执
        this.receiptMsg(JSON.stringify(msg.map((item) => {
          return item.mid
        })))
        break;
      }
      case 'addGroup':

        break;
      case 'group_del_msg': { //群删除某条消息
        let resp = JSON.parse(respData.data)
        Dao.getRdbModel().deleteMsgByMid(resp.mid)
        this.sendEmit(IConstant.MSG_OPERATOR_ID, {
          'chatType': IConstant.GROUP,
          'type': 'group_del_msg',
          'id': respData.channel.replace('group-', ''),
          'mid': resp.mid
        })
        break;
      }
      case 'supervise': //变更群成员身份
        break;
      case 'readMsg': { //已读
        let socketRead = JSON.parse(respData.data)
        let sql = `UPDATE msg SET isRead = 1 WHERE listId = '${IConstant.FRIEND + socketRead.from}' and isRead = 0 and id_from = ${globalThis.uid} `
        Dao.getRdbModel().executeSql(sql)
        this.sendEmit(IConstant.MSG_OPERATOR_ID, { 'type': 'readMsg',
          'id': `${socketRead.from}` }
        )
        break;
      }
      case 'pullMessage': {
        UserViewModel.getOffline()
        break;
      }
      case 'disturb':
        break;
      case 'outGroup':
      // this.ws?.send(generatorUnbindGroup())
        break;
      case 'friendApply':
      case 'addFriend':
      case 'removeFriend':
      case 'removeGroup':
      case 'revoke':
      case 'groupApply': {
        let socket = JSON.parse(respData.data)
        if ('revoke' == respData.event) { //{"type":"friend","id":168,"mid":"67277119","uid":147381}
          Dao.getRdbModel().revoke(socket.mid)
          if (socket.uid == globalThis.uid) {
            return
          }
          this.sendEmit(IConstant.MSG_OPERATOR_ID,
            { "mid": `${socket.mid}`,
              'type': 'revoke',
              'chatType': socket.type,
              'id': socket.type == IConstant.GROUP ? `${socket.id}` : `${socket.uid}` }
          )
        }
        break;
      }
    }
  }

  private sendEmit(eventId, data: {}) {
    emitter.emit({ eventId: eventId }, {
      data: data
    })
  }

  private appKey = "5f88825c28c56763eb0d8b270646e4b1"
  private appSecret = "a2a906fe997867135886e5c4f62b03d2"

  destroy() {
    emitter.off(IConstant.ROOM_WS_ID)
  }
}

export default new SocketTask()
