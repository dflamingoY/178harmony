/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import media from '@ohos.multimedia.media';
import resourceManager from '@ohos.resourceManager';
import window from '@ohos.window';
import DateFormatUtil from '../utils/DateFormatUtil';
import LogUtil from '../utils/LogUtil';

@Observed
export class VideoPresenter {
  private avPlayer: media.AVPlayer | null = null;
  private duration: number = 0;
  private status: number = -1;
  private loop: boolean = false;
  private index: number = 0;
  private url?: resourceManager.RawFileDescriptor = {} as resourceManager.RawFileDescriptor;
  private iUrl: string = '';
  private surfaceId: string = '';
  currentState: AvplayerStatus = AvplayerStatus.IDLE
  private onState?: (state: AvplayerStatus) => void
  private onProgress?: (pro: string, total: string, val: number) => void
  private seekTime: number = 0;

  constructor() {
    this.createAVPlayer();
  }

  /**
   * Creates a videoPlayer object.
   */
  async createAVPlayer() {
    let avPlayer: media.AVPlayer = await media.createAVPlayer();
    this.avPlayer = avPlayer;
    this.bindState();
  }

  /**
   * AVPlayer binding event.
   */
  async bindState() {
    if (this.avPlayer === null) {
      return;
    }
    this.avPlayer.on(Events.STATE_CHANGE, async (state: media.AVPlayerState) => {
      let avplayerStatus: string = state;
      if (this.avPlayer === null) {
        return;
      }
      LogUtil.d("West", "当前播放器状态：" + avplayerStatus)
      switch (avplayerStatus) {
        case AvplayerStatus.IDLE:
          this.currentState = AvplayerStatus.IDLE;
          this.resetProgress();
          this.avPlayer.url = this.iUrl;
          break;
        case AvplayerStatus.INITIALIZED:
          this.currentState = AvplayerStatus.INITIALIZED;
          this.avPlayer.surfaceId = this.surfaceId;
          this.avPlayer.prepare();
          break;
        case AvplayerStatus.PREPARED:
          this.currentState = AvplayerStatus.PREPARED;
          this.avPlayer.videoScaleType = 0;
          this.setVideoSize();
          this.avPlayer.play();
          this.duration = this.avPlayer.duration;
          LogUtil.d("West", `duration : ${this.duration}`)
          break;
        case AvplayerStatus.PLAYING:
          this.currentState = AvplayerStatus.PLAYING;
        // this.avPlayer.setVolume(this.playerThis.volume);
        // this.setBright();
          this.status = 1;
        // this.watchStatus();
          break;
        case AvplayerStatus.PAUSED:
          this.currentState = AvplayerStatus.PAUSED;
          this.status = 2;
        // this.watchStatus();
          break;
        case AvplayerStatus.COMPLETED:
          this.currentState = AvplayerStatus.COMPLETED;
          this.duration = 0;
          this.avPlayer.reset();
          this.iUrl = ''
          break;
        case AvplayerStatus.RELEASED:
          this.currentState = AvplayerStatus.RELEASED;
          this.avPlayer.release();
          this.status = 3;
        // this.watchStatus();
        // Logger.info('[PlayVideoModel] state released called')
          break;
        default:
          LogUtil.d('West', '[PlayVideoModel] unKnown state: ' + state);
          break;
      }
      if (this.status) {
        this.onState(this.currentState)
      }
    });
    this.avPlayer.on(Events.TIME_UPDATE, (time: number) => {
      this.initProgress(time);
    });
    this.avPlayer.on(Events.ERROR, () => {
      this.playError();
    })
  }

  /**
   * This method is triggered when the video playback page is displayed on the video list page.
   *
   * @param index Video object subscript in the video list.
   * @param url Playback Path.
   * @param surfaceId Indicates the surface ID of the surfaceId.
   */
  async firstPlay(iUrl: string, surfaceId: string) {
    this.iUrl = iUrl;
    this.surfaceId = surfaceId;
    if (this.avPlayer === null) {
      await this.createAVPlayer();
    }
    if (this.avPlayer !== null) {
      this.avPlayer.url = iUrl;
    }
  }

