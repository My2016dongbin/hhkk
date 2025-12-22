import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/location/location_controller.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';

class LocationPage extends StatelessWidget {
  final logic = Get.find<LocationController>();

  LocationPage({super.key});

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
    return Stack(
      children: [
        // Image.asset('assets/images/common/back_login.png',width:1.sw,height: 1.sh,fit: BoxFit.fill,),
        Container(color: HhColors.whiteColor,width: 1.sw,height: 1.sh,),
        ///title
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 90.w),
            color: HhColors.trans,
            child: Text(
              '选择定位',
              style: TextStyle(
                  color: HhColors.blackTextColor,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
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
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: (){
              if(logic.longitude.value == 0.0){
                EventBusUtil.getInstance().fire(HhToast(title: '请选择定位'));
                return;
              }
              Get.back();
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 90.w, 36.w, 0),
              padding: EdgeInsets.fromLTRB(23.w, 8.w, 23.w, 10.w),
              decoration: BoxDecoration(
                color: HhColors.mainBlueColor,
                borderRadius: BorderRadius.all(Radius.circular(8.w),),
              ),
              child: Text(
                '确定',
                style: TextStyle(
                    color: HhColors.whiteColor,
                    fontSize: 26.sp,),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 160.w),
          child: BMFMapWidget(
            onBMFMapCreated: (controller) {
              logic.onBMFMapCreated(controller);
            },
            mapOptions: BMFMapOptions(
                center: BMFCoordinate(CommonData.latitude ?? 36.30865,
                    CommonData.longitude ?? 120.314037),
                zoomLevel: 14,
                mapType: BMFMapType.Standard,
                mapPadding:
                BMFEdgeInsets(left: 30.w, top: 0, right: 30.w, bottom: 0)),
          ),
        ),

        logic.longitude.value==0.0?const SizedBox():Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 1.sw,
            padding: EdgeInsets.fromLTRB(40.w, 30.w, 40.w, 30.w),
            margin: EdgeInsets.fromLTRB(20.w,0,20.w,0),
            decoration: BoxDecoration(
              color: HhColors.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(10.w))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  logic.locText.value
                ),
                SizedBox(height: 20.w,),
                Text(
                  '经度：${logic.longitude.value}'
                ),
                SizedBox(height: 20.w,),
                Text(
                  '纬度：${logic.latitude.value}'
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

}
