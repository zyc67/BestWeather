import { WeatherUtils, PFUtils, HttpUtils, getCurrentTheme, getWeaThemeType, receiveEmitter, isDayTime, ThemeBgDB, LONGITUDE,
  LATITUDE, CHANGE_THEME_EVENT_ID,
  BaseCell,
  TOP_NAVI_HEIGHT} from '@bw/common'
import {
  AdditionalLiveInfos,
  Alert, City, Condition, Dailys, Hourlys, Radar, ToDayAqi, WeaSummary } from '../../models/WeatherModel'
import dayjs from 'dayjs'
import isToday from 'dayjs/plugin/isToday'
import { WeatherInfoView } from '../WeatherInfoView'

@Component
export struct WeaView {
  private topRectHeight = px2vp(AppStorage.get<number>(TOP_NAVI_HEIGHT) || 0)
  city: City = {}
  @State themeBgImage: ResourceStr = $r('app.media.theme_bg_default')

  @State condition: Condition = {}
  @State hours: Hourlys[] = []
  @State aqi: ToDayAqi = {}
  @State desc: WeaSummary = {}
  @State radar: Radar = {}
  @State daily: Dailys = {}
  @State alert: Alert[] = []
  @State lifeIndex: AdditionalLiveInfos = {}

  aboutToAppear(): void {
    this.registerThemeBgEmitter()
    this.getWeatherData()
    this.requestWeatherData(true)
    this.getThemeBg()
  }

  registerThemeBgEmitter() {
    receiveEmitter(CHANGE_THEME_EVENT_ID, () => {
      this.getThemeBg()
    })
  }

  getWeatherData() {
    if (this.city.citycode) {
      WeatherUtils.getCondition(this.city.citycode).then((condition) => {
        this.condition = condition
      })
      WeatherUtils.getHours(this.city.citycode).then((hours) => {
        this.hours = hours
      })
      WeatherUtils.getAqi(this.city.citycode).then((aqi) => {
        this.aqi = aqi
      })
      WeatherUtils.getDesc(this.city.citycode).then((desc) => {
        this.desc = desc
      })
      WeatherUtils.getRadar(this.city.citycode).then((radar) => {
        this.radar = radar
      })
      WeatherUtils.getDailys(this.city.citycode).then((daily) => {
        this.daily = daily
      })
      WeatherUtils.getAlert(this.city.citycode).then((alert) => {
        this.alert = alert
      })
      WeatherUtils.getLifeIndex(this.city.citycode).then((lifeIndex) => {
        this.lifeIndex = lifeIndex
      })
    }
  }

  async requestWeatherData(autoRefresh: boolean) {
    if (this.city.addTime === 0) {
      const longitude = await PFUtils.get(LONGITUDE, '', getContext(this)) as string
      const latitude = await PFUtils.get(LATITUDE, '', getContext(this)) as string
      await WeatherUtils.getLocationCityWeather(longitude ?? this.city.co, latitude ?? this.city.ca, autoRefresh)
    } else {
      await WeatherUtils.getCityWeatherWithCityCode(this.city.citycode || '', autoRefresh)
    }
  }

  async getThemeBg() {
    const cityCode = this.city.citycode
    const theme = await getCurrentTheme()

    const weaId = getWeaThemeType((this.condition.cnwid || '').toString()).toString()

    const todayWeatherArray = (this.daily.dailyweathers || []).filter(item => {
      dayjs.extend(isToday)
      return dayjs(item.current).isToday()
    })

    let isDay = '0'
    if (weaId === '1') { // 非晴天1 isDay都传0
      if (todayWeatherArray?.length || 0 > 0) {
        const todayWeatherData = todayWeatherArray![0]
        isDay = isDayTime(todayWeatherData.sr || 0, todayWeatherData.ss || 0)
      }
    }

    let url = ''
    if (theme.carousel === 1) {
      url = await ThemeBgDB.sharedManager().queryThemeBg('', theme.theme_id || '', weaId, isDay)
      if (!url) {
        const result = await HttpUtils.getThemeBgImage(theme.theme_id || '', '', weaId, isDay, theme.carousel)
        url = result.data
      }
    } else {
      url = await ThemeBgDB.sharedManager().queryThemeBg(cityCode || '', theme.theme_id || '', '', '')
      const result = await HttpUtils.getThemeBgImage(theme.theme_id || '', cityCode || '', '', '', theme.carousel || 3)
      url = result.data
    }
    this.themeBgImage = url || $r('app.media.theme_bg_default')
    console.log('get 11111111111_' + url)
  }

  build() {
    Stack() {
      Image(this.themeBgImage)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
      Column() {
        List({space: 12}) {
          ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9], (item: number) => {
            ListItem() {
              if (item === 9) {
                BaseCell({bgColor: '#FFFFFF'}) {
                  WeatherInfoView()
                }
              } else {
                BaseCell() {
                  Column() {
                    Text(item.toString())
                  }
                  .height(100)
                }
              }
            }
          })
        }
        .scrollBar(BarState.Off)
        // .nestedScroll({
        //   scrollForward: NestedScrollMode.SELF_FIRST,
        //   scrollBackward: NestedScrollMode.PARENT_FIRST
        // })
      }
      .width('100%')
      .padding({
        left: 8,
        right: 8
      })
      .margin({
        top: 60 + this.topRectHeight
      })
    }
    .width('100%')
    .height('100%')
  }
}