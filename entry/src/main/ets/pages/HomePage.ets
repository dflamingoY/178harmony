import { IndexRecommend } from './IndexRecommend';
import { ChatPage } from './ChatPage';
import { MatchPage } from './MatchPage';
import { UserPage } from './UserPage';
import { NewsPage } from './NewsPage';
import router from '@ohos.router';
import hilog from '@ohos.hilog';
import { HomeTabBar } from './HomeTabBar';

@Entry
@Component
struct HomePage {
  @State message: string = 'Hello World'
  private tabsController: TabsController = new TabsController();
  @State currentIndex: number = 0
  @State unreadCount: number = 1

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Swiper() {
        IndexRecommend()
        ChatPage()
        MatchPage()
        NewsPage()
        UserPage()
      }
      .index(this.currentIndex)
      .indicator(false)
      .loop(false)
      .duration(50)
      .onChange((index) => {
        this.currentIndex = index
      })

      HomeTabBar({ index: $currentIndex, unreadCount: $unreadCount })

    }.height('100%').width('100%')

  }
}