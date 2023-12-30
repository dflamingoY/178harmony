import ArrayList from '@ohos.util.ArrayList'
import { MatchBean, MatchDayEntity } from '../../data/Data'
import MatchModel from './MatchModel'

@Component
export struct MatchChildPage {
  index: number
  @Link data: MatchModel

  build() {
    Column() {
      if (this.data.getShowList(this.index)?.length > 0) {
        List({}) {
          ForEach(this.data.getShowList(this.index), (item: MatchDayEntity) => {
            ListItem() {
              Column() {
                Text(`${item.date}`)
                  .height('40vp')
                  .width('100%')
                  .textAlign(TextAlign.Start)
                  .fontSize('12fp')
                  .fontColor(0x666666)
                  .backgroundColor(0xf6f6f6)
                  .padding({ left: '10vp' })
                if (item.list == null || item.list.length == 0 || item.list.length == undefined) {
                  Text('暂无直播')
                    .height('37vp')
                    .width('100%')
                    .textAlign(TextAlign.Start)
                    .fontSize('12fp')
                    .fontColor(0x999999)
                    .padding({ left: '10vp' })
                }
              }
            }

            ForEach(item.list, (value: MatchBean) => {
              ListItem() {
                this.buildListItem(value)
              }.backgroundColor(0xf6f6f6)
            })
            ForEach(item.list, (value: MatchBean) => {
            }, (value: MatchBean) => {
              return JSON.stringify(value)
            })
          }, (item: MatchDayEntity) => {
            return JSON.stringify(item)
          })
        }.width('100%').height('100%')
      } else {
        Text(`当前角标：${this.index}`)
          .width('100%')
          .height('100%')
          .textAlign(TextAlign.Center)
          .fontSize('20fp')
          .fontColor(Color.Black)
      }
    }.width('100%')
    .height('100%')
  }

  @Builder
  buildListItem(item: MatchBean) {
    Column() {
      Row() {
        if (item.tournament_type == 1)
          Image($r('app.media.icon_football')).width('18vp').height('18vp').margin({ left: '12vp' })
        else if (item.tournament_type == 2) {
          Image($r('app.media.icon_basketball')).width('18vp').height('18vp').margin({ left: '12vp' })
        } else Image($r('app.media.icon_live_other_game')).width('18vp').height('18vp').margin({ left: '12vp' })

      }.height('35vp').alignItems(VerticalAlign.Center)
    }.height('131vp')
  }

  aboutToAppear() {
    this.data.getShowList(0)
  }
}