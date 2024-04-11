import display from '@ohos.display';
import emitter from '@ohos.events.emitter';
import router from '@ohos.router';
import { MsgBean } from '../data/MsgBean';
import { isLogin } from '../login/LoginPlugin';
import UserViewModel from '../pages/UserViewModel';
import IColors from '../utils/IColors';
import IConstant from '../utils/IConstant';
import LogUtil from '../utils/LogUtil';
import PreferenceModel from '../utils/PreferenceModel';
import { LiveInfoModel } from './LiveIndoModel'

@Component
export struct ChatRoomPage {
  model: LiveInfoModel
  @Prop @Watch('onRoomIdChange') roomId: string;
  private currentPage: number = 1
  @State msgArray: Array<MsgBean> = []
  @State isRefreshing: boolean = false
  @Link contentHeight: number
  @State content: string = ''
  scroller = new Scroller()
  @State isShowMore: boolean = false
  @State isInterceptSystem: boolean = false //是否拦截进场消息
  scrollEnd: number = 0

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        Row() {
          Image($r('app.media.icon_group_hint_chat_room'))
            .width('15vp')
            .margin({ left: '10vp' })
            .height('15vp')

          Text('的直播间,传播任何广告诈骗、敏感词汇等信息的，封号处理。')
            .height('30vp')
            .fontSize('12fp')
            .textAlign(TextAlign.Start)
            .width('100%')
            .margin({ left: '10vp', right: '10vp' })
            .fontColor(IColors.colorOrange)
        }
        .backgroundColor(0x26e49013)
        .width('100%')
        .height('30vp')

