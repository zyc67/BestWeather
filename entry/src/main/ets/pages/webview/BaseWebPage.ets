import { BaseNaviBar, TOP_NAVI_HEIGHT } from '@bw/common';

@Entry
@Component
struct BaseWebPage {
  private topRectHeight = px2vp(AppStorage.get<number>(TOP_NAVI_HEIGHT) || 0)

  build() {
    Column() {
      BaseNaviBar({title: 'webview'})
    }
    .padding({
      top: this.topRectHeight
    })
    .height('100%')
    .width('100%')
  }
}