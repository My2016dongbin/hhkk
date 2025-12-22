import 'package:get/get.dart';
import 'package:iot/pages/common/share/confirm/confirm_controller.dart';

class ConfirmBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConfirmController());
  }
}
