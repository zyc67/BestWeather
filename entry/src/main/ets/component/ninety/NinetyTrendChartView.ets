import { NinetyWeaTrendModel, NinetyWeaTrendChartModel } from '../../models/NinetyDaysResp'

@Component
export struct NinetyTrendChartView {
  @Prop weaTrend: NinetyWeaTrendModel[]
  @Prop weaTrendChartModel: NinetyWeaTrendChartModel

  build() {
    Row() {
      Column() {

      }
    }
    .height(266)
  }
}