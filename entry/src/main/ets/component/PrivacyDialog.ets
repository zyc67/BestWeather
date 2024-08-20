@Preview
@CustomDialog
@Component
export struct PrivacyDialog {

  controller: CustomDialogController

  firstAction?: () => void
  secondAction?: () => void

  build() {
    Column() {
      Text('温馨提示')
        .fontColor('#2C2C2C')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      Text($r('app.string.disagree_desc'))
        .fontColor('#666666')
        .fontSize(15)
        .margin({
          top: 16
        })
        .lineHeight(24)

      Button('游客模式访问')
        .backgroundColor('#F0F2F5')
        .fontColor('#666666')
        .fontSize(15)
        .width('80%')
        .height(46)
        .borderRadius(22)
        .margin({
          top: 30
        })
        .onClick(() => {
          if (this.firstAction) {
            this.firstAction()
          }
          this.controller.close()
        })

      Button('退出最美天气App')
        .backgroundColor('#2895FF')
        .fontColor(Color.White)
        .fontSize(15)
        .width('80%')
        .height(46)
        .borderRadius(22)
        .margin({
          top: 20
        })
        .onClick(() => {
        if (this.secondAction) {
          this.secondAction()
        }
        this.controller.close()
      })

      Text('取消')
        .fontColor('#666666')
        .fontSize(15)
        .decoration({
          type: TextDecorationType.Underline,
          color: '#666666',
          // style: TextDecorationStyle.WAVY
        })
        .margin({
          top: 20
        })
        .onClick(() => {
          this.controller.close()
        })
    }
    .backgroundColor(Color.White)
    .borderRadius(10)
    .padding(20)
    .margin({
      left: 20,
      right: 20
    })
  }
}