import { window } from '@kit.ArkUI';
import { UIConstants } from '@qs/common/src/main/ets/constans/UIContansts';

@Entry
@Component
struct VideoPage {
  ctrl: VideoController = new VideoController();

  @State isPlay: boolean = false;
  @State currentTime:number = 0; // 当前播放时长
  @State totalTime:number = 0; // 总时长

  aboutToAppear(): void {
    const w = AppStorage.get('window') as window.Window
    // LANDSCAPE: 肖像画
    w.setPreferredOrientation(window.Orientation.LANDSCAPE)
    w.setWindowLayoutFullScreen(true)
  }

  build() {
    RelativeContainer() {
      // 播放器
      Video({
        src: 'https://www.codeboy.com/res/1.mp4',
        previewUri: 'https://www.codeboy.com/res/poster1.png',
        controller: this.ctrl
      }).width('100%').height('100%').objectFit(ImageFit.Contain).controls(false)
        .onPrepared((e)=>{
          console.log('视频已准备就绪,总时长', e.duration)
          this.totalTime = e.duration
        })
        .onUpdate((e)=>{
          console.log('当前播放进度，已播放时长',e.time)
          this.currentTime = e.time
        })
      // 头部row
      Row(){
        Image($r('app.media.back')).width(9)
        Text('问问问不问不了').fontSize(16).fontColor(UIConstants.COLOR_WHITE).margin({left: 5})
        Blank()
        Image($r('app.media.more')).fillColor(UIConstants.COLOR_WHITE).width(24)
      }.width('calc(100% - 80vp)').height(50)
        .alignRules({
          middle:{anchor: '__container__', align: HorizontalAlign.Center},
          top:{anchor: '__container__', align: VerticalAlign.Top}
        }).offset({
          y: 20
        })
      // 底部row
      Row(){
        Text(''+this.currentTime).fontSize(12).fontColor(UIConstants.COLOR_WHITE)
        // todo 进度条 start 可以考虑下小圆点的动画效果，使用translate动态去改变位置，而不是通过position去定位位置
        Row(){
          // todo 这里堆叠容器，对于定位点相对位置理解的还不够好,小圆点和已播放位置就不好定位
          Stack(){
            Row().width('100%').height(2).backgroundColor(UIConstants.COLOR_WHITE)
            Row().width(`${(this.currentTime/this.totalTime)*100}%`).height(2).backgroundColor(UIConstants.COLOR_ORANGE).position({
              left: 0,
              top: 2
            })
            Row().width(14).height(14).borderRadius('100%').backgroundColor(UIConstants.COLOR_WHITE).position({
              left: `${(this.currentTime/this.totalTime)*100}%`,
              top: 2
            }).translate({ y: '-50%', x:-7 })
          }
        }
        .layoutWeight(1) //布局权重
        .height(5)
        .margin({
          left: 12,
          right: 12
        })
        // 进度条 end
        Text(''+this.totalTime).fontSize(12).fontColor(UIConstants.COLOR_WHITE)
        Text('标清').fontSize(12).fontColor(UIConstants.COLOR_WHITE).margin({
          left: 10,
          right: 10
        })
        Image($r('app.media.zoomin')).fillColor(UIConstants.COLOR_WHITE).width(15)
      }.width('calc(100% - 80vp)').height(50)
      .alignRules({
        middle:{anchor: '__container__', align: HorizontalAlign.Center},
        bottom:{anchor: '__container__', align: VerticalAlign.Bottom}
      }).offset({
        y: -20
      })
      // 播放/暂停 按钮
      Image(this.isPlay ? $r('app.media.pause2') : $r('app.media.play2')).width(50).onClick(() => {
        this.isPlay = !this.isPlay
        if (this.isPlay) {
          this.ctrl.start()
        } else {
          this.ctrl.pause()
        }
      }).alignRules({
        middle: {anchor: '__container__', align: HorizontalAlign.Center},
        center: {anchor: '__container__', align: VerticalAlign.Center}
      })
    }
    .height('100%')
    .width('100%')
  }
}