
@Component
export struct MePage {
  aboutToAppear(): void {
    console.log('我的')
  }
  build() {
    Column() {
      Row() {
        Text('我的')
      }
    }
  }
}