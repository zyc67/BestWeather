import { TOP_NAVI_HEIGHT, RouterUtils, PRIVACY_URL, PROTOCOL_URL, BOTTOM_AVOID_AREA_HEIGHT, PFUtils, HAS_PRIVACY } from '@bw/common'
import { PrivacyModel } from '../../models/PrivacyModel'
import { PrivacyItem } from '../../component/PrivacyItem'
import { PrivacyDialog } from '../../component/PrivacyDialog'
import { common } from '@kit.AbilityKit'

@Extend(Span) function normalStyle() {
  .fontSize(16)
  .fontColor('#2C2C2C')
}

@Extend(Span) function highLightStyle() {
  .fontSize(16)
  .fontColor('#00B8FE')
}

@Extend(Button) function privacyStyle(backgroundColor: string, fontColor: string) {
  .width(150)
  .height(46)
  .borderRadius(20)
  .backgroundColor(backgroundColor)
  .fontSize(16)
  .fontColor(fontColor)
}

class Obj {
  title: string = ''
  url: string = ''
}

@Entry
@Component
struct PrivacyPage {
  dialogController: CustomDialogController = new CustomDialogController({
    builder: PrivacyDialog({
      firstAction: () => {
        // TODO: 游客模式访问
      },
      secondAction: () => {
        // 退出最美天气App
        const context: common.UIAbilityContext = getContext() as common.UIAbilityContext
        context.terminateSelf()
        // 调用terminateSelf方法后在module.json5 ability中设置"removeMissionAfterTerminate": true后会将app从后台任务列表中移除
      }
    }),
    customStyle: true
  })
  private topRectHeight = px2vp(AppStorage.get<number>(TOP_NAVI_HEIGHT) || 0)
  private bottomRectHeight = px2vp(AppStorage.get<number>(BOTTOM_AVOID_AREA_HEIGHT) || 0)
  permissions: PrivacyModel[] = [
    {
      icon: $r('app.media.img_location_info'),
      title: '获取高精度天气数据及短临预报服务',
      subtitle: '需要申请位置信息'
    },
    {
      icon: $r('app.media.img_storage'),
      title: '存储背景图片、意见反馈',
      subtitle: '需要申请储存访问权限'
    },
    {
      icon: $r('app.media.img_info'),
      title: '意见反馈、语音播报和AI识别天气',
      subtitle: '需要申请设备信息'
    },
    {
      icon: $r('app.media.img_photo'),
      title: 'AI识别天气',
      subtitle: '需要申请相机权限'
    },
    {
      icon: $r('app.media.img_push'),
      title: '推送天气预报及预警信息',
      subtitle: '需要申请通知权限'
    },
    {
      icon: $r('app.media.img_advert'),
      title: '广告运营及反作弊检测',
      subtitle: '需要申请读取应用列表权限'
    },
  ]

  @State name: string = ''
  @State name1: string = ''
  @State name2: string = ''

  agree() {
    PFUtils.put(HAS_PRIVACY, true, getContext())
    RouterUtils.replaceUrl('pages/city/CityAddPage')
  }

  disAgree() {
    this.dialogController.open()
  }

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
            Column() {
              Text() {
                Span($r('app.string.privacy_desc_1'))
                  .normalStyle()
                Span($r('app.string.privacy_label'))
                  .highLightStyle()
                  .onClick(() => {
                    const params: Obj = {
                      title: '隐私政策',
                      url: PRIVACY_URL
                    }
                    RouterUtils.pushUrl('pages/webview/BaseWebPage', params)
                  })
                Span('和')
                  .normalStyle()
                Span($r('app.string.protocol_label'))
                  .highLightStyle()
                  .onClick(() => {
                    const params: Obj = {
                      title: '用户协议',
                      url: PROTOCOL_URL
                    }
                    RouterUtils.pushUrl('pages/webview/BaseWebPage', params)
                  })
                Span($r('app.string.privacy_desc_2'))
                  .normalStyle()
              }
              .lineHeight(26)
              List() {
                ForEach(this.permissions, (item: PrivacyModel) => {
                  PrivacyItem({item})
                })
              }
            }
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
        bottom: this.bottomRectHeight + 80
      })
      Row() {
        Button('不同意')
          .privacyStyle('#EDF0F5', '#808080')
          .onClick(() => {
            this.disAgree()
          })
        Button('同意')
          .privacyStyle('#2895FF', '#FFFFFF')
          .fontWeight(FontWeight.Bold)
          .margin({
            left: 30
          })
          .onClick(() => {
            this.agree()
          })
      }
      .justifyContent(FlexAlign.Center)
      .position({
        top: '100%'
      })
      .translate({
        y: -this.bottomRectHeight - 60
      })
      .width('100%')
      .alignItems(VerticalAlign.Center)
    }
    .height('100%')
    .width('100%')
  }
}