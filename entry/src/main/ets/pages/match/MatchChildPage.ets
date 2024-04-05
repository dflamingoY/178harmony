import { MatchBean, MatchDayEntity, TvUser } from '../../data/Data'
import { getBasketState } from '../../utils/BallUtils'
import MatchModel from './MatchModel'
import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import IColors from '../../utils/IColors'

@Component
export struct MatchChildPage {
  index: number
  @Link data: MatchModel
  @Link isRefresh: boolean

  build() {
    Column() {
      if (this.data.getShowList(this.index)?.length > 0) {
        Refresh({ refreshing: $$this.isRefresh, offset: 120, friction: 100 }) {
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
              }.backgroundColor(0xF3F3F5)

              ForEach(item.list, (value: MatchBean) => {
                ListItem() {
                  this.buildListItem(value)
                }.backgroundColor(Color.White)
              })
            }, (item: MatchDayEntity) => {
              return JSON.stringify(item)
            })
          }.width('100%').height('100%')
        }.onRefreshing(() => {
          if (!this.isRefresh) {
            this.isRefresh = true
          }
        })
      } else {
        Column() {
          LoadingProgress()
            .width('50vp')
            .color(Color.Red)
            .height('50vp')
            .backgroundColor(Color.White)
            .borderRadius('10vp')
        }.width('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor(IColors.colorF3F3F5)
        .height('100%')
      }
    }.width('100%')
    .height('100%')
  }

  @Builder
  buildListItem(item: MatchBean) {
    Column() {
      //绘制顶部状态
      Stack() {
        Row() {
          if (item.tournament_type == 1)
            Image($r('app.media.icon_football')).width('18vp').height('18vp').margin({ left: '12vp' })
          else if (item.tournament_type == 2) {
            Image($r('app.media.icon_basketball')).width('18vp').height('18vp').margin({ left: '12vp' })
          } else Image($r('app.media.icon_live_other_game')).width('18vp').height('18vp').margin({ left: '12vp' })
          Text(`${item.league_name_zh}`)
            .fontColor(0x1E1E20)
            .fontSize('12fp').margin({ left: '10vp' })
        }.alignItems(VerticalAlign.Center).width('100%')

        if (item.tournament_type == 1 || item.tournament_type == 2 || item.is_game == 1) {
          if (item.state > 0 && item.is_game == 0 || item.state == 2 && item.is_game == 1) {
            if (item.tournament_type == 2 && item.state == 50 || item.tournament_type == 1 && item.state == 2) { //basket  midfield
              Text('中场').fontSize('12fp')
                .fontColor(item.tournament_type == 1 ? 0xffE73636 : 0xff2677EF)
            } else if (item.is_game == 1) { //game end
              Text(item.state == 3 ? '完赛' : item.on_time).fontSize('12fp')
                .fontColor(0xffE73636)
            } else {
              Text(item.tournament_type == 2 ? `${getBasketState(item.state)} ${item.on_time}'` : item.on_time)
                .fontSize('12fp')
                .fontColor(0xffE73636)
            }
          } else {
            Text(item.state == -1 && (item.tournament_type == 1 || item.tournament_type == 2) || item.is_game == 1 && item.state == 3 ? '完赛' : '未开始')
              .fontSize('12fp')
              .fontColor(item.state == -1 && (item.tournament_type == 1 || item.tournament_type == 2) || item.is_game == 1 && item.state == 3 ? 0xffE73636 : 0xff5B5E68)
          }
        } else
          Text('直播中').fontSize('12fp')
            .fontColor(0xff5B5E68)
      }
      .height('35vp')
      //绘制主客队信息
      Row() {
        Row() {
          Text(item.home_team_zh).fontColor(0x1E1E20)
            .fontSize('15fp')
          Image(item.home_logo).width('23vp').height('23vp').margin({ left: '6vp' })
        }.justifyContent(FlexAlign.End).width('45%')

        Text(item.tournament_type == 1 || item.tournament_type == 2 || item.is_game == 1 ? item.state > 0 && item.is_game != 1 || item.is_game == 1 && item.state == 2 ? `${item.home_score}:${item.away_score}` : item.start_time : "0:0")
          .fontSize('15fp')
          .fontColor(item.state > 0 && item.is_game != 1 || item.is_game == 1 && item.state == 2 ? 0xffE73636 : 0xff5B5E68)
          .fontWeight(item.state > 0 && item.is_game != 1 || item.is_game == 1 && item.state == 2 ? FontWeight.Bold : FontWeight.Normal)
          .width('10%')
          .textAlign(TextAlign.Center)
        Row() {
          Image(item.away_logo).width('23vp').height('23vp').margin({ left: '6vp' })
          Text(item.away_team_zh).fontColor(0x1E1E20)
            .fontSize('15fp')
        }.width('45%')

      }.height('48vp').width('100%')

      if (item.anchor == null || item.anchor.length == 0) {
        this.buildPlayerUser(null, null, null)
      } else {
        Scroll() {
          List() {
            ForEach(item.anchor, (anchor: TvUser) => {
              this.buildPlayerUser(anchor, item.tournament_id, item.tournament_type)
            })
          }.listDirection(Axis.Horizontal)
          .height('100%')
          .width('100%')
        }
        .scrollable(ScrollDirection.Horizontal)
        .height('48vp')
        .width('100%')
        .linearGradient({ angle: 90, colors: [[0x3dFED8BD, 1.0], [0x00FED8BD, 1.0]] })
      }
    }.height('131vp').width('100%')
  }

  @Builder
  buildPlayerUser(item?: TvUser, tournament_id?: number, type?: number) {
    Column() {
      Image(item ? item.face : $r('app.media.icon_empty_live_user_1'))
        .width('20vp')
        .height('20vp')
        .alt($r('app.media.icon_default_avatar'))
        .margin({ top: '5vp' })

        .borderRadius('10vp')
      Text(item ? item.username : '暂无主播')
        .margin({ top: '5vp' })
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .fontSize('13fp')
        .fontColor(0x5B5E68)
    }.height('100%').width('18%').onClick(() => {
      if (item != null) {
        router.pushUrl({ url: 'liveInfo/LiveContentPage', params: {
          "tournamentId": tournament_id,
          "url": item.url,
          "type": type,
          "memberId": item.member_id
        } })
      } else {
        promptAction.showToast({ message: '暂无主播', duration: 1500 })
      }
    })
  }

  aboutToAppear() {

  }
}