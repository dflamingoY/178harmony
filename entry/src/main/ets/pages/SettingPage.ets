import router from '@ohos.router'
import PreferenceModel from '../utils/PreferenceModel'

@Entry
@Component
export struct SettingPage {
  build() {
    Column() {
      Stack({ alignContent: Alignment.Start }) {

        Text('通用')
          .fontColor(0x333333)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .fontSize('17fp')
          .width('100%')

        Image($r('app.media.icon_back'))
          .margin({ left: '15vp' })
          .height('21vp')
          .width('21vp')
          .onClick(() => {
            router.back()
          })
      }.width('100%')
      .height('48vp')

      Blank()

      Column() {
        Text('退出登录').width('100%')
          .fontColor(0xED6262)
          .textAlign(TextAlign.Center)
          .fontSize('15fp')
      }
      .height('58vp')
      .backgroundColor(Color.White)
      .margin({ left: '15vp', right: '15vp', bottom: '25vp' })
      .justifyContent(FlexAlign.Center)
      .borderRadius('8vp')
      .onClick(() => {
        globalThis.token = null
        PreferenceModel.deleteKey('token')
        PreferenceModel.deleteKey('user')
        // router.replaceUrl({url:'pages/HomePage'})
        router.back()
      })
    }
    .height('100%')
    .backgroundColor(0xF3F3F5)
  }
}