// 热门城市
import { getAreaName } from '@bw/common'
import { AreaHotCityModel } from '../models/HotCityModel'
import { City } from '../models/WeatherModel'

@Component
export struct HotCityView {

  @Prop areaHotCity: AreaHotCityModel[]
  action: (city: City) => void = () => {}

  @Builder cityHeader(areaCode: string) {
    Text(getAreaName(areaCode))
      .fontColor('#666666')
      .fontSize(16)
      .textAlign(TextAlign.Center)
      .backgroundColor(Color.White)
      .height(50)
  }

  build() {
    List() {
      ForEach(this.areaHotCity, (item: AreaHotCityModel) => {
        ListItemGroup({ header: this.cityHeader(item.area) }) {
          ListItem() {
            Grid() {
              ForEach(item.cityList, (city: City) => {
                GridItem() {
                  Text(city.localizedname)
                    .fontSize(16)
                    .fontColor('#666666')
                    .borderRadius(4)
                    .maxLines(1)
                    .textOverflow({
                      overflow: TextOverflow.Ellipsis
                    })
                }
                .height(26)
                .backgroundColor('#F8F8F8')
                .onClick(() => {
                  this.action(city)
                })
              })
            }
            .columnsTemplate('1fr 1fr 1fr')
            .columnsGap(8)
            .rowsGap(8)
            .maxCount(3)
          }
        }
      })
    }
  }
}