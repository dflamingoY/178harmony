export default class IConstant {
  static readonly SP_NAME = "gqj"
  static readonly db_name = "gqj.db"
  static readonly FRIEND = "friend"
  static readonly GROUP = "group"
  //eventId
  static readonly EVENT_ID_MATCH = 1
  static readonly LOGIN_EVENT_ID = 2 //登陆发送通知的eventId
  static readonly MATCH_PARENT = '100%'
  static readonly ROOM_WS_ID = 3;
  static readonly ROOM_MSG_ID = 4;
  static readonly APP_IN_FOREGROUND = 5; //应用前后台切换

  //内存变量名
  static readonly FILTER_ROOM_SYSTEM="filter_room_system";
  static readonly PHONE_CACHED="phone_cached";
}