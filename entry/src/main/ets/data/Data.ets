export class BaseResp {
  code: number
  msg: string
  data: object

  constructor() {
    this.code = 0;
    this.msg = '';
  }
}

export default class RecommendData {
  banner: Array<MatchBean> = []
  recommend: Array<MatchBean> = []
  hot_matches: Array<MatchBean> = []
  is_video: number //0 直播 1 回放
}
//
export class MatchBean {
  type: number = 1
  tournament_id: number = 0
  home_team_zh: string = ''
  away_team_zh: string = ''
  home_logo: string = ''
  away_logo: string = ''
  home_score: number = 0
  away_score: number = 0
  league_name_zh: string = ''
  color: string = ''
  cover: string = ''
  url: string = ''
  username: string = ''
  face: string = ''
  member_id: number = 0
  viewer: number = 0
  nickname: string = ''
  state: number = 0 //1 直播中 0 未开始     电竞 1未开始 2 进行中 3完结 11 中断
  is_video: number = 0 //1video 0 live
  on_time: string = ''
  start_time: string = ''
  start_time_int: number = 0
  is_game: number = 0
  list_type: number = 0
  tournament_type: number = 0
  anchor: Array<TvUser> = []
  title: string = ''
  id: number = 0
  video_url: string = ''
  jump_type: number = 0
}

export class TvUser {
  member_id: number = 0
  username: string = ''
  url: string = '' //播放地址
  face: string = '' //头像
  room_user_num: number = 0
  state: number = 0
  tournament_id: number = 0
  viewer: number = 0 //人气
  cover: string = ''
}

export class MatchListData {
  match_list: Array<MatchDayEntity> = []
  date_list?: Array<MatchDateEntity>
}


export class MatchDateEntity {
  date: string = ''
  week: string = ''
}

export class MatchDayEntity {
  date: string = ''
  list?: Array<MatchBean>
}
