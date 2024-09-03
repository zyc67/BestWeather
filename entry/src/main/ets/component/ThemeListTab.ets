import { SCREEN_WIDTH } from '@bw/common'

@Preview
@Component
export struct ThemeListTab {
  private screenWidth = Number(AppStorage.get<string>(SCREEN_WIDTH))
  private tabWidth = 80
  private marginSpace = 30
  private indicatorWidth = 18
  @Prop offsetX: number = 0
  @State selectIndex: number = 0
  action: (index: number) => void = () => {}

  build() {
    Column() {
      Row() {
        Text('简洁模式')
          .fontSize(16)
          .fontColor(this.selectIndex === 0 ? '#333333' : '#666666')
          .width(this.tabWidth)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            if (this.selectIndex !== 0) {
              this.selectIndex = 0
              this.action(0)
            }
          })
        Text('经典模式')
          .fontSize(16)
          .fontColor(this.selectIndex === 1 ? '#333333' : '#666666')
          .width(this.tabWidth)
          .textAlign(TextAlign.Center)
          .margin({
            left: this.marginSpace
          })
          .onClick(() => {
            if (this.selectIndex !== 1) {
              this.selectIndex = 1
              this.action(1)
            }
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      Blank()
        .width(this.indicatorWidth)
        .height(2)
        .backgroundColor('#158EFF')
        .margin({
          left: ((this.screenWidth - 2 * this.tabWidth - this.marginSpace) / 2 + (this.tabWidth - this.indicatorWidth) / 2) + (this.offsetX / this.screenWidth) * (this.tabWidth + this.marginSpace),
          top: 6
        })
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Start)
  }
}