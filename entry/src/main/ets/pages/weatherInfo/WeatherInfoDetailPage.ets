import { BaseNaviBar, HttpUtils, SCREEN_WIDTH } from '@bw/common'
import { router } from '@kit.ArkUI'
import { WeatherInfoDetailResp } from '../../models/WeatherInfoModel'
import { webview } from '@kit.ArkWeb'

@Entry
@Component
struct WeatherInfoDetailPage {
  private webController: webview.WebviewController = new webview.WebviewController()
  @State title: string = ''
  @State publishTime: string = ''
  @State content: string = ''

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, number>
    const ID = params['ID'] as number
    this.getWeatherInfoDetailData(ID)
  }

  async getWeatherInfoDetailData(ID: number) {
    const res = await HttpUtils.getWeatherInfoDetailData<WeatherInfoDetailResp>(ID)
    if (res.infoFlow) {
      const model = res.infoFlow
      this.title = model.title
      if (model.content) {
        const w = AppStorage.get<string>(SCREEN_WIDTH)
        const str = `<!DOCTYPE html><html lang="zh-CN"><head><meta name="viewport" content="width=device-width"></head><body><head><style>img{max-width:${Number(w) - 32}vp !important;height:auto !important}</style></head>${model.content}</body>`
        // 加载HTML格式的文本数据
        this.webController.loadData(str, 'text/html', 'UTF-8')
      }
    }
  }

  build() {
    Column() {
      BaseNaviBar({title: '天气资讯'})
      Column() {
        Text(this.title)
          .fontColor($r('app.color.color_333'))
          .fontSize(23)
          .fontWeight(FontWeight.Medium)
        Text(this.publishTime)
          .fontColor($r('app.color.color_999'))
          .fontSize(15)
          .margin({
            top: 16
          })
        Web({src:'', controller: this.webController})
          .domStorageAccess(true)
          .layoutWeight(1)
          .verticalScrollBarAccess(false)
      }
      .width('100%')
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .padding({
        left: 16,
        right: 16
      })
    }
    .height('100%')
    .width('100%')
  }
}

// NSDictionary *options = @{NSDocumentTypeDocumentAttribute :NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
// NSString *contentStr = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;height:auto !important}</style></head>%@", wiScreenWidth - 28, model.content];
// NSData *data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
// NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
// [attStr addAttributes:@{NSFontAttributeName: [UIFont bw_fontOfSize:14 weight:UIFontWeightLight]} range:NSMakeRange(0, attStr.length)];
// [attStr addAttributes:@{NSForegroundColorAttributeName: WIColorWithHex(@"#333333")} range:NSMakeRange(0, attStr.length)];
// self.contentLabel.attributedText = attStr;
