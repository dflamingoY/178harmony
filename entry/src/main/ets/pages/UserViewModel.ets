import { BaseResp } from '../data/Data'
import { GroupBean } from '../data/GroupData'
import { UserBean } from '../data/user'
import { getData } from '../net/HttpUtils'

class UserViewModel {
  getUserInfo(): Promise<UserBean> {
    return new Promise(async (resolve: Function, reject: Function) => {
      getData("get_user").then((resp: BaseResp) => {
        if (resp.code == 200) {
          resolve(resp.data)
        } else {
          reject(resp.msg)
        }
      }).catch((err: Error) => {
        reject(err)
      })
    })
  }

  getFriendList() {

  }

  getGroupList(): Promise<Array<GroupBean>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      getData('lists_group').then((resp: BaseResp) => {
        if (resp.code == 200) {
          resolve(resp.data)
        } else {
          reject(resp.msg)
        }
      }).catch((err: Error) => {
        reject(err)
      })
    })
  }

  async getOffline() {
    getData("get_off_line_msg").then((resp: BaseResp) => {
      if (resp.code == 200) {
     // let result:   JSON.parse(`${resp.data}`)
      }
    })
  }
}

export default new UserViewModel()