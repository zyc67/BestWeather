import { getWeatherType, WeatherType, getCurrentDay, getWeaIcon } from '@bw/common'
import { NinetyModel, NinetyWeaTrend, NinetyWeaTrendModel, NinetyWeaTrendChartModel, WeaTrendType } from '../models/NinetyDaysResp'
import dayjs from 'dayjs'
import { Solar } from 'lunar'

export class NinetyUtils {
  static getWeaTrendData(ninetyData: NinetyModel[]) {
    let highTemps: number[] = [] // 所有高温
    let lowTemps: number[] = [] // 所有低温
    let highTempMax: number = Number.MIN_VALUE // 高温最大值
    let lowTempMin: number = Number.MAX_VALUE // 低温最小值

    let preHighTemp = 0 // 前一天高温
    let preLowTemp = 0 // 前一天低温
    let hotIndexes: number[] = [] // 高温
    let coldIndexes: number[] = []// 低温
    let tempUpIndexes: number[] = [] // 升温
    let tempDownIndexes: number[] = []// 降温
    let rainIndexes: number[] = [] // 降雨
    let snowIndexes: number[] = []// 降雪

    const validNinetyData:NinetyModel[] = []
    const calendarData: NinetyModel[] = []
    for (let index = 0; index < ninetyData.length; index++) {
      const model = ninetyData[index]
      // 今天 + 之后 的天气数据
      if (model.ptime >= getCurrentDay()) {
        validNinetyData.push(model)
      }
      if (index === 0) {
        preHighTemp = model.ht
        preLowTemp = model.lt
        continue
      }
      let nextHighTemp = model.ht // 后一天高温
      let nextLowTemp = model.lt // 后一天低温

      highTemps.push(nextHighTemp)
      lowTemps.push(nextLowTemp)

      if (nextHighTemp > highTempMax) {
        highTempMax = nextHighTemp
      }
      if (nextLowTemp < lowTempMin) {
        lowTempMin = nextLowTemp
      }

      // 高、低温
      if (nextHighTemp >= 35) {
        hotIndexes.push(index)
      } else if (nextHighTemp <= 5) {
        coldIndexes.push(index)
      }

      const maxOffset = nextHighTemp - preHighTemp
      const minOffset = nextLowTemp - preLowTemp
      // 升、降温
      if (maxOffset >= 5) {//高温升温
        tempUpIndexes.push(index)
        if (minOffset <= -5) {//低温降温
          tempDownIndexes.push(index)
        }
      } else if (maxOffset <= -5) {//高温降温
        tempDownIndexes.push(index)
        if (minOffset >= 5) {//低温升温
          tempUpIndexes.push(index)
        }
      } else if (minOffset >= 5) {//低温升温
        tempUpIndexes.push(index)
      } else if (maxOffset <= -5) {//低温降温
        tempDownIndexes.push(index)
      }

      preHighTemp = nextHighTemp
      preLowTemp = nextLowTemp

      // 降雨、降雪
      const weaType = getWeatherType(model.conditionDay, model.conditionNight)
      if (weaType == WeatherType.Rain) {
        rainIndexes.push(index)
      } else if (weaType == WeatherType.Snow) {
        snowIndexes.push(index)
      }

      calendarData.push(NinetyUtils.handleCalendarData(model))
    }

    const ninetyWeaTrend: NinetyWeaTrend = new NinetyWeaTrend()
    ninetyWeaTrend.weaTrendModel = NinetyUtils.handleChartData(ninetyData, hotIndexes, coldIndexes, tempUpIndexes, tempDownIndexes, rainIndexes, snowIndexes)
    ninetyWeaTrend.weaTrendChartModel = NinetyUtils.handleTrendData(highTemps, lowTemps, highTempMax, lowTempMin)
    ninetyWeaTrend.ninetyData = validNinetyData
    ninetyWeaTrend.calendarData = calendarData
    return ninetyWeaTrend
  }

