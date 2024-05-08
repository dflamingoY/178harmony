//视频播放控制器
import { VideoPresenter } from '../liveInfo/VideoPresenter';
import IColors from '../utils/IColors';

@Component
export struct VideoBottom {
  private videoController: VideoPresenter | null = null
  @State currentTime: string = '00:00';
  @State totalTime: string = '00:00';
  @State progressVal: number = 0;
  @Consume state: number

  build() {
    Row() {
      Image(this.state == 1 ? $r('app.media.ic_pause') : $r('app.media.ic_play'))
        .width('24vp')
        .height('24vp')
        .margin({ left: '12vp' })
        .onClick(async () => {
          if (this.videoController !== null) {
            let curStatus = (this.videoController.getStatus() === 1);
            this.state = curStatus ? 2 : 1;
            this.videoController.switchPlayOrPause();
          }
        })

      Text(this.currentTime)
        .fontSize('14fp')
        .fontColor(Color.White)
        .margin({ left: '12vp' })
      Slider({
        value: this.progressVal,
        step: 1,
        style: SliderStyle.OutSet
      })
        .blockColor(Color.White)
        .trackColor(IColors.color999)
        .selectedColor(Color.White)
        .trackThickness(1)
        .layoutWeight(1)
        .margin({ left: '10vp' })
        .onChange((value: number, mode: SliderChangeMode) => {
          this.videoController.setSeekTime(value, mode);
        })
      Text(this.totalTime)
        .fontSize('14fp')
        .fontColor(Color.White)
        .maxLines(1)
        .margin({ left: '10vp', right: '12vp' })

    }
  }

  aboutToAppear() {
    if (this.videoController) {
      this.videoController.setProgressCallback((pro: string, total: string, val: number) => {
        this.currentTime = pro
        this.totalTime = total
        this.progressVal = val
      })
    }
  }
}