import router from '@ohos.router';
import Want from '@ohos.app.ability.Want';
import RecommendData, { BaseResp, MatchBean } from '../data/Data';
import { getData } from '../net/HttpUtils'
import { IndexRecommendModel } from './IndexRecommendModel';
import AppContext from '@ohos.app.ability.common';
import hilog from '@ohos.hilog';
import display from '@ohos.display';

//new_index
@Entry
@Component
export struct IndexRecommend {
  @State model: RecommendData = new RecommendData()
  private swiperController: SwiperController = new SwiperController();
  matchWidth = 0
  matchHeight = 0

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Scroll() {
        Column({ space: 12 }) {
          Swiper(this.swiperController) {
            ForEach(this.model.banner, (item: MatchBean) => {
              Image(item.cover).borderRadius($r('app.float.home_swiper_borderRadius')).onClick(() => {
                this.jumpDetails(item)
              })
            }, (item: MatchBean, index?: number) => {
              return item.cover
            })
          }
          .autoPlay(this.model.banner.length > 1)
          .height($r('app.float.banner_height'))
          .width('90%')
          .margin({ top: "12vp" })
          .align(Alignment.Top)

          if (this.model.hot_matches.length > 0) {
            Row() {
              Image($r('app.media.icon_home_hot_league'))
                .width('20vp')
                .height('20vp')
              Text('热门比赛')
                .fontSize('16fp')
                .margin({ top: $r('app.float.mainPage_tabTitles_margin') })
                .padding({ left: $r('app.float.mainPage_tabTitles_padding') })
            }.alignItems(VerticalAlign.Bottom).align(Alignment.Start).width('100%').margin({ left: '15vp' })

            List({}) {
              ForEach(this.model.recommend, (item: MatchBean) => {
                ListItem() {
                  Stack() {
                    Image(item.cover)
                  }
                  .height('100%')
                  // .width(this.matchWidth)
                  .borderWidth('1vp')
                  .margin({ left: '10vp' })
                  .borderColor(0xf6f6f6)
                  .borderRadius('8vp')
                }.margin({ left: '10vp' })
              }, (item: MatchBean, index?: number) => {
                return JSON.stringify(item)
              })
            }.listDirection(Axis.Horizontal).height('80vp').width('100%')
          }

          Row() {
            Image($r('app.media.icon_hot_logo'))
              .width('20vp')
              .height('20vp')
            Text('今日推荐')
              .fontSize('16fp')
              .margin({ top: $r('app.float.mainPage_tabTitles_margin') })
              .padding({ left: $r('app.float.mainPage_tabTitles_padding') })
          }.alignItems(VerticalAlign.Bottom)
          .width('100%')
          .margin({ left: '15vp' })
          .align(Alignment.Start)

          List() {
            ForEach(this.model.recommend, (item: MatchBean) => {
              ListItem() {
                Stack() {
                  Image(item.cover).borderRadius('10vp')
                    .margin({ left: '3vp', right: '3vp' })
                }
              }
              .onClick(() => {
                this.jumpDetails(item)
              })
              .width(`${this.matchWidth}px`)
              .height(`${this.matchHeight}px`)
              .margin({ top: '6vp' })
            }, (item: MatchBean) => {
              return JSON.stringify(item)
            })
          }
          .alignListItem(ListItemAlign.Center)
          .margin({ left: '3vp', right: '3vp' })
          .lanes(2)
        }
      }.scrollBar(BarState.Off).scrollBar(BarState.Off)
    }
  }
  //宽高 16:9 初始化项目
  initMatchScreen() {
    let pixels = display.getDefaultDisplaySync().densityPixels
    let width = display.getDefaultDisplaySync().width
    this.matchWidth = (width - pixels * 6) / 2
    this.matchHeight = this.matchWidth * 9 / 16
  }

  aboutToAppear() {
    this.initMatchScreen()
    new IndexRecommendModel().getIndex().then((data: RecommendData) => {
      this.model = data
    })
  }

  jumpDetails(item: MatchBean) {
    const want: Want = {
      bundleName: getContext(this).applicationInfo.name,
      abilityName: 'LiveAbility',
      parameters: {
        "tournamentId": item.tournament_id,
        "url": item.url,
        "type": item.type,
        "memberId": item.member_id
      }
    }
    let con = getContext(this) as AppContext.UIAbilityContext;
    try {
      con.startAbility(want).catch((err: Error) => {
        hilog.debug(0x00ff00, "Mozator", `${err.message}`)
      })
    } catch (e) {
      hilog.debug(0x00ff00, "Mozator", `${e}`)
    }
  }
}