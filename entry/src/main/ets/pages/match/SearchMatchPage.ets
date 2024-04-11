import router from '@ohos.router'
import IConstant from '../../utils/IConstant'
import UserViewModel from '../UserViewModel'

@Component
@Entry
export struct SearchMatchPage {
  @State searchKey: string = ''

  build() {
    Column() {
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
        Image($r('app.media.icon_black_back'))
          .width('22vp')
          .height('22vp')
          .margin({ left: "15vp" })
          .onClick(() => {
            router.back()
          })
        Row() {
          Image($r('app.media.icon_search'))
            .width('17vp')
            .height('17vp')
            .margin({ left: '12vp' })
          TextInput({ placeholder: '搜索球队、主播' })
            .fontSize('15fp')
            .margin({ left: '8vp' })
            .placeholderColor(0x99ffffff)
            .maxLength(1)
            .enterKeyType(EnterKeyType.Search)
            .fontColor(0x99ffffff)
            .onChange((value) => {
              this.searchKey = value
            })
            .onSubmit((keyType) => {
              if (keyType == EnterKeyType.Search) {
                this.search()
              }
            })
        }
        .backgroundColor(Color.Red)
        .backgroundColor(0x33ffffff)
        .margin({ left: '12vp', right: '12vp' })
        .borderRadius('17vp')
        .height('35vp')

        Text('取消')
          .margin({ right: '12vp', left: '8vp' })
          .fontSize('12fp')
          .maxLines(1)
          .width('10%')
          .fontColor(Color.White)
          .onClick(() => {
            router.back()
          })
      }.height('50vp')
      .width(IConstant.MATCH_PARENT)
      .backgroundColor(Color.Black)
    }
  }

  private search() {
    if (this.searchKey == '') {
      return
    }
    UserViewModel.searchMatch(this.searchKey).then((result) => {

    }).catch((err) => {

    })
  }
}