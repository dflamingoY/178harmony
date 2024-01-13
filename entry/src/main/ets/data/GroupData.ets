export class GroupBean {
  gid: string = ''
  groupname: string = ''
  avatar: string = ''
  groupnotice: string = ''
  gaccount: string = ''
  add_friend: string = ''
  user_remark: string = ''
  owner_uid: string = '' //群主id
  is_top: number = 0
  agree_join: number = 0
  is_disturb: number = 0
  forbid_talk: number = 0 //禁止聊天
  total: number = 0
  role: number = 0 //1 群主2 管理员 3 成员
  is_owner: boolean = false
}

