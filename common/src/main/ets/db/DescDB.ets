import { relationalStore, ValuesBucket } from '@kit.ArkData'
import { Context } from '@kit.AbilityKit'
import { WeaSummary } from '../../../../../entry/src/main/ets/models/WeatherModel'

const DESC_TABLE = 'desc_table'

export class DescDB {
  private static manager: DescDB
  private store?: relationalStore.RdbStore

  static sharedManager() {
    if (!DescDB.manager) {
      DescDB.manager = new DescDB()
    }
    return DescDB.manager
  }

  async createTable(context: Context) {
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: DESC_TABLE,
      securityLevel: relationalStore.SecurityLevel.S1
    }
    const store = await relationalStore.getRdbStore(context, STORE_CONFIG)
    if (store.version === 0) {
      // 创建数据表
      const SQL_CREATE_TABLE = `create table if not exists ${DESC_TABLE} (cityCode text not null primary key, desc text)`; // 建表Sql语句
      await store.executeSql(SQL_CREATE_TABLE)
      store.version = 1
    }
    DescDB.sharedManager().store = store
  }

  async insertDesc(desc: ValuesBucket): Promise<number> {
    const store = DescDB.sharedManager().store
    if (store) {
      try {
        const oldRowId: number = await this.deleteDesc(desc['cityCode'] as string)
        const rowId: number = await store.insert(DESC_TABLE, desc)
        return Promise.resolve(rowId)
      } catch {
        return Promise.resolve(-1)
      }
    }
    return Promise.resolve(-2)
  }

  async deleteDesc(cityCode: string): Promise<number> {
    const store = DescDB.sharedManager().store
    if (store) {
      try {
        let predicates = new relationalStore.RdbPredicates(DESC_TABLE);
        predicates.equalTo('cityCode', cityCode);
        const rows = await store.delete(predicates)
        return Promise.resolve(rows)
      } catch {
        return Promise.resolve(-1)
      }
    }
    return Promise.resolve(-2)
  }

  async queryDesc(cityCode: string) {
    const store = DescDB.sharedManager().store
    const predicates = new relationalStore.RdbPredicates(DESC_TABLE);
    predicates.equalTo('cityCode', cityCode);
    let result: WeaSummary = {}
    if (store) {
      const resultSet = await store.query(predicates, ['desc'])
      while (resultSet.goToNextRow()) {
        result = JSON.parse(resultSet.getString(resultSet.getColumnIndex('desc')));
      }
      // 释放数据集的内存
      resultSet.close();
    }
    return result
  }
}