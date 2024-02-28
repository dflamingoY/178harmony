import { RdbModel } from '../pages/RdbModel';

class Dao {
  private rdbModel: RdbModel = null

  getRdbModel(): RdbModel {
    if (globalThis.uid == null) {
      return null
    }
    if (this.rdbModel == null) {
      this.rdbModel = new RdbModel()
    }
    return this.rdbModel
  }

  destroy() {

  }
}

export default new Dao()