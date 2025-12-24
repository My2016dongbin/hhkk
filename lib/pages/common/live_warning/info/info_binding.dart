import 'package:get/get.dart';
import 'package:iot/pages/common/live_warning/info/info_controller.dart';

class WarningInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WarningInfoController());
  }
}
