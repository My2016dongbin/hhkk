import 'package:get/get.dart';
import 'package:iot/pages/home/device/detail/huoxianyinzi/energy_more/hxyz_energy_more_controller.dart';

class HXYZEnergyMoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HXYZEnergyMoreController());
  }
}
