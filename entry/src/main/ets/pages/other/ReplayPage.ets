import router from '@ohos.router'

@Component
@Entry //视频回放
export struct ReplayPage {
  build() {
    Column() {

    }
  }

  aboutToAppear() {
    let params = router.getParams() as Record<string, any>
    let playId: number = params.id

  }
}