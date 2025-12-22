import 'package:get/get.dart';

import '../home_controller.dart';
import 'message_controller.dart';

class MessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MessageController());
    Get.lazyPut(() => HomeController());
  }
}
