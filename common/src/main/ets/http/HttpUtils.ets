import { HttpManager } from './HttpManager'
import { EnvType, environment, baseUrl, baseUrlTest, baseWeatherPath, cityManagerWeatherPath, baseSearchCityUrl, searchCityPath,
  baseHotCityUrl,
  hotCityPath,
  baseUrl_SH,
  themeListPath,
  themeBgImagePath} from './HttpConstant'
import { isEmpty } from '../utils'
import { THEME_BG_UPDATE } from '../constant'
import { CommonResp } from '../../../../../entry/src/main/ets/models/ThemeListModel'
import { util } from '@kit.ArkTS'
import pako from 'pako'
import { ThemeListDB } from '../db/ThemeListDB'
import { SCREEN_HEIGHT, SCREEN_WIDTH } from '../constant'
import { emitter } from '@kit.BasicServicesKit'

export class HttpUtils {
  /**
   * 主接口 - 定位城市
   * @param longitude 经度
   * @param latitude 纬度
   * @returns
   */
  static getLocationCityWeather<T>(longitude: string, latitude: string): Promise<T> {
    return HttpUtils.getCityWeather<T>(longitude, latitude, '')
  }

  /**
   * 主接口 - 非定位城市
   * @param cityCode 城市码
   * @returns
   */
  static getCityWeatherWithCityCode<T>(cityCode: string): Promise<T> {
    return HttpUtils.getCityWeather<T>('', '', cityCode)
  }

  private static getCityWeather<T>(longitude: string, latitude: string, cityCode: string): Promise<T> {
    let params: Record<string, Object> = {}
    if (!isEmpty(longitude) && !isEmpty(latitude)) {
      params['lon'] = longitude
      params['lat'] = latitude
    } else if (!isEmpty(cityCode)) {
      params['citycode'] = cityCode
    }
    params['cityType'] = 1 // 定位颗粒度 1：行政区；2：AOI。默认为1
    params['codeType'] = 0 // 编码类型 0表示最美编码；1表示Accu；2表示adcode（民政部编码）

    const host = environment === EnvType.Release ? baseUrl : baseUrlTest
    return HttpManager.getUrl<T>(host, baseWeatherPath, params, 0, 1)
  }

  /**
   * 城市管理
   * @param cityCodes 其他城市码，多个城市码以逗号分割
   * @returns
   */
  static getCityManagerWeathersWithCityCodes<T>(cityCodes: string): Promise<T> {
    let params: Record<string, Object> = {}

    // const longitude = AppStorage.get(Keys.LONGITUDE) ?? ''
    // const latitude = AppStorage.get(Keys.LATITUDE) ?? ''
    // params['lon'] = longitude
    // params['lat'] = latitude
    if (!isEmpty(cityCodes)) {
      params['otherCityCodes'] = cityCodes
    }
    params['cityType'] = 1 // 定位颗粒度 1：行政区；2：AOI。默认为1
    params['codeType'] = 0 // 编码类型 0表示最美编码；1表示Accu；2表示adcode（民政部编码）

    const host = environment === EnvType.Release ? baseUrl : baseUrlTest
    return HttpManager.getUrl<T>(host, cityManagerWeatherPath, params, 0, 1)
  }

  /**
   * 城市搜索
   * @param name
   * @returns
   */
  static searchCity<T>(name: string): Promise<T> {
    let params: Record<string, Object> = {}
    params['q'] = name
    params['web'] = 1

    return HttpManager.getUrl<T>(baseSearchCityUrl, searchCityPath, params, 0, 0)
  }

  static getCalendar<T>() {
    // let params: Record<string, Object> = {}
    // params['apikey'] = HttpConstant.apiKeyCalendar
    // params['timestamp'] = DateToolUtils.getCurTimestampS()
    // return HttpManager.getUrl<T>(HttpConstant.baseCalendarUrl, HttpConstant.calendarPath, params, 0, 0)
  }

  /**
   * 热门城市
   * @param name
   * @returns
   */
  static hotCity<T>(): Promise<T> {
    let params: Record<string, Object> = {}
    params['procCode'] = '3501'
    return HttpManager.postUrl<T>(baseHotCityUrl + hotCityPath, params, 1, 1)
  }

  static async getThemeList(): Promise<CommonResp> {
    const result = await HttpManager.getUrl<CommonResp>(baseUrl_SH, themeListPath, {}, 2, 0)
    const base64Helper = new util.Base64Helper()
    const decodeData = base64Helper.decodeSync(result.data)
    const jsonStr = pako.inflate(decodeData, { to: 'string' }) as string
    console.log('接口返回' + jsonStr)
    result.data = jsonStr
    ThemeListDB.sharedManager().insertThemeList({ 'theme_list': jsonStr })
    return result
  }

  static async getThemeBgImage(themeId: string, cityCode: string, weaId: string, isDay: string, themeType: number): Promise<CommonResp> {
    let params: Record<string, Object> = {
      'theme_id': themeId,
      'width': Number(AppStorage.get<string>(SCREEN_WIDTH)) || 0,
      'height': Number(AppStorage.get<string>(SCREEN_HEIGHT)) || 0,
    }
    if (themeType === 1) {
      params['weather_code'] = weaId
      params['is_day'] = isDay
    } else {
      params['city_code'] = cityCode
    }
    const result = await HttpManager.postUrl<CommonResp>(baseUrl_SH + themeBgImagePath, params, 2, 0)
    const event: emitter.InnerEvent = {
      eventId: THEME_BG_UPDATE,
      priority: emitter.EventPriority.LOW
    }
    const eventData: emitter.EventData = {
      data: {
        cityCode,
        url: result.data
      }
    }
    emitter.emit(event, eventData)
    return result
  }
}