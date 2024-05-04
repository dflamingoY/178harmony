import router from '@ohos.router'
import display from '@ohos.display';
import { VideoPresenter } from '../../liveInfo/VideoPresenter';
import IConstant from '../../utils/IConstant';
import { MatchBean } from '../../data/Data';
import { VideoBottom } from '../../widget/VideoBottom';

@Component
@Entry //视频回放
export struct ReplayPage {
  private xComponentController = new XComponentController();
  private videoController: VideoPresenter = new VideoPresenter()
  private surfaceID: string = '';
  @State list: Array<MatchBean> = []
  @State playId: number = 0
  matchWidth = 0
  matchHeight = 0

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
          .width(IConstant.MATCH_PARENT)
          .height(`${display.getDefaultDisplaySync().width * 0.5629}px`)

        Column() {
          Image($r('app.media.icon_black_back'))
            .height('21vp')
            .align(Alignment.TopStart)
            .width('21vp')
            .margin({ left: '12vp', top: '12vp' })
            .onClick(() => {
              router.back()
            })
          Blank()
          //展示视频长度等信息
          VideoBottom()
        }
        .alignItems(HorizontalAlign.Start)
        .height(IConstant.MATCH_PARENT)

      }.width('100%')
      .height(`${display.getDefaultDisplaySync().width * 0.5629}px`)

      List({}) {
        ForEach(this.list, (item: MatchBean) => {
          ListItem() {
            this.buildItem(item)
          }
        })
      }.alignListItem(ListItemAlign.Center)
      .margin({ left: '3vp', right: '3vp' })
      .layoutWeight(1)
      .lanes(2)
    }.height(IConstant.MATCH_PARENT)
    .width(IConstant.MATCH_PARENT)
  }

  @Builder
  private buildItem(item: MatchBean) {
    Column() {
      Stack() {
        Image(item.cover)
          .borderRadius('10vp')
          .margin({ left: '3vp', right: '3vp' })
          .alt($r('app.media.icon_news_default'))
          .height(`${this.matchHeight}px`)
          .width(`${this.matchWidth - display.getDefaultDisplaySync().densityPixels * 6}px`)

        Row() {
          Image(item.face)
            .alt($r('app.media.icon_default_avatar'))
            .width('15vp')
            .height('15vp')
            .margin({ left: '8vp' })
            .borderRadius('7.5vp')

          Text(item.username??item.nickname)
            .fontSize(12)
            .fontColor(Color.White)
            .margin({ left: '5vp' })
          Blank()
          if (item.is_video !== undefined || item.is_video == 0) {
            Image($r('app.media.icon_live_count_user'))
              .width('10vp')
              .height('14vp')
            Text(`${item.viewer}`)
              .fontColor(Color.White)
              .margin({ left: '5vp' })
              .margin({ right: '8vp' })
              .fontSize('12vp')
          }
        }
        .width(`${this.matchWidth - display.getDefaultDisplaySync().densityPixels * 6}px`)
        .height('30vp')
        .alignItems(VerticalAlign.Center)
        .backgroundColor(0xb3000000)
        .borderRadius({ bottomLeft: '10vp', bottomRight: '10vp' })

        if (item.id == this.playId) {
          Image($r('app.media.icon_playing'))
            .width('40vp')
            .height('20vp')
            .objectFit(ImageFit.Cover)
            .padding('5vp')
            .backgroundColor(Color.White)
            .borderRadius('10vp')
            .margin({
              left: `${this.matchWidth - display.getDefaultDisplaySync().densityPixels * 60}px`,
              bottom: `${this.matchHeight - display.getDefaultDisplaySync().densityPixels * 30}px`
            })
        }

      }.alignContent(Alignment.Bottom)

      Text(item.is_video !== undefined || item.is_video == 0 ? `${item.league_name_zh} ${item.home_team_zh} VS ${item.away_team_zh}` : item.title)
        .textAlign(TextAlign.Start)
        .width('100%')
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: '10vp', left: '5vp', right: '5vp' })
        .maxLines(1)
    }.margin({ top: '10vp' })
    .onClick(() => {
      this.playId = item.id
      this.videoController.firstPlay(item.video_url, this.surfaceID)
      this.videoController.nextVideo()
    })
  }

  aboutToAppear() {
    let pixels = display.getDefaultDisplaySync().densityPixels
    let width = display.getDefaultDisplaySync().width
    this.matchWidth = (width - pixels * 6) / 2
    this.matchHeight = this.matchWidth * 9 / 16
    let params = router.getParams() as Record<string, any>
    this.playId = params.id
    let url: string = params.url
    try {
      let arr: Array<MatchBean> = JSON.parse(params.data)
      if (arr !== undefined) {
        this.list = arr.filter((item) => {
          return item.is_video !== undefined && item.is_video == 1
        })
      }
    } catch (e) {
    }
    setTimeout(() => {
      this.videoController.firstPlay(url, this.surfaceID)
    }, 1000)
  }

  aboutToDisappear() {
    this.videoController.release()
  }
}