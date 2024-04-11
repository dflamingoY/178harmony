import router from '@ohos.router'
import IColors from '../utils/IColors'

@Component
export struct ChatMenu {
  build() {
    Row() {
      Column() {
        Image($r('app.media.icon_chat_photo'))
          .width('55vp')
          .height('55vp')
          .objectFit(ImageFit.ScaleDown)

        Text('相册')
          .margin({ top: '9vp' })
          .fontSize('12fp')
          .fontColor(IColors.color666)
      }.width('22%').height('100%')
      .onClick(() => {
        router.pushUrl({ url: "p2p/PhotoPickerPage" })
      })

      Column() {
        Image($r('app.media.icon_chat_camera'))
          .width('55vp')
          .height('55vp')
          .objectFit(ImageFit.ScaleDown)

        Text('拍摄')
          .margin({ top: '9vp' })
          .fontSize('12fp')
          .fontColor(IColors.color666)
      }.width('22%').height('100%')
      .onClick(() => {
        router.pushUrl({ url: "p2p/PhotoPickerPage" })
      })

      Column() {
        Image($r('app.media.icon_chat_file'))
          .width('55vp')
          .height('55vp')
          .objectFit(ImageFit.ScaleDown)

        Text('文件')
          .margin({ top: '9vp' })
          .fontSize('12fp')
          .fontColor(IColors.color666)
      }.width('22%').height('100%')
      .onClick(() => {
        router.pushUrl({ url: "p2p/PhotoPickerPage" })
      })

      Column() {
        Image($r('app.media.icon_chat_collection'))
          .width('55vp')
          .height('55vp')
          .objectFit(ImageFit.ScaleDown)

        Text('我的收藏')
          .margin({ top: '9vp' })
          .fontSize('12fp')
          .fontColor(IColors.color666)
      }.width('22%').height('100%')
      .onClick(() => {
        router.pushUrl({ url: "p2p/PhotoPickerPage" })
      })
    }.height('123vp').backgroundColor(IColors.colorF3F3F5)

  }
}