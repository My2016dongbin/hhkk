import 'package:get/get.dart';

import '../home_controller.dart';
import 'device_controller.dart';

class DeviceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DeviceController());
    Get.lazyPut(() => HomeController());
  }
}
