import dayjs from 'dayjs'

// 获取时间戳 （毫秒）
export function getCurrentTimestamp() {
  return dayjs().valueOf()
}

// 获取时间戳 （秒）
export function getCurrentTimestampS() {
  return dayjs().unix()
}