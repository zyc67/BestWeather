import { AMapLocationManagerImpl, AMapLocationOption, AMapLocationReGeocodeLanguage,
  IAMapLocationListener, AMapLocationType } from '@amap/amap_lbs_location'
import { AMAP_KEY } from '../constant'
import { AMapPrivacyShowStatus, AMapPrivacyInfoStatus, AMapPrivacyAgreeStatus } from '@amap/amap_lbs_common'
import { Context } from '@ohos.abilityAccessCtrl'
import { geoLocationManager } from '@kit.LocationKit'

export function initAmap(context: Context) {
  AMapLocationManagerImpl.setApiKey(AMAP_KEY)
  AMapLocationManagerImpl.updatePrivacyShow(AMapPrivacyShowStatus.DidShow, AMapPrivacyInfoStatus.DidContain, context)
  AMapLocationManagerImpl.updatePrivacyAgree(AMapPrivacyAgreeStatus.DidAgree, context)
  const locationManger = new AMapLocationManagerImpl(context);

  let options: AMapLocationOption = {
    priority: geoLocationManager.LocationRequestPriority.FIRST_FIX, //定位优先配置选项
    scenario: geoLocationManager.LocationRequestScenario.UNSET, //定位场景设置
    maxAccuracy: 0, //定位精度 单位：米
    singleLocationTimeout: 3000, //指定单次定位超时时间
    locatingWithReGeocode: false, //定位是否返回逆地理信息
    reGeocodeLanguage: AMapLocationReGeocodeLanguage.Chinese, //逆地址语言类型
    isOffset: false //是否加偏
  }

  let listener: IAMapLocationListener = {
    onLocationChanged: (location) => {
      // todo something
    }, onLocationError: (error) => {
      // todo something
    }
  }

  locationManger.setLocationListener(AMapLocationType.Single, listener) //设置定位信息监听
  locationManger.setLocationOption(AMapLocationType.Single, options) //设置定位配置项
  locationManger.requestSingleLocation() //单次定位
}

export function startLocation() {

}