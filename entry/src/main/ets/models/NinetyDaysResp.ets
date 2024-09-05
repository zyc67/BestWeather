import { ConditionDay, ConditionNight } from './WeatherModel'

export class NinetyDaysResp {
  resultcode: string = ''
  resultinfo: string = ''
  servertime: number = 0
  data: NinetyDailys = {} as NinetyDailys
}

export class NinetyDailys {
  dailys: NinetyDailysInfo = {} as NinetyDailysInfo
}

export class NinetyDailysInfo {
  expiretime: number = 0
  publictime: number = 0
  mobilelink: string = ''
  dailyweathers: NinetyModel[] = []
}

export class NinetyModel {
  ptime: number = 0
  p: number = 0
  source: string = ''
  ns: number = 0
  ht: number = 0
  rest: string = ''
  nnf: number = 0
  pm25: number = 0
  nsf: number = 0
  avt: string = ''
  mp: string = ''
  aqivalue: number = 0
  vis: number = 0
  lt: number = 0
  hat: string = ''
  uvt: string = ''
  mr: number = 0
  sr: number = 0
  timeStr: string = ''
  lv: number = 0
  lat: string = ''
  ss: number = 0
  uv: number = 0
  ms: number = 0
  festival: string = ''
  conditionDay: ConditionDay = {} as ConditionDay
  conditionNight: ConditionNight = {} as ConditionNight
}

// export class NinetyWeaTrend {
//   heatLow: NinetyWeaTrendModel = {} as NinetyWeaTrendModel // 降温
//   heatUp: NinetyWeaTrendModel = {} as NinetyWeaTrendModel // 升温
//   hot: NinetyWeaTrendModel = {} as NinetyWeaTrendModel // 炎热
//   cold: NinetyWeaTrendModel = {} as NinetyWeaTrendModel // 寒冷
//   snow: NinetyWeaTrendModel = {} as NinetyWeaTrendModel // 降雪
//   rain: NinetyWeaTrendModel = {} as NinetyWeaTrendModel // 降雨
// }

export enum WeaTrendType {
  Default,
  HeatLow, // 降温
  HeatUp, // 升温
  Hot, // 炎热
  Cold, // 寒冷
  Snow, // 降雪
  Rain // 降雨
}

export class NinetyWeaTrendModel {
  days: number = 0
  firstDate: number = 0
  indexes: string = ''
  trendType: WeaTrendType = WeaTrendType.Default
  icon: ResourceStr = ''
  title: string = ''
  firstDateString: string = '--'
}