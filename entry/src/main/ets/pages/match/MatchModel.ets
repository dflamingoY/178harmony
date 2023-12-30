import hilog from '@ohos.hilog'
import { MatchBean, MatchDayEntity } from '../../data/Data'

export default class MatchModel {
  allData: Array<MatchDayEntity>
  footBall: Array<MatchDayEntity> = []
  basketBall: Array<MatchDayEntity> = []
  game: Array<MatchDayEntity> = []
  other: Array<MatchDayEntity> = []

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