import hilog from '@ohos.hilog'

class LogUtil {
  d(key: string, value: string) {
    hilog.debug(0xff00, key, value)
  }
}

export default new LogUtil()