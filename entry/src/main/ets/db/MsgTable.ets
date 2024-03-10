import relationalStore from '@ohos.data.relationalStore';
import { MsgBean } from '../data/MsgBean';
import IConstant from '../utils/IConstant';
import LogUtil from '../utils/LogUtil';
import SqlConstant from './DatabaseSqlCommont'
import Rdb from './Rdb'

export default class MsgTable {
  private msgTable = new Rdb(SqlConstant.MSG_TABLE.tableName, SqlConstant.MSG_TABLE.sqlCreate, SqlConstant.MSG_TABLE.columns)

  constructor(callback: Function = () => {
  }) {
    this.msgTable.getRdbStore(callback);
  }

  insertTx(msg: MsgBean[], callback: Function) {
    this.msgTable.insertDataTx(generatorBucketTx(msg), callback)
  }

  insert(msg: MsgBean, callback: Function) {
    this.msgTable.insertData(generatorBucket(msg), callback)
  }

  getAll() {
    let predicates = new relationalStore.RdbPredicates(SqlConstant.MSG_TABLE.tableName)
    this.msgTable.queryAsync(predicates).then((value) => {
      let count = value.rowCount
      LogUtil.d("Dao", `查询到的数据量${count}`)
    })
  }

  getTopByListId(listId: string): Promise<MsgBean> {
    return new Promise((resolve: Function, reject: Function) => {
      let predicates = new relationalStore.RdbPredicates(SqlConstant.MSG_TABLE.tableName)
      predicates.equalTo("listId", listId)
      predicates.limitAs(1)
      this.msgTable.queryAsync(predicates).then((value) => {
        let count = value.rowCount
        if (count == 0) {
          reject("empty")
        } else {
          value.goToFirstRow()
          let msg = this.parseMsgBean(value)
          resolve(msg)
        }
      }).catch(() => {
        reject("empty")
      })
    })
  }

  deleteFromMid() {

  }

  getByMid(mid: string) {
    this.msgTable.querySql(`selecte * from ${SqlConstant.MSG_TABLE.tableName} where mid = ${mid}`).then((value) => {
      let count = value.rowCount
      LogUtil.d("Dao", `查询到的数据量${count}`)
    })
  }

  deleteAll(callback?: Function) {
    let predicates = new relationalStore.RdbPredicates(SqlConstant.MSG_TABLE.tableName)
    this.msgTable.deleteData(predicates, callback)
  }

  parseMsgBean(value: relationalStore.ResultSet): MsgBean {
    let msg = new MsgBean()
    msg.from_name_ios = value.getString(value.getColumnIndex('name_from_ios'))
    msg.listId = value.getString(value.getColumnIndex('listId'))
    msg.mid = value.getString(value.getColumnIndex('mid'))
    msg.from = value.getString(value.getColumnIndex('id_from'))
    msg.sub_type = value.getString(value.getColumnIndex('sub_type'))
    msg.content_type = value.getString(value.getColumnIndex('content_type'))
    msg.type = value.getString(value.getColumnIndex('chat_type'))
    msg.remark = value.getString(value.getColumnIndex('remark'))
    msg.from_avatar = value.getString(value.getColumnIndex('avatar_from'))
    msg.from_name = value.getString(value.getColumnIndex('name_from'))
    msg.to = value.getString(value.getColumnIndex('chat_to'))
    msg.quote = value.getString(value.getColumnIndex('quote'))
    msg.to_avatar = value.getString(value.getColumnIndex('avatar_to'))
    msg.to_name = value.getString(value.getColumnIndex('name_to'))
    msg.from_name_remark = value.getString(value.getColumnIndex('name_from_remark'))
    msg.sendId = value.getString(value.getColumnIndex('sendId'))
    msg.verifyStatus = value.getString(value.getColumnIndex('verifyStatus'))
    msg.timestamp = value.getLong(value.getColumnIndex('timestamp'))
    msg.msgStatus = value.getLong(value.getColumnIndex('msgStatus'))
    msg.content = value.getString(value.getColumnIndex('content'))
    msg.isRead = value.getLong(value.getColumnIndex('isRead'))
    msg.role = value.getLong(value.getColumnIndex('role'))
    return msg
  }

  getChatListByKey(listId: string): Promise<Array<MsgBean>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let predicates = new relationalStore.RdbPredicates(SqlConstant.MSG_TABLE.tableName)
      predicates.equalTo("listId", listId)
      this.msgTable.queryAsync(predicates).then((value) => {
        let count = value.rowCount
        LogUtil.d("Dao", `查询到的数据量${count}`)
        if (count == 0) {
          reject('empty')
        } else {
          value.goToFirstRow()
          const result: MsgBean[] = []
          for (let index = 0; index < count; index++) {
            let msg = this.parseMsgBean(value)
            result.push(msg)
            value.goToNextRow()
          }
          resolve(result)
        }
      }).catch((e: Error) => {
        reject(e.message)
      })
    })
  }
}

function generatorBucketTx(user: MsgBean[]): relationalStore.ValuesBucket[] {
  let array: relationalStore.ValuesBucket[] = []
  user.forEach((item: MsgBean) => {
    array.push(generatorBucket(item))
  })
  return array
}

function generatorBucket(item: MsgBean): relationalStore.ValuesBucket {
  let bucket: relationalStore.ValuesBucket = {}
  bucket.mid = `${item.mid}`
  bucket.name_from_ios = item.from_name_ios??''
  bucket.content = item.content??''
  bucket.id_from = `${item.from}`
  bucket.sub_type = item.sub_type??''
  bucket.timestamp = item.timestamp??0
  bucket.msgStatus = item.msgStatus??0
  bucket.content_type = item.content_type??''
  bucket.chat_type = item.type??''
  bucket.remark = item.remark??''
  bucket.avatar_from = item.from_avatar??''
  bucket.name_from = item.from_name??''
  bucket.chat_to = item.to??''
  bucket.isRead = item.isRead??0
  bucket.quote = item.quote??''
  bucket.avatar_to = item.to_avatar??''
  bucket.name_to = item.to_name??''
  bucket.name_from_remark = item.from_name_remark??''
  bucket.sendId = item.sendId??''
  bucket.verifyStatus = item.verifyStatus??'0'
  if (item.type == IConstant.FRIEND && item.from != globalThis.uid) {
    bucket.listId = IConstant.FRIEND + item.from
  } else {
    bucket.listId = IConstant.GROUP + item.to
  }
  bucket.role = item.role??4
  return bucket
}
