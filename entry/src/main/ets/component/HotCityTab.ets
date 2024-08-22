import { SCREEN_WIDTH } from '@bw/common'

@Preview
@Component
export struct HotCityTab {
  private screenWidth = Number(AppStorage.get<string>(SCREEN_WIDTH))
  private tabWidth = 80
  private marginSpace = 30
  @Prop offsetX: number = 0
  @State selectIndex: number = 0
  action: (index: number) => void = () => {}
  build() {
    Column() {
      Row() {
        Text('热门城市')
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
        Text('热门景点')
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
      Blank()
        .width(40)
        .height(2)
        .backgroundColor('#333333')
        .margin({
          left: 20 + (this.offsetX / this.screenWidth) * (this.tabWidth + this.marginSpace),
          top: 6
        })
    }
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Start)
  }
}