import { IndexRecommend } from './IndexRecommend';
import { ChatPage } from './ChatPage';
import { MatchPage } from './MatchPage';
import { UserPage } from './UserPage';
import { NewsPage } from './NewsPage';
import router from '@ohos.router';
import hilog from '@ohos.hilog';

@Entry
@Component
struct HomePage {
  @State message: string = 'Hello World'
  private tabsController: TabsController = new TabsController();

  build() {
    Row() {
      Tabs({ barPosition: BarPosition.End,
        controller: this.tabsController }
      ) {
        TabContent() {
          IndexRecommend()
        }.tabBar("首页").onClick(() => {
          hilog.debug(0x0000ff, "Mozator", "首页 界面点击事件")
        })

        TabContent() {
          ChatPage()
        }.tabBar("聊天").onClick(() => {
          hilog.debug(0x0000ff, "Mozator", "聊天 界面点击事件")
        })

        TabContent() {
          MatchPage()
        }.tabBar("赛事").onClick(() => {
          hilog.debug(0x0000ff, "Mozator", "赛事 界面点击事件")
        })

        TabContent() {
          NewsPage()
        }.tabBar("资讯").onClick(() => {
          hilog.debug(0x0000ff, "Mozator", "资讯 界面点击事件")
        })

        TabContent() {
          UserPage()
        }.tabBar("我的").onClick(() => {
          hilog.debug(0x0000ff, "Mozator", "我的 界面点击事件")
        })
      }
      .width('100%')
      .height('100%')
      .barMode(BarMode.Fixed)
      .scrollable(false)
      .barHeight('56vp')
      .onChange((index: number) => {
        hilog.debug(0x0000ff, "Mozator", "界面发生变化  ; " + `${index}`)
      })
      .onClick(() => {
        hilog.debug(0x0000ff, "Mozator", "tab 按点事件")
      })
    }
  }
}