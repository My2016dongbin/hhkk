import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/common/model/model_class.dart';
import 'package:iot/pages/common/share/share_binding.dart';
import 'package:iot/pages/common/share/share_view.dart';
import 'package:iot/pages/home/device/detail/device_detail_binding.dart';
import 'package:iot/pages/home/device/detail/device_detail_view.dart';
import 'package:iot/pages/home/my/help/detail/help_detail_binding.dart';
import 'package:iot/pages/home/my/help/detail/help_detail_view.dart';
import 'package:iot/pages/home/my/help/help_controller.dart';
import 'package:iot/utils/HhColors.dart';

class HelpPage extends StatelessWidget {
  final logic = Get.find<HelpController>();

  HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              Container(
                margin: EdgeInsets.fromLTRB(20.w, 180.w, 20.w, 30.w),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(14.w))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 30.w,),
                    Container(
                      margin: EdgeInsets.fromLTRB(40.w, 20.w, 0, 0),
                      child: Text(
                        '常见问题',
                        style: TextStyle(
                            color: HhColors.blackTextColor, fontSize: 32.sp,fontWeight: FontWeight.bold),
                      ),
                    ),
                    ///tab
                    Container(
                      margin: EdgeInsets.fromLTRB(30.w, 36.w, 0, 0),
                      child: SingleChildScrollView(
                        child: Row(
                          children: [
                            Column(
                              children: [
                                BouncingWidget(
                                  duration: const Duration(milliseconds: 100),
                                  scaleFactor: 1.2,
                                  onPressed: (){
                                    logic.tabIndex.value = 0;
                                  },
                                  child: Text(
                                    '热门问题',
                                    style: TextStyle(
                                        color: logic.tabIndex.value==0?HhColors.mainBlueColor:HhColors.gray9TextColor, fontSize: logic.tabIndex.value==0?32.sp:26.sp,fontWeight: logic.tabIndex.value==0?FontWeight.bold:FontWeight.w200),
                                  ),
                                ),
                                SizedBox(height: 5.w,),
                                logic.tabIndex.value==0?Container(
                                  height: 4.w,
                                  width: 26.w,
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(Radius.circular(2.w))
                                  ),
                                ):const SizedBox()
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 30.w),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  BouncingWidget(
                                    duration: const Duration(milliseconds: 100),
                                    scaleFactor: 1.2,
                                    onPressed: (){
                                      logic.tabIndex.value = 1;
                                    },
                                    child: Text(
                                      '连接设备',
                                      style: TextStyle(
                                          color: logic.tabIndex.value==1?HhColors.mainBlueColor:HhColors.gray9TextColor, fontSize: logic.tabIndex.value==1?32.sp:26.sp,fontWeight: logic.tabIndex.value==1?FontWeight.bold:FontWeight.w200),
                                    ),
                                  ),
                                  SizedBox(height: 5.w,),
                                  logic.tabIndex.value==1?Container(
                                    height: 4.w,
                                    width: 26.w,
                                    decoration: BoxDecoration(
                                        color: HhColors.mainBlueColor,
                                        borderRadius: BorderRadius.all(Radius.circular(2.w))
                                    ),
                                  ):const SizedBox()
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 30.w),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  BouncingWidget(
                                    duration: const Duration(milliseconds: 100),
                                    scaleFactor: 1.2,
                                    onPressed: (){
                                      logic.tabIndex.value = 2;
                                    },
                                    child: Text(
                                      '网络异常',
                                      style: TextStyle(
                                          color: logic.tabIndex.value==2?HhColors.mainBlueColor:HhColors.gray9TextColor, fontSize: logic.tabIndex.value==2?32.sp:26.sp,fontWeight: logic.tabIndex.value==2?FontWeight.bold:FontWeight.w200),
                                    ),
                                  ),
                                  SizedBox(height: 5.w,),
                                  logic.tabIndex.value==2?Container(
                                    height: 4.w,
                                    width: 26.w,
                                    decoration: BoxDecoration(
                                        color: HhColors.mainBlueColor,
                                        borderRadius: BorderRadius.all(Radius.circular(2.w))
                                    ),
                                  ):const SizedBox()
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ///列表
                    logic.testStatus.value?deviceList():const SizedBox()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  deviceList() {
    return Expanded(
      child: PagedListView<int, Device>(
        pagingController: logic.deviceController,
        builderDelegate: PagedChildBuilderDelegate<Device>(
          itemBuilder: (context, item, index) => InkWell(
                onTap: (){
                  Get.to(()=>HelpDetailPage(),binding: HelpDetailBinding());
                },
                child: Container(
                  height:100.w,
                  color: HhColors.trans,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin:EdgeInsets.only(left: 20.w),
                          child: Text(
                            "${item.name}",
                            style: TextStyle(
                                color: HhColors.textBlackColor,
                                fontSize: 28.sp),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin:EdgeInsets.fromLTRB(0,6.w,30.w,0),
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
                        child: Container(
                          height: 1.w,
                          width: 1.sw,
                          color: HhColors.grayEDBackColor,
                          margin:EdgeInsets.fromLTRB(20.w,10.w,20.w,10.w),
                        ),
                      )
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
