import webSocket from '@ohos.net.webSocket';
import emitter from '@ohos.events.emitter';
import { SocketData } from '../data/SocketData';
import LogUtil from '../utils/LogUtil';
import HttpIp from './HttpIP';

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

class SocketTask {
  private ping = "{\"event\":\"woker:ping\"}"
  private ws: webSocket.WebSocket | null = null;
  private pingTimerId: number = -1
  private timer: Function = () => {
    LogUtil.d("Socket", "发送ping ")
    if (this.ws != null)
      this.ws?.send(this.ping).then((result) => {
        if (!result) { //ws 发送失败。需要重连
          this.createWs()
        } else {
          this.pingTimerId = setTimeout(this.timer, 10_000)
        }
      })
  }

  createWs() {
    this.ws = webSocket.createWebSocket()
    this.ws.on('open', (err, value) => {
      LogUtil.d("Socket", "on open, status:" + value['status'] + ", message:" + value['message'])
      this.pingTimerId = setTimeout(this.timer, 10_000)
      //开启定时任务
    });
    this.ws.on('message', (err, value) => {
      this.parseWs(value)
    });
    this.ws.on('close', (err, value) => {
      this.clearTime()
      LogUtil.d("Socket", "on close, code is " + value.code + ", reason is " + value.reason)
    });
    this.ws.on('error', (err) => {
      this.clearTime()
      LogUtil.d("Socket", "on error, error:" + JSON.stringify(err))
    });
    let params = { header: { "Origin": HttpIp.origin, "clientType": 'android' } }
    this.ws.connect(defaultIpAddress, params, (err, value) => {
      if (!err) {
        LogUtil.d("Socket", "connect success")
      } else {
        LogUtil.d("Socket", "connect fail, err:" + JSON.stringify(err))
      }
    });
  }

  private clearTime() {
    if (this.pingTimerId != -1) {
      clearTimeout(this.pingTimerId)
    }
  }

  private parseWs(value: string | ArrayBuffer) {
    var respData: SocketData = JSON.parse(value.toString())
    switch (respData.event) {
      case "pushMatch": //match_type   match_id on_time away_score home_score
        let eventData = {
          data: {
            "data": respData.data
          } }
        let innerEvent = {
          eventId: 1,
          priority: emitter.EventPriority.IMMEDIATE
        };
        emitter.emit(innerEvent, eventData)
        break;
    }
    LogUtil.d("Socket", "message:" + value + "  " + respData)

  }
}

export default new SocketTask()
