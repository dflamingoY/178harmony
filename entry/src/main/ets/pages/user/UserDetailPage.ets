import router from '@ohos.router'
import { PageState } from '../../data/PageState'
import { UserBean } from '../../data/user'
import IColors from '../../utils/IColors'
import IConstant from '../../utils/IConstant'
import LogUtil from '../../utils/LogUtil'
import { LoadingPage } from '../../widget/LoadingPage'
import UserViewModel from '../UserViewModel'
import { EditNamePage } from './EditNamePage'

@Component
@Entry
export struct UserDetailPage {
  @State user: UserBean = new UserBean()
  nickname: string = ''
  @State isEdit: boolean = false
  @State loadingState: PageState = PageState.Content
  resultMethod = (value: number, result: string) => {
    LogUtil.d("West", 'result: ' + result)
    if (value == 0) { //修改昵称
      this.isEdit = false
      if (result != '' && result != this.user.nickname) {
        this.nickname = result
        this.updateNickname()
      }
    } else {
      if (result != this.user.sign) {
        this.sign = result
        this.updateSign()
      }
    }
  }
  editModel: number = 0 //0昵称1签名
  @State sign: string = ''

  build() {
    Stack() {
      Column() {
        Stack({ alignContent: Alignment.Start }) {
          Text('个人资料')
            .fontColor(Color.Black)
            .textAlign(TextAlign.Center)
            .fontSize('20fp').width('100%')
          Image($r('app.media.icon_back'))
            .width('22vp')
            .height('22vp')
            .margin({ left: "15vp" })
            .onClick(() => {
              router.back()
            })
        }.width('100%')
        .height('50vp')

        Row() {
          Text('头像')
            .fontSize('15fp')
            .fontColor(IColors.color1R1E20)
            .margin({ left: '12vp' })
          Blank()
            .layoutWeight(1)
          Image(this.user.avatar)
            .width('42vp')
            .height('42vp')
            .borderRadius('21vp')
            .alt($r('app.media.icon_default_avatar'))
            .margin({ right: '12vp' })
        }
        .margin({ left: '12vp', right: '12vp', top: '20vp' })
        .height('70vp')
        .backgroundColor(Color.White)
        .borderRadius({ topLeft: '10pv', topRight: '10vp' })

        Row() {
          Text('昵称')
            .fontSize('15fp')
            .fontColor(IColors.color1R1E20)
            .margin({ left: '12vp' })
          Blank().layoutWeight(1)
          Text(this.user.nickname)
            .fontSize('15fp')
            .fontColor(IColors.color666)
          Image($r('app.media.icon_item_arrow'))
            .width('8vp')
            .fitOriginalSize(true)
            .margin({ left: '12vp', right: '12vp' })
        }.height('54vp')
        .backgroundColor(Color.White)
        .margin({ left: '12vp', right: '12vp' })
        .onClick(() => {
          this.editModel = 0
          this.nickname = this.user.nickname
          this.isEdit = true
        })

        Row() {
          Text('我的二维码')
            .fontSize('15fp')
            .fontColor(IColors.color1R1E20)
            .margin({ left: '12vp' })
          Blank().layoutWeight(1)

          Image($r('app.media.icon_user_qr_code'))
            .width('24vp')
            .height('24vp')

          Image($r('app.media.icon_item_arrow'))
            .width('8vp')
            .fitOriginalSize(true)
            .margin({ left: '12vp', right: '12vp' })

        }.height('54vp')
        .backgroundColor(Color.White)
        .margin({ left: '12vp', right: '12vp' })
        .onClick(() => {
          router.pushUrl({ url: "pages/other/UserQrPage", params: {
            uid: this.user.uid,
            nickname: this.user.nickname,
            account: this.user.username
          } })
        })

        Row() {
          Text('178号')
            .fontSize('15fp')
            .fontColor(IColors.color1R1E20)
            .margin({ left: '12vp' })
          Blank().layoutWeight(1)
          Text(this.user.username)
            .fontSize('15fp')
            .fontColor(IColors.color666)
            .margin({ right: '12vp' })
        }.height('54vp')
        .backgroundColor(Color.White)
        .borderRadius({ bottomLeft: '10vp', bottomRight: '10vp' })
        .margin({ left: '12vp', right: '12vp' })

        Row() {
          Text('手机号')
            .fontSize('15fp')
            .fontColor(IColors.color1R1E20)
            .margin({ left: '12vp' })
          Blank().layoutWeight(1)
          Text(this.user.phone)
            .fontSize('15fp')
            .fontColor(IColors.color666)
            .margin({ right: '12vp' })
        }
        .height('54vp')
        .backgroundColor(Color.White)
        .borderRadius({ topRight: '10vp', topLeft: '10vp' })
        .margin({ left: '12vp', right: '12vp', top: '10vp' })

        Row() {
          Text('个性签名')
            .fontSize('15fp')
            .fontColor(IColors.color1R1E20)
            .margin({ left: '12vp' })

          Text(this.user.sign)
            .layoutWeight(1)
            .margin({ left: '12vp', right: '12vp' })
            .fontSize('15fp')
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(2)
            .fontColor(IColors.color666)

          Image($r('app.media.icon_item_arrow'))
            .width('8vp')
            .fitOriginalSize(true)
            .margin({ left: '12vp', right: '12vp' })
        }
        .height('54vp')
        .backgroundColor(Color.White)
        .margin({ left: '12vp', right: '12vp' })
        .borderRadius({ bottomRight: '10vp', bottomLeft: '10vp' })
        .onClick(() => {
          this.editModel = 1
          this.isEdit = true
        })

      }.backgroundColor(IColors.colorF3F3F5)
      .width(IConstant.MATCH_PARENT)
      .height(IConstant.MATCH_PARENT)

      if (this.isEdit) {
        EditNamePage({
          content: this.editModel == 0 ? this.nickname : this.sign,
          isEdit: $isEdit,
          result: this.resultMethod,
          type: this.editModel
        })
          .width(IConstant.MATCH_PARENT)
          .height(IConstant.MATCH_PARENT)
      }
      if (this.loadingState == PageState.Progress) {
        LoadingPage()
      }
    }.width(IConstant.MATCH_PARENT)
    .height(IConstant.MATCH_PARENT)
  }

  private updateNickname() {
    this.loadingState = PageState.Progress
    UserViewModel.updateUserInfo({ "nickname": this.nickname })
      .then(() => {
        this.user.nickname = this.nickname
        this.loadingState = PageState.Content
      }).catch(() => {
      this.loadingState = PageState.Content
    })
  }

  private updateSign() {
    this.loadingState = PageState.Progress
    UserViewModel.updateUserInfo({ "sign": this.sign })
      .then(() => {
        this.user.sign = this.sign
        this.loadingState = PageState.Content
      }).catch(() => {
      this.loadingState = PageState.Content
    })
  }

  aboutToAppear() {
    this.user = globalThis.user
    UserViewModel.getUserInfo().then((user) => {
      this.user = user
      this.nickname = user.nickname
      this.sign = user.sign
    })
  }

  onBackPress() {
    if (this.isEdit) {
      this.isEdit = false
      return true
    }
  }
}