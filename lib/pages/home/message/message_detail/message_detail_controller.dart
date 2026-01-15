import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/map_location_search/map_location_search_binding.dart';
import 'package:iot/pages/common/map_location_search/map_location_search_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';

class MessageDetailController extends GetxController {
  final index = 0.obs;
  final Rx<bool> testStatus = true.obs;
  late List<dynamic> typeList = [];
  late String id = "";
  late dynamic fireInfo = {};
  late AMapController gdMapController;
  final RxSet<Marker> aMapMarkers = <Marker>{}.obs;

  @override
  Future<void> onInit() async {
    if(Get.arguments!=null){
      id = Get.arguments["id"]??"";
    }
    getWarnType();
    getLiveWarningInfo(id);
    super.onInit();
  }

  /// 创建完成回调
  void onGDMapCreated(AMapController controller) {
    gdMapController = controller;

    if(CommonData.latitude!=null && CommonData.latitude!=0){
      gdMapController.moveCamera(CameraUpdate.newLatLngZoom(LatLng(CommonData.latitude!,CommonData.longitude!), 12));
    }
  }


  Future<void> getWarnType() async {
    typeList.clear();
    var result = await HhHttp()
        .request(RequestUtils.getAlarmConfig, method: DioMethod.get);
    HhLog.d("getWarnType --  $result");
    if (result["code"] == 0) {
      dynamic data = result["data"];
      if(data!=null){
        for(dynamic model in data){
          if(model["chose"]==1){
            typeList.add(model);
          }
        }
      }
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }


  Future<void> getLiveWarningInfo(String id) async {
    dynamic param = {
      "id": id,
    };
    var result = await HhHttp()
        .request(RequestUtils.liveWarningInfo, method: DioMethod.get,params: param);
    HhLog.d("liveWarningInfo --  $result");
    if (result["code"] == 0 && result["data"]!=null) {
      fireInfo = result["data"];
      testStatus.value = false;
      testStatus.value = true;
      updateMarker();
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  void updateMarker(){
    aMapMarkers.clear();
    ///设备打点
    try{
      LatLng latLng = LatLng(double.parse("${fireInfo["latitude"]}"),double.parse("${fireInfo["longitude"]}"));
      Marker mk = Marker(
          anchor: const Offset(0.5, 1.0),
          position: latLng,
          icon: BitmapDescriptor.fromIconPath("${fireInfo["status"]}"=="1"?'assets/images/common/ic_device_online2.png':'assets/images/common/ic_device_offline2.png'),
          onTap: (v){
            gdMapController.moveCamera(CameraUpdate.newLatLngZoom(latLng, 12));
            Get.to(
                    () => MapLocationSearchPage(),
                binding: MapLocationSearchBinding(),
                arguments: {
                  "name": CommonUtils().parseNull("${fireInfo['deviceName']}", "")
                });
          }
      );
      aMapMarkers.add(mk);
      gdMapController.moveCamera(CameraUpdate.newLatLngZoom(latLng, 12));
    }catch(e){
      HhLog.e("$e");
    }

  }

  Future<void> alarmHandle(String id, String auditResult) async {
    dynamic data = {
      "id": id,
      "auditResult": auditResult,
    };
    var result = await HhHttp()
        .request(RequestUtils.alarmHandle, method: DioMethod.post,data: data);
    HhLog.d("alarmHandle --  $result");
    if (result["code"] == 0) {
      EventBusUtil.getInstance().fire(HhToast(title: '操作成功',type: 0));
      getLiveWarningInfo(id);
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

}
