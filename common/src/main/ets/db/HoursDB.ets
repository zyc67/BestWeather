import { relationalStore, ValuesBucket } from '@kit.ArkData'
import { Context } from '@kit.AbilityKit'
import { Hourlys } from '../../../../../entry/src/main/ets/models/WeatherModel'

const HOURS_TABLE = 'hours_table'

export class HoursDB {
  private static manager: HoursDB
  private store?: relationalStore.RdbStore

  static sharedManager() {
    if (!HoursDB.manager) {
      HoursDB.manager = new HoursDB()
    }
    return HoursDB.manager
  }

  async createTable(context: Context) {
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: HOURS_TABLE,
      securityLevel: relationalStore.SecurityLevel.S1
    }
    const store = await relationalStore.getRdbStore(context, STORE_CONFIG)
    if (store.version === 0) {
      // 创建数据表
      const SQL_CREATE_TABLE = `create table if not exists ${HOURS_TABLE} (cityCode text not null primary key, hours text)`; // 建表Sql语句
      await store.executeSql(SQL_CREATE_TABLE)
      store.version = 1
    }
    HoursDB.sharedManager().store = store
  }

  async insertHours(hours: ValuesBucket): Promise<number> {
    const store = HoursDB.sharedManager().store
    if (store) {
      try {
        const oldRowId: number = await this.deleteHours(hours['cityCode'] as string)
        const rowId: number = await store.insert(HOURS_TABLE, hours)
        return Promise.resolve(rowId)
      } catch {
        return Promise.resolve(-1)
      }
    }
    return Promise.resolve(-2)
  }

  async deleteHours(cityCode: string): Promise<number> {
    const store = HoursDB.sharedManager().store
    if (store) {
      try {
        let predicates = new relationalStore.RdbPredicates(HOURS_TABLE);
        predicates.equalTo('cityCode', cityCode);
        const rows = await store.delete(predicates)
        return Promise.resolve(rows)
      } catch {
        return Promise.resolve(-1)
      }
    }
    return Promise.resolve(-2)
  }

  async queryHours(cityCode: string) {
    const store = HoursDB.sharedManager().store
    const predicates = new relationalStore.RdbPredicates(HOURS_TABLE);
    predicates.equalTo('cityCode', cityCode);
    let result: Hourlys = {}
    if (store) {
      const resultSet = await store.query(predicates, ['hours'])
      while (resultSet.goToNextRow()) {
        result = JSON.parse(resultSet.getString(resultSet.getColumnIndex('hours')));
      }
      // 释放数据集的内存
      resultSet.close();
    }
    return result
  }
}