import media from '@ohos.multimedia.media';
import LogUtil from '../utils/LogUtil';

export default class LiveController {
  private avPlayer: media.AVPlayer | null = null;
  private surfaceId: string = ''
  private url: string = ''

  constructor() {
    this.createAVPlayer()
  }

  async createAVPlayer() {
    let avPlayer: media.AVPlayer = await media.createAVPlayer();
    this.avPlayer = avPlayer;
    this.bindState();
  }

  async bindState() {
    if (this.avPlayer == null) {
      return
    }
    this.avPlayer.on("stateChange", async (state: media.AVPlayerState) => {
      let currentState = state
      if (this.avPlayer == null) {
        return
      }
      switch (currentState) {
        case 'idle':
          if (this.url != '') {
            this.avPlayer.url = this.url
          }
          break;
        case 'initialized':
          this.avPlayer.surfaceId = this.surfaceId
          this.avPlayer.prepare()
          break;
        case 'prepared':
          this.avPlayer.play()
          break;
        case 'error':
          LogUtil.d("West", "error")
          break;
        case 'released':
          LogUtil.d("West", "released")
          break;
        case 'stopped':
          LogUtil.d("West", "released")
          break
      }
    })
    this.avPlayer.on('error', (err) => {
      LogUtil.d("West", 'error: ' + err.message)
    })
    this.avPlayer.on('timeUpdate', (time: number) => {
      LogUtil.d("West", 'timeUpdate: ')
    });
  }

  async setPlayUrl(url: string, surfaceId: string) {
    this.surfaceId = surfaceId
    if (this.avPlayer === null) {
      await this.createAVPlayer();
    }
    this.url = url
    if (this.avPlayer == null) {
      this.avPlayer.url = url
    }
  }

  release() {
    if (this.avPlayer !== null) {
      this.avPlayer.release();
    }
  }

}
