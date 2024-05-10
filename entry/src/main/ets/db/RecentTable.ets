import relationalStore from '@ohos.data.relationalStore';
import { RecentBean } from '../data/MsgBean';
import LogUtil from '../utils/LogUtil';
import SqlConstant from './DatabaseSqlCommont';
import Rdb from './Rdb';

export default class RecentTable {
  private recent = new Rdb(SqlConstant.RECENT_TABLE.tableName, SqlConstant.RECENT_TABLE.sqlCreate, SqlConstant.RECENT_TABLE.columns)

  constructor(callback: Function = () => {
  }) {
    this.recent.getRdbStore(callback);
  }

  insertTx(msg: RecentBean[], callback: Function) {
    this.recent.insertDataTx(generatorBucketTx(msg), callback)
  }

  insert(msg: RecentBean, callback: Function) {
    this.recent.insertData(generatorBucket(msg), callback)
  }

  deleteAll(callback?: Function) {
    let predicates = new relationalStore.RdbPredicates(SqlConstant.RECENT_TABLE.tableName)
    this.recent.deleteData(predicates, callback)
  }

  deleteRecent(listId: string) {
    this.recent.executeSql(`delete from recent where listId = ${listId}`)
  }

  async update(recentBean: RecentBean, callback: Function) {
    let predicates = new relationalStore.RdbPredicates(SqlConstant.RECENT_TABLE.tableName)
    predicates.equalTo('listId', recentBean.listId)
    let data = generatorBucket(recentBean)
    this.recent.updateData(predicates, data, callback)
  }

  //获取需要更新的最新聊天列表
  getNeedUpdateRecentList(array: Array<string>): Promise<Array<RecentBean>> {
    return new Promise((resolve: Function, reject: Function) => {
      let predicates = new relationalStore.RdbPredicates(SqlConstant.RECENT_TABLE.tableName)
      predicates.in('listId', array)
      this.recent.queryAsync(predicates)?.then((value) => {
        let count = value.rowCount
        const result: RecentBean[] = []
        if (count > 0) {
          value.goToFirstRow()
          for (let index = 0; index < count; index++) {
            let recent = this.parseRecentByResultSet(value)
            result.push(recent)
            value.goToNextRow()
          }
        }
        resolve(result)
        value.close()
      })?.catch(() => {
        reject("empty")
      })
    })
  }

  getAll(): Promise<Array<RecentBean>> {
    return new Promise((resolve: Function, reject: Function) => {
      let predicates = new relationalStore.RdbPredicates(SqlConstant.RECENT_TABLE.tableName)
      predicates.orderByDesc('timestamp')
      this.recent.queryAsync(predicates)?.then((value) => {
        let count = value.rowCount
        if (count == 0) {
          reject('empty')
        } else {
          const result: RecentBean[] = []
          value.goToFirstRow()
          for (let index = 0; index < count; index++) {
            let recent = this.parseRecentByResultSet(value)
            result.push(recent)
            value.goToNextRow()
          }
          //数据排序 置顶在前面
          result.sort((a, b) => {
            if (a.is_top === 1 && b.is_top === 1) {
              return b.timestamp - a.timestamp
            } else if (a.is_top === 1 || b.is_top === 1) {
              if (a.is_top === 1) {
                return -1
              } else {
                return 1
              }
            } else {
              return b.timestamp - a.timestamp
            }
          })
          resolve(result)
        }
        value.close()
      })?.catch((err: Error) => {
        reject(err.message)
      })
    })
  }

  getUnread(): Promise<number> {
    return new Promise((resolve: Function) => {
      let predicates = new relationalStore.RdbPredicates(SqlConstant.RECENT_TABLE.tableName)
      predicates.greaterThan('unread_count', 0)
      this.recent.querySome(predicates, ['unread_count']).then((value) => {
        let rowCount = value.rowCount
        var allCount = 0
        if (rowCount > 0) {
          value.goToFirstRow()
          for (let index = 0; index < rowCount; index++) {
            try {
              allCount += value.getLong(value.getColumnIndex('unread_count'))
            } catch (e) {
            }
          }
        }
        resolve(allCount)
      }).catch(() => {
        resolve(0)
      })
    })
  }

  private parseRecentByResultSet(value: relationalStore.ResultSet): RecentBean {
    let recent = new RecentBean()
    recent.avatar = value.getString(value.getColumnIndex('avatar'))
    recent.content = value.getString(value.getColumnIndex('content'))
    recent.id_from = value.getString(value.getColumnIndex('id_from'))
    recent.sub_type = value.getString(value.getColumnIndex('sub_type'))
    recent.timestamp = value.getLong(value.getColumnIndex('timestamp'))
    recent.content_type = value.getString(value.getColumnIndex('content_type'))
    recent.unread_count = value.getLong(value.getColumnIndex('unread_count'))
    recent.chat_type = value.getString(value.getColumnIndex('chat_type'))
    recent.name = value.getString(value.getColumnIndex('name'))
    recent.chatId = value.getString(value.getColumnIndex('chatId'))
    recent.remark = value.getString(value.getColumnIndex('remark'))
    recent.is_top = value.getLong(value.getColumnIndex('is_top'))
    recent.is_disturb = value.getLong(value.getColumnIndex('is_disturb'))
    recent.mid = value.getString(value.getColumnIndex('mid'))
    recent.topTime = value.getLong(value.getColumnIndex('topTime'))
    recent.isRemind = value.getLong(value.getColumnIndex('isRemind'))
    recent.draft = value.getString(value.getColumnIndex('draft'))
    recent.isOnline = value.getLong(value.getColumnIndex('isOnline'))
    recent.fromUserName = value.getString(value.getColumnIndex('fromUserName'))
    recent.isReadAudio = value.getLong(value.getColumnIndex('isReadAudio'))
    recent.readMid = value.getLong(value.getColumnIndex('readMid'))
    recent.updateTime = value.getLong(value.getColumnIndex('updateTime'))
    recent.listId = value.getString(value.getColumnIndex('listId'))
    recent.role = value.getLong(value.getColumnIndex('role'))
    return recent
  }
}

function generatorBucketTx(user: RecentBean[]): relationalStore.ValuesBucket[] {
  let array: relationalStore.ValuesBucket[] = []
  user.forEach((item: RecentBean) => {
    array.push(generatorBucket(item))
  })
  return array
}

function generatorBucket(item: RecentBean): relationalStore.ValuesBucket {
  let bucket: relationalStore.ValuesBucket = {}
  bucket.avatar = item.avatar??''
  bucket.content = item.content??''
  bucket.id_from = item.id_from??''
  bucket.sub_type = item.sub_type??''
  bucket.timestamp = item.timestamp??0
  bucket.content_type = item.content_type??''
  bucket.unread_count = item.unread_count??0
  bucket.chat_type = item.chat_type??''
  bucket.name = item.name??''
  bucket.chatId = item.chatId??''
  bucket.remark = item.remark??''
  bucket.is_top = item.is_top??0
  bucket.is_disturb = item.is_disturb??0
  bucket.mid = item.mid??''
  bucket.topTime = item.topTime??0
  bucket.isRemind = item.isRemind??0
  bucket.draft = item.draft??''
  bucket.isOnline == item.isOnline??0
  bucket.fromUserName = item.fromUserName??''
  bucket.isReadAudio = item.isReadAudio??0
  bucket.readMid = item.readMid??0
  bucket.updateTime = item.updateTime??0
  bucket.listId = item.listId??''
  bucket.role = item.role??4
  return bucket
}