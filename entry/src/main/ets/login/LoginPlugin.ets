//是否登陆
import hilog from '@ohos.hilog'

export function isLogin(): boolean {
  hilog.debug(0xff00, "West", "token: " + AppStorage.Link('token'))
  return AppStorage.Link('token') != undefined && AppStorage.Link('token') != null
}