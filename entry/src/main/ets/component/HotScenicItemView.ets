import { City } from '../models/WeatherModel'

@Component
export struct HotScenicItemView {
  @Prop hotScenic?: City[]
  action: (city: City) => void = () => {}

  @Builder scenicItemLarge(item: City) {
    Stack({alignContent: Alignment.Bottom}) {
      Image(item.bgImg)
        .width('100%')
        .height(72)
        .objectFit(ImageFit.Contain)
        .borderRadius(4)
      Text(item.localizedname)
        .fontSize(16)
        .fontColor('#FFFFFF')
        .maxLines(1)
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
        .backgroundColor('#00000066')
        .textAlign(TextAlign.Center)
    }
    .onClick(() => {
      this.action(item)
    })
  }

  @Builder scenicItem(item: City) {
    Row() {
      Text(item.localizedname)
        .fontSize(16)
        .fontColor('#666666')
        .borderRadius(4)
        .maxLines(1)
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
    }
    .width('100%')
    .height(26)
    .backgroundColor('#F8F8F8')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.action(item)
    })
  }

  build() {
    Grid() {
      ForEach(this.hotScenic, (item: City, index: number) => {
        GridItem() {
          if (index < 3) {
            this.scenicItemLarge(item)
          } else {
            this.scenicItem(item)
          }
        }
      })
    }
    .columnsTemplate('1fr 1fr 1fr')
    .columnsGap(8)
    .rowsGap(8)
    .maxCount(3)
  }
}