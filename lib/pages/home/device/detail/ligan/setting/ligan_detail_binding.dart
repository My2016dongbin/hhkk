import 'package:get/get.dart';
import 'package:iot/pages/home/device/detail/ligan/setting/ligan_detail_controller.dart';

class LiGanDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LiGanDetailController());
  }
}
