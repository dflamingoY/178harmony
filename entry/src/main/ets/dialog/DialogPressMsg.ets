import systemDateTime from '@ohos.systemDateTime'
import { MsgBean } from '../data/MsgBean'
import IColors from '../utils/IColors'
import IConstant from '../utils/IConstant'

@CustomDialog
export struct DialogPressMsg {
  controller?: CustomDialogController
  msgBean: MsgBean | null
  onRevoke: (msg: MsgBean) => void
  onCollect: (msg: MsgBean) => void
  onDelete: (msg: MsgBean) => void
  @State currentTime: number = 0

  build() {
    Column() {
      if (this.msgBean != null && this.currentTime < this.msgBean.timestamp + 180 && this.msgBean.msgStatus == 0 && this.msgBean.from == globalThis.uid)
        Text('撤回')
          .width(IConstant.MATCH_PARENT)
          .height('50vp')
          .textAlign(TextAlign.Center)
          .fontSize('16fp')
          .fontColor(IColors.color1R1E20)
          .onClick(() => {
            this.controller.close()
            this.onRevoke(this.msgBean)
          })

      Text('收藏')
        .width(IConstant.MATCH_PARENT)
        .height('50vp')
        .fontSize('16fp')
        .textAlign(TextAlign.Center)
        .fontColor(IColors.color1R1E20)
        .onClick(() => {
          this.controller.close()
          this.onCollect(this.msgBean)
        })
      Text('删除')
        .width(IConstant.MATCH_PARENT)
        .height('50vp')
        .fontSize('16fp')
        .textAlign(TextAlign.Center)
        .fontColor(IColors.color1R1E20)
        .onClick(() => {
          this.controller.close()
          this.onDelete(this.msgBean)
        })
      Text('取消')
        .width(IConstant.MATCH_PARENT)
        .height('50vp')
        .fontSize('16fp')
        .textAlign(TextAlign.Center)
        .fontColor(IColors.color999)
        .onClick(() => {
          this.controller.close()
        })
    }.width(IConstant.MATCH_PARENT)
    .borderRadius(0)
  }

  aboutToAppear() {
    systemDateTime.getCurrentTime(false).then((time) => {
      this.currentTime = Math.ceil(time / 1000)
    })
  }
}