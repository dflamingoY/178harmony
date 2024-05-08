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


class DateFormatUtil {
  /**
   * Seconds converted to HH:mm:ss.
   *
   * @param seconds Maximum video duration (seconds).
   * @return Time after conversion.
   */
  secondToTime(seconds: number): string {
    let hourUnit =3600;
    let hour = Math.floor(seconds / hourUnit);
    let minute = Math.floor((seconds - hour * hourUnit) / 60);
    let second = seconds - hour * hourUnit - minute * 60;
    if (hour > 0) {
      return `${this.padding(hour.toString())}${':'}${this.padding(minute.toString())}${':'}${this.padding(second.toString())}`;
    }
    if (minute > 0) {
      return `${this.padding(minute.toString())}${':'}${this.padding(second.toString())}`;
    } else {
      return `00${':'}${this.padding(second.toString())}`;
    }
  }

  /**
   * Zero padding, 2 bits.
   *
   * @param num Number to be converted.
   * @return Result after zero padding.
   */
  padding(num: string): string {
    let length = 2;
    for (let len = (num.toString()).length; len < length; len = num.length) {
      num = `0${num}`;
    }
    return num;
  }
}

export default new DateFormatUtil();

