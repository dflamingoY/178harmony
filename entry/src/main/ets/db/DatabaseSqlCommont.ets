import { TableInfo } from './TableInfo'

export default class SqlConstant {
  static readonly FRIEND_TABLE: TableInfo = {
    tableName: "friend",
    sqlCreate: 'CREATE TABLE IF NOT EXISTS friend(id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    'uid INTEGER unique, ' +
    'phone TEXT,' +
    'username TEXT,' +
    'nickname TEXT,' +
    'avatar TEXT,' +
    'sign TEXT,' +
    'state TEXT,' +
    'member_id TEXT,' +
    'role INTEGER,' +
    'last_login_time INTEGER,' +
    ' remark TEXT)',
    columns: ['id', 'uid', 'phone', 'username', 'nickname', 'avatar', 'sign', 'state', 'member_id', 'role', 'last_login_time', 'remark']
  }

  static readonly MSG_TABLE: TableInfo = {
    tableName: 'msg',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS msg(id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    'mid TEXT ,' +
    'from_name_ios TEXT,' +
    'content TEXT,' +
    'from TEXT,' +
    'sub_type TEXT,' +
    'timestamp INTEGER,' +
    'msgStatus INTEGER,' +
    'content_type TEXT,' +
    'type TEXT,' +
    'remark TEXT,' +
    'from_avatar TEXT,' +
    'from_name TEXT,' +
    'to TEXT,' +
    'isRead INTEGER,' +
    'quote TEXT,' +
    'to_avatar TEXT,' +
    'to_name TEXT,' +
    'from_name_remark TEXT,' +
    'sendId TEXT,' +
    'verifyStatus TEXT,' +
    'key TEXT,' +
    'role INTEGER)',
    columns: ['id', 'mid', 'from_name_ios', 'content',
      'from', 'sub_type', 'timestamp', 'msgStatus', 'content_type',
      'type', 'remark', 'from_avatar', 'from_name', 'to',
      'isRead', 'quote', 'to_avatar', 'to_name', 'from_name_remark', 'sendId', 'verifyStatus', 'key', 'role']
  }

  static readonly RECENT_TABLE: TableInfo = {
    tableName: 'recent',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS recent(id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    'avatar TEXT,' +
    'content TEXT,' +
    'from TEXT,' +
    'sub_type TEXT,' +
    'timestamp INTEGER,' +
    'content_type TEXT,' +
    'unread_count INTEGER,' +
    'type TEXT,' +
    'name TEXT,' +
    'chatId TEXT,' +
    'remark TEXT,' +
    'is_top INTEGER,' +
    'is_disturb INTEGER,' +
    'mid TEXT,' +
    'topTime INTEGER,' +
    'isRemind INTEGER,' +
    'draft TEXT,' +
    'isOnline INTEGER,' +
    'fromUserName TEXT,' +
    'isReadAudio TEXT,' +
    'readMid TEXT,' +
    'updateTime INTEGER,' +
    'role INTEGER)',
    columns: ['id', 'avatar', 'content', 'from', 'sub_type', 'timestamp', 'content_type', 'unread_count', 'type',
      'name', 'chatId', 'remark', 'is_top', 'is_disturb', 'mid', 'topTime', 'isRemind', 'draft',
      'isOnline', 'fromUserName', 'fromUserName', 'isReadAudio', 'readMid', 'updateTime', 'role'
    ]
  }
}