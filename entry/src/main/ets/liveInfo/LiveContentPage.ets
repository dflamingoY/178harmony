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
import LogUtil from '../utils/LogUtil'
import { LiveInfo } from '../data/LiveDetailData'
import { VideoController } from './VideoController'

@Entry
@Component
export struct LiveContentPage {
  model: LiveInfoModel = new LiveInfoModel()
  @State index: number = 0
  @State unreadCount: number = 0
  private xComponentController = new XComponentController();
  private videoController: VideoController = new VideoController()
  private surfaceID: string = '';

  build() {
    Column() {
      Stack({ alignContent: Alignment.TopStart }) {
        XComponent({ id: '', type: 'surface', libraryname: '', controller: this.xComponentController })
          .onLoad(async () => {
            this.xComponentController.setXComponentSurfaceSize({
              surfaceWidth: display.getDefaultDisplaySync().width,
              surfaceHeight: display.getDefaultDisplaySync().width * 0.5629
            });
            this.surfaceID = this.xComponentController.getXComponentSurfaceId();
          })
          .backgroundColor(Color.White)
          .width('100%')
          .height(`${display.getDefaultDisplaySync().width * 0.5629}px`)
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

  aboutToDisappear() {
    this.videoController.release()
  }

  aboutToAppear() {
    let params = router.getParams() as Record<string, object>
    var tournamentId = params.tournamentId as unknown as number
    var type = params.type as unknown as number
    var memberId = params.memberId as unknown as number
    this.model.getLiveInfo(tournamentId, type, memberId).then((value: LiveInfo) => {
      LogUtil.d("West", "详情获取到 " + `${value}`)
      this.videoController.firstPlay(value.detail.screen_url_m3u8, this.surfaceID)
    })
  }
}