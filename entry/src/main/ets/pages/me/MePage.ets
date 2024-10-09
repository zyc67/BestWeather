import { CURRENT_USER } from "@bw/common/src/main/ets/constant/Constant"
import { User } from "../../models/User"

@Component
export struct MePage {
  @StorageProp(CURRENT_USER) userInfo: User = new User()

  aboutToAppear(): void {
    console.log('我的')
  }
  build() {
    Column() {
      Row() {
        Text(JSON.stringify(this.userInfo))
      }
    }
  }
}