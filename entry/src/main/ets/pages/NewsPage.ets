@Entry
@Component
export struct NewsPage {
  build() {
    Row() {
      Column() {
        Text("资讯")
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}