import display from '@ohos.display'
import systemDateTime from '@ohos.systemDateTime'
import router from '@ohos.router'
import { MsgBean, RecentBean } from '../data/MsgBean'
import CommonUtil from '../utils/CommonUtil'
import UserViewModel from './UserViewModel'
import IConstant from '../utils/IConstant'
import emitter from '@ohos.events.emitter'
import { DialogRecentChat } from '../dialog/DialogRecentChat'
import IColors from '../utils/IColors'
import LogUtil from '../utils/LogUtil'

//最近聊天列表
@Component
export struct ChatPage {
  @State recentList: Array<RecentBean> = []
  @State currentTime: number = 0
  @State pageNumber: number = 0
  @State operatorRecent: RecentBean | null = null

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
    .backgroundColor(item.is_top == 1 ? IColors.color91939A : Color.White)
    .align(Alignment.Bottom)
    .onClick(() => {
      router.pushUrl({ url: "p2p/P2PPage", params: {
        'type': item.chat_type,
        'id': item.chatId
      } })
    })
    .gesture(LongPressGesture().onAction(() => {
      this.operatorRecent = item
      this.dialogController.open()
    }))
  }

  dialogController: CustomDialogController = new CustomDialogController({
    builder: DialogRecentChat({
      recentBean: this.operatorRecent,
      onTop: (recent: RecentBean) => {
        this.topChat(recent)
      },
      onDelete: (recent: RecentBean) => {
        this.deleteChat(recent)
      }
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: false,
    offset: { dx: 0, dy: -20 },
    gridCount: 4
  })

  private topChat(recent: RecentBean) {
    recent.is_top = recent.is_top == 1 ? 0 : 1
    //获取数据 从新插入
    /* let tempList = this.recentList.filter((item) => {
       return item.listId != recent.listId
     })
     if (recent.is_top == 1) {
       tempList.unshift(recent)
       this.recentList = tempList
     } else { //排序
       // tempList.sort()
     }*/
    UserViewModel.updateRecent(recent)
    this.sortList()
  }

  private sortList() {
    let temp = [...this.recentList].sort((a, b) => {
      if (a.is_top === 1 && b.is_top === 1) {
        return b.timestamp - a.timestamp
      } else if (a.is_top === 1 || b.is_top === 1) {
        if (a.is_top === 1) {
          return -1
        } else {
          return 1
        }
      } else {
        return b.timestamp - a.timestamp
      }
    })
    this.recentList = temp
  }

  private deleteChat(recent: RecentBean) {
    UserViewModel.deleteRecent(recent.listId)
    this.recentList = this.recentList.filter((item) => {
      return item.listId != recent.listId
    })
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
    this.loadData()
    systemDateTime.getCurrentTime(false).then((time: number) => {
      this.currentTime = time / 1000
    })
    this.registerWs()
  }

  private loadData() {
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
  }

  private registerWs() {
    //消息通知
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
        this.recentList = this.recentList.filter((item) => {
          return item.listId != msg.listId
        })
        this.recentList.unshift(find)
        UserViewModel.updateRecent(find)
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
          recent.chatId = `${msg.from}`
        }
        recent.unread_count = 1
        //插入数据
        this.recentList.unshift(recent)
        UserViewModel.insertRecent(recent)
      }
    })
    //聊天单挑通知
    emitter.on({ eventId: IConstant.RECENT_UPDATE_ID }, (event) => {
      let find = this.recentList.find((item) => {
        return item.chat_type == event.data.type && item.chatId == event.data.id
      })
      if (find) {
        find.unread_count = 0
        find.readMid = event.data.readId
        this.recentList = [...this.recentList]
      }
    })
    //内容操作
    emitter.on({ eventId: IConstant.MSG_OPERATOR_ID }, (event) => {
      if (event.data.type == 'message_froward') {
        let find = this.recentList.find((item) => {
          return item.chat_type == event.data.chatType && item.chatId == event.data.id
        })
        if (find) {
          find.content = event.data.content
          find.content_type = event.data.content_type
          find.unread_count = find.unread_count + event.data.count
          this.recentList = this.recentList.filter((item) => {
            return item.listId != find.listId
          })
          this.recentList.unshift(find)
        } else { //新建一条数据
          let recent = new RecentBean()
          recent.listId = event.data.chatType + event.data.id
          recent.content = event.data.content
          recent.content_type = event.data.content_type
          recent.sub_type = event.data.sub_type
          recent.chat_type = event.data.chatType
          recent.timestamp = event.data.timestamp
          recent.name = event.data.name
          recent.avatar = event.data.avatar
          recent.chatId = event.data.id
          recent.unread_count = event.data.count
          //插入数据
          this.recentList.unshift(recent)
          UserViewModel.insertRecent(recent)
        }
      }
      else if (event.data.type == 'syncLoad') {
        this.loadData()
      }
    })
    emitter.on({ eventId: IConstant.LOGIN_EVENT_ID }, () => {
      LogUtil.d("West", '检测到登陆或取消登陆的消息  ' + globalThis.user)
      if (!globalThis.user || globalThis.user == null) {

      } else {
        this.loadData()
      }
    })
  }

  aboutToDisappear() {
    emitter.off(IConstant.WS_MSG_ID)
    emitter.off(IConstant.RECENT_UPDATE_ID)
    emitter.off(IConstant.MSG_OPERATOR_ID)
    emitter.off(IConstant.LOGIN_EVENT_ID)
  }
}