import { TOP_NAVI_HEIGHT, SCREEN_WIDTH } from '@bw/common'


@Component
export struct ThemeTopView {
   @Prop type: number
   @Prop images: string[]
   build() {
     Column() {
       Banner({arr: this.images, centerIndex: Math.floor(this.images.length / 2)})
     }
   }
}

@Component
struct Banner {
  itemWidth: number = 126
  private scroller: Scroller = new Scroller();
  @Prop arr: string[] = []
  @Prop centerIndex: number
  @State @Watch('getOffset') mDevW: number = 0
  @State scrollX: number = 0
  @State xOffset: number = 0

  getOffset() {
    this.xOffset = this.centerIndex * this.itemWidth - (this.mDevW - this.itemWidth) / 2
    this.scroller.scrollBy(this.xOffset, 0)
  }

  getTranslateX(item: string) {
    let index = this.arr.indexOf(item)
    //此处需要减去左右间距,保持居中
    return this.itemWidth * 0.55 * (this.centerIndex - index) + this.scrollX / 2 - 10
  }

  getZIndex(item: string) {
    let index = this.arr.indexOf(item)
    if (this.centerIndex >= index) {
      return index
    }
    return index - (index - this.centerIndex) * 2
  }

  getScale(item: string) {
    let rate = 0
    if (Math.abs(this.scrollX) >= this.itemWidth) {
      rate = 1
    } else {
      rate = 1 - Math.abs(this.scrollX) / this.itemWidth
    }
    let index = this.arr.indexOf(item)
    if (this.centerIndex > index) {
      if (this.scrollX > 0) {
        return index * 0.1 + (1 - this.centerIndex / 10) - (1 - rate) * 0.1
      } else {
        return index * 0.1 + (1 - this.centerIndex / 10) + (1 - rate) * 0.1
      }
    } else if (this.centerIndex == index) {
      return 1 - (1 - rate) * 0.1
    }
    if (this.scrollX > 0) {
      return (index - (index - this.centerIndex) * 2) * 0.1 + (1 - this.centerIndex / 10) + (1 - rate) * 0.1
    } else {
      return (index - (index - this.centerIndex) * 2) * 0.1 + (1 - this.centerIndex / 10) - (1 - rate) * 0.1
    }
  }

