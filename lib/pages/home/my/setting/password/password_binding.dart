import 'package:get/get.dart';
import 'package:iot/pages/home/my/setting/password/password_controller.dart';

class PasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PasswordController());
  }
}
