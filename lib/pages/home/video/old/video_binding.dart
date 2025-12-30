import 'package:get/get.dart';
import 'package:iot/pages/home/home_controller.dart';
import 'package:iot/pages/home/message/message_controller.dart';

import 'video_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VideoController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => MessageController());
  }
}
