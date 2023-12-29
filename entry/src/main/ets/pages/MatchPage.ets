import { MatchChildPage } from './match/MatchChildPage'
import { MatchTopBar } from './match/MatchTopBar'

@Entry
@Component
export struct MatchPage {
  @State currentIndex: number = 0
  @State otherCount: number = 0

  build() {
    Flex({ direction: FlexDirection.Column }) {
      MatchTopBar({ index: $currentIndex, otherCount: $otherCount })
      Swiper() {
        MatchChildPage({ index: $currentIndex })
        MatchChildPage({ index: $currentIndex })
        MatchChildPage({ index: $currentIndex })
        MatchChildPage({ index: $currentIndex })
        MatchChildPage({ index: $currentIndex })
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

  aboutToAppear() {

  }
}