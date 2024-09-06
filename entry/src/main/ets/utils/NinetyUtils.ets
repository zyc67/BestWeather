import { getWeatherType, WeatherType } from '@bw/common'
import { NinetyModel, NinetyWeaTrend, NinetyWeaTrendModel, NinetyWeaTrendChartModel, WeaTrendType } from '../models/NinetyDaysResp'
import dayjs from 'dayjs'

export class NinetyUtils {
  static getWeaTrendData(ninetyData: NinetyModel[]) {
    let highTemps: number[] = [] // 所有高温
    let lowTemps: number[] = [] // 所有低温
    let highTempMax: number = Number.MIN_VALUE // 高温最大值
    let lowTempMin: number = Number.MAX_VALUE // 低温最小值
    const weaTrendChartModel: NinetyWeaTrendChartModel = new NinetyWeaTrendChartModel()

    let preHighTemp = 0 // 前一天高温
    let preLowTemp = 0 // 前一天低温
    let hotIndexes: number[] = [] // 高温
    let coldIndexes: number[] = []// 低温
    let tempUpIndexes: number[] = [] // 升温
    let tempDownIndexes: number[] = []// 降温
    let rainIndexes: number[] = [] // 降雨
    let snowIndexes: number[] = []// 降雪

    for (let index = 0; index < ninetyData.length; index++) {
      const model = ninetyData[index]
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


      weaTrendChartModel.highTemps = highTemps
      weaTrendChartModel.lowTemps = lowTemps
      weaTrendChartModel.highTempMax = highTempMax
      weaTrendChartModel.lowTempMin = lowTempMin


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
    }

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

    const ninetyWeaTrend: NinetyWeaTrend = new NinetyWeaTrend()
    ninetyWeaTrend.weaTrendModel = ninetyWeaTrendModel
    ninetyWeaTrend.weaTrendChartModel = weaTrendChartModel

    return ninetyWeaTrend
  }
}