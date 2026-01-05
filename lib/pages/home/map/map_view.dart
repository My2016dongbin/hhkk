import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';

import 'map_controller.dart';

class MapPage extends StatelessWidget {
  final logic = Get.find<MapController>();

  MapPage({super.key});

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
          child: logic.testStatus.value ? modelPage() : const SizedBox(),
        ),
      ),
    );
  }

  modelPage() {
    return Stack(
      children: [
        ///背景-渐变色
        Image.asset(
          "assets/images/common/main_background.png",
          width: 1.sw,
          height: 1.sh,
          fit: BoxFit.fill,
        ),

        ///title
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 47.w*3),
            color: HhColors.trans,
            child: Text(
              '选择地址',
              style: TextStyle(
                  color: HhColors.blackTextColor,
                  fontSize: 18.sp*3,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),

        ///高德地图
        Container(
          height: 1.0.sh - 95.w*3,
          width: 1.sw,
          margin: EdgeInsets.only(top: 90.w*3),
          child: AMapWidget(
            apiKey: CommonData.aMapApiKey,
            privacyStatement: const AMapPrivacyStatement(
                hasContains: true, hasShow: true, hasAgree: true),
            onMapCreated: logic.onGDMapCreated,
            mapType: MapType.satellite,
            tiltGesturesEnabled: true,
            buildingsEnabled: true,
            compassEnabled: true,
            scaleEnabled: true,
            markers: logic.aMapMarkers.toSet(),
            onTap: (LatLng latLng){
              FocusScope.of(Get.context!).requestFocus(FocusNode());

              logic.gdMapController.moveCamera(CameraUpdate.newLatLngZoom(latLng, 16));
              logic.updateMarker(latLng);
            },
            onPoiTouched: (poi){
              FocusScope.of(Get.context!).requestFocus(FocusNode());

              logic.gdMapController.moveCamera(CameraUpdate.newLatLngZoom(poi.latLng!, 16));
              logic.updateMarker(poi.latLng);
            },
          ),
        ),
      ],
    );
  }

}