  // 趋势汇总
  private static handleTrendData(highTemps: number[], lowTemps: number[], highTempMax: number, lowTempMin: number) {
    const weaTrendChartModel: NinetyWeaTrendChartModel = new NinetyWeaTrendChartModel()
    weaTrendChartModel.highTemps = highTemps
    weaTrendChartModel.lowTemps = lowTemps
    weaTrendChartModel.highTempMax = highTempMax
    weaTrendChartModel.lowTempMin = lowTempMin
    return weaTrendChartModel
  }

  // 趋势图
  private static handleChartData(
    ninetyData: NinetyModel[],
    hotIndexes: number[],
    coldIndexes: number[],
    tempUpIndexes: number[],
    tempDownIndexes: number[],
    rainIndexes: number[],
    snowIndexes: number[]) {
    const ninetyWeaTrendModel: NinetyWeaTrendModel[] = []

    // 高温
    const hot: NinetyWeaTrendModel = new NinetyWeaTrendModel()
    hot.trendType = WeaTrendType.Hot
    hot.days = hotIndexes.length
    hot.icon = $r('app.media.icon_ninety_temperature_hot')
    hot.title = `${hot.days}天高温`
    if (hotIndexes.length > 0) {
      hot.firstDate = ninetyData[hotIndexes[0]].ptime
      hot.indexes = hotIndexes.join(',')
      hot.firstDateString = dayjs(hot.firstDate).format('MM月DD日')
    }
    ninetyWeaTrendModel.push(hot)

    // 低温
    const cold: NinetyWeaTrendModel = new NinetyWeaTrendModel()
    cold.trendType = WeaTrendType.Cold
    cold.days = coldIndexes.length
    cold.icon = $r('app.media.icon_ninety_temperature_cold')
    cold.title = `${cold.days}天低温`
    if (coldIndexes.length > 0) {
      cold.firstDate = ninetyData[coldIndexes[0]].ptime
      cold.indexes = coldIndexes.join(',')
      cold.firstDateString = dayjs(cold.firstDate).format('MM月DD日')
    }
    ninetyWeaTrendModel.push(cold)

    // 降雨
    const rain: NinetyWeaTrendModel = new NinetyWeaTrendModel()
    rain.trendType = WeaTrendType.Rain
    rain.days = rainIndexes.length
    rain.icon = $r('app.media.icon_ninety_temperature_rain')
    rain.title = `${rain.days}天降雨`
    if (rainIndexes.length > 0) {
      rain.firstDate = ninetyData[rainIndexes[0]].ptime
      rain.indexes = rainIndexes.join(',')
      rain.firstDateString = dayjs(rain.firstDate).format('MM月DD日')
    }
    ninetyWeaTrendModel.push(rain)

    // 升温
    const heatUp: NinetyWeaTrendModel = new NinetyWeaTrendModel()
    heatUp.trendType = WeaTrendType.HeatUp
    heatUp.days = tempUpIndexes.length
    heatUp.icon = $r('app.media.icon_ninety_temperature_ascend')
    heatUp.title = `${heatUp.days}天升温`
    if (tempUpIndexes.length > 0) {
      heatUp.firstDate = ninetyData[tempUpIndexes[0]].ptime
      heatUp.indexes = tempUpIndexes.join(',')
      heatUp.firstDateString = dayjs(heatUp.firstDate).format('MM月DD日')
    }
    ninetyWeaTrendModel.push(heatUp)

    // 降温
    const heatLow: NinetyWeaTrendModel = new NinetyWeaTrendModel()
    heatLow.trendType = WeaTrendType.HeatLow
    heatLow.days = tempDownIndexes.length
    heatLow.icon = $r('app.media.icon_ninety_temperature_descend')
    heatLow.title = `${heatLow.days}天降温`
    if (tempDownIndexes.length > 0) {
      heatLow.firstDate = ninetyData[tempDownIndexes[0]].ptime
      heatLow.indexes = tempDownIndexes.join(',')
      heatLow.firstDateString = dayjs(heatLow.firstDate).format('MM月DD日')
    }
    ninetyWeaTrendModel.push(heatLow)

    // 降雪
    const snow: NinetyWeaTrendModel = new NinetyWeaTrendModel()
    snow.trendType = WeaTrendType.Snow
    snow.days = snowIndexes.length
    snow.icon = $r('app.media.icon_ninety_temperature_snow')
    snow.title = `${snow.days}天降雪`
    if (snowIndexes.length > 0) {
      snow.firstDate = ninetyData[snowIndexes[0]].ptime
      snow.indexes = snowIndexes.join(',')
      snow.firstDateString = dayjs(snow.firstDate).format('MM月DD日')
    }
    ninetyWeaTrendModel.push(snow)

    return ninetyWeaTrendModel
  }

