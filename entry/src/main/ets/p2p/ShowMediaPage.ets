import router from '@ohos.router'
import { MsgBean } from '../data/MsgBean'
import Dao from '../db/Dao'
import { AvplayerStatus, VideoPresenter } from '../liveInfo/VideoPresenter'
import CommonUtil from '../utils/CommonUtil'
import IConstant from '../utils/IConstant'
import { MediaVideoPage } from '../widget/MediaVideoPage'

@Component
@Entry
export struct ShowMediaPage {
  @State resArray: Array<MsgBean> = []
  @State currentIndex: number = 0
  private videoController: VideoPresenter = new VideoPresenter()
  @Provide avState: AvplayerStatus = AvplayerStatus.IDLE

  build() {
    Swiper() {
      ForEach(this.resArray, (item: MsgBean) => {
        this.buildRes(item)
      })
    }
    .indicator(false)
    .loop(false)
    .onChange((index) => {

    })
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
      MediaVideoPage({ msgBean: item, videoController: this.videoController })
    }
  }

  aboutToAppear() {
    let params = router.getParams() as Record<string, string>
    let listId = params.listId as string
    let selectId = params.id as unknown as number
    this.getAllRes(listId, selectId)
    this.videoController.setStateCallback((state) => {
      this.avState = state
    })
  }

  private getAllRes(listId: string, selectId: number) {
    Dao.getRdbModel()?.getResByListId(listId).then((value) => {
      this.resArray = value.concat(value).concat(value)
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

  onPageHide() {
    this.videoController.pause()
  }

  aboutToDisappear() {
    this.videoController.release()
  }
}