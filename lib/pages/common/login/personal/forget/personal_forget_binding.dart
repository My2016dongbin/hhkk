import 'package:get/get.dart';
import 'package:iot/pages/common/login/personal/forget/personal_forget_controller.dart';

class PersonalForgetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonalForgetController());
  }
}
