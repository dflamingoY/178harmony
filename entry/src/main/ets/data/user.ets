export class UserBean {
  uid: string = ''
  phone: string = ''
  username: string = ''
  nickname: string = ''
  avatar: string = ''
  sign: string = ''
  state: string = '' //offline online
  logout_timestamp: number = 0
  timestamp: number = 0
  account_state: string = ''
  qrcode: string = ''
  member_id: string
  role: number = 0
  last_login_time: number = 0
  token: string = ''
  remark: string = ''
  operation: string = '' //'not_operated','refuse','agree' 未操作,拒绝,同意
}