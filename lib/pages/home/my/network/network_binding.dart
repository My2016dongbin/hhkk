import 'package:get/get.dart';
import 'package:iot/pages/home/my/network/network_controller.dart';


class NetWorkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NetWorkController());
  }
}
