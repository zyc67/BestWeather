import { getCurrentDayType, getWeaThemeType } from '.';
import { ThemeModel } from '../../../../../entry/src/main/ets/models/ThemeListModel';
import { CURRENT_THEME_ID, DEFAULT_THEME_ID } from '../constant/Constant';
import { ThemeListDB } from '../db/ThemeListDB'
import { PFUtils } from './PFUtils';

async function getThemeList() {
  const themeList = await ThemeListDB.sharedManager().queryThemeList()
  return themeList
}

export async function getCurrentThemeId() {
  return await PFUtils.get(CURRENT_THEME_ID, DEFAULT_THEME_ID, getContext())
}

export async function getCurrentTheme() {
  const themeList = await getThemeList()
  const themeId = await getCurrentThemeId()
  const themes = themeList.filter(item => item.theme_id === themeId)
  return themes.length > 0 ? themes[0] : {} as ThemeModel
}

// tabbar背景颜色
export async function getTabbarBgColor(weaId: string, sunRise: number, sunSet: number) {
  const theme = await getCurrentTheme()
  let color = '#FFFFFF'
  if (theme) {
    if (theme.color_type === 1) { // 按天气区分tabbar颜色
      const colorWeatherString = theme.color_weather
      if (colorWeatherString) {
        const colorWeather: Record<string, Record<string, string>> = JSON.parse(colorWeatherString as string)
        const naviBar = colorWeather['navi_bar']
        const weaType = getWeaThemeType(weaId)
        switch (weaType) {
          case 1: {
            const dayType = getCurrentDayType(sunRise, sunSet)
            // 0:白天夜间图标； 1:白天白天图标； 2:夜间夜间图标
            if (dayType === 1) {
              if (naviBar['1']) {// 白天 晴
                color = naviBar['1']
              }
            } else {
              if (naviBar['9']) {// 晚上 晴
                color = naviBar['9']
              }
            }
          }
            break
          default: { // 2阴天 3雨天 4雪 5雾、霾 6沙尘暴 8多云
              if (naviBar[weaType.toString()]) {
                color = naviBar[weaType.toString()]
              }
            }
            break
        }
      }

    } else { // tabbar固定色
      const colorFixedString = theme.color_fixed
      if (colorFixedString) {
        const colorFixed: Record<string, Record<string, string>> = JSON.parse(colorFixedString as string)
        const naviBar = colorFixed['navi_bar']
        if (naviBar && naviBar['0']) {
          color = naviBar['0']
        }
      }
    }
  }
  return color
}

// 首页上拉背景颜色
export async function homeBgColor(weaId: string, sunRise: number, sunSet: number) {
  const theme = await getCurrentTheme()
  let color = '#FFFFFF'
  if (theme) {
    if (theme.color_type === 1) { // 按天气区分上拉背景颜色
      const colorWeatherString = theme.color_weather
      if (colorWeatherString) {
        const colorWeather: Record<string, Record<string, string>> = JSON.parse(colorWeatherString as string)
        const naviBar = colorWeather['second_screen']
        const weaType = getWeaThemeType(weaId)
        switch (weaType) {
          case 1: {
            const dayType = getCurrentDayType(sunRise, sunSet)
            // 0:白天夜间图标； 1:白天白天图标； 2:夜间夜间图标
            if (dayType === 1) {
              if (naviBar['1']) {// 白天 晴
                color = naviBar['1']
              }
            } else {
              if (naviBar['9']) {// 晚上 晴
                color = naviBar['9']
              }
            }
          }
            break
          default: { // 2阴天 3雨天 4雪 5雾、霾 6沙尘暴 8多云
            if (naviBar[weaType.toString()]) {
              color = naviBar[weaType.toString()]
            }
          }
            break
        }
      }

    } else { // tabbar固定色
      const colorFixedString = theme.color_fixed
      if (colorFixedString) {
        const colorFixed: Record<string, Record<string, string>> = JSON.parse(colorFixedString as string)
        const naviBar = colorFixed['second_screen']
        if (naviBar && naviBar['0']) {
          color = naviBar['0']
        }
      }
    }
  }
  return color
}

// 获取tabbar非选中icon
export async function getTabbarNormalIcons() {
  const theme = await getCurrentTheme()
  const iconNonSelectedString = theme.icon_non_selected
  let icons: string[] = []
  if (iconNonSelectedString) {
    const iconNonSelected: Record<string, string> = JSON.parse(iconNonSelectedString as string)
    const list = ['1', '2', '3', '4']
    list.forEach((item) => {
      if (iconNonSelected[item]) {
        icons.push(iconNonSelected[item])
      }
    })
  }
  return icons
}

// 获取tabbar选中icon
export async function getTabbarSelectedIcons() {
  const theme = await getCurrentTheme()
  const iconSelectedString = theme.icon_selected
  let icons: string[] = []
  if (iconSelectedString) {
    const iconNonSelected: Record<string, string> = JSON.parse(iconSelectedString as string)
    const list = ['1', '2', '3', '4']
    list.forEach((item) => {
      if (iconNonSelected[item]) {
        icons.push(iconNonSelected[item])
      }
    })
  }
  return icons
}

// 获取tabbar非选中状态颜色
export async function getTabbarItemNormalColor() {
  const theme = await getCurrentTheme()
  if (theme.layout === 3) {
    return '#575757'
  }
  return '#FFFFFF80'
}

// 获取tabbar选中状态颜色
export async function getTabbarItemSelectedColor() {
  return '#FFFFFF'
}