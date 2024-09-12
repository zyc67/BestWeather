import { getTabbarSelectedIcons, getTabbarNormalIcons, getTabbarItemSelectedColor, getTabbarItemNormalColor,
  BOTTOM_AVOID_AREA_HEIGHT, WeatherUtils, getTabbarBgColor, receiveEmitter, CHANGE_THEME_EVENT_ID } from '@bw/common'
import { HomePage } from '../home/HomePage'
import { NinetyDayPage } from '../ninetyDay/NinetyDayPage'
import { FindPage } from '../find/FindPage'
import { MePage } from '../me/MePage'
import dayjs from 'dayjs'
import isToday from 'dayjs/plugin/isToday'

@Entry
@Component
struct MainPage {
  private bottomRectHeight = px2vp(AppStorage.get<number>(BOTTOM_AVOID_AREA_HEIGHT) || 0)

  @State currentTabIndex: number = 0
  @State currentIndex: number = 0
  @State selectedIcons: string[] = []
  @State normalIcons: string[] = []
  @State selectedColor: string = '#FFFFFF'
  @State normalColor: string = '#FFFFFF'
  @State tabbarBgColor: string = '#FFFFFF'

  aboutToAppear(): void {
    this.getThemeData()
    this.changeIndex(this.currentIndex)
    receiveEmitter(CHANGE_THEME_EVENT_ID, () => {
      this.getThemeData()
      this.changeIndex(this.currentIndex)
    })
  }

  // onPageShow(): void {
  //   this.homePageShow()
  // }
  //
  pageChange(index: number) {
    this.currentTabIndex = index
    // if (index === 0) {
    //   this.homePageShow()
    // }
  }
  //
  // homePageShow() {
  //   const event: emitter.InnerEvent = {
  //     eventId: HOME_PAGE_SHOW_EVENT_ID,
  //     priority: emitter.EventPriority.LOW
  //   }
  //   emitter.emit(event)
  // }

  async getThemeData() {
    this.selectedIcons = await getTabbarSelectedIcons()
    this.normalIcons = await getTabbarNormalIcons()
    this.selectedColor = await getTabbarItemSelectedColor()
    this.normalColor = await getTabbarItemNormalColor()
  }

  async changeIndex(index: number) {
    this.currentIndex = index
    const allCities = await WeatherUtils.getAllCities()
    if (allCities.length > index) {
      const city = allCities[index]
      const condition = await WeatherUtils.getCondition(city.citycode!)
      const dailys = await WeatherUtils.getDailys(city.citycode!)
      const todayWeatherArray = dailys.dailyweathers?.filter(item => {
        dayjs.extend(isToday)
        return dayjs(item.current).isToday()
      })
      if (todayWeatherArray?.length || 0 > 0) {
        const todayWeatherData = todayWeatherArray![0]
        this.tabbarBgColor = await getTabbarBgColor(condition.cnwid!.toString(), todayWeatherData.sr || 0, todayWeatherData.ss || 0)
      }
    }
  }

  @Builder tabBuilder(title: string, targetIndex: number) {
    Column() {
      Image(this.currentTabIndex === targetIndex ? this.selectedIcons[targetIndex] : this.normalIcons[targetIndex])
        .size({ width: 25, height: 25 })
      Text(title)
        .fontColor(this.currentTabIndex === targetIndex ? this.selectedColor : this.normalColor)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.tabbarBgColor)
    .justifyContent(FlexAlign.Center)
    .padding({
      bottom: this.bottomRectHeight
    })
  }

  build() {
    Column() {
     Tabs({barPosition: BarPosition.End, index: $$this.currentTabIndex}) {
        TabContent() {
          NinetyDayPage()
        }
        .tabBar(this.tabBuilder('最美', 0))

       TabContent() {
         HomePage({changeIndexAction: (index: number) => {
           this.changeIndex(index)
         }})
       }
       .tabBar(this.tabBuilder('90天', 1))

       TabContent() {
          FindPage()
       }
       .tabBar(this.tabBuilder('发现', 2))

       TabContent() {
          MePage()
       }
       .tabBar(this.tabBuilder('我的', 3))
     }
     .barHeight(this.bottomRectHeight + 50)
     .edgeEffect(EdgeEffect.None)
     .animationDuration(0)
     .barBackgroundColor(Color.Black)
     // .onChange((index) => {
     //   this.pageChange(index)
     // })
    }
    .height('100%')
    .width('100%')
  }
}