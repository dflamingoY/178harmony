import router from '@ohos.router'
import { GroupDetailsData } from '../../data/GroupData'
import UserViewModel from '../../pages/UserViewModel'
import IConstant from '../../utils/IConstant'

@Entry
@Component
export struct GroupDetails {
  private gid: string
  @State group: GroupDetailsData | null = null

  build() {
    Column() {
      Stack({ alignContent: Alignment.Start }) {

        Text('详细资料')
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


      Grid(){

      }

    }.width(IConstant.MATCH_PARENT)
    .height(IConstant.MATCH_PARENT)
  }

  aboutToAppear() {
    let params = router.getParams() as Record<string, string>
    this.gid = params.id
    UserViewModel.getGroupInfo(this.gid).then((group) => {
      this.group = group
    }).catch(() => {

    })
  }
}