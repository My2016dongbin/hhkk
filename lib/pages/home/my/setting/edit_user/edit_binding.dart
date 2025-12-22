import 'package:get/get.dart';
import 'package:iot/pages/home/my/setting/edit_user/edit_controller.dart';

class EditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditController());
  }
}
