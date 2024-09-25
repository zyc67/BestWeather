import { COLOR_MODE } from "../constant";

export class ColorModeUtils {
  static setColorMode(colorMode: string) {
    AppStorage.setOrCreate(COLOR_MODE, colorMode)
  }

  static getColorMode(): string {
    return AppStorage.get<string>(COLOR_MODE) || '1'
  }

  // 应用默认配置为跟随系统切换深浅色模式，如不希望应用跟随系统深浅色模式变化，可主动设置应用的深浅色风格。设置后，应用的深浅色模式固定，不会随系统改变。
  static setColorModeManual(context: Context, colorMode: string) {
    context.getApplicationContext().setColorMode(Number(colorMode))
  }
}