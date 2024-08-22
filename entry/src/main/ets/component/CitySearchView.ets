@Preview
@Component
export struct CitySearchView {
  build() {
    Row() {
      Image($r('app.media.ic_city_search'))
        .width(18)
        .height(18)
      TextInput({placeholder: '搜索城市或者景点'})
        .backgroundColor(Color.Transparent)
    }
    .width('100%')
    .height(47)
    .borderRadius(4)
    .backgroundColor(Color.White)
    .padding({
      left: 16,
      right: 16
    })
  }
}