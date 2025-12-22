import 'package:get/get.dart';
import 'package:iot/pages/common/login/personal/forget/password/personal_password_controller.dart';

class PersonalPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonalPasswordController());
  }
}
