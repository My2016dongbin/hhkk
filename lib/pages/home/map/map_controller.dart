import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';

class MapController extends GetxController {
  final index = 0.obs;
  final Rx<bool> testStatus = true.obs;
  late BuildContext context;
  late AMapController gdMapController;
  final RxSet<Marker> aMapMarkers = <Marker>{}.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  /// 创建完成回调
  void onGDMapCreated(AMapController controller) {
    gdMapController = controller;

    if(CommonData.latitude!=0){
      gdMapController.moveCamera(CameraUpdate.newLatLngZoom(LatLng(CommonData.latitude!,CommonData.longitude!), 14));
    }
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
