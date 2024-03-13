import display from '@ohos.display'
import systemDateTime from '@ohos.systemDateTime'
import router from '@ohos.router'
import { RecentBean } from '../data/MsgBean'
import CommonUtil from '../utils/CommonUtil'
import UserViewModel from './UserViewModel'
import promptAction from '@ohos.promptAction'

@Entry
@Component
export struct ChatPage {
  @State recentList: Array<RecentBean> = []
  @State currentTime: number = 0

  build() {
    Column() {
      Stack() {
        Image($r('app.media.draw_content_actionbar_bg_3'))
          .width("100%")
          .height('100%')
        Column() {

          Text('聊天')
            .fontSize('18fp')
            .fontColor(Color.White)

          Row() {
            Image($r('app.media.icon_search'))
              .width('17vp')
              .height('17vp')
              .margin({ left: '12vp' })
            Text('搜索')
              .fontSize('12fp')
              .margin({ left: '12vp' })
              .fontColor(0x99ffffff)
              .width('100%')
          }
          .backgroundColor(Color.Red)
          .backgroundColor(0x33ffffff)
          .margin({ left: '12vp', top: '8.5vp', right: '12vp', bottom: '12vp' })
          .borderRadius('17vp')
          .height('31vp')
        }

      }.height(`${display.getDefaultDisplaySync().width * 0.2666}px`)
      .align(Alignment.Bottom)

      if (this.recentList.length <= 0) {
        Column() {
          Image($r('app.media.icon_search_empty'))
            .fitOriginalSize(true)
          Text('暂无聊天信息,添加球友撩起')
            .margin({ top: '15vp' })
            .fontColor(0xff91939A)
            .fontSize('15fp')
        }
        .height('80%')
        .width('100%')
        .justifyContent(FlexAlign.Center)
      } else {
        List() {
          ForEach(this.recentList, (item: RecentBean) => {
            ListItem() {
              this.buildRecentItem(item)
            }
          })
        }
      }
    }.align(Alignment.TopStart)
  }

  @Builder
  buildRecentItem(item: RecentBean) {
    Stack() {
      if (item.is_top == 1) {
        Divider().color('#f6f6f6')
          .strokeWidth('70vp')
          .width('100%')
          .height('100%')
      }
      Row() {
        RelativeContainer() {
          Badge({ count: item.unread_count, maxCount: 99, style: {
            fontSize: '11fp', color: Color.White, badgeColor: Color.Red
          } }) {
            Image(item.avatar)
              .width('49vp')
              .height('49vp')
              .borderRadius('24.5vp')
          }.alignRules({
            top: { anchor: "__container__", align: VerticalAlign.Top },
            left: { anchor: "__container__", align: HorizontalAlign.Start }
          })
          .id('ivAvatar')

          if (item.isOnline == 1)
            Circle()
              .width('6vp')
              .height('6vp')
              .fill(0xff0CFF00)
              .stroke(Color.White)
              .strokeWidth('1vp')
              .alignRules({
                bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
                right: { anchor: "__container__", align: HorizontalAlign.End }
              })
              .margin({ bottom: '3vp', right: '3vp' })
              .id('idOnLine')
        }.width('49vp')
        .height('49vp')
        .margin({ left: '12vp' })

        Column() {
          Text(item.name)
            .fontSize('15fp')
            .fontColor(0xff333333)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: '5vp' })
            .maxLines(1)
          Blank()

          Text(item.content)
            .fontSize('13fp')
            .fontColor(0xff999999)
            .margin({ bottom: '5vp' })
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
        }
        .height('49vp')
        .margin({ left: '12vp' })
        .alignItems(HorizontalAlign.Start)
        .width('60%')

        Blank()

        Column() {
          Text(CommonUtil.parseTime(this.currentTime - item.timestamp, item.timestamp))
            .fontSize('13fp')
            .fontColor(0xff999999)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: '5vp' })
            .maxLines(1)

          Blank()
          if (item.is_disturb == 1)
            Image($r('app.media.icon_msg_disturb'))
              .width('15vp')
              .height('15vp')
              .margin({ bottom: '5vp' })

        }.height('49vp')
        .margin({ right: '12vp' })
        .alignItems(HorizontalAlign.End)

      }.height('100%')
      .width('100%')

      Divider().strokeWidth(1).color('#F1F3F5')
        .margin({ left: '73vp' })
    }
    .height('70vp')
    .width('100%')
    .align(Alignment.Bottom)
    .onClick(() => {
      router.pushUrl({ url: "p2p/P2PPage", params: {
        'type': item.chat_type,
        'id': item.chatId
      } })
    })
    .gesture(LongPressGesture().onAction(() => {
      promptAction.showToast({ message: "获取到长按事件", duration: 500 })
    }))
  }

  aboutToAppear() {
    UserViewModel.getRecentList()?.then((recents) => {
      if (recents != null && recents.length > 0) {
        this.recentList = recents
      } else {
        this.recentList = []
      }
    }).catch(() => {
      this.recentList = []
    })

    systemDateTime.getCurrentTime(false).then((time: number) => {
      this.currentTime = time / 1000
    })
  }
}