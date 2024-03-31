import router from '@ohos.router'
import { PageState } from '../../data/PageState'
import { UserBean } from '../../data/user'
import IColors from '../../utils/IColors'
import IConstant from '../../utils/IConstant'
import { UserDetailsView } from '../../widget/UserDetailsView'
import UserViewModel from '../UserViewModel'
/**
 * 1.如果有加人 和被加的权限，非好友展示添加按钮，
 * 2.同意申请时 展示同意拒绝按钮
 * 3.好友正常展示
 * 4.展示无权限界面
 */
@Entry
@Component
export struct UserDetailsPage {
  @State user: UserBean | null = null
  private uid: string | null = null
  @State isLoading: PageState = PageState.Progress

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Image($r('app.media.draw_user_details_bg'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      Column() {
        Stack({ alignContent: Alignment.Start }) {

          Text('详细资料')
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Bold)
            .fontSize('17fp')
            .width('100%')
          if (this.user != null && this.user.is_friend) {
            Row() {
              Image($r('app.media.icon_more'))
                .fitOriginalSize(true)
                .margin({ right: '15vp' })
                .onClick(() => {

                })
            }.justifyContent(FlexAlign.End)
            .width('100%')
          }

          Image($r('app.media.icon_black_back'))
            .margin({ left: '15vp' })
            .height('21vp')
            .width('21vp')
            .onClick(() => {
              router.back()
            })
        }.width('100%')
        .height('48vp')

        if (this.user != null) {
          Flex({ direction: FlexDirection.Column }) {
            //用户头像昵称
            Row() {
              Image(this.user.avatar)
                .margin({ left: '12vp' })
                .width('65vp')
                .height('65vp')
                .borderRadius('32.5vp')
                .borderWidth('1vp')
                .alt($r('app.media.icon_default_avatar'))
                .borderColor(Color.White)
              Column() {
                Text(this.user.remark != null && this.user.remark != "" ? this.user.remark : this.user.nickname)
                  .fontColor(Color.White)
                  .textAlign(TextAlign.Start)
                  .maxLines(1)
                  .fontSize('17fp')
                if (this.user.remark != null && this.user.remark != "") {
                  Text(this.user.nickname)
                    .fontSize('13fp')
                    .fontColor(IColors.color737D92)
                    .margin({ top: '5vp' })
                }
                Row() {
                  Text(`178号：${this.user.is_friend ? this.user.username : "*******"}`)
                    .fontSize('13fp')
                    .fontColor(IColors.color737D92)
                  Image($r('app.media.icon_copy'))
                    .width('21vp')
                    .height('21vp')
                    .margin({ left: '8vp' })
                }.margin({ bottom: '5vp', top: '5vp' })
              }.margin({ left: '10vp' })
              .alignItems(HorizontalAlign.Start)
            }.width('100%')
            .margin({ top: '19vp', left: '10vp' })

            Text(this.user.sign == null || this.user.sign == "" ? "这个人很懒什么都没留下～" : this.user.sign)
              .fontColor(Color.White)
              .fontSize('13fp')
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(2)
              .margin({ top: '16vp' })
              .padding({ left: '19vp', right: '19vp' })
              .width('100%')
              .textAlign(TextAlign.Start)
            if (this.user.is_friend) { //好友界面展示
              Column() {
                UserDetailsView({ content: this.user.remark, name: "标签" }).margin({ top: '12vp' })
                UserDetailsView({
                  content: this.user.remark == null || this.user.remark == '' ? "未设置" : this.user.remark,
                  name: '备注'
                })

                Blank()
                Row() {
                  // Blank()
                  // Text('打电话')
                  //   .fontSize('17fp')
                  //   .fontColor(IColors.colorCB8656)
                  //   .height('48vp')
                  //   .width('40%')
                  //   .textAlign(TextAlign.Center)
                  //   .backgroundColor(Color.White)
                  //   .margin({ bottom: '38vp' })
                  //   .borderRadius('25vp')
                  // Blank()
                  Text('发消息')
                    .fontSize('17fp')
                    .textAlign(TextAlign.Center)
                    .fontColor(IColors.colorFED8BD)
                    .height('48vp')
                    .width('80%')
                    .margin({ bottom: '38vp' })
                    .backgroundColor(IColors.color1R1E20)
                    .borderRadius('25vp')
                    .onClick(() => {
                      router.pushUrl({ url: 'p2p/P2PPage', params: {
                        type: IConstant.FRIEND,
                        id: this.uid
                      } })
                    })
                }.margin({ bottom: '38vp' })

              }.width('100%')
              .height('100%')
              .margin({ top: '40vp' })
              .backgroundColor(IColors.colorF3F3F5)
            } else {

            }
          }
        } else {
          if (this.isLoading == PageState.Progress) {
            Column() {
              LoadingProgress()
                .color(IColors.color1R1E20)
                .width('40vp')
                .height('40vp')
                .backgroundColor(Color.White)
                .borderRadius('5vp')
            }.justifyContent(FlexAlign.Center)
            .width('100%')
            .height('100%')
          } else if (this.isLoading == PageState.Offline) {
            Column() {
              Image($r('app.media.icon_net_error'))
                .fitOriginalSize(true)
              Text('网络异常，请稍后重试')
                .fontSize('15fp')
                .fontColor(IColors.color737D92)
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
            .backgroundColor(Color.White)
            .height('100%')
          }
        }
      }
    }
  }

  aboutToAppear() {
    let params = router.getParams() as Record<string, object>
    try {
      this.uid = params.uid as unknown as string
      UserViewModel.getFriend(this.uid).then((user) => {
        this.user = user
        this.isLoading = PageState.Content
      }).catch((err: Error) => {
        if (err.message == "3016") {

        }
        this.isLoading = PageState.Offline
      })
    } catch (e) {
      this.isLoading = PageState.Offline
    }
  }
}