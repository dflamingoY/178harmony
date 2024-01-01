import webSocket from '@ohos.net.webSocket';
import hilog from '@ohos.hilog';

var defaultIpAddress = "wss://dev-ws.gqj.live/app/5f88825c28c56763eb0d8b270646e4b1?protocol=7&client=ios&version=1.1.0&flash=false";

export function initWs() {
  let ws = webSocket.createWebSocket();
  ws.on('open', (err, value) => {
    hilog.debug(0xff00, 'Socket', "on open, status:" + value['status'] + ", message:" + value['message']);
    // 当收到on('open')事件时，可以通过send()方法与服务器进行通信

  });

  ws.on('message', (err, value) => {
    hilog.debug(0xff00, 'Socket', "on message, message:" + value);
    // 当收到服务器的`bye`消息时（此消息字段仅为示意，具体字段需要与服务器协商），主动断开连接
    if (value === 'bye') {
      ws.close((err, value) => {
        if (!err) {
          hilog.debug(0xff00, 'Socket', "close success");
        } else {
          hilog.debug(0xff00, 'Socket', "close fail, err is " + JSON.stringify(err));
        }
      });
    }
  });

  ws.on('close', (err, value) => {
    hilog.debug(0xff00, 'Socket',"on close, code is " + value.code + ", reason is " + value.reason);
  });

  ws.on('error', (err) => {
    hilog.debug(0xff00, 'Socket',"on error, error:" + JSON.stringify(err));
  });
  ws.connect(defaultIpAddress, (err, value) => {
    if (!err) {
      hilog.debug(0xff00, 'Socket',"connect success");
    } else {
      hilog.debug(0xff00, 'Socket',"connect fail, err:" + JSON.stringify(err));
    }
  });
}
