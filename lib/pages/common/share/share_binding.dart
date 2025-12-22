import 'package:get/get.dart';
import 'package:iot/pages/common/share/share_controller.dart';

class ShareBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShareController());
  }
}
