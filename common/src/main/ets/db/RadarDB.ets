import { relationalStore, ValuesBucket } from '@kit.ArkData'
import { Context } from '@kit.AbilityKit'
import { Radar } from '../../../../../entry/src/main/ets/models/WeatherModel'

const RADAR_TABLE = 'radar_table'

export class RadarDB {
  private static manager: RadarDB
  private store?: relationalStore.RdbStore

  static sharedManager() {
    if (!RadarDB.manager) {
      RadarDB.manager = new RadarDB()
    }
    return RadarDB.manager
  }

  async createTable(context: Context) {
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: RADAR_TABLE,
      securityLevel: relationalStore.SecurityLevel.S1
    }
    const store = await relationalStore.getRdbStore(context, STORE_CONFIG)
    if (store.version === 0) {
      // 创建数据表
      const SQL_CREATE_TABLE = `create table if not exists ${RADAR_TABLE} (cityCode text not null primary key, radar text)`; // 建表Sql语句
      await store.executeSql(SQL_CREATE_TABLE)
      store.version = 1
    }
    RadarDB.sharedManager().store = store
  }

  async insertRadar(radar: ValuesBucket): Promise<number> {
    const store = RadarDB.sharedManager().store
    if (store) {
      try {
        const oldRowId: number = await this.deleteRadar(radar['cityCode'] as string)
        const rowId: number = await store.insert(RADAR_TABLE, radar)
        return Promise.resolve(rowId)
      } catch {
        return Promise.resolve(-1)
      }
    }
    return Promise.resolve(-2)
  }

  async deleteRadar(cityCode: string): Promise<number> {
    const store = RadarDB.sharedManager().store
    if (store) {
      try {
        let predicates = new relationalStore.RdbPredicates(RADAR_TABLE);
        predicates.equalTo('cityCode', cityCode);
        const rows = await store.delete(predicates)
        return Promise.resolve(rows)
      } catch {
        return Promise.resolve(-1)
      }
    }
    return Promise.resolve(-2)
  }

  async queryRadar(cityCode: string) {
    const store = RadarDB.sharedManager().store
    const predicates = new relationalStore.RdbPredicates(RADAR_TABLE);
    predicates.equalTo('cityCode', cityCode);
    let result: Radar = {}
    if (store) {
      const resultSet = await store.query(predicates, ['radar'])
      while (resultSet.goToNextRow()) {
        result = JSON.parse(resultSet.getString(resultSet.getColumnIndex('radar')));
      }
      // 释放数据集的内存
      resultSet.close();
    }
    return result
  }
}