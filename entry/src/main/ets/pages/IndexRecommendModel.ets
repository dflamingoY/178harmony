import RecommendData, { BaseResp } from '../data/Data'
import { getData } from '../net/HttpUtils'

export class IndexRecommendModel {

  getIndex(): Promise<RecommendData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      getData("index").then((value: BaseResp) => {
        if (value.code == 200) {
          resolve(value.data)
        } else {
          reject(value.msg)
        }
      }).catch((err: Error) => {
        reject(err.message)
      })
    })
  }
}