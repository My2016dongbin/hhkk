import 'package:get/get.dart';
import 'package:iot/pages/home/device/status/device_status_controller.dart';
import 'package:iot/pages/home/my/help/detail/help_detail_controller.dart';

class HelpDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HelpDetailController());
  }
}
