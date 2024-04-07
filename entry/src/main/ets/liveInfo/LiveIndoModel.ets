import { BaseResp } from '../data/Data'
import { LiveInfo } from '../data/LiveDetailData'
import { GameOddBean, OddsData } from '../data/OddsData'
import { ChatRoomBean } from '../data/RoomData'
import { getData, post } from '../net/HttpUtils'

export class LiveInfoModel {
  getLiveInfo(tournamentId: number, type: number, memberId: number): Promise<LiveInfo> {
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

  getRoomHistory(roomId: string, currentPage: number): Promise<ChatRoomBean> {
    return new Promise((resolve: Function, reject: Function) => {
      getData(`get_room_msg/${roomId}?limit=20&type=down&page=${currentPage}`).then((value) => {
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

  //蓝足odd 获取
  getBallOdds(type: number, tournamentId: number): Promise<OddsData> {
    return new Promise((resolve: Function, reject: Function) => {
      getData(type == 1 ? `getfootball_oddshistory?id=${tournamentId}` : `getbasketball_oddshistory?id=${tournamentId}`)
        .then((value) => {
          if (value.code == 200) {
            resolve(value.data)
          } else {
            reject(value.msg)
          }
        })
        .catch((err: Error) => {
          reject(err.message)
        })
    })
  }

  //game odd 获取
  getGameOdd(type: number, tournamentId: number): Promise<Array<GameOddBean>> {
    return new Promise((resolve: Function, reject: Function) => {
      getData(type == 9 ? `kog_odds?tournament_id=${tournamentId}`
                        : type == 10 ? `dota2_odds?tournament_id=${tournamentId}`
                                     : type == 11 ? `csgo_odds?tournament_id=${tournamentId}`
                                                  : `lol_odds?tournament_id=${tournamentId}`)
        .then((result) => {

        }).catch((err: Error) => {

      })
    })
  }
}
