import { BaseList, BaseNaviBar, HttpUtils } from '@bw/common'
import { WeatherInfoModel, WeatherInfoResp } from '../models/WeatherInfoModel'
import { WeatherInfoItem } from './WeatherInfoItem'

@Component
export struct WeatherInfoView {
  lastCreateTime: string = ''

  @Consume @Watch('switchSecondView') isSecondView: boolean
  @Consume @Watch('refresh') weatherInfoRefresh: boolean

  @State weatherInfoList: WeatherInfoModel[] = []

  scroller: Scroller = new Scroller()

  aboutToAppear(): void {
    this.requestWeatherInfoList(true)
  }

  async requestWeatherInfoList(refreshing: boolean) {
    const result = await HttpUtils.getWeatherInfoList<WeatherInfoResp>(this.lastCreateTime)
    this.lastCreateTime = result.flagTime ?? '0'
    if (refreshing) {
      this.weatherInfoList = result.infoFlowList ?? []
    } else {
      this.weatherInfoList = this.weatherInfoList.concat(result.infoFlowList ?? [])
    }
    this.weatherInfoRefresh = false
  }

  switchSecondView() {
    if (!this.isSecondView) {
      this.scroller.scrollToIndex(0)
    }
  }

  refresh() {
    this.scroller.scrollToIndex(0)
  }

  @Builder
  renderItem(item: object) {
    WeatherInfoItem({item: item as WeatherInfoModel})
  }

  build() {
    Column() {
      BaseNaviBar({title: '天气资讯', canBack: false})
      BaseList({
        dataSource: this.weatherInfoList,
        renderItem: this.renderItem,
        isRefreshing: this.weatherInfoRefresh,
        nestedScroll: ({
          scrollForward: this.isSecondView ? NestedScrollMode.SELF_ONLY : NestedScrollMode.PARENT_FIRST,
          scrollBackward: this.isSecondView ? NestedScrollMode.SELF_ONLY : NestedScrollMode.PARENT_FIRST
        }),
        onRefresh: async () => {
          await this.requestWeatherInfoList(true)
        },
        onLoadMoreData: async () => {
          await this.requestWeatherInfoList(false)
        },
        onLoad:(scroller: Scroller) => {
          this.scroller = scroller
        }
      })
        .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}