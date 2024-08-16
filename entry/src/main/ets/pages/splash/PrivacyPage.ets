import { TOP_NAVI_HEIGHT } from '@bw/common'

@Extend(Span) function normalStyle() {
  .fontSize(16)
  .fontColor('#2C2C2C')
}

@Extend(Span) function highLightStyle() {
  .fontSize(16)
  .fontColor('#00B8FE')
}

@Entry
@Component
struct PrivacyPage {
  private topRectHeight = px2vp(AppStorage.get<number>(TOP_NAVI_HEIGHT) || 0)

  build() {
    Stack() {
      Column() {
        Stack({alignContent: Alignment.Top}) {
          Image($r('app.media.ic_privacy_top_bg_new'))
            .width('100%')
            .height(246)
          Text('个人信息保护提示')
            .fontColor('#2C2C2C')
            .fontSize(29)
            .fontWeight(FontWeight.Bold)
            .margin({
              top: this.topRectHeight + 26
            })
          Scroll() {
            Text() {
              Span($r('app.string.privacy_desc_1'))
                .normalStyle()
              Span($r('app.string.privacy_label'))
                .highLightStyle()
                .onClick(() => {

                })
              Span('和')
                .normalStyle()
              Span($r('app.string.protocol_label'))
                .highLightStyle()
                .onClick(() => {

                })
              Span($r('app.string.privacy_desc_2'))
                .normalStyle()
            }
            .lineHeight(26)
          }
          .scrollBar(BarState.Off)
          .margin({
            top: this.topRectHeight + 75,
            left: 20,
            right: 20
          })
        }
      }
      .height('100%')
      .width('100%')
      .padding({
        bottom: 100
      })
    }
    .height('100%')
    .width('100%')
  }
}