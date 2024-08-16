import { HAS_GUIDE, TOP_NAVI_HEIGHT, PFUtils } from '@bw/common'
import { GuideModel } from '../../models/GuideModel'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct GuidePage {
  private topRectHeight = px2vp(AppStorage.get<number>(TOP_NAVI_HEIGHT) || 0)

  guideList: GuideModel[] = [
    {
      bgIcon: $r('app.media.guide_bg_v8'),
      title: $r('app.media.guide_title_0'),
      subtitle: '',
      icon: $r('app.media.guide_middle_0'),
      cloudIcon: ''
    },
    {
      bgIcon: $r('app.media.guide_bg_odd'),
      title: $r('app.media.guide_title_1'),
      subtitle: '多套精彩主题纷呈 天气变化更灵动',
      icon: $r('app.media.guide_middle_1'),
      cloudIcon: ''
    },
    {
      bgIcon: $r('app.media.guide_bg_even'),
      title: $r('app.media.guide_title_2'),
      subtitle: '降水、温度等10类图形 气象动态尽在眼底',
      icon: $r('app.media.guide_middle_2'),
      cloudIcon: $r('app.media.guide_cloud_2')
    },
    {
      bgIcon: $r('app.media.guide_bg_odd'),
      title: $r('app.media.guide_title_3'),
      subtitle: '即时告知天气变化 贴心关怀每一天',
      icon: $r('app.media.guide_middle_3'),
      cloudIcon: ''
    },
    {
      bgIcon: $r('app.media.guide_bg_even'),
      title: $r('app.media.guide_title_4'),
      subtitle: '丰富的内容 呈现详尽的天气信息',
      icon: $r('app.media.guide_middle_4'),
      cloudIcon: $r('app.media.guide_cloud_4')
    }
  ]

  // 跳过
  async toNext() {
    await PFUtils.put(HAS_GUIDE, true, getContext())

    router.replaceUrl({
      url: 'pages/splash/PrivacyPage'
    })
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd}) {
      Swiper() {
        ForEach(this.guideList, (item: GuideModel, index: number) => {
          Stack({ alignContent: Alignment.Top}) {
            Image(item.bgIcon)
              .width('100%')
              .height('100%')
            Stack({ alignContent: Alignment.Top}) {
              Column() {
                Image(item.title)
                  .width(index === 0 ? 222 : (index === 2 ? 193 : 166))
                  .height(index === 0 ? 32 : 27)
                  .objectFit(ImageFit.Contain)
                Text(item.subtitle)
                  .fontSize(15)
                  .fontColor('#818DA3')
                  .margin({
                    top: 21
                  })
                Image(item.icon)
                  .width(index === 0 ? 177 : (index === 2 ? 303 : (index === 3 ? 314 : (index === 4 ? 296 : 334))))
                  .height(index === 0 ? 303 : (index === 2 ? 399 : (index === 3 ? 428 : (index === 4 ? 419 : 420))))
                  .objectFit(ImageFit.Contain)
                  .margin({
                    top: index === 0 ? 65 : 33
                  })
              }
              .padding({
                top: this.topRectHeight + (index === 0 ? 91 : 76)
              })

              if (index === 2 || index === 4) {
                Image(item.cloudIcon)
                  .height(445)
                  .objectFit(ImageFit.Contain)
                  .margin({
                    left: 0,
                    right: 0,
                    top: index === 2 ? 210 : 180
                  })
              }
            }
          }
        })
      }
      .autoPlay(true)
      .interval(3000)
      .loop(false)
      .indicator(
        DotIndicator.dot()
          .itemWidth(9)
          .itemHeight(9)
          .color('#4EA1FF47')
          .selectedItemWidth(9)
          .selectedItemHeight(9)
          .selectedColor('#4EA1FF')
          .bottom(24)
      )
      .effectMode(EdgeEffect.None)

      Button('跳过')
        .fontSize(15)
        .fontColor(Color.White)
        .backgroundColor('#47454533')
        .height(26)
        .margin({
          top: this.topRectHeight + 14,
          right: 15
        })
        .onClick(() => {
          this.toNext()
        })
    }
    .width('100%')
    .height('100%')
  }
}