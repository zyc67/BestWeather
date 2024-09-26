import { getCurrentThemeId, RouterUtils } from '@bw/common'
import { ThemeModel } from '../models/ThemeModel'
import { router } from '@kit.ArkUI'

@Component
export struct ThemeListView {

  @Prop type: number
  @Prop themeList: ThemeModel[]
  @Prop usedThemeId: string
  @Prop usedThemeType: number
  themeUsedAction: (themeId: string, themeType: number) => void = () => {}

  build() {
    Grid() {
      ForEach(this.themeList, (theme: ThemeModel) => {
        GridItem() {
          Column() {
            Image(this.type === 0 ? theme.cover_concise : theme.cover)
              .aspectRatio(170/305)
            Row() {
              Text(theme.theme_name)
                .fontColor('#333333')
                .fontSize(13)
              Button(theme.theme_id === this.usedThemeId && this.type === this.usedThemeType ? '使用中' : '使用')
                .width(70)
                .height(28)
                .fontSize(11)
                .backgroundColor(theme.theme_id === this.usedThemeId && this.type === this.usedThemeType ? '#158EFF' : '#F3F3F3')
                .fontColor(theme.theme_id === this.usedThemeId && this.type === this.usedThemeType ? '#FFFFFF' : '#333333')
                .onClick(() => {
                  if (theme.theme_id !== this.usedThemeId || this.type !== this.usedThemeType) {
                    // console.log(theme.theme_name + '_' + this.type)
                    this.themeUsedAction(theme.theme_id!, this.type)
                  }
                })
            }
            .width('100%')
            .padding({
              top: 10,
              bottom: 10,
              left: 5,
              right: 5
            })
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width('100%')
          .onClick(async () => {
            RouterUtils.pushUrl('pages/webview/BaseWebPage', {
              title: theme.theme_name,
              url: (this.type === 2 ? theme.detail_url_concise : theme.detail_url) + '&isUse=' + (theme.theme_id === await getCurrentThemeId() ? 1 : 0)
            })
          })
        }
      })
    }
    .columnsTemplate('1fr 1fr')
    .columnsGap(12)
    .rowsGap(12)
    .maxCount(2)
    .padding(10)
  }
}