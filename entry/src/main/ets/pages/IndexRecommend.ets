import RecommendData, { MatchBean } from '../data/Data';
import display from '@ohos.display';
import router from '@ohos.router';
import IndexRecommendModel from './IndexRecommendModel';

//new_index
@Entry
@Component
export struct IndexRecommend {
  @State model: RecommendData = new RecommendData()
  @State isRefreshing: boolean = false
  private swiperController: SwiperController = new SwiperController();
  matchWidth = 0
  matchHeight = 0

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Image($r('app.media.draw_home_bg'))
        .width('100%')
      Flex({ direction: FlexDirection.Column }) {

        Flex({ direction: FlexDirection.Row }) {
          Image($r('app.media.app_icon'))
            .width('31vp')
            .height('31vp')
            .margin({ left: "15vp", top: '8.5vp' })

          Row() {
              Image($r('app.media.icon_search'))
                .width('17vp')
                .height('17vp')
                .margin({left:'12vp'})
            Text('搜索球队、主播')
              .fontSize('12fp')
              .margin({left:'12vp'})
              .fontColor(0x99ffffff)
              .width('100%')
          }
          .backgroundColor(Color.Red)
          .backgroundColor(0x33ffffff)
          .margin({left:'12vp',top:'8.5vp',right:'12vp'})
          .borderRadius('17vp')
          .height('31vp')

        }.height('48vp')
        .width('100%')

        Refresh({ refreshing: $$this.isRefreshing, offset: 120, friction: 100 }) {
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
        }.onRefreshing(() => {
          this.loadData()
        })
      }
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
    this.loadData()
  }

  loadData() {
    IndexRecommendModel.getIndex().then((data: RecommendData) => {
      this.model = data
      this.isRefreshing = false
    }).catch(() => {
      this.isRefreshing = false
    })
  }

  jumpDetails(item: MatchBean) {
    router.pushUrl({ url: "liveInfo/LiveContentPage", params: {
      "tournamentId": item.tournament_id,
      "url": item.url,
      "type": item.type,
      "memberId": item.member_id } })

    //跳转Ability
    // const want: Want = {
    //   bundleName: getContext(this).applicationInfo.name,
    //   abilityName: 'LiveAbility',
    //   parameters: {
    //     "tournamentId": item.tournament_id,
    //     "url": item.url,
    //     "type": item.type,
    //     "memberId": item.member_id
    //   }
    // }
    // let con = getContext(this) as AppContext.UIAbilityContext;
    // try {
    //   con.startAbility(want).catch((err: Error) => {
    //     hilog.debug(0x00ff00, "West", `${err.message}`)
    //   })
    // } catch (e) {
    //   hilog.debug(0x00ff00, "West", `${e}`)
    // }
  }
}