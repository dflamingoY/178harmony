import router from '@ohos.router'
@Entry
@Component
export struct TagPage {
  build() {
    Column() {
      Stack({ alignContent: Alignment.Start }) {

        Text('好友标签')
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
    }.backgroundColor(0xfff6f6f6)
  }
}