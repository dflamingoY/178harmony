export class OddsData {
  asia: Array<OddsBean> = []
  bs: Array<OddsBean> = []
  eu: Array<OddsBean> = []
}

export class OddsBean {
  id: number = 0
  tournament_id: number = 0
  company_id: number = 0
  type: number = 0
  sort: number = 0
  a: string = ''
  b: string = ''
  c: string = ''
  d: string = ''
  e: string = ''
  f: string = ''
  change_time: string = ''
  create_time: string = ''
  company_name: string = ''
  name: string = ''
}

export class GameOddBean {
}
