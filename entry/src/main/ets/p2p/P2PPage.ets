import router from '@ohos.router'
import { MsgBean } from '../data/MsgBean'
import Dao from '../db/Dao'
import LogUtil from '../utils/LogUtil'

@Entry
@Component
export struct P2PPage {
  @State isRefreshing: boolean = false
  @State msgList: Array<MsgBean> = []

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Image($r('app.media.icon_chat_bg'))
        .height('48vp')
        .width('100%')
        .objectFit(ImageFit.Cover)
      Flex({ direction: FlexDirection.Column }) {

        Stack({ alignContent: Alignment.Start }) {
          Text('通用')
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
            .fontSize('17fp')
            .width('100%')

          Image($r('app.media.icon_black_back'))
            .margin({ left: '15vp' })
            .height('21vp')
            .width('21vp')
            .onClick(() => {
              router.back()
            })
        }
        .width('100%')
        .height('48vp')

        Refresh({ refreshing: $$this.isRefreshing, offset: 120, friction: 100 }) {

        }.onRefreshing(() => {
          this.isRefreshing = true
        })
      }
    }.height('100%')
    .backgroundColor(0xffF6f6f6)
  }

  aboutToAppear() {
    let params = router.getParams() as Record<string, object>
    let type = params.type as unknown as string
    let id = params.id
    Dao.getRdbModel()?.getMsgByChatId(`${type + id}`, 20).then((msg) => {
      LogUtil.d("West", `查询结果${msg}`)
    }).catch((e: Error) => {

    })
  }
}