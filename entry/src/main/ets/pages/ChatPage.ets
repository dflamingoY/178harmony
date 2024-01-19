import display from '@ohos.display'
@Entry
@Component
export struct ChatPage {
  build() {
    Column(){
      Stack(){
        Image($r('app.media.draw_content_actionbar_bg_3'))
          .width("100%")
          .height('100%')
        Row() {
          Image($r('app.media.icon_search'))
            .width('17vp')
            .height('17vp')
            .margin({left:'12vp'})
          Text('搜索')
            .fontSize('12fp')
            .margin({left:'12vp'})
            .fontColor(0x99ffffff)
            .width('100%')
        }
        .backgroundColor(Color.Red)
        .backgroundColor(0x33ffffff)
        .margin({left:'12vp',top:'8.5vp',right:'12vp',bottom:'12vp'})
        .borderRadius('17vp')
        .height('31vp')

      }.height(`${display.getDefaultDisplaySync().width * 0.2666}px`)
      .align(Alignment.Bottom)


    }.align(Alignment.TopStart)
  }
}