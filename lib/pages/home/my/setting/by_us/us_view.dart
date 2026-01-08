import 'dart:ui';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/home/my/setting/by_us/us_controller.dart';
import 'package:iot/pages/home/my/setting/phone/phone_controller.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';

class UsPage extends StatelessWidget {
  final logic = Get.find<UsController>();

  UsPage({super.key});

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    // 在这里设置状态栏字体为深色
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 状态栏背景色
      statusBarBrightness: Brightness.dark, // 状态栏字体亮度
      statusBarIconBrightness: Brightness.dark, // 状态栏图标亮度
    ));
    return Scaffold(
      backgroundColor: HhColors.backColor,
      body: Obx(
            () => Container(
          height: 1.sh,
          width: 1.sw,
          padding: EdgeInsets.zero,
          child: logic.testStatus.value ? loginView() : const SizedBox(),
        ),
      ),
    );
  }

  loginView() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          // Image.asset('assets/images/common/back_login.png',width:1.sw,height: 1.sh,fit: BoxFit.fill,),
          ///title
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 54.w*3),
              color: HhColors.trans,
              child: Text(
                '关于我们',
                style: TextStyle(
                    color: HhColors.blackTextColor,
                    fontSize: 18.sp*3,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(23.w*3, 59.h*3, 0, 0),
              padding: EdgeInsets.fromLTRB(0, 10.w, 20.w, 10.w),
              color: HhColors.trans,
              child: Image.asset(
                "assets/images/common/back.png",
                height: 17.w*3,
                width: 10.w*3,
                fit: BoxFit.fill,
              ),
            ),
          ),

          Container(
            width: 1.sw,
            margin: EdgeInsets.fromLTRB(14.w*3, 98.w*3, 14.w*3, 0),
            decoration: BoxDecoration(
              color: HhColors.whiteColor,
              borderRadius: BorderRadius.circular(8.w*3)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 55.w*3,),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.w*3),
                    border: Border.all(color: HhColors.grayLineColor, width: 2.w),
                  ),
                  child: Image.asset(
                    "assets/images/common/logo_slide.png",
                    height: 56.w*3,
                    width: 56.w*3,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 8.w*3,),
                Text(
                  "${logic.appName.value}V${logic.version.value}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: HhColors.gray9TextColor, fontSize: 12.sp*3,fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 30.w*3,),
                Text(
                  "青岛浩海网络科技股份有限公司",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: HhColors.gray9TextColor, fontSize: 12.sp*3,fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 17.w*3,),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
