import { HttpUtils, BaseList, BaseNaviBar } from '@bw/common'
import { WeatherInfoDataSource } from '../models/WeatherInfoDataSource'
import { WeatherInfoModel, WeatherInfoResp } from '../models/WeatherInfoModel'
import { WeatherInfoItem } from './WeatherInfoItem'

@Component
export struct WeatherInfoViewLazy {
  lastCreateTime: string = ''
  @Consume @Watch('switchSecondView') isSecondView: boolean
  @Consume @Watch('refresh') weatherInfoRefresh: boolean
  @State weatherInfoList: WeatherInfoDataSource = new WeatherInfoDataSource()
  scroller: Scroller = new Scroller()
  @State isLoadMoreData: boolean = false

  aboutToAppear(): void {
    this.requestWeatherInfoList(true)
  }

  async requestWeatherInfoList(refreshing: boolean) {
    const result = await HttpUtils.getWeatherInfoList<WeatherInfoResp>(this.lastCreateTime)
    this.lastCreateTime = result.flagTime ?? '0'
    if (refreshing) {
      this.weatherInfoList.reloadData(result.infoFlowList ?? [])
    } else if (result.infoFlowList) {
      this.weatherInfoList.pushData(result.infoFlowList ?? [])
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
    WeatherInfoItem({ item: item as WeatherInfoModel })
  }

  build() {
    Column() {
      BaseNaviBar({ title: '天气资讯', canBack: false })
      Refresh({refreshing: $$this.weatherInfoRefresh}) {
        List({scroller: this.scroller}) {
          LazyForEach(this.weatherInfoList, (item: WeatherInfoModel) => {
            this.renderItem(item)
          }, (item: WeatherInfoModel) => item.id.toString())
        }
        .nestedScroll({
          scrollForward: this.isSecondView ? NestedScrollMode.SELF_ONLY : NestedScrollMode.PARENT_FIRST,
          scrollBackward: this.isSecondView ? NestedScrollMode.SELF_ONLY : NestedScrollMode.PARENT_FIRST
        })
        .onReachEnd(async () => {
          if (this.weatherInfoRefresh || this.isLoadMoreData) {
            return
          }
          this.isLoadMoreData = true
          await this.requestWeatherInfoList(false)
          this.isLoadMoreData = false
        })
      }
      .pullToRefresh(true)
      .refreshOffset(64)
      .onRefreshing(async () => {
        // 进入刷新状态时触发回调
        await this.requestWeatherInfoList(true)
      })

      // BaseList({
      //   isLazy: true,
      //   dataSource: this.weatherInfoList,
      //   renderItem: this.renderItem,
      //   isRefreshing: this.weatherInfoRefresh,
      //   nestedScroll: ({
      //     scrollForward: this.isSecondView ? NestedScrollMode.SELF_ONLY : NestedScrollMode.PARENT_FIRST,
      //     scrollBackward: this.isSecondView ? NestedScrollMode.SELF_ONLY : NestedScrollMode.PARENT_FIRST
      //   }),
      //   onRefresh: async () => {
      //     await this.requestWeatherInfoList(true)
      //   },
      //   onLoadMoreData: async () => {
      //     await this.requestWeatherInfoList(false)
      //   },
      //   onLoad: (scroller: Scroller) => {
      //     this.scroller = scroller
      //   }
      // })
        .layoutWeight(1)
    }
    .height('100%')
  }
}