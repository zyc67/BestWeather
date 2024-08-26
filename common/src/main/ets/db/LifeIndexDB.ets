import { relationalStore, ValuesBucket } from '@kit.ArkData'
import { Context } from '@kit.AbilityKit'
import { AdditionalLiveInfos } from '../../../../../entry/src/main/ets/models/WeatherModel'

const LIFE_INDEX_TABLE = 'life_index_table'

export class LifeIndexDB {
  private static manager: LifeIndexDB
  private store?: relationalStore.RdbStore

  static sharedManager() {
    if (!LifeIndexDB.manager) {
      LifeIndexDB.manager = new LifeIndexDB()
    }
    return LifeIndexDB.manager
  }

  async createTable(context: Context) {
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: LIFE_INDEX_TABLE,
      securityLevel: relationalStore.SecurityLevel.S1
    }
    const store = await relationalStore.getRdbStore(context, STORE_CONFIG)
    if (store.version === 0) {
      // 创建数据表
      const SQL_CREATE_TABLE = `create table if not exists ${LIFE_INDEX_TABLE} (cityCode text not null primary key, life_index text)`; // 建表Sql语句
      await store.executeSql(SQL_CREATE_TABLE)
      store.version = 1
    }
    LifeIndexDB.sharedManager().store = store
  }

  async insertLifeIndex(lifeIndex: ValuesBucket): Promise<number> {
    const store = LifeIndexDB.sharedManager().store
    if (store) {
      try {
        const oldRowId: number = await this.deleteLifeIndex(lifeIndex['cityCode'] as string)
        const rowId: number = await store.insert(LIFE_INDEX_TABLE, lifeIndex)
        return Promise.resolve(rowId)
      } catch {
        return Promise.resolve(-1)
      }
    }
    return Promise.resolve(-2)
  }

  async deleteLifeIndex(cityCode: string): Promise<number> {
    const store = LifeIndexDB.sharedManager().store
    if (store) {
      try {
        let predicates = new relationalStore.RdbPredicates(LIFE_INDEX_TABLE);
        predicates.equalTo('cityCode', cityCode);
        const rows = await store.delete(predicates)
        return Promise.resolve(rows)
      } catch {
        return Promise.resolve(-1)
      }
    }
    return Promise.resolve(-2)
  }

  async queryLifeIndex(cityCode: string) {
    const store = LifeIndexDB.sharedManager().store
    const predicates = new relationalStore.RdbPredicates(LIFE_INDEX_TABLE);
    predicates.equalTo('cityCode', cityCode);
    let result: AdditionalLiveInfos = {}
    if (store) {
      const resultSet = await store.query(predicates, ['life_index'])
      while (resultSet.goToNextRow()) {
        result = JSON.parse(resultSet.getString(resultSet.getColumnIndex('life_index')));
      }
      // 释放数据集的内存
      resultSet.close();
    }
    return result
  }
}