  build() {
    Scroll(this.scroller) {
      Row() {
        ForEach(this.arr, (item: string) => {
          Stack() {
            Image("")
              .width('100%')
              .height('100%')
              .objectFit(ImageFit.Contain)
              .backgroundColor('#E5E5E5')
              .borderRadius(20)
              .shadow({
                radius: 20,
                offsetY: 1,
                offsetX: 1,
                color: "#99000000"
              })
            Image(item)
              .width('100%')
              .height('100%')
              .objectFit(ImageFit.Fill)
          }
          .width(this.itemWidth)
          .height('100%')
          .padding({ bottom: 4 })
          .translate({ x: this.getTranslateX(item), y: 0 })
          .zIndex(this.getZIndex(item))
          .scale({ x: this.getScale(item), y: this.getScale(item) })
        }, (item: number) => item.toString())
      }
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
    .scrollable(ScrollDirection.Horizontal)
    .onWillScroll(() => {
      this.scrollX = this.scroller.currentOffset().xOffset - this.xOffset
      if (Math.abs(this.scrollX) > this.itemWidth / 2) {
        animateTo({ curve: Curve.EaseOut, duration: 100 }, () => {
          if (this.scrollX > 0) {
            let tmp = this.arr.splice(0, 1) as string[]
            this.arr.push(tmp[0])
          } else {
            let tmp = this.arr.pop() as string
            this.arr.unshift(tmp)
          }
          this.scroller.scrollTo({
            xOffset: this.xOffset,
            yOffset: 0
          })
        })
      }
    })
    .onScrollStop(() => {
      this.scroller.scrollTo({
        xOffset: this.xOffset,
        yOffset: 0,
        animation: {
          duration: 100,
          curve: Curve.EaseOut
        }
      })
    })
    .onAppear(() => {
      this.getOffset()
    })
  }
}

// @Component
// export struct ThemeTopView {
//   private topRectHeight = px2vp(AppStorage.get<number>(TOP_NAVI_HEIGHT) || 0)
//   private DISPLAY_COUNT: number = 5
//   private MIN_SCALE: number = 0.8
//   private OPACTIY_LIST: number[] = [0.4, 0.8, 1.0, 0.8, 0.4]
//   private SCALE_LIST: number[] = [0.8, 0.9, 1.0, 0.9, 0.8]
//   private TRANSLATE_LIST: number[] = [50, 20, 0, -20, -50]
//   private ZINDEX_LIST: number[] = [1, 2, 3, 2, 1]
//
//   @Prop type: number
//   @Prop images: string[]
//
//   @State opacityList: number[] = this.OPACTIY_LIST
//   @State scaleList: number[] = this.SCALE_LIST
//   @State translateList: number[] = this.TRANSLATE_LIST
//   @State zIndexList: number[] = this.ZINDEX_LIST
//
//   build() {
//     Column() {
//       Swiper() {
//         ForEach(this.images, (url: string, index: number) => {
//           Image(url)
//             .objectFit(ImageFit.Cover)
//             .borderRadius(10)
//             .opacity(this.opacityList[index])
//             .scale({ x: this.scaleList[index], y: this.scaleList[index] })
//             .translate({ x: this.translateList[index] })
//             .zIndex(this.zIndexList[index])
//         })
//       }
//       .displayCount(this.DISPLAY_COUNT)
//       .width('100%')
//       .height(200)
//       .indicator(false)
//       .customContentTransition({
//         // 页面移除视窗时超时1000ms下渲染树
//         timeout: 1000,
//         // 对视窗内所有页面逐帧回调transition，在回调中修改opacity、scale、translate、zIndex等属性值，实现自定义动画
//         transition: (proxy: SwiperContentTransitionProxy) => {
//           console.log(`11111111_selectedIndex=${proxy.selectedIndex}_index=${proxy.index}_position=${proxy.position}_mainAxisLength=${proxy.mainAxisLength}`)
//           // if (proxy.position <= proxy.index % this.DISPLAY_COUNT || proxy.position >= this.DISPLAY_COUNT + proxy.index % this.DISPLAY_COUNT) {
//           //   // 同组页面往左滑或往右完全滑出视窗外时，重置属性值
//           //   this.opacityList[proxy.index] = 1.0
//           //   this.scaleList[proxy.index] = 1.0
//           //   this.translateList[proxy.index] = 0.0
//           //   this.zIndexList[proxy.index] = 0
//           // } else {
//           //   // 同组页面往右滑且未滑出视窗外时，对同组中左右两个页面，逐帧根据position修改属性值，实现两个页面往Swiper中间靠拢并透明缩放的自定义切换动画
//           //   if (proxy.index % this.DISPLAY_COUNT === 0) {
//           //     this.opacityList[proxy.index] = 1 - proxy.position / this.DISPLAY_COUNT
//           //     this.scaleList[proxy.index] = this.MIN_SCALE + (1 - this.MIN_SCALE) * (1 - proxy.position / this.DISPLAY_COUNT)
//           //     this.translateList[proxy.index] = - proxy.position * proxy.mainAxisLength + (1 - this.scaleList[proxy.index]) * proxy.mainAxisLength / 2.0
//           //   } else {
//           //     this.opacityList[proxy.index] = 1 - (proxy.position - 1) / this.DISPLAY_COUNT
//           //     this.scaleList[proxy.index] = this.MIN_SCALE + (1 - this.MIN_SCALE) * (1 - (proxy.position - 1) / this.DISPLAY_COUNT)
//           //     this.translateList[proxy.index] = - (proxy.position - 1) * proxy.mainAxisLength - (1 - this.scaleList[proxy.index]) * proxy.mainAxisLength / 2.0
//           //   }
//           //   this.zIndexList[proxy.index] = -1
//         }
//       })
//     }
//     .width('100%')
//     .height(this.topRectHeight + 240)
//   }
// }
