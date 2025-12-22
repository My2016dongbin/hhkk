import 'package:get/get.dart';
import 'package:iot/pages/home/message/message_setting/warn_setting_controller.dart';

class WarnSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WarnSettingController());
  }
}
