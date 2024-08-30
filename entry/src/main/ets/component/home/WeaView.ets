import { WeatherUtils, getCurrentTheme, getWeaThemeType, isDayTime, ThemeBgDB } from '@bw/common'
import {
  AdditionalLiveInfos,
  Alert, City, Condition, Dailys, Hourlys, Radar, ToDayAqi, WeaSummary } from '../../models/WeatherModel'
import { emitter } from '@kit.BasicServicesKit'
import dayjs from 'dayjs'
import isToday from 'dayjs/plugin/isToday'

// import { THEME_BG_UPDATE } from '@bw/common/src/main/ets/constant/Constant'

@Component
export struct WeaView {
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
    console.log('1111111111111_' + this.city.localizedname)
    // this.registerThemeBgEmitter()
    this.getWeatherData()
    this.requestWeatherData(true)
  }

  // registerThemeBgEmitter() {
  //   const event: emitter.InnerEvent = {
  //     eventId: THEME_BG_UPDATE,
  //     priority: emitter.EventPriority.LOW
  //   }
  //
  //   emitter.on(event, (eventData: emitter.EventData) => {
  //     const cityCode = eventData.data!['cityCode'] as string
  //     if (cityCode === this.city.citycode) {
  //       this.themeBgImage = eventData.data!['url']
  //     }
  //   })
  // }

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

      this.getThemeBg()
    }
  }

  async requestWeatherData(autoRefresh: boolean) {
    if (this.city.addTime === 0) {
      await WeatherUtils.getLocationCityWeather(this.city.co || '', this.city.ca || '', autoRefresh)
    } else {
      await WeatherUtils.getCityWeatherWithCityCode(this.city.citycode || '', autoRefresh)
    }

    this.getThemeBg()
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
      url = await ThemeBgDB.sharedManager().queryThemeBg(cityCode || '', theme.theme_id || '', weaId, isDay)
      console.log(`get 11111111111_cityCode=${cityCode}_themeId=${theme.theme_id}_weaId=${weaId}_isDay=${isDay}_url=${url}`);
    } else {
      url = await ThemeBgDB.sharedManager().queryThemeBg(cityCode || '', theme.theme_id || '', '', '')
      console.log(`get 11111111111_cityCode=${cityCode}_themeId=${theme.theme_id}_weaId=''_isDay=''_url=${url}`);
    }
    this.themeBgImage = url || $r('app.media.theme_bg_default')
  }

  build() {
    Stack() {
      Image(this.themeBgImage)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
      Row() {
        Text(this.city.localizedname)
      }
    }
    .width('100%')
    .height('100%')
  }
}