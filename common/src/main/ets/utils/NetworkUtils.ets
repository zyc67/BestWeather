import { connection } from '@kit.NetworkKit'
import { promptAction } from '@kit.ArkUI'

export function isNetwork(show: boolean = true) {
  if (connection.hasDefaultNetSync()) { // ohos.permission.GET_NETWORK_INFO
    return true
  }
  if (show) {
    promptAction.showToast({message: '当前无网络，请稍后尝试'})
  }
  return false
}