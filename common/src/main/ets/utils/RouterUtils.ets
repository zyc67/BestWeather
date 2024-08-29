import { router } from '@kit.ArkUI'

export class Params {
  title?: string = ''
  url?: string = ''
  firstLaunch?: boolean = false
}

export class RouterUtils {
  static pushUrl(url: string, params?: Params) {
    router.pushUrl({
      url,
      params
    })
  }

  static replaceUrl(url: string, params?: Params) {
    router.replaceUrl({
      url,
      params
    })
  }

  static back(url?: string, params?: Params) {
    if (url) {
      router.back({
        url,
        params
      })
    } else {
      router.back()
    }
  }

  static getParams() {
    return router.getParams() as Params
  }
}