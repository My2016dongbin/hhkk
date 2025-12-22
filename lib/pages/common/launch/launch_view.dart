import 'dart:ui';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/launch/launch_controller.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhColors.dart';

class LaunchPage extends StatelessWidget {
  final logic = Get.find<LaunchController>();

  LaunchPage({super.key});

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    return Scaffold(
      backgroundColor: HhColors.backColor,
      body: Obx(
            () => Container(
          height: 1.sh,
          width: 1.sw,
          padding: EdgeInsets.zero,
          child: logic.testStatus.value ? launchView() : const SizedBox(),
        ),
      ),
    );
  }

  launchView() {
    return Stack(
      children: [
        CommonData.personal?SizedBox(height: 1.sh,width: 1.sw,child: Image.asset('assets/images/common/icon_bg.png',fit: BoxFit.fill,)):const SizedBox(),
        Image.asset(CommonData.personal?'assets/images/common/icon_launch.png':'assets/images/common/icon_launch_blue.png',fit: BoxFit.fill,),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 181.h*3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      width: 74.w*3,
                      height: 74.w*3,
                      child: Image.asset('assets/images/common/logo.png',fit: BoxFit.fill,)
                  ),
                  SizedBox(height: 12.w*3,),
                  Text('卡口App',style: TextStyle(color: HhColors.whiteColor,fontSize: 16.sp*3),)
                ],
              )
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(bottom: 86.h*3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Text('智能物联设备·一端管理',style: TextStyle(color: CommonData.personal?HhColors.whiteColor:HhColors.blackColor,fontSize: 30.sp,/*fontWeight: FontWeight.bold*/),),
                // SizedBox(height: 0.08.sw,),
                logic.secondStatus.value?const SizedBox():BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: (){
                    CommonUtils().toLogin();
                  },
                  child: Container(
                    width: 1.sw,
                    height: 48.w*3,
                    margin: EdgeInsets.fromLTRB(29.w*3, 0, 29.w*3, 0),
                    decoration: CommonData.personal?BoxDecoration(
                        color: HhColors.mainBlueColorTrans,
                        borderRadius: BorderRadius.all(Radius.circular(24.w*3))):BoxDecoration(
                        color: HhColors.mainBlueColor,
                        borderRadius: BorderRadius.all(Radius.circular(24.w*3))),
                    child: Center(
                      child: Text(
                        "开始体验",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: HhColors.whiteColor, fontSize: 15.sp*3,fontWeight: FontWeight.w200),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}
