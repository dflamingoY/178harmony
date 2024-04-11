import router from '@ohos.router'
import systemDateTime from '@ohos.systemDateTime'
import { UserBean } from '../../data/user'
import CommonUtil from '../../utils/CommonUtil'
import UserViewModel from '../UserViewModel'

@Entry
@Component
export struct FriendRequestPage {
  @State applyList: Array<UserBean> = []
  private page: number = 1
  @State currentTime: number = 0

  build() {
    Column() {
      Stack({ alignContent: Alignment.Start }) {

        Text('新的朋友')
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

      if (this.applyList == null || !this.applyList || this.applyList.length == 0) {
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
      } else {
        List() {
          ForEach(this.applyList, (item: UserBean) => {
            ListItem() {
              this.buildItem(item)
            }
          })
        }.backgroundColor(Color.White)
      }
    }.backgroundColor(0xfff6f6f6)
    .height('100%')
  }

  @Builder
  private buildItem(item: UserBean) {
    Stack({ alignContent: Alignment.Bottom }) {

      Row() {
        Image(item.avatar)
          .alt($r('app.media.icon_default_avatar'))
          .height('45vp')
          .width('45vp')
          .margin({ left: '12vp' })
          .borderRadius('22.5vp')


        Column() {
          Text(item.nickname)
            .fontSize('15fp')
            .fontColor(0xff333333)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: '5vp' })
            .maxLines(1)
          Blank()
          if (item.remark != null) {
            Text(item.remark)
              .fontSize('12fp')
              .fontColor(0xff999999)
              .margin({ bottom: '5vp' })
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
          }


        }
        .height('49vp')
        .margin({ left: '12vp' })
        .alignItems(HorizontalAlign.Start)
        .width('60%')

        Blank()

        Column() {
          Text(item.operation == 'not_operated' ? "待处理" : item.operation == 'refuse' ? '已拒绝' : '已添加')
            .fontSize('13fp')
            .fontColor(item.operation == 'not_operated' ? 0xff6A9436 : item.operation == 'refuse' ? 0xff9F1E1E : 0xff999999)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: '5vp' })
            .maxLines(1)
          Blank()
          Text(CommonUtil.parseTime(this.currentTime - item.timestamp, item.timestamp))
            .fontSize('13fp')
            .fontColor(0xff666666)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ bottom: '5vp' })

        }.height('49vp')
        .margin({ right: '12vp' })
        .alignItems(HorizontalAlign.End)

      }.height('100%')
      .width('100%')

      Divider().strokeWidth(1).color('#F1F3F5')
        .margin({ left: '73vp' })
    }.height('60vp')
    .width('100%').onClick(() => {
      router.pushUrl({ url: "pages/contact/FriendDetailsPage", params: {
        uid: item.uid
      } })
    })
  }

  aboutToAppear() {
    UserViewModel.getFriendApplyList(this.page).then((data) => {
      this.applyList = data
    }).catch(() => {

    })

    systemDateTime.getCurrentTime(false).then((time: number) => {
      this.currentTime = time / 1000
    })
  }
}