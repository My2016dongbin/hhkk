import 'package:get/get.dart';
import 'package:iot/pages/common/login/personal/personal_login_controller.dart';

class PersonalLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonalLoginController());
    // Get.lazyPut(() => MainController());
  }
}