  /**
   * Release the video player.
   */
  release() {
    if (this.avPlayer !== null) {
      this.avPlayer.release();
    }
  }

  /**
   * Pause Playing.
   */
  pause() {
    if (this.avPlayer !== null) {
      this.avPlayer.pause();
    }
  }

  /**
   * Playback mode. The options are as follows: true: playing a single video; false: playing a cyclic video.
   */
  setLoop() {
    this.loop = !this.loop;
  }

  /**
   * Set the playback speed.
   *
   * @param playSpeed Current playback speed.
   */
  setSpeed(playSpeed: number) {
    if (this.avPlayer === null) {
      return;
    }
    // if (CommonConstants.OPERATE_STATE.indexOf(this.avPlayer.state) === -1) {
    //   return;
    // }
    // this.playSpeed = playSpeed;
    // this.avPlayer.setSpeed(this.playSpeed);
  }

  /**
   * Next video.
   */
  nextVideo() {
    if (this.avPlayer === null) {
      return;
    }
    this.avPlayer.reset();
  }

  /**
   * Switching Between Video Play and Pause.
   */
  switchPlayOrPause() {
    if (this.avPlayer === null) {
      return;
    }
    if (this.status === 1) {
      this.avPlayer.pause();
    } else {
      this.avPlayer.play();
    }
  }

  /**
   * Slide the progress bar to set the playback progress.
   *
   * @param value Value of the slider component.
   * @param mode Slider component change event.
   */
  setSeekTime(value: number, mode: SliderChangeMode) {
    if (mode === Number(SliderMode.MOVING)) {
      // The current time is changed during dragging, and other parameters remain unchanged.
      let progressVal = value;
      let currentTime = DateFormatUtil.secondToTime(Math.floor(value * this.duration /
      100 / 1000));
    }
    if (mode === Number(SliderMode.END) || mode === Number(SliderMode.CLICK)) {
      this.seekTime = value * this.duration / 100;
      if (this.avPlayer !== null) {
        this.avPlayer.seek(this.seekTime, media.SeekMode.SEEK_PREV_SYNC);
      }
    }
  }

  /**
   * Setting the brightness.
   */
  setBright() {
    // let windowClass = GlobalContext.getContext().getObject('windowClass') as window.Window;
    // windowClass.setWindowBrightness(this.playerThis.bright)
  }

  /**
   * Obtains the current video playing status.
   */
  getStatus() {
    return this.status;
  }

  /**
   * Initialization progress bar.
   *
   * @param time Current video playback time.
   */
  initProgress(time: number) {
    let nowSeconds = Math.floor(time / 1000);
    let totalSeconds = Math.floor(this.duration / 1000);
    let currentTime = DateFormatUtil.secondToTime(nowSeconds);
    let totalTime = DateFormatUtil.secondToTime(totalSeconds);
    let progressVal = Math.floor(nowSeconds * 100 / totalSeconds);
    if (this.onProgress) {
      this.onProgress(currentTime, totalTime, progressVal)
    }
    // LogUtil.d("West", `currentTime : ${currentTime}  totalTime: ${totalTime} progressVal:${progressVal} `)
  }

  /**
   * Reset progress bar data.
   */
  resetProgress() {
    // this.seekTime = PlayConstants.PROGRESS_SEEK_TIME;
    // this.progressThis.currentTime = PlayConstants.PROGRESS_CURRENT_TIME;
    // this.progressThis.progressVal = PlayConstants.PROGRESS_PROGRESS_VAL;
  }

  /**
   * Volume gesture method onActionStart.
   *
   * @param event Gesture event.
   */
  onVolumeActionStart(event?: GestureEvent) {
    if (!event) {
      return;
    }
    // this.positionX = event.offsetX;
  }

  /**
   * Bright gesture method onActionStart.
   *
   * @param event Gesture event.
   */
  onBrightActionStart(event?: GestureEvent) {
    if (!event) {
      return;
    }
    // this.positionY = event.offsetY;
  }

