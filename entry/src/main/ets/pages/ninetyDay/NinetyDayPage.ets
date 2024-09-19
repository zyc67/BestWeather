import { HttpUtils } from '@bw/common/src/main/ets/http/HttpUtils'
import { NinetyDaysResp, NinetyWeaTrendModel, NinetyWeaTrendChartModel,
  NinetyModel } from '../../models/NinetyDaysResp'
import { NinetyUtils } from '../../utils/NinetyUtils'
import { NinetyNaviTitleView } from '../../component/ninety/NinetyNaviTitleView'
import { WeatherUtils, TOP_NAVI_HEIGHT, BaseCell } from '@bw/common'
import { NinetyTrendView } from '../../component/ninety/NinetyTrendView'
import { NinetyTrendChartView } from '../../component/ninety/NinetyTrendChartView'
import { NinetyCalendarView } from '../../component/ninety/NinetyCalendarView'
import { City } from '../../models/WeatherModel'

@Component
export struct NinetyDayPage {
  private topRectHeight = px2vp(AppStorage.get<number>(TOP_NAVI_HEIGHT) || 0)
  @State ninetyData: NinetyModel[] = []
  @State weaTrendModel: NinetyWeaTrendModel[] = []
  @State weaTrendChartModel: NinetyWeaTrendChartModel | undefined = undefined
  @State calendarData: NinetyModel[][] = []
  @State title: string = '90天天气趋势'
  @State subtitle: string = ''
  @State allCities: City[] = []
  @State isShowSheet: boolean = false

  aboutToAppear(): void {
    this.getNinetyDaysData()
  }

  async getNinetyDaysData() {
    const allCities = await WeatherUtils.getAllCities()
    const city = allCities[0]
    this.subtitle = city.localizedname || ''
    this.allCities = allCities
    this.requestNinetyDaysData(city)
  }

  async requestNinetyDaysData(city: City) {
    const ninetyDataResp = await HttpUtils.getNinetyDaysData<NinetyDaysResp>(city.citycode || '')
    if (ninetyDataResp.resultcode === '0') {
      const ninetyData = ninetyDataResp.data.dailys.dailyweathers
      const ninetyWeaTrend = NinetyUtils.getWeaTrendData(ninetyData)
      this.ninetyData = ninetyWeaTrend.ninetyData
      this.weaTrendModel = ninetyWeaTrend.weaTrendModel
      this.weaTrendChartModel = ninetyWeaTrend.weaTrendChartModel
      this.calendarData = NinetyUtils.addInvalidCalendarData(ninetyWeaTrend.calendarData)
    }
  }

  switchCity(city: City) {
    this.subtitle = city.localizedname || ''
    this.requestNinetyDaysData(city)
  }

  @Builder sheetContent() {
    Column() {
      ForEach(this.allCities, (city: City) => {
        Column() {
          Text(city.localizedname)
        }
        .width('100%')
        .height(60)
        .justifyContent(FlexAlign.Center)
        .borderColor({
          bottom: '#FFFFFF'
        })
        .borderWidth({
          bottom: 1
        })
        .onClick(() => {
          this.isShowSheet = !this.isShowSheet
          this.switchCity(city)
        })
      })
    }
    .width('100%')
  }

  build() {
    Column() {
      NinetyNaviTitleView({title: this.title, subtitle: this.subtitle, cityCount: this.allCities.length, isShowSheet: this.isShowSheet, sheetContent: () => {
        this.sheetContent()
      }})
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
        ListItem() {
          BaseCell() {
            NinetyCalendarView({calendarData: this.calendarData})
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