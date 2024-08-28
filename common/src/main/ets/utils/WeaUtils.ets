import dayjs from 'dayjs'
import { getCurrentTimestamp } from '.'

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