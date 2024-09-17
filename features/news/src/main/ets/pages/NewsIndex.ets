@Entry({routeName: 'NIndex'})
@Component
export struct NewsIndex {
  @State message: string = 'NEWS模块的首页';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}
