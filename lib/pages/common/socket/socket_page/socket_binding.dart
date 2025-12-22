import 'package:get/get.dart';
import 'package:iot/pages/common/location/location_controller.dart';
import 'package:iot/pages/common/socket/socket_page/socket_controller.dart';
import 'package:iot/pages/home/my/setting/edit_user/edit_controller.dart';

class SocketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SocketController());
  }
}
