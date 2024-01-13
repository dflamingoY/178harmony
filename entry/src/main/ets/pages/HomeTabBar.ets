import router from '@ohos.router'
import { isLogin } from '../login/LoginPlugin'

@Component
export struct HomeTabBar {
  @Link index: number
  @Link unreadCount: number

  build() {
    Row() {
      Column() {
        Image(this.index == 0 ? $r('app.media.icon_home_selected') : $r('app.media.icon_home_default'))
          .width('19vp')
          .margin({ top: '5vp' })
          .height('19vp')
        Text('首页')
          .fontColor(this.index == 0 ? 0xFED8BD : 0x91939A)
          .fontSize('13fp')
          .margin({ top: '5vp' })
      }.width('20%').onClick(() => {
        this.index = 0
      })
      .height('100%')

      Badge({ count: this.unreadCount, maxCount: 99, style: {
        fontSize: '11fp', color: Color.White, badgeColor: Color.Red
      } }) {
        Column() {
          Image(this.index == 1 ? $r('app.media.icon_chat_selected') : $r('app.media.icon_chat_defalut'))
            .width('19vp')
            .margin({ top: '5vp' })
            .height('19vp')
          Text('聊天').fontColor(this.index == 1 ? 0xFED8BD : 0x91939A)
            .fontSize('13fp')
            .margin({ top: '5vp' })
        }.onClick(() => {
          if (isLogin()) {
            this.index = 1
          } else {
            router.pushUrl({ url: 'login/LoginPage' });
          }
        }).width('100%').height('100%')
      }.width('20%').height('100%')

      Column() {
        Image(this.index == 2 ? $r('app.media.icon_live_selected') : $r('app.media.icon_live_default'))
          .width('19vp')
          .height('19vp')
          .margin({ top: '5vp' })
        Text('赛事').fontColor(this.index == 2 ? 0xFED8BD : 0x91939A)
          .fontSize('13fp')
          .margin({ top: '5vp' })
      }.width('20%')
      .onClick(() => {
        this.index = 2
      }).height('100%')

      Column() {
        Image(this.index == 3 ? $r('app.media.icon_tab_news_selected') : $r('app.media.icon_tab_news_default'))
          .width('19vp')
          .margin({ top: '5vp' })
          .height('19vp')
        Text('资讯').fontColor(this.index == 3 ? 0xFED8BD : 0x91939A)
          .fontSize('13fp')
          .margin({ top: '5vp' })

      }.onClick(() => {
        this.index = 3
      }).width('20%').height('100%')

      Column() {
        Image(this.index == 4 ? $r('app.media.icon_my_selected') : $r('app.media.icon_my_default'))
          .width('19vp')
          .height('19vp')
          .margin({ top: '5vp' })
        Text('我的')
          .fontColor(this.index == 4 ? 0xFED8BD : 0x91939A)
          .fontSize('13fp')
          .margin({ top: '5vp' })
      }.onClick(() => {
        if (isLogin()) {
          this.index = 4
        } else {
          router.pushUrl({ url: 'login/LoginPage' });
        }
      })
      .width('20%').height('100%')
    }.height('50vp')
  }
}