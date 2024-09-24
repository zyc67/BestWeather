import { WeatherInfoModel } from '../models/WeatherInfoModel'

@Component
export struct WeatherInfoItem {
  @Prop item: WeatherInfoModel
  build() {
    Row() {
      Column() {
        Text(this.item.title)
          .fontColor('#333333')
          .fontSize(19)
          .maxLines(2)
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })
        Text(this.item.publishTime)
          .fontColor('#999999')
          .fontSize(13)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(HorizontalAlign.Start)
      .height('100%')
      .layoutWeight(1)

      Image(this.item.headImg)
        .width(140)
        .height(80)
        .margin({
          left: 8
        })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .height(124)
    .padding(12)
    .borderColor({
      bottom: '#EFEFEF'
    })
    .borderWidth({
      bottom: 1
    })
  }
}