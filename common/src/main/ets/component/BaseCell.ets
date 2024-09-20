@Component
export struct BaseCell {
  @Prop bgColor: ResourceColor = '#24FFFFFF'
  @BuilderParam contentBuilder: () => void

  build() {
    Column() {
      this.contentBuilder()
    }
    .width('100%')
    .borderRadius(6)
    .backgroundColor(this.bgColor)
  }
}