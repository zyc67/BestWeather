import { AMapLocationManagerImpl, AMapLocationOption, AMapLocationReGeocodeLanguage,
  IAMapLocationListener, AMapLocationType, AMapLocation } from '@amap/amap_lbs_location'
import { AMAP_KEY } from '../constant'
import { AMapPrivacyShowStatus, AMapPrivacyInfoStatus, AMapPrivacyAgreeStatus } from '@amap/amap_lbs_common'
import abilityAccessCtrl, { Context, Permissions, PermissionRequestResult } from '@ohos.abilityAccessCtrl'
import { geoLocationManager } from '@kit.LocationKit'
import { isNetwork } from '.'
import { bundleManager } from '@kit.AbilityKit'
import { BusinessError } from '@kit.BasicServicesKit'

const locationPermissions: Array<Permissions> = ['ohos.permission.LOCATION', 'ohos.permission.APPROXIMATELY_LOCATION'];

function initAmap(context: Context, onLocationListener: (code: number, address: AMapLocation | undefined) => void) {
  AMapLocationManagerImpl.setApiKey(AMAP_KEY)
  AMapLocationManagerImpl.updatePrivacyShow(AMapPrivacyShowStatus.DidShow, AMapPrivacyInfoStatus.DidContain, context)
  AMapLocationManagerImpl.updatePrivacyAgree(AMapPrivacyAgreeStatus.DidAgree, context)
  const locationManger = new AMapLocationManagerImpl(context);

  let options: AMapLocationOption = {
    priority: geoLocationManager.LocationRequestPriority.FIRST_FIX, //定位优先配置选项
    scenario: geoLocationManager.LocationRequestScenario.UNSET, //定位场景设置
    maxAccuracy: 0, //定位精度 单位：米
    singleLocationTimeout: 3000, //指定单次定位超时时间
    locatingWithReGeocode: true, //定位是否返回逆地理信息
    reGeocodeLanguage: AMapLocationReGeocodeLanguage.Chinese, //逆地址语言类型
    isOffset: false //是否加偏
  }

  let listener: IAMapLocationListener = {
    onLocationChanged: (location) => {
      onLocationListener(0, location)
    }, onLocationError: (error) => {
      onLocationListener(-3, undefined)
    }
  }

  locationManger.setLocationListener(AMapLocationType.Single, listener) //设置定位信息监听
  locationManger.setLocationOption(AMapLocationType.Single, options) //设置定位配置项
  locationManger.requestSingleLocation() //单次定位
}

/**
 * 开始定位
 * @param context
 * @param onLocationListener
 *        code 0成功获取定位信息 -1没有打开手机定位 -2请求权限失败 -3获取定位异常
 */
export async function startLocation(context: Context, onLocationListener: (code: number, address: AMapLocation | undefined) => void) {
  // 是否有网络
  if (!isNetwork()) {
    return
  }

  //手机是否打开定位
  if (!geoLocationManager.isLocationEnabled()) {
    onLocationListener(-1, undefined)
    return
  }

  await checkPermissions(context, onLocationListener)
}

async function checkPermissions(context: Context, onLocationListener: (code: number, address: AMapLocation | undefined) => void): Promise<void> {
  let grantStatus = false
  for (let index = 0; index < locationPermissions.length; index++) {
    const element = locationPermissions[index]
    const status = await checkAccessToken(element)
    if (status === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
      grantStatus = true
    }
  }

  if (grantStatus) {
    // 已经授权，可以继续访问目标操作
    initAmap(context, onLocationListener)
  } else {
    //请求权限
    const status: boolean = await reqPermissionsFromUser(context, locationPermissions)
    if (status) {
      // 用户授权，可以继续访问目标操作
      initAmap(context, onLocationListener)
    } else {
      // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
      onLocationListener(-2, undefined)
    }
  }
}

async function checkAccessToken(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
  let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  let grantStatus: abilityAccessCtrl.GrantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED;

  // 获取应用程序的accessTokenID
  let tokenId: number = 0;
  try {
    let bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
    tokenId = appInfo.accessTokenId;
  } catch (error) {
    let err: BusinessError = error as BusinessError;
    console.error(`Failed to get bundle info for self. Code is ${err.code}, message is ${err.message}`);
  }

  // 校验应用是否被授予权限
  try {
    grantStatus = await atManager.checkAccessToken(tokenId, permission);
  } catch (error) {
    let err: BusinessError = error as BusinessError;
    console.error(`Failed to check access token. Code is ${err.code}, message is ${err.message}`);
  }

  return grantStatus;
}

// 申请权限
async function reqPermissionsFromUser(context: Context, permissions: Array<Permissions>) {
  try {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
    const data: PermissionRequestResult = await atManager.requestPermissionsFromUser(context, permissions)
    let grantStatus: Array<number> = data.authResults
    let status: boolean = true
    for (let i = 0; i < grantStatus.length; i++) {
      if (grantStatus[i] !== 0) {
        // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
        status = false
      }
    }
    return Promise.resolve(status)
  } catch (e) {
    return Promise.resolve(false)
  }
}