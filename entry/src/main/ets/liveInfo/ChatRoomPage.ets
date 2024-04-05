import display from '@ohos.display';
import { MsgBean } from '../data/MsgBean';
import IColors from '../utils/IColors';
import { LiveInfoModel } from './LiveIndoModel'

@Component
export struct ChatRoomPage {
  model: LiveInfoModel
  @Prop @Watch('onRoomIdChange') roomId: string;
  private currentPage: number = 1
  @State msgArray: Array<MsgBean> = []
  @State isRefreshing: boolean = false

  build() {
    Column() {
      Row() {
        Image($r('app.media.icon_group_hint_chat_room'))
          .width('15vp')
          .margin({ left: '10vp' })
          .height('15vp')

        Text('的直播间,传播任何广告诈骗、敏感词汇等信息的，封号处理。')
          .height('30vp')
          .fontSize('12fp')
          .textAlign(TextAlign.Start)
          .width('100%')
          .margin({ left: '10vp', right: '10vp' })
          .fontColor(IColors.colorOrange)
      }
      .backgroundColor(0x26e49013)
      .width('100%')
      .height('30vp')

      Refresh({ refreshing: $$this.isRefreshing, offset: 20, friction: 100 }) {
        List({}) {
          ForEach(this.msgArray, (value: MsgBean) => {
            ListItem() {
              Row() {
                Text('普通')
                  .fontSize('13fp')
                  .fontColor(Color.White)
                  .backgroundColor(0xffFFA800)
                  .borderRadius('4vp')
                  .width('31vp')
                  .textAlign(TextAlign.Center)
                  .margin({ left: '12vp' })
                  .height('13vp')

                Text() {
                  Span(value.nickname + ": ")
                    .fontSize('13fp')
                    .margin({ left: '6vp' })
                    .fontColor(IColors.colorOrange)

                  Span(value.content)
                    .fontSize('13fp')
                    .margin({ left: '6vp' })
                    .fontColor(0xff4F5A70)
                }.margin({ left: '8vp', right: '12vp' })
                .padding({ right: '12vp' })
              }
              .alignItems(VerticalAlign.Top)
              .width('95%')
              .margin({ top: '12vp', right: '12vp' })
            }
          })
        }.height(`${display.getDefaultDisplaySync().height - display.getDefaultDisplaySync()
          .width * 0.5629 - display.getDefaultDisplaySync().densityPixels * 158}px`)
      }.onRefreshing(() => {
        this.isRefreshing = true
        this.currentPage++
        this.getRoomList()
      })
    }
  }

  onRoomIdChange() {
    this.currentPage = 1
    this.getRoomList()
  }

  private getRoomList() {
    this.model.getRoomHistory(this.roomId, this.currentPage).then((value => {
      this.msgArray = value.data.concat(this.msgArray)
      this.isRefreshing = false
    })).catch(() => {
      this.isRefreshing = false
    })
  }
}