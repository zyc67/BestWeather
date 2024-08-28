import { IData } from '@ohos/banner';

export class CommonResp {
  code: number = 0
  data: string = ''
  msg: string = ''
}

export class ThemeModel implements IData {
  theme_name?: string // 主题名称
  theme_id?: string   // 主题Id
  level?: number      // 标签 (1黄金 2白银 3热门 4推荐 5普通)
  layout?: number     // 布局类型 (1全透明瀑布流 2实况中置全透明 3实况左置全透明)
  clean_install_layout?: number // // 全新安装 1经典 2简洁
  carousel?: number   // 背景图 (1按天气 2城市 3随机)
  sort?: number
  cover?: string     // 封面
  cover_display?: string // 展示封面
  cover_concise?: string // 简明封面
  top?: number // 1是置顶
  author?: string
  detail_desc?: string  // 主题描述
  tab_id?: number
  color_type?: number   // 色值区域 1按天气 2固定色
  color_weather?: string // 色值区域-天气
  color_fixed?: string   // 色值区域-固定
  detail_imgs?: string   // 经典主题轮播图
  detail_imgs_concise?: string // 简明主题轮播图
  detail_url?: string          // 详情页落地页
  detail_url_concise?: string // 简明详情页落地页
  icon_selected?: string  // 主题底部图标选中
  icon_non_selected?: string //主题底部图标未选中
  updated_at?: string
  created_at?: string
}

