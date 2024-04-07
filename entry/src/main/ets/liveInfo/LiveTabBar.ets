@Component
@Preview
export struct LiveTabBar {
  @Link index: number
  @Link unreadCount: number

  build() {
    Row() {
      Text('聊天室')
        .fontColor(this.index == 0 ? 0xFFB400 : 0x5B5E68)
        .fontSize('15fp')
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.index = 0
        })
        .width(`${100 / 6}%`)
        .margin({ left: '10vp' })
      Text('主播').fontColor(this.index == 1 ? 0xFFB400 : 0x5B5E68)
        .fontSize('15fp')
        .textAlign(TextAlign.Center)
        .width(`${100 / 6}%`)
        .onClick(() => {
          this.index = 1
        })
      /*Text('指数').fontColor(this.index == 2 ? 0xFFB400 : 0x5B5E68)
        .fontSize('15fp')
        .textAlign(TextAlign.Center)
        .width(`${100 / 6}%`)
        .onClick(() => {
          this.index = 2
        })
      Text('分析').fontColor(this.index == 3 ? 0xFFB400 : 0x5B5E68)
        .fontSize('15fp')
        .textAlign(TextAlign.Center)
        .width(`${100 / 6}%`)
        .onClick(() => {
          this.index = 3
        })*/
      Text('直播').fontColor(this.index == 2 ? 0xFFB400 : 0x5B5E68)
        .fontSize('15fp')
        .width(`${100 / 6}%`)
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.index = 2
        })
      /*Stack({ alignContent: Alignment.TopEnd }) {
        Badge({ count: this.unreadCount, maxCount: 99, style: {
          fontSize: '11fp', color: Color.White, badgeColor: Color.Red
        } }) {
          Text('私信')
            .fontColor(this.index == 5 ? 0xFFB400 : 0x5B5E68)
            .fontSize('15fp')
            .textAlign(TextAlign.Center)
            .width('100%')
            .height('100%')
            .textAlign(TextAlign.Center)
        }
      }
      .width(`${100 / 6}%`)
      .onClick(() => {
        this.index = 5
      })*/

    }.height('48vp').width('100%')
  }
}