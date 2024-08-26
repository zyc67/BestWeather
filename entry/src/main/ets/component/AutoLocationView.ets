@Preview
@Component
export struct AutoLocationView {
  currentLocation: string = '当前位置  --'
  autoLocationAction: () => void = () => {}
  build() {
    Column() {
      Image($r('app.media.icon_add_city_location'))
        .width(110)
        .height(58)
        .margin({
          top: 2
        })
      Text(this.currentLocation)
        .fontSize(16)
        .fontColor('#333333')
        .margin({
          left: 16,
          right: 16,
          top: 16
        })
        .textAlign(TextAlign.Center)
      Button('自动定位')
        .backgroundColor('#1F90FF')
        .fontColor('#FFFFFF')
        .fontSize(16)
        .borderRadius(20)
        .width(234)
        .height(40)
        .margin({
          top: 6
        })
        .onClick(() => {
          this.autoLocationAction()
        })
      Text('自动定位后，可以获取高精度天气预报')
        .fontSize(14)
        .fontColor('#999999')
        .margin({
          top: 10
        })
    }
    .width('100%')
    .height(190)
    .backgroundColor(Color.White)
  }
}