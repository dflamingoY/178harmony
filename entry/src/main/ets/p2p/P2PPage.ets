import router from '@ohos.router'
import systemDateTime from '@ohos.systemDateTime'
import promptAction from '@ohos.promptAction'
import { GroupBean } from '../data/GroupData'
import { MsgBean } from '../data/MsgBean'
import { UserBean } from '../data/user'
import Dao from '../db/Dao'
import UserViewModel from '../pages/UserViewModel'
import CommonUtil from '../utils/CommonUtil'
import IColors from '../utils/IColors'
import IConstant from '../utils/IConstant'
import { ChatMenu } from '../widget/ChatMenu'
import { ChatButtonState } from '../data/ChatButtonState'
import { ChatEmoji } from '../widget/ChatEmoji'

@Entry
@Component
export struct P2PPage {
  @State isRefreshing: boolean = false
  @State msgList: Array<MsgBean> = []
  @State unreadCount: number = 1
  @State name: string = ''
  @State avatarUrl: string = ''
  private type: string = IConstant.FRIEND
  private chatId: string = ''
  @State userInfo: UserBean | null = null
  private groupInfo: GroupBean | null = null
  @State currentTime: number = 0
  @State ownerId: string | null = null //群主id
  @State managerUids: Array<string> | null = null //管理员数组
  @State msgContent: string = ''
  @State chatMenuState: ChatButtonState = ChatButtonState.Default

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Image($r('app.media.icon_chat_bg'))
        .height('48vp')
        .width('100%')
        .backgroundColor(Color.Black)
        .objectFit(ImageFit.Cover)
      Flex({ direction: FlexDirection.Column }) {
        Stack({ alignContent: Alignment.Start }) {
          Column() {
            Text(this.name)
              .fontColor(Color.White)
              .textAlign(TextAlign.Center)
              .fontSize('17fp')
              .margin({ top: '5vp' })
            if (this.type == IConstant.FRIEND && this.userInfo != null) {
              Blank()
              Row() {
                Circle({ width: '6vp', height: '6vp' })
                  .fill(this.userInfo.state == 'offline' ? 0xBDBEC2 : 0x0CFF00)
                Text(CommonUtil.getUserState(this.userInfo.state, this.currentTime - this.userInfo.logout_timestamp))
                  .fontColor(0x5B5E68)
                  .fontSize('12fp')
                  .margin({ left: '12vp' })
              }.justifyContent(FlexAlign.Start).margin({ bottom: '5vp' })
            }
          }.width('100%').justifyContent(FlexAlign.Center)
          .height('100%')

          Row() {
            Image($r('app.media.icon_more'))
              .fitOriginalSize(true)
              .margin({ right: '15vp' })
              .onClick(() => {
                //跳转好友或者群的聊天设置
                if (this.type == IConstant.FRIEND) {
                  router.pushUrl({ url: 'p2p/friend/FriendChatConfig' })
                } else {
                  router.pushUrl({ url: 'p2p/group/GroupDetails' })
                }
              })
          }.justifyContent(FlexAlign.End)
          .width('100%')

          Badge({ count: this.unreadCount, maxCount: 99, style: {
            fontSize: '11fp', color: Color.White, badgeColor: Color.Red
          }, position: BadgePosition.Right }) {
            Image($r('app.media.icon_black_back'))
              .margin({ left: '25vp' })
              .height('21vp')
              .width('21vp')
              .onClick(() => {
                router.back()
              })
          }.margin({ left: '15vp' })
        }
        .width('100%')
        .height('48vp')

        Refresh({ refreshing: $$this.isRefreshing, offset: 20, friction: 100 }) {
          List() {
            ForEach(this.msgList, (item: MsgBean) => {
              ListItem() {
                this.buildMsgItem(item)
              }
            })
          }.height('100%')
        }.onRefreshing(() => {
          this.isRefreshing = true
        }).height('100%')

        Column() {
          RelativeContainer() {
            Image($r('app.media.icon_record_default'))
              .width('27vp')
              .height('27vp')
              .padding('2vp')
              .id('idRecord')
              .margin({ left: '12vp', top: '12vp' })
              .alignRules({
                top: { anchor: "__container__", align: VerticalAlign.Top },
                left: { anchor: "__container__", align: HorizontalAlign.Start }
              })
            TextArea({ text: this.msgContent })
              .fontColor(IColors.color1R1E20)
              .fontSize('15fp')
              .onChange((value: string) => {
                this.msgContent = value
              })
              .margin({ left: '10vp', right: '10vp', top: '10vp' })
              .id('idInputContent')
              .alignRules({
                top: { anchor: "__container__", align: VerticalAlign.Top },
                left: { anchor: "idRecord", align: HorizontalAlign.End },
                right: { anchor: 'idEmoji', align: HorizontalAlign.Start }
              })
              .backgroundColor(IColors.colorF3F3F5)
              .borderRadius('19vp')
            Image($r('app.media.icon_emoji'))
              .width('27vp')
              .height('27vp')
              .objectFit(ImageFit.Contain)
              .padding('2vp')
              .id('idEmoji')
              .alignRules({
                top: { anchor: "idSendOrMenu", align: VerticalAlign.Top },
                right: { anchor: "idSendOrMenu", align: HorizontalAlign.Start },
                bottom: { anchor: 'idSendOrMenu', align: VerticalAlign.Bottom }
              })
              .margin({ right: '6vp', top: '12vp' })
              .onClick(() => {
                if (this.chatMenuState == ChatButtonState.Emoji) {
                  this.chatMenuState = ChatButtonState.Default
                } else {
                  this.chatMenuState = ChatButtonState.Emoji
                }
              })
            Row() {
              if (this.msgContent.length > 0) {
                Text('发送')
                  .fontSize('15fp')
                  .fontColor(IColors.colorFED8BD)
                  .width('52vp')
                  .textAlign(TextAlign.Center)
                  .height('36vp')
                  .backgroundColor(IColors.color1R1E20)
                  .borderRadius('5vp')
                  .onClick(() => {
                    this.sendMsg()
                  })
              } else {
                Image($r('app.media.icon_add_menu'))
                  .width('27vp')
                  .height('27vp')
                  .padding('2vp')
                  .onClick(() => {
                    if (this.chatMenuState == ChatButtonState.Menu) {
                      this.chatMenuState = ChatButtonState.Default
                    } else {
                      this.chatMenuState = ChatButtonState.Menu
                    }
                  })
              }
            }.alignRules({
              top: { anchor: "__container__", align: VerticalAlign.Top },
              right: { anchor: "__container__", align: HorizontalAlign.End }
            }).id('idSendOrMenu').height('36vp')
            .margin({ right: '12vp', top: '10vp' })
          }
          .width('100%')
          .backgroundColor(Color.White)
          .borderRadius({ topLeft: '10vp', topRight: '10vp' })
          .height('58vp')

          if (this.chatMenuState == ChatButtonState.Menu) {
            ChatMenu()
          }
          else if (this.chatMenuState == ChatButtonState.Emoji) {
            ChatEmoji()
          } else {

          }
        }
      }
    }
    .backgroundColor(0xffF6f6f6)
  }

  @Builder
  private buildMsgItem(item: MsgBean) {
    Column() {
      Text(CommonUtil.parseTime(this.currentTime - item.timestamp, item.timestamp))
        .fontSize(IColors.color999)
        .fontSize('12fp').margin({ top: '8vp' })
      if (item.content_type == "notice" || item.sub_type == "notice") {
        Text(item.content).fontSize('12fp')
          .fontColor(IColors.color999)
          .margin({ top: '12vp', bottom: '12vp' })
      } else {
        Flex({ direction: FlexDirection.Row }) {
          if (item.from != globalThis.uid) { //自己发的消息
            Image(item.from_avatar)
              .height('37vp')
              .width('37vp')
              .alt($r('app.media.icon_default_avatar'))
              .borderRadius('18.5vp')
              .margin({ left: '12vp', top: '12vp' })
              .onClick(() => {
                router.pushUrl({ url: 'pages/contact/UserDetailsPage', params: {
                  uid: item.from
                } })
              })
          }
          Column() {
            if (this.type == IConstant.GROUP) {
              //有好友备注， 先展示好友备注， 群优先展示群备注。最后是原昵称
              Row() {
                if (item.from != globalThis.uid) {
                  Text(item.from == this.ownerId ? "群主" : this.managerUids != null && this.managerUids.some((from) => {
                    return item.from == from
                  }) ? "管理员" : "普通")
                    .fontSize('11fp')
                    .fontColor(Color.White)
                    .borderRadius('4vp')
                    .margin({ left: '8vp', right: '8vp' })
                    .backgroundColor(item.from == this.ownerId ? 0xffE64545 : this.managerUids != null && this.managerUids.some((from) => {
                      return item.from == from
                    }) ? 0xff438FE5 : 0xffCB8656)
                }
                Text(item.from_name_ios != null && item.from_name_ios != "" ? item.from_name_ios : item.from_name_remark != null && item.from_name_remark != "" ? item.from_name_remark : item.from_name)
                  .fontColor(IColors.color91939A)
                  .fontSize('11fp')
                if (item.from == globalThis.uid) {
                  Text(item.from == this.ownerId ? "群主" : this.managerUids != null && this.managerUids.some((from) => {
                    return item.from == from
                  }) ? "管理员" : "普通")
                    .fontSize('11fp')
                    .fontColor(Color.White)
                    .borderRadius('4vp')
                    .margin({ left: '8vp', right: '8vp' })
                    .backgroundColor(item.from == this.ownerId ? 0xffE64545 : this.managerUids != null && this.managerUids.some((from) => {
                      return item.from == from
                    }) ? 0xff438FE5 : 0xffCB8656)
                }
              }.justifyContent(item.from == globalThis.uid ? FlexAlign.End : FlexAlign.Start)
            } else {
              Divider().color(Color.Transparent).height('18vp')
            }
            Column() { //内容展示区
              if (item.content_type == "img") {
                Image(item.content)
                  .width('154vp')
                  .height('86vp')
                  .borderRadius('6vp')
              } else if (item.content_type == "voice") {
                Row() {
                  Image(item.isPlay ? $r('app.media.icon_audio_play_right_pause') : $r('app.media.icon_audio_play_right_start'))
                    .width('23vp')
                    .height('23vp')
                    .margin({ left: '8vp' })

                  Divider().width('50vp')
                    .color(Color.Transparent)

                  Text(item.remark??"1'")
                    .fontColor(item.from == globalThis.uid ? Color.White : IColors.colorOrange)
                    .margin({ right: '8vp' })
                    .fontSize('14fp')
                }.height('36vp')
                .backgroundColor(item.from == globalThis.uid ? IColors.color1R1E20 : Color.White)
                .borderRadius('6vp')
              } else if (item.content_type == "video") {
                Stack({ alignContent: Alignment.Center }) {
                  Image(item.remark)
                    .width('100%')
                    .height('100%')
                    .borderRadius('6vp')

                  Rect().borderRadius('6vp')
                    .backgroundColor(0x7f000000)
                    .fill(0x7f000000)

                  Image($r('app.media.icon_video_play'))
                    .width('34vp')
                    .height('34vp')
                }.width('154vp')
                .height('86vp')
                .borderRadius('6vp')
              } else if (item.content_type == "file") {
                Flex({ direction: FlexDirection.Row }) {
                  if (item.from != globalThis.uid) {
                    Image(this.getFileType(item.remark))
                      .width('30vp')
                      .height('39vp')
                      .margin({ left: '8vp', top: '10vp' })
                  }
                  Column() {
                    Text(this.getFileName(item.remark))
                      .fontSize('12fp')
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .maxLines(2)
                      .margin({ top: '5vp', right: '10vp' })
                      .fontColor(item.from != globalThis.uid ? IColors.color1R1E20 : Color.White)
                    Blank()
                    Text(this.getFileSize(item.remark))
                      .fontSize('11fp')
                      .width('100%')
                      .textAlign(TextAlign.End)
                      .fontColor(IColors.color666)
                      .margin({ bottom: '5vp', right: '10vp' })

                  }.margin({ left: '8vp', right: '8vp' }).width('100%')

                  if (item.from == globalThis.uid) {
                    Image(this.getFileType(item.remark))
                      .width('30vp')
                      .height('39vp')
                      .margin({ left: '8vp', top: '10vp' })
                  }
                }.width('200vp')
                .height('59vp')
                .borderRadius('5vp')
                .backgroundColor(item.from == globalThis.uid ? IColors.color1R1E20 : Color.White)
              } else if (item.content_type == 'call' || item.content_type == 'VOICE_CALL') { //语音通话
                Row() {
                  if (item.from != globalThis.uid) {
                    Image($r('app.media.icon_chat_voice_from'))
                      .fitOriginalSize(true)
                  }

                  Text('语音通话')
                    .fontSize('14fp')
                    .margin({ left: '5vp', right: '5vp' })
                    .fontColor(item.from == globalThis.uid ? Color.White : IColors.color1R1E20)
                  if (item.from == globalThis.uid) {
                    Image($r('app.media.icon_chat_voice_to'))
                      .fitOriginalSize(true)
                  }

                }.borderRadius('5vp')
                .backgroundColor(item.from == globalThis.uid ? IColors.color1R1E20 : Color.White)
                .padding({ left: '8vp', top: '10vp', right: '8vp', bottom: '10vp' })

              } else { //所有未处理的类型默认为txt文本
                Text(item.content)
                  .fontSize('14fp')
                  .padding({ left: '8vp', top: '10vp', right: '8vp', bottom: '10vp' })
                  .fontColor(item.from == globalThis.uid ? Color.White : IColors.color1R1E20)
                  .borderRadius('5vp')
                  .backgroundColor(item.from == globalThis.uid ? IColors.color1R1E20 : Color.White)
              }
            }
            .width('80%')
            .margin({ left: '8vp', right: '8vp', top: '4vp' })
            .alignItems(item.from == globalThis.uid ? HorizontalAlign.End : HorizontalAlign.Start)
            .gesture(LongPressGesture().onAction(() => {
              promptAction.showToast({ message: "获取到长按事件", duration: 500 })
            }))
          }
          .margin({ top: '12vp' })
          .width('100%')
          .alignItems(item.from == globalThis.uid ? HorizontalAlign.End : HorizontalAlign.Start)

          if (item.from == globalThis.uid) {
            Image(item.from_avatar)
              .height('37vp')
              .width('37vp')
              .alt($r('app.media.icon_default_avatar'))
              .borderRadius('18.5vp')
              .margin({ right: '12vp', top: '12vp' })
              .onClick(() => {
                router.pushUrl({ url: 'pages/contact/UserDetailsPage', params: {
                  uid: item.from
                } })
              })
          }
        }.width('100%')
      }
    }.justifyContent(FlexAlign.Center).width('100%')
  }

  private getFileType(remark: string): Resource {
    try {
      let fileInfo = JSON.parse(remark)
      if (fileInfo['fileType'] == "word") {
        return $r('app.media.icon_word')
      }
      else if (fileInfo['fileType'] == "excel") {
        return $r('app.media.icon_excel')
      }
      else if (fileInfo['fileType'] == "ppt") {
        return $r('app.media.icon_ppt')
      }
      else if (fileInfo['fileType'] == "pdf") {
        return $r('app.media.icon_pdf')
      }
      else if (fileInfo['fileType'] == "txt") {
        return $r('app.media.icon_txt')
      }
      else {
        return $r('app.media.icon_undefine')
      }
    } catch (e) {
      return $r('app.media.icon_undefine')
    }
  }

  private getFileName(remark: string) {
    try {
      let fileInfo = JSON.parse(remark)
      return fileInfo['fileName']
    } catch (e) {
      return 'unKnow'
    }
  }

  private getFileSize(remark: string) {
    try {
      let fileInfo = JSON.parse(remark)
      return fileInfo['fileSize']
    } catch (e) {
      return 'unKnow'
    }
  }

  private sendMsg() {
    let msgBean = new MsgBean()
    msgBean.content_type = 'txt'
    msgBean.content = this.msgContent
    msgBean.listId = this.type + this.chatId
    msgBean.sub_type = "message"
    msgBean.to = this.chatId
    msgBean.from = globalThis.uid
    msgBean.from_name = globalThis.user['nickname']
    msgBean.from_avatar = globalThis.user['avatar']
    // msgBean.timestamp=
    this.msgList.push(msgBean)

    this.msgContent = ''
  }

  aboutToAppear() {
    let params = router.getParams() as Record<string, object>
    let type = params.type as unknown as string
    let id = params.id
    this.chatId = id as unknown as string
    this.type = type
    systemDateTime.getCurrentTime(false).then((time: number) => {
      this.currentTime = time
    })
    Dao.getRdbModel()?.getMsgByChatId(`${type + id}`, 20).then((msg) => {
      msg.forEach((item) => {
        this.msgList.push(item)
      })
    }).catch((e: Error) => {

    })
    if (type == IConstant.FRIEND) {
      UserViewModel.getFriendInfo(id.toString()).then((user) => {
        this.name = user.remark == null || user.remark == '' ? user.nickname : user.remark
        this.userInfo = user
      })
    } else {
      UserViewModel.getGroupInfo(id.toString()).then((group) => {
        this.name = group.group.groupname
      })
    }

  }
}