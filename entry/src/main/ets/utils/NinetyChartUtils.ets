import { getWeatherDetailType, getWeatherType, WeatherType } from '@bw/common'
import dayjs from 'dayjs'
import { NinetyModel, NinetyWeaTrendChartModel } from '../models/NinetyDaysResp'
import { LeftMargin, LowTempBottom, HighTempBottom, LineBottom, WeaIconWidth, LineLeft,
  DateBottom,
  WeaIconBottom,
  WeaIconHeight,
  TempHeight,
  lineHeight} from './NinetyConstant'

export class NinetyChartUtils {
  static drawChartView(context: CanvasRenderingContext2D, ninetyData: NinetyModel[], weaTrendChartModel: NinetyWeaTrendChartModel) {
    if (weaTrendChartModel === undefined || ninetyData === undefined || ninetyData.length === 0) {
      return
    }
    // 绘制左边最高温和最低温
    NinetyChartUtils.drawHighLowTemp(context, weaTrendChartModel)
    // 画水平线
    NinetyChartUtils.drawLineView(context, ninetyData.length)
    // 绘制日期和天气
    const highLowTempHeight = HighTempBottom - LowTempBottom
    let highPrePointY: number = 0
    let lowPrePointY: number = 0
    const perHeight: number = highLowTempHeight / (weaTrendChartModel.highTempMax - weaTrendChartModel.lowTempMin)

    const highGradient = context.createLinearGradient(0, 0, 0, context.height)
    highGradient.addColorStop(0, 'rgba(255, 255, 255, 0.20)')
    highGradient.addColorStop(0.5, 'rgba(255, 255, 255, 0.06)')
    highGradient.addColorStop(1, 'rgba(255, 255, 255, 0.00)')

    const lowGradient = context.createLinearGradient(0, 0, 0, context.height)
    lowGradient.addColorStop(0, 'rgba(255, 255, 255, 0.30)')
    lowGradient.addColorStop(0.5, 'rgba(255, 255, 255, 0.08)')
    lowGradient.addColorStop(1, 'rgba(255, 255, 255, 0.00)')

    for (let index = 0; index < ninetyData.length; index++) {
      const model = ninetyData[index]

      // 画刻度和日期
      NinetyChartUtils.drawBottom(context, model, index)

      // 画天气图标
      NinetyChartUtils.drawWeaIcon(context, model, index)

      const height = context.height

      context.lineWidth = 1
      context.strokeStyle = '#FFFFFF'

      const highTempY = height - LowTempBottom - TempHeight / 2 - (model.ht - weaTrendChartModel.lowTempMin) * perHeight
      const lowTempY = height - LowTempBottom - TempHeight / 2 - (model.lt - weaTrendChartModel.lowTempMin) * perHeight

      if (index !== 0) {
        context.fillStyle = "#FFFFFF"
        const highPath: Path2D = new Path2D()
        const lowPath: Path2D = new Path2D()
        highPath.moveTo(LineLeft + WeaIconWidth * (index - 1), highPrePointY)
        lowPath.moveTo(LineLeft + WeaIconWidth * (index - 1), lowPrePointY)
        // 高温曲线
        const cp1xHigh: number = (LineLeft + WeaIconWidth * (index - 1) + LineLeft + WeaIconWidth * index) / 2
        const cp1yHigh: number = highPrePointY
        const cp2xHigh: number = cp1xHigh
        const cp2yHigh: number = highTempY
        highPath.bezierCurveTo(cp1xHigh, cp1yHigh, cp2xHigh, cp2yHigh, LineLeft + WeaIconWidth * index, highTempY)
        context.stroke(highPath)

        // 低温曲线
        const cp1xLow: number = cp1xHigh
        const cp1yLow: number = lowPrePointY
        const cp2xLow: number = cp1xLow
        const cp2yLow: number = lowTempY
        lowPath.bezierCurveTo(cp1xLow, cp1yLow, cp2xLow, cp2yLow, LineLeft + WeaIconWidth * index, lowTempY)
        context.stroke(lowPath)

        // 高温渐变
        context.fillStyle = highGradient
        const highMaskPath: Path2D = new Path2D()
        highMaskPath.moveTo(LineLeft + WeaIconWidth * (index - 1), height - WeaIconBottom)
        highMaskPath.lineTo(LineLeft + WeaIconWidth * (index - 1), highPrePointY)
        highMaskPath.bezierCurveTo(cp1xHigh, cp1yHigh, cp2xHigh, cp2yHigh, LineLeft + WeaIconWidth * index, highTempY)
        highMaskPath.lineTo(LineLeft + WeaIconWidth * index, height - WeaIconBottom)
        highMaskPath.closePath()
        context.fill(highMaskPath)

        // 低温渐变
        context.fillStyle = lowGradient
        const lowMaskPath: Path2D = new Path2D()
        lowMaskPath.moveTo(LineLeft + WeaIconWidth * (index - 1), height - WeaIconBottom)
        lowMaskPath.lineTo(LineLeft + WeaIconWidth * (index - 1), lowPrePointY)
        lowMaskPath.bezierCurveTo(cp1xLow, cp1yLow, cp2xLow, cp2yLow, LineLeft + WeaIconWidth * index, lowTempY)
        lowMaskPath.lineTo(LineLeft + WeaIconWidth * index, height - WeaIconBottom)
        lowMaskPath.closePath()
        context.fill(lowMaskPath)
      }

      highPrePointY = highTempY
      lowPrePointY = lowTempY
    }
  }

