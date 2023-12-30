@Component
@Preview
export struct MatchTopBar {
  @Link index: number
  @Link otherCount: number

  build() {
    Row({ space: 16 }) {
      Text('全部')
        .fontColor(this.index == 0 ? 0xFFB400 : Color.White)
        .fontSize('15fp')
        .onClick(() => {
          this.index = 0
        })
        .width('10%')
        .margin({ left: '10vp' })
      Text('足球').fontColor(this.index == 1 ? 0xFFB400 : Color.White)
        .fontSize('15fp')
        .onClick(() => {
          this.index = 1
        }).width('10%')
      Text('篮球').fontColor(this.index == 2 ? 0xFFB400 : Color.White)
        .fontSize('15fp')
        .onClick(() => {
          this.index = 2
        }).width('10%')
      Text('电竞').fontColor(this.index == 3 ? 0xFFB400 : Color.White)
        .fontSize('15fp')
        .onClick(() => {
          this.index = 3
        }).width('10%')
      Stack({ alignContent: Alignment.TopEnd }) {
        Badge({ count: this.otherCount, maxCount: 99, style: {
          fontSize: '11fp', color: Color.White, badgeColor: Color.Red
        } }) {
          Text('其他')
            .fontColor(this.index == 4 ? 0xFFB400 : Color.White)
            .fontSize('15fp')
            .width('100%')
            .height('100%')
            .textAlign(TextAlign.Center)
        }
      }.onClick(() => {
        this.index = 4
      }).width('10%')

    }.height('48vp').width('100%')
  }
}