import { relationalStore, ValuesBucket } from '@kit.ArkData'
import { Context } from '@kit.AbilityKit'
import { ToDayAqi } from '../../../../../entry/src/main/ets/models/WeatherModel'

const AQI_TABLE = 'aqi_table'

export class AqiDB {
  private static manager: AqiDB
  private store?: relationalStore.RdbStore

  static sharedManager() {
    if (!AqiDB.manager) {
      AqiDB.manager = new AqiDB()
    }
    return AqiDB.manager
  }

  async createTable(context: Context) {
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: AQI_TABLE,
      securityLevel: relationalStore.SecurityLevel.S1
    }
    const store = await relationalStore.getRdbStore(context, STORE_CONFIG)
    if (store.version === 0) {
      // 创建数据表
      const SQL_CREATE_TABLE = `create table if not exists ${AQI_TABLE} (cityCode text not null primary key, aqi text)`; // 建表Sql语句
      await store.executeSql(SQL_CREATE_TABLE)
      store.version = 1
    }
    AqiDB.sharedManager().store = store
  }

  async insertAqi(aqi: ValuesBucket): Promise<number> {
    const store = AqiDB.sharedManager().store
    if (store) {
      try {
        const oldRowId: number = await this.deleteAqi(aqi['cityCode'] as string)
        const rowId: number = await store.insert(AQI_TABLE, aqi)
        return Promise.resolve(rowId)
      } catch {
        return Promise.resolve(-1)
      }
    }
    return Promise.resolve(-2)
  }

  async deleteAqi(cityCode: string): Promise<number> {
    const store = AqiDB.sharedManager().store
    if (store) {
      try {
        let predicates = new relationalStore.RdbPredicates(AQI_TABLE);
        predicates.equalTo('cityCode', cityCode);
        const rows = await store.delete(predicates)
        return Promise.resolve(rows)
      } catch {
        return Promise.resolve(-1)
      }
    }
    return Promise.resolve(-2)
  }

  async queryAqi(cityCode: string) {
    const store = AqiDB.sharedManager().store
    const predicates = new relationalStore.RdbPredicates(AQI_TABLE);
    predicates.equalTo('cityCode', cityCode);
    let result: ToDayAqi = {}
    if (store) {
      const resultSet = await store.query(predicates, ['aqi'])
      while (resultSet.goToNextRow()) {
        result = JSON.parse(resultSet.getString(resultSet.getColumnIndex('aqi')));
      }
      // 释放数据集的内存
      resultSet.close();
    }
    return result
  }
}