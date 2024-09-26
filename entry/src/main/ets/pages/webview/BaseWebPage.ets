import { BaseNaviBar, BOTTOM_AVOID_AREA_HEIGHT } from '@bw/common';
import { webview } from '@kit.ArkWeb';
import { router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { WebViewUtils } from '../../utils/WebViewUtils';

@Entry
@Component
struct BaseWebPage {
  private bottomRectHeight = px2vp(AppStorage.get<number>(BOTTOM_AVOID_AREA_HEIGHT) || 0)
  private webController: webview.WebviewController = new webview.WebviewController()

  titleString: string = ''
  urlString: string = ''

  @State progress: number = 0

  // 前端页面调用应用侧函数
  jsCallApp: WebViewUtils = {
    setTheme: (data: string) => {
      const themeId: string = JSON.parse(data)['themeId']
      // 应用侧调用前端页面函数
      this.webController.runJavaScript('setThemeSuccess()')
    },
    savePic: (pic: string) => {

    }
  }

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>
    this.titleString = params['title'] as string
    this.urlString = params['url'] as string
  }

  build() {
    Column() {
      BaseNaviBar({title: this.titleString})
      if (this.progress > 0) {
        Progress({value: this.progress, total: 100, type: ProgressType.Linear})
          .width('100%')
          .height(2)
      }
      Web({src: this.urlString, controller: this.webController})
        .onProgressChange((event) => {
          this.progress = event.newProgress
          if (this.progress >= 100) {
            setTimeout(() => {
              this.progress = 0
            }, 100)
          }
        })
        .domStorageAccess(true)
        .darkMode(WebDarkMode.Auto)
        // .forceDarkAccess(true)
        .javaScriptProxy({
          object: this.jsCallApp,
          name: 'zmweather_app',
          methodList: ['setTheme', 'savePic'],
          controller: this.webController
        })
        .onControllerAttached(() => {
          try {
            const ua = this.webController.getUserAgent() + 'ZuiMei/1.0zuimeiIOS'
            this.webController.setCustomUserAgent(ua)
          } catch (error) {
            console.error(`ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
          }
        })
        .onPageEnd(() => {
          // 先调用onPageEnd，再调用onProgressChange，此时event.newProgress===100
          // this.progress = 0
        })
        .onRenderExited(() => {
          // onRenderExited，再调用onProgressChange，此时event.newProgress===100
          // this.progress = 0
        })
        .layoutWeight(1)
    }
    .padding({
      bottom: this.bottomRectHeight
    })
    .height('100%')
    .width('100%')
  }
}
