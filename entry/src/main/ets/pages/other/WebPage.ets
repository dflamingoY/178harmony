import webview from '@ohos.web.webview'
import router from '@ohos.router'
import HttpIp from '../../net/HttpIP'

@Entry
@Component
export struct WebPage {
  controller: WebviewController = new webview.WebviewController()
  @State type: number = 0
  @State tournamentId: number = 0

  build() {
    Scroll() {
      Column() {
        Web({ src: this.type == 1 ? HttpIp.HOST_H5_ANALYST + `Fenxi2?type=0&id=${this.tournamentId}`
                                  : HttpIp.HOST_H5_ANALYST + `BasketballFenxi2?type=1&id=${this.tournamentId}`
        , controller: this.controller })
          .width('100%')
          .javaScriptAccess(true)
          .zoomAccess(false)
          .height('100%')
          .verticalScrollBarAccess(true)
      }
    }.height('100%')
  }

  aboutToAppear() {
    let params = router.getParams() as Record<string, object>
    this.type = params.type as unknown as number
    this.tournamentId = params.tournamentId as unknown as number
  }
}