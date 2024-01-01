import hilog from '@ohos.hilog'
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
    var tournamentId = globalThis.wantParams.parameters.tournamentId
    var url = globalThis.wantParams.parameters.url
    var type = globalThis.wantParams.parameters.type
    var memberId = globalThis.wantParams.parameters.memberId
    hilog.debug(0x0000ff, "West", `tournamentId : ${tournamentId}`)
    this.model.getLiveInfo(tournamentId, type, memberId).then((value: object) => {
      hilog.debug(0xff00, "West", "详情获取到 " + `${value}`)
    })
  }
}