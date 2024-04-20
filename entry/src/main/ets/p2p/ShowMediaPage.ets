import router from '@ohos.router'
import { MsgBean } from '../data/MsgBean'
import Dao from '../db/Dao'
import CommonUtil from '../utils/CommonUtil'
import IConstant from '../utils/IConstant'

@Component
@Entry
export struct ShowMediaPage {
  @State resArray: Array<MsgBean> = []
  @State currentIndex: number = 0

  build() {
    Swiper() {
      ForEach(this.resArray, (item: MsgBean) => {
        this.buildRes(item)
      })
    }
    .indicator(false)
    .loop(false)
    .index(this.currentIndex)
    .duration(50)
  }

  @Builder
  private buildRes(item: MsgBean) {
    if (item.content_type == "img") {
      Image(item.content)
        .width(IConstant.MATCH_PARENT)
        .height(IConstant.MATCH_PARENT)
    } else {
      Stack({ alignContent: Alignment.Center }) {
        Image(item.remark)
          .width(IConstant.MATCH_PARENT)
          .height(IConstant.MATCH_PARENT)
        Image($r('app.media.icon_video_play'))
          .width('80vp')
          .height('80vp')
          .backgroundColor(0x7fffffff)
          .borderRadius('40vp')

      }.width(IConstant.MATCH_PARENT)
      .height(IConstant.MATCH_PARENT)
    }
  }

  aboutToAppear() {
    let params = router.getParams() as Record<string, string>
    let listId = params.listId as string
    let selectId = params.id as unknown as number
    this.getAllRes(listId, selectId)
  }

  private getAllRes(listId: string, selectId: number) {
    Dao.getRdbModel()?.getResByListId(listId).then((value) => {
      this.resArray = value
      let find = this.resArray.find((item) => {
        return item.id == selectId
      })
      if (find) {
        this.currentIndex = this.resArray.indexOf(find)
      }
    }).catch(() => {
      CommonUtil.showToast("数据查询错误")
    })
  }
}