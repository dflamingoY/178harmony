import router from '@ohos.router'
import { initWs } from '../net/Socket'
import LogUtil from '../utils/LogUtil'
import PreferenceModel from '../utils/PreferenceModel'

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
    initWs()
    PreferenceModel.getString("token", null).then((value?: string) => {
      LogUtil.d("West", '获取到缓存数据：' + value)
      if (value != null) {
        globalThis.token = value
      }
    })
    setTimeout(() => {
      router.replaceUrl({ url: 'pages/HomePage' });
    }, 1000)
  }
}

// https://repo.huaweicloud.com/repository/npm/.
