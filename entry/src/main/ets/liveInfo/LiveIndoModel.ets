import { BaseResp } from '../data/Data'
import { post } from '../net/HttpUtils'

export class LiveInfoModel {
  getLiveInfo(tournamentId: number, type: number, memberId: number): Promise<Object> {
    return new Promise((resolve: Function, reject: Function) => {
      post(`get_match/${type}/detail/${tournamentId}`, { "member_id": memberId }).then((value: BaseResp) => {
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
