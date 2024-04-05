import http from '@ohos.net.http'
import { BaseResp } from '../data/Data'
import LogUtil from '../utils/LogUtil'
import PreferenceModel from '../utils/PreferenceModel'
import HttpIp from './HttpIP'

export function getData(uri: string): Promise<BaseResp> {
  let request = http.createHttp().request(HttpIp.PORT + uri, {
    method: http.RequestMethod.GET,
    header: {
      "clientType": "android",
      "version": "1.0",
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": globalThis.token??""
    },
    readTimeout: 15000,
    connectTimeout: 15000
  })
  // LogUtil.d("NetLog", `请求路由token   ${globalThis.token}`)
  let resp = new BaseResp()
  return request.then((value: http.HttpResponse) => {
    if (value.responseCode == 200) {
      let result = `${value.result}`
      let resData: BaseResp = JSON.parse(result)
      if (resData.code == 401) { //清除所有用户登陆凭证相关的缓存
        globalThis.token = null
        globalThis.uid = null
        PreferenceModel.deleteKey('token')
        PreferenceModel.deleteKey('user')
      }
      LogUtil.d("NetLog", `请求路由  ${HttpIp.PORT + uri}  ` + result)
      resp.data = resData.data
      resp.code = resData.code
      resp.msg = resData.msg
    } else {
      resp.msg = `response code : ${value.responseCode}`
      resp.code = value.responseCode
    }
    return resp
  }).catch((e: Error) => {
    LogUtil.d("NetLog", e.message)
    return resp
  })
}

export function post(uri: String, params: Object): Promise<BaseResp> {
  let request = http.createHttp().request(HttpIp.PORT + uri, {
    method: http.RequestMethod.POST,
    extraData: params,
    header: {
      "clientType": "android",
      "version": "1.0",
      "Content-Type": "application/json",
      "Authorization": globalThis.token??""
    },
    readTimeout: 15000,
    connectTimeout: 15000
  })
  let resp = new BaseResp()
  return request.then((value: http.HttpResponse) => {
    if (value.responseCode == 200) {
      let result = `${value.result}`
      let netResp: BaseResp = JSON.parse(result)
      resp.code = netResp.code
      resp.msg = netResp.msg
      resp.data = netResp.data
      LogUtil.d("NetLog", `post 请求路由  ${uri}  ` + result)
      if (resp.code == 401) { //清除所有用户登陆凭证相关的缓存
        globalThis.token = null
        globalThis.uid = null
        PreferenceModel.deleteKey('token')
        PreferenceModel.deleteKey('user')
      }
    } else {
      resp.code = value.responseCode
      resp.msg = ''
    }
    return resp
  }).catch((err: Error) => {
    resp.msg = err.message
    return resp
  })
}
