import { HttpUtils } from '@bw/common/src/main/ets/http/HttpUtils'
import { NinetyDaysResp, NinetyWeaTrendModel } from '../../models/NinetyDaysResp'
import { NinetyUtils } from '../../utils/NinetyUtils'
import { NinetyNaviTitleView } from '../../component/ninety/NinetyNaviTitleView'
import { WeatherUtils, TOP_NAVI_HEIGHT, BaseCell } from '@bw/common'
import { NinetyTrendView } from '../../component/ninety/NinetyTrendView'

@Component
export struct NinetyDayPage {
  private topRectHeight = px2vp(AppStorage.get<number>(TOP_NAVI_HEIGHT) || 0)
  @State ninetyWeaTrend: NinetyWeaTrendModel[] = []
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
      this.ninetyWeaTrend = NinetyUtils.getWeaTrendData(ninetyData)
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
            NinetyTrendView({ninetyWeaTrend: this.ninetyWeaTrend})
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