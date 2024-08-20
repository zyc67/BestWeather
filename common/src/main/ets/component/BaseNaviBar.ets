import { RouterUtils } from '../utils'

@Component
export struct BaseNaviBar {

  @BuilderParam leftBuilder: () => void
  @BuilderParam titleBuilder: () => void
  @BuilderParam rightBuilder: () => void

  leftTitle: string = ''
  title: string = ''
  rightTitle: string = ''

  leftIcon: string | Resource = ''
  rightIcon: string | Resource = ''

  build() {
    Row() {
      // 左边
      if (this.leftBuilder) {
        Row() {
          this.leftBuilder()
        }
        .width('20%')
      } else if (this.leftTitle) {
        Text(this.leftTitle)
          .fontColor('#2C2C2C')
          .fontSize(16)
          .width('20%')
      } else {
        Row() {
          Image(this.leftIcon ? this.leftIcon : $r('app.media.icon_left_arrow'))
            .height(24)
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              RouterUtils.back()
            })
        }
        .width('20%')
        .justifyContent(FlexAlign.Start)
        // .backgroundColor(Color.Yellow)
      }

      // 中间
      if (this.titleBuilder) {
        Row() {
          this.titleBuilder()
        }
        .justifyContent(FlexAlign.Center)
        .width('60%')
      } else {
        Text(this.title)
          .fontColor('#2C2C2C')
          .fontSize(24)
          .width('60%')
          .textAlign(TextAlign.Center)
          // .backgroundColor(Color.Red)
          .maxLines(1)
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })
      }

      // 右边
      if (this.rightBuilder) {
        Row() {
          this.rightBuilder()
        }
        .justifyContent(FlexAlign.End)
        .width('20%')
        // .backgroundColor(Color.Yellow)
      } else if (this.rightTitle) {
        Row() {
          Text(this.rightTitle)
          .fontColor('#2C2C2C')
          .fontSize(16)
        }
        .width('20%')
        .height(24)
        .justifyContent(FlexAlign.End)
        // .backgroundColor(Color.Yellow)
      } else if (this.rightIcon) {
        Row() {
          Image(this.rightIcon)
            .height(24)
            .objectFit(ImageFit.Contain)
        }
        .width('20%')
        .height(24)
        .justifyContent(FlexAlign.End)
        // .backgroundColor(Color.Yellow)
      } else {
        Blank()
          .width('20%')
          // .backgroundColor(Color.Yellow)
      }
    }
    .padding({
      left: 16,
      right: 16
    })
    .width('100%')
    .height(50)
  }
}

// import { BaseNaviBar, TOP_NAVI_HEIGHT } from '@bw/common';
//
// @Entry
// @Component
// struct BaseNaviBarTestDemo {
//   private topRectHeight = px2vp(AppStorage.get<number>(TOP_NAVI_HEIGHT) || 0)
//
//   @Builder leftView() {
//     Text('嗯嗯嗯')
//   }
//
//   @Builder titleView() {
//     Row() {
//       Text('多大郭德纲点击更多几个点广东佛山申达股份十多个')
//         .maxLines(1)
//         .textOverflow({
//           overflow: TextOverflow.Ellipsis
//         })
//         .layoutWeight(3)
//       Image($r('app.media.app_icon'))
//         .width(20)
//         .height(20)
//         .objectFit(ImageFit.Contain)
//         .layoutWeight(1)
//     }
//   }
//
//   @Builder rightView() {
//     Image($r('app.media.app_icon'))
//       .width(40)
//       .height(40)
//   }
//
//
//   build() {
//     Column({space: 20}) {
//       BaseNaviBar({title: '关于我们关于我们关于我们关于我们关于我们关于我们关于我们关于我们关于我们关于我们关于我们关于我们关于我们关于我们关于我们关于我们'})
//       BaseNaviBar({title: '关于我们', leftIcon: $r('app.media.app_icon')})
//       BaseNaviBar({title: '关于我们', leftIcon: $r('app.media.app_icon'), rightTitle: '哈哈哈'})
//       BaseNaviBar({title: '关于我们', leftIcon: $r('app.media.app_icon'), rightIcon: $r('app.media.app_icon')})
//       BaseNaviBar()
//       BaseNaviBar({leftBuilder: this.leftView})
//       BaseNaviBar({titleBuilder: this.titleView})
//       BaseNaviBar({rightBuilder: this.rightView})
//       BaseNaviBar({leftBuilder: this.leftView, titleBuilder: this.titleView, rightBuilder: this.rightView})
//
//     }
//     .padding({
//       top: this.topRectHeight
//     })
//     .height('100%')
//     .width('100%')
//   }
// }