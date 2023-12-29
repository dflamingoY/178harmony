import http from '@ohos.net.http'
import { BaseResp } from '../data/Data'

export function getData(uri: string): Promise<BaseResp> {
  let token = AppStorage.Link('token')
  let request = http.createHttp().request(PORT + uri, {
    method: http.RequestMethod.GET,
    header: {
      "clientType": "android",
      "version": "1.0",
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": token??""
    },
    readTimeout: 15000,
    connectTimeout: 15000
  })
  let resp = new BaseResp()
  return request.then((value: http.HttpResponse) => {
    if (value.responseCode == 200) {
      let result = `${value.result}`
      let resData: BaseResp = JSON.parse(result)
      resp.data = resData.data
      resp.code = resData.code
      resp.msg = resData.msg
    } else {
      resp.msg = `response code : ${value.responseCode}`
      resp.code = value.responseCode
    }
    return resp
  }).catch(() => {
    return resp
  })
}

export function post(uri: String, params: Object): Promise<BaseResp> {
  let token = AppStorage.Link('token')
  let request = http.createHttp().request(PORT + uri, {
    method: http.RequestMethod.POST,
    extraData: params,
    header: {
      "clientType": "android",
      "version": "1.0",
      "Content-Type": "application/json",
      "Authorization": token??""
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

const PORT = "https://dev-api.gqj.live/v2/"