import systemDateTime from '@ohos.systemDateTime';
import promptAction from '@ohos.promptAction';
import LogUtil from './LogUtil';

class CommonUtil {
  getUserState(state: string, logout_timestamp: number): string {
    return state == "online" ? '在线' : this.calcOfflineTime(logout_timestamp)
  }

  private calcOfflineTime(time: number): string {
    if (time < 60) {
      return "刚刚在线";
    } else if (time < 3600) {
      return Math.floor(time / 60) + "分钟前在线";
    } else if (time < 86400) {
      return Math.floor(time / 3600) + "小时前在线";
    } else if (time < 86400 * 7) {
      return Math.floor(time / 86400) + "天前在线";
    } else if (time < 30 * 86400) {
      return Math.floor(time / (86400 * 7)) + "周前在线";
    } else {
      return "一个月前在线";
    }
  }

  //格式化聊天列表展示时间规则
  parseTime(dTime: number, time: number) {
    if (dTime < 60) {
      return "刚刚";
    } else if (dTime < 3600) {
      Math.floor(dTime / 60)
      return Math.floor(dTime / 60) + "分钟前";
    } else if (dTime < 86400) {
      return Math.floor(dTime / 3600).valueOf() + "小时前";
    } else {
      let datefmt = new Intl.DateTimeFormat();
      let result = datefmt.format(time * 1000)
      return result
    }
  }

  isCloseEnough(time: number): boolean {
    return time < 60_000
  }

  showToast(message: string) {
    promptAction.showToast({ message: message, duration: 500 })
  }
}

export default new CommonUtil()