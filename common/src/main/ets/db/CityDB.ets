import { relationalStore, ValuesBucket } from '@kit.ArkData'
import { Context } from '@kit.AbilityKit'
import { City } from '../../../../../entry/src/main/ets/models/WeatherModel'

const CITY_TABLE = 'city_table'

export class CityDB {
  private static manager: CityDB
  private store?: relationalStore.RdbStore

  static sharedManager() {
    if (!CityDB.manager) {
      CityDB.manager = new CityDB()
    }
    return CityDB.manager
  }

  async createTable(context: Context) {
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: CITY_TABLE,
      securityLevel: relationalStore.SecurityLevel.S1
    }
    const store = await relationalStore.getRdbStore(context, STORE_CONFIG)
    if (store.version === 0) {
      // 创建数据表
      const SQL_CREATE_TABLE = `create table if not exists ${CITY_TABLE} (cityCode text not null, addTime integer, city text)`; // 建表Sql语句
      await store.executeSql(SQL_CREATE_TABLE)
      store.version = 1
    }
    CityDB.sharedManager().store = store
  }

  async insertCity(city: ValuesBucket): Promise<number> {
    const store = CityDB.sharedManager().store
    if (store) {
      try {
        if (city['addTime'] as number === 0) {
          await this.deleteLocationCity()
        } else {
          await this.deleteCity(city['cityCode'] as string)
        }
        const rowId: number = await store.insert(CITY_TABLE, city)
        return Promise.resolve(rowId)
      } catch {
        return Promise.resolve(-1)
      }
    }
    return Promise.resolve(-2)
  }

  // 删除手动添加城市
  async deleteCity(cityCode: string): Promise<number> {
    const store = CityDB.sharedManager().store
    if (store) {
      try {
        let predicates = new relationalStore.RdbPredicates(CITY_TABLE);
        predicates.equalTo('cityCode', cityCode).and().notEqualTo('addTime', 0);
        const rows = await store.delete(predicates)
        return Promise.resolve(rows)
      } catch {
        return Promise.resolve(-1)
      }
    }
    return Promise.resolve(-2)
  }

  // 删除定位城市
  async deleteLocationCity(): Promise<number> {
    const store = CityDB.sharedManager().store
    if (store) {
      try {
        let predicates = new relationalStore.RdbPredicates(CITY_TABLE);
        predicates.equalTo('addTime', 0);
        const rows = await store.delete(predicates)
        return Promise.resolve(rows)
      } catch {
        return Promise.resolve(-1)
      }
    }
    return Promise.resolve(-2)
  }

  async queryCity(cityCode: string) {
    const store = CityDB.sharedManager().store
    let predicates = new relationalStore.RdbPredicates(CITY_TABLE);
    predicates.equalTo('cityCode', cityCode);
    let result: City = {}
    if (store) {
      const resultSet = await store.query(predicates, ['city'])
      while (resultSet.goToNextRow()) {
        result = JSON.parse(resultSet.getString(resultSet.getColumnIndex('city')));
      }
      // 释放数据集的内存
      resultSet.close();
    }
    return result
  }

  async queryLocationCity() {
    const store = CityDB.sharedManager().store
    let predicates = new relationalStore.RdbPredicates(CITY_TABLE);
    predicates.equalTo('addTime', 0);
    let result: City = {}
    if (store) {
      const resultSet = await store.query(predicates, ['city'])
      while (resultSet.goToNextRow()) {
        result = JSON.parse(resultSet.getString(resultSet.getColumnIndex('city')));
      }
      // 释放数据集的内存
      resultSet.close();
    }
    return result
  }

  async queryAllCities() {
    const store = CityDB.sharedManager().store
    const predicates = new relationalStore.RdbPredicates(CITY_TABLE);
    let result: City[] = [];
    if (store) {
      const resultSet = await store.query(predicates, ['city'])
      while (resultSet.goToNextRow()) {
        const a = resultSet.getString(resultSet.getColumnIndex('city'));
        result.push(JSON.parse(a) as City)
      }
      // 释放数据集的内存
      resultSet.close();
    }
    result = result.sort((a,b)=>(a.addTime! - b.addTime!))//按添加时间从小到大
    return result
  }
}