@Component
export struct BaseCell {
  @BuilderParam contentBuilder: () => void

  build() {
    Column() {
      this.contentBuilder()
    }
    .width('100%')
    .borderRadius(6)
    .backgroundColor('#24FFFFFF')
  }
}