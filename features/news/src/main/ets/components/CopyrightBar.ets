@Preview    //该装饰器允许一个组件被预览
@Component
export struct CopyrightBar {
  build() {
    Column(){
      Text('NEWS模块导出的组件：版权声明条')
      Text('NEWS模块导出的组件：版权声明条')
    }.backgroundColor('#dfd')
  }
}