//视频播放控制器
import IColors from '../utils/IColors';

@Component
export struct VideoBottom {
  @State currentTime: string = '00:00';
  @State totalTime: string = '00:00';
  @State progressVal: number = 0;

  build() {
    Row() {
      Image($r('app.media.ic_pause'))
        .width('24vp')
        .height('24vp')
        .margin({ left: '12vp' })
        .onClick(() => {

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

        })
      Text(this.totalTime)
        .fontSize('14fp')
        .fontColor(Color.White)
        .margin({ left: '10vp', right: '12vp' })

    }
  }
}