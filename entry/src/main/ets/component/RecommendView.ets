import { HotCityModel } from '../models/HotCityModel'
import { City } from '../models/WeatherModel'
import { AutoLocationView } from './AutoLocationView'
import { CitySearchView } from './CitySearchView'
import { HotCityTab } from './HotCityTab'
import { HotCityView } from './HotCityView'
import { HotScenicView } from './HotScenicView'

@Component
export struct RecommendView {
  private listScroller: ListScroller = new ListScroller()
  action: (city: City) => void = () => {}
  @Prop hotCityModel: HotCityModel
  @State offsetX: number = 0
  @State currentIndex: number = 0

  @Builder header() {
    HotCityTab({offsetX: this.offsetX, action: (index: number) => {
      this.listScroller.scrollToIndex(index, true)
    }})
      .width('100%')
      .height(56)
      .backgroundColor(Color.White)
      .padding({
        left: 16
      })
  }

  build() {
    List() {
      ListItemGroup() {
        AutoLocationView()
      }
      ListItemGroup({ header: this.header()}) {
        ListItem() {
          List({ scroller: this.listScroller}) {
            ListItem() {
              HotCityView({areaHotCity: this.hotCityModel.areaHotCity, action: this.action})
                .padding({
                  left: 16,
                  right: 16
                })
            }
            .width('100%')

            ListItem() {
              HotScenicView({hotScenic: this.hotCityModel.hotScenic, hotGolf: this.hotCityModel.hotGolf, action: this.action})
            }
            .width('100%')
          }
          .listDirection(Axis.Horizontal)
          .edgeEffect(EdgeEffect.None)
          .scrollBar(BarState.Off)
          .onDidScroll((scrollOffset: number) => {
            this.offsetX += scrollOffset
          })
          .onScrollIndex((start: number, end: number, center: number) => {
            this.currentIndex = center
          })
          .onScrollStop(() => {
              this.listScroller.scrollToIndex(this.currentIndex, true)
          })
        }
      }
    }
    .scrollBar(BarState.Off)
    .sticky(StickyStyle.Header)
  }
}