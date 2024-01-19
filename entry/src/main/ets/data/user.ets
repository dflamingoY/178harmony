export class UserBean {
  uid: number = 0
  phone: string = ''
  username: string = ''
  nickname: string = ''
  avatar: string = ''
  sign: string = ''
  state: string = ''//offline online
  logout_timestamp: number = 0
  timestamp: number = 0
  account_state: string = ''
  qrcode: string = ''
  member_id: Object | string
  role: number = 0
  last_login_time: number = 0
  token: string = ''
  remark: string = ''
}