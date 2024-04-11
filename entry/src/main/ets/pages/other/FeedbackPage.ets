import router from '@ohos.router'
import display from '@ohos.display'
import IColors from '../../utils/IColors'
import IConstant from '../../utils/IConstant'
import UserViewModel from '../UserViewModel'
import { PageState } from '../../data/PageState'
import { LoadingPage } from '../LoadingPage'
import CommonUtil from '../../utils/CommonUtil'

@Component
@Entry
export struct FeedbackPage {
  @State content: string = ''
  @State connect: string = ''
  @State loadingState: PageState = PageState.Content

  build() {
    Stack() {
      Column() {
        Stack({ alignContent: Alignment.Start }) {
          Text('意见反馈')
            .fontColor(Color.Black)
            .textAlign(TextAlign.Center)
            .fontSize('17fp').width('100%')
          Image($r('app.media.icon_back'))
            .width('22vp')
            .height('22vp')
            .margin({ left: "15vp" }).onClick(() => {
            router.back()
          })
        }.width('100%')
        .height('50vp')

        Text() {
          Span('反馈内容')
            .fontSize("13fp")
            .fontColor(IColors.color666)
          Span('*')
            .fontColor(IColors.colorEd6262)
            .fontSize("13fp")
            .fontColor(IColors.color666)
        }.margin({ left: '12vp', top: '20vp' })


        TextArea({ placeholder: '你的反馈将帮我们成长' })
          .fontSize('15fp')
          .fontColor(IColors.color1R1E20)
          .placeholderColor(IColors.color999)
          .height('189vp')
          .margin({ top: '12vp', left: '12vp', right: '12vp' })
          .onChange((value) => {
            this.content = value
          })
        Text('联系方式')
          .fontSize('13fp')
          .fontColor(IColors.color666)
          .margin({ left: '12vp', top: '20vp' })

        TextInput({ placeholder: '手机号码，微信，qq' })
          .margin({ left: '12vp', right: '12vp', top: '20vp' })
          .fontColor(IColors.color1R1E20)
          .placeholderColor(IColors.color999)
          .height('50vp')
          .onChange((value) => {
            this.connect = value
          })
        Text('提交')
          .height('50vp')
          .margin({ left: '12vp', right: '12vp', top: '20vp' })
          .textAlign(TextAlign.Center)
          .backgroundColor(IColors.color1R1E20)
          .fontSize('15fp')
          .borderRadius('15vp')
          .width(`${display.getDefaultDisplaySync().width - display.getDefaultDisplaySync().densityPixels * 24}px`)
          .fontColor(IColors.colorOrange)
          .onClick(() => {
            this.feedback()
          })

      }
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .width(IConstant.MATCH_PARENT)
      .height(IConstant.MATCH_PARENT)
      if (this.loadingState == PageState.Progress) {
        LoadingPage()
      }
    }
    .width(IConstant.MATCH_PARENT)
    .height(IConstant.MATCH_PARENT)
    .backgroundColor(IColors.colorF3F3F5)
  }

  private feedback() {
    this.loadingState = PageState.Progress
    UserViewModel.feedback({ "content": this.connect, "contact": this.connect }).then((value) => {
      this.loadingState = PageState.Content
      CommonUtil.showToast("反馈成功")
      router.back()
    }).catch(() => {
      this.loadingState = PageState.Content
    })
  }
}