  // 日历
  private static handleCalendarData(model: NinetyModel) {
    const solar = Solar.fromDate(new Date(model.ptime))
    const lunar = solar.getLunar()

    model.yymm = `${solar.getYear()}${solar.getMonth()}`
    model.daySolar = solar.getDay()
    model.dayLunar = lunar.getDayInChinese()
    if (model.dayLunar === '初一') {
      model.dayLunar = lunar.getMonthInChinese() + '月'
    }
    model.jieQi = lunar.getJieQi()
    const solarFestivals = solar.getFestivals()
    const lunarFestivals = lunar.getFestivals()
    model.festival = model.festival ?? (solarFestivals.length ? solarFestivals[0] : (lunarFestivals.length ? lunarFestivals[0] : ''))
    model.week = solar.getWeek()
    model.weaIcon = getWeaIcon(model.conditionDay.cnwid ? model.conditionDay.cnwid.toString() : '', 1)
    return model
  }

  static addInvalidCalendarData(calendarData: NinetyModel[]): NinetyModel[][] {
    if (!calendarData || calendarData.length === 0) {
      return []
    }
    const data: NinetyModel[][] = []
    const first: NinetyModel = calendarData[0]
    const firstDaysInMonth = dayjs(first.ptime).daysInMonth()
    // 增加当月当前日期之前的日期
    if (first.daySolar > 1) {
      for (let i = first.daySolar - 1; i > 0; i--) {
        calendarData.unshift(NinetyUtils.getCalendarModel(first.ptime - (first.daySolar - i) * 24 * 3600 * 1000))
      }
    }
    const firstDay = calendarData[0]
    const solar = Solar.fromDate(new Date(firstDay.ptime))
    const week = solar.getWeek()
    for (let i = week - 1; i >= 0; i--) {
      calendarData.unshift(NinetyUtils.getEmptyCalendarModel())
    }
    // 增加当月超过90天之后的日期
    const last: NinetyModel = calendarData[calendarData.length - 1]
    const lastDaysInMonth = dayjs(last.ptime).daysInMonth()
    if (lastDaysInMonth > last.daySolar) {
      for (let i = 1; i <= lastDaysInMonth - last.daySolar; i++) {
        calendarData.push(NinetyUtils.getCalendarModel(last.ptime + i * 24 * 3600 * 1000))
      }
    }
    data.push(calendarData.splice(0, week + firstDaysInMonth))
    while (calendarData.length) {
      const days: NinetyModel[] = []
      const firstDay = calendarData[0]
      const solar = Solar.fromDate(new Date(firstDay.ptime))
      const week = solar.getWeek()
      for (let i = week - 1; i >= 0; i--) {
        days.unshift(NinetyUtils.getEmptyCalendarModel())
      }
      const daysInMonth = dayjs(calendarData[0].ptime).daysInMonth()
      data.push(days.concat(calendarData.splice(0, daysInMonth)))
    }
    return data
  }

  private static getCalendarModel(ptime: number): NinetyModel {
    const model: NinetyModel = new NinetyModel()
    model.ptime = ptime
    const data = NinetyUtils.handleCalendarData(model)
    model.weaIcon = ''
    return data
  }

  private static getEmptyCalendarModel(): NinetyModel {
    const model: NinetyModel = new NinetyModel()
    model.ptime = 0
    return model
  }
}