export class UserResp {
  data: User = new User()
  resultCode: number = 0
  resultInfo: string = ''
  serverTime: number = 0
}

export class User {
  userId: string = ''
  headUrl: string = ''
  job: string = ''
  vip: string = ''
  phone: string = ''
  sex: string = ''
  prizePhone: string = ''
  tags: string = ''
  binds: string[] = []
  source: string = ''
  createTime: number = 0
  birthday: string = ''
  city: string = ''
  isNew: string = ''
  nickname: string = ''
  prizeAddress: string = ''
  prizeName: string = ''
  sign: string = ''
}