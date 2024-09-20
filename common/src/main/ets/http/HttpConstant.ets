export enum EnvType {
  Debug = 1,
  Release = 2
}

// 环境：正式Release、测试Debug
export const environment: number = EnvType.Release

export const channelId: string = '20001'

// 西安气象新接口
// 正式环境
export const baseUrl: string = 'https://open.zuimeitianqi.com/'
export const baseUrl_SH: string = 'https://bs.zuimeitianqi.com/'
// 测试环境
export const baseUrlTest: string = 'https://uat.zuimeitianqi.com/'

export const apiKey: string = '60228eb91292739f0e4e41d1dfb84cfc'
export const apiKeyXiAn: string = 'c137be706bb863996a67fa06483d43b6'
export const apiKeyCalendar: string = '8a15039792a84d46ab659fff34c6e8d0'
export const language: string = 'zh-cn'

// 西安老接口
// 城市搜索
export const baseSearchCityUrl: string = 'https://zmapp.zuimeitianqi.com/'

// 热门城市列表
export const baseHotCityUrl: string = 'https://hot.zuimeitianqi.com/'

// 万年历
export const baseCalendarUrl: string = 'https://zmcalender-api.colaapp.cn/'

export const baseDBUrl: string = 'https://zmdb.zuimeitianqi.com/zmDbServer/'
export const baseDBPath: string = '4.0/'

// path
// 天气主接口
export const baseWeatherPath: string = 'openWeatherDataService/v1/weather'
// 90天
export const ninetyDaysPath: string = 'openWeatherDataService/getNinetyDailys'
// 城市管理
export const cityManagerWeatherPath: string = 'openWeatherDataService/getCityManageData'
// 城市搜索
export const searchCityPath: string = 'zmAppDataServer/city/aoi'
// 万年历
export const calendarPath: string = 'calendar/daily'
// 热门城市列表
export const hotCityPath: string = 'zmHotServer/3.0/'
// 主题列表
export const themeListPath: string = 'theme/list/gzip/'
// 主题图片
export const themeBgImagePath: string = 'theme/bg'

