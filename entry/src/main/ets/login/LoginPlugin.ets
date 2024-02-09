//是否登陆

export function isLogin(): boolean {
  let token = globalThis.token
  return token != null
}