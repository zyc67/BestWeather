import { relationalStore, ValuesBucket } from '@kit.ArkData'
import { Context } from '@kit.AbilityKit'
import { Condition } from '../../../../../entry/src/main/ets/models/WeatherModel'

const CONDITION_TABLE = 'condition_table'

export class ConditionDB {
  private static manager: ConditionDB
  private store?: relationalStore.RdbStore

  static sharedManager() {
    if (!ConditionDB.manager) {
      ConditionDB.manager = new ConditionDB()
    }
    return ConditionDB.manager
  }

  async createTable(context: Context) {
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: CONDITION_TABLE,
      securityLevel: relationalStore.SecurityLevel.S1
    }
    const store = await relationalStore.getRdbStore(context, STORE_CONFIG)
    if (store.version === 0) {
      // 创建数据表
      const SQL_CREATE_TABLE = `create table if not exists ${CONDITION_TABLE} (
      cityCode text not null primary key, condition text)`; // 建表Sql语句
      await store.executeSql(SQL_CREATE_TABLE)
      store.version = 1
    }
    ConditionDB.sharedManager().store = store
  }

  async insertCondition(condition: ValuesBucket): Promise<number> {
    const store = ConditionDB.sharedManager().store
    if (store) {
      try {
        const oldRowId: number = await this.deleteCondition(condition['cityCode'] as string)
        const rowId: number = await store.insert(CONDITION_TABLE, condition)
        return Promise.resolve(rowId)
      } catch {
        return Promise.resolve(-1)
      }
    }
    return Promise.resolve(-2)
  }

  async deleteCondition(cityCode: string): Promise<number> {
    const store = ConditionDB.sharedManager().store
    if (store) {
      try {
        let predicates = new relationalStore.RdbPredicates(CONDITION_TABLE);
        predicates.equalTo('cityCode', cityCode);
        const rows = await store.delete(predicates)
        return Promise.resolve(rows)
      } catch {
        return Promise.resolve(-1)
      }
    }
    return Promise.resolve(-2)
  }

  async queryCondition(cityCode: string) {
    const store = ConditionDB.sharedManager().store
    const predicates = new relationalStore.RdbPredicates(CONDITION_TABLE);
    predicates.equalTo('cityCode', cityCode);
    let result: Condition = {}
    if (store) {
      const resultSet = await store.query(predicates, ['condition'])
      while (resultSet.goToNextRow()) {
        result = JSON.parse(resultSet.getString(resultSet.getColumnIndex('condition')));
      }
      // 释放数据集的内存
      resultSet.close();
    }
    return result
  }
}