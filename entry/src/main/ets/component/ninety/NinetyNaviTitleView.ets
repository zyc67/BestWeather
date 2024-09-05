@Component
export struct NinetyNaviTitleView {
  @Prop title: string
  @Prop subtitle: string
  @Prop hasMultiplyCities: boolean

  build() {
    Row() {
      Text(this.title)
        .fontColor('#FFFFFF')
        .fontSize(23)
        .fontWeight(FontWeight.Medium)
        .layoutWeight(1)
      Row() {
        Text() {
          Span(this.subtitle)
            .fontColor('#FFFFFF')
            .fontSize(17)
          if (this.hasMultiplyCities) {
            ImageSpan($r('app.media.icon_drop_down'))
              .width(24)
              .height(7)
              .objectFit(ImageFit.Contain)
              .verticalAlign(ImageSpanAlignment.CENTER)
              .margin({
                left: 6
              })
          }
        }
      }
      .justifyContent(FlexAlign.End)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      left: 6,
      right: 6
    })
  }
}