import { BaseResp, MatchListData } from '../../data/Data'
import { getData } from '../../net/HttpUtils'

class MatchViewModel {
  getMatch(): Promise<MatchListData> {
    return new Promise((resolve: Function, reject: Function) => {
      getData('get_match_lists/99').then((value: BaseResp) => {
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

let matchViewModel = new MatchViewModel()

export default matchViewModel as MatchViewModel