  /**
   * Gesture method onActionUpdate.
   *
   * @param event Gesture event.
   */
  onVolumeActionUpdate(event?: GestureEvent) {
    if (!event) {
      return;
    }
    if (this.avPlayer === null) {
      return;
    }
    // if (CommonConstants.OPERATE_STATE.indexOf(this.avPlayer.state) === -1) {
    //   return;
    // }
    // if (this.playerThis.brightShow === false) {
    //   this.playerThis.volumeShow = true;
    //   let screenWidth = GlobalContext.getContext().getObject('screenWidth') as number;
    //   let changeVolume = (event.offsetX - this.positionX) / screenWidth;
    //   let volume: number = this.playerThis.volume;
    //   let currentVolume = volume + changeVolume;
    //   let volumeMinFlag = currentVolume <= PlayConstants.MIN_VALUE;
    //   let volumeMaxFlag = currentVolume > PlayConstants.MAX_VALUE;
    //   this.playerThis.volume = volumeMinFlag ? PlayConstants.MIN_VALUE :
    //     (volumeMaxFlag ? PlayConstants.MAX_VALUE : currentVolume);
    //   this.avPlayer.setVolume(this.playerThis.volume);
    //   this.positionX = event.offsetX;
    // }
  }

  /**
   * Gesture method onActionUpdate.
   *
   * @param event Gesture event.
   */
  onBrightActionUpdate(event?: GestureEvent) {
    if (!event) {
      return;
    }
    // if (this.playerThis.volumeShow === false) {
    //   this.playerThis.brightShow = true;
    //   let screenHeight = GlobalContext.getContext().getObject('screenHeight') as number;
    //   let changeBright = (this.positionY - event.offsetY) / screenHeight;
    //   let bright: number = this.playerThis.bright;
    //   let currentBright = bright + changeBright;
    //   let brightMinFlag = currentBright <= PlayConstants.MIN_VALUE;
    //   let brightMaxFlag = currentBright > PlayConstants.MAX_VALUE;
    //   this.playerThis.bright = brightMinFlag ? PlayConstants.MIN_VALUE :
    //     (brightMaxFlag ? PlayConstants.MAX_VALUE : currentBright);
    //   this.setBright();
    //   this.positionY = event.offsetY;
    // }
  }

  /**
   * Gesture method onActionEnd.
   */
  onActionEnd() {
    // setTimeout(() => {
    //   this.playerThis.volumeShow = false;
    //   this.playerThis.brightShow = false;
    //   this.positionX = PlayConstants.POSITION_X;
    //   this.positionY = PlayConstants.POSITION_Y;
    // }, PlayConstants.DISAPPEAR_TIME);
  }

  /**
   * Sets whether the screen is a constant based on the playback status.
   */
  // watchStatus() {
  //   let windowClass = GlobalContext.getContext().getObject('windowClass') as window.Window;
  //   if (this.status === CommonConstants.STATUS_START) {
  //     windowClass.setWindowKeepScreenOn(true);
  //   } else {
  //     windowClass.setWindowKeepScreenOn(false);
  //   }
  // }

  /**
   * Sets the playback page size based on the video size.
   */
  setVideoSize() {
    if (this.avPlayer === null) {
      return;
    }
  }
  /**
   * An error is reported during network video playback.
   */
  playError() {
    this.currentState = AvplayerStatus.ERROR;
    // prompt.showToast({
    //   duration: 200,
    //   message: $r('app.string.link_check_address_internet')
    // });
  }

  setStateCallback(onState: (state: AvplayerStatus) => void) {
    this.onState = onState
  }

  setProgressCallback(onProgress: (pro: string, total: string, val: number) => void) {
    this.onProgress = onProgress
  }
}


/**
 * Player component status.
 */
export enum AvplayerStatus {
  IDLE = 'idle',
  INITIALIZED = 'initialized',
  PREPARED = 'prepared',
  PLAYING = 'playing',
  PAUSED = 'paused',
  COMPLETED = 'completed',
  STOPPED = 'stopped',
  RELEASED = 'released',
  ERROR = 'error'
}

/**
 * AVPlayer binding event.
 */
enum Events {
  STATE_CHANGE = 'stateChange',
  TIME_UPDATE = 'timeUpdate',
  ERROR = 'error'
}


/**
 * Slider mode.
 */
export enum SliderMode {
  MOVING = 1,
  END = 2,
  CLICK = 3
}