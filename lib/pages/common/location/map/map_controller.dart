import 'package:flutter/cupertino.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/home/home_binding.dart';
import 'package:iot/pages/home/home_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapController extends GetxController {
  late BuildContext context;
  final Rx<bool> testStatus = true.obs;
  final Rx<bool> pageStatus = false.obs;
  final Rx<bool> mapStatus = true.obs;
  final Rx<double> longitude = 0.0.obs;
  final Rx<double> latitude = 0.0.obs;
  // BMFMapController ?controller;

  @override
  Future<void> onInit() async {
    // runToast();
    super.onInit();
  }

  void onBMFMapCreated(BMFMapController controller_) {
    // controller = controller_;
  }

  @override
  void dispose() {
    // controller!
    mapStatus.value = false;
    super.dispose();
  }

  @override
  void onClose() {
    // 在这里释放资源
    print("DetailController 被释放");
    super.onClose();
  }

  void runToast() {
    EventBusUtil.getInstance().fire(HhToast(title: 'map'));
    Future.delayed(const Duration(milliseconds: 2000),(){
      runToast();
    });
  }
}
