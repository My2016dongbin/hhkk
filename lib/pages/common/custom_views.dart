import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/HhColors.dart';


/// Text数字分割（单行）
class TextSingleSplit extends StatelessWidget {
  final String title;
  final int split;//大于次位数以后合并为一个Expanded
  final int ?minLimit;//title最小分割数
  final TextStyle ?textStyle;

  const TextSingleSplit(this.title,this.split,{super.key, this.minLimit,this.textStyle});


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: clipTexts(),
    );
  }

  List<Widget> clipTexts() {
    List<Widget> listW = [];
    if(title.length <= (minLimit??10)){
      //小于最小分割起点 不分割
      listW.add(Text(title,style: textStyle??childStyle,));
    }else{
      //大于最小分割起点 分割
      for(int i = 0; i < title.length; i++){
        if(i==split-1){
          //最后一段
          listW.add(Expanded(child: Text(title.substring(i,title.length),style: textStyle??childStyle,maxLines: 1,overflow: TextOverflow.ellipsis,)));
          return listW;
        }else{
          listW.add(Text(title.substring(i,i+1),style: textStyle??childStyle,maxLines: 1,));
        }
      }
    }
    return listW;
  }

}


///Text数字分割（多行）
class TextMultiSplit extends StatelessWidget {
  final String title;
  final TextStyle ?textStyle;

  const TextMultiSplit(this.title,{super.key, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      children: clipTexts(),
    );
  }

  List<Widget> clipTexts() {
    List<Widget> listW = [];
    //分割
    for(int i = 0; i < title.length; i++){
      listW.add(Text(title.substring(i,i+1),style: textStyle??childStyle,));
    }
    return listW;
  }
}

final childStyle = TextStyle(color: HhColors.blackColor,fontSize: 26.sp,height: 1.2);

