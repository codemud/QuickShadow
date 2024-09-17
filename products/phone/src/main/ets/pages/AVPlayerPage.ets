import { window } from '@kit.ArkUI';
import { UIConstants } from '@qs/common/src/main/ets/constans/UIContansts';
import { media } from '@kit.MediaKit';
import { avSession as AVSessionManager } from '@kit.AVSessionKit';
import { videoWH } from '@qs/common/src/main/ets/components/VideoWH'

let player:media.AVPlayer
let session: AVSessionManager.AVSession
let avSessionController: AVSessionManager.AVSessionController

interface XCContainer {
  width: number;
  height: number;
}

@Entry
@Component
struct VideoPage {
  ctrl: VideoController = new VideoController();
  xctrl: XComponentController = new XComponentController()

  @State isPlay: boolean = false;
  @State currentTime:number = 0; // 当前播放时长
  @State totalTime:number = 0; // 总时长
  @State canPlay:boolean = false; // 手动控制视频是否可以播放了
  @State progress: number = 0; // 选择某段进行点播
  @State xcomponentWH: XCContainer = {
    width: 0,
    height: 0
  }

  async aboutToAppear() {
    const w = AppStorage.get('window') as window.Window
    // LANDSCAPE: 肖像画
    w.setPreferredOrientation(window.Orientation.LANDSCAPE)
    w.setWindowLayoutFullScreen(true)

    let windowWidth:number = w.getWindowProperties().windowRect.width
    let windowHeight:number = w.getWindowProperties().windowRect.height
    console.log('--手机窗口尺寸:', JSON.stringify(w.getWindowProperties())) // 手机的尺寸，｛windowRect：｛width,height｝｝

    // 利用系统的音视频控制中心来控制视频 用AVSession kit
    try {
      session = await AVSessionManager.createAVSession(getContext(),'avplayer_video', 'video')
    } catch (err) {
      console.log('session失败', JSON.stringify(err))
    }

    // 通过已有session获取一个controller对象
    avSessionController = await session.getController();

    //1. 初始化/创建AVplayer对象 ---state: idle(空闲态)
    player = await media.createAVPlayer()
    //2. 提前设置好AVplayer的事件监听
    player.on('stateChange', async (state, reason) => { // 状态改变
      console.log('---Player state change', state)
      switch (state) {
        case 'initialized':
          player.surfaceId = this.xctrl.getXComponentSurfaceId() // 指定即将在哪个“界面”上绘制内容
          player.prepare() // player进入prepared状态，此过程中试图去加载视频信息（时长、宽高）
          break;
        case 'prepared':
          // player.play() //就绪态执行“播放”操作-->即将进入playing: 等同视频自动播放
          this.totalTime = player.duration // 视频总时长   单位是ms
          console.log('--视频的宽高：', player.width, player.height)
          const info = videoWH({videoWidth: player.width, videoHeight: player.height, screenWidth: windowWidth, screenHeight: windowHeight})
          this.xcomponentWH.width = info.finalWidth
          this.xcomponentWH.height = info.finalHeight
          console.log('---视频宽高', this.xcomponentWH.width, this.xcomponentWH.height)
          this.canPlay = true
          // 设置媒体信息
          let metaData: AVSessionManager.AVMetadata = {
            assetId: '123',
            title: '我这是视频标题',
            mediaImage: 'IMAGE',
            duration: this.totalTime, // 媒体时长
          }
          try {
            await session.setAVMetadata(metaData)
            console.log('媒体信息设置成功')
          } catch (e) {
            console.log('媒体信息设置失败',JSON.stringify(e))
          }
          break;
        case 'playing':
          // 设置播放状态
          let playbackState: AVSessionManager.AVPlaybackState = {
            state: AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY
          }
          await session.setAVPlaybackState(playbackState)
          break;
        case 'error':
            console.log('--视频播放错误')
            break;
        default:
            break;
      }
    })
    player.on('error', (err) => { // 播放出错
      console.log('---Player err', JSON.stringify(err))
    })
    player.on('timeUpdate', async (time) => { // 播放进度的时间更新
      this.currentTime = time  // 已经播放的时长 单位ms
      try {
        // 设置播放状态
        let playbackState: AVSessionManager.AVPlaybackState = {
          position: {
            elapsedTime: time,
            updateTime: (new Date()).getTime()
          }
        }
        await session.setAVPlaybackState(playbackState)
      } catch (err) {
        console.log('设置时长跳转失败,',err, JSON.stringify(err))
      }
      // console.log('---Player time update', time)
    })
    //3. 设置视频源 --- state: initialzed(初始化)
    player.url = 'https://www.codeboy.com/res/0.mp4'
    //4. 准备就绪 --- state: prepared(准备就绪态) 上面stateChange事件中



    // 监听
    session.on('play', async () => {
      console.log('触发了这个--play')
      player.play()
      // 设置播放状态
      let playbackState: AVSessionManager.AVPlaybackState = {
        state: AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY
      }
      await session.setAVPlaybackState(playbackState)
      console.log('设置播放状态成功--playing')
    });
    session.on('pause', async () => {
      console.log('触发了这个--pause')
      player.pause()
      // 设置播放状态
      let playbackState: AVSessionManager.AVPlaybackState = {
        state: AVSessionManager.PlaybackState.PLAYBACK_STATE_PAUSE
      }
      await session.setAVPlaybackState(playbackState)
      console.log('设置播放状态成功--pause')
    });

    await session.activate();
  }

