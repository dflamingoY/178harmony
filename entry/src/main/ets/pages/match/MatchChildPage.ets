@Component
export struct MatchChildPage {
  @Link index: number

  build() {
    Text(`当前页面${this.index}`).fontSize('20fp')
      .fontColor(Color.Red).height('100%').width('100%')
  }
}