import router from '@ohos.router'
import { UserBean } from '../data/user'
import Dao from '../db/Dao'
import SocketTask from '../net/SocketTask'
import PreferenceModel from '../utils/PreferenceModel'
import UserViewModel from './UserViewModel'

@Entry
@Component
struct StartUp {
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
    SocketTask.createWs()
    PreferenceModel.getString("user", null).then((value?: string) => {
      // LogUtil.d("West", '获取到缓存数据：' + value)
      if (value != null) {
        let user: UserBean = JSON.parse(value)
        globalThis.token = user.token
        globalThis.uid = user.uid
        globalThis.user = user
      }
      Dao.getRdbModel()
      UserViewModel.getOffline()
      setTimeout(() => {
        router.pushUrl({ url: 'pages/HomePage' },);
      }, 1000)
    }).catch(() => {
      setTimeout(() => {
        router.pushUrl({ url: 'pages/HomePage' });
      }, 1000)
    })
  }
}

// https://repo.huaweicloud.com/repository/npm/.
