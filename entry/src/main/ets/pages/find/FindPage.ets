@Entry
@Component
export struct FindPage {
  aboutToAppear(): void {
    console.log('发现')
  }
  build() {
    Column() {
      Row() {
        Text('发现')
      }
    }
  }
}