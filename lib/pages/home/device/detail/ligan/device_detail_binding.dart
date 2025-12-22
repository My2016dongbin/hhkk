import 'package:get/get.dart';
import 'package:iot/pages/home/device/detail/ligan/device_detail_controller.dart';

class LiGanDeviceDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LiGanDeviceDetailController());
  }
}
