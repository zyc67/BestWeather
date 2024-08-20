import { router } from '@kit.ArkUI'

export class RouterUtils {
  static pushUrl(url: string, params?: Object) {
    router.pushUrl({
      url,
      params
    })
  }

  static replaceUrl(url: string, params?: Object) {
    router.replaceUrl({
      url,
      params
    })
  }

  static back(url?: string, params?: Object) {
    if (url) {
      router.back({
        url,
        params
      })
    } else {
      router.back()
    }
  }
}