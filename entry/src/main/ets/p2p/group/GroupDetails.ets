import router from '@ohos.router'
import display from '@ohos.display'
import { GroupDetailsData } from '../../data/GroupData'
import { UserBean } from '../../data/user'
import UserViewModel from '../../pages/UserViewModel'
import IColors from '../../utils/IColors'
import IConstant from '../../utils/IConstant'

@Entry
@Component
export struct GroupDetails {
  private gid: string
  @State group: GroupDetailsData | null = null
  private avatarWidth: number = 0

  build() {


    Column() {
      Stack({ alignContent: Alignment.Start }) {

        Text('详细资料')
          .fontColor(0x333333)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .fontSize('17fp')
          .width('100%')

        Image($r('app.media.icon_back'))
          .margin({ left: '15vp' })
          .height('21vp')
          .width('21vp')
          .onClick(() => {
            router.back()
          })
      }.width('100%')
      .height('48vp')

      Scroll() {
        Column() {
          Grid() {
            if (this.group != null)
              ForEach(this.group?.members??[], (item) => {
                GridItem() {
                  this.buildAvatar(item)
                }
              })
          }
          .rowsTemplate('1fr 1fr 1fr 1fr 1fr')
          .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
          .width('90%')
          .height(`${this.avatarWidth * 2.5}px`)
          .backgroundColor(Color.White)
          .borderRadius('10vp')

          Row() {
            Text('群头像')
              .fontSize('15fp')
              .fontColor(IColors.color1R1E20)
              .margin({ left: '12vp' })

            Blank()
              .layoutWeight(1)

            Image(this.group?.group?.avatar??'')
              .width('42vp')
              .height('42vp')
              .borderRadius('21vp')
              .alt($r('app.media.icon_default_avatar'))
              .margin({ right: '12vp' })
          }
          .margin({ left: '12vp', right: '12vp', top: '20vp' })
          .height('70vp')
          .backgroundColor(Color.White)
          .borderRadius({ topLeft: '10pv', topRight: '10vp' })

          Row() {
            Text('群昵称')
              .fontSize('15fp')
              .fontColor(IColors.color1R1E20)
              .margin({ left: '12vp' })
            Blank().layoutWeight(1)
            Text(this.group?.group?.groupname??'')
              .fontSize('15fp')
              .fontColor(IColors.color666)
            Image($r('app.media.icon_item_arrow'))
              .width('8vp')
              .fitOriginalSize(true)
              .margin({ left: '12vp', right: '12vp' })
          }.height('54vp')
          .backgroundColor(Color.White)
          .margin({ left: '12vp', right: '12vp' })
          .onClick(() => {

          })

          Row() {
            Text('群ID及二维码')
              .fontSize('15fp')
              .fontColor(IColors.color1R1E20)
              .margin({ left: '12vp' })
            Blank().layoutWeight(1)

            Text(this.group?.group?.gaccount??'')
              .fontSize('15fp')
              .fontColor(IColors.color1R1E20)
              .margin({ right: '10vp' })

            Image($r('app.media.icon_user_qr_code'))
              .width('24vp')
              .height('24vp')

            Image($r('app.media.icon_item_arrow'))
              .width('8vp')
              .fitOriginalSize(true)
              .margin({ left: '12vp', right: '12vp' })

          }.height('54vp')
          .backgroundColor(Color.White)
          .margin({ left: '12vp', right: '12vp' })
          .onClick(() => {

          })

          Row() {
            Text('群公告')
              .fontSize('15fp')
              .fontColor(IColors.color1R1E20)
              .margin({ left: '12vp' })
            Blank().layoutWeight(1)
            Text(this.group?.group?.groupnotice??'暂无公告')
              .layoutWeight(1)
              .margin({ left: '12vp', right: '12vp' })
              .fontSize('15fp')
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(2)
              .fontColor(IColors.color666)

            Image($r('app.media.icon_item_arrow'))
              .width('8vp')
              .fitOriginalSize(true)
              .margin({ left: '12vp', right: '12vp' })

          }.height('54vp')
          .backgroundColor(Color.White)
          .margin({ left: '12vp', right: '12vp' })
          .onClick(() => {

          })

          Row() {
            Text('我在群里的昵称')
              .fontSize('15fp')
              .fontColor(IColors.color1R1E20)
              .margin({ left: '12vp' })
            Blank().layoutWeight(1)
            Text(this.group?.group?.user_remark??'')
              .fontSize('15fp')
              .fontColor(IColors.color666)
            Image($r('app.media.icon_item_arrow'))
              .width('8vp')
              .fitOriginalSize(true)
              .margin({ left: '12vp', right: '12vp' })
          }.height('54vp')
          .backgroundColor(Color.White)
          .margin({ left: '12vp', right: '12vp' })
          .onClick(() => {

          })

          Row() {
            Text('查找聊天记录')
              .fontSize('15fp')
              .fontColor(IColors.color1R1E20)
              .margin({ left: '12vp' })
            Blank().layoutWeight(1)
            Image($r('app.media.icon_item_arrow'))
              .width('8vp')
              .fitOriginalSize(true)
              .margin({ left: '12vp', right: '12vp' })
          }.height('54vp')
          .backgroundColor(Color.White)
          .margin({ left: '12vp', right: '12vp' })
          .onClick(() => {

          })

          Row() {
            Text("置顶聊天")
              .fontSize('16fp')
              .margin({ left: '12vp' })
              .fontColor(IColors.color1R1E20)
            Blank().layoutWeight(1)
            Toggle({ type: ToggleType.Switch, isOn: false })
              .selectedColor(IColors.colorOrange)
              .switchPointColor('#FFFFFF')
              .onChange((isOn: boolean) => {

              }).margin({ right: '12vp' })
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .backgroundColor(Color.White)
          .margin({ left: '12vp', right: '12vp', top: '10vp' })
          .height('50vp')
          .borderRadius({ topLeft: '10vp', topRight: '10vp' })

          Row() {
            Text("定时清空消息")
              .fontSize('16fp')
              .margin({ left: '12vp' })
              .fontColor(IColors.color1R1E20)
            Blank().layoutWeight(1)
            Toggle({ type: ToggleType.Switch, isOn: false })
              .selectedColor(IColors.colorOrange)
              .switchPointColor('#FFFFFF')
              .onChange((isOn: boolean) => {

              }).margin({ right: '12vp' })
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .backgroundColor(Color.White)
          .margin({ left: '12vp', right: '12vp' })
          .height('50vp')

          Row() {
            Text("消息免打扰")
              .fontSize('16fp')
              .margin({ left: '12vp' })
              .fontColor(IColors.color1R1E20)
            Blank().layoutWeight(1)
            Toggle({ type: ToggleType.Switch, isOn: false })
              .selectedColor(IColors.colorOrange)
              .switchPointColor('#FFFFFF')
              .onChange((isOn: boolean) => {

              }).margin({ right: '12vp' })
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .backgroundColor(Color.White)
          .margin({ left: '12vp', right: '12vp' })
          .height('50vp')
          .borderRadius({ bottomLeft: '10vp', bottomRight: '10vp' })

          Column() {
            Text('退出群').width('100%')
              .fontColor(0xED6262)
              .textAlign(TextAlign.Center)
              .fontSize('15fp')
          }
          .height('58vp')
          .backgroundColor(Color.White)
          .margin({ left: '15vp', right: '15vp', bottom: '25vp' })
          .justifyContent(FlexAlign.Center)
          .borderRadius('8vp')
          .onClick(() => {
            AlertDialog.show({
              message: '是否退出登陆',
              autoCancel: true,
              alignment: DialogAlignment.Center,
              confirm: { value: "确定", fontColor: IColors.colorOrange, action: () => {

              }
              }
            })
          })
        }
      }
    }.width(IConstant.MATCH_PARENT)
    .height(IConstant.MATCH_PARENT)
    .backgroundColor(IColors.colorf6f6f6)
  }

  @Builder
  private buildAvatar(item: UserBean) {

    Column({ space: '5vp' }) {

      Image(item.avatar)
        .width(`${this.avatarWidth}px`)
        .borderRadius(`${this.avatarWidth}px`)
        .height(`${this.avatarWidth}px`)

      Text(item.nickname)
        .fontSize('13fp')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ left: '2vp', right: '2vp' })
        .fontColor(IColors.color1R1E20)
    }
    .width(IConstant.MATCH_PARENT)
    .height(IConstant.MATCH_PARENT)

  }

  aboutToAppear() {
    this.avatarWidth = display.getDefaultDisplaySync().width / 8
    let params = router.getParams() as Record<string, string>
    this.gid = params.id
    UserViewModel.getGroupInfo(this.gid).then((group) => {
      this.group = group
    }).catch(() => {

    })
  }
}