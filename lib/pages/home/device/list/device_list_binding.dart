import 'package:get/get.dart';

import 'device_list_controller.dart';

class DeviceListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DeviceListController());
  }
}
