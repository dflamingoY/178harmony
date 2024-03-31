import router from '@ohos.router'
import IColors from '../utils/IColors'
//好友详情界面  标签 备注综合控件
@Component
export struct UserDetailsView {
  name: string = ''
  content: string = ''

  build() {
    Stack() {
      Row() {
        Text(this.name)
          .fontSize('14vp')
          .fontColor(IColors.color1R1E20)
          .margin({ left: '15vp' })

        Text(this.content)
          .fontSize('14fp')
          .fontColor(IColors.color999)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .width('60%')
          .textAlign(TextAlign.Start)
          .margin({ left: '50vp' })

        Blank()

        Image($r('app.media.icon_item_arrow'))
          .width('8vp')
          .fitOriginalSize(true)
          .margin({ right: '15vp', left: '10vp' })

      }.height('55vp')
      .width('100%')
      .backgroundColor(Color.White)

      Divider().color(IColors.colorF3F3F5).height('1vp')
        .margin({ left: '15vp' })
    }.alignContent(Alignment.Bottom)

  }

  aboutToAppear() {
    let params = router.getState()
    params.name
  }
}