import { common, Want } from '@kit.AbilityKit'

export function toLocationSetting(context: common.UIAbilityContext) {
  const want: Want = {
    bundleName: `com.huawei.hmos.settings`,
    abilityName: `com.huawei.hmos.settings.MainAbility`,
    parameters: {
      pushParams: 'com.zmtq.weather'
    },
    uri: 'location_manager_settings',
  };
  context.startAbility(want)
}

export function toApplicationInfo(context: common.UIAbilityContext) {
  const want: Want = {
    bundleName: `com.huawei.hmos.settings`,
    abilityName: `com.huawei.hmos.settings.MainAbility`,
    parameters: {
      pushParams: 'com.zmtq.weather'
    },
    uri: 'application_info_entry',
  };
  context.startAbility(want)
}