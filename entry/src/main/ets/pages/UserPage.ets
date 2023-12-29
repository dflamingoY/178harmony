import Want from '@ohos.app.ability.Want'
import hilog from '@ohos.hilog'
import AppContext from '@ohos.app.ability.common';

@Entry
@Component
export struct UserPage {
  @State message: string = '我的'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold).onClick(() => {
          const want: Want = {
            bundleName: getContext(this).applicationInfo.name,
            abilityName: 'LoginAbility',
          }
          let con = getContext(this) as AppContext.UIAbilityContext;
          try {
            con.startAbility(want).catch((err: Error) => {
              hilog.debug(0x00ff00, "Mozator", `${err.message}`)
            })
          } catch (e) {
            hilog.debug(0x00ff00, "Mozator", `${e}`)
          }
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}