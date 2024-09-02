import { HttpUtils, RouterUtils, PFUtils, CURRENT_THEME_ID, DEFAULT_THEME_ID, TOP_NAVI_HEIGHT } from '@bw/common';
import { CommonResp, ThemeModel } from '../../models/ThemeModel';
import { Banner, BannerOptions, AnimatedEnum, SwiperIndicator, BannerMargin } from '@ohos/banner'

@Entry
@Component
struct SelectThemePage {
  private topRectHeight = px2vp(AppStorage.get<number>(TOP_NAVI_HEIGHT) || 0)
  @State currentPos: number = 0 // 当前选中的index
  private swiperController: SwiperController = new SwiperController()
  @State themeList: ThemeModel[] = []
  @State autoPlay?: boolean = false // 自定播放
  @State indicator?: SwiperIndicator = { bool: false } // 系统的指示器配置 不启用设置false
  @State loop?: boolean = true // 是否开启循环
  @State vertical?: boolean = false // 是否纵向滑动
  @State bannerMargin: BannerMargin = { left: 40, right: 40 }; // 水平是左右的margin,垂直为上下的margin
  @State animatedEnum?: AnimatedEnum = AnimatedEnum.ZoomOutPage // 魅族 动画效果
  @State curve?: Curve = Curve.Linear // 动画曲率
  @State bannerOptions: BannerOptions = {
    swiperController: this.swiperController,
    autoPlay: this.autoPlay, // 自定播放
    indicator: this.indicator, // 系统的指示器配置 不启用设置false
    loop: this.loop, // 是否开启循环
    vertical: this.vertical, // 是否纵向滑动
    curve: Curve.Linear, // 动画曲率

    bannerMargin: { left: this.bannerMargin.left, right: this.bannerMargin.right }, // 水平是左右的margin,垂直为上下的margin
    animatedEnum: AnimatedEnum.ZoomOutPage, // 动画效果

    onChange: (index: number) => {
      // console.log('dodo BannerConfigPage onChange 当前页面index=' + index)
      this.currentPos = index;
    },

    // onGestureSwipe: (index: number, extraInfo: SwiperAnimationEvent) => {
    //   console.log('dodo BannerConfigPage onGestureSwipe 当前页面index=' + index + ' extraInfo=' +
    //   JSON.stringify(extraInfo))
    // },
    //
    // onAnimationStart: (index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
    //   console.log('dodo BannerConfigPage onAnimationStart 当前页面index=' + index + '   targetIndex=' + targetIndex +
    //     ' extraInfo=' + JSON.stringify(extraInfo))
    // },
    //
    // onAnimationEnd: (index: number, extraInfo: SwiperAnimationEvent) => {
    //   console.log('dodo BannerConfigPage onAnimationStart 当前页面index=' + index + ' extraInfo=' +
    //   JSON.stringify(extraInfo))
    // }
  }

  async aboutToAppear() {
    const res = await HttpUtils.getThemeList() as CommonResp
    const themeList = JSON.parse(res.data) as ThemeModel[]
    this.themeList = themeList.filter((item) => item.level != 1 && item.level != 2)
  }

  // 跳过
  skip() {
    RouterUtils.replaceUrl('pages/main/MainPage')
    PFUtils.put(CURRENT_THEME_ID, DEFAULT_THEME_ID, getContext())
  }

  // 确定
  confirm() {
    const theme = this.themeList[this.currentPos]
    PFUtils.put(CURRENT_THEME_ID, theme.theme_id || DEFAULT_THEME_ID, getContext())
    RouterUtils.replaceUrl('pages/main/MainPage')
  }

  @Builder
  bannerContent(index: number) {
    Stack({ alignContent: Alignment.TopStart }) {
      Image(this.themeList[index].cover)
        .objectFit(ImageFit.Cover)
        .width('100%')
        .height('100%')
        .backgroundColor(Color.Gray)
        .borderColor(this.currentPos === index ? '#FFDC6A' : '#FFFFFF')
        .borderWidth(3)
        .borderRadius(25)
      Image(this.themeList[index].clean_install_layout === 1 ? $r('app.media.icon_theme_classical') : $r('app.media.icon_theme_concise'))
        .width(80)
        .height(80)
      Text(this.themeList[index].theme_name)
        .width('100%')
        .height(40)
        .textAlign(TextAlign.Center)
        .backgroundColor('#3A3A3AC7')
        .fontColor('#FFFFFF')
        .fontSize(15)
        .position({
          top: '100%'
        })
        .translate({
          y: -40
        })
        .borderRadius({
          bottomLeft: 25,
          bottomRight: 25
        })
        .borderColor(this.currentPos === index ? '#FFDC6A' : '#FFFFFF')
        .borderWidth({
          top: 0,
          bottom: 3,
          left: 3,
          right: 3
        })
    }
    .width('100%')
    .height('100%')
  }

  build() {

    Column() {
      Row() {
        Text('跳过')
          .fontColor('#3A3D57')
          .fontSize(12)
          .backgroundColor('#F3F3F3')
          .padding({
            left: 6,
            right: 6
          })
          .borderRadius(10)
          .height(20)
          .onClick(() => {
            this.skip()
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.End)
      .margin({
        right: 20
      })

      Text('挑选一套您喜欢的背景')
        .fontColor('#666666')
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .margin({
          top: 20
        })

      Banner({
        bannerOptions: this.bannerOptions,
        currentPosition: this.currentPos,
        data: this.themeList,
        bannerContent: (item, index) => {
          this.bannerContent(index)
        }
      })
        .width('100%')
        .height(388)
        .margin({
          top: 44
        })

      Button('确定')
        .fontColor('#FFFFFF')
        .fontSize(16)
        .width(286)
        .height(44)
        .backgroundColor('#5CAFFC')
        .margin(40)
        .onClick(() => {
          this.confirm()
        })
    }
    .width('100%')
    .height('100%')
    .padding({
      top: this.topRectHeight + 62
    })
  }
}