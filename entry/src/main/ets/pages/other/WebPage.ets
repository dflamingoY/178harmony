import webview from '@ohos.web.webview'
import router from '@ohos.router'
import HttpIp from '../../net/HttpIP'

@Entry
@Component
export struct WebPage {
  controller: WebviewController = new webview.WebviewController()
  @State url: string = ''
  @State title: string = ''

  build() {
    Column() {
      Stack({ alignContent: Alignment.Start }) {
        Text(this.title)
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

      Web({ src: this.url, controller: this.controller })
        .width('100%')
        .javaScriptAccess(true)
        .zoomAccess(false)
        .verticalScrollBarAccess(true)
    }
    .backgroundColor(Color.Black)
    .height('100%')
  }

  aboutToAppear() {
    let params = router.getParams() as Record<string, object>
    this.url = params.url as unknown as string
    this.title = params.title as unknown as string
  }
}