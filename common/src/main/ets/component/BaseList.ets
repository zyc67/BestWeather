@Preview
@Component
export struct BaseList {
  @Prop dataSource: object[]
  @Prop headerDragTitle: string = '下拉可以刷新'
  @Prop headerOverDragTitle: string = '松开立即刷新'
  @Prop headerRefreshingTitle: string = '努力加载中...'
  @Prop headerDoneTitle: string = '加载完成'
  @Prop footerRefreshTitle: string = '努力加载中...'
  @Prop footerEndTitle: string = '我是有底线的'
  @Prop noData: boolean = false
  @Prop nestedScroll: NestedScrollOptions
  scroller: Scroller = new Scroller()

  @BuilderParam renderItem: (item: object) => void = this.defaultItem

  @Builder defaultItem() {}

  @Link isRefreshing: boolean
  @State isLoadMoreData: boolean = false
  @State ratio: number = 1
  @State status: RefreshStatus = RefreshStatus.Inactive

  onRefresh: () => void = () => {}
  onLoadMoreData: () => void = () => {}
  onLoad: (scroller: Scroller) => void = () => {}

  getHeaderTitle() {
    switch (this.status) {
      case RefreshStatus.Drag:
        return this.headerDragTitle
      case RefreshStatus.OverDrag:
        return this.headerOverDragTitle
      case RefreshStatus.Refresh:
        return this.headerRefreshingTitle
      case RefreshStatus.Done:
        return this.headerDoneTitle
      default:
        return ''
    }
  }
  
  @Builder header() {
    Row({space: 10}) {
      Text(this.getHeaderTitle())
        .fontColor('#A7A7A7')
        .fontSize(12)
      LoadingProgress()
        .width(20)
        .height(20)
        .color('#A7A7A7')
    }
    .width('100%')
    .height(64)
    .justifyContent(FlexAlign.Center)
  }

  @Builder footer() {
    Row({space: 10}) {
      if (this.noData) {
        Text(this.footerEndTitle)
          .fontColor('#A7A7A7')
          .fontSize(12)
      } else {
        Text(this.footerRefreshTitle)
          .fontColor('#A7A7A7')
          .fontSize(12)
        LoadingProgress()
          .width(20)
          .height(20)
          .color('#A7A7A7')
      }
    }
    .width('100%')
    .height(64)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      Refresh({refreshing: $$this.isRefreshing, builder: this.header}) {
        List({scroller: this.scroller}) {
          ForEach(this.dataSource, (item: object) => {
            ListItem() {
              if (this.renderItem) {
                this.renderItem(item)
              }
            }
          })
          ListItem() {
            this.footer()
          }
        }
        .nestedScroll(this.nestedScroll)
        .scrollBar(BarState.Off)
        .onReachEnd(async () => {
          if (this.isRefreshing || this.isLoadMoreData) {
            return
          }
          this.isLoadMoreData = true
          await this.onLoadMoreData()
          this.isLoadMoreData = false
        })
        .onAppear(() => {
          this.onLoad(this.scroller)
        })
      }
      .pullToRefresh(true)
      .refreshOffset(64)
      .pullDownRatio(this.ratio)
      .onStateChange((refreshStatus: RefreshStatus) => {
        // 当前刷新状态变更时，触发回调
        this.status = refreshStatus
      })
      .onOffsetChange((offset: number) => {
        // 下拉距离发生变化时触发回调
        // this.ratio = 1 - Math.pow((offset / 200), 3) // 越接近最大距离，下拉跟手系数越小
      })
      .onRefreshing(async () => {
        // 进入刷新状态时触发回调
        await this.onRefresh()
        this.isRefreshing = false
      })
    }
  }
}