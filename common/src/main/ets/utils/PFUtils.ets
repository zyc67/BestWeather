import { preferences } from '@kit.ArkData'
import { BW_PREFERENCES_NAME } from '../constant/Constant'
import { BusinessError } from '@kit.BasicServicesKit'
import { Context } from '@ohos.abilityAccessCtrl'


export class PFUtils {
  static dataPreferences: preferences.Preferences | null = null
  /**
   * 获取Preferences实例
   */
  static async getPreferences(context: Context) {
    try {
      PFUtils.dataPreferences = await preferences.getPreferences(context, BW_PREFERENCES_NAME)
    } catch (e) {
      console.log((e as BusinessError).message)
    }
  }

  /**
   * 从缓存中移出指定的Preferences实例，若Preferences实例有对应的持久化文件，则同时删除其持久化文件。
   */
  static async deletePreferences(context: Context) {
    if (!PFUtils.dataPreferences) {
      await PFUtils.getPreferences(context)
    }
    try {
      await preferences.deletePreferences(context, BW_PREFERENCES_NAME)
    } catch (e) {
      console.log((e as BusinessError).message)
    }
  }

  /**
   * 从缓存的Preferences实例中获取键对应的值，如果值为null或者非默认值类型，返回默认数据defValue
   * @param key
   * @param defValue
   * @returns
   */
  static async get(key: string, defValue: preferences.ValueType, context: Context) {
    if (!PFUtils.dataPreferences) {
      await PFUtils.getPreferences(context)
    }

    try {
      return await PFUtils.dataPreferences?.get(key, defValue)
    } catch (e) {
      console.log((e as BusinessError).message)
    }
    return defValue
  }

  /**
   * 将数据写入缓存的Preferences实例中，可通过flush将Preferences实例持久化
   * @param key
   * @param defValue
   */
  static async put(key: string, defValue: preferences.ValueType, context: Context) {
    if (!PFUtils.dataPreferences) {
      await PFUtils.getPreferences(context)
    }

    try {
      await PFUtils.dataPreferences?.put(key, defValue)
      await PFUtils.dataPreferences?.flush()
    } catch (e) {
      console.log((e as BusinessError).message)
    }
  }

  /**
   * 从缓存的Preferences实例中删除名为给定Key的存储键值对，可通过flush将Preferences实例持久化
   *
   * @param key
   * @param defValue
   */
  static async delete(key: string, context: Context) {
    if (!PFUtils.dataPreferences) {
      await PFUtils.getPreferences(context)
    }
    try {
      await PFUtils.dataPreferences?.delete(key)
      await PFUtils.dataPreferences?.flush()
    } catch (e) {
      console.log((e as BusinessError).message)
    }
  }
}