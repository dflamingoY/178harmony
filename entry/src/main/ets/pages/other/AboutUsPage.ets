import router from '@ohos.router'
import featureAbility from '@ohos.ability.featureAbility'
import IColors from '../../utils/IColors'

@Entry
@Component
export struct AboutUsPage {
  build() {
    Column() {
      Stack({ alignContent: Alignment.Start }) {

        Text('版本信息')
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

      Column() {
        Image($r('app.media.ic_launcher'))
          .width('96vp')
          .height('96vp')

        Text() {
          Span($r('app.string.app_name'))
            .fontSize('15fp')
            .fontColor(IColors.color1R1E20)

          Span("  1.0.0")
            .fontSize('15fp')
            .fontColor(IColors.color1R1E20)
        }
        .margin({ top: '20vp' })

      }.justifyContent(FlexAlign.Center)
      .height('60%')
    }.height('100%')
    .backgroundColor(0xF3F3F5)
  }
}