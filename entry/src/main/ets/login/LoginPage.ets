import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import { UserBean } from '../data/user'
import LogUtil from '../utils/LogUtil'
import PreferenceModel from '../utils/PreferenceModel'
import { LoginModel } from './LoginModel'
import emitter from '@ohos.events.emitter'
import IConstant from '../utils/IConstant'
import IColors from '../utils/IColors'
import HttpIp from '../net/HttpIP'

@Entry
@Component
export struct LoginPage {
  model: LoginModel = new LoginModel()
  @State isLogin: boolean = false
  @State account: string = ''
  @State pwd: string = ''

  build() {
    Stack() {
      Image($r('app.media.draw_login_bg')).width('100%').height('100%')
      Flex({ direction: FlexDirection.Column }) {
        Column() {
          Row() {
            Image($r('app.media.icon_black_back'))
              .width('22vp')
              .height('22vp')
              .margin({ left: "15vp", top: "15vp" }).onClick(() => {
              router.back()
            })
          }.justifyContent(FlexAlign.Start).width('100%')

          Image($r('app.media.ic_launcher')).width('90vp').height('90vp').margin({ top: '100vp' })
          Text('看球聊天两不误').fontSize('24fp').fontColor(Color.White).margin({ top: '20vp' })
          Row() {
            Image($r('app.media.icon_phone')).width('25vp').height('25vp').margin({ left: "16vp" })
            TextInput({ placeholder: "请输入手机号/178号" })
              .fontColor(Color.White)
              .fontSize('22fp')
              .placeholderColor(0x99ffffff)
              .type(InputType.Number)
              .enterKeyType(EnterKeyType.Next)
              .layoutWeight(1)
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
            TextInput({ placeholder: "请输入密码" })
              .fontColor(Color.White)
              .layoutWeight(1)
              .fontSize('22fp')
              .showPasswordIcon(true)
              .showPasswordIcon(true)
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
          .margin({ top: '20vp' })
          .borderRadius('25vp')

          Row() {
            Text("忘记密码?")
              .fontSize('12vp')
              .fontColor(Color.White)
              .align(Alignment.End)
              .onClick(() => {
                router.pushUrl({ url: 'login/ResetPwsPage' })
              })
              .margin({ right: '12vp' })

          }.justifyContent(FlexAlign.End).width('100%').margin({ top: "20vp", right: '20vp' })

          Button('登 陆', { type: ButtonType.Capsule })
            .fontSize('18vp')
            .width('90%')
            .height('50vp')
            .margin({ top: '20vp' })
            .backgroundColor(0xFED8BD)
            .fontColor(0x1E1E20)
            .onClick(() => {
              this.login()
            })

          Text("注册")
            .fontSize('18vp')
            .fontColor(Color.White)
            .width('90%')
            .textAlign(TextAlign.Center)
            .margin({ top: '10vp' })
            .height('50vp')
            .onClick(() => {
              router.pushUrl({ url: "login/SignPage" })
            })

          Blank()

          Text() {
            Span('登录代表您已阅读并同意').fontSize('12fp').fontColor(Color.White)
            Span('使用协议').fontSize('12fp').fontColor(0xFED8BD)
              .onClick(() => {
                router.pushUrl({ url: 'pages/other/WebPage', params: {
                  title: '使用协议', url: HttpIp.APP_PROTOCOL
                } })
              })
            Span('和').fontSize('12fp').fontColor(Color.White)
            Span('隐私政策').fontSize('12fp').fontColor(0xFED8BD)
              .onClick(() => {
                router.pushUrl({ url: 'pages/other/WebPage', params: {
                  title: '隐私政策', url: HttpIp.APP_PRIVACY
                } })
              })
          }.margin({ bottom: '20vp' })
        }.align(Alignment.Center).height('100%')
      }

      if (this.isLogin)
      Column() {
        LoadingProgress()
          .color(IColors.colorOrange)
          .height('50vp')
          .width('50vp')
          .backgroundColor(IColors.colorF3F3F5)
          .borderRadius('5vp')
          .padding('2vp')

      }.width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
  }

  login() {
    if (this.account === '' || this.pwd === '') {
      promptAction.showToast({ message: '请输入账号密码', duration: 1500 })
      return
    }
    this.isLogin = true
    this.model.login(this.account, this.pwd).then((value: UserBean) => {
      PreferenceModel.putNormal(IConstant.PHONE_CACHED, this.account)
      PreferenceModel.putNormal("token", value.token)
      PreferenceModel.putNormal("user", JSON.stringify(value))
      globalThis.token = value.token
      globalThis.uid = value.uid
      globalThis.user = value
      let eventData = {}
      let innerEvent = {
        eventId: IConstant.LOGIN_EVENT_ID,
        priority: emitter.EventPriority.IMMEDIATE
      };
      emitter.emit(innerEvent, eventData)

      router.back()
    }).catch((err) => {
      promptAction.showToast({
        message: err.toString(),
        duration: 1500
      })
      LogUtil.d("West", err.toString)
      this.isLogin = false
    })
  }

  aboutToAppear() {
    PreferenceModel.getString(IConstant.PHONE_CACHED, '').then((value: string) => {
      this.account = value
    })
  }
}