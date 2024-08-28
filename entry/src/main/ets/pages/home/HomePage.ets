import { WeatherUtils } from '@bw/common'
import { City } from '../../models/WeatherModel'
import { HomeTitleView } from '../../component/home/HomeTitleView'

@Entry
@Component
export struct HomePage {

  @State allCities: City[] = []
  @State currentIndex: number = 0
  @State refreshing: boolean = false
  @State refreshTitle: string = '数据更新中...'

  aboutToAppear(): void {
    this.getAllCities()
    setInterval(() => {
      this.refreshing = !this.refreshing
    }, 3000)
  }

  async getAllCities() {
    // this.allCities = await WeatherUtils.getAllCitys()
    const array = await WeatherUtils.getAllCitys()
    if (array.length > 0) {
      this.allCities.push(array[0])
      this.allCities.push(array[0])
      this.allCities.push(array[0])
      this.allCities.push(array[0])
    }
  }

  build() {
    Stack({alignContent: Alignment.Top}) {
      Tabs({barPosition: BarPosition.Start}) {
        ForEach(this.allCities, (city: City) => {
          TabContent() {
            Text(city.localizedname)
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
          refreshTitle: this.refreshTitle
        })
      }
    }
  }
}