import { UserBean } from '../data/user'
import FriendTable from '../db/FriendTable'

class RdbModel {
  private friendTable = new FriendTable(() => {
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
    return new Promise(async (resolve: Function, reject: Function) => {
      this.friendTable.getAll()
    })
  }
}

export default new RdbModel()


