import router from '@ohos.router'
import IConstant from '../../utils/IConstant'
import UserViewModel from '../UserViewModel'

@Component
@Entry
export struct UserQrPage {
  @State url: string = ''
  @State nickname: string = ''
  @State account: string = ''

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Image($r('app.media.draw_user_details_bg'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      Column() {
        Image(this.url)
          .width('200vp')
          .height('200vp')
          .margin({ top: '10vp' })

        Text(this.nickname).fontSize('16fp')
          .margin({ top: '20vp' })
          .fontColor(Color.White)

        Text(`178号：${this.account}`).fontColor($r('app.color.color_alpha_99_white'))
          .fontSize('12fp')
          .margin({ top: '10vp' })
        Image($r('app.media.icon_save_qr_code'))
          .width('46vp')
          .height('46vp')
          .margin({ top: '20vp' })
        Text('保存图片')
          .fontSize('15fp')
          .margin({ top: '5vp' })
          .fontColor(Color.White)
      }.alignSelf(ItemAlign.Center)
      .width(IConstant.MATCH_PARENT)
      .height(IConstant.MATCH_PARENT)
      .justifyContent(FlexAlign.Center)

      Stack({ alignContent: Alignment.Start }) {
        Text('我的二维码')
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .fontSize('17fp').width('100%')
        Image($r('app.media.icon_black_back'))
          .width('22vp')
          .height('22vp')
          .margin({ left: "15vp" }).onClick(() => {
          router.back()
        })
      }.width('100%')
      .height('50vp')
    }
  }

  aboutToAppear() {
    let params = router.getParams() as Record<string, any>
    let uid = params['uid'] as string
    this.nickname = params["nickname"]
    this.account = params["account"]
    UserViewModel.getQrCode(1, uid).then((url) => {
      this.url = url
    })
  }
}