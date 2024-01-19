import hilog from '@ohos.hilog'
import router from '@ohos.router'
import display from '@ohos.display'
import { LiveInfoModel } from './LiveIndoModel'
import { LiveTabBar } from './LiveTabBar'
import { ChatRoomPage } from './ChatRoomPage'
import { LiveAnchorPage } from './LiveAnchorPage'
import { LiveOddPage } from './LiveOddPage'
import { LiveAnalysePage } from './LiveAnalysePage'
import { LiveLeagueListPage } from './LiveLeagueListPage'
import { LiveChatPage } from './LiveChatPage'

@Entry
@Component
export struct LiveContentPage {
  model: LiveInfoModel = new LiveInfoModel()
  @State index: number = 0
  @State unreadCount: number = 0

  build() {
    Column() {

      Stack({ alignContent: Alignment.TopStart }) {



        Image($r('app.media.icon_back'))
          .height('21vp')
          .width('21vp')
          .margin({ left: '12vp', top: '12vp' })
          .onClick(() => {
            router.back()
          })
      }.width('100%')
      .height(`${display.getDefaultDisplaySync().width * 0.5629}px`)

      LiveTabBar({ index: $index, unreadCount: $unreadCount })

      Swiper() {
        ChatRoomPage()
        LiveAnchorPage()
        LiveOddPage()
        LiveAnalysePage()
        LiveLeagueListPage()
        LiveChatPage()
      }
      .index(this.index)
      .indicator(false)
      .loop(false)
      .duration(50)
      .onChange((index) => {
        this.index = index
      })
    }
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