import { City } from '../models/WeatherModel'

@Component
export struct HotGolfItemView {
  @Prop hotGolf?: City[]
  action: (city: City) => void = () => {}

  build() {
    Column() {
      Text('高尔夫球场')
        .fontSize(16)
        .fontColor('#333333')
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Center)
        .height(40)
      List() {
        ForEach(this.hotGolf, (item: City) => {
          ListItem() {
            Row() {
              Text(item.localizedname)
                .fontSize(16)
                .fontColor('#666666')
                .maxLines(1)
                .textOverflow({
                  overflow: TextOverflow.Ellipsis
                })
              Image($r('app.media.icon_left_arrow'))
                .height(16)
                .height(16)
                .objectFit(ImageFit.Contain)
                .rotate({angle: 180})
            }
            .width('100%')
            .height(48)
            .justifyContent(FlexAlign.SpaceBetween)
            .onClick(() => {
              this.action(item)
            })
          }
        })
      }
    }
    .alignItems(HorizontalAlign.Start)
  }
}