  // 绘制左边最高温和最低温
  private static drawHighLowTemp(context: CanvasRenderingContext2D, weaTrendChartModel: NinetyWeaTrendChartModel) {
    if (weaTrendChartModel) {
      const height = context.height
      context.font = 'normal bold 16vp'
      context.textAlign = 'right'
      context.fillStyle = '#FFFFFF'
      context.fillText(weaTrendChartModel.highTempMax.toString() + '°',  LeftMargin, height - HighTempBottom)
      context.fillText(weaTrendChartModel.lowTempMin.toString() + '°',  LeftMargin, height - LowTempBottom)
    }
  }

  // 画水平线
  private static drawLineView(context: CanvasRenderingContext2D, count: number) {
    const height = context.height
    const path: Path2D = new Path2D()
    context.strokeStyle = '#FFFFFF'
    context.lineWidth = 1
    path.moveTo(LineLeft, height - LineBottom)
    path.lineTo(LineLeft + WeaIconWidth * (count - 1), height - LineBottom)
    context.stroke(path)
  }

  // 画刻度和日期
  private static drawBottom(context: CanvasRenderingContext2D, model: NinetyModel, index: number) {
    const height = context.height
    const path: Path2D = new Path2D()
    let lineHeight = 0
    if (index % 5 === 0) {
      // 画大刻度
      context.lineWidth = 1
      context.strokeStyle = '#CCFFFFFF'
      lineHeight = 4
      // 画日期
      NinetyChartUtils.drawDate(context, model, index)
    } else {
      // 画小刻度
      context.lineWidth = 0.5
      context.strokeStyle = '#33FFFFFF'
      lineHeight = 2
    }
    path.moveTo(LineLeft + WeaIconWidth * index, height - LineBottom)
    path.lineTo(LineLeft + WeaIconWidth * index, height - LineBottom - lineHeight)
    context.stroke(path)
  }

  // 画日期
  private static drawDate(context: CanvasRenderingContext2D, model: NinetyModel, index: number) {
    const height = context.height
    const date = dayjs(model.ptime).format('MM/DD')
    // const contentWidth = context.measureText(date)
    context.font = 'normal 13vp'
    context.textAlign = 'center'
    context.fillStyle = '#FFFFFF'
    context.fillText(date, LineLeft + WeaIconWidth * index, height - DateBottom)
  }

  // 画天气图标
  private static drawWeaIcon(context: CanvasRenderingContext2D, model: NinetyModel, index: number) {
    const height = context.height
    let icon: ImageBitmap = new ImageBitmap('/images/icon_normal_weather.png')
    const weaType = getWeatherType(model.conditionDay, model.conditionNight)
    if (weaType == WeatherType.Rain || weaType == WeatherType.Snow) {
      icon = new ImageBitmap('/images/icon_rain_weather.png')
    }
    context.drawImage(icon, LineLeft + WeaIconWidth * index - WeaIconWidth / 2, height - WeaIconBottom - WeaIconHeight, WeaIconWidth, WeaIconHeight)
  }

