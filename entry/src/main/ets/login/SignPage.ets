import router from '@ohos.router'
import IColors from '../utils/IColors'
import UserViewModel from '../pages/UserViewModel'
import { LoginStatuePage } from './LoginStatuePage'
import CommonUtil from '../utils/CommonUtil'
import HttpIp from '../net/HttpIP'

@Entry
@Component
export struct SignPage {
  @State account: string = ''
  @State optCode: string = ''
  @State pwd: string = ''
  @State nickname: string = ''
  @State timerCount: number = -1
  @State loading: boolean = false
  @State showSuccess: boolean = false
  @State checkState: boolean = false

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Image($r('app.media.draw_login_bg')).width('100%').height('100%')

      Column() {
        Row() {
          Image($r('app.media.icon_phone')).width('25vp').height('25vp').margin({ left: "16vp" })
          TextInput({ placeholder: "请输入手机号" })
            .fontColor(Color.White)
            .layoutWeight(1)
            .fontSize('22fp')
            .placeholderColor(0x99ffffff)
            .type(InputType.Number)
            .enterKeyType(EnterKeyType.Next)
            .onChange((value: string) => {
              this.account = value
            })
        }
        .height('52vp')
        .backgroundColor(0x40ffffff)
        .width('90%')
        .margin({ top: '51vp' })
        .borderRadius('25vp')

        Row() {
          Image($r('app.media.icon_pwd')).width('25vp').height('25vp').margin({ left: "16vp" })
          TextInput({ placeholder: "请输入6-16位字母或数字" })
            .fontColor(Color.White)
            .fontSize('22fp')
            .showPasswordIcon(true)
            .layoutWeight(1)
            .placeholderColor(0x99ffffff)
            .type(InputType.Password)
            .width('100%')
            .enterKeyType(EnterKeyType.Next)
            .onChange((value: string) => {
              this.pwd = value
            })
        }
        .height('52vp')
        .backgroundColor(0x40ffffff)
        .width('90%')
        .margin({ top: '20vp' })
        .borderRadius('25vp')

        Row() {
          Image($r('app.media.icon_pwd')).width('25vp').height('25vp').margin({ left: "16vp" })
          TextInput({ placeholder: "请输入昵称" })
            .fontColor(Color.White)
            .fontSize('22fp')
            .showPasswordIcon(true)
            .layoutWeight(1)
            .placeholderColor(0x99ffffff)
            .enterKeyType(EnterKeyType.Next)
            .onChange((value: string) => {
              this.nickname = value
            })
        }
        .height('52vp')
        .backgroundColor(0x40ffffff)
        .width('90%')
        .margin({ top: '30vp' })
        .borderRadius('25vp')

        Stack({ alignContent: Alignment.End }) {
          Row() {
            Image($r('app.media.icon_sign_sms')).width('25vp').height('25vp').margin({ left: "16vp" })
            TextInput({ placeholder: "请输入短信验证码" })
              .fontColor(Color.White)
              .fontSize('22fp')
              .placeholderColor(0x99ffffff)
              .layoutWeight(1)
              .type(InputType.Number)
              .enterKeyType(EnterKeyType.Done)
              .onChange((value: string) => {
                this.optCode = value
              })
          }

          Text(this.timerCount != -1 ? `重新发送 ${this.timerCount}` : "发送验证码")
            .fontSize('12fp')
            .lineHeight('100%')
            .margin({ right: '12vp' })
            .textAlign(TextAlign.Center)
            .fontColor(IColors.colorOrange)
            .onClick(() => {
              if (this.timerCount == -1) {
                this.getOpt()
              }
            })
        }
        .height('52vp')
        .backgroundColor(0x40ffffff)
        .width('90%')
        .margin({ top: '30vp' })
        .borderRadius('25vp')

        Row() {
          Checkbox()
            .select(false)
            .selectedColor(IColors.colorOrange)
            .onChange((statue) => {
              this.checkState = statue
            })

          Text() {
            Span('同意')
              .fontColor(Color.White)
              .fontSize('13fp')
            Span('《使用协议》')
              .fontColor(IColors.colorOrange)
              .fontSize('13fp')
              .onClick(() => {
                router.pushUrl({ url: 'pages/other/WebPage', params: {
                  title: '使用协议', url: HttpIp.APP_PROTOCOL
                } })
              })
          }.margin({ left: '12vp' })
        }.width('90%').margin({ top: '30vp' })

        Button('注册', { type: ButtonType.Capsule })
          .fontSize('18vp')
          .width('90%')
          .height('50vp')
          .margin({ top: '30vp' })
          .backgroundColor(0xFED8BD)
          .fontColor(0x1E1E20)
          .onClick(() => {
            this.register()
          })
      }
      .margin({ top: '100vp' })

      Stack({ alignContent: Alignment.Start }) {
        Text('用户注册')
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .fontSize('17fp').width('100%')
        Image($r('app.media.icon_black_back'))
          .width('22vp')
          .height('22vp')
          .margin({ left: "15vp" }).onClick(() => {
          router.back()
        })
      }.width('100%')
      .height('50vp')

      if (this.loading) {
        Column() {
          LoadingProgress()
            .height('50vp')
            .width('50vp')
            .backgroundColor(IColors.colorF3F3F5)
            .borderRadius('5vp')
            .padding('2vp')
        }.width('100%')
        .justifyContent(FlexAlign.Center)
        .height("100%")
      }
      if (this.showSuccess)
        LoginStatuePage({ type: 1 })

    }.width('100%')
    .height('100%')
    .alignContent(Alignment.Top)
  }

  private intervalId: number
  private timeoutID: number

  startTimer() {
    this.timerCount = 60
    let fun = () => {
      this.timerCount--
    }
    this.intervalId = setInterval(fun, 1_000)
    let funInter = () => {
      clearInterval(this.intervalId)
    }
    this.timeoutID = setTimeout(funInter, 60_000);
  }

  getOpt() {
    if (this.account == "") {
      CommonUtil.showToast('请输入手机号')
      return
    }
    this.loading = true
    UserViewModel.getOptCode(this.account).then(() => {
      this.startTimer()
      this.loading = false
      CommonUtil.showToast('发送成功')
    }).catch((err) => {
      this.loading = false
      CommonUtil.showToast(err)
    })
  }

  register() {
    if (!this.checkState) {
      CommonUtil.showToast('请先阅读并同意用户注册协议')
      return
    }
    if (this.account == "") {
      CommonUtil.showToast('请输入手机号')
      return
    }
    if (this.nickname == '') {
      CommonUtil.showToast('请输入昵称')
      return
    }
    if (this.pwd == '') {
      CommonUtil.showToast('请输入密码')
      return
    }
    if (this.optCode == '') {
      CommonUtil.showToast('请输入验证码')
      return
    }
    this.loading = true
    UserViewModel.register(this.account, this.optCode, this.nickname, this.pwd).then(() => {
      this.loading = false
      this.showSuccess = true
    }).catch((err) => {
      CommonUtil.showToast(err)
      this.loading = false
    })
  }

  aboutToDisappear() {
    if (this.timeoutID) {
      clearTimeout(this.timeoutID)
    }
    if (this.intervalId) {
      clearInterval(this.intervalId)
    }
  }
}