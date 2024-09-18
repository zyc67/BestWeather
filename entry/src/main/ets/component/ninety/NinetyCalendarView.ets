import { NinetyModel } from '../../models/NinetyDaysResp'
import dayjs from 'dayjs'

@Component
export struct NinetyCalendarView {
  @Prop calendarData: NinetyModel[][] = []
  weeks: string[] = ['日', '一', '二', '三', '四', '五', '六']

  build() {
    Column() {
      Grid() {
        ForEach(this.weeks, (item: string) => {
          GridItem() {
            Text(item)
              .fontSize(15)
              .fontColor('#FFFFFF')
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Center)
          }
          .height(60)
        })
      }
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')

      Swiper() {
        ForEach(this.calendarData, (months: NinetyModel[]) => {
          Grid() {
            ForEach(months, (item: NinetyModel) => {
              GridItem() {
                Column({space: 6}) {
                  Text(item.daySolar.toString())
                    .fontSize(17)
                    .fontColor(item.weaIcon ? '#FFFFFF' : '#88FFFFFF')
                    .fontWeight(FontWeight.Bold)
                  Text(item.festival.length ? item.festival : (item.jieQi.length ? item.jieQi : item.dayLunar))
                    .fontSize(10)
                    .fontColor('#8AFFFFFF')
                    .textOverflow({
                      overflow: TextOverflow.MARQUEE
                    })
                  Image($r(`app.media.${item.weaIcon}`))
                    .width(25)
                    .height(25)
                }
                .borderRadius(4)
                .borderColor('#33FFFFFF')
                .borderWidth(dayjs(item.ptime).isToday() ? 1 : 0)
                .linearGradient({
                  direction: GradientDirection.Bottom,
                  colors: dayjs(item.ptime).isToday() ? [['#33FFFFFF', 0.0], ['#00FFFFFF', 1.0]] : []
                })
                .padding({
                  top: 10,
                  bottom: 10,
                  left: 2,
                  right: 2
                })
              }
            })
          }
          .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
        })
      }
      .autoPlay(false)
      .loop(false)
      .effectMode(EdgeEffect.None)
      .indicator(false)
      .margin({
        top: 16
      })
    }
    .padding(10)
  }
}