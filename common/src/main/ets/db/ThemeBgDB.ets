import { relationalStore, ValuesBucket } from '@kit.ArkData'
import { Context } from '@kit.AbilityKit'

const THEME_BG_TABLE = 'theme_bg_table'

export class ThemeBgDB {
  private static manager: ThemeBgDB
  private store?: relationalStore.RdbStore

  static sharedManager() {
    if (!ThemeBgDB.manager) {
      ThemeBgDB.manager = new ThemeBgDB()
    }
    return ThemeBgDB.manager
  }

  async createTable(context: Context) {
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: THEME_BG_TABLE,
      securityLevel: relationalStore.SecurityLevel.S1
    }
    const store = await relationalStore.getRdbStore(context, STORE_CONFIG)
    if (store.version === 0) {
      // 创建数据表
      const SQL_CREATE_TABLE = `create table if not exists ${THEME_BG_TABLE} (cityCode text, themeId text, weaId text, isDay text, url text, primary key(cityCode, themeId, weaId, isDay))`; // 建表Sql语句
      await store.executeSql(SQL_CREATE_TABLE)
      store.version = 1
    }
    ThemeBgDB.sharedManager().store = store
  }

  async insertThemeBg(cityCode: string, themeId: string, weaId: string, isDay: string, url: string): Promise<number> {
    const store = ThemeBgDB.sharedManager().store
    if (store) {
      try {
        const oldRowId: number = await this.deleteThemeBg(cityCode, themeId, weaId, isDay)
        const rowId: number = await store.insert(THEME_BG_TABLE, { url })
        return Promise.resolve(rowId)
      } catch {
        return Promise.resolve(-1)
      }
    }
    return Promise.resolve(-2)
  }

  async deleteThemeBg(cityCode: string, themeId: string, weaId: string, isDay: string): Promise<number> {
    const store = ThemeBgDB.sharedManager().store
    if (store) {
      try {
        let predicates = new relationalStore.RdbPredicates(THEME_BG_TABLE);
        predicates.equalTo('cityCode', cityCode).and().equalTo('themeId', themeId).and().equalTo('weaId', weaId).and().equalTo('isDay', isDay);
        const rows = await store.delete(predicates)
        return Promise.resolve(rows)
      } catch {
        return Promise.resolve(-1)
      }
    }
    return Promise.resolve(-2)
  }

  async queryThemeBg(cityCode: string, themeId: string, weaId: string, isDay: string) {
    const store = ThemeBgDB.sharedManager().store
    const predicates = new relationalStore.RdbPredicates(THEME_BG_TABLE);
    predicates.equalTo('cityCode', cityCode).and().equalTo('themeId', themeId).and().equalTo('weaId', weaId).and().equalTo('isDay', isDay);
    let result: string = ''
    if (store) {
      const resultSet = await store.query(predicates, ['url'])
      while (resultSet.goToNextRow()) {
        result = resultSet.getString(resultSet.getColumnIndex('url'));
      }
      // 释放数据集的内存
      resultSet.close();
    }
    return result
  }
}