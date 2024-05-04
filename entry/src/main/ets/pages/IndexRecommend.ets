import RecommendData, { MatchBean } from '../data/Data';
import display from '@ohos.display';
import router from '@ohos.router';
import IndexRecommendModel from './IndexRecommendModel';
import common from '@ohos.app.ability.common';
import IColors from '../utils/IColors';

//new_index
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
              .margin({ left: '12vp' })
            Text('搜索球队、主播')
              .fontSize('12fp')
              .margin({ left: '12vp' })
              .fontColor(0x99ffffff)
              .width('100%')
          }
          .backgroundColor(Color.Red)
          .backgroundColor(0x33ffffff)
          .margin({ left: '12vp', top: '8.5vp', right: '12vp' })
          .borderRadius('17vp')
          .height('31vp')

        }.height('48vp')
        .width('100%')
        .onClick(() => {
          router.pushUrl({ url: 'pages/match/SearchMatchPage' })
        })

        Refresh({ refreshing: $$this.isRefreshing, offset: 120, friction: 100 }) {
          Scroll() {
            Column({ space: 12 }) {
              //banner
              Swiper(this.swiperController) {
                ForEach(this.model.banner, (item: MatchBean) => {
                  Image(item.cover).borderRadius($r('app.float.home_swiper_borderRadius')).onClick(() => {
                    this.jumpDetails(item)
                  }).alt($r('app.media.icon_news_default'))
                }, (item: MatchBean, index?: number) => {
                  return item.cover
                })
              }
              .autoPlay(this.model.banner.length > 1)
              .height($r('app.float.banner_height'))
              .width('90%')
              .margin({ top: "12vp" })
              .align(Alignment.Top)
              //热门比赛
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
                  ForEach(this.model.hot_matches, (item: MatchBean) => {
                    ListItem() {
                      Stack({ alignContent: Alignment.TopStart }) {
                        Rect({ width: '100%', height: 27 })
                          .radius([[8, 8], [8, 8]])
                          .fill(0x353B49)
                        Row() {
                          Text(item.league_name_zh)
                            .fontColor(0xfed8bd)
                            .fontSize('12fp')
                              // .textOverflow({ overflow: TextOverflow.Ellipsis })
                            .maxLines(1)
                            .margin({ left: '10vp' })
                          Blank()
                          Text(item.start_time)
                            .fontColor(0xfed8bd)
                            .fontSize('11fp')
                        }.height(27)
                        .width('100%')
                        .justifyContent(FlexAlign.SpaceBetween)

                        Column() {
                          Row() {
                            Image(item.home_logo)
                              .width(20)
                              .height(20)
                              .alt(item.type == 1 ? $r('app.media.icon_football') : $r('app.media.icon_basketball'))
                              .margin({ left: 8 })
                            Text(item.home_team_zh)
                              .fontSize(13)
                              .fontColor(0x1e1e20)
                              .margin({ left: 8 })
                              .maxLines(1)
                              .width("50%")
                            Blank()
                            Text(`${item.home_score}`)
                              .fontSize(13)
                              .fontColor(0xD61818)
                              .margin({ right: '10vp' })
                          }.margin({ top: 5 })

                          Row() {
                            Image(item.away_logo)
                              .width(20)
                              .height(20)
                              .alt(item.type == 1 ? $r('app.media.icon_football') : $r('app.media.icon_basketball'))
                              .margin({ left: 8 })
                            Text(item.away_team_zh)
                              .fontSize(13)
                              .fontColor(0x1e1e20)
                              .maxLines(1)
                              .margin({ left: 8 })
                              .width("50%")
                            Blank()
                            Text(`${item.away_score}`)
                              .fontSize(13)
                              .fontColor(0xD61818)
                              .margin({ right: '10vp' })
                          }.margin({ bottom: 5 })
                        }.height(53)
                        .margin({ top: 27 })
                        .justifyContent(FlexAlign.SpaceBetween)
                      }
                      .height('100%')
                      .borderWidth('1vp')
                      .backgroundColor(Color.White)
                      .margin({ left: '10vp' })
                      .borderColor(0xf6f6f6)
                      .width('155vp')
                      .margin({ left: '10vp' })
                      .borderRadius('8vp')
                      .onClick(() => {
                        this.jumpDetails(item)
                      })
                    }.height('100%')
                  }, (item: MatchBean, index?: number) => {
                    return JSON.stringify(item)
                  })
                }.listDirection(Axis.Horizontal).height('80vp').width('100%')
              }
              //今日推荐
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
                    Column() {
                      Stack() {
                        Image(item.cover)
                          .borderRadius('10vp')
                          .margin({ left: '3vp', right: '3vp' })
                          .alt($r('app.media.icon_news_default'))
                          .height(`${this.matchHeight}px`)
                          .width(`${this.matchWidth - display.getDefaultDisplaySync().densityPixels * 6}px`)

                        Row() {
                          Image(item.face)
                            .alt($r('app.media.icon_default_avatar'))
                            .width('15vp')
                            .height('15vp')
                            .margin({ left: '8vp' })
                            .borderRadius('7.5vp')

                          Text(item.username??item.nickname)
                            .fontSize(12)
                            .fontColor(Color.White)
                            .margin({ left: '5vp' })
                          Blank()
                          if (item.is_video === undefined || item.is_video == 0) {
                            Image($r('app.media.icon_live_count_user'))
                              .width('10vp')
                              .height('14vp')
                            Text(`${item.viewer}`)
                              .fontColor(Color.White)
                              .margin({ left: '5vp' })
                              .margin({ right: '8vp' })
                              .fontSize('12vp')
                          }
                        }
                        .width(`${this.matchWidth - display.getDefaultDisplaySync().densityPixels * 6}px`)
                        .height('30vp')
                        .alignItems(VerticalAlign.Center)
                        .backgroundColor(0xb3000000)
                        .borderRadius({ bottomLeft: '10vp', bottomRight: '10vp' })

                        if (item.is_video === undefined || item.is_video == 0) {
                          Image($r('app.media.icon_playing'))
                            .width('40vp')
                            .height('20vp')
                            .objectFit(ImageFit.Cover)
                            .padding('5vp')
                            .backgroundColor(0x7f000000)
                            .borderRadius('10vp')
                            .margin({
                              left: `${this.matchWidth - display.getDefaultDisplaySync().densityPixels * 60}px`,
                              bottom: `${this.matchHeight - display.getDefaultDisplaySync().densityPixels * 30}px`
                            })
                        }
                      }.alignContent(Alignment.Bottom)

                      Text(item.is_video === undefined || item.is_video == 0 ? `${item.league_name_zh} ${item.home_team_zh} VS ${item.away_team_zh}` : item.title)
                        .textAlign(TextAlign.Start)
                        .width('100%')
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                        .margin({ top: '10vp', left: '5vp', right: '5vp' })
                        .maxLines(1)
                    }.margin({ top: '10vp' })
                  }
                  .onClick(() => {
                    this.jumpDetails(item)
                  })
                  .width(`${this.matchWidth}px`)
                  // .height(`${this.matchHeight}px`)
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
    .backgroundColor(IColors.colorf6f6f6)
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
    if (item.jump_type !== undefined) {
      if (item.jump_type == 1) { //进入直播间  v2 不支持此跳转
        // router.pushUrl({ url: "liveInfo/LiveContentPage", params: {
        //   "memberId": item.member_id } })
      } else { //跳外部浏览器
        let want = {
          "action": "ohos.want.action.viewData",
          "entities": ["entity.system.browsable"],
          "uri": item.url,
          "type": "text/plain"
        }
        let context = getContext(this) as common.UIAbilityContext;
        context.startAbility(want)
      }
    }
    else if (item.is_video === undefined || item.is_video == 0) {
      router.pushUrl({ url: "liveInfo/LiveContentPage", params: {
        "tournamentId": item.tournament_id,
        "url": item.url,
        "type": item.type,
        "memberId": item.member_id } })
    } else {
      router.pushUrl({ url: 'pages/other/ReplayPage', params: { 'id': item.id,
        'url': item.video_url,
        "data": JSON.stringify(this.model.recommend)
      } })
    }
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