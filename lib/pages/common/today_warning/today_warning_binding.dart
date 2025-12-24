import 'package:get/get.dart';

import 'today_warning_controller.dart';

class TodayWarningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TodayWarningController());
  }
}
