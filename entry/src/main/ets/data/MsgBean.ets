export class MsgBean {
  id: number = 0
  from_name_ios: string = '' //用户备注
  listId: string = ''
  mid: string = ''
  from: string = ''
  sub_type: string = ''
  content_type: string = ''
  type: string = ''
  remark: string = ''
  from_avatar: string = ''
  from_name: string = ''
  to: string = ''
  quote: string = ''
  to_avatar: string = ''
  to_name: string = ''
  groupName: string = ''
  from_name_remark: string = '' //用户在群里的备注
  sendId: string = '' //本地创建校验消息唯一
  verifyStatus: string = ''
  role: number = 0
  timestamp: number = 0
  msgStatus: number = 0 //消息发送状态  0 成功 1 发送中 2 失败 客户端定义
  unread_count: number = 0
  identity: number = 0
  content: string = ''
  isRead: number = 0 // 1 已读 0 未读
  isPlay: boolean = false //是否正在播放
  nickname: string = ''
  verify: string = '' //接口返回参数 校验消息唯一
}

export class RecentBean {
  avatar: string = ''
  content: string = ''
  id_from: string = ''
  sub_type: string = ''
  timestamp: number = 0
  content_type: string = ''
  unread_count: number = 0
  chat_type: string = '' //friend group
  name: string = ''
  chatId: string = ''
  remark: string = ''
  is_top: number = 0
  is_disturb: number = 0
  mid: string = ''
  topTime: number = 0
  isRemind: number = 0
  draft: string = ''
  isOnline: number = 0
  fromUserName: string = ''
  isReadAudio: number = 0
  readMid: number = 0
  updateTime: number = 0
  listId: string = ''
  role: number = 0
}
