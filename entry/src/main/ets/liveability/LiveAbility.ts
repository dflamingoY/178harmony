import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import Want from '@ohos.app.ability.Want';

export default class LiveAbility extends UIAbility {
  onCreate(want, launchParam) {
    let wantParams = want as Want
    globalThis.wantParams = wantParams
    var tournamentId = wantParams.parameters.tournamentId
    var url = wantParams.parameters.url
    var type = wantParams.parameters.type
    var memberId = wantParams.parameters.memberId
    let eventhub = this.context.eventHub;
    eventhub.on('event1', this.func1);
    hilog.debug(0xff0000, "West", `result : ${tournamentId}  ${url} ${type} ${memberId}`)
  }

  func1(...data) {
    // 触发事件，完成相应的业务操作
    hilog.debug(0xff0000, "West", `result : 消息通知`)
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('liveInfo/LiveContentPage', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
