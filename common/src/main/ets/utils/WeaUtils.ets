import dayjs from 'dayjs'
import { ConditionDay, ConditionNight } from '../../../../../entry/src/main/ets/models/WeatherModel'
import { getCurrentTimestamp } from '.'
import { WeaIconDayDict, WeaIconNightDict, WeatherTypeMap, WeatherTypeMapShort } from '../constant'

// 通过天气码和主题天气码匹配
export function getWeaThemeType(weaId: string) {
  let result = 1
  if (['0'].indexOf(weaId) != -1) { // 晴
    result = 1
  } else if (['1'].indexOf(weaId) != -1) { // 多云
    result = 8
  } else if (['2'].indexOf(weaId) != -1) { // 阴
    result = 2
  } else if (['3', '4', '5', '7', '8', '9', '10', '11', '12', '19', '21', '22', '23', '24', '25'].indexOf(weaId) != -1) { // 雨
    result = 3
  } else if (['6', '13', '14', '15', '16', '17', '26', '27', '28', '34'].indexOf(weaId) != -1) { // 雪
    result = 4
  } else if (['18', '35'].indexOf(weaId) != -1) { // 雾
    result = 5
  } else if (['20', '29', '30', '31', '32', '33'].indexOf(weaId) != -1) { // 沙尘
    result = 6
  } else if (['53'].indexOf(weaId) != -1) { // 霾
    result = 5
  }
  return result
}

//0:白天夜间图标； 1:白天白天图标； 2:夜间夜间图标
export function getCurrentDayType(sunRise: number, sunSet: number) {
  let result = 0
  if (sunRise === 0) {
    sunRise = dayjs(dayjs().format('YYYY-MM-DD') + ' 06:00').valueOf()
  }
  if (sunSet === 0) {
    sunSet = dayjs(dayjs().format('YYYY-MM-DD') + ' 18:00').valueOf()
  }

  const currentTimestamp = getCurrentTimestamp()
  if (sunRise <= currentTimestamp && sunSet > currentTimestamp) {
    result = 1
  } else if (sunSet <= currentTimestamp) {
    result = 2
  }
  return result
}

// 是否是白天
export function isDayTime(sunRise: number, sunSet: number) {
  const dayType = getCurrentDayType(sunRise, sunSet)
  return dayType === 1 ? '1' : '0'
}

export enum WeatherType {
  Sun, // 晴
  Cloudy, // 多云
  Overcast, // 阴
  Rain, // 雨
  Snow, // 雪
  Alert // 特殊天气 预警
}

export function getWeatherTypeWithWeaId(weaId: string) {
  let result = WeatherType.Sun
  if (['0'].indexOf(weaId) != -1) { // 晴
    result = WeatherType.Sun
  } else if (['1'].indexOf(weaId) != -1) { // 多云
    result = WeatherType.Cloudy
  } else if (['2'].indexOf(weaId) != -1) { // 阴
    result = WeatherType.Overcast
  } else if (['3', '4', '5', '7', '8', '9', '10', '11', '12', '19', '21', '22', '23', '24', '25'].indexOf(weaId) != -1) { // 雨
    result = WeatherType.Rain
  } else if (['6', '13', '14', '15', '16', '17', '26', '27', '28', '34'].indexOf(weaId) != -1) { // 雪
    result = WeatherType.Snow
  } else if (['18', '35'].indexOf(weaId) != -1) { // 雾
    result = WeatherType.Alert
  } else if (['20', '29', '30', '31', '32', '33'].indexOf(weaId) != -1) { // 沙尘
    result = WeatherType.Alert
  } else if (['53'].indexOf(weaId) != -1) { // 霾
    result = WeatherType.Alert
  }
  return result
}

export function getWeatherType(conditionDay: ConditionDay, conditionNight: ConditionNight) {
  const dayWeatherType = getWeatherTypeWithWeaId(conditionDay.cnwid?.toString() || '1')
  const nightWeatherType = getWeatherTypeWithWeaId(conditionNight.cnwid?.toString() || '1')
  if (dayWeatherType === WeatherType.Rain || nightWeatherType === WeatherType.Rain) {
    return WeatherType.Rain
  } else if (dayWeatherType === WeatherType.Snow || nightWeatherType === WeatherType.Snow) {
    return WeatherType.Snow
  }
  return WeatherType.Sun
}

export function getWeatherDetailType(conditionDayWeaId: string, conditionNightWeaId: string, isShort: boolean) {
  const dayDesc = getWeaDescFromWeaId(conditionDayWeaId, isShort)
  const nightDesc = getWeaDescFromWeaId(conditionNightWeaId, isShort)
  if (dayDesc === nightDesc) {
    return dayDesc
  }
  return `${dayDesc}转${nightDesc}`
}

export function getWeaDescFromWeaId(weaId: string, isShort: boolean) {
  const weaCode = parseInt(weaId)
  if (weaCode < 0 || (weaCode > 35 && weaCode != 53)) {
    return ''
  }
  return isShort ? WeatherTypeMapShort[weaId] : WeatherTypeMap[weaId]
}

/**
 * 获取天气图标
 * @param weaId 白天weaId/晚上weaId
 * @param dayType 0:白天夜间图标； 1:白天白天图标； 2:夜间夜间图标
 */
export function getWeaIcon(weaId: string, dayType: number) {
  if (weaId.length) {
    if (dayType === 1) {
      return WeaIconDayDict[weaId]
    } else {
      return WeaIconNightDict[weaId]
    }
  }
  return 'ui_ic_default'
}

