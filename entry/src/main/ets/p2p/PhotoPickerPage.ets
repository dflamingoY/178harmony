import picker from '@ohos.file.picker';
import LogUtil from '../utils/LogUtil';

@Entry
@Component
export struct PhotoPickerPage {
  build() {
    Column() {

    }
  }

  aboutToAppear() {
    let photoPicker = new picker.PhotoViewPicker()
    let PhotoSelectOptions = new picker.PhotoSelectOptions()
    PhotoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
    PhotoSelectOptions.maxSelectNumber = 9;
    photoPicker.select(PhotoSelectOptions).then((PhotoSelectResult) => {
      LogUtil.d("West", 'PhotoViewPicker.select successfully, PhotoSelectResult uri: ' + JSON.stringify(PhotoSelectResult));
    }).catch((err) => {
      LogUtil.d("West", 'PhotoViewPicker.select failed with err: ' + err);
    });
  }
}