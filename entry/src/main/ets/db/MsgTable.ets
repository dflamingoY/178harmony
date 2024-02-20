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

  }

  deleteFromMid() {

  }

  getByMid(mid: string) {
    this.msgTable.querySql(`selecte * from ${SqlConstant.MSG_TABLE.tableName} where mid = ${mid}`).then((value) => {
      let count = value.rowCount
      LogUtil.d("Dao", `查询到的数据量${count}`)
    })
  }

  getChatListByKey(key: string): Promise<Array<MsgBean>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let sql = `select * from ${SqlConstant.MSG_TABLE.tableName} where key = ${key}`
      this.msgTable.querySql(sql).then((value) => {
        let count = value.rowCount
        LogUtil.d("Dao", `查询到的数据量${count}`)
        if (count == 0) {
          reject('empty')
        } else {
          value.goToFirstRow()
          const result: MsgBean[] = []
          for (let index = 0; index < count; index++) {
            let msg = new MsgBean()
            msg.from_name_ios = value.getString(value.getColumnIndex('from_name_ios'))
            msg.key = value.getString(value.getColumnIndex('key'))
            msg.mid = value.getString(value.getColumnIndex('mid'))
            msg.from = value.getString(value.getColumnIndex('from'))
            msg.sub_type = value.getString(value.getColumnIndex('sub_type'))
            msg.content_type = value.getString(value.getColumnIndex('content_type'))
            msg.type = value.getString(value.getColumnIndex('type'))
            msg.remark = value.getString(value.getColumnIndex('remark'))
            msg.from_avatar = value.getString(value.getColumnIndex('from_avatar'))
            msg.from_name = value.getString(value.getColumnIndex('from_name'))
            msg.to = value.getString(value.getColumnIndex('to'))
            msg.quote = value.getString(value.getColumnIndex('quote'))
            msg.to_avatar = value.getString(value.getColumnIndex('to_avatar'))
            msg.to_name = value.getString(value.getColumnIndex('to_name'))
            msg.groupName = value.getString(value.getColumnIndex('groupName'))
            msg.from_name_remark = value.getString(value.getColumnIndex('from_name_remark'))
            msg.sendId = value.getString(value.getColumnIndex('sendId'))
            msg.verifyStatus = value.getString(value.getColumnIndex('verifyStatus'))
            msg.role = value.getLong(value.getColumnIndex('role'))
            msg.timestamp = value.getLong(value.getColumnIndex('timestamp'))
            msg.msgStatus = value.getLong(value.getColumnIndex('msgStatus'))
            msg.unread_count = value.getLong(value.getColumnIndex('unread_count'))
            msg.identity = value.getLong(value.getColumnIndex('identity'))
            msg.content = value.getString(value.getColumnIndex('content'))
            msg.isRead = value.getLong(value.getColumnIndex('isRead'))
            result.push(msg)
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
  bucket.mid = item.mid
  bucket.from_name_ios = item.from_name_ios
  bucket.content = item.content
  bucket.from = item.from
  bucket.sub_type = item.sub_type
  bucket.timestamp = item.timestamp
  bucket.msgStatus = item.msgStatus
  bucket.content_type = item.content_type
  bucket.type = item.type
  bucket.remark = item.remark
  bucket.from_avatar = item.from_avatar
  bucket.from_name = item.from_name
  bucket.to = item.to
  bucket.isRead = item.isRead
  bucket.quote = item.quote
  bucket.to_avatar = item.to_avatar
  bucket.to_name = item.to_name
  bucket.from_name_remark = item.from_name_remark
  bucket.sendId = item.sendId
  bucket.verifyStatus = item.verifyStatus
  if (item.type == IConstant.FRIEND && item.from != globalThis.uid) {
    bucket.key = IConstant.FRIEND + item.from
  } else {
    bucket.key = IConstant.GROUP + item.to
  }
  bucket.role = item.role
  return bucket
}
