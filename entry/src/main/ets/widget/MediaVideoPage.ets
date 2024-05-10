import display from '@ohos.display'
import { MsgBean } from '../data/MsgBean'
import { AvplayerStatus, VideoPresenter } from '../liveInfo/VideoPresenter'
import IConstant from '../utils/IConstant'
import { LoadingPage } from './LoadingPage'
import { VideoBottom } from './VideoBottom'

@Component
export struct MediaVideoPage {
  msgBean: MsgBean
  videoController: VideoPresenter
  private xComponentController = new XComponentController();
  private surfaceID: string = '';
  @Consume avState: AvplayerStatus
  @Provide state: number = 1 //1 开始 2 暂停 3 停止

  build() {
    Stack({ alignContent: Alignment.Center }) {

      XComponent({ id: '', type: 'surface', libraryname: '', controller: this.xComponentController })
        .onLoad(async () => {
          this.xComponentController.setXComponentSurfaceSize({
            surfaceWidth: display.getDefaultDisplaySync().width,
            surfaceHeight: display.getDefaultDisplaySync().height
          });
          this.surfaceID = this.xComponentController.getXComponentSurfaceId();
        })
        .backgroundColor(Color.White)
        .width(IConstant.MATCH_PARENT)
        .height(IConstant.MATCH_PARENT)
      Column() {
        Blank()
        //展示视频长度等信息
        VideoBottom({ videoController: this.videoController })
      }
      .alignItems(HorizontalAlign.Start)
      .height(IConstant.MATCH_PARENT)

      if (this.avState === AvplayerStatus.PREPARED || this.avState === AvplayerStatus.IDLE || this.avState === AvplayerStatus.INITIALIZED) {
        LoadingPage()
        Image(this.msgBean.remark)
          .width(IConstant.MATCH_PARENT)
          .height(IConstant.MATCH_PARENT)
          .objectFit(ImageFit.Fill)

        Image($r('app.media.icon_video_play'))
          .width('50vp')
          .height('50vp')
          .onClick(() => {
            this.videoController.firstPlay(this.msgBean.content, this.surfaceID)
          })
      }
    }.width(IConstant.MATCH_PARENT)
    .height(IConstant.MATCH_PARENT)
  }
}