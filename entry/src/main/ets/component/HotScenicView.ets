// 热门景点 + 高尔夫球场
import { City } from '../models/WeatherModel'
import { HotGolfItemView } from './HotGolfItemView'
import { HotScenicItemView } from './HotScenicItemView'

@Component
export struct HotScenicView {
  @Prop hotScenic?: City[]
  @Prop hotGolf?: City[]
  action: (city: City) => void = () => {}
  build() {
    Column() {
      HotScenicItemView({hotScenic: this.hotScenic, action: this.action})
        .padding({
          left: 16,
          right: 16
        })
      Blank()
        .width('100%')
        .height(8)
        .backgroundColor('#F8F8F8')
        .margin({
          top: 20,
          bottom: 10
        })
      HotGolfItemView({hotGolf: this.hotGolf, action: this.action})
        .padding({
          left: 16,
          right: 16
        })
    }
  }
}