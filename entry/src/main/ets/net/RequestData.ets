export class LoginRequest {
  password: string = ''
  username: string = ''
  reg_id: string = ''
  device_id: string = ''

  constructor(username: string, password: string, reg_ig: string, device_id: string) {
    this.username = username
    this.password = password
    this.reg_id = reg_ig
    this.device_id = device_id
  }
}