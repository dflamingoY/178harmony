import { MsgBean } from '../data/MsgBean'
import { UserBean } from '../data/user'
import FriendTable from '../db/FriendTable'
import MsgTable from '../db/MsgTable'

export class RdbModel {
  private friendTable = new FriendTable(() => {

  })
  private msgTable = new MsgTable(() => {

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

  insertMsgs(msg: MsgBean[]) {
    // msg.forEach((value) => {
    //   this.msgTable.insert(value, () => {
    //   })
    // })
    new Promise(async () => {
      this.msgTable.deleteAll()
      this.msgTable.insertTx(msg, () => {
      })
    })
  }

  getMsgByChatId(key: string, offset: number): Promise<Array<MsgBean>> {
    return this.msgTable.getChatListByKey(key)
  }
}

