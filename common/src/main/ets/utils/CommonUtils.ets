import { UUID_STRING } from '../constant/Constant'
import { PFUtils } from './PFUtils'
import { util } from '@kit.ArkTS'

export function isEmpty(value?: string) {
  return value === null || value === undefined || value.length === 0
}

export async function getUUID() {
  let uuid: string = ''
  uuid = await PFUtils.get(UUID_STRING, "", getContext()) as string
  if (!uuid) {
    uuid = util.generateRandomUUID()
    PFUtils.put(UUID_STRING, uuid, getContext())
  }
  return uuid
}