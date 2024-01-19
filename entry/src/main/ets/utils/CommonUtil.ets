import systemDateTime from '@ohos.systemDateTime';

class CommonUtil {
  getUserState(state: string, logout_timestamp: number): string {
    return state == "online" ? '在线' : this.calcOfflineTime(logout_timestamp)
  }

  private   calcOfflineTime(time: number): string {
    if (time < 60) {
      return "刚刚在线";
    } else if (time < 3600) {
      return (time / 60) + "分钟前在线";
    } else if (time < 86400) {
      return (time / 3600) + "小时前在线";
    } else if (time < 86400 * 7) {
      return (time / 86400) + "天前在线";
    } else if (time < 30 * 86400) {
      return (time / (86400 * 7)) + "周前在线";
    } else {
      return "一个月前在线";
    }
  }
}

export default new CommonUtil()