  // 绘制移动线
  static drawMoveLine(context: CanvasRenderingContext2D, model: NinetyModel, index: number, weaTrendChartModel: NinetyWeaTrendChartModel) {
    if (weaTrendChartModel === undefined) {
      return
    }
    context.clearRect(0, 0, context.width, context.height)

    // 线
    const lineGradient = context.createLinearGradient(0, 0, 0, context.height)
    lineGradient.addColorStop(0, 'rgba(255, 255, 255, 1.0)')
    lineGradient.addColorStop(0.5, 'rgba(255, 255, 255, 0.06)')
    lineGradient.addColorStop(1, 'rgba(255, 255, 255, 0.00)')

    const height = context.height
    context.fillStyle = lineGradient
    const lineMaskPath: Path2D = new Path2D()
    lineMaskPath.moveTo(LineLeft + WeaIconWidth * index - 1, height - lineHeight - LineBottom)
    lineMaskPath.lineTo(LineLeft + WeaIconWidth * index + 1, height - lineHeight - LineBottom)
    lineMaskPath.lineTo(LineLeft + WeaIconWidth * index + 1, height - LineBottom)
    lineMaskPath.lineTo(LineLeft + WeaIconWidth * index - 1, height - LineBottom)
    lineMaskPath.closePath()
    context.fill(lineMaskPath)

    context.fillStyle = '#FFFFFF'
    const highLowTempHeight = HighTempBottom - LowTempBottom
    const perHeight: number = highLowTempHeight / (weaTrendChartModel.highTempMax - weaTrendChartModel.lowTempMin)
    // 高温点
    const highPath: Path2D = new Path2D()
    const radius = 4
    const highTempY = height - LowTempBottom - TempHeight / 2 - (model.ht - weaTrendChartModel.lowTempMin) * perHeight
    highPath.arc(LineLeft + WeaIconWidth * index, highTempY, radius, 0, 2 * Math.PI)
    context.fill(highPath)

    // 低温点
    const lowPath: Path2D = new Path2D()
    const lowTempY = height - LowTempBottom - TempHeight / 2 - (model.lt - weaTrendChartModel.lowTempMin) * perHeight
    lowPath.arc(LineLeft + WeaIconWidth * index, lowTempY, radius, 0, 2 * Math.PI)
    context.fill(lowPath)

    // 先设置文字大小，因为要计算文字宽高 measureText
    context.font = 'normal 13vp'
    const topString: string = `${dayjs(model.ptime).format('MM/DD')} ${model.ht}~${model.lt}°`
    const bottomString: string = getWeatherDetailType((model.conditionDay.cnwid ?? '').toString(), (model.conditionNight.cnwid ?? '').toString(), true)
    const weather = `${topString}\n${bottomString}`
    const size = context.measureText(weather)
    const marginVertical = 4
    const w = size.width
    const h = size.height + marginVertical
    const heightOffsetY = 4

    if (index < weaTrendChartModel.highTemps.length / 2) { // 左半边
      // 框
      context.fillStyle = '#33FFFFFF'
      const weaPath: Path2D = new Path2D()
      weaPath.moveTo(LineLeft + WeaIconWidth * index + 1, height - lineHeight - LineBottom - h / 2 + heightOffsetY)
      weaPath.arc(LineLeft + WeaIconWidth * index + 1 + h / 2, height - lineHeight - LineBottom - h / 2 + heightOffsetY, h / 2, Math.PI, 1.5 * Math.PI)
      weaPath.lineTo(LineLeft + WeaIconWidth * index + 1 + h / 2 + w, height - lineHeight - LineBottom - h + heightOffsetY)
      weaPath.arc(LineLeft + WeaIconWidth * index + 1 + h / 2 + w , height - lineHeight - LineBottom - h / 2 + heightOffsetY, h / 2, 1.5 * Math.PI, 0.5 * Math.PI)
      weaPath.lineTo(LineLeft + WeaIconWidth * index + 1, height - lineHeight - LineBottom + heightOffsetY)
      weaPath.closePath()
      context.fill(weaPath)

      // 文字
      context.fillStyle = '#FFFFFF'
      // height - lineHeight - LineBottom - h / 2 如果不换行是不需要减去h / 2，fillText这里是左下角x,y坐标
      context.fillText(weather,  LineLeft + WeaIconWidth * index + 1 + h / 2, height - lineHeight - LineBottom - h / 2)
    } else { // 右半边
      // 框
      context.fillStyle = '#33FFFFFF'
      const weaPath: Path2D = new Path2D()
      weaPath.moveTo(LineLeft + WeaIconWidth * index - 1, height - lineHeight - LineBottom - h / 2 + heightOffsetY)
      weaPath.arc(LineLeft + WeaIconWidth * index - 1 - h / 2, height - lineHeight - LineBottom - h / 2 + heightOffsetY, h / 2, 2 * Math.PI, 1.5 * Math.PI, true)
      weaPath.lineTo(LineLeft + WeaIconWidth * index - 1 - h / 2 - w, height - lineHeight - LineBottom - h + heightOffsetY)
      weaPath.arc(LineLeft + WeaIconWidth * index - 1 - h / 2 - w , height - lineHeight - LineBottom - h / 2 + heightOffsetY, h / 2, 1.5 * Math.PI, 0.5 * Math.PI, true)
      weaPath.lineTo(LineLeft + WeaIconWidth * index - 1, height - lineHeight - LineBottom + heightOffsetY)
      weaPath.closePath()
      context.fill(weaPath)

      // 文字
      context.fillStyle = '#FFFFFF'
      // height - lineHeight - LineBottom - h / 2 如果不换行是不需要减去h / 2，fillText这里是左下角x,y坐标
      context.fillText(weather,  LineLeft + WeaIconWidth * index - 1 - h / 2 - w, height - lineHeight - LineBottom - h / 2)
    }
  }
}