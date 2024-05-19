import { TableInfo } from './TableInfo'

export default class SqlConstant {
  static readonly FRIEND_TABLE: TableInfo = {
    tableName: "friend",
    sqlCreate: 'CREATE TABLE IF NOT EXISTS friend(id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    'uid TEXT unique, ' +
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
    ' mid TEXT ,' +
    ' name_from_ios TEXT,' +
    ' content TEXT,' +
    ' id_from TEXT,' +
    ' sub_type TEXT,' +
    ' timestamp INTEGER,' +
    ' msgStatus INTEGER,' +
    ' content_type TEXT,' +
    ' chat_type TEXT,' +
    ' remark TEXT,' +
    ' avatar_from TEXT,' +
    ' name_from TEXT,' +
    ' chat_to TEXT,' +
    ' isRead INTEGER,' +
    ' quote TEXT,' +
    ' avatar_to TEXT,' +
    ' name_to TEXT,' +
    ' name_from_remark TEXT,' +
    ' sendId TEXT,' +
    ' verifyStatus TEXT,' +
    ' listId TEXT,' +
    ' role INTEGER)',
    columns: ['id', 'mid', 'name_from_ios', 'content',
      'id_from', 'sub_type', 'timestamp', 'msgStatus', 'content_type',
      'chat_type', 'remark', 'avatar_from', 'name_from', 'chat_to',
      'isRead', 'quote', 'avatar_to', 'name_to', 'name_from_remark', 'sendId', 'verifyStatus', 'listId', 'role']
  }
  static readonly RECENT_TABLE: TableInfo = {
    tableName: 'recent',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS recent(id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    'avatar TEXT,' +
    'content TEXT,' +
    'id_from TEXT,' +
    'sub_type TEXT,' +
    'timestamp INTEGER,' +
    'content_type TEXT,' +
    'unread_count INTEGER,' +
    'chat_type TEXT,' + //friend or group
    'name TEXT,' +
    'chatId TEXT,' + //聊天对象id
    'remark TEXT,' +
    'is_top INTEGER,' +
    'is_disturb INTEGER,' +
    'mid TEXT,' +
    'topTime INTEGER,' +
    'isRemind INTEGER,' +
    'draft TEXT,' +
    'isOnline INTEGER,' +
    'fromUserName TEXT,' +
    'isReadAudio INTEGER,' +
    'readMid INTEGER,' +
    'updateTime INTEGER,' +
    'listId TEXT unique,' +
    'role INTEGER)',
    columns: ['id', 'avatar', 'content', 'id_from', 'sub_type', 'timestamp', 'content_type', 'unread_count', 'chat_type',
      'name', 'chatId', 'remark', 'is_top', 'is_disturb', 'mid', 'topTime', 'isRemind', 'draft',
      'isOnline', 'fromUserName', 'fromUserName', 'isReadAudio', 'readMid', 'updateTime', 'listId', 'role'
    ]
  }
}