  aboutToDisappear(): void {
    session.off('play');
    session.off('pause');
    session.destroy()
  }


  build() {
    RelativeContainer() {
      // AVPlayer播放器
      // xcomponent
      XComponent({
        id: 'xxcc',
        type: XComponentType.SURFACE, // 类型，用于绘图的画板/界面
        controller: this.xctrl // 控制器，用于控制绘图界面
      })
        .width(this.xcomponentWH.width === 0 ? '100%' : this.xcomponentWH.width)  // todo 这里宽度和高度需要动态计算，根据视频宽高和手机窗口宽高计算合适的值
        .height(this.xcomponentWH.height === 0 ? '100%' : this.xcomponentWH.height)
      // 头部row
      Row(){
        Image($r('app.media.back')).width(9)
        Text('视频标题').fontSize(16).fontColor(UIConstants.COLOR_WHITE).margin({left: 5})
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
            // 整个播放条
            Row().width('100%').height(2).backgroundColor(UIConstants.COLOR_WHITE).onClick((e)=>{
              // e.x,e.y 点击的坐标位置
              // e.target.area.width,e.target.area.height 整个点击的事件源的尺寸（坐标）
              this.progress = this.totalTime * e.x / (e.target.area.width as number)
              player.seek(this.progress)
            })
            // 已播放的长度
            Row().width(`${(this.currentTime/this.totalTime)*100}%`).height(2).backgroundColor(UIConstants.COLOR_ORANGE).position({
              left: 0,
              top: 2
            })
            // 圆点
            Row().width(14).height(14).borderRadius('100%').backgroundColor(UIConstants.COLOR_WHITE).position({
              left: `${(this.currentTime/this.totalTime)*100}%`,
              top: 2
            }).translate({ y: '-50%', x:-7 })
              .draggable(true)
              .onDrop(e => {
                console.log('拖拽事件：', JSON.stringify(e))
              })
              .onDragEnd((e) => {
                // todo 可以试试按住拖动
                console.log('拖拽结束：', JSON.stringify(e))
              })
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
      if (this.canPlay) {
        Image(this.isPlay ? $r('app.media.pause2') : $r('app.media.play2')).width(50).onClick(() => {
          this.isPlay = !this.isPlay
          if (this.isPlay) {
            player.play()
          } else {
            player.pause()
          }
        }).alignRules({
          middle: {anchor: '__container__', align: HorizontalAlign.Center},
          center: {anchor: '__container__', align: VerticalAlign.Center}
        })
      }
    }
    .height('100%')
    .width('100%')
  }
}