import { window } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State message: string = 'Phone模块的入口';

  onPageShow(): void {
    const w = AppStorage.get('window') as window.Window
    w.setWindowLayoutFullScreen(false) // 设置是否全屏
    // 必须使用6位/8位颜色值
    w.setWindowBackgroundColor('#000000') // 设置窗口背景颜色
    // 设置系统提供的横栏的属性（状态栏/导航栏）
    w.setWindowSystemBarProperties({
      statusBarColor: '#ffffff', // 设置状态栏图标/文字的颜色
      statusBarContentColor: '#ff0000', // 设置状态栏背景色（优先级高于setWindowBackgroundColor）
      // 目前以下两个导航栏属性设置无效,等待官方修复
      navigationBarColor: '#0000ff', // 设置导航栏三键/指示器颜色
      navigationBarContentColor: '#ffff00' //设置导航栏背景色
    })

    w.setSpecificSystemBarEnabled('status', false) // 禁用顶部的状态栏
    w.setSpecificSystemBarEnabled('navigation', false) // 禁用底部的三键导航栏
    w.setSpecificSystemBarEnabled('navigationIndicator', false) // 禁用底部的指示器(小横条)导航栏
  }

  build() {
    Column() {
      Text('入口')
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#fde')
  }
}