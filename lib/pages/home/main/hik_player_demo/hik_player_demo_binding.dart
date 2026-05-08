import 'package:get/get.dart';
import 'package:iot/pages/home/main/hik_player_demo/hik_player_demo_controller.dart';

class HikPlayerDemoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HikPlayerDemoController());
  }
}
