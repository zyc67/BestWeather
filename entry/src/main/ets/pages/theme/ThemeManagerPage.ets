import { BaseNaviBar, getThemeList, getCurrentThemeId, getCurrentThemeType, getCurrentTheme, PFUtils, postEmitter,
  DEFAULT_THEME_TYPE, BOTTOM_AVOID_AREA_HEIGHT, CURRENT_THEME_ID, CURRENT_THEME_TYPE, CHANGE_THEME_EVENT_ID } from '@bw/common';
import { ThemeTopView } from '../../component/ThemeTopView'
import { ThemeListView } from '../../component/ThemeListView'
import { ThemeListTab } from '../../component/ThemeListTab';
import { ThemeModel } from '../../models/ThemeModel';

@Entry
@Component
struct ThemeManagerPage {
  private bottomRectHeight = AppStorage.get<number>(BOTTOM_AVOID_AREA_HEIGHT) || 0
  private listScroller: ListScroller = new ListScroller()
  @State offsetX: number = 0
  @State @Watch('switchThemeTab') currentIndex: number = 0
  @State themeList: ThemeModel[] = []
  @State usedThemeId: string = ''
  @State usedThemeType: number = DEFAULT_THEME_TYPE
  @State topImages: string[] = []

  aboutToAppear(): void {
    this.getThemeInfo()
    this.switchThemeTab()
  }

  themeUsed(themeId: string, themeType: number) {
    this.usedThemeId = themeId
    this.usedThemeType = themeType
    PFUtils.put(CURRENT_THEME_ID, themeId, getContext())
    PFUtils.put(CURRENT_THEME_TYPE, themeType, getContext())
    postEmitter(CHANGE_THEME_EVENT_ID)
  }

  async getThemeInfo() {
    this.themeList = await getThemeList()
    this.usedThemeId = await getCurrentThemeId() as string
    this.usedThemeType = await getCurrentThemeType() as number
  }

  async switchThemeTab() {
    const theme = await getCurrentTheme()
    this.topImages = (this.usedThemeType === 1 ? theme.detail_imgs?.split(';') : theme.detail_imgs_concise?.split(';')) || []
  }

  @Builder header() {
    ThemeListTab({offsetX: this.offsetX, action: (index: number) => {
      this.listScroller.scrollToIndex(index, true)
      this.currentIndex = index
    }})
      .width('100%')
      .height(56)
      .backgroundColor(Color.White)
  }

  build() {
    Column() {
      // Image($r('app.media.icon_theme_manage_header_bg'))
      //   .height(this.topRectHeight + 240)
      //   .width('100%')
      BaseNaviBar({title: '个性主题'})

      List() {
        ListItemGroup() {
          ThemeTopView({images: this.topImages, type: this.currentIndex === 0 ? 2 : 1})
            .height(263).width('100%').padding({ left: 10, right: 10 })
        }
        ListItemGroup({ header: this.header()}) {
          ListItem() {
            List({ scroller: this.listScroller}) {
              ListItem() {
                ThemeListView({
                  type: 2,
                  themeList: this.themeList,
                  usedThemeId: this.usedThemeId,
                  usedThemeType: this.usedThemeType,
                  themeUsedAction: (themeId: string, themeType: number) => {
                    this.themeUsed(themeId, themeType)
                  }})
              }
              .width('100%')

              ListItem() {
                ThemeListView({
                  type: 1,
                  themeList: this.themeList,
                  usedThemeId: this.usedThemeId,
                  usedThemeType: this.usedThemeType,
                  themeUsedAction: (themeId: string, themeType: number) => {
                    this.themeUsed(themeId, themeType)
                  }})
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
    .padding({
      bottom: this.bottomRectHeight
    })
    .height('100%')
    .width('100%')
  }
}