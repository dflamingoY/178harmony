import router from '@ohos.router'
import IColors from '../utils/IColors'

@Component
export struct LoginStatuePage {
  type: number = 0

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Image($r('app.media.draw_login_bg')).width('100%').height('100%')

      Column() {
        Stack({ alignContent: Alignment.Start }) {
          Image($r('app.media.icon_black_back'))
            .width('22vp')
            .height('22vp')
            .margin({ left: "15vp" }).onClick(() => {
            router.back()
          })
        }.width('100%')
        .height('50vp')

        Image($r('app.media.icon_sign_success'))
          .width('64vp')
          .margin({ top: '200vp' })
          .height('64vp')

        Text(this.type == 0 ? '重置密码成功' : "恭喜你,注册成功")
          .fontColor(Color.White)
          .fontSize('17fp')
          .margin({ top: '20vp' })

        Button('去登陆', { type: ButtonType.Capsule })
          .fontSize('18vp')
          .width('90%')
          .height('50vp')
          .margin({ top: '40vp' })
          .backgroundColor(IColors.color1R1E20)
          .fontColor(Color.White)
          .onClick(() => {
            router.back()
          })
      }
    }
  }
}