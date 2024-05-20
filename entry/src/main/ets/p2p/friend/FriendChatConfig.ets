import router from '@ohos.router'
import { UserBean } from '../../data/user'
import UserViewModel from '../../pages/UserViewModel'
import IColors from '../../utils/IColors'
import IConstant from '../../utils/IConstant'

@Entry
@Component
export struct FriendChatConfig {
  uid: string
  @State user: UserBean | null = null

  build() {
    Column() {
      Stack({ alignContent: Alignment.Start }) {

        Text('聊天信息')
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

      Row() {
        Column() {

          Image(this.user?.avatar??'')
            .height('40vp')
            .width('40vp')
            .borderRadius('20vp')

          Text(this.user?.nickname??'')
            .fontSize('15fp')
            .fontColor(IColors.color1R1E20)
            .margin({ top: '10vp' })

        }.margin({ left: '20vp' })
        .onClick(() => {
          router.pushUrl({ url: "p2p/P2PPage", params: {
            'type': IConstant.FRIEND,
            'id': this.uid
          } })
        })

        Column() {
          Image($r('app.media.icon_group_add_user_3'))
            .height('40vp')
            .width('40vp')

          Text('  ')
            .fontSize('15fp')
            .fontColor(IColors.color1R1E20)
            .margin({ top: '10vp' })

        }.margin({ left: '12vp' })

      }
      .backgroundColor(Color.White)
      .borderRadius('10vp')
      .height('120vp')
      .width('90%')
      .margin({ left: '12vp', right: '12vp' })


      Row() {
        Text("查找聊天记录")
          .fontSize('16fp')
          .margin({ left: '12vp' })
          .fontColor(IColors.color1R1E20)
        Blank()
        Image($r('app.media.icon_item_arrow'))
          .width('8vp')
          .fitOriginalSize(true)
          .margin({ right: '12vp' })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor(Color.White)
      .margin({ top: '20vp' })
      .width('90%')
      .height('50vp')
      .borderRadius('10vp')
      .onClick(() => {

      })

      Row() {
        Text("消息免打扰")
          .fontSize('16fp')
          .margin({ left: '12vp' })
          .fontColor(IColors.color1R1E20)

        Toggle({ type: ToggleType.Switch, isOn: false })
          .selectedColor(IColors.colorOrange)
          .switchPointColor('#FFFFFF')
          .onChange((isOn: boolean) => {

          }).margin({ right: '12vp' })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor(Color.White)
      .width('90%')
      .height('50vp')
      .margin({ top: '20vp' })
      .borderRadius({ topLeft: '10vp', topRight: '10vp' })

      Row() {
        Text("置顶聊天")
          .fontSize('16fp')
          .margin({ left: '12vp' })
          .fontColor(IColors.color1R1E20)

        Toggle({ type: ToggleType.Switch, isOn: false })
          .selectedColor(IColors.colorOrange)
          .switchPointColor('#FFFFFF')
          .onChange((isOn: boolean) => {

          }).margin({ right: '12vp' })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor(Color.White)
      .width('90%')
      .height('50vp')
      .borderRadius({ bottomLeft: '10vp', bottomRight: '10vp' })

      Row() {
        Text("清除聊天记录")
          .fontSize('16fp')
          .margin({ left: '12vp' })
          .fontColor(IColors.color1R1E20)
        Blank()
        Image($r('app.media.icon_item_arrow'))
          .width('8vp')
          .fitOriginalSize(true)
          .margin({ right: '12vp' })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor(Color.White)
      .margin({ top: '20vp' })
      .width('90%')
      .height('50vp')
      .borderRadius('10vp')
      .onClick(() => {
        AlertDialog.show({
          title: '提示',
          message: '确定清除所有个人和群的聊天记录？',
          autoCancel: false,
          alignment: DialogAlignment.Center,
          primaryButton: {
            value: '取消',
            fontColor: IColors.color999,
            action: () => {
            }
          },
          secondaryButton: {
            value: '确定',
            fontColor: IColors.colorOrange,
            action: () => {


            }
          }
        })
      })

    }
    .height(IConstant.MATCH_PARENT)
    .width(IConstant.MATCH_PARENT)
    .backgroundColor(IColors.colorf6f6f6)
  }

  aboutToAppear() {
    //查询用户信息
    let params = router.getParams() as Record<string, string>
    this.uid = params.id
    UserViewModel.getFriend(this.uid).then((user) => {
      this.user = user
    }).catch(() => {
      UserViewModel.getLocalUserById(this.uid).then((user) => {
        this.user = user
      })
    })

  }
}