
@Component
export struct NinetyDayPage {
  aboutToAppear(): void {
    console.log('90天')
  }
  build() {
    Column() {
      Row() {
        Text('90天')
      }
    }
  }
}