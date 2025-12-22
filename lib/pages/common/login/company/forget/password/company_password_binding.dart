import 'package:get/get.dart';
import 'package:iot/pages/common/login/company/forget/password/company_password_controller.dart';

class CompanyPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CompanyPasswordController());
  }
}
