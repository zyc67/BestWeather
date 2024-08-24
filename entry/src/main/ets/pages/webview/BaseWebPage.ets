import { BaseNaviBar, BOTTOM_AVOID_AREA_HEIGHT, TOP_NAVI_HEIGHT } from '@bw/common';
import { webview } from '@kit.ArkWeb';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct BaseWebPage {
  private topRectHeight = px2vp(AppStorage.get<number>(TOP_NAVI_HEIGHT) || 0)
  private bottomRectHeight = px2vp(AppStorage.get<number>(BOTTOM_AVOID_AREA_HEIGHT) || 0)
  private webController: webview.WebviewController = new webview.WebviewController()

  titleString: string = ''
  urlString: string = ''

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>
    this.titleString = params['title'] as string
    this.urlString = params['url'] as string
  }

  build() {
    Column() {
      BaseNaviBar({title: this.titleString})
      Web({src: this.urlString, controller: this.webController})
    }
    .padding({
      top: this.topRectHeight,
      bottom: this.bottomRectHeight
    })
    .height('100%')
    .width('100%')
  }
}
