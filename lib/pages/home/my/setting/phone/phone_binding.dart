import 'package:get/get.dart';
import 'package:iot/pages/home/my/setting/phone/phone_controller.dart';

class PhoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PhoneController());
  }
}
