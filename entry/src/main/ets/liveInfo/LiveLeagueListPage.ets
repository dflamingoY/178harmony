import display from '@ohos.display'
import { TvUser } from '../data/Data'
import { LiveDetailBean } from '../data/LiveDetailData'

@Component
export struct LiveLeagueListPage {
  @Link list: Array<TvUser>
  @Link details: LiveDetailBean
  private matchWidth = 0
  private matchHeight = 0

  build() {
    Column() {
      List() {
        ForEach(this.list, (item: TvUser) => {
          ListItem() {
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

                  Text(item.username)
                    .fontSize(12)
                    .fontColor(Color.White)
                    .margin({ left: '5vp' })
                  Blank()

                  Image($r('app.media.icon_live_count_user'))
                    .width('10vp')
                    .height('14vp')

                  Text(`${item.viewer}`)
                    .fontColor(Color.White)
                    .margin({ left: '5vp' })
                    .margin({ right: '8vp' })
                    .fontSize('12vp')

                }
                .width(`${this.matchWidth - display.getDefaultDisplaySync().densityPixels * 6}px`)
                .height('30vp')
                .alignItems(VerticalAlign.Center)
                .backgroundColor(0xb3000000)
                .borderRadius({ bottomLeft: '10vp', bottomRight: '10vp' })

              }.alignContent(Alignment.Bottom)

              Text(`${this.details.league_name_zh} ${this.details.home_team_zh} VS ${this.details.away_team_zh}`)
                .textAlign(TextAlign.Start)
                .width('100%')
                .margin({ top: '10vp' })
                .maxLines(1)
            }.margin({ top: '10vp' })
          }.width(`${this.matchWidth}px`)
          .margin({ top: '6vp' })
        })
      }.lanes(2)
      .margin({ left: '3vp', right: '3vp' })
      .height(`${display.getDefaultDisplaySync().height - display.getDefaultDisplaySync()
        .width * 0.5629 - display.getDefaultDisplaySync().densityPixels * 128}px`)
    }
  }

  //宽高 16:9 初始化项目
  initMatchScreen() {
    let pixels = display.getDefaultDisplaySync().densityPixels
    let width = display.getDefaultDisplaySync().width
    this.matchWidth = (width - pixels * 6) / 2
    this.matchHeight = this.matchWidth * 9 / 16
  }

  aboutToAppear() {
    this.initMatchScreen()
  }
}