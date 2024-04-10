import window from '@ohos.window'
import IColors from '../utils/IColors'
import IConstant from '../utils/IConstant'

@Component
export struct RoomInputPage {
  @State msgContent: string = ''

  build() {

    Stack({alignContent:Alignment.Bottom}) {

      TextArea()
        .fontColor(IColors.color1R1E20)
        .fontSize('15fp')
        .onChange((value: string) => {
          this.msgContent = value
        })
        .margin({ left: '10vp', right: '10vp', top: '10vp' })
    }
    .backgroundColor(Color.Brown)

  }

  aboutToAppear(){

  }

}