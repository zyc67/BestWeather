export class WeatherInfoResp {
  resultcode?: string
  resultinfo?: string
  servertime?: number // 服务器时间
  flagTime?: string
  infoFlowList?: WeatherInfoModel[]
}

export class WeatherInfoModel {
  id: number = 0
  headImg: string = ''
  publishTime: string = ''
  source: string = ''
  title: string = ''
}