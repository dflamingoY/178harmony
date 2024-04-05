import webview from '@ohos.web.webview'
import HttpIp from '../net/HttpIP'

@Component
export struct LiveAnalysePage {
  controller: WebviewController = new webview.WebviewController()
  type: number = 1
  tournamentId: number = 0

  build() {
    Scroll() {
      Web({ src: this.type == 1 ? HttpIp.HOST_H5_ANALYST + `Fenxi2?type=0&id=${this.tournamentId}`
                                : HttpIp.HOST_H5_ANALYST + `BasketballFenxi2?type=1&id=${this.tournamentId}`
      , controller: this.controller })
        .width('100%')
        .javaScriptAccess(true)
        .zoomAccess(false)
        .verticalScrollBarAccess(true)


    }.height('50%')

  }
}