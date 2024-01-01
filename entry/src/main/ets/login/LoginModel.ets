import deviceInfo from '@ohos.deviceInfo'
import hilog from '@ohos.hilog'
import { BaseResp } from '../data/Data'
import { UserBean } from '../data/user'
import { post } from '../net/HttpUtils'

export class LoginModel {
  login(phone: string, pwd: string): Promise<UserBean> {
    return new Promise(async (resolve: Function, reject: Function) => {
      var device = deviceInfo.serial
      let params = {
        'password': pwd,
        'username': phone,
        'reg_id': 'aksdasdasdkashdakshdash',
        'device_id': device
      }
      post('login', params)
        .then((value: BaseResp) => {
          hilog.debug(0xff0000, "West", `${value.msg}`)
          if (value.code == 200) {
            resolve(value.data)
          } else {
            reject(value.msg)
          }
        }).catch((err: Error) => {
        reject(err.message)
      })
    })
  }
}