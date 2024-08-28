import { AlertDB, AqiDB, CityDB, ConditionDB, DailysDB, DescDB, HoursDB, RadarDB, LifeIndexDB,
  isEmpty,
  getCurrentTimestamp } from '../../../../Index'
import { HttpUtils } from '../http/HttpUtils'
import { WeaCommResp, CityWeatherData } from '../../../../../entry/src/main/ets/models/WeatherModel'

export class WeatherUtils {
  static async getLocationCityWeather(longitude: string, latitude: string): Promise<CityWeatherData | undefined> {
    const data = await HttpUtils.getLocationCityWeather<WeaCommResp>(longitude, latitude)
    if (data.resultcode === '0') {
      await WeatherUtils.parseWeather(data.data, longitude, latitude)
      return data.data
    }
    return undefined
  }

  static async getCityWeatherWithCityCode(cityCode: string): Promise<CityWeatherData | undefined> {
    const data = await HttpUtils.getCityWeatherWithCityCode<WeaCommResp>(cityCode)
    if (data.resultcode === '0') {
      await WeatherUtils.parseWeather(data.data, undefined, undefined, cityCode)
      return data.data
    }
    return undefined
  }

  private static async parseWeather(data?: CityWeatherData, longitude?: string, latitude?: string, citycode?: string) {
    let cityCode = citycode

    let city_new = data?.city_new
    if (!city_new) {
      return
    }

    if (longitude && latitude) {
      cityCode = city_new?.citycode
      city_new.addTime = 0
    } else {
      city_new.addTime = getCurrentTimestamp()
    }

    if (isEmpty(cityCode)) {
      return
    }

    if (city_new) {
      await CityDB.sharedManager().insertCity({'cityCode': cityCode!, 'addTime': city_new.addTime, 'city': JSON.stringify(city_new)})
    }

    let condition = data?.condition
    if (condition) {
      await ConditionDB.sharedManager().insertCondition({'cityCode': cityCode!, 'condition': JSON.stringify(condition)})
    }

    let hours = data?.hourlys
    if (hours) {
      await HoursDB.sharedManager().insertHours({'cityCode': cityCode!, 'hours': JSON.stringify(hours)})
    }

    let aqi = data?.aqi
    if (aqi) {
      await AqiDB.sharedManager().insertAqi({'cityCode': cityCode!, 'aqi': JSON.stringify(aqi)})
    }

    let desc = data?.desc
    if (desc) {
      await DescDB.sharedManager().insertDesc({'cityCode': cityCode!, 'desc': JSON.stringify(desc)})
    }

    let radar = data?.radar
    if (radar) {
      await RadarDB.sharedManager().insertRadar({'cityCode': cityCode!, 'radar': JSON.stringify(radar)})
    }

    let dailys = data?.dailys
    if (dailys) {
      await DailysDB.sharedManager().insertDailys({'cityCode': cityCode!, 'dailys': JSON.stringify(dailys)})
    }

    let alert = data?.alert
    if (alert) {
      await AlertDB.sharedManager().insertAlert({'cityCode': cityCode!, 'alert': JSON.stringify(alert)})
    }

    let lifeIndex = data?.additionalLiveInfos
    if (lifeIndex) {
      await LifeIndexDB.sharedManager().insertLifeIndex({'cityCode': cityCode!, 'life_index': JSON.stringify(lifeIndex)})
    }

  }

  static async getCondition(cityCode: string) {
    return await ConditionDB.sharedManager().queryCondition(cityCode)
  }

  static async deleteCondition(cityCode: string) {
    await ConditionDB.sharedManager().deleteCondition(cityCode)
  }

  static async getHours(cityCode: string) {
    return await HoursDB.sharedManager().queryHours(cityCode)
  }

  static async deleteHours(cityCode: string) {
    await HoursDB.sharedManager().deleteHours(cityCode)
  }

  static async getAqi(cityCode: string) {
    return await AqiDB.sharedManager().queryAqi(cityCode)
  }

  static async deleteAqi(cityCode: string) {
    await AqiDB.sharedManager().deleteAqi(cityCode)
  }

  static async getDesc(cityCode: string) {
    return await DescDB.sharedManager().queryDesc(cityCode)
  }

  static async deleteDesc(cityCode: string) {
    await DescDB.sharedManager().deleteDesc(cityCode)
  }

  static async getRadar(cityCode: string) {
    return await RadarDB.sharedManager().queryRadar(cityCode)
  }

  static async deleteRadar(cityCode: string) {
    await RadarDB.sharedManager().deleteRadar(cityCode)
  }

  static async getDailys(cityCode: string) {
    return await DailysDB.sharedManager().queryDailys(cityCode)
  }

  static async deleteDailys(cityCode: string) {
    await DailysDB.sharedManager().deleteDailys(cityCode)
  }

  static async getAlert(cityCode: string) {
    return await AlertDB.sharedManager().queryAlert(cityCode)
  }

  static async deleteAlert(cityCode: string) {
    await AlertDB.sharedManager().deleteAlert(cityCode)
  }

  static async getCity(cityCode: string) {
    return await CityDB.sharedManager().queryCity(cityCode)
  }

  static async getAllCitys() {
    return await CityDB.sharedManager().queryAllCitys()
  }

  static async deleteCity(cityCode: string) {
    await CityDB.sharedManager().deleteCity(cityCode)
  }

  static async deleteLocationCity() {
    await CityDB.sharedManager().deleteLocationCity()
  }

  static async getLifeIndex(cityCode: string) {
    return await LifeIndexDB.sharedManager().queryLifeIndex(cityCode)
  }

  static async deleteLifeIndex(cityCode: string) {
    await LifeIndexDB.sharedManager().deleteLifeIndex(cityCode)
  }
}