import { SCREEN_WIDTH } from '@bw/common'
import { NinetyWeaTrendChartModel, NinetyModel } from '../../models/NinetyDaysResp'
import { NinetyChartUtils } from '../../utils/NinetyChartUtils'
import { WeaIconWidth, LineLeft, RightMargin } from '../../utils/NinetyConstant'

@Component
export struct NinetyTrendChartView {
  @Prop ninetyData: NinetyModel[]
  @Prop @Watch('trendDataChange') weaTrendChartModel: NinetyWeaTrendChartModel
  private screenWidth = Number(AppStorage.get<string>(SCREEN_WIDTH))
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private moveContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  @State canvasWidth: number = 0
  private scroller: Scroller = new Scroller()
  private xOffset: number = 0
  private currentIndex: number = 0

  trendDataChange() {
    this.canvasWidth = LineLeft + RightMargin + WeaIconWidth * (this.weaTrendChartModel.highTemps ? this.weaTrendChartModel.highTemps.length : 0)
  }

  drawChartView() {
    // this.context.reset()
    // this.context.clearRect(0, 0, this.context.width, this.context.height)
    NinetyChartUtils.drawChartView(this.context, this.ninetyData, this.weaTrendChartModel)
  }

  build() {
    Column() {
      Scroll(this.scroller) {
        Stack() {
          Canvas(this.context)
            .width('100%')
            .height('100%')
            .onReady(() => {
              this.drawChartView()
            })
          Canvas(this.moveContext)
            .width('100%')
            .height('100%')
            .onReady(() => {
              setTimeout(() => {
                NinetyChartUtils.drawMoveLine(this.moveContext, this.ninetyData[0], 0, this.weaTrendChartModel)
              }, 300)
            })
        }
        .width(this.canvasWidth)
        .height('100%')
      }
      // .onWillScroll() 不要在onWillScroll回调中处理！！！
      .onDidScroll((xOffset: number) => {
        // console.log(xOffset.toString())
        this.xOffset += xOffset
        console.log(this.scroller.currentOffset().xOffset + '_' + this.xOffset)
        const offsetX = this.canvasWidth - (this.screenWidth - 12)
        const lineOffsetX = WeaIconWidth * (this.ninetyData.length - 1)
        const index: number = Math.round((this.xOffset * lineOffsetX / offsetX) / WeaIconWidth)
        if (index !== this.currentIndex) {
          NinetyChartUtils.drawMoveLine(this.moveContext, this.ninetyData[index], index, this.weaTrendChartModel)
          this.currentIndex = index
        }
      })
      .width('100%')
      .height('100%')
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height(266)
  }
}