import { AlertDB, AqiDB, CityDB, ConditionDB, DailysDB, DescDB, HoursDB, RadarDB, LifeIndexDB,
  isEmpty,
  getCurrentTimestamp, getCurrentTheme,
  getWeaThemeType, isDayTime } from '../../../../Index'
import { HttpUtils } from '../http/HttpUtils'
import { WeaCommResp, CityWeatherData } from '../../../../../entry/src/main/ets/models/WeatherModel'
import dayjs from 'dayjs'
import isToday from 'dayjs/plugin/isToday'

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
    const theme = await getCurrentTheme()
    if (theme.carousel !== 1) { // 非天气数据背景可以直接请求，不用等到天气数据结果出来再去请求背景
      HttpUtils.getThemeBgImage(theme.theme_id || '', cityCode, '', '', theme.carousel || 3)
    }
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

    const theme = await getCurrentTheme()
    const weaId = getWeaThemeType(data?.condition?.cnwid?.toString() || '').toString()

    const todayWeatherArray = data?.dailys?.dailyweathers?.filter(item => {
      dayjs.extend(isToday)
      return dayjs(item.current).isToday()
    })

    let isDay = '0'
    if (weaId === '1') { // 非晴天1 isDay都传0
      if (todayWeatherArray?.length || 0 > 0) {
        const todayWeatherData = todayWeatherArray![0]
        isDay = isDayTime(todayWeatherData.sr || 0, todayWeatherData.ss || 0)
      }
    }

    if (longitude && latitude) {
      cityCode = city_new?.citycode
      city_new.addTime = 0
      if (isEmpty(cityCode)) {
        return
      }

      if (theme.carousel === 1) {
        HttpUtils.getThemeBgImage(theme.theme_id || '', cityCode!, weaId, isDay, theme.carousel || 3)
      } else {
        HttpUtils.getThemeBgImage(theme.theme_id || '', cityCode!, '', '', theme.carousel || 3)
      }
    } else {
      city_new.addTime = getCurrentTimestamp()

      if (theme.carousel === 1) {
        HttpUtils.getThemeBgImage(theme.theme_id || '', cityCode!, weaId, isDay, theme.carousel || 3)
      }
    }



    if (city_new) {
      await CityDB.sharedManager().insertCity({'cityCode': cityCode!, 'addTime': city_new.addTime, 'city': JSON.stringify(city_new)})
    }

    const condition = data?.condition || {}
    const conditionPromise = ConditionDB.sharedManager().insertCondition({'cityCode': cityCode!, 'condition': JSON.stringify(condition)})

    const hours = data?.hourlys || []
    const hoursPromise = HoursDB.sharedManager().insertHours({'cityCode': cityCode!, 'hours': JSON.stringify(hours)})

    const aqi = data?.aqi || {}
    const aqiPromise = AqiDB.sharedManager().insertAqi({'cityCode': cityCode!, 'aqi': JSON.stringify(aqi)})

    const desc = data?.desc || {}
    const descPromise = DescDB.sharedManager().insertDesc({'cityCode': cityCode!, 'desc': JSON.stringify(desc)})

    const radar = data?.radar || {}
    const radarPromise = RadarDB.sharedManager().insertRadar({'cityCode': cityCode!, 'radar': JSON.stringify(radar)})

    const dailys = data?.dailys || {}
    const dailysPromise = DailysDB.sharedManager().insertDailys({'cityCode': cityCode!, 'dailys': JSON.stringify(dailys)})

    const alert = data?.alert || []
    const alertPromise = AlertDB.sharedManager().insertAlert({'cityCode': cityCode!, 'alert': JSON.stringify(alert)})

    const lifeIndex = data?.additionalLiveInfos || []
    const lifeIndexPromise = LifeIndexDB.sharedManager().insertLifeIndex({'cityCode': cityCode!, 'life_index': JSON.stringify(lifeIndex)})

    await Promise.all([conditionPromise, hoursPromise, aqiPromise, descPromise, radarPromise, dailysPromise, alertPromise, lifeIndexPromise])
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