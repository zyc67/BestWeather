import { relationalStore, ValuesBucket } from '@kit.ArkData'
import { Context } from '@kit.AbilityKit'
import { Dailys } from '../../../../../entry/src/main/ets/models/WeatherModel'

const DAILYS_TABLE = 'dailys_table'

export class DailysDB {
  private static manager: DailysDB
  private store?: relationalStore.RdbStore

  static sharedManager() {
    if (!DailysDB.manager) {
      DailysDB.manager = new DailysDB()
    }
    return DailysDB.manager
  }

  async createTable(context: Context) {
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: DAILYS_TABLE,
      securityLevel: relationalStore.SecurityLevel.S1
    }
    const store = await relationalStore.getRdbStore(context, STORE_CONFIG)
    if (store.version === 0) {
      // 创建数据表
      const SQL_CREATE_TABLE = `create table if not exists ${DAILYS_TABLE} (cityCode text not null primary key, dailys text)`; // 建表Sql语句
      await store.executeSql(SQL_CREATE_TABLE)
      store.version = 1
    }
    DailysDB.sharedManager().store = store
  }

  async insertDailys(dailys: ValuesBucket): Promise<number> {
    const store = DailysDB.sharedManager().store
    if (store) {
      try {
        const oldRowId: number = await this.deleteDailys(dailys['cityCode'] as string)
        const rowId: number = await store.insert(DAILYS_TABLE, dailys)
        return Promise.resolve(rowId)
      } catch {
        return Promise.resolve(-1)
      }
    }
    return Promise.resolve(-2)
  }

  async deleteDailys(cityCode: string): Promise<number> {
    const store = DailysDB.sharedManager().store
    if (store) {
      try {
        let predicates = new relationalStore.RdbPredicates(DAILYS_TABLE);
        predicates.equalTo('cityCode', cityCode);
        const rows = await store.delete(predicates)
        return Promise.resolve(rows)
      } catch {
        return Promise.resolve(-1)
      }
    }
    return Promise.resolve(-2)
  }

  async queryDailys(cityCode: string) {
    const store = DailysDB.sharedManager().store
    const predicates = new relationalStore.RdbPredicates(DAILYS_TABLE);
    predicates.equalTo('cityCode', cityCode);
    let result: Dailys[] = []
    if (store) {
      const resultSet = await store.query(predicates, ['dailys'])
      while (resultSet.goToNextRow()) {
        result = JSON.parse(resultSet.getString(resultSet.getColumnIndex('dailys')));
      }
      // 释放数据集的内存
      resultSet.close();
    }
    return result
  }
}