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

  queryAllMid(): Promise<Array<string>> {
    return new Promise((resolve: Function, reject: Function) => {
      let predicates = new relationalStore.RdbPredicates(SqlConstant.MSG_TABLE.tableName)
      this.msgTable.querySome(predicates, ['mid'])?.then((value) => {
        let count = value.rowCount
        let mids = new Array<string>()
        if (count > 0) {
          value.goToFirstRow()
          for (let index = 0; index < count; index++) {
            try {
              let mid = value.getString(value.getColumnIndex('mid'))
              if (mid && mid != null) {
                mids.push(mid)
              }
            } catch (e) {
            }
            value.goToNextRow()
          }
        }
        resolve(mids)
      }).catch((err) => {
        reject('error')
      })
    })
  }

  insert(msg: MsgBean, callback: Function) {
    this.msgTable.insertData(generatorBucket(msg), callback)
  }

  update(msg: MsgBean, callback: Function) {
    let predicates = new relationalStore.RdbPredicates(SqlConstant.MSG_TABLE.tableName)
    predicates.equalTo('sendId', msg.sendId)
    this.msgTable.updateData(predicates, generatorBucket(msg), callback)
  }

  queryBySendId(sendId: string): Promise<MsgBean> {
    return new Promise((resolve: Function, reject: Function) => {
      let predicates = new relationalStore.RdbPredicates(SqlConstant.MSG_TABLE.tableName)
      predicates.equalTo('sendId', sendId)
      predicates.limitAs(1)
      this.msgTable.queryAsync(predicates)?.then((value) => {
        let count = value.rowCount
        if (count == 0) {
          reject("empty")
        } else {
          value.goToFirstRow()
          let msg = this.parseMsgBean(value)
          resolve(msg)
        }
        value.close()
      })?.catch(() => {
        reject("empty")
      })
    })
  }

  getTopByListId(listId: string): Promise<MsgBean> {
    return new Promise((resolve: Function, reject: Function) => {
      let predicates = new relationalStore.RdbPredicates(SqlConstant.MSG_TABLE.tableName)
      predicates.equalTo("listId", listId)
      predicates.limitAs(1)
      this.msgTable.queryAsync(predicates)?.then((value) => {
        let count = value.rowCount
        if (count == 0) {
          reject("empty")
        } else {
          value.goToFirstRow()
          let msg = this.parseMsgBean(value)
          resolve(msg)
        }
        value.close()
      })?.catch(() => {
        reject("empty")
      })
    })
  }
  /**
   * 执行sql 语句删除或者更新数据
   * @param sql 操作语句
   */
  executeSql(sql: string) {
    this.msgTable.executeSql(sql)
  }

  deleteFromMid(mid: string) {
    this.msgTable.executeSql('DELETE FROM msg WHERE mid = ' + mid)
  }

  deleteAll(callback?: Function) {
    let predicates = new relationalStore.RdbPredicates(SqlConstant.MSG_TABLE.tableName)
    this.msgTable.deleteData(predicates, callback)
  }

  getSomeUnread(listId: string, id: number): Promise<number> {
    return new Promise((resolve: Function, reject: Function) => {
      let predicates = new relationalStore.RdbPredicates(SqlConstant.MSG_TABLE.tableName)
      predicates.equalTo("listId", listId)
        .and()
        .notEqualTo('id_from', globalThis.uid)
        .greaterThan("id", id)
      try {
        this.msgTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
          resolve(resultSet.rowCount)
          resultSet.close()
        })
      } catch (e) {
        reject(0)
      }
    })
  }

  parseMsgBean(value: relationalStore.ResultSet): MsgBean {
    let msg = new MsgBean()
    msg.from_name_ios = value.getString(value.getColumnIndex('name_from_ios'))
    msg.listId = value.getString(value.getColumnIndex('listId'))
    msg.id = value.getLong(value.getColumnIndex('id'))
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

  getChatListByKey(listId: string, limitId: number): Promise<Array<MsgBean>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let predicates = new relationalStore.RdbPredicates(SqlConstant.MSG_TABLE.tableName)
      predicates.equalTo("listId", listId)
      predicates.orderByDesc('id')
      if (limitId != -1) {
        predicates.lessThan('id', limitId)
      }
      predicates.limitAs(20)
      this.msgTable.queryAsync(predicates)?.then((value) => {
        let count = value.rowCount
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
          resolve(result.reverse())
          value.close()
        }
      })?.catch((e: Error) => {
        reject(e.message)
      })
    })
  }

  /**
   * 获取截止 endId 到最新的消息历史记录
   * @param listId
   * @param endId
   * @returns
   */
  getRecentList(listId: string, endId: number): Promise<Array<MsgBean>> {
    return new Promise((resolve: Function, reject: Function) => {
      let predicates = new relationalStore.RdbPredicates(SqlConstant.MSG_TABLE.tableName)
      predicates.equalTo("listId", listId)
      predicates.orderByDesc('id')
      predicates.greaterThan('id', endId)
      this.msgTable.queryAsync(predicates)?.then((value) => {
        let count = value.rowCount
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
          resolve(result.reverse())
        }
      })?.catch((e: Error) => {
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
  // if (item.id != 0) {
  //   bucket.id = item.id
  // }
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
  if (item.type == IConstant.FRIEND) {
    bucket.listId = IConstant.FRIEND + (item.from != globalThis.uid ? item.from : item.to)
  } else {
    bucket.listId = IConstant.GROUP + item.to
  }
  bucket.role = item.role??4
  return bucket
}
