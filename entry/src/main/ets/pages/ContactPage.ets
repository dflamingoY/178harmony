import display from '@ohos.display'
import systemDateTime from '@ohos.systemDateTime'
import router from '@ohos.router'
import { UserBean } from '../data/user'
import CommonUtil from '../utils/CommonUtil'
import LogUtil from '../utils/LogUtil'
import UserViewModel from './UserViewModel'
import IConstant from '../utils/IConstant'
import emitter from '@ohos.events.emitter'

@Entry
@Component
export struct ContactPage {
  @State unreadCount: number = 0
  @State friendLit: Array<UserBean> = []
  @State currentTime: number = 0

  build() {

    Flex({ direction: FlexDirection.Column }) {
      Stack() {
        Image($r('app.media.draw_content_actionbar_bg_3'))
          .width("100%")
          .height('100%')
        Column() {
          Text('通讯录')
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

      Row() {
        this.buildFriendCard()
        Divider()
          .vertical(true)
          .height(22)
          .color('#C7C7C7')
          .opacity(0.6)
        this.buildOtherCard('群聊', $r('app.media.icon_contact_group_card'), 1)
        Divider()
          .vertical(true)
          .height(22)
          .color('#C7C7C7')
          .opacity(0.6)

        this.buildOtherCard('标签', $r('app.media.icon_contact_tag_card'), 2)
      }
      .height("88vp")
      .margin({ left: "12vp", right: '12vp', top: '12vp' })
      .borderRadius('18vp')
      .borderStyle(BorderStyle.Solid)
      .borderWidth('1vp')
      .borderColor(0xf3f3f5)
      //好友列表
      List({}) {
        ForEach(this.friendLit, (item: UserBean) => {
          ListItem() {
            this.buildFriendItem(item)
          }.onClick(() => {
            router.pushUrl({ url: 'pages/contact/FriendDetailsPage', params: {
              uid: item.uid
            } })
          })
        })
      }
    }.align(Alignment.TopStart).height('100%')
    .width("100%")
  }

  @Builder
  private buildFriendItem(item: UserBean) {
    Row() {
      Image(item.avatar)
        .height('35vp')
        .width('35vp')
        .borderRadius('17.5vp')
        .alt($r('app.media.icon_default_avatar'))
        .margin({ left: '12vp' })

      Column() {
        Text(item.remark == "" ? item.nickname : item.remark)
          .fontSize('13fp')
          .fontColor("#1E1E20")
          .textAlign(TextAlign.Start)
          .width('100%')
        Row() {
          Circle({ width: '6vp', height: '6vp' })
            .fill(item.state == 'offline' ? 0xBDBEC2 : 0x0CFF00)

          Text(CommonUtil.getUserState(item.state, this.currentTime - item.logout_timestamp))
            .fontColor(0x5B5E68)
            .fontSize('12fp')
            .margin({ left: '12vp' })
        }.justifyContent(FlexAlign.Start)
        .width('100%')

      }.justifyContent(FlexAlign.SpaceBetween)
      .margin({ left: '12vp' })
      .height('35vp')
      .width('50%')

      Blank()
      Text('去聊天')
        .fontSize('12fp')
        .fontColor(0xfed8bd)
        .width("71vp")
        .height('29vp')
        .textAlign(TextAlign.Center)
        .borderRadius('15vp')
        .backgroundColor(0x1e2024)
        .margin({ right: '12vp' })
        .onClick(() => {
          router.pushUrl({ url: "p2p/P2PPage", params: {
            'type': IConstant.FRIEND,
            'id': item.uid.toString()
          } })
        })
    }.width('100%')
    .height('60vp')
  }

  @Builder
  private buildFriendCard() {
    Badge({ count: this.unreadCount, maxCount: 99, style: {
      fontSize: '11fp', color: Color.White, badgeColor: Color.Red
    } }) {
      Column() {
        Image($r('app.media.icon_contact_frinds_card'))
          .width('35vp')
          .margin({ top: '12vp' })
          .height('35vp')
        Text('聊天').fontColor(0xff1E1E20)
          .fontSize('13fp')
          .margin({ bottom: '12vp' })
      }.onClick(() => {
        router.pushUrl({ url: 'pages/contact/FriendRequestPage' })
      }).width('100%').height('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }.width('33%').height('100%')
  }

  @Builder
  private buildOtherCard(title: string, res: Resource, type: number) {
    Column() {
      Image(res)
        .width('35vp')
        .margin({ top: '12vp' })
        .height('35vp')

      Text(title)
        .fontSize('13fp')
        .margin({ bottom: '12vp' })
        .fontColor(0xff1E1E20)

    }.justifyContent(FlexAlign.SpaceBetween).width('33%').height('100%')
    .onClick(() => {
      router.pushUrl({ url: type == 1 ? 'pages/contact/GroupListPage' : 'pages/contact/TagPage' })
    })

  }

  getFriend() {
    UserViewModel.getFriendList().then((data: Array<UserBean>) => {
      this.friendLit = data
    }).catch((err: Error) => {
      this.getLocal()
      LogUtil.d("West", `${err}`)
    })
  }

  getLocal() {
    UserViewModel.getLocalFriend().then((data: Array<UserBean>) => {
      this.friendLit = data
    }).catch((err: Error) => {
      LogUtil.d("West", `${err}`)
    })
  }

  getCurrentTime() {
    systemDateTime.getCurrentTime(false).then((time: number) => {
      this.currentTime = time
    })
  }

  aboutToAppear() {
    //获取好友列表
    emitter.on(this.innerEvent, (event) => {
      if (globalThis.user != null) {
        this.getFriend()
      }
    })
    this.getFriend()
    this.getCurrentTime()
  }

  innerEvent = {
    eventId: IConstant.LOGIN_EVENT_ID
  }

  aboutToDisappear() {
    emitter.off(IConstant.LOGIN_EVENT_ID)
  }
}