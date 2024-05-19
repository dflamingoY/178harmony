import router from '@ohos.router'
import systemDateTime from '@ohos.systemDateTime'
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
import window from '@ohos.window'
import LogUtil from '../utils/LogUtil'
import emitter from '@ohos.events.emitter'
import util from '@ohos.util'
import { DialogPressMsg } from '../dialog/DialogPressMsg'

@Entry
@Component
export struct P2PPage {
  @State isRefreshing: boolean = false
  @State msgList: Array<MsgBean> = []
  @State unreadCount: number = 0
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
  @State phoneFocuseAble: boolean = true
  scroll = new Scroller()
  private queryId: number = -1

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
          List({ scroller: this.scroll }) {
            ForEach(this.msgList, (item: MsgBean, index: number) => {
              ListItem() {
                this.buildMsgItem(item, index + 1 < this.msgList.length ? this.msgList[index-1] : null)
              }
            })
          }.height('100%')

        }.onRefreshing(() => {
          this.isRefreshing = true
          this.getChatList()
        }).layoutWeight(1)
        Column() {
          RelativeContainer() {
            /* Image($r('app.media.icon_record_default'))
               .width('27vp')
               .height('27vp')
               .padding('2vp')
               .id('idRecord')
               .margin({ left: '12vp', top: '12vp' })
               .alignRules({
                 top: { anchor: "__container__", align: VerticalAlign.Top },
                 left: { anchor: "__container__", align: HorizontalAlign.Start }
               })*/
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
                left: { anchor: "__container__", align: HorizontalAlign.Start },
                right: { anchor: 'idSendOrMenu', align: HorizontalAlign.Start }
              })
              .focusable(this.phoneFocuseAble)
              .onClick(() => {
                this.phoneFocuseAble = true
              })
              .onTouch((event) => {
                if (event.type == TouchType.Down) {
                  this.chatMenuState = ChatButtonState.Default
                }
              })
              .backgroundColor(IColors.colorF3F3F5)
              .borderRadius('19vp')
            /*Image($r('app.media.icon_emoji'))
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
              })*/
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
              } /*else {
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
                    this.phoneFocuseAble = false
                  })
              }*/
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

          /* if (this.chatMenuState == ChatButtonState.Menu) {
             ChatMenu()
           }
           else if (this.chatMenuState == ChatButtonState.Emoji) {
             ChatEmoji()
           }*/
        }
      }
    }
    .backgroundColor(0xffF6f6f6)
  }

  @Builder
  private buildMsgItem(item: MsgBean, next: MsgBean | null) {
    Column() {
      if (next == null || !CommonUtil.isCloseEnough(item.timestamp - next.timestamp))
        Text(CommonUtil.parseTime(this.currentTime - item.timestamp, item.timestamp))
          .fontColor(IColors.color91939A)
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
                router.pushUrl({ url: 'pages/contact/FriendDetailsPage', params: {
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
              Divider().color(Color.Transparent).height('8vp')
            }

            Flex({
              direction: FlexDirection.Row,
              justifyContent: (item.from == globalThis.uid ? FlexAlign.End : FlexAlign.Start),
              alignItems: ItemAlign.Center
            }) {
              if (item.msgStatus == 2) {
                Image($r('app.media.nim_ic_failed'))
                  .width('20vp')
                  .height('20vp')
                  .margin({ right: '8vp' })
                  .onClick(() => { //重新发送
                    item.msgStatus = 1
                    UserViewModel.sendMsg(item)
                  })
              } else if (item.msgStatus == 1) {
                LoadingProgress()
                  .width('20vp')
                  .color(IColors.colorOrange)
                  .height('20vp')
                  .margin({ right: '8vp' })
              }
              Column() { //内容展示区
                if (item.content_type == "img") {
                  Image(item.content)
                    .width('154vp')
                    .height('86vp')
                    .borderRadius('6vp')
                    .onClick(() => {
                      router.pushUrl({ url: 'p2p/ShowMediaPage', params: {
                        'listId': this.type + this.chatId,
                        'id': item.id
                      } })
                    })
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
                  .onClick(() => {
                    router.pushUrl({ url: 'p2p/ShowMediaPage', params: {
                      'listId': this.type + this.chatId,
                      'id': item.id
                    } })
                  })
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
              .gesture(LongPressGesture().onAction(() => {
                this.operatorBean = item
                this.dialogController.open()
              }))
            }
            .width('80%')
            .margin({ left: '8vp', right: '8vp', top: '4vp' })

            if (this.type == IConstant.FRIEND && globalThis.uid == item.from && item.msgStatus == 0 && item.content_type != 'VOICE_CALL') {
              Text(item.isRead == 0 ? '未读' : '已读')
                .fontSize('13fp')
                .margin({ right: '12vp', top: '10vp' })
                .fontColor(item.isRead == 0 ? IColors.colorOrange : IColors.color999)
            }
          }
          .margin({ top: '12vp' })
          .width('100%')
          // .backgroundColor(0x7f1ff199)
          .alignItems(item.from == globalThis.uid ? HorizontalAlign.End : HorizontalAlign.Start)

          if (item.from == globalThis.uid) {
            Image(item.from_avatar)
              .height('37vp')
              .width('37vp')
              .alt($r('app.media.icon_default_avatar'))
              .borderRadius('18.5vp')
              .margin({ right: '12vp', top: '12vp' })
              .onClick(() => {
                router.pushUrl({ url: 'pages/contact/FriendDetailsPage', params: {
                  uid: item.from
                } })
              })
          }
        }.width('100%')
      }
    }.justifyContent(FlexAlign.Center).width('100%')
  }

  @State operatorBean: MsgBean | null = null
  dialogController: CustomDialogController = new CustomDialogController({
    builder: DialogPressMsg({
      msgBean: this.operatorBean,
      onRevoke: (msg) => {
        this.onRevoke(msg)
      },
      onCollect: (msg) => {
        this.onCollect(msg)
      },
      onDelete: (msg) => {
        this.onDelete(msg)
      }
    }),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    customStyle: false,
    offset: { dx: 0, dy: -20 },
    gridCount: 4
  })

  private onRevoke(msg: MsgBean) {
    if (msg != null) {
      UserViewModel.revoke(this.operatorBean.mid, '1', this.chatId)
    }
  }

  private onCollect(msg: MsgBean) {

  }

  private onDelete(msg: MsgBean) {
    AlertDialog.show({
      message: '是否删除该消息？',
      primaryButton: {
        value: '取消',
        fontColor: IColors.color91939A,
        action: () => {

        }
      },
      secondaryButton: {
        value: '删除',
        fontColor: IColors.colorOrange,
        action: () => {
          if (msg != null) {
            Dao.getRdbModel()
              .executeSql(`DELETE FROM msg WHERE mid = ${msg.mid.includes(':') ? `'${msg.mid}'` : msg.mid}`)
            this.filterRemove(msg.mid)
          }
        }
      }
    })
  }

  private filterRemove(mid: string) {
    let filter = this.msgList.filter((item) => {
      return item.mid != mid
    })
    this.msgList = filter
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

  private async sendMsg() {
    let msgBean = new MsgBean()
    msgBean.content_type = 'txt'
    msgBean.content = this.msgContent
    msgBean.listId = this.type + this.chatId
    msgBean.sub_type = "message"
    msgBean.to = this.chatId
    msgBean.type = this.type
    msgBean.from = globalThis.uid
    msgBean.from_name = globalThis.user['nickname']
    msgBean.from_avatar = globalThis.user['avatar']
    msgBean.sendId = util.generateRandomUUID(false) + ':' + msgBean.to //创建不重复的UUID
    msgBean.mid = msgBean.sendId
    msgBean.msgStatus = 1
    await systemDateTime.getCurrentTime(false).then((time) => {
      msgBean.timestamp = time / 1000
    })
    LogUtil.d("Dao", '本地生成sendId : ' + msgBean.sendId)
    Dao.getRdbModel().insertMsg(msgBean)
    this.msgList.push(msgBean)
    UserViewModel.sendMsg(msgBean)
    this.msgContent = ''
    this.scroll.scrollToIndex(this.msgList.length - 1)
  }

  onPageShow() {
    systemDateTime.getCurrentTime(false).then((time: number) => {
      this.currentTime = Math.ceil(time / 1000)
    })
  }

  aboutToAppear() {
    let params = router.getParams() as Record<string, object>
    let type = params.type as unknown as string
    let id = params.id
    this.chatId = id as unknown as string
    this.type = type
    this.getChatList()
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
    this.registerWs()
    this.registerMsgStatus()
    this.getUnreadCount()
  }

  private getUnreadCount() {
    UserViewModel.getUnreadCount().then((count) => {
      this.unreadCount = count
    })
  }

  private getChatList() {
    Dao.getRdbModel()?.getMsgByChatId(`${this.type + this.chatId}`, this.queryId).then((msg) => {
      this.msgList = msg.concat(this.msgList)
      if (this.queryId == -1) {
        try {
          this.scroll.scrollToIndex(this.msgList.length - 1)
          this.updateRecent(this.msgList[this.msgList.length - 1].id)
        } catch (e) {
        }
      }
      if (this.type == IConstant.FRIEND && this.msgList.length > 0 && this.queryId == -1) {
        let filter = this.msgList.filter((item) => {
          return item.from == this.chatId
        })
        if (filter.length > 0) {
          UserViewModel.sendReadReceipt(this.chatId, filter.pop().mid)
        }
      }
      if (msg.length > 0) {
        this.queryId = msg[0].id
      }
      this.isRefreshing = false
    }).catch((e: Error) => {
      this.isRefreshing = false
    })
  }

  //监听ws msgBean推送的消息
  private registerWs() {
    emitter.on({ eventId: IConstant.WS_MSG_ID }, (event) => {
      let msgBean: MsgBean = JSON.parse(event.data.data)
      msgBean.listId = msgBean.type + (IConstant.GROUP == msgBean.type || msgBean.from == globalThis.uid ? msgBean.to : msgBean.from)
      if (msgBean.listId != this.type + this.chatId) {
        this.getUnreadCount()
        return
      }
      if (msgBean.from == globalThis.uid) {
        //更新状态，没有此条就加入
        let emitMsg = this.msgList.find((item) => {
          return item.mid == msgBean.mid || item.sendId == msgBean.verify
        })
        if (emitMsg && emitMsg != null) {
          emitMsg = msgBean
        } else {
          this.msgList.push(msgBean)
        }
      } else {
        this.msgList.push(msgBean)
      }
      //更新本地最新的阅读的id 并更新未读书 获取该条消息的id
      this.queryMid(`${msgBean.mid}`)
    })
  }

  //处理消息相关的通用事件
  private registerMsgStatus() {
    emitter.on({ eventId: IConstant.MSG_OPERATOR_ID }, (event) => {
      if (event.data.type == 'revoke') {
        if (event.data.id != this.chatId || event.data.chatType != this.type) {
          return
        }
        let filter = this.msgList.find((item) => {
          return item.mid == event.data.mid
        })
        if (!filter && filter == null) {
          return
        }
        filter.content_type = 'notice'
        filter.content = `${$r('app.string.revoke_msg')}`
        this.msgList = [...this.msgList]
      }
      else if (event.data.type == 'send') {
        //发送接口插入数据
        LogUtil.d("West", '发送接口插入数据 ' + event.data.sendId)
        let filter = this.msgList.find((item) => {
          return item.sendId == event.data.sendId
        })
        if (!filter && filter == null) {
          return
        }
        filter.msgStatus = event.data.msgStatus
        if (event.data.mid && event.data.mid != null) {
          filter.mid = event.data.mid
        }
        this.msgList = [...this.msgList]
      }
      else if (event.data.type == 'readMsg') {
        if (event.data.id != this.chatId) {
          return
        }
        this.msgList.forEach((item) => {
          if (item.isRead == 0 && item.from != this.chatId) {
            item.isRead = 1
          }
        })
        this.msgList = [...this.msgList]
      }
      else if (event.data.type == 'message_froward') {
        if (event.data.id != this.chatId || event.data.chatType != this.type) {
          return
        }
        //获取最新的聊天记录
        Dao.getRdbModel().getRecentMsg(`${this.type + this.chatId}`, this.msgList[this.msgList.length-1].id)
          .then((value) => {
            if (value.length > 0) {
              this.msgList.push(...value)
            }
          }).catch((err) => {

        })
      }
      else if (event.data.type == 'group_del_msg') { //群主删除消息
        if (event.data.id == this.chatId && event.data.chatType == this.type) {
          this.msgList = this.msgList.filter((item) => {
            return item.mid != event.data.mid
          })
        }
      }
    })
  }

  //查询本地的mid
  private queryMid(mid: string) {
    UserViewModel.getMsgByMid(mid).then((msg) => {
      this.updateRecent(msg.id)
    })
  }

  //更新最新一条mid 和 未读数
  private updateRecent(id: number) {
    let sql = `UPDATE recent SET readMid = ${id} , unread_count = 0 WHERE listId = '${this.type + this.chatId}'`
    Dao.getRdbModel()?.executeSql(sql)
    emitter.emit({ eventId: IConstant.RECENT_UPDATE_ID }, { data: {
      'type': this.type,
      'id': this.chatId,
      'readId': id
    } })
  }
}