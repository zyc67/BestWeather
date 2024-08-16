import { PFUtils, HAS_GUIDE } from '@bw/common';

@Entry
@Component
struct PrivacyPage {
  @State message: string = 'PrivacyPage';

  aboutToAppear(): void {
    PFUtils.get(HAS_GUIDE, false, getContext()).then((res) => {
      console.log(res?.toString());
    }).catch((e: Error) => {
      console.log(e.message);
    })
  }

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('PrivacyPageHelloWorld')
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