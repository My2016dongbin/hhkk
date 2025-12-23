import 'package:get/get.dart';
import 'package:iot/pages/common/login/code/code_controller.dart';
import 'package:iot/pages/common/login/company/company_login_controller.dart';
import 'package:iot/pages/home/video/video_controller.dart';
import 'package:iot/pages/home/message/message_controller.dart';
import 'package:iot/pages/home/my/my_controller.dart';

class CompanyLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CompanyLoginController());
    Get.lazyPut(() => VideoController());
  }
}
