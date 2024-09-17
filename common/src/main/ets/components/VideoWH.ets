interface VideoInfo {
  videoWidth: number
  videoHeight : number
  screenWidth : number
  screenHeight : number
}

interface FinalInfo {
  finalWidth: number;
  finalHeight: number;
}

export function videoWH(videoViewInfo: VideoInfo): FinalInfo {
  const videoWidth = videoViewInfo.videoWidth; // 屏幕宽度
  const videoHeight = videoViewInfo.videoHeight; // 屏幕宽度
  const screenWidth = videoViewInfo.screenWidth; // 屏幕宽度
  const screenHeight = videoViewInfo.screenHeight; // 屏幕高度

  // 计算宽高比
  const videoAspectRatio = videoWidth / videoHeight;
  // 根据屏幕宽度和视频宽高比计算高度
  const calculatedHeight = screenWidth / videoAspectRatio;
  // 根据屏幕高度和视频宽高比计算宽度
  const calculatedWidth = screenHeight * videoAspectRatio;

  let finalWidth: number, finalHeight:number;

  if (calculatedHeight > screenHeight) {
    // 则按照屏幕高度缩放
    finalWidth = calculatedWidth;
    finalHeight = screenHeight;
  } else {
    // 则按照屏幕宽度缩放
    finalWidth = screenWidth;
    finalHeight = calculatedHeight;
  }

  return {
    finalWidth,
    finalHeight,
  };
}