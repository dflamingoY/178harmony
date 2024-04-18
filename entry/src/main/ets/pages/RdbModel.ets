import { MsgBean, RecentBean } from '../data/MsgBean'
import { OffLineData } from '../data/OffLineData'
import { UserBean } from '../data/user'
import FriendTable from '../db/FriendTable'
import MsgTable from '../db/MsgTable'
import RecentTable from '../db/RecentTable'
import IConstant from '../utils/IConstant'
import LogUtil from '../utils/LogUtil'

export class RdbModel {
  private friendTable = new FriendTable(() => {

  })
  private msgTable = new MsgTable(() => {

  })
  private recentTable = new RecentTable(() => {
  })

  insertFriends(user?: UserBean[]) {
    if (user == null) return
    new Promise(() => {
      this.friendTable.deleteAll()
      this.friendTable.insertTx(user, () => {
      })
    })
  }

  getAllFriend(): Promise<Array<UserBean>> {
    return this.friendTable.getAll()
  }

  async insertMsgs(offline: OffLineData) {
    if (offline.msg != null) {
      let revokes = offline.revoke?.map((item) => {
        return item.mid
      })
      offline.msg.forEach((item) => {
        if (item.type == IConstant.FRIEND && item.from != globalThis.uid) {
          item.listId = IConstant.FRIEND + item.from
        } else {
          item.listId = IConstant.GROUP + item.to
        }
        if (revokes && revokes != null && item.mid in revokes) {
          item.content = `${$r('app.string.revoke_msg')}`
          item.content_type = 'notice'
        }
      })
      //过滤本地有的mid
      this.msgTable.insertTx(offline.msg, () => {

      })
      //插入数据之后更新最近聊天列表
      let result = offline.msg.map((item) => {
        if (item.type == IConstant.GROUP || item.from == globalThis.uid)
          return item.type + item.to
        else
          return item.type + item.from
      })
      //数组去重
      let set = new Set(result)
      this.recentTable.getNeedUpdateRecentList(Array.from(set))
        .then((recents) => {
          recents.forEach((recent) => { //更新最新内容， 更新最新未读数
            let find = offline.msg.reverse().find((item) => {
              return item.listId == recent.listId
            }) //存在数据进行赋值
            recent.timestamp = find.timestamp
            recent.content = find.content
            recent.content_type = find.content_type
            recent.sub_type = find.sub_type
            recent.chat_type = find.type
            recent.mid = find.mid
            if (find.from == globalThis.uid || find.type == IConstant.GROUP) {
              recent.name = find.to_name
              recent.avatar = find.to_avatar
              recent.chatId = find.to.toString()
            } else {
              recent.name = find.from_name_ios
              recent.avatar = find.from_avatar
              recent.chatId = find.from.toString()
            }
            this.msgTable.getSomeUnread(recent.listId, recent.readMid).then((count) => {
              recent.unread_count = count
            })
            //计算未读熟 加上离线库中的数据
            this.recentTable.update(recent, () => {
            })
            set.delete(recent.listId)
          })
          //没有最近聊天记录的进行赋值
          if (set.size > 0) {
            set.forEach((listId) => {
              let find = offline.msg.filter((item) => {
                return item.listId == listId
              }).pop()
              let recent = new RecentBean()
              recent.listId = find.listId
              recent.content = find.content
              recent.content_type = find.content_type
              recent.sub_type = find.sub_type
              recent.chat_type = find.type
              recent.timestamp = find.timestamp
              recent.mid = find.mid
              if (find.from == globalThis.uid || find.type == IConstant.GROUP) {
                recent.name = find.to_name
                recent.avatar = find.to_avatar
                recent.chatId = find.to
              } else {
                recent.name = find.from_name_ios
                recent.avatar = find.from_avatar
                recent.chatId = find.from
              }
              recent.unread_count = 1
              if (find.content_type == "voice" && find.from != globalThis.uid) {
                recent.isReadAudio = 1
              }
              this.recentTable.insert(recent, () => {
              })
            })
          }
        })
        .catch((err) => {
          LogUtil.d("Dao", 'RdbModel 异常 : ' + err)
        })
    }
  }

  getMsgByChatId(key: string, id: number): Promise<Array<MsgBean>> {
    return this.msgTable.getChatListByKey(key, id)
  }

  async insertMsg(msg: MsgBean) {
    this.msgTable.insert(msg, () => {
    })
  }

  queryMsgByMid(mid: string) {
    return this.msgTable.queryBySendId(mid)
  }

  async updateMsg(msg: MsgBean) {
    this.msgTable.update(msg, () => {
    })
  }

  getRecentList() {
    return this.recentTable.getAll()
  }

  /*
   * 执行sql语句
   */
  async executeSql(sql: string) {
    this.msgTable.executeSql(sql)
  }

  async revoke(mid: string) {
    this.msgTable.executeSql(`UPDATE msg SET content = '此消息已撤回' , content_type = 'notice' WHERE mid = ${mid} `)
  }

  async updateMsgSendToFail() {
    this.msgTable.executeSql(`UPDATE msg SET msgStatus = 2 WHERE msgStatus = 1 `)
  }

  async insertMsgList(arr: Array<MsgBean>) {
    this.msgTable.insertTx(arr, () => {
    })
  }

  getRecentMsg(listId: string, endId: number) {
    return this.msgTable.getRecentList(listId, endId)
  }

  getAllMid() {
    return this.msgTable.queryAllMid()
  }

  async deleteMsgByMid(mid: string) {
    this.msgTable.deleteFromMid(mid)
  }

  updateRecent(recent: RecentBean) {
    this.recentTable.update(recent, () => {
    })
  }

  async insertRecent(recent: RecentBean) {
    this.recentTable.insert(recent, () => {
    })
  }
}

