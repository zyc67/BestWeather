import { WeatherUtils } from '@bw/common/src/main/ets/utils'
import {
  AdditionalLiveInfos,
  Alert, City, Condition, Dailys, Hourlys, Radar, ToDayAqi, WeaSummary } from '../../models/WeatherModel'
import { emitter } from '@kit.BasicServicesKit'
import { THEME_BG_UPDATE } from '@bw/common/src/main/ets/constant/Constant'

@Component
export struct WeaView {
  city: City = {}
  @State themeBgImage: Resource | string = $r('app.media.theme_bg_default')

  @State condition: Condition = {}
  @State hours: Hourlys[] = []
  @State aqi: ToDayAqi = {}
  @State desc: WeaSummary = {}
  @State radar: Radar = {}
  @State daily: Dailys[] = []
  @State alert: Alert[] = []
  @State lifeIndex: AdditionalLiveInfos = {}

  aboutToAppear(): void {
    this.registerThemeBgEmitter()
    this.getWeatherData()
    this.requestWeatherData()
  }

  registerThemeBgEmitter() {
    const event: emitter.InnerEvent = {
      eventId: THEME_BG_UPDATE,
      priority: emitter.EventPriority.LOW
    }

    emitter.on(event, (eventData: emitter.EventData) => {
      const cityCode = eventData.data!['cityCode'] as string
      if (cityCode === this.city.citycode) {
        this.themeBgImage = eventData.data!['url']
      }
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

  requestWeatherData() {
    if (this.city.addTime === 0) {
      WeatherUtils.getLocationCityWeather(this.city.co || '', this.city.ca || '')
    } else {
      WeatherUtils.getCityWeatherWithCityCode(this.city.citycode || '')
    }
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