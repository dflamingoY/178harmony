import dataPreferences from '@ohos.data.preferences';
import hilog from '@ohos.hilog';
import IConstant from './IConstant';

let shared: dataPreferences.Preferences = null

export function initSp() {
  dataPreferences.getPreferences(getContext(), IConstant.SP_NAME, function (err, sp) {
    shared = sp
    getAll()
  })
}

export function getAll() {
  shared.get("token", null).then((value) => {
    AppStorage.SetAndLink("token", value)
  })
  shared.get("uid", undefined).then((value) => {
    AppStorage.SetAndLink("uid", value)
  })
}

export function saveString(key: string, value: string) {
  try {
    shared.put(key, value)
    shared.flush()
  } catch (e) {
    e
  }
}

export function saveNumber(key: string, value: number) {
  try {
    shared.put(key, value)
    shared.flush()
  } catch (e) {
    e
  }
}
