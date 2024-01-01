import hilog from '@ohos.hilog'
import { UserBean } from '../data/user'
import { saveNumber, saveString } from '../utils/SpUtil'
import { LoginModel } from './LoginModel'

@Entry
@Component
export struct LoginPage {
  model: LoginModel = new LoginModel()

  build() {
    Stack() {
      Image($r('app.media.draw_login_bg')).width('100%').height('100%')
      Flex({ direction: FlexDirection.Column }) {
        Column() {
          Row() {
            Image($r('app.media.icon_black_back'))
              .width('22vp')
              .height('22vp')
              .margin({ left: "15vp", top: "15vp" })
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
              .fontSize('22fp')
              .placeholderColor(0x99ffffff)
              .type(InputType.Password)
              .enterKeyType(EnterKeyType.Done)
          }
          .height('52vp')
          .backgroundColor(0x40ffffff)
          .width('90%')
          .margin({ top: '20vp' })
          .borderRadius('25vp')

          Row() {
            Text("忘记密码")
              .fontSize('12vp')
              .fontColor(Color.White)
              .align(Alignment.End)
          }.justifyContent(FlexAlign.End).width('100%').margin({ top: "20vp", right: '20vp' })

          Button('登 陆', { type: ButtonType.Capsule })
            .fontSize('18vp')
            .width('90%')
            .height('50vp')
            .margin({ top: '20vp' })
            .backgroundColor(0xFED8BD)
            .fontColor(0x1E1E20)
            .onClick(() => {
              this.model.login('13200000001', '111111').then((value: UserBean) => {
                saveString('token', value.token)
                saveNumber('uid', value.uid)
                AppStorage.SetAndLink("token", value.token)
                hilog.debug(0xff00, "West", "登陆成功 " + `${value.token}`)
              })
            })

          Text("注册")
            .fontSize('18vp')
            .fontColor(Color.White)
            .width('90%')
            .textAlign(TextAlign.Center)
            .margin({ top: '10vp' })
            .height('50vp')
            .onClick(() => {

            })

          Blank()

          Text() {
            Span('登录代表您已阅读并同意').fontSize('12fp').fontColor(Color.White)
            Span('使用协议').fontSize('12fp').fontColor(0xFED8BD)
            Span('和').fontSize('12fp').fontColor(Color.White)
            Span('隐私政策').fontSize('12fp').fontColor(0xFED8BD)
          }.margin({ bottom: '20vp' })
        }.align(Alignment.Center).height('100%')
      }

    }
  }
}