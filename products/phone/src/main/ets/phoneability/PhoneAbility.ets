import { AbilityConstant, UIAbility, Want, wantAgent } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { backgroundTaskManager } from '@kit.BackgroundTasksKit';

// 监视窗口周期
export default class PhoneAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/AVPlayerPage', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      // 获得窗口舞台（WindowStage）中的窗口（window）对象
      const w: window.Window = windowStage.getMainWindowSync()
      // 保存到全局
      AppStorage.setOrCreate('window', w)
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  async onBackground(): Promise<void> {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
    const wantagent = await wantAgent.getWantAgent({
      wants: [{
        bundleName: 'cn.tedu.quickshadow',
        abilityName: 'PhoneAbility'
      }],
      actionType: wantAgent.OperationType.START_ABILITY,
      requestCode: 0
    })
    await backgroundTaskManager.startBackgroundRunning(getContext(this), backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK, wantagent)
    console.log('长时任务开启成功')
  }
}
