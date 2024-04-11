import IColors from '../../utils/IColors'
import IConstant from '../../utils/IConstant'

@Component
export struct EditNamePage {
  content: string = ''
  @Link isEdit: boolean
  @State type: number = 0
  result = (value: number, result: string) => {
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Start }) {
        Text(this.type == 0 ? '昵称' : '个性签名')
          .fontColor(Color.Black)
          .textAlign(TextAlign.Center)
          .fontSize('20fp').width('100%')
        Column() {
          Text("保存")
            .backgroundColor(IColors.color1R1E20)
            .borderRadius('15vp')
            .fontColor(Color.White)
            .fontSize('15fp')
            .margin({ right: '12vp' })
            .padding({ left: '10vp', right: '10vp', top: '5vp', bottom: '5vp' })
            .textAlign(TextAlign.Center)
            .onClick(() => {
              this.result(this.type, this.content)
              this.isEdit = false
            })
        }.layoutWeight(1)
        .width(IConstant.MATCH_PARENT)
        .alignItems(HorizontalAlign.End)

        Image($r('app.media.icon_back'))
          .width('22vp')
          .height('22vp')
          .margin({ left: "15vp" })
          .onClick(() => {
            this.isEdit = false
          })
      }.width('100%')
      .height('50vp')

      if (this.type == 0) {
        TextInput({ placeholder: '最多可输入14个字', text: this.content })
          .fontSize('15fp')
          .fontColor(IColors.color1R1E20)
          .placeholderColor(IColors.color999)
          .height('54vp')
          .maxLength(14)
          .margin({ left: '12vp', right: '12vp', top: '20vp' })
          .onChange((value) => {
            this.content = value
          })
      } else {
        TextArea({ placeholder: '请输入签名', text: this.content })
          .fontSize('15fp')
          .fontColor(IColors.color1R1E20)
          .placeholderColor(IColors.color999)
          .height('189vp')
          .margin({ left: '12vp', right: '12vp', top: '20vp' })
          .onChange((value) => {
            this.content = value
          })
      }

    }.backgroundColor(IColors.colorF3F3F5)
    .height(IConstant.MATCH_PARENT)
    .width(IConstant.MATCH_PARENT)
  }
}
