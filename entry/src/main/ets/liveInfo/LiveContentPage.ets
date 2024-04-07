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
import { LiveDetailBean, LiveInfo, TvUser } from '../data/LiveDetailData'
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
  @State currentUser: TvUser | null = null
  @State roomId: string = ''
  @State ballType: number = 0
  @State tournamentId: number = -1
  @State more: Array<TvUser> = []
  @State liveDetails: LiveDetailBean = new LiveDetailBean()

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
        ChatRoomPage({ model: this.model, roomId: this.roomId })
        LiveAnchorPage({ user: $currentUser })
        // LiveOddPage()
        // LiveAnalysePage({ type: this.ballType, tournamentId: this.tournamentId })
        LiveLeagueListPage({ list: $more, details: $liveDetails })
        // LiveChatPage()
      }
      .index(this.index)
      .indicator(false)
      .disableSwipe(true)
      .duration(50)
      .onChange((index) => {
        this.index = index
      })
    }.height('100%').width('100%')
  }

  aboutToDisappear() {
    this.videoController.release()
  }

  aboutToAppear() {
    let params = router.getParams() as Record<string, object>
    this.tournamentId = params.tournamentId as unknown as number
    this.ballType = params.type as unknown as number
    var memberId = params.memberId as unknown as number
    this.model.getLiveInfo(this.tournamentId, this.ballType, memberId).then((value: LiveInfo) => {
      // this.currentUser = value.more.find((more) => {
      //   return more.member_id == `${memberId}`
      // })
      value.more.forEach((item) => {
        if (item.member_id == value.detail.member_id) {
          item.isPlay = true
          this.currentUser = item
          return
        }
      })
      this.roomId = value.detail.room_id
      this.videoController.firstPlay(value.detail.screen_url_m3u8, this.surfaceID)
      this.more = value.more
      this.liveDetails = value.detail
    })
  }
}