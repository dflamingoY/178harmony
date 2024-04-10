import cryptoFramework from '@ohos.security.cryptoFramework'
import { TvUser } from '../data/Data'
import IColors from '../utils/IColors'
import LogUtil from '../utils/LogUtil'

@Preview
@Component
export struct LiveAnchorPage {
  @Link user: TvUser
  @State followCount: number = 0

  build() {
    Column() {
      Image(this.user?.face)
        .alt($r('app.media.icon_default_avatar'))
        .width('84vp')
        .borderRadius('42vp')
        .height('84vp')
        .margin({ top: '80vp' })

      Text(this.user?.username)
        .fontSize('15fp')
        .fontColor(IColors.color1R1E20)
        .margin({ top: '20vp' })

      Row() {
        Text() {
          Span(`${this.user?.viewer}\n`)
            .fontSize('14fp')
            .fontColor(IColors.colorFED8BD)

          Span('人气')
            .margin({ top: '12vp' })
            .margin({ top: '10vp' })
            .fontSize('14fp')
            .fontColor(IColors.color91939A)

        }.textAlign(TextAlign.Center)

        Text() {
          Span(`${this.followCount}\n`)
            .fontSize('14fp')
            .fontColor(IColors.colorFED8BD)

          Span('关注')
            .margin({ top: '12vp' })
            .fontSize('14fp')
            .margin({ top: '10vp' })
            .fontColor(IColors.color91939A)

        }.textAlign(TextAlign.Center)
        .margin({ left: '20vp' })
      }.margin({ top: '20vp' })

      // Text('私信主播')
      //   .width('141vp')
      //   .height('38vp')
      //   .borderRadius('15vp')
      //   .margin({ top: '20vp' })
      //   .backgroundColor(0xffFFFAF7)
      //   .borderWidth('1vp')
      //   .textAlign(TextAlign.Center)
      //   .fontSize('15fp')
      //   .fontColor(IColors.colorOrange)
      //   .borderColor(IColors.colorOrange)

    }
    .width('100%')
  }

  aboutToAppear() {
    cryptoFramework.createRandom().generateRandom(1, (err, random) => {
      this.followCount = random.data[0]
    })
  }
}