import { getTabbarSelectedIcons, getTabbarNormalIcons, getTabbarItemSelectedColor, getTabbarItemNormalColor, BOTTOM_AVOID_AREA_HEIGHT, HOME_PAGE_SHOW_EVENT_ID } from '@bw/common'
import { HomePage } from '../home/HomePage'
import { NinetyDayPage } from '../ninetyDay/NinetyDayPage'
import { FindPage } from '../find/FindPage'
import { MePage } from '../me/MePage'
import { emitter } from '@kit.BasicServicesKit'

@Entry
@Component
struct MainPage {
  private bottomRectHeight = px2vp(AppStorage.get<number>(BOTTOM_AVOID_AREA_HEIGHT) || 0)

  @State currentIndex: number = 0
  @State selectedIcons: string[] = []
  @State normalIcons: string[] = []
  @State selectedColor: string = '#FFFFFF'
  @State normalColor: string = '#FFFFFF'

  aboutToAppear(): void {
    this.getThemeData()
  }

  onPageShow(): void {
    this.homePageShow()
  }

  pageChange(index: number) {
    this.currentIndex = index
    if (index === 0) {
      this.homePageShow()
    }
  }

  homePageShow() {
    const event: emitter.InnerEvent = {
      eventId: HOME_PAGE_SHOW_EVENT_ID,
      priority: emitter.EventPriority.LOW
    }
    emitter.emit(event)
  }

  async getThemeData() {
    this.selectedIcons = await getTabbarSelectedIcons()
    this.normalIcons = await getTabbarNormalIcons()
    this.selectedColor = await getTabbarItemSelectedColor()
    this.normalColor = await getTabbarItemNormalColor()
  }

  @Builder tabBuilder(title: string, targetIndex: number) {
    Column() {
      Image(this.currentIndex === targetIndex ? this.selectedIcons[targetIndex] : this.normalIcons[targetIndex])
        .size({ width: 25, height: 25 })
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? this.selectedColor : this.normalColor)
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .padding({
      bottom: this.bottomRectHeight
    })
  }

  build() {
    Column() {
     Tabs({barPosition: BarPosition.End}) {
        TabContent() {
          HomePage()
        }
        .tabBar(this.tabBuilder('最美', 0))

       TabContent() {
          NinetyDayPage()
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
     .onChange((index) => {
       this.pageChange(index)
     })
    }
    .height('100%')
    .width('100%')
  }
}