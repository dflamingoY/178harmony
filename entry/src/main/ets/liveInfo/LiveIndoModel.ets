import { BaseResp } from '../data/Data'
import { LiveInfo } from '../data/LiveDetailData'
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
}
