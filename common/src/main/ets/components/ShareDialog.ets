import { UIConstants } from '../constans/UIContansts'

@CustomDialog
export struct ShareDialog {
  controller: CustomDialogController
  build() {
    Column() {
      Grid(){
        GridItem(){
          Column(){
            Row(){
              Image('')
            }
          }
        }
      }.width('100%')
      .height(220)
      Text('取消').backgroundColor('#096dd9')
        .padding({
          top: 2,
          bottom: UIConstants.NAVIGATION_BAR_HEIGHT
        })
        .onClick(() => {
          this.controller.close()
        })
    }
  }
}