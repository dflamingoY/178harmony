import router from '@ohos.router'
import IConstant from '../utils/IConstant'

@Entry
@Component
export struct ShowPicPage {
  @State url: string = ''
  @State opacity1: number = 1

  build() {
    Column() {
      Image(this.url)
        .objectFit(ImageFit.Auto)
        .draggable(true)
    }
    .width(IConstant.MATCH_PARENT)
    .height(IConstant.MATCH_PARENT)
    .opacity(this.opacity1)
    .onClick(() => {
      router.back()
    })
    .backgroundColor(Color.Black)
  }

  aboutToAppear() {
    let params = router.getParams() as Record<string, string>
    this.url = params.url
  }

  pageTransition() {
    PageTransitionEnter({ duration: 1000, curve: Curve.Linear })
      .onEnter((type: RouteType, progress: number) => {
        this.opacity1 = progress
      })
    PageTransitionExit({ duration: 500, curve: Curve.Linear })
      .onExit((type: RouteType, progress: number) => {
        this.opacity1 = 1-progress
      })
  }
}