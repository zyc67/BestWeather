import { PrivacyModel } from '../models/PrivacyModel'

@Component
export struct PrivacyItem {

  item: PrivacyModel = {} as PrivacyModel

  build() {
    Row() {
      Image(this.item.icon)
        .width(26)
        .height(26)
        .objectFit(ImageFit.Contain)
      Column({ space: 6 }) {
        Text(this.item.title)
          .fontSize(16)
          .fontColor('#2C2C2C')
          .fontWeight(FontWeight.Bold)
        Text(this.item.subtitle)
          .fontSize(14)
          .fontColor('#666666')
      }
      .margin({
        left: 10
      })
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height(70)
  }
}