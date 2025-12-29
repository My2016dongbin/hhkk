import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/pages/common/share/confirm/confirm_controller.dart';
import 'package:iot/utils/HhColors.dart';

class ConfirmPage extends StatelessWidget {
  final logic = Get.find<ConfirmController>();

  ConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: logic.testStatus.value ? myPage() : const SizedBox(),
        ),
      ),
    );
  }

  myPage() {
    return Stack(
      children: [
        ///背景-渐变色
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [HhColors.backColorF5, HhColors.backColorF5]),
          ),
        ),

        ///title
        InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(36.w, 90.w, 0, 0),
            padding: EdgeInsets.all(10.w),
            color: HhColors.trans,
            child: Image.asset(
              "assets/images/common/back.png",
              height: 17.w*3,
              width: 10.w*3,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 90.w),
            color: HhColors.trans,
            child: Text(
              "分享确认",
              style: TextStyle(
                  color: HhColors.blackTextColor,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),

        ///菜单
        Container(
          margin: EdgeInsets.fromLTRB(20.w, 180.w, 20.w, 0),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: HhColors.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(20.w))),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 5.w,
                ),
                Container(
                  height: 110.w,
                  color: HhColors.trans,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 30.w),
                        child: Text(
                          "我的分组",
                          style: TextStyle(
                              color: HhColors.textBlackColor,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w200),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(6.w, 6.w, 0, 0),
                        child: Image.asset(
                          "assets/images/common/icon_top_role.png",
                          width: 30.w,
                          height: 26.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Expanded(child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              height: 80.w,
                              width: 80.w,
                              margin: EdgeInsets.only(right: 20.w),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(40.w))
                              ),
                              child: Image.asset(
                                "assets/images/common/ic_camera.png",
                                width: 30.w,
                                height: 26.w,
                                fit: BoxFit.fill,
                              ),
                            ),
                          )
                        ],
                      ))
                    ],
                  ),
                ),
                Container(
                  height: 0.5.w,
                  width: 1.sw,
                  margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                  color: HhColors.grayDDTextColor,
                ),
                Container(
                  height: 110.w,
                  color: HhColors.trans,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 30.w),
                        child: Text(
                          "大涧林场",
                          style: TextStyle(
                              color: HhColors.textBlackColor,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w200),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 1.sw,
          margin: EdgeInsets.fromLTRB(20.w, 440.w, 20.w, 0),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: HhColors.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(20.w))),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 40.w,
                ),
                Text(
                  "管理员",
                  style: TextStyle(
                      color: HhColors.gray4TextColor, fontSize: 30.sp,
                    fontWeight: FontWeight.bold,),
                ),
                SizedBox(
                  height: 20.w,
                ),
                Text(
                  "邀请你共享",
                  style: TextStyle(
                    color: HhColors.gray4TextColor,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                SizedBox(
                  height: 20.w,
                ),
                Text(
                  "“大涧林场-F1-HH160双枪机”",
                  style: TextStyle(
                    color: HhColors.mainBlueColor,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 40.w,
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.w))
                  ),
                  child: Image.asset(
                    "assets/images/common/test_video.jpg",
                    width: 220.w,
                    height: 220.w,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 60.w,
                ),
              ],
            ),
          ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 1.sw,
            height: 1.w,
            margin: EdgeInsets.only(bottom: 160.w),
            color: HhColors.grayDDTextColor,
          ),
        ),

        ///分享完成按钮
        Align(
          alignment: Alignment.bottomCenter,
          child: BouncingWidget(
            duration: const Duration(milliseconds: 100),
            scaleFactor: 1.2,
            onPressed: () {

            },
            child: Container(
              height: 80.w,
              width: 1.sw,
              margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 50.w),
              decoration: BoxDecoration(
                  color: HhColors.mainBlueColor,
                  borderRadius: BorderRadius.all(Radius.circular(20.w))),
              child: Center(
                child: Text(
                  "确定添加",
                  style: TextStyle(
                    color: HhColors.whiteColor,
                    fontSize: 30.sp,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
