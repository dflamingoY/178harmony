import router from '@ohos.router'
import systemDateTime from '@ohos.systemDateTime'
import { GroupBean } from '../data/GroupData'
import { MsgBean } from '../data/MsgBean'
import { UserBean } from '../data/user'
import Dao from '../db/Dao'
import UserViewModel from '../pages/UserViewModel'
import CommonUtil from '../utils/CommonUtil'
import IConstant from '../utils/IConstant'
import LogUtil from '../utils/LogUtil'

@Entry
@Component
export struct P2PPage {
  @State isRefreshing: boolean = false
  @State msgList: Array<MsgBean> = []
  @State unreadCount: number = 1
  @State name: string = ''
  @State avatarUrl: string = ''
  private type: string = IConstant.FRIEND
  @State userInfo: UserBean | null = null
  private groupInfo: GroupBean | null = null
  @State currentTime: number = 0

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Image($r('app.media.icon_chat_bg'))
        .height('48vp')
        .width('100%')
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

        Refresh({ refreshing: $$this.isRefreshing, offset: 120, friction: 100 }) {
          List() {
            ForEach(this.msgList, (item: MsgBean) => {
              ListItem() {
                this.buildMsgItem(item)
              }
            })
          }
        }.onRefreshing(() => {
          this.isRefreshing = true
        }).height('100%').backgroundColor(Color.Gray)




      }
    }
    .backgroundColor(0xffF6f6f6)
  }

  @Builder
  private buildMsgItem(item: MsgBean) {
      Column(){

      }
  }

  aboutToAppear() {
    let params = router.getParams() as Record<string, object>
    let type = params.type as unknown as string
    let id = params.id
    this.type = type
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
    systemDateTime.getCurrentTime(false).then((time: number) => {
      this.currentTime = time
    })
  }
}