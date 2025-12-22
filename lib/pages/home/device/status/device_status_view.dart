import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/home/device/add/device_add_controller.dart';
import 'package:iot/pages/home/device/status/device_status_controller.dart';
import 'package:iot/pages/home/home_binding.dart';
import 'package:iot/pages/home/home_view.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';

class DeviceStatusPage extends StatelessWidget {
  final logic = Get.find<DeviceStatusController>();
  final logicAdd = Get.find<DeviceAddController>();

  DeviceStatusPage({super.key});

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
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 54.w*3),
                  color: HhColors.trans,
                  child: Text(
                    '添加设备',
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

              ///状态图
              Align(
                alignment:Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top:225.w*3),
                  color: HhColors.trans,
                  child: Image.asset(
                    logicAdd.addingStatus.value == 2?"assets/images/common/status_no.png":"assets/images/common/status_yes.png",
                    width: 237.w*3,
                    height: 127.w*3,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top:368.w*3),
                  color: HhColors.trans,
                  child: Text(
                    logicAdd.addingStatus.value == 0?"添加设备中":logicAdd.addingStatus.value == 1?"添加设备成功":"添加设备失败",
                    style: TextStyle(
                        color: HhColors.blackTextColor,
                        fontSize: 18.sp*3,fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              logicAdd.addingStatus.value == 2?Align(
                alignment: Alignment.topCenter,
                child: BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: (){
                      Get.back();
                  },
                  child: Container(
                    height: 44.w*3,
                    width: 168.w*3,
                    margin: EdgeInsets.fromLTRB(14.w*3, 415.w*3, 14.w*3, 25.w*3),
                    decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        border: Border.all(color: HhColors.mainBlueColor,width: 1.w*3),
                        borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
                    child: Center(
                      child: Text(
                        "返回",
                        style: TextStyle(
                          color: HhColors.mainBlueColor,
                          fontSize: 16.sp*3,),
                      ),
                    ),
                  ),
                ),
              ):const SizedBox(),
              ///流程
              logicAdd.addingStatus.value == 2?const SizedBox():Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(136.w*3,412.w*3,0,0),
                  color: HhColors.trans,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      logicAdd.addingStep>0?Image.asset(
                        "assets/images/common/yes.png",
                        width: 14.w*3,
                        height: 14.w*3,
                        fit: BoxFit.fill,
                      ):Image.asset(
                        "assets/images/common/loading.gif",
                        width: 14.w*3,
                        height: 14.w*3,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(width: 8.w,),
                      Text(
                        logicAdd.addingStep>0?"连接设备成功":"连接设备",
                        style: TextStyle(
                            color: HhColors.gray9TextColor,
                            fontSize: 14.sp*3),
                      ),
                    ],
                  ),
                ),
              ),
              logicAdd.addingStatus.value == 2?const SizedBox():Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(136.w*3,442.w*3,0,0),
                  color: HhColors.trans,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      logicAdd.addingStep>1?Image.asset(
                        "assets/images/common/yes.png",
                        width: 14.w*3,
                        height: 14.w*3,
                        fit: BoxFit.fill,
                      ):Image.asset(
                        "assets/images/common/loading.gif",
                        width: 14.w*3,
                        height: 14.w*3,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(width: 8.w,),
                      Text(
                        logicAdd.addingStep>1?"标准认证成功":"标准认证",
                        style: TextStyle(
                            color: HhColors.gray9TextColor,
                            fontSize: 14.sp*3),
                      ),
                    ],
                  ),
                ),
              ),
              logicAdd.addingStatus.value == 2?const SizedBox():Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(136.w*3,472.w*3,0,0),
                  color: HhColors.trans,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      logicAdd.addingStep>2?Image.asset(
                        "assets/images/common/yes.png",
                        width: 14.w*3,
                        height: 14.w*3,
                        fit: BoxFit.fill,
                      ):Image.asset(
                        "assets/images/common/loading.gif",
                        width: 14.w*3,
                        height: 14.w*3,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(width: 8.w,),
                      Text(
                        logicAdd.addingStep>2?"设备绑定账号成功":"设备绑定账号",
                        style: TextStyle(
                            color: HhColors.gray9TextColor,
                            fontSize: 14.sp*3),
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
              ///确定添加按钮
              Align(
                alignment: Alignment.bottomCenter,
                child:
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: (){
                    // Get.to(()=>DeviceListPage(),binding: DeviceListBinding());
                    if(logicAdd.addingStatus.value == 1){
                      Get.offAll(() => HomePage(), binding: HomeBinding());
                    }
                    Get.back();
                  },
                  child: Container(
                    height: 44.w*3,
                    width: 1.sw,
                    margin: EdgeInsets.fromLTRB(14.w*3, 0, 14.w*3, 25.w*3),
                    decoration: BoxDecoration(
                        color: HhColors.mainBlueColor,
                        borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
                    child: Center(
                      child: Text(
                        logicAdd.addingStatus.value==2?"继续添加":"完成",
                        style: TextStyle(
                          color: HhColors.whiteColor,
                          fontSize: 16.sp*3,),
                      ),
                    ),
                  ),
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
