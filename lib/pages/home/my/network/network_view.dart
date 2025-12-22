import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/pages/home/my/network/network_controller.dart';
import 'package:iot/pages/home/my/setting/setting_controller.dart';
import 'package:iot/utils/HhColors.dart';
class NetWorkPage extends StatelessWidget {
  final logic = Get.find<NetWorkController>();
  NetWorkPage({super.key});


  @override
  Widget build(BuildContext context) {
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
                colors: [HhColors.mainBlueColor, HhColors.transBlue1Color, HhColors.whiteColor]),
          ),
        ),
        ///title
        InkWell(
          onTap: (){
            Get.back();
          },
          child: Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(25.w))),
            margin: EdgeInsets.fromLTRB(36.w, 90.w, 0, 0),
            padding: EdgeInsets.all(10.w),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/images/common/back.png",
                    height: 17.w*3,
                    width: 10.w*3,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 100.w),
            color: HhColors.trans,
            child: Text(
              "网络状态",
              style: TextStyle(
                  color: HhColors.whiteColor,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ///菜单
        Container(
          margin: EdgeInsets.fromLTRB(20.w, 200.w, 20.w, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20.w,),
                          Text(
                            "一般",
                            style: TextStyle(
                                color: HhColors.whiteColor,
                                fontSize: 30.sp,fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20.w,),
                          Container(
                            height: 10.w,
                            margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor.withAlpha(100),
                                borderRadius: BorderRadius.all(Radius.circular(5.w))
                            ),
                          ),
                          SizedBox(height: 20.w,),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20.w,),
                          Text(
                            "良好",
                            style: TextStyle(
                                color: HhColors.whiteColor,
                                fontSize: 30.sp,fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20.w,),
                          Container(
                            height: 10.w,
                            margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor.withAlpha(160),
                                borderRadius: BorderRadius.all(Radius.circular(5.w))
                            ),
                          ),
                          SizedBox(height: 20.w,),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20.w,),
                          Text(
                            "优秀",
                            style: TextStyle(
                                color: HhColors.whiteColor,
                                fontSize: 44.sp,fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20.w,),
                          Container(
                            height: 10.w,
                            margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius: BorderRadius.all(Radius.circular(5.w))
                            ),
                          ),
                          SizedBox(height: 20.w,),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.w,),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(14.w))
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ///WI-FI设备
                      SizedBox(
                        height:110.w,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin:EdgeInsets.only(left: 30.w),
                                child: Text(
                                  "WI-FI设备",
                                  style: TextStyle(
                                      color: HhColors.textBlackColor,
                                      fontSize: 28.sp,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin:EdgeInsets.only(right: 65.w),
                                child: Text(
                                  "ehaohai",
                                  style: TextStyle(
                                      color: HhColors.gray9TextColor,
                                      fontSize: 26.sp),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin:EdgeInsets.fromLTRB(0,0,30.w,0),
                                child: Image.asset(
                                  "assets/images/common/back_role.png",
                                  width: 25.w,
                                  height: 25.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child:Container(
                                  height: 0.5.w,
                                  width: 1.sw,
                                  margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                  color: HhColors.grayDDTextColor,
                                )
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.w,),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(14.w))
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ///WI-FI设备
                      SizedBox(
                        height:110.w,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin:EdgeInsets.only(left: 30.w),
                                child: Text(
                                  "WI-FI设备",
                                  style: TextStyle(
                                      color: HhColors.textBlackColor,
                                      fontSize: 28.sp,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin:EdgeInsets.only(right: 65.w),
                                child: Text(
                                  "",
                                  style: TextStyle(
                                      color: HhColors.gray9TextColor,
                                      fontSize: 26.sp),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin:EdgeInsets.fromLTRB(0,0,30.w,0),
                                child: Image.asset(
                                  "assets/images/common/back_role.png",
                                  width: 25.w,
                                  height: 25.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child:Container(
                                  height: 0.5.w,
                                  width: 1.sw,
                                  margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                  color: HhColors.grayDDTextColor,
                                )
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 20.w,),
                                Text(
                                  "0",
                                  style: TextStyle(
                                      color: HhColors.textBlackColor,
                                      fontSize: 40.sp,fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10.w,),
                                Text(
                                  "信号弱",
                                  style: TextStyle(
                                      color: HhColors.gray9TextColor,
                                      fontSize: 26.sp),
                                ),
                                SizedBox(height: 20.w,),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 20.w,),
                                Text(
                                  "0",
                                  style: TextStyle(
                                      color: HhColors.textBlackColor,
                                      fontSize: 40.sp,fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10.w,),
                                Text(
                                  "近一周离线",
                                  style: TextStyle(
                                      color: HhColors.gray9TextColor,
                                      fontSize: 26.sp),
                                ),
                                SizedBox(height: 20.w,),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 20.w,),
                                Text(
                                  "0",
                                  style: TextStyle(
                                      color: HhColors.textBlackColor,
                                      fontSize: 40.sp,fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10.w,),
                                Text(
                                  "长期离线",
                                  style: TextStyle(
                                      color: HhColors.gray9TextColor,
                                      fontSize: 26.sp),
                                ),
                                SizedBox(height: 20.w,),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
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
