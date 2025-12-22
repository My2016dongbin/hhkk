import 'package:get/get.dart';
import 'package:iot/pages/home/device/manage/device_manage_controller.dart';

class DeviceManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DeviceManageController());
  }
}
