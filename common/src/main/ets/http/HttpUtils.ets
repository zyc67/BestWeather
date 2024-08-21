import { HttpManager } from './HttpManager'
import { EnvType, environment, baseUrl, baseUrlTest, baseWeatherPath, cityManagerWeatherPath, baseSearchCityUrl, searchCityPath,
  baseHotCityUrl,
  hotCityPath} from './HttpConstant'
import { isEmpty } from '../utils'

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
}