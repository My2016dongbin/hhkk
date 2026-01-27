import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';

class LocationController extends GetxController {
  final index = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final Rx<String> locTitle = '点击地图选择地址'.obs;
  final Rx<String> locDetail = '点击地图选择地址'.obs;
  final Rx<double> locLat = 0.0.obs;
  final Rx<double> locLng = 0.0.obs;
  late BuildContext context;
  late String province = "";
  late String city = "";
  late String district = "";
  late String township = "";
  late AMapController gdMapController;
  final RxSet<Marker> aMapMarkers = <Marker>{}.obs;
  late bool forDynamicParameter = false;
  late String dynamicParameterCode = "";
  dynamic arg;

  @override
  Future<void> onInit() async {
    arg = Get.arguments;
    if(arg!=null){
      forDynamicParameter = arg["forDynamicParameter"]??false;
      dynamicParameterCode = arg["dynamicParameterCode"]??"";

    }
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// 创建完成回调
  void onGDMapCreated(AMapController controller) {
    gdMapController = controller;

    if(CommonData.latitude!=0){
      gdMapController.moveCamera(CameraUpdate.newLatLngZoom(LatLng(CommonData.latitude!,CommonData.longitude!), 14));
    }

    ///初始化地图位置
    if(arg["latitude"]!=null && arg["longitude"]!=null){
      updateMarker(LatLng(arg["latitude"], arg["longitude"]));
      gdMapController.moveCamera(CameraUpdate.newLatLngZoom(LatLng(arg["latitude"], arg["longitude"]), 16));
      searchLocation(arg["longitude"],arg["latitude"]);
    }
  }


  Future<void> searchLocation(lng,lat) async {
    var result = await HhHttp().request(
        "https://restapi.amap.com/v3/geocode/regeo?key=a94a9e0e144b7a5cf77c229713275500&location=$lng,$lat&extensions=all&radius=1000",
        method: DioMethod.get);

    HhLog.d("searchLocation -- $result");
    locDetail.value = result["regeocode"]["formatted_address"];
    locTitle.value = "${result["regeocode"]["addressComponent"]["province"]??""}${result["regeocode"]["addressComponent"]["city"]??""}${result["regeocode"]["addressComponent"]["district"]??""}".replaceAll("[", "").replaceAll("]", "");
    locLat.value = lat;
    locLng.value = lng;
    province = "${result["regeocode"]["addressComponent"]["province"]??""}".replaceAll("[", "").replaceAll("]", "");
    city = "${result["regeocode"]["addressComponent"]["city"]??""}".replaceAll("[", "").replaceAll("]", "");
    district = "${result["regeocode"]["addressComponent"]["district"]??""}".replaceAll("[", "").replaceAll("]", "");
    township = "${result["regeocode"]["addressComponent"]["township"]??""}".replaceAll("[", "").replaceAll("]", "");
  }

  void updateMarker(latLng){
    aMapMarkers.clear();
    Marker mk = Marker(
        anchor: const Offset(0.5,0.5),
        position: latLng,
        icon: BitmapDescriptor.fromIconPath('assets/images/common/icon_blue_loc.png'),
        onTap: (v){
        }
    );
    aMapMarkers.add(mk);
  }

}
