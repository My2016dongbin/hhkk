import 'package:get/get.dart';
import 'warning_controller.dart';

class LiveWarningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LiveWarningController());
  }
}
