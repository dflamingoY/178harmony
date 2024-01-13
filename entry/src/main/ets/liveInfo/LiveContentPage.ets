import hilog from '@ohos.hilog'
import router from '@ohos.router'
import { LiveInfoModel } from './LiveIndoModel'

@Entry
@Component
export struct LiveContentPage {
  model: LiveInfoModel = new LiveInfoModel()

  build() {
    Row() {
      Column() {
        Text("直播详情")
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }

  onPageShow() {

  }

  aboutToAppear() {
    let params = router.getParams() as Record<string, object>
    var tournamentId = params.tournamentId as unknown as number
    var url = params.url
    var type = params.type as unknown as number
    var memberId = params.memberId as unknown as number
    hilog.debug(0x0000ff, "West", `tournamentId : ${tournamentId}`)
    this.model.getLiveInfo(tournamentId, type, memberId).then((value: object) => {
      hilog.debug(0xff00, "West", "详情获取到 " + `${value}`)
    })
  }
}