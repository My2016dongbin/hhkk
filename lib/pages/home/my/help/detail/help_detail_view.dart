import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/pages/home/my/help/detail/help_detail_controller.dart';
import 'package:iot/utils/HhColors.dart';

class HelpDetailPage extends StatelessWidget {
  final logic = Get.find<HelpDetailController>();

  HelpDetailPage({super.key});

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
          color: HhColors.backColorF5,
          padding: EdgeInsets.zero,
          child: Stack(
            children: [
              ///title
              InkWell(
                onTap: (){
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
                  margin: EdgeInsets.only(top:90.w),
                  color: HhColors.trans,
                  child: Text(
                    "帮助与反馈",
                    style: TextStyle(
                        color: HhColors.blackTextColor,
                        fontSize: 30.sp,fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              ///详情
              Container(
                margin: EdgeInsets.fromLTRB(20.w, 180.w, 20.w, 0),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(14.w))
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin:EdgeInsets.fromLTRB(20.w,30.w,20.w,30.w),
                      child: Text(
                        "怎么删除已添加的设备？",
                        style: TextStyle(
                            color: HhColors.textBlackColor,
                            fontSize: 30.sp,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: 1.w,
                      width: 1.sw,
                      color: HhColors.grayEDBackColor,
                      margin:EdgeInsets.fromLTRB(20.w,0,20.w,0),
                    ),
                    Container(
                      margin:EdgeInsets.fromLTRB(20.w,30.w,20.w,50.w),
                      child: Text(
                        "删除已添加的设备应该这样删除已添加的设备应该这样删除已添加的设备应该这样删除已添加的设备应该这样删除已添加的设备应该这样删除已添加的设备应该这样",
                        style: TextStyle(
                            color: HhColors.textBlackColor,
                            fontSize: 26.sp),
                      ),
                    ),
                  ],
                ),
              ),

              logic.index.value==0?const SizedBox():const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
