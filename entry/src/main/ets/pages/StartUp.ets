import router from '@ohos.router'
import { initWs } from '../net/Socket'
import { initSp } from '../utils/SpUtil'

@Entry
@Component
struct StartUp {
  @State message: string = 'Hello World'

  build() {
    Row() {
      Image($r("app.media.draw_splash_5"))
        .width('100%')
        .height('100%')
    }
    .height('100%')
  }

  aboutToDisappear() {
    clearTimeout(-1);
  }

  onPageShow() {
    initSp()
    initWs()
    setTimeout(() => {
      router.replaceUrl({ url: 'pages/HomePage' });
    }, 1000)
  }
}

// https://repo.huaweicloud.com/repository/npm/.
