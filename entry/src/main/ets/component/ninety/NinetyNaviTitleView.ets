@Component
export struct NinetyNaviTitleView {
  @Prop title: string
  @Prop subtitle: string
  @Prop cityCount: number
  @Link isShowSheet: boolean
  @BuilderParam sheetContent: () => void = this.empty

  @Builder empty() {
    Column() {

    }
  }

  @Builder titleBuilder() {
    Column() {
      Text('此处显示城市列表已添加的城市')
    }
    .width('100%')
    .height(60)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.Red)
  }

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
          if (this.cityCount) {
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
        .bindSheet($$this.isShowSheet, this.sheetContent(), {
          height: Math.min((this.cityCount + 1) * 60, 300),
          showClose: true,
          title: {
            title: '此处显示城市列表已添加的城市',
            // subtitle: '哈哈'
          }
          // title: this.titleBuilder()
        })
        // .onDisAppear(() => {
        //   this.isShowSheet = !this.isShowSheet
        // })
        .onClick(() => {
          this.isShowSheet = !this.isShowSheet
        })
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