import router from '@ohos.router'
import { GroupBean } from '../../data/GroupData'
import IConstant from '../../utils/IConstant'
import UserViewModel from '../UserViewModel'

@Entry
@Component //群列表
export struct GroupListPage {
  @State groups: Array<GroupBean> = []

  build() {
    Column() {
      Stack({ alignContent: Alignment.Start }) {

        Text('群聊')
          .fontColor(0x333333)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .fontSize('17fp')
          .width('100%')

        Image($r('app.media.icon_back'))
          .margin({ left: '15vp' })
          .height('21vp')
          .width('21vp')
          .onClick(() => {
            router.back()
          })
      }.width('100%')
      .height('48vp')

      Row() {
        Image($r('app.media.icon_search'))
          .width('17vp')
          .height('17vp')
          .margin({ left: '12vp' })
        Text('搜索')
          .fontSize('12fp')
          .margin({ left: '12vp' })
          .fontColor(0x99ffffff)
          .width('100%')
      }
      .backgroundColor(Color.Red)
      .backgroundColor(0xffffffff)
      .margin({ left: '12vp', top: '8.5vp', right: '12vp', bottom: '12vp' })
      .borderRadius('17vp')
      .height('31vp')

      if (this.groups.length > 0) {
        List() {
          ForEach(this.groups, (item: GroupBean) => {
            ListItem() {
              this.buildGroupItem(item)
            }
          })
        }.backgroundColor(Color.White)
      } else {
        Column() {
          Image($r('app.media.icon_search_empty'))
            .fitOriginalSize(true)
          Text('暂时没有数据')
            .margin({ top: '15vp' })
            .fontColor(0xff91939A)
            .fontSize('15fp')
        }
        .height('80%')
        .width('100%')
        .justifyContent(FlexAlign.Center)
      }
    }.backgroundColor(0xfff6f6f6)
  }

  @Builder
  buildGroupItem(item: GroupBean) {
    Stack({ alignContent: Alignment.Bottom }) {
      Row() {
        Image(item.avatar)
          .width('49vp')
          .height('49vp')
          .borderRadius('24.5vp')
          .alt($r('app.media.icon_default_group_avatar'))
          .margin({ left: '15vp' })

        Text(item.groupname)
          .fontSize('16fp')
          .fontColor(0xff333333)
          .margin({ left: '10vp', right: '10vp' })
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }.height('60vp')
      .width('100%')
      .onClick(() => {
        router.pushUrl({ url: 'p2p/P2PPage', params: {
          type: IConstant.GROUP,
          id: item.gid
        } })
      })

      Divider().strokeWidth(1).color('#F1F3F5')
        .margin({ left: '73vp' })
    }.height('60vp')
    .width('100%')
  }

  aboutToAppear() {
    UserViewModel.getGroupList().then((list) => {
      this.groups = list == null || list == undefined ? [] : list
    })
  }
}