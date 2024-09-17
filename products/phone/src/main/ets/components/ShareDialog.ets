import { UIConstants } from '@qs/common';
interface ShareItem{
  id?:number
  pic?:string
  title?:string
}

@CustomDialog
export struct ShareDialog {
  controller: CustomDialogController
  data:ShareItem[] = [
    {id: 1, pic: '/images/weixin.svg', title:'微信好友'},
    {id: 2, pic: '/images/pyq.svg', title:'朋友圈'},
    {id: 3, pic: '/images/qq.svg', title:'QQ好友'},
    {id: 4, pic: '/images/qzone.svg', title:'QQ空间'},
    {id: 5, pic: '/images/weibo.svg', title:'新浪微博'},
    {id: 6, pic: '/images/email.svg', title:'邮件分享'},
    {id: 7, pic: '/images/prtsc.svg', title:'创意截屏'},
    {id: 8, pic: '/images/copylink.svg', title:'复制链接'},
  ]
  build() {
    Column() {
      Grid(){
        ForEach(this.data, (item: ShareItem) => {
          GridItem(){
            Column(){
              Row(){
                Image(item.pic).width(32)
              }
              .width(42)
              .height(42)
              .borderWidth(1)
              .borderColor(UIConstants.COLOR_BLUE)
              .borderRadius(20)
              .justifyContent(FlexAlign.Center)
              Text(item.title)
                .fontColor(UIConstants.COLOR_DARKER)
            }
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.SpaceAround)
          }
        })
      }.width('100%')
      .height(220)
      .rowsTemplate('repeat(2, 1fr)')
      .columnsTemplate('repeat(4, 1fr)')
      .padding({
        top: UIConstants.SPACE_COL_XL,
        bottom: UIConstants.SPACE_COL_XL,
      })
      //对话框底部：关闭按钮
      Text('取消')
        .width('100%')
        .textAlign(TextAlign.Center)
        .backgroundColor(UIConstants.COLOR_BLUE)
        .fontColor(UIConstants.COLOR_WHITE)
        .fontSize(UIConstants.FONT_XL)
        .padding({
          top: UIConstants.SPACE_COL_LG,
          bottom: UIConstants.NAVIGATION_BAR_HEIGHT,
        })
        .onClick(_=>{
          this.controller.close()
        })
    }.width('100%')
  }
}