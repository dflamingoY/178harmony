/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import relationalStore from '@ohos.data.relationalStore';
import IConstant from '../utils/IConstant';
import LogUtil from '../utils/LogUtil';

let STORE_CONFIG: relationalStore.StoreConfig = {
  name: globalThis.uid + IConstant.db_name,
  securityLevel: relationalStore.SecurityLevel.S1
};

export default class Rdb {
  private rdbStore: relationalStore.RdbStore | null = null;
  private tableName: string;
  private sqlCreateTable: string;
  private columns: Array<string>;

  constructor(tableName: string, sqlCreateTable: string, columns: Array<string>) {
    this.tableName = tableName;
    this.sqlCreateTable = sqlCreateTable;
    this.columns = columns;
  }

  getRdbStore(callback: Function = () => {
  }) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      LogUtil.d("Dao", 'getRdbStore() has no callback!');
      return;
    }
    if (this.rdbStore !== null) {
      LogUtil.d("Dao", 'The rdbStore exists.');
      callback();
      return
    }
    if (globalThis.uid == null) {
      LogUtil.d("Dao", '未登录不允许创建数据库');
      return
    }

    let context: Context = getContext(this) as Context;
    relationalStore.getRdbStore(context, STORE_CONFIG, (err, rdb) => {
      if (err) {
        LogUtil.d("Dao", `gerRdbStore() failed, err: ${err}`);
        return;
      }
      this.rdbStore = rdb;
      this.rdbStore.executeSql(this.sqlCreateTable);
      LogUtil.d("Dao", 'getRdbStore() finished.');
      callback();
    });
  }

  insertDataTx(data: relationalStore.ValuesBucket[], callback: Function = () => {
  }) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      LogUtil.d("Dao", 'insertData() has no callback!');
      return;
    }
    let resFlag: boolean = false;
    const valueBucket: relationalStore.ValuesBucket[] = data;
    if (this.rdbStore) {
      this.rdbStore.batchInsert(this.tableName, valueBucket, (err, ret) => {
        if (err) {
          LogUtil.d("Dao", `insertData() failed, err: ${err}`);
          callback(resFlag);
          return;
        }
        LogUtil.d("Dao", `insertData() finished: ${ret}`);
        callback(ret);
      });
    }
  }

  insertData(data: relationalStore.ValuesBucket, callback: Function = () => {
  }) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      LogUtil.d("Dao", 'insertData() has no callback!');
      return;
    }
    let resFlag: boolean = false;
    const valueBucket: relationalStore.ValuesBucket = data;
    if (this.rdbStore) {
      this.rdbStore.insert(this.tableName, valueBucket, (err, ret) => {
        if (err) {
          LogUtil.d("Dao", `insertData() failed, err: ${err}`);
          callback(resFlag);
          return;
        }
        LogUtil.d("Dao", `insertData() finished: ${ret}`);
        callback(ret);
      });
    }
  }

  deleteData(predicates: relationalStore.RdbPredicates, callback: Function = () => {
  }) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      LogUtil.d("Dao", 'deleteData() has no callback!');
      return;
    }
    let resFlag: boolean = false;
    if (this.rdbStore) {
      this.rdbStore.delete(predicates, (err, ret) => {
        if (err) {
          LogUtil.d("Dao", `deleteData() failed, err: ${err}`);
          callback(resFlag);
          return;
        }
        LogUtil.d("Dao", `deleteData() finished: ${ret}`);
        callback(!resFlag);
      });
    }
  }

  updateData(predicates: relationalStore.RdbPredicates, data: relationalStore.ValuesBucket, callback: Function = () => {
  }) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      LogUtil.d("Dao", 'updateDate() has no callback!');
      return;
    }
    let resFlag: boolean = false;
    const valueBucket: relationalStore.ValuesBucket = data;
    if (this.rdbStore) {
      this.rdbStore.update(valueBucket, predicates, (err, ret) => {
        if (err) {
          LogUtil.d("Dao", `updateData() failed, err: ${err}`);
          callback(resFlag);
          return;
        }
        LogUtil.d("Dao", `updateData() finished: ${ret}`);
        callback(!resFlag);
      });
    }
  }

  query(predicates: relationalStore.RdbPredicates, callback: Function = () => {
  }) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      LogUtil.d("Dao", 'query() has no callback!');
      return;
    }
    if (this.rdbStore) {
      this.rdbStore.query(predicates, this.columns, (err, resultSet) => {
        if (err) {
          LogUtil.d("Dao", `query() failed, err:  ${err}`);
          return;
        }
        LogUtil.d("Dao", 'query() finished.');
        callback(resultSet);
        resultSet.close();
      });
    }
  }

  querySql( sql: string): Promise<relationalStore.ResultSet> {
    if (this.rdbStore) {
      return this.rdbStore.querySql(sql, this.columns);
    } else return null
  }

  queryAsync(predicates: relationalStore.RdbPredicates): Promise<relationalStore.ResultSet> {
    if (this.rdbStore) {
      return this.rdbStore.query(predicates, this.columns)
    } else return null
  }
}