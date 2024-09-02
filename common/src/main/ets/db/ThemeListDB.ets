import { relationalStore, ValuesBucket } from '@kit.ArkData'
import { Context } from '@kit.AbilityKit'
import { ThemeModel } from '../../../../../entry/src/main/ets/models/ThemeModel'

const THEME_LIST_TABLE = 'theme_list_table'

export class ThemeListDB {
  private static manager: ThemeListDB
  private store?: relationalStore.RdbStore

  static sharedManager() {
    if (!ThemeListDB.manager) {
      ThemeListDB.manager = new ThemeListDB()
    }
    return ThemeListDB.manager
  }

  async createTable(context: Context) {
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: THEME_LIST_TABLE,
      securityLevel: relationalStore.SecurityLevel.S1
    }
    const store = await relationalStore.getRdbStore(context, STORE_CONFIG)
    if (store.version === 0) {
      // 创建数据表
      const SQL_CREATE_TABLE = `create table if not exists ${THEME_LIST_TABLE} (theme_list text)`; // 建表Sql语句
      await store.executeSql(SQL_CREATE_TABLE)
      store.version = 1
    }
    ThemeListDB.sharedManager().store = store
  }

  async insertThemeList(themeList: ValuesBucket): Promise<number> {
    const store = ThemeListDB.sharedManager().store
    if (store) {
      try {
        const oldRowId: number = await this.deleteThemeList()
        const rowId: number = await store.insert(THEME_LIST_TABLE, themeList)
        return Promise.resolve(rowId)
      } catch {
        return Promise.resolve(-1)
      }
    }
    return Promise.resolve(-2)
  }

  async deleteThemeList(): Promise<number> {
    const store = ThemeListDB.sharedManager().store
    if (store) {
      try {
        let predicates = new relationalStore.RdbPredicates(THEME_LIST_TABLE);
        const rows = await store.delete(predicates)
        return Promise.resolve(rows)
      } catch {
        return Promise.resolve(-1)
      }
    }
    return Promise.resolve(-2)
  }

  async queryThemeList() {
    const store = ThemeListDB.sharedManager().store
    const predicates = new relationalStore.RdbPredicates(THEME_LIST_TABLE);
    let result: ThemeModel[] = []
    if (store) {
      const resultSet = await store.query(predicates, ['theme_list'])
      while (resultSet.goToNextRow()) {
        result = JSON.parse(resultSet.getString(resultSet.getColumnIndex('theme_list')));
      }
      // 释放数据集的内存
      resultSet.close();
    }
    return result
  }
}