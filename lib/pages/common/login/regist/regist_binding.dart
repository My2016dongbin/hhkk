import 'package:get/get.dart';
import 'package:iot/pages/common/login/regist/regist_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterController());
  }
}
