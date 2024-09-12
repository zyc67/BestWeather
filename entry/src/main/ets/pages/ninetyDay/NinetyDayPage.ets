import { HttpUtils } from '@bw/common/src/main/ets/http/HttpUtils'
import { NinetyDaysResp, NinetyWeaTrendModel, NinetyWeaTrendChartModel,
  NinetyModel } from '../../models/NinetyDaysResp'
import { NinetyUtils } from '../../utils/NinetyUtils'
import { NinetyNaviTitleView } from '../../component/ninety/NinetyNaviTitleView'
import { WeatherUtils, TOP_NAVI_HEIGHT, BaseCell } from '@bw/common'
import { NinetyTrendView } from '../../component/ninety/NinetyTrendView'
import { NinetyTrendChartView } from '../../component/ninety/NinetyTrendChartView'
import { JSON } from '@kit.ArkTS'

@Component
export struct NinetyDayPage {
  private topRectHeight = px2vp(AppStorage.get<number>(TOP_NAVI_HEIGHT) || 0)
  @State ninetyData: NinetyModel[] = []
  @State weaTrendModel: NinetyWeaTrendModel[] = []
  @State weaTrendChartModel: NinetyWeaTrendChartModel | undefined = undefined
  @State title: string = '90天天气趋势'
  @State subtitle: string = ''
  @State hasMultiplyCities: boolean = false

  aboutToAppear(): void {
    this.requestNinetyDaysData()
  }

  async requestNinetyDaysData() {
    const allCities = await WeatherUtils.getAllCities()
    this.hasMultiplyCities = allCities.length > 1
    const city = allCities[0]
    this.subtitle = city.localizedname || ''

    const ninetyDataResp = await HttpUtils.getNinetyDaysData<NinetyDaysResp>(city.citycode || '')
    if (ninetyDataResp.resultcode === '0') {
      const ninetyData = ninetyDataResp.data.dailys.dailyweathers
      const ninetyWeaTrend = NinetyUtils.getWeaTrendData(ninetyData)
      this.ninetyData = ninetyWeaTrend.ninetyData
      this.weaTrendModel = ninetyWeaTrend.weaTrendModel
      this.weaTrendChartModel = ninetyWeaTrend.weaTrendChartModel
    }
  }

  build() {
    Column() {
      NinetyNaviTitleView({title: this.title, subtitle: this.subtitle, hasMultiplyCities: this.hasMultiplyCities})
        .width('100%')
        .height(this.topRectHeight + 50)
        .padding({
          top: this.topRectHeight
        })
      List({ space: 12 }) {
        ListItem() {
          BaseCell() {
            NinetyTrendView({weaTrend: this.weaTrendModel})
            NinetyTrendChartView({ninetyData: this.ninetyData, weaTrendChartModel: this.weaTrendChartModel})
          }
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .padding(6)
    .backgroundColor('#29829D')
  }
}