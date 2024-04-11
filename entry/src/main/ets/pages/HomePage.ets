import { IndexRecommend } from './IndexRecommend';
import { ChatPage } from './ChatPage';
import { MatchPage } from './MatchPage';
import { UserPage } from './UserPage';
import { NewsPage } from './NewsPage';
import { HomeTabBar } from './HomeTabBar';
import { ContactPage } from './ContactPage';
import router from '@ohos.router';
import IConstant from '../utils/IConstant';
import emitter from '@ohos.events.emitter';
import SocketTask from '../net/SocketTask';

@Entry
@Component
struct HomePage {
  @State message: string = 'Hello World'
  @State currentIndex: number = 0
  @State unreadCount: number = 1

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Swiper() {
        IndexRecommend()
        ChatPage()
        MatchPage()
        ContactPage()
        UserPage()
      }
      .index(this.currentIndex)
      .indicator(false)
      .loop(false)
      .duration(50)
      .disableSwipe(true)
      .onChange((index) => {
        this.currentIndex = index
      })

      HomeTabBar({ index: $currentIndex, unreadCount: $unreadCount })
    }.height('100%').width('100%')
  }

  aboutToAppear() {
    router.clear()
    SocketTask.createWs()
    emitter.on(this.innerEvent, () => {
      if (!globalThis.user || globalThis.user == null) {
        this.currentIndex = 0
      }
    })
    emitter.on({ eventId: IConstant.APP_IN_FOREGROUND }, () => {
      SocketTask.checkWs()
    })
  }

  innerEvent = {
    eventId: IConstant.LOGIN_EVENT_ID
  }

  aboutToDisappear() {
    emitter.off(IConstant.LOGIN_EVENT_ID)
  }
}