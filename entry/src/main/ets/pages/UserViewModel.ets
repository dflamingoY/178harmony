import emitter from '@ohos.events.emitter'
import { BaseResp } from '../data/Data'
import { FriendKeyData } from '../data/FriendKeyData'
import { GroupBean, GroupDetailsData } from '../data/GroupData'
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
      this.localMid = this.localMid.concat(value)
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
    LogUtil.d("West", '开始请求离线消息')
    this.isLoading = true
    await getData("get_off_line_msg").then((resp: BaseResp) => {
      if (resp.code == 200) {
        let result: OffLineData = JSON.parse(JSON.stringify(resp.data))
        //发送已收回执
        let mids = result.msg?.map((item) => {
          return item.mid
        })??[]
        //群删除消息id
        let group_del_msg = result.group_del_msg?.map((item) => {
          return item.mid
        })??[]
        let revoke = result.revoke?.map((item) => {
          return item.mid
        })
        if (result.msg != null) {
          result.msg = result.msg.filter((item) => {
            return this.localMid.indexOf(item.mid.toString()) < 0 && group_del_msg.indexOf(item.mid.toString())
          })
          this.localMid = this.localMid.concat(mids)
        }
        //清除已读mid记录
        Dao.getRdbModel()?.insertMsgs(result)
        if (mids && mids != null && mids.length > 0) {
          SocketTask.receiptMsg(JSON.stringify(mids))
        }
        if (group_del_msg && group_del_msg != null && group_del_msg.length > 0) {
          //删除最近删除列表
          let deleteMsgSql = `DELETE FROM msg WHERE mid in ${group_del_msg}`
          Dao.getRdbModel().executeSql(deleteMsgSql)
          SocketTask.receiptMsg(JSON.stringify(group_del_msg))
        }
        if (revoke && revoke != null) {
          SocketTask.receiptMsg(JSON.stringify(revoke))
        }
      }
      this.isLoading = false
    }).catch(() => {
      this.isLoading = false
    })
  }

  getUnreadCount() {
    return Dao.getRdbModel().getUnreadCount()
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

  getGroupInfo(gid: string): Promise<GroupDetailsData> {
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
    post('send_room', { 'to': roomId, 'content': content, 'content_type': 'text' }).then(() => {

    }).catch(() => {

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

  /*
  保存本地产生的mid到集合，判断是否存在本地
   */
  updateMids(mid: string[]) {
    this.localMid.push(...mid)
  }

  updateMid(mid: string) {
    this.localMid.push(mid)
  }

  inertVerifyMsg(msg: MsgBean) {
    if (!this.localMid.some((item) => {
      return item == msg.mid || item == msg.verify
    })) {
      Dao.getRdbModel().insertMsg(msg)
    }
  }

  async updateRecent(recent: RecentBean) {
    Dao.getRdbModel()?.updateRecent(recent)
  }

  insertRecent(recent: RecentBean) {
    Dao.getRdbModel()?.insertRecent(recent)
  }

  async deleteRecent(listId: string) {
    //删除最近聊天
    Dao.getRdbModel()?.deleteRecent(listId)
    //删除聊天记录
    Dao.getRdbModel()?.deleteChatHistory(listId)
  }

  getMsgByMid(mid: string) {
    return Dao.getRdbModel()?.queryMsgByMid(mid)
  }

  getLocalUserById(uid:string){
    return Dao.getRdbModel()?.queryFriend(uid)
  }



}

export default new UserViewModel()