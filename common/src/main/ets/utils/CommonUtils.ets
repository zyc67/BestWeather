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

export function getAreaName(areaCode: string) {
  switch (areaCode) {
    case 'HB':
      return '华北地区'
    case 'HD':
      return '华东地区'
    case 'HN':
      return '华南地区'
    case 'HZ':
      return '华中地区'
    case 'XN':
      return '西南地区'
    case 'XB':
      return '西北地区'
    case 'DB':
      return '东北地区'
    default:
      return ''
  }
}