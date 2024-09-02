import { BaseNaviBar, BOTTOM_AVOID_AREA_HEIGHT, HttpUtils, TOP_NAVI_HEIGHT, startLocation,
  toLocationSetting, toApplicationInfo, WeatherUtils,
  RouterUtils, Params,
  PFUtils,
  LONGITUDE,
  LATITUDE, postEmitter, ADD_CITY_EVENT_ID} from '@bw/common';
import { CitySearchView } from '../../component/CitySearchView';
import { RecommendView } from '../../component/RecommendView';
import { HotCityModel, HotCityResp } from '../../models/HotCityModel';
import { City, CityWeatherData } from '../../models/WeatherModel';
import { AMapLocation } from '@amap/amap_lbs_location';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct CityAddPage {
  firstLaunch: boolean = false
  @State hotCityModel: HotCityModel = {}
  private topRectHeight = px2vp(AppStorage.get<number>(TOP_NAVI_HEIGHT) || 0)
  private bottomRectHeight = px2vp(AppStorage.get<number>(BOTTOM_AVOID_AREA_HEIGHT) || 0)

  async aboutToAppear() {
    const res = await HttpUtils.hotCity<HotCityResp>()
    if (res.data) {
      this.hotCityModel = res.data
    }
  }

  // 自动定位
  async startLocation() {
    const locationCity = await WeatherUtils.getLocationCity()
    startLocation(getContext(this), (code: number, address: AMapLocation | undefined) => {
      // code 0成功获取定位信息 -1没有打开手机定位 -2请求权限失败 -3获取定位异常
      if (code === 0) {
        if (address && address.longitude > 0 && address.latitude > 0) {
          const longitude = address.longitude.toString()
          const latitude = address.latitude.toString()
          PFUtils.put(LONGITUDE, longitude, getContext(this))
          PFUtils.put(LATITUDE, latitude, getContext(this))
          WeatherUtils.getLocationCityWeather(longitude, latitude, false)
            .then(() => {
              WeatherUtils.getLocationCity().then((res) => {
                this.addCitySuccess(res, locationCity.citycode === undefined)
              })
            })
        }
      } else if (code === -1) {
        const context = getContext(this) as common.UIAbilityContext
        toLocationSetting(context)
      } else if (code === -2) {
        const context = getContext(this) as common.UIAbilityContext
        toApplicationInfo(context)
      }
    })
  }

  // 手动添加城市
  async addCity(city: City) {
    if (city && city.citycode) {
      await WeatherUtils.getCityWeatherWithCityCode(city.citycode, false)
      const cityModel = await WeatherUtils.getCity(city.citycode)
      this.addCitySuccess(cityModel, true)
    }
  }

  async addCitySuccess(city: City, add: boolean) {
    if (add) {
      postEmitter(ADD_CITY_EVENT_ID, { data: city })
    }
    const params: Params = RouterUtils.getParams()
    if (params.firstLaunch) {
      RouterUtils.replaceUrl('pages/splash/SelectThemePage')
    } else {
      RouterUtils.back('pages/main/MainPage')
    }
  }

  build() {
    Stack({alignContent: Alignment.Top}) {
      Row()
        .width('100%')
        .height(this.topRectHeight + 80)
        .linearGradient({
          direction: GradientDirection.Bottom,
          colors: [['#1F90FF', 0.0], ['#FFFFFF', 1.0]]
        })
      BaseNaviBar({title: '添加城市', canBack: !RouterUtils.getParams().firstLaunch})

      Column() {
        CitySearchView()
          .margin({
            left: 16,
            right: 16
          })
        RecommendView({hotCityModel: this.hotCityModel, autoLocationAction: () => {
          // 自动定位
          this.startLocation()
        }, userAddCityAction: (city: City) => {
          // 手动添加城市
          this.addCity(city)
        }})
          .layoutWeight(1)
      }
      .margin({
        top: 60 + this.topRectHeight
      })
    }
    .padding({
      bottom: this.bottomRectHeight
    })
    .height('100%')
    .width('100%')
  }
}