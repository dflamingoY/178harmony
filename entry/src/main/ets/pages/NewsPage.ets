@Entry
@Component
export struct NewsPage {
  build() {
    Column() {
      LoadingProgress()
        .width('30vp')
        .height('30vp')

      // Column() {
      //   Text("资讯")
      //     .fontSize(50)
      //     .fontWeight(FontWeight.Bold)
      // }
      // .width('100%')
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}