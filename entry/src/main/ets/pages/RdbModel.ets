import { MsgBean } from '../data/MsgBean'
import { UserBean } from '../data/user'
import FriendTable from '../db/FriendTable'
import MsgTable from '../db/MsgTable'

class RdbModel {
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
    this.msgTable.insertTx(msg, () => {

    })
  }

  getMsgByChatId(key: string, offset: number): Promise<Array<MsgBean>> {
    return this.msgTable.getChatListByKey(key)
  }
}

export default new RdbModel()


