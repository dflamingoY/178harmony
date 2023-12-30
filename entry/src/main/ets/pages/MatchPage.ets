import hilog from '@ohos.hilog'
import { MatchListData } from '../data/Data'
import { MatchChildPage } from './match/MatchChildPage'
import MatchModel from './match/MatchModel'
import { MatchTopBar } from './match/MatchTopBar'
import MatchViewModel from './match/MatchViewModel'

@Entry
@Component
export struct MatchPage {
  @State currentIndex: number = 0
  @State otherCount: number = 0
  @State matchModel: MatchModel = new MatchModel()

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Image($r('app.media.draw_live_bg'))
        .height('88vp')
        .width('100%')
        .objectFit(ImageFit.Cover)
      Flex({ direction: FlexDirection.Column }) {
        Text("直播")
          .height('40vp')
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontSize('17fp')
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
        MatchTopBar({ index: $currentIndex, otherCount: $otherCount })
        Swiper() {
          MatchChildPage({ index: 0, data: $matchModel })
          MatchChildPage({ index: 1, data: $matchModel })
          MatchChildPage({ index: 2, data: $matchModel })
          MatchChildPage({ index: 3, data: $matchModel })
          MatchChildPage({ index: 4, data: $matchModel })
        }
        .index(this.currentIndex)
        .indicator(false)
        .loop(false)
        .duration(50)
        .onChange((index) => {
          this.currentIndex = index
        })
      }.height('100%').width('100%')
    }
  }

  onPageShow() {

  }

  aboutToAppear() {
    MatchViewModel.getMatch().then((value: MatchListData) => {
      hilog.debug(0xff00, "Mozator", '获取到数据直播列表')
      this.matchModel.allData = value.match_list
      this.matchModel.parseOtherData()
    })
  }
}