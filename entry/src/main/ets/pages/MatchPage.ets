import emitter from '@ohos.events.emitter'
import { MatchListData } from '../data/Data'
import LogUtil from '../utils/LogUtil'
import { MatchChildPage } from './match/MatchChildPage'
import MatchModel from './match/MatchModel'
import { MatchTopBar } from './match/MatchTopBar'
import MatchViewModel from './match/MatchViewModel'

@Component
export struct MatchPage {
  @State currentIndex: number = 0
  @State otherCount: number = 0
  @State matchModel: MatchModel = new MatchModel()
  @Prop @Watch('onRefreshUpdated') isRefresh: boolean;

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
          MatchChildPage({ index: 0, data: $matchModel, isRefresh: $isRefresh })
          MatchChildPage({ index: 1, data: $matchModel, isRefresh: $isRefresh })
          MatchChildPage({ index: 2, data: $matchModel, isRefresh: $isRefresh })
          MatchChildPage({ index: 3, data: $matchModel, isRefresh: $isRefresh })
          MatchChildPage({ index: 4, data: $matchModel, isRefresh: $isRefresh })
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

  onRefreshUpdated() {
    if (this.isRefresh) {
      this.getData()
    }
  }

  private getData() {
    MatchViewModel.getMatch().then((value: MatchListData) => {
      this.matchModel.allData = value.match_list
      this.matchModel.parseOtherData()
      this.isRefresh = false
    }).catch(() => {
      this.isRefresh = false
    })
  }

  aboutToAppear() {
    this.getData()
    emitter.on(this.innerEvent, (event) => {
      var emit: Array<any> = JSON.parse(event.data.data)
      emit.forEach((value) => {
        this.matchModel.update(value)
      })
    })
  }

  innerEvent = {
    eventId: 1
  }

  aboutToDisappear() {
    emitter.off(1)
  }
}