import { WeatherUtils, RouterUtils, HOME_PAGE_SHOW_EVENT_ID, HttpUtils } from '@bw/common'
import { City } from '../../models/WeatherModel'
import { HomeTitleView } from '../../component/home/HomeTitleView'
import { WeaView } from '../../component/home/WeaView'
import { emitter } from '@kit.BasicServicesKit'

@Component
export struct HomePage {

  @State allCities: City[] = []
  @State currentIndex: number = 0
  @State refreshing: boolean = false
  @State refreshTitle: string = '数据更新中...'

  aboutToAppear(): void {
    const event: emitter.InnerEvent = {
      eventId: HOME_PAGE_SHOW_EVENT_ID
    };
    emitter.on(event, () => {
      this.getAllCities()
    })

    this.getAllCities()
    // setInterval(() => {
    //   this.refreshing = !this.refreshing
    // }, 3000)
  }

  async getAllCities() {
    this.allCities = await WeatherUtils.getAllCitys()
  }

  build() {
    Stack({alignContent: Alignment.Top}) {
      Tabs({barPosition: BarPosition.Start}) {
        ForEach(this.allCities, (city: City) => {
          TabContent() {
            WeaView({city})
          }
        })
      }
      .barHeight(0)
      .edgeEffect(EdgeEffect.None)
      .onChange((index) => {
        this.currentIndex = index
      })

      if (this.allCities.length > 0) {
        HomeTitleView({
          cityName: this.allCities[this.currentIndex].localizedname,
          currentIndex: this.currentIndex,
          cityCount: this.allCities.length,
          weaIcon: '',
          temperature: '29°',
          refreshing: this.refreshing,
          refreshTitle: this.refreshTitle,
          isLocation: this.allCities[this.currentIndex].addTime === 0,
          toCityManagerPageAction: () => {
            RouterUtils.pushUrl('pages/city/CityAddPage', { firstLaunch: false })
          },
          showCategoryViewAction: () => {

          }
        })
      }
    }
  }
}