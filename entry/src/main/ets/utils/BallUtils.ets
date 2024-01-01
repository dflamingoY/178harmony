export function getFootStatue(state: number): string {
  switch (state) {
    case 0:
      return "未";
    case 2:
      return "中场";
    case 4:
      return "加时";
    case 5:
      return "点球";
    case -1:
      return "完场";
    case -10:
      return "取消";
    case -11:
      return "待定";
    case -12:
      return "腰斩";
    case -13:
      return "中断";
    case -14:
      return "推迟";
  }
}

export function getBasketState(state: number): string {
  switch (state) {
    case 0:
      return "未";
      break;
    case 1:
      return "1st  ";
      break;
    case 2:
      return "2nd  ";
      break;
    case 3:
      return "3rd  ";
      break;
    case 4:
      return "4th  ";
      break;
    case 5:
    case 6:
    case 7:
      return "OT  ";
      break;
    case -1:
      return "完场";
      break;
    case -2:
      return "待";
      break;
    case -3:
      return "断";
      break;
    case -4:
      return "取消";
      break;
    case -5:
      return "推迟";
      break;
    case 50:
      return "中场";
      break;
  }
}