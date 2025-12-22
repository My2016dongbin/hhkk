import 'package:get/get.dart';
import 'package:iot/pages/home/device/detail/device_detail_controller.dart';
import 'package:iot/pages/home/device/detail/yunweixiang/yunwei_detail_controller.dart';
import 'package:iot/pages/home/device/status/device_status_controller.dart';

class YunWeiDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => YunWeiDetailController());
  }
}
