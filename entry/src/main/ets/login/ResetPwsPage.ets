import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import IColors from '../utils/IColors'
import UserViewModel from '../pages/UserViewModel'
import { LoginStatuePage } from './LoginStatuePage'

@Entry
@Component
export struct ResetPwsPage {
  @State account: string = ''
  @State optCode: string = ''
  @State pwd: string = ''
  @State confirmPwd: string = ''
  @State loading: boolean = false
  @State timerCount: number = -1
  @State showSuccess: boolean = false

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Image($r('app.media.draw_login_bg')).width('100%').height('100%')

      Column() {
        Row() {
          Image($r('app.media.icon_phone')).width('25vp').height('25vp').margin({ left: "16vp" })
          TextInput({ placeholder: "请输入手机号" })
            .fontColor(Color.White)
            .fontSize('22fp')
            .layoutWeight(1)
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

        Stack({ alignContent: Alignment.End }) {
          Row() {
            Image($r('app.media.icon_sign_sms')).width('25vp').height('25vp').margin({ left: "16vp" })
            TextInput({ placeholder: "请输入短信验证码" })
              .fontColor(Color.White)
              .fontSize('22fp')
              .layoutWeight(1)
              .placeholderColor(0x99ffffff)
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
          Image($r('app.media.icon_pwd')).width('25vp').height('25vp').margin({ left: "16vp" })
          TextInput({ placeholder: "请输入密码" })
            .fontColor(Color.White)
            .fontSize('22fp')
            .showPasswordIcon(true)
            .layoutWeight(1)
            .placeholderColor(0x99ffffff)
            .type(InputType.Password)
            .enterKeyType(EnterKeyType.Done)
            .onChange((value: string) => {
              this.pwd = value
            })
        }
        .height('52vp')
        .backgroundColor(0x40ffffff)
        .width('90%')
        .margin({ top: '30vp' })
        .borderRadius('25vp')

        Row() {
          Image($r('app.media.icon_pwd')).width('25vp').height('25vp').margin({ left: "16vp" })
          TextInput({ placeholder: "请再次确认密码" })
            .fontColor(Color.White)
            .fontSize('22fp')
            .layoutWeight(1)
            .showPasswordIcon(true)
            .placeholderColor(0x99ffffff)
            .type(InputType.Password)
            .enterKeyType(EnterKeyType.Done)
            .onChange((value: string) => {
              this.confirmPwd = value
            })
        }
        .height('52vp')
        .backgroundColor(0x40ffffff)
        .width('90%')
        .margin({ top: '30vp' })
        .borderRadius('25vp')

        Button('完 成', { type: ButtonType.Capsule })
          .fontSize('18vp')
          .width('90%')
          .height('50vp')
          .margin({ top: '30vp' })
          .backgroundColor(0xFED8BD)
          .fontColor(0x1E1E20)
          .onClick(() => {
            this.reset()
          })
      }
      .margin({ top: '100vp' })

      Stack({ alignContent: Alignment.Start }) {
        Text('重置密码')
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
        LoginStatuePage({ type: 0 })

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

  reset() {
    if (this.account == "") {
      promptAction.showToast({ message: '请输入手机号', duration: 500 })
      return
    }

    if (this.pwd !== this.confirmPwd) {
      promptAction.showToast({ message: '两次输入的密码不一致', duration: 500 })
      return
    }
    this.loading = true
    UserViewModel.resetPwd(this.account, this.pwd, this.optCode).then(() => {
      this.loading = false
      this.showSuccess = true
    }).catch((err) => {
      promptAction.showToast({ message: err, duration: 500 })
      this.loading = false
    })
  }

  getOpt() {
    if (this.account == "") {
      promptAction.showToast({ message: '请输入手机号', duration: 500 })
      return
    }
    this.loading = true
    UserViewModel.getOptCode(this.account).then(() => {
      this.startTimer()
      this.loading = false
      promptAction.showToast({ message: '发送成功', duration: 500 })
    }).catch((err) => {
      this.loading = false
      promptAction.showToast({ message: err, duration: 500 })
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