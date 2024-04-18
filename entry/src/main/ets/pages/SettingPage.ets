import router from '@ohos.router'
import emitter from '@ohos.events.emitter'
import IConstant from '../utils/IConstant'
import PreferenceModel from '../utils/PreferenceModel'
import IColors from '../utils/IColors'
import Dao from '../db/Dao'

@Entry
@Component
export struct SettingPage {
  build() {
    Column() {
      Stack({ alignContent: Alignment.Start }) {

        Text('通用')
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

      Text('通知管理')
        .fontSize('12fp')
        .margin({ left: '12vp' })
        .width('90%')
        .margin({ top: '20vp' })
        .textAlign(TextAlign.Start)
        .fontColor(IColors.color5B5E68)

      Row() {
        Text("通知栏推送")
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
      .margin({ top: '20vp' })
      .width('90%')
      .height('50vp')
      .borderRadius({ topLeft: '10vp', topRight: '10vp' })

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
      .borderRadius({ bottomLeft: '10vp', bottomRight: '10vp' })

      Text('聊天设置')
        .fontSize('12fp')
        .margin({ left: '12vp' })
        .width('90%')
        .margin({ top: '20vp' })
        .textAlign(TextAlign.Start)
        .fontColor(IColors.color5B5E68)

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
              Dao.getRdbModel().clearChatList()
            }
          }
        })
      })

      Blank()


      Column() {
        Text('退出登录').width('100%')
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
            this.logout()
          }
          }
        })
      })
    }
    .height('100%')
    .backgroundColor(0xF3F3F5)
  }

  logout() {
    globalThis.token = null
    globalThis.user = null
    PreferenceModel.deleteKey('token')
    PreferenceModel.deleteKey('user')
    let eventData = {}
    let innerEvent = {
      eventId: IConstant.LOGIN_EVENT_ID,
      priority: emitter.EventPriority.IMMEDIATE
    };
    emitter.emit(innerEvent, eventData)
    router.back()
  }
}