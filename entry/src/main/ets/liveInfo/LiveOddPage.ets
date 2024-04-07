@Component
export struct LiveOddPage {

  type: number = 0
  tournamentId: number = 0

  build() {
    Row() {
      Text("指数")
        .fontColor(Color.Black)
        .fontSize('17fp')
    }.height('100%')
    .width('100%')
  }

  aboutToAppear() {

  }
}