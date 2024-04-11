import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import { UserBean } from '../data/user'
import UserViewModel from './UserViewModel'
import IConstant from '../utils/IConstant'
import emitter from '@ohos.events.emitter'

@Entry
@Component
export struct UserPage {
  @State user: UserBean = new UserBean()

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Image($r('app.media.draw_home_bg'))
        .objectFit(ImageFit.Cover)
        .height('167vp')
        .width('100%')

      RelativeContainer() {

        Image(this.user.avatar)
          .width('58vp')
          .height('58vp')
          .alt($r('app.media.icon_default_avatar'))
          .borderRadius('29vp')
          .margin({ left: '15vp', top: '23vp' })
          .alignRules({
            top: { anchor: "__container__", align: VerticalAlign.Top },
            left: { anchor: "__container__", align: HorizontalAlign.Start }
          })
          .id('ivAvatar')

        Column() {
          Text(this.user.nickname)
            .fontSize('17vp')
            .width('100%')
            .fontColor(Color.White)
          Blank()
          Text('178号：' + this.user.username)
            .fontSize('15vp')
            .width('100%')
            .fontColor(0x99ffffff)
        }
        .alignRules({
          top: { anchor: "ivAvatar", align: VerticalAlign.Top },
          left: { anchor: "ivAvatar", align: HorizontalAlign.End },
          bottom: { anchor: "ivAvatar", align: VerticalAlign.Bottom },
        })
        .margin({ left: '15vp', top: '23vp' })
        .alignSelf(ItemAlign.Start)
        .id('row3')
        .width('30%')
        .justifyContent(FlexAlign.Start)

        Row() {
          Image($r('app.media.icon_user_qr_code')).width('21vp')
            .height('21vp')
          Image($r('app.media.icon_item_arrow')).width('8vp')
            .margin({ left: '10vp' })
            .height('12vp')
        }
        .alignRules({
          right: { anchor: "__container__", align: HorizontalAlign.End },
          top: { anchor: 'ivAvatar', align: VerticalAlign.Top },
          bottom: { anchor: 'ivAvatar', align: VerticalAlign.Bottom }
        })
        .width('50vp')
        .height('21vp')
        .onClick(() => {
          router.pushUrl({ url: "pages/other/UserQrPage", params: {
            uid: this.user.uid,
            nickname: this.user.nickname,
            account: this.user.username
          } })
        })
        .id('row2')
        .margin({ right: '15vp', top: '23vp' })

        Text(this.user.sign??'')
          .id('tvSign')
          .fontSize('15fp')
          .fontColor(Color.White)
          .alignRules({
            left: { anchor: "__container__", align: HorizontalAlign.Start },
            right: { anchor: "__container__", align: HorizontalAlign.End },
            top: { anchor: "ivAvatar", align: VerticalAlign.Bottom }
          })
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ bottom: '12vp', left: '12vp', right: '12vp', top: '10vp' })

      }.width('100%').height('167vp')
      .onClick(() => {
        router.pushUrl({ url: 'pages/user/UserDetailPage' })
      })


      Column() {
        Flex({ direction: FlexDirection.Column }) {
          Text('聊天管理')
            .fontSize('15fp')
            .width('100%')
            .margin({ left: '15vp' })
            .height('42vp')
            .fontColor(0x1E2024)

          Row() {
            this.buildItem('我的表情', $r('app.media.icon_user_emoji'), ClickType.Emoji)
            this.buildItem('我的收藏', $r('app.media.icon_collection'), ClickType.Collection)
          }
          .width('100%').height('96%')
        }
        .borderRadius('8vp')
        .height('112vp')
        .backgroundColor(Color.White)

        Flex({ direction: FlexDirection.Column }) {
          Text('个人中心')
            .fontSize('15fp')
            .width('100%')
            .margin({ left: '15vp' })
            .height('32vp')
            .fontColor(0x1E2024)

          Row() {
            this.buildItem('意见反馈', $r('app.media.icon_feedback'), ClickType.Feedback)
            this.buildItem('关于我们', $r('app.media.icon_about_us'), ClickType.About)
            this.buildItem('清除缓存', $r('app.media.icon_clean_cached'), ClickType.CleanCache)
            this.buildItem('设置', $r('app.media.icon_notify_manager'), ClickType.Setting)
          }
          .width('100%')
          .height('96%')
        }
        .borderRadius('8vp')
        .height('112vp')
        .margin({ top: '20vp' })
        .backgroundColor(Color.White)
      }
      .margin({ top: '152vp', left: '12vp', right: '12vp' })

    }
    .height('100%').backgroundColor(0xF3F3F5)
  }

  @Builder
  buildItem(title: string, res: Resource, type: ClickType) {
    Column() {
      Blank()
      Image(res)
        .width('21vp')
        .height('21vp')
      Text(title).fontColor(0x5B5E68)
        .fontSize('12vp')
        .margin({ top: '12vp' })
      Blank()
    }.justifyContent(FlexAlign.Center).width('25%').height('100%').onClick(() => {
      switch (type) {
        case ClickType.Emoji:

          break;
        case ClickType.Collection:

          break;
        case ClickType.Feedback:
          router.pushUrl({ url: 'pages/other/FeedbackPage' })
          break;
        case ClickType.About:
          router.pushUrl({ url: 'pages/other/AboutUsPage' })
          break;
        case ClickType.CleanCache:
          promptAction.showToast({ message: '已经清理缓存', duration: 1500 })
          break;
        case ClickType.Setting:
          router.pushUrl({ url: 'pages/SettingPage' });
          break;
      }
    })
  }

  aboutToAppear() {
    UserViewModel.getUserInfo().then((user: UserBean) => {
      this.user = user
    }).catch((err: Error) => {
      err.message
    })
    emitter.on(this.innerEvent, (event) => {
      if (!globalThis.user || globalThis.user == null) {
        this.user = new UserBean()
      } else {
        this.user = globalThis.user
      }
    })
  }

  innerEvent = {
    eventId: IConstant.LOGIN_EVENT_ID
  }

  aboutToDisappear() {
    emitter.off(IConstant.LOGIN_EVENT_ID)
  }
}

enum ClickType {
  Emoji, Collection, Feedback, About, CleanCache, Setting
}