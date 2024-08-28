export class WeaCommResp {
  resultcode?: string
  resultinfo?: string
  servertime?: number // 服务器时间
  data?: CityWeatherData
}

export class CityWeatherData {
  city_new?: City
  additionalLiveInfos?: AdditionalLiveInfos[]
  condition?: Condition
  alert?: Alert[]
  radar?: Radar
  dailys?: Dailys
  aqi?: ToDayAqi
  hourlys?: Hourlys[]
  desc?: WeaSummary
  dailysCurrentlink?: string
  dailysMobilelink?: string
  hourlsMobilelink?: string
}

export class Radar {
  summary?: string
  dataseries?: Array<number> // 2小时逐分钟降水
  dataTime?: number // 雷达发布时间
  mobilelink?: string
  radarType?: string // 雨雪标记。1：雨；2：雪
}

export class WeaSummary {
  summary?: string
  icontype?: string
  summary2?: string
  mobilelink2?: string
  dailyDesc?: DailyDesc
  conditionDesc?: ConditionDesc
  mobilelink?: string
}

export class ConditionDesc {
  summary?: string  // 一句话 小时天气描述
  mobilelink?: string
}

export class DailyDesc {
  summary?: string  // 一句话 多天天气描述
  mobilelink?: string
}

export class Hourlys {
  date?: number
  pp?: number
  cc?: number
  uv?: number
  vis?: number
  cnwid?: number
  temp?: number
  gs?: number
  dp?: number
  wd?: string
  p?: number
  por?: number
  uvt?: string
  current?: string
  at?: number
  wid?: number
  rh?: number
  wp?: string
  dateFmt?: string
  ws?: number
  Isdaynight?: boolean
  gf?: string
}

export class ToDayAqi {
  no2?: number
  aqivalue?: number
  o3?: number
  pm25?: number
  so2?: number
  pm10?: number
  aqivaluetext?: string
  lv?: number
  co?: number
  aqidesc?: string
  mobilelink?: string
  updatetime?: string
}

export class Dailys {
  dailyweathers?: Dailyweathers[]
  mobilelink?: string
}

export class Dailyweathers {
  ss?: number // 日落
  sr?: number // 日出
  nsf?: number
  ns?: number
  lt?: number  // 最低温度
  source?: string
  ht?: number  // 最高温度
  conditionDay?: ConditionDay
  current?: string // 当前日期 20240506
  mlink?: string
  hat?: number
  lat?: number
  st?: string
  vis?: number
  uv?: number
  mp?: string
  nnf?: number
  p?: number
  uvt?: string
  aqi?: DaysAqi  // 空气质量
  conditionNight?: ConditionNight
  tr?: string
}

export class ConditionNight {
  cc?: number
  cnwid?: number
  pof?: number
  wd?: string
  pop?: number
  por?: number
  wid?: number
  sf?: number
  rf?: number
  pot?: number
  pos?: number
  rh?: number
  ia?: number
  wp?: number
  ws?: number
  tp?: number
  gd?: string
  gf?: number
}

export class DaysAqi {
  name?: string
  categoryValue?: number
  category?: string
  type?: string
  value?: number
}

export class ConditionDay {
  cc?: number
  cnwid?: number
  pof?: number
  wd?: string
  pop?: number
  por?: number
  wid?: number
  sf?: number
  rf?: number
  pot?: number
  pos?: number
  rh?: number
  ia?: number
  wp?: number
  ws?: number
  tp?: number
  gd?: string
  gf?: number
}

export class Condition {
  utime?: number
  cc?: number
  pp?: number
  sft?: number
  uv?: number
  vis?: number//能见度
  cnwid?: number
  pt?: string
  gs?: number
  wd?: string//风向
  p?: number//气压
  uvt?: string
  at?: number//体感温度
  wid?: number
  t?: number
  mlink?: string
  rh?: number//湿度
  clink?: string
  wp?: number//风力
  ws?: number
  gd?: string
  gf?: number
}

export class AdditionalLiveInfos {
  code?: string
  mlink?: Mlink
  levelList?: LevelList[]
  name?: string
}

export class LevelList {
  level?: number
  day?: string
  content?: string
  status?: string
  // 手动添加
  icon?: ResourceStr
  name?: string
  bgColor?: string
  code?: string
}

export class Mlink {
  webURL?: string
}

@Observed
export class City {
  //下面是服务器返回字段
  citycode?: string
  localizedname?: string
  level?: number
  timezone?: string
  co?: string
  administrativearea?: Administrativearea[]
  ca?: string
  bgImg?: string
  // 手动添加字段
  addTime?: number = 0
}

export class Administrativearea{
  englishName?: string
  level?: number
  localizedname?: string
  id?: string
}

export class Alert {
  typeName?: string  // 预警类型名称
  zmRecommend?: string
  publictime?: number // 发布时间
  level?: number   // 等级
  relievedtime?: number // 0 未解除  大于 0 已解除
  isEffect?: string
  levelName?: string // 等级名称
  title?: string   // 预警全称
  type?: string    // 预警类型
  content?: string  // 预警内容
  titleEn?: string
  gradeDesc?: string
  releaseAgency?: string  // 来源
  id?: string
  mobilelink?: string  // H5链接
  guide?: string
}

export class CityManagerWeatherData {
  ss?: number
  cnwid?: number
  lt?: number
  ht?: number
  wd?: string
  wid?: number
  t?: number
  cityName?: string
  citycode?: string
  alert?:[]
  aqit?: string
  isLocation?: number
  aqi?: number
  wp?: number
  sr?: number
}
