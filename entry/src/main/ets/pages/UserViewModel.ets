import emitter from '@ohos.events.emitter'
import { BaseResp } from '../data/Data'
import { FriendKeyData } from '../data/FriendKeyData'
import { GroupBean, GroupDetails } from '../data/GroupData'
import { MatchSearchData } from '../data/MatchData'
import { MsgBean, RecentBean } from '../data/MsgBean'
import { OffLineData } from '../data/OffLineData'
import { UserBean } from '../data/user'
import Dao from '../db/Dao'
import { getData, post } from '../net/HttpUtils'
import SocketTask from '../net/SocketTask'
import IConstant from '../utils/IConstant'
import LogUtil from '../utils/LogUtil'

class UserViewModel {
  private localMid: Array<string> = []

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

  getLocalMid() {
    Dao.getRdbModel().getAllMid().then((value) => {
      this.localMid.concat(value)
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

  async getGroupSaveCached() {
    await getData('lists_group').then((resp: BaseResp) => {
      if (resp.code == 200) {
        try {
          let groups: Array<GroupBean> = resp.data as Array<GroupBean>
          let allWsIds = groups?.map((item) => {
            return `${IConstant.GROUP_WS_PREFIX}${item.gid}`
          })
          emitter.emit({ eventId: IConstant.WS_GROUP_ID, priority: emitter.EventPriority.IMMEDIATE }, { data: {
            "data": allWsIds.join(','),
            'type': 'init'
          } })
        } catch (e) {
        }
      }
    })
  }

  private isLoading = false

  async getOffline() {
    if (this.isLoading) {
      return
    }
    this.isLoading = true
    await getData("get_off_line_msg").then((resp: BaseResp) => {
      if (resp.code == 200) {
        let result: OffLineData = JSON.parse(JSON.stringify(resp.data))
        //数据库存储
        if (result.msg != null) {
          result.msg = result.msg.filter((item) => {
            return item.mid ! in this.localMid
          })
          this.localMid.concat(result.msg.map((item) => {
            return item.mid
          }))
        }
        Dao.getRdbModel()?.insertMsgs(result)
        //发送已收回执
        let mids = result.msg?.map((item) => {
          return item.mid
        })
        if (mids && mids != null) {
          SocketTask.receiptMsg(JSON.stringify(mids))
        }
      }
      this.isLoading = false
    }).catch((e: Error) => {
      this.isLoading = false
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
  async sendMsg(msgBean: MsgBean) {
    let msg = {
      "to": msgBean.to,
      'type': msgBean.type == IConstant.GROUP ? '2' : '1',
      'content_type': msgBean.content_type,
      'content': msgBean.content,
      'remark': msgBean.remark??'',
      'verify': msgBean.sendId
    }
    await  post("send", msg).then((value) => {
      if (value.code == 200) {
        let result: MsgBean = value.data as MsgBean
        //更新本地mid 和发送状态
        msgBean.mid = result.mid
        msgBean.msgStatus = 0
        Dao.getRdbModel()
          .executeSql(`UPDATE msg SET msgStatus = 0,mid = '${result.mid}' WHERE sendId = '${msgBean.sendId}' `)
        this.sendEmitEvent(IConstant.MSG_OPERATOR_ID, {
          'msgStatus': 0,
          'mid': `${result.mid}`,
          'type': 'send',
          'sendId': msgBean.sendId
        })
      } else {
        msgBean.msgStatus = 2
        Dao.getRdbModel().executeSql(`UPDATE msg SET msgStatus = 2 WHERE sendId = '${msgBean.sendId}' `)
        this.sendEmitEvent(IConstant.MSG_OPERATOR_ID, {
          'msgStatus': 2,
          'type': 'send',
          'sendId': msgBean.sendId
        })
      }
    }).catch(() => {
      msgBean.msgStatus = 2
      Dao.getRdbModel().executeSql(`UPDATE msg SET msgStatus = 2 WHERE sendId = '${msgBean.sendId}' `)
      this.sendEmitEvent(IConstant.MSG_OPERATOR_ID, {
        'msgStatus': 2,
        'type': 'send',
        'sendId': msgBean.sendId
      })
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

  feedback(data: {}): Promise<any> {
    return new Promise((resolve: Function, reject: Function) => {
      post("feedback", data).then((value) => {
        if (value.code == 200) {
          resolve(value.msg)
        } else {
          reject(value.msg)
        }
      }).catch((err) => {
        reject(err.message)
      })
    })
  }

  /*
  消息撤回
   */
  async revoke(mid: string, type: string, to: string) {
    post('revoke', { 'mid': mid, 'type': type, 'to': to }).then((value) => {
      if (value.code == 200) { //更新聊天框ui
        Dao.getRdbModel().revoke(mid)
        this.sendEmitEvent(IConstant.MSG_OPERATOR_ID, {
          "mid": mid,
          'type': 'revoke',
          'id': to
        })
      }
    })
  }

  /*
   * 发送已读回执
   */
  async sendReadReceipt(to: string, mid: string) {
    await  post('read_msg', { 'uid': to, 'mid': mid }).then(() => {

    })
  }

  private sendEmitEvent(id: number, data: {}) {
    emitter.emit({ eventId: id }, {
      data: data
    })
  }
}

export default new UserViewModel()