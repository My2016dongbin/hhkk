
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/HhColors.dart';
import 'custom_views.dart';

class HhAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color ?barBackgroundColor;
  final double ?barHeight;
  final Color ?barTitleColor;
  final bool ?trans;
  final String ?leftImage;
  final String ?rightImage;
  final double ?leftImageSize;
  final double ?rightImageSize;
  final String ?title;
  final double ?titleSize;
  final String ?centerImage;
  final String ?leftTitle;
  final String ?rightTitle;
  final Function() ?leftCallback;
  final Function() ?rightCallback;

  const HhAppBar({super.key,this.barBackgroundColor,this.leftImageSize,this.rightImageSize,this.barTitleColor,this.barHeight,this.trans,this.title,this.titleSize,this.centerImage,this.leftImage,this.leftTitle,this.rightImage,this.rightTitle,this.leftCallback,this.rightCallback});


  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: statusBarHeight),
          color: barBackgroundColor??HhColors.backColor,
          height: barHeight??((75.w+75.h)/2+statusBarHeight),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              if (leftImage==null) Container() else Align(
                alignment:Alignment.centerLeft,
                child: GestureDetector(
                  onTap: leftCallback,
                  child: Container(
                      color: HhColors.trans,
                      padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
                      margin: const EdgeInsets.only(left: 15),
                      child: Image.asset(leftImage!,height: leftImageSize??26,width:leftImageSize??26,)
                  ),
                ),
              ),
              leftTitle==null?Container():Align(
                alignment:Alignment.centerLeft,
                child: GestureDetector(
                  onTap: leftCallback,
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                      child: Text(leftTitle!,style:const TextStyle(color: HhColors.gray9TextColor,fontSize: 14))
                  ),
                ),
              ),
              Align(
                alignment:Alignment.center,
                child: Container(
                  margin: EdgeInsets.fromLTRB(screenWidth/6, 0, screenWidth/6, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      centerImage==null?Container():Container(
                          margin: const EdgeInsets.only(top: 2),
                          child: Image.asset(centerImage!,height: 20,width:20)
                      ),
                      title==null?Container():Container(
                        constraints: BoxConstraints(
                          maxWidth: screenWidth/2,
                        ),
                        margin: const EdgeInsets.only(left: 5),
                        child: TextSingleSplit(title!,8,textStyle: TextStyle(color: barTitleColor??HhColors.lineColor,fontSize: titleSize??20),minLimit: 5,),
                      ),
                    ],
                  ),
                ),
              ),
              rightImage==null?Container():Align(
                alignment:Alignment.centerRight,
                child: GestureDetector(
                  onTap: rightCallback,
                  child: Container(
                      color: HhColors.trans,
                      padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
                      margin: const EdgeInsets.only(right: 15),
                      child: Image.asset(rightImage!,height: rightImageSize??26,width:rightImageSize??26,fit: BoxFit.fill,)
                  ),
                ),
              ),
              rightTitle==null?Container():Align(
                alignment:Alignment.centerRight,
                child: GestureDetector(
                  onTap: rightCallback,
                  child: Container(
                      width: screenWidth/4,
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.fromLTRB(0, 0, rightImage==null?15:35, 0),
                      child: Text(rightTitle!,style:const TextStyle(color: HhColors.gray9TextColor,fontSize: 14,),maxLines: 1,overflow: TextOverflow.ellipsis,)
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(barHeight ?? 44.h);


}

class BaseLine extends StatelessWidget {
  final Color ?color;
  final double ?height;
  final double ?width;
  final EdgeInsets ?margin;


  const BaseLine({super.key, this.color, this.height, this.width, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height??1.w,
      width: width??1.sw,
      color: color??HhColors.lineColor,
      margin: margin,
    );
  }
}