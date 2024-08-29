import { relationalStore, ValuesBucket } from '@kit.ArkData'
import { Context } from '@kit.AbilityKit'
import { Alert } from '../../../../../entry/src/main/ets/models/WeatherModel'

const ALERT_TABLE = 'alert_table'

export class AlertDB {
  private static manager: AlertDB
  private store?: relationalStore.RdbStore

  static sharedManager() {
    if (!AlertDB.manager) {
      AlertDB.manager = new AlertDB()
    }
    return AlertDB.manager
  }

  async createTable(context: Context) {
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: ALERT_TABLE,
      securityLevel: relationalStore.SecurityLevel.S1
    }
    const store = await relationalStore.getRdbStore(context, STORE_CONFIG)
    if (store.version === 0) {
      // 创建数据表
      const SQL_CREATE_TABLE = `create table if not exists ${ALERT_TABLE} (cityCode text not null primary key, alert text)`; // 建表Sql语句
      await store.executeSql(SQL_CREATE_TABLE)
      store.version = 1
    }
    AlertDB.sharedManager().store = store
  }

  async insertAlert(alert: ValuesBucket): Promise<number> {
    const store = AlertDB.sharedManager().store
    if (store) {
      try {
        const oldRowId: number = await this.deleteAlert(alert['cityCode'] as string)
        const rowId: number = await store.insert(ALERT_TABLE, alert)
        return Promise.resolve(rowId)
      } catch {
        return Promise.resolve(-1)
      }
    }
    return Promise.resolve(-2)
  }

  async deleteAlert(cityCode: string): Promise<number> {
    const store = AlertDB.sharedManager().store
    if (store) {
      try {
        let predicates = new relationalStore.RdbPredicates(ALERT_TABLE);
        predicates.equalTo('cityCode', cityCode);
        const rows = await store.delete(predicates)
        return Promise.resolve(rows)
      } catch {
        return Promise.resolve(-1)
      }
    }
    return Promise.resolve(-2)
  }

  async queryAlert(cityCode: string) {
    const store = AlertDB.sharedManager().store
    const predicates = new relationalStore.RdbPredicates(ALERT_TABLE);
    predicates.equalTo('cityCode', cityCode);
    let result: Alert[] = []
    if (store) {
      const resultSet = await store.query(predicates, ['alert'])
      while (resultSet.goToNextRow()) {
        result = JSON.parse(resultSet.getString(resultSet.getColumnIndex('alert')));
      }
      // 释放数据集的内存
      resultSet.close();
    }
    return result
  }
}