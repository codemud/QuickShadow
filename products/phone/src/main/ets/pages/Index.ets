import { window } from '@kit.ArkUI';
import { UIConstants } from '@qs/common';
import { ShareDialog } from '../components/ShareDialog'

interface IAddInfo {
  txt: string
  bgc: string
  fc: string
  opacity: number
}

interface IMusicPosition {
  x: number
  y: number
  opacity: number
}

@Extend(Text) function viewText() {
  .fontSize(UIConstants.FONT_MD).fontColor(UIConstants.COLOR_WHITE).margin({ top: UIConstants.SPACE_COL_LG})
}

@Entry
@Component
struct Index {

  @State addInfo: IAddInfo = {
    txt: '+',
    bgc: UIConstants.COLOR_RED,
    fc: UIConstants.COLOR_WHITE,
    opacity: 1
  }

  @State heartFilColor: string = UIConstants.COLOR_WHITE  // 爱心填充色
  @State discRotate: number = 0  // 唱片旋转角度

  @State musicPosition: IMusicPosition = {
    x: 20,
    y: 20,
    opacity: 0
  }

  @State isPlaying: boolean = true

  @State musicInterval: number | null = null

  // 分享dialog控制器  todo 可以加上动画
  shareCon:CustomDialogController = new CustomDialogController({
    builder: ShareDialog(), // 控制的是哪一个对话框
    alignment: DialogAlignment.Bottom,  // 对齐方式
    width: '100%', // 整体对话框的宽度
    offset: {dx: 0, dy: UIConstants.NAVIGATION_BAR_HEIGHT}, //对话框窗口的位置偏移量（安全区域问题）
    cornerRadius: 10 // dialog的圆角
  })

  aboutToAppear(): void {
    // aboutToAppear中对属性进行修改不会触发动画animation
    // this.discRotate = 360
  }

  onPageHide(): void {
    clearInterval(this.musicInterval)
  }

  onPageShow() {
    // onPageShow对属性进行修改会触发动画animation
    this.discRotate = 360
    // 控制音符图片的漂移——定时器动画
    let direction: number = 1 // 1表示不透明度0-->1， -1表示不透明度1--->0
    this.musicInterval = setInterval(()=> {
      if (this.isPlaying) {
        this.musicPosition.x +=1
        this.musicPosition.y +=2
        this.musicPosition.opacity += direction*0.03
        if (this.musicPosition.opacity >= 1) {
          direction = -1
        } else if (this.musicPosition.opacity <= 0) {
          direction = 1
          this.musicPosition.x = 0
          this.musicPosition.y = 0
        }
      }
    }, 50)
    const w = AppStorage.get('window') as window.Window
    w.setWindowLayoutFullScreen(true) //全屏显示
    w.setWindowSystemBarProperties({
      statusBarContentColor: UIConstants.COLOR_WHITE  //状态栏图标的颜色
    })
    // // 获取顶部状态栏高度
    // let h1 = w.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height
    // console.log('顶部状态栏高度-->', h1, px2vp(h1))
    // // 获取底部导航条的高度
    // let h2  = w.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height
    // console.log('底部导航条高度-->', h2, px2vp(h2))
  }

  build() {
    Stack() {
      // 视频
      Image('/images/videobg.png').width('100%').height('100%')
      // 相机
      Image('/images/camera.svg').width(20).position({
        top: UIConstants.STATUS_BAR_HEIGHT,
        left: UIConstants.SPACE_ROW_XL
      })
      // 中间推荐、关注
      Flex({
        justifyContent: FlexAlign.Center
      }){
        Text('推荐').fontColor(UIConstants.COLOR_WHITE)
        Divider().vertical(true).color(UIConstants.COLOR_WHITE).height(15).margin({
          left: UIConstants.SPACE_COL_SM,
          right: UIConstants.SPACE_COL_SM
        })
        Text('关注').fontColor(UIConstants.COLOR_WHITE)
      }.position({
        top: UIConstants.STATUS_BAR_HEIGHT
      })
      // 搜索
      Image('/images/search.svg').fillColor(UIConstants.COLOR_WHITE).width(20)
        .position({
          top: UIConstants.STATUS_BAR_HEIGHT,
          right: UIConstants.SPACE_ROW_XL
        })
      Column(){
        // 头像
        Image('/images/avatar_lg.svg').width(45)
        Text(this.addInfo.txt).width(20).height(20)  //指定当前元素相对于直接父元素的定位，且会释放当前元素的布局空间
          // .position({
          //   left: '50%'
          // })
          // .transform({x: '-50%'})
            .position({
              top: 12.5,
              left: 30
            })
          .borderRadius('100%')
          .fontColor(UIConstants.COLOR_WHITE)
          .fontSize(this.addInfo.fc)
          .textAlign(TextAlign.Center)
          .backgroundColor(this.addInfo.bgc)
          .border({
            width:1,
            color:UIConstants.COLOR_RED
          })
          .opacity(this.addInfo.opacity)
          .animation({duration: 1000, onFinish: () => {
            // 等到动画结束后，再进行动画
            animateTo({duration: 500}, () =>{
              this.addInfo.opacity = 0
            })
          }})
          .onClick(() => {
            this.addInfo.txt = '✓'
            this.addInfo.bgc = UIConstants.COLOR_WHITE
            this.addInfo.fc = UIConstants.COLOR_RED
          })

        // 点赞
        Image('/images/heart.svg').width(40)
          .fillColor(this.heartFilColor)
            //.animation({duration:1000})  目前SVG的填充色还不能使用属性动画
          .margin({ top: UIConstants.SPACE_COL_LG * 2})
          .onClick(() => {
            this.heartFilColor = UIConstants.COLOR_RED
          })
        Text('52.1w').viewText()
        // 评论
        Image('/images/comment.svg').width(40).margin({ top: UIConstants.SPACE_COL_LG * 2})
        Text('12.1w').viewText()
        // 分享
        Image('/images/share.svg').width(35).margin({ top: UIConstants.SPACE_COL_LG * 2})
          .onClick(() => {
            this.shareCon.open()
          })
        Text('3.1w').viewText()
        // 头像唱片
        Image('/images/avatar_sm.svg').width(44).border({width: 10, color: '#66000000'}).borderRadius('100%')
          .margin({
            top: UIConstants.SPACE_COL_LG * 5
          })
          .rotate({angle: this.discRotate})
          // iterations: 动画循环次数，-1表示无穷, curve：速度曲线,linear表示匀速，线性等
          .animation({duration: 2000, iterations: -1, curve: 'linear'})
          .onClick(() => {
            this.discRotate = this.discRotate === 0 ? 360 : 0
          })
        // 小音符,使用定时器动画
        Image('/images/music.svg').width(14).opacity(this.musicPosition.opacity)
          .position({
            left:-12-this.musicPosition.x,
            bottom: 22+this.musicPosition.y
          })
      }.position({
        right: UIConstants.SPACE_ROW_XL,
        bottom: UIConstants.SPACE_COL_XL * 6
      })

      //  跑马灯
      Marquee({
        start: true, // 是否立即开始
        src: 'wozheshiceshiwozheshiceshiwozheshiceshiwozheshiceshiwozheshiceshi' //文字来源
      }).fontColor(UIConstants.COLOR_WHITE).fontSize(UIConstants.FONT_MD)
        .width('60%')
        .position({
          left: 75,
          bottom: UIConstants.SPACE_COL_XL * 6 + 18
        })

    }
    .height('100%')
    .width('100%')
  }
}