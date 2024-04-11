import { BaseResp } from '../data/Data'
import { FriendKeyData } from '../data/FriendKeyData'
import { GroupBean, GroupDetails } from '../data/GroupData'
import { MatchSearchData } from '../data/MatchData'
import { RecentBean } from '../data/MsgBean'
import { OffLineData } from '../data/OffLineData'
import { UserBean } from '../data/user'
import Dao from '../db/Dao'
import { getData, post } from '../net/HttpUtils'
import LogUtil from '../utils/LogUtil'

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
    return Dao.getRdbModel()?.getAllFriend()
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
          Dao.getRdbModel()?.insertFriends(arr)
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
        let result: OffLineData = JSON.parse(JSON.stringify(resp.data))
        //数据库存储
        Dao.getRdbModel()?.insertMsgs(result)
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
          reject(resp.code)
        }
      }).catch((err: Error) => {
        reject(err.message)
      })
    })
  }

  getGroupInfo(gid: string): Promise<GroupDetails> {
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

  getRecentList(): Promise<Array<RecentBean>> {
    return Dao.getRdbModel()?.getRecentList()
  }

  getFriendInfo(uid: string): Promise<UserBean> {
    return new Promise((resolve: Function, reject: Function) => {
      getData(`get_friend_info/${uid}`).then((resp: BaseResp) => {
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

  getFriendApplyList(page: number): Promise<Array<UserBean>> {
    return new Promise((resolve: Function, reject: Function) => {
      getData(`apply_friend_lists?limit=20&page=${page}`).then((resp: BaseResp) => {
        if (resp.code == 200) {
          resolve(resp.data)
        } else {
          reject(resp.code)
        }
      }).catch((err) => {
        reject(err.message)
      })
    })
  }

  /*
  发送消息
   */
  async sendMsg(to: string, type: string, content_type: string, content: string, remark: string, verify: string) {
    let msg = {
      "to": to,
      'type': type,
      'content_type': content_type,
      'content': content,
      'remark': remark,
      'verify': verify
    }
    post("send", msg).then((MsgBean) => {

    }).catch(() => {

    })
  }

  /*
  获取验证码
   */
  getOptCode(phone: string): Promise<any> {
    return new Promise((resolve: Function, reject: Function) => {
      post("send_sms", { "phone": phone }).then((value) => {
        if (value.code == 200) {
          resolve(value.msg)
        } else {
          reject(value.msg)
        }
      }).catch((err: Error) => {
        reject(err.message)
      })
    })
  }

  /*
  重置登陆密码
   */
  resetPwd(phone: string, pwd: string, optCode: string): Promise<any> {
    return new Promise((resolve: Function, reject: Function) => {
      post("reset_password", { "phone": phone, "code": optCode, "password": pwd }).then((value) => {
        if (value.code == 200) {
          resolve(value.msg)
        } else {
          reject(value.msg)
        }
      }).catch((err: Error) => {
        reject(err.message)
      })
    })
  }

  register(phone: string, optCode: string, nickname: string, pwd: string): Promise<any> {
    return new Promise((resolve: Function, reject: Function) => {
      post('register', { "phone": phone, "nickname": nickname, "password": pwd, "code": optCode })
        .then((value) => {
          if (value.code == 200) {
            resolve(value.msg)
          } else {
            reject(value.msg)
          }
        }).catch((err: Error) => {
        reject(err.message)
      })
    })
  }

  searchMatch(key: string): Promise<MatchSearchData> {
    return new Promise((resolve: Function, reject: Function) => {
      getData(`match_search?keyword=${key}`).then((value) => {
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

  async sendRoomMsg(content: string, roomId: string) {
    post('send_room', { 'to': roomId, 'content': content, 'content_type': 'text' }).then((resp) => {

    }).catch((err) => {

    })
  }

  getQrCode(type: number, gid: string): Promise<string> {
    return new Promise((resolve: Function, reject: Function) => {
      post("get_qrcode", { 'type': type, 'gid': gid }).then((result) => {
        if (result.code == 200) {
          resolve(result.data['qr_url'])
        } else {
          reject(result.msg)
        }
      }).catch((err: Error) => {
        reject(err.message)
      })
    })
  }

  updateUserInfo(data: {}): Promise<any> {
    return new Promise((resolve: Function, reject: Function) => {
      post("update_user", data).then(result => {
        if (result.code == 200) {
          resolve(result.data)
        } else {
          reject(result.msg)
        }
      }).catch((err: Error) => {
        reject(err.message)
      })
    })
  }
}

export default new UserViewModel()