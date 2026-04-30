import 'package:get/get.dart';
import 'package:iot/pages/home/device/detail/ligan/energy_more/ligan_energy_more_controller.dart';

class LiGanEnergyMoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LiGanEnergyMoreController());
  }
}
