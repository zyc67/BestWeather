import { TOP_NAVI_HEIGHT } from '@bw/common'
import { CircleIndicator, IndicatorConfig } from '@ohos/banner'
import { curves } from '@kit.ArkUI'

@Preview
@Component
export struct HomeTitleView {
  private topRectHeight = px2vp(AppStorage.get<number>(TOP_NAVI_HEIGHT) || 0)
  @Prop cityName: string
  @Prop @Watch('cityCountChange') cityCount: number = 0
  @Prop @Watch('switchCities') currentIndex: number = 0
  @Prop up: boolean = false
  @Prop weaIcon: Resource | string
  @Prop temperature: string
  @Prop @Watch('refreshWeatherData') refreshing: boolean
  @Prop refreshTitle: string
  @Prop isLocation: boolean
  toCityManagerPageAction: () => void = () => {}
  showCategoryViewAction: (index: number) => void = () => {}
  @State indicatorConfig: IndicatorConfig = new IndicatorConfig(this.cityCount, this.currentIndex, '#FFFFFF', '#FFFFFF80')
  @State translateY: number = 0

  cityCountChange() {
    const indicatorConfig: IndicatorConfig = new IndicatorConfig(this.cityCount, this.currentIndex, '#FFFFFF', '#FFFFFF80')
    indicatorConfig.normalWidth = 3
    indicatorConfig.selectedWidth = 4
    indicatorConfig.indicatorSpace = 2
    this.indicatorConfig = indicatorConfig
  }

  switchCities() {
    this.indicatorConfig.currentPosition = this.currentIndex
  }

  refreshWeatherData() {
    animateTo({curve: curves.springMotion()}, () => {
      this.translateY = this.refreshing ? -2 : 0
    })
  }

  aboutToAppear(): void {
    this.cityCountChange()
  }

  toCityManagerPage() {
    this.toCityManagerPageAction()
  }

  @Builder locationBuilder() {
    Text() {
      Span(this.cityName)
        .fontColor('#FFFFFF')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
      if (this.isLocation) {
        ImageSpan($r('app.media.icon_location'))
          .width(24)
          .height(24)
          .objectFit(ImageFit.Contain)
          .verticalAlign(ImageSpanAlignment.CENTER)
      }
    }
    .textOverflow({
      overflow: TextOverflow.MARQUEE
    })
    .translate({
      y: this.translateY
    })
  }

  @Builder categoryBuilder() {
    Image($r('app.media.icon_home_category'))
      .width(20)
      .height(20)
      .margin({
        left: 20
      })
      .bindMenu([
        {
          value: '天气地图',
          action: () => {
            this.showCategoryViewAction(0)
          }
        },
        {
          value: '个性主题',
          action: () => {
            this.showCategoryViewAction(1)
          }
        },
        // {
        //   value: '灵动组件',
        //   action: () => {
        //     this.showCategoryViewAction(2)
        //   }
        // },
        {
          value: '关闭广告',
          action: () => {
            this.showCategoryViewAction(2)
          }
        },
        {
          value: '分享精彩',
          action: () => {
            this.showCategoryViewAction(3)
          }
        },
      ])
  }

  build() {
    Column() {
      if (!this.up) {
        Row() {
          Image($r('app.media.icon_add'))
            .width(28)
            .height(28)
            .onClick(() => {
              this.toCityManagerPage()
            })

          Column() {
            this.locationBuilder()
            if (this.translateY != 0) {
              Text(this.refreshTitle)
                .fontColor('#FFFFFF')
                .fontSize(10)
            }
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
          .onClick(() => {
            this.toCityManagerPage()
          })

          this.categoryBuilder()
        }
      } else {
        Row() {
          Row() {
            Column() {
              this.locationBuilder()
            }
            .alignItems(HorizontalAlign.Start)
            .constraintSize({
              maxWidth: '60%'
            })
            .onClick(() => {
              this.toCityManagerPage()
            })
            Image(this.weaIcon)
              .width(28)
              .height(28)
            Text(this.temperature)
              .fontColor('#FFFFFF')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
          }
          .layoutWeight(1)
          this.categoryBuilder()
        }
        .justifyContent(FlexAlign.SpaceBetween)
      }
      CircleIndicator({indicatorConfig: this.indicatorConfig})
        .margin({
          left: this.up ? 0 : 28
        })
    }
    .width('100%')
    .height(60 + this.topRectHeight)
    .padding({
      left: 10,
      right: 10,
      top: this.topRectHeight
    })
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Start)
  }
}