import axios, { AxiosError, AxiosResponse } from '@ohos/axios'
import pako from 'pako'
import { apiKey,
  apiKeyXiAn,
  baseUrl, baseUrlTest, channelId,
  getUUID,
  language, SCREEN_HEIGHT, SCREEN_WIDTH,
  toBase64Encrypt,
  toXor} from '../../../../Index'
import { deviceInfo } from '@kit.BasicServicesKit';
import { bundleManager } from '@kit.AbilityKit'
import display from '@ohos.display'
import { util } from '@kit.ArkTS';

export class HttpManager {
  static async getUrl<T>(baseUrl: string, path: string, parameters: Record<string, Object>, getType: number, respType: number): Promise<T> {
    const res: AxiosResponse<T> = await axios.get<T, AxiosResponse<T>>(path, {
      url: path,
      method: 'GET',
      baseURL: baseUrl,
      params: await HttpManager.getParams(parameters, baseUrl, getType),
      responseEncoding: 'utf-8',
      responseType: 'array_buffer',
      readTimeout: 20000
    }).catch((e: AxiosError) => {
      return Promise.reject(e)
    })
    if (respType == 0) { // 直接处理
      return JSON.parse(util.TextDecoder.create('utf-8').decodeToString(new Uint8Array(res.data as ArrayBuffer))) as T
    } else if (respType == 1) { // gzip
      const jsonStr = pako.inflate(res.data, { to: 'string' }) as string
      console.log('接口返回' + jsonStr)
      return JSON.parse(jsonStr) as T
    } else {
      return Promise.resolve(res.data)
    }
  }

  static async postUrl<T>(url: string, parameters: Record<string, Object>, getType: number, respType: number): Promise<T> {
    let requestJson: Record<string, Object> = await HttpManager.getParams(parameters, '', getType)
    let requestData: string = getType === 1 ? toBase64Encrypt(toXor(JSON.stringify(requestJson))) : JSON.stringify(requestJson)
    const res: AxiosResponse<T> = await axios<T, AxiosResponse<T>>({
      url: url,
      method: 'POST',
      responseEncoding: 'utf-8',
      responseType: 'array_buffer',
      readTimeout: 20000,
      data: requestData,
      headers: {
        'Content-Type': 'application/octet-stream',
        // 'User-Agent': ''
      }
    })
      .catch((e: AxiosError) => {
      return Promise.reject(e)
    })
    if (respType == 0) { // 直接处理
      return JSON.parse(util.TextDecoder.create('utf-8').decodeToString(new Uint8Array(res.data as ArrayBuffer))) as T
    } else if (respType == 1) { // gzip
      let jsonStr = pako.inflate(res.data, { to: 'string' }) as string
      console.log('接口返回'+jsonStr)
      return JSON.parse(jsonStr) as T
    } else {
      return Promise.resolve(res.data)
    }
  }

  private static async getParams(parameters: Record<string, Object>, host: string, getType: number) {
    if (!parameters) {
      parameters = {}
    }
    if (getType === 0) {
      // 西安气象新接口统一处理apikey和language
      if (host === baseUrl || host === baseUrlTest) {
        parameters['apikey'] = apiKey
        parameters['language'] = language
      }
    } else if (getType === 1) {
      parameters = await HttpManager.createXNCommReqMap(parameters)
    }
    return parameters
  }


  /**
   * 西安天气旧接口 统一公共变量
   * @param parameters
   * @returns
   */
  private static async createXNCommReqMap(parameters: Record<string, Object>): Promise<Record<string, Object>> {
    parameters['devNo'] = await getUUID()
    parameters['brand'] = 'apple'
    parameters['deviceType'] = 1
    parameters['vendor'] = 'apple'
    parameters['devName'] = deviceInfo.osFullName
    parameters['osType'] = 1
    parameters['osVer'] = deviceInfo.distributionOSVersion
    let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT
    let appInfo = await bundleManager.getBundleInfoForSelf(bundleFlags)
    parameters['softVer'] = appInfo.versionName
    parameters['operation'] = ''
    const w = AppStorage.get<string>(SCREEN_WIDTH)
    const h = AppStorage.get<string>(SCREEN_HEIGHT)
    parameters['reso'] = `${w},${h}`
    parameters['devDensity'] = display.getDefaultDisplaySync().densityPixels // todo://
    parameters['pkgName'] = appInfo.name
    parameters['locationSystem'] = 'GCJ02'
    parameters['netType'] = '1' // todo://
    parameters['chl'] = channelId
    parameters['language'] = 'zh-cn'
    parameters['idfa'] = '' // todo://
    parameters['uiVer'] = 'zuimei7'
    parameters['apikey'] = apiKeyXiAn

    return parameters
  }
}