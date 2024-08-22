import { City } from './WeatherModel'

export class HotCityResp {
  resultCode?: number
  resultInfo?: string
  serverTime?: number // 服务器时间
  data?: HotCityModel
}

export class HotCityModel {
  hotScenic?: City[]
  areaHotCity?: AreaHotCityModel[]
  hotGolf?: City[]
}

export class AreaHotCityModel {
  area?: string
  cityList?: City[]
}