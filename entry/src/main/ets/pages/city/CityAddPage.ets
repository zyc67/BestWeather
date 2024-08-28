import { BaseNaviBar, BOTTOM_AVOID_AREA_HEIGHT, HttpUtils, TOP_NAVI_HEIGHT, startLocation,
  toLocationSetting, toApplicationInfo, WeatherUtils,
  RouterUtils } from '@bw/common';
import { CitySearchView } from '../../component/CitySearchView';
import { RecommendView } from '../../component/RecommendView';
import { HotCityModel, HotCityResp } from '../../models/HotCityModel';
import { City, CityWeatherData } from '../../models/WeatherModel';
import { AMapLocation } from '@amap/amap_lbs_location';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct CityAddPage {
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
    startLocation(getContext(this), (code: number, address: AMapLocation | undefined) => {
      // code 0成功获取定位信息 -1没有打开手机定位 -2请求权限失败 -3获取定位异常
      if (code === 0) {
        if (address && address.longitude > 0 && address.latitude > 0) {
          WeatherUtils.getLocationCityWeather(address.longitude.toString(), address.latitude.toString())
            .then((res) => {
              this.addCitySuccess()
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
      const res = await WeatherUtils.getCityWeatherWithCityCode(city.citycode)
      this.addCitySuccess()
    }
  }

  addCitySuccess() {
    RouterUtils.replaceUrl('pages/splash/SelectThemePage')
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
      BaseNaviBar({title: '添加城市', canBack: false})

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