        Refresh({ refreshing: $$this.isRefreshing, offset: 20, friction: 100 }) {
          List({ scroller: this.scroller }) {
            ForEach(this.msgArray, (value: MsgBean) => {
              ListItem() {
                if (value.content_type == "system") {
                  Text(value.content)
                    .fontSize('13fp')
                    .fontColor(IColors.colorOrange)
                    .width('95%')
                    .margin({ top: '12vp', right: '12vp' })
                    .width('100%')
                    .padding({ left: '12vp' })
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                } else {
                  Row() {
                    Text('普通')
                      .fontSize('13fp')
                      .fontColor(Color.White)
                      .backgroundColor(0xffFFA800)
                      .borderRadius('4vp')
                      .width('31vp')
                      .textAlign(TextAlign.Center)
                      .margin({ left: '12vp' })
                      .height('13vp')

                    Text() {
                      Span((value.nickname ?? value.from_name) + ": ")
                        .fontSize('13fp')
                        .margin({ left: '6vp' })
                        .fontColor(IColors.colorOrange)

                      Span(value.content)
                        .fontSize('13fp')
                        .margin({ left: '6vp' })
                        .fontColor(0xff4F5A70)
                    }.margin({ left: '8vp', right: '12vp' })
                    .padding({ right: '12vp' })
                  }
                  .alignItems(VerticalAlign.Top)
                  .width('95%')
                  .margin({ top: '12vp', right: '12vp' })
                }

              }
            })
          }
          .layoutWeight(1)
          .onScrollIndex((start, end) => {
            this.scrollEnd = end
            if (end == this.msgArray.length - 1) {
              this.isShowMore = false
            }
            LogUtil.d("West", `start  :${start}   end: ${end}`)
          })
          .height(`${this.contentHeight - display.getDefaultDisplaySync()
            .width * 0.5629 - display.getDefaultDisplaySync().densityPixels * (48 + 30 + 50)}px`)
        }.onRefreshing(() => {
          this.isRefreshing = true
          this.currentPage++
          this.getRoomList()
        })

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          Image(this.isInterceptSystem ? $r('app.media.icon_room_chat_disable') : $r('app.media.icon_room_chat_enable'))
            .width('23vp')
            .height('23vp')
            .margin({ left: '12vp' })
            .onClick(() => {
              this.isInterceptSystem = !this.isInterceptSystem
              PreferenceModel.putNormal(IConstant.FILTER_ROOM_SYSTEM, this.isInterceptSystem)
            })
          TextArea({ placeholder: "说点什么", text: this.content })
            .fontSize('14fp')
            .fontColor(IColors.color999)
            .backgroundColor(Color.Transparent)
            .margin({ left: '12vp' })
            .onChange((text) => {
              this.content = text
            })
          if (this.content.length > 0) {
            Text("发送")
              .fontSize('12fp')
              .fontColor(Color.White)
              .backgroundColor(IColors.colorOrange)
              .height('30vp')
              .borderRadius('15vp')
              .width('50vp')
              .margin({ right: '10vp' })
              .textAlign(TextAlign.Center)
              .onClick(() => {
                if (isLogin()) {
                  this.sendMsg()
                } else {
                  router.pushUrl({ url: 'login/LoginPage' })
                }
              })
          }
        }
        .height('40vp')
        .backgroundColor(IColors.colorF3F3F5)
        .borderRadius('15vp')
        .alignSelf(ItemAlign.Center)
        .width('90%')
      }

      if (this.isShowMore)
        Text("有新的消息")
          .backgroundColor(IColors.colorOrange)
          .height('30vp')
          .padding({ left: '12vp', right: '12vp' })
          .fontColor(Color.White)
          .fontSize('12vp')
          .margin({ bottom: '50vp' })
          .onClick(() => {
            this.scroller.scrollToIndex(this.msgArray.length - 1)
            this.isShowMore = false
          })
    }
  }

  private sendMsg() {
    UserViewModel.sendRoomMsg(this.content, this.roomId)
    this.content = ''
  }

  onRoomIdChange() {
    this.currentPage = 1
    this.getRoomList()
  }

  private getRoomList() {
    this.model.getRoomHistory(this.roomId, this.currentPage).then((value => {
      this.msgArray = value.data.concat(this.msgArray)
      this.isRefreshing = false
      if (this.currentPage == 1) {
        this.scroller.scrollToIndex(this.msgArray.length - 1)
      }
    })).catch(() => {
      this.isRefreshing = false
    })
  }

  private removeForbidden(uid: string) {
    let filters = this.msgArray.filter((item) => {
      return item.from != uid
    })
    this.msgArray = filters
  }

  private removeMid(mid: string) {
    let filters = this.msgArray.filter((item) => {
      return item.from != mid
    })
    this.msgArray = filters
  }

  aboutToAppear() {
    PreferenceModel.getBoolean(IConstant.FILTER_ROOM_SYSTEM, false).then((result: boolean) => {
      this.isInterceptSystem = result
    })
    emitter.on({
      eventId: IConstant.ROOM_MSG_ID
    }, (event) => {
      //获取到ws推送的聊天室消息
      try {
        if (event.data.type == "msg") {
          if (event.data.roomId == this.roomId) {
            let msg: MsgBean = JSON.parse(event.data.data)
            if (this.isInterceptSystem && msg.content_type == 'system') {
              return
            }
            this.msgArray.push(msg)
            if (this.scrollEnd == this.msgArray.length - 2) {
              this.scroller.scrollToIndex(this.msgArray.length - 1)
            } else if ( /*msg.content_type != 'system' &&*/
              !this.isShowMore) {
              this.isShowMore = true
            }
          }
        } else if (event.data.type == "delRoomMsg") {
          let forbidden = JSON.parse(event.data.data)
          if (forbidden['uid'] && forbidden['uid'] != '') {
            this.removeForbidden(forbidden['uid'])
          } else {
            this.removeMid(forbidden["mid"])
          }
        } else if (event.data.type == "disabledUser") {
          let forbidden = JSON.parse(event.data.data)
          this.removeForbidden(forbidden['uid'])
        }
      } catch (e) {
      }
    })
  }

  aboutToDisappear() {
    emitter.off(IConstant.ROOM_MSG_ID)
  }
}