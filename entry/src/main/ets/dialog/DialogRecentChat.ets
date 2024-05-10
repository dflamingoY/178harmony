import { RecentBean } from '../data/MsgBean'
import IColors from '../utils/IColors'
import IConstant from '../utils/IConstant'

@CustomDialog
export struct DialogRecentChat {
  controller?: CustomDialogController
  recentBean: RecentBean | null
  onTop: (recent?: RecentBean) => void
  onDelete: (recent?: RecentBean) => void

  build() {

    Column() {
      Text(this.recentBean.name??'')
        .fontSize('15fp')
        .fontColor(IColors.colorOrange)
        .width(IConstant.MATCH_PARENT)
        .padding({ left: '20vp' })
        .height('50vp')

      Text(this.recentBean?.is_top == 1 ? "取消置顶" : "置顶聊天")
        .fontSize('15fp')
        .fontColor(IColors.color1R1E20)
        .height('50vp')
        .width(IConstant.MATCH_PARENT)
        .padding({ left: '20vp' })
        .onClick(() => {
          this.onTop(this.recentBean)
          this.controller.close()
        })
      Text("删除聊天")
        .fontSize('15fp')
        .fontColor(IColors.color1R1E20)
        .height('50vp')
        .width(IConstant.MATCH_PARENT)
        .padding({ left: '20vp' })
        .onClick(() => {
          this.onDelete(this.recentBean)
          this.controller.close()
        })
    }.width(IConstant.MATCH_PARENT)
  }
}