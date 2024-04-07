export class LiveInfo {
  detail: LiveDetailBean
  more: TvUser[] = []
}

export class LiveDetailBean {
  state: number = 0;
  league_name_zh: string = '';
  type: number = 0;
  member_id: string = '';
  url: string = '';
  cover: string = '';
  roomid: string = ''; //云信id
  username: string = '';
  face: string = '';
  screen_url: string = '';
  screen_url_m3u8: string = '';
  uid: string = '';
  nickname: string = '';
  is_friend: number = 0;
  room_id: string = ''
  home_team_zh: string = ''
  away_team_zh: string = ''
}

export class TvUser {
  tournament_id: string = '';
  cover: string = '';
  face: string = '';
  member_id: string = '';
  username: string = '';
  viewer: number = 0;
  isPlay: Boolean = false
}