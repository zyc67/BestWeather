import { NinetyWeaTrendModel } from '../../models/NinetyDaysResp'

@Component
export struct NinetyTrendView {
  @Prop weaTrend: NinetyWeaTrendModel[]
  
  build() {
    Grid() {
      ForEach(this.weaTrend, (item: NinetyWeaTrendModel, index: number) => {
        GridItem() {
          NinetyTrendItem({item, index})
        }
      })
    }
    .columnsTemplate('1fr 1fr 1fr')
    .rowsGap(10)
    .padding(10)
  }
}

@Component
struct NinetyTrendItem {
  @Prop item: NinetyWeaTrendModel
  index: number = 0
  build() {
    Column({ space: 6}) {
      Image(this.item.icon)
        .width(38)
        .height(38)
        .objectFit(ImageFit.Contain)
      Text(this.item.title)
        .fontColor('#FFFFFF')
        .fontSize(17)
      Row() {
        Text(this.item.firstDateString)
          .fontColor('#85FFFFFF')
          .fontSize(15)
        if (this.item.indexes.split(',').length > 1) {
          Image($r('app.media.icon_drop_down'))
            .width(10)
            .height(10)
            .objectFit(ImageFit.Contain)
            .rotate({
              angle: -90
            })
            .fillColor('#85FFFFFF')
        }
      }
    }
    .padding({
      top: 6,
      bottom: 6
    })
    .width('100%')
  }
}