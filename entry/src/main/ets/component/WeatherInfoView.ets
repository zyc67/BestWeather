import { BaseList, HttpUtils } from '@bw/common'
import { WeatherInfoModel, WeatherInfoResp } from '../models/WeatherInfoModel'
import { WeatherInfoItem } from './WeatherInfoItem'

@Component
export struct WeatherInfoView {
  lastCreateTime: string = ''

  @State weatherInfoList: WeatherInfoModel[] = []

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
  }

  @Builder
  renderItem(item: object) {
    WeatherInfoItem({item: item as WeatherInfoModel})
  }

  build() {
    BaseList({
      dataSource: this.weatherInfoList,
      renderItem: this.renderItem,
      onRefresh: () => {
        this.requestWeatherInfoList(true)
      },
      onLoadMoreData: () => {
        this.requestWeatherInfoList(false)
      }
    })
      .height('100%')
  }
}