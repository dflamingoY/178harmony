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
}