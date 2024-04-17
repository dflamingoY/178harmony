import display from '@ohos.display'
import systemDateTime from '@ohos.systemDateTime'
import router from '@ohos.router'
import { MsgBean, RecentBean } from '../data/MsgBean'
import CommonUtil from '../utils/CommonUtil'
import UserViewModel from './UserViewModel'
import promptAction from '@ohos.promptAction'
import IConstant from '../utils/IConstant'
import emitter from '@ohos.events.emitter'
import Dao from '../db/Dao'

@Entry
@Component
export struct ChatPage {
  @State recentList: Array<RecentBean> = []
  @State currentTime: number = 0
  @State pageNumber: number = 0

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
              .alt(item.chat_type == IConstant.GROUP ? $r('app.media.icon_default_group_avatar') : $r('app.media.icon_default_avatar'))
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

          Text(this.getContentType(item.content, item.content_type))
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

  private getContentType(content: string, content_type: string): string {
    switch (content_type) {
      case 'img':
        return "[图片]";
      case 'voice':
        return '[语音]';
      case 'video':
        return '[视频]';
      case 'file':
        return '[文件]';
      case 'group_notice':
        return '[群公告]';
      case 'VOICE_CALL':
        return '[语音通话]';
      default:
        return content;
    }
  }

  aboutToAppear() {
    try {
      UserViewModel.getRecentList()?.then((recents) => {
        if (recents != null && recents.length > 0) {
          this.recentList = recents
        } else {
          this.recentList = []
        }
      }).catch(() => {
        this.recentList = []
      })
    } catch (e) {
    }

    systemDateTime.getCurrentTime(false).then((time: number) => {
      this.currentTime = time / 1000
    })
    this.registerWs()
  }

  private registerWs() {
    emitter.on({ eventId: IConstant.WS_MSG_ID }, (event) => {
      //更新当条消息
      let msg: MsgBean = JSON.parse(event.data.data)
      msg.listId = msg.type + (IConstant.GROUP == msg.type || msg.from == globalThis.uid ? msg.to : msg.from)
      let find = this.recentList.find((item) => {
        return item.listId == msg.listId
      })
      if (find && find != null) {
        find.content = msg.content
        find.content_type = msg.content_type
        find.timestamp = msg.timestamp
        find.remark = msg.remark
        find.mid = msg.mid
        find.unread_count = find.unread_count + 1
        this.recentList = [...this.recentList]
        Dao.getRdbModel()?.updateRecent(find)
      } else {
        let recent = new RecentBean()
        recent.listId = msg.listId
        recent.content = msg.content
        recent.content_type = msg.content_type
        recent.sub_type = msg.sub_type
        recent.chat_type = msg.type
        recent.timestamp = msg.timestamp
        recent.mid = msg.mid
        if (msg.from == globalThis.uid || msg.type == IConstant.GROUP) {
          recent.name = msg.to_name
          recent.avatar = msg.to_avatar
          recent.chatId = msg.to
        } else {
          recent.name = msg.from_name_ios
          recent.avatar = msg.from_avatar
          recent.chatId = msg.from
        }
        recent.unread_count = 1
        //插入数据
        this.recentList.unshift(recent)
        Dao.getRdbModel()?.insertRecent(recent)
      }
    })
  }

  aboutToDisappear() {
    emitter.off(IConstant.WS_MSG_ID)
  }
}