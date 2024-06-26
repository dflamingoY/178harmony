import emitter from '@ohos.events.emitter'
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
  private recentUpdateList: Set<String> = new Set()
  /*
    插入功能
   */
  insertFriends(user?: UserBean[]) {
    if (user == null) return
    new Promise(() => {
      this.friendTable.deleteAll()
      this.friendTable.insertTx(user, () => {
      })
    })
  }
  //插入离线消息
  async insertMsgs(offline: OffLineData) {
    if (offline.msg != null && offline.msg.length > 0) {
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
            this.recentUpdateList.add(recent.listId)
            let find = offline.msg.reverse().find((item) => {
              return item.listId == recent.listId
            }) //存在数据进行赋值
            this.updateRecentOffline(recent, find)
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
                recent.chatId = `${find.to}`
              } else {
                recent.name = find.from_name_ios
                recent.avatar = find.from_avatar
                recent.chatId = `${find.from}`
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
          LogUtil.d("West", 'RdbModel 异常 : ' + err)
        })
    }
  }
  //插入单条消息
  async insertMsg(msg: MsgBean) {
    this.msgTable.insert(msg, () => {
    })
  }

  async insertMsgList(arr: Array<MsgBean>) {
    this.msgTable.insertTx(arr, () => {
    })
  }

  async insertRecent(recent: RecentBean) {
    this.recentTable.insert(recent, () => {
    })
  }


  /*
 查询 获取方法
  */
  getMsgByChatId(key: string, id: number): Promise<Array<MsgBean>> {
    return this.msgTable.getChatListByKey(key, id)
  }

  getAllFriend(): Promise<Array<UserBean>> {
    return this.friendTable.getAll()
  }
  //获取所有图片视频资源
  getResByListId(listId: string): Promise<Array<MsgBean>> {
    return this.msgTable.getResByListId(listId)
  }

  getRecentList() {
    return this.recentTable.getAll()
  }

  getAllMid() {
    return this.msgTable.queryAllMid()
  }

  getRecentMsg(listId: string, endId: number) {
    return this.msgTable.getRecentList(listId, endId)
  }

  getUnreadCount(): Promise<number> {
    return this.recentTable.getUnread()
  }

  //通过mid sendId 查询消息
  queryMsgBySendId(mid: string) {
    return this.msgTable.queryBySendId(mid)
  }

  queryMsgByMid(mid: string) {
    return this.msgTable.queryByMid(mid)
  }

  queryFriend(uid:string){
   return this.friendTable.queryByUid(uid,false)
  }

  //更新方法
  async updateMsg(msg: MsgBean) {
    this.msgTable.update(msg, () => {
    })
  }

  updateRecent(recent: RecentBean) {
    this.recentTable.update(recent, () => {
    })
  }

  async updateMsgSendToFail() {
    this.msgTable.executeSql(`UPDATE msg SET msgStatus = 2 WHERE msgStatus = 1 `)
  }

  private async updateRecentOffline(recent: RecentBean, find: MsgBean) {
    recent.timestamp = find.timestamp
    recent.content = find.content
    recent.content_type = find.content_type
    recent.sub_type = find.sub_type
    recent.chat_type = find.type
    recent.mid = find.mid
    if (find.from == globalThis.uid || find.type == IConstant.GROUP) {
      recent.name = find.to_name
      recent.avatar = find.to_avatar
      recent.chatId = `${find.to}`
    } else {
      recent.name = find.from_name_ios
      recent.avatar = find.from_avatar
      recent.chatId = `${find.from}`
    }
    await this.msgTable.getSomeUnread(recent.listId, recent.readMid).then((count) => {
      recent.unread_count = count
    })
    //计算未读熟 加上离线库中的数据
    this.recentTable.update(recent, () => {
    })
    this.recentUpdateList.delete(recent.listId)
    if (this.recentUpdateList.size == 0) { //通知界面刷新
      emitter.emit({ eventId: IConstant.MSG_OPERATOR_ID }, { data: {
        'type': 'syncLoad'
      } })
    }
  }

  //删除后者清除函数

  async deleteMsgByMid(mid: string) {
    this.msgTable.deleteFromMid(mid)
  }

  async clearChatList() {
    this.msgTable.deleteAll()
    this.recentTable.deleteAll()
  }
  //删除最近聊天的某条记录
  deleteRecent(listId: string) {
    this.recentTable.deleteRecent(listId)
  }
  //删除与某个好友的所有聊天记录
  deleteChatHistory(listId: string) {
    let sql = `DELETE FROM msg WHERE listId = "${listId}"`
    this.msgTable.executeSql(sql)
  }

  // 执行sql语句
  async executeSql(sql: string) {
    this.msgTable.executeSql(sql)
  }
  //更新撤回消息
  async revoke(mid: string) {
    this.msgTable.executeSql(`UPDATE msg SET content = '此消息已撤回' , content_type = 'notice' WHERE mid = ${mid} `)
  }
}

