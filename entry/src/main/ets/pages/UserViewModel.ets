import { BaseResp } from '../data/Data'
import { FriendKeyData } from '../data/FriendKeyData'
import { GroupBean } from '../data/GroupData'
import { OffLineData } from '../data/OffLineData'
import { UserBean } from '../data/user'
import { getData } from '../net/HttpUtils'
import LogUtil from '../utils/LogUtil'
import RdbModel from './RdbModel'

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

  getLocalFriend(): Promise<Array<UserBean>> {
    return RdbModel.getAllFriend()
  }

  getFriendList(): Promise<Array<UserBean>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      getData('get_friend_list').then((resp: BaseResp) => {
        if (resp.code == 200) {
          let res = resp.data as FriendKeyData
          let arr = Array<UserBean>()
          res.data_key.forEach((key: string) => {
            let letter: Array<UserBean> = res.data[key]
            letter.forEach((item: UserBean) => {
              arr.push(item)
            })
          })
          RdbModel.insertFriends(arr)
          resolve(arr)
        } else {
          reject(resp.msg)
        }
      }).catch((err: Error) => {
        reject(err)
      })
    })
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
        let result: OffLineData = JSON.parse(`${resp.data}`)
        //数据库存储
        if (result.msg != null) {
          RdbModel.insertMsgs(result.msg)
        }
      }
    }).catch((e: Error) => {
      LogUtil.d("West", `getOffline ${e.message}`)
    })
  }

  getFriend(uid: string): Promise<UserBean> {
    return new Promise(async (resolve: Function, reject: Function) => {
      getData('get_friend_info/' + uid).then((resp: BaseResp) => {
        if (resp.code == 200) {
          resolve(resp.data)
        } else {
          reject(resp.msg)
        }
      }).catch((err: Error) => {
        reject(err.message)
      })
    })
  }

  getGroupInfo(gid: string): Promise<GroupBean> {
    return new Promise(async (resolve: Function, reject: Function) => {
      getData('detail_group/' + gid).then((resp: BaseResp) => {
        if (resp.code == 200) {
          resolve(resp.data)
        } else {
          reject(resp.msg)
        }
      }).catch((err: Error) => {
        reject(err.message)
      })
    })
  }
}

export default new UserViewModel()