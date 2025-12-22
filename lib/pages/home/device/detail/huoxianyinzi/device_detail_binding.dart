import 'package:get/get.dart';
import 'package:iot/pages/home/device/detail/huoxianyinzi/device_detail_controller.dart';

class HXYZDeviceDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HXYZDeviceDetailController());
  }
}
