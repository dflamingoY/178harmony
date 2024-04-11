import IColors from '../utils/IColors'
import IConstant from '../utils/IConstant'
@Component
 export  struct  LoadingPage{
   build(){
     Column() {
       LoadingProgress()
         .color(IColors.color1R1E20)
         .width('40vp')
         .height('40vp')
         .backgroundColor(Color.White)
         .borderRadius('5vp')
     }.justifyContent(FlexAlign.Center).width(IConstant.MATCH_PARENT)
     .height(IConstant.MATCH_PARENT)
   }
 }