//是否登陆
import LogUtil from '../utils/LogUtil'

export function isLogin(): boolean {
  let token = globalThis.token
  LogUtil.d("West", `token 状态 ${token!=null}  ${token}`)
  return token != null
}