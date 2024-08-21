import { HttpUtils } from '@bw/common';

@Entry
@Component
struct CityAddPage {
  @State message: string = 'Hello World';

  async aboutToAppear() {
    const res = await HttpUtils.hotCity<string>()
    console.log(res)
  }

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('CityAddPageHelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
    }
    .height('100%')
    .width('100%')
  }
}