import { AbilityConstant, bundleManager, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { AlertDB, AqiDB, CityDB, ConditionDB, DailysDB, DescDB, HoursDB, LifeIndexDB, PFUtils, RadarDB, ThemeListDB, ThemeBgDB,
  BOTTOM_AVOID_AREA_HEIGHT, HAS_GUIDE, TOP_NAVI_HEIGHT, HAS_PRIVACY, SCREEN_WIDTH, SCREEN_HEIGHT, WeatherUtils, ColorModeUtils } from '@bw/common';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    let flag = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_SIGNATURE_INFO;
    let bundleInfo = bundleManager.getBundleInfoForSelfSync(flag)
    let appId = bundleInfo.signatureInfo.appId;
    AppStorage.setOrCreate('aMap_AppId', appId);

    // 应用深浅色适配
    const colorMode: ConfigurationConstant.ColorMode = this.context.config.colorMode || ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT
    ColorModeUtils.setColorMode(colorMode.toString())
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability

    await this.setupDB()

    const hasGuide = await PFUtils.get(HAS_GUIDE, false, this.context)
    const hasPrivacy = await PFUtils.get(HAS_PRIVACY, false, this.context)
    let page = 'pages/main/MainPage'
    if (!hasGuide) {
      page = 'pages/splash/GuidePage'
    } else if (!hasPrivacy) {
      page = 'pages/splash/PrivacyPage'
    } else if ((await WeatherUtils.getAllCities()).length === 0) {
      page = 'pages/city/CityAddPage'
    }
    // page = 'pages/theme/ThemeManagerPage'
    windowStage.loadContent(page, (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      let windowClass: window.Window = windowStage.getMainWindowSync() // 获取应用主窗口
      // 设置窗口全屏
      windowClass.setWindowLayoutFullScreen(true).then(() => {
        console.info('Succeeded in setting the window layout to full-screen mode.')
      }).catch((err: BusinessError) => {
        console.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err))
      })

      // 屏幕顶部的矩形区
      let systemType = window.AvoidAreaType.TYPE_SYSTEM
      let avoidAreaSystem = windowClass.getWindowAvoidArea(systemType)
      let topRectHeight = avoidAreaSystem.topRect.height
      AppStorage.setOrCreate(TOP_NAVI_HEIGHT, topRectHeight)

      // 获取布局避让遮挡的区域
      let type = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR // 以导航条避让为例
      let avoidArea = windowClass.getWindowAvoidArea(type)
      let bottomRectHeight = avoidArea.bottomRect.height // 获取到导航条区域的高度
      AppStorage.setOrCreate(BOTTOM_AVOID_AREA_HEIGHT, bottomRectHeight)

      const windowProp = windowClass.getWindowProperties()
      let w = px2vp(windowProp.windowRect.width).toFixed()
      let h = px2vp(windowProp.windowRect.height).toFixed()

      AppStorage.setOrCreate(SCREEN_WIDTH, w)
      AppStorage.setOrCreate(SCREEN_HEIGHT, h)

      windowClass.on('windowSizeChange',(windowSize) => {
        w = px2vp(windowSize.width).toFixed()
        h = px2vp(windowSize.height).toFixed()
        AppStorage.setOrCreate(SCREEN_WIDTH, w)
        AppStorage.setOrCreate(SCREEN_HEIGHT, h)
      })
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  async setupDB() {
    const context: Context = this.context
    await ConditionDB.sharedManager().createTable(context)
    await CityDB.sharedManager().createTable(context)
    await AlertDB.sharedManager().createTable(context)
    await AqiDB.sharedManager().createTable(context)
    await DailysDB.sharedManager().createTable(context)
    await DescDB.sharedManager().createTable(context)
    await HoursDB.sharedManager().createTable(context)
    await LifeIndexDB.sharedManager().createTable(context)
    await RadarDB.sharedManager().createTable(context)
    await ThemeListDB.sharedManager().createTable(context)
    await ThemeBgDB.sharedManager().createTable(context)
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
