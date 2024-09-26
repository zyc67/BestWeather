/**
 * Web与应用前端交互
 */
export interface WebViewUtils {
  // 选取主题
  setTheme: (data: string) => void
  // 保存图片
  savePic: (pic: string) => void
}