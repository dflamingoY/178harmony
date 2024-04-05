import { MatchBean, MatchDayEntity } from '../../data/Data'

export default class MatchModel {
  allData: Array<MatchDayEntity>
  private footBall: Array<MatchDayEntity> = []
  private basketBall: Array<MatchDayEntity> = []
  private game: Array<MatchDayEntity> = []
  private other: Array<MatchDayEntity> = []

  parseOtherData() {
    this.allData.forEach((item: MatchDayEntity) => {
      let entityFoot = new MatchDayEntity()
      entityFoot.date = item.date
      try {
        entityFoot.list = item.list.filter((item: MatchBean) => {
          return item.tournament_type == 1
        })
      } catch (e) {
      }
      this.footBall.push(entityFoot)

      let entityBasket = new MatchDayEntity()
      entityBasket.date = item.date
      try {
        entityBasket.list = item.list.filter((item: MatchBean) => {
          return item.tournament_type == 2
        })
      } catch (e) {
      }
      this.basketBall.push(entityBasket)

      let entityGame = new MatchDayEntity()
      entityGame.date = item.date
      try {
        entityGame.list = item.list.filter((item: MatchBean) => {
          return item.is_game == 1
        })
      } catch (e) {
      }
      this.game.push(entityGame)
      let entityOther = new MatchDayEntity()
      entityOther.date = item.date
      try {
        entityOther.list = item.list.filter((item: MatchBean) => {
          return item.tournament_type != 1 && item.tournament_type != 2 && item.is_game != 1
        })
      } catch (e) {
      }
      this.other.push(entityOther)
    })
  }

  update(value: any) {
    try {
      let find0 = this.allData[0].list.find((item) => {
        return item.tournament_id == value['match_id'] && item.tournament_type == value['match_type']
      })
      if (find0 == null) {
        let find1 = this.allData[1].list.find((item) => {
          return item.tournament_id == value['match_id'] && item.tournament_type == value['match_type']
        })
        // let index = this.allData[1].list.indexOf(find1)
        let onTime = value['on_time']
        if (onTime) {
          find1.on_time = onTime
        }
        let away_score = value['away_score']
        if (away_score) {
          find1.away_score = away_score
        }
        let home_score = value['home_score']
        if (home_score) {
          find1.home_score = home_score
        }
        let state = value["state"]
        if (state) {
          find1.state = state
        }
        this.allData = [...this.allData]
      } else {
        let onTime = value['on_time']
        if (onTime) {
          find0.on_time = onTime
        }
        let away_score = value['away_score']
        if (away_score) {
          find0.away_score = away_score
        }
        let home_score = value['home_score']
        if (home_score) {
          find0.home_score = home_score
        }
        let state = value["state"]
        if (state) {
          find0.state = state
        }
        this.allData = [...this.allData]
      }
    } catch (e) {
    }
  }

  getShowList(index: number): Array<MatchDayEntity> {
    switch (index) {
      case 0:
        return this.allData
        break
      case 1:
        return this.footBall
        break
      case 2:
        return this.basketBall
        break
      case 3:
        return this.game
        break
      case 4:
        return this.other
        break
    }
  }
}