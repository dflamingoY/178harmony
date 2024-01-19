import dataPreferences from '@ohos.data.preferences';
import IConstant from './IConstant';
import LogUtil from './LogUtil';

let context = getContext()
let preference: dataPreferences.Preferences;

class PreferenceModel {
  async getString(key: string, defaultValue?: string) {
    if (!preference) {
      await this.loadPreference()
    }
    var result = await preference.get(key, defaultValue)
    LogUtil.d("West", `查询结果：${result}`)
    return result
  }

  async loadPreference() {
    preference = await dataPreferences.getPreferences(context, IConstant.SP_NAME)
  }

  async putNormal(key: string, value: number | string | boolean | Array<number> | Array<string> | Array<boolean>) {
    if (!preference) {
      this.loadPreference()
    }
    await preference.put(key, value)
    await preference.flush()
  }

  async putJson(key: string, value: object) {
    if (!preference) {
      this.loadPreference()
    }
    await preference.put(key, JSON.stringify(value))
    await preference.flush()
  }

  async deleteKey(key: string) {
    if (!preference) {
      this.loadPreference()
    }
    await preference.delete(key)
    await preference.flush()
  }
}


export default new PreferenceModel()