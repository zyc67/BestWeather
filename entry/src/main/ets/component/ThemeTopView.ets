import { TOP_NAVI_HEIGHT } from '@bw/common'

@Component
export struct ThemeTopView {
  private topRectHeight = px2vp(AppStorage.get<number>(TOP_NAVI_HEIGHT) || 0)

  build() {
    Column() {

    }
    .width('100%')
    .height(this.topRectHeight + 240)
  }
}