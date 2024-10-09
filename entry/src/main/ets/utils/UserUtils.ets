import { PFUtils, CURRENT_USER } from '@bw/common';
import { User } from '../models/User';

export class UserUtils {
  static async getCurrentUser(context: Context) {
    const userString = await PFUtils.get(CURRENT_USER, JSON.stringify(user), context) as string
    return JSON.parse(userString) as User
  }

  static async getCurrentUserId(context: Context) {
    return (await UserUtils.getCurrentUser(context)).userId
  }
}

const user: User = {
  'headUrl': '',
  'job': '',
  'vip': '1',
  'phone': '17612135216',
  'sex': '',
  'prizePhone': '',
  'tags': '',
  'binds': ['9','10'],
  'source': '9',
  'userId': '236587504',
  'createTime': 1698659130881,
  'birthday': '',
  'city': '刚刚好',
  'isNew': '0',
  'nickname': '176****5216',
  'prizeAddress': '',
  'prizeName': '',
  'sign': ''
}