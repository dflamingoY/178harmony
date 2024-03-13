//好友数据库
import relationalStore from '@ohos.data.relationalStore'
import { UserBean } from '../data/user'
import LogUtil from '../utils/LogUtil'
import SqlConstant from './DatabaseSqlCommont'
import Rdb from './Rdb'

export default class FriendTable {
  private friendTab = new Rdb(SqlConstant.FRIEND_TABLE.tableName, SqlConstant.FRIEND_TABLE.sqlCreate, SqlConstant.FRIEND_TABLE.columns)

  constructor(callback: Function = () => {
  }) {
    this.friendTab.getRdbStore(callback);
  }

  insertTx(user: UserBean[], callback: Function) {
    this.friendTab.insertDataTx(generatorBucketTx(user), callback)
  }

  insert(user: UserBean, callback: Function) {
    this.friendTab.insertData(generatorBucket(user), callback)
  }

  query(uid: string, isAll: boolean = true) {
    let predicates = new relationalStore.RdbPredicates(SqlConstant.FRIEND_TABLE.tableName)
    if (isAll) {
      predicates.equalTo('uid', uid)
    }
    this.friendTab.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count = resultSet.rowCount
      LogUtil.d("Dao", `查询到的数据量${count}`)
    })
  }

  getAll(): Promise<Array<UserBean>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let predicates = new relationalStore.RdbPredicates(SqlConstant.FRIEND_TABLE.tableName)
      this.friendTab.queryAsync(predicates).then((value) => {
        let count = value.rowCount
        if (count == 0) {
          reject("empty")
        } else {
          value.goToFirstRow()
          const result: UserBean[] = []
          for (let index = 0; index < count; index++) {
            var user = new UserBean()
            user.uid = value.getString(value.getColumnIndex('uid'))
            user.phone = value.getString(value.getColumnIndex('phone'))
            user.username = value.getString(value.getColumnIndex('username'))
            user.nickname = value.getString(value.getColumnIndex('nickname'))
            user.avatar = value.getString(value.getColumnIndex('avatar'))
            user.sign = value.getString(value.getColumnIndex('sign'))
            user.state = value.getString(value.getColumnIndex('state'))
            user.member_id = value.getString(value.getColumnIndex('member_id'))
            user.role = value.getLong(value.getColumnIndex('role'))
            user.last_login_time = value.getLong(value.getColumnIndex('last_login_time'))
            user.remark = value.getString(value.getColumnIndex('remark'))
            result.push(user)
            value.goToNextRow()
          }
          resolve(result)
        }
      }).catch((err:Error)=>{
        LogUtil.d("Dao", `查询出错：${err}`)
      })
    })
  }

  delete() {

  }

  deleteAll(callback?: Function) {
    let predicates = new relationalStore.RdbPredicates(SqlConstant.FRIEND_TABLE.tableName)
    this.friendTab.deleteData(predicates, callback)
  }
}

function generatorBucketTx(user: UserBean[]): relationalStore.ValuesBucket[] {
  let array: relationalStore.ValuesBucket[] = []
  user.forEach((item: UserBean) => {
    array.push(generatorBucket(item))
  })
  return array
}

function generatorBucket(item: UserBean): relationalStore.ValuesBucket {
  let bucket: relationalStore.ValuesBucket = {}
  bucket.uid = item.uid
  bucket.phone = item.phone
  bucket.username = item.username
  bucket.nickname = item.nickname
  bucket.avatar = item.avatar
  bucket.sign = item.sign
  bucket.state = item.state
  bucket.member_id = item.member_id??""
  bucket.role = item.role??0
  bucket.last_login_time = item.last_login_time??0
  bucket.remark = item.remark
  return bucket
}
