import 'package:get/get.dart';
import 'package:iot/pages/common/location/location_controller.dart';

import '../home_controller.dart';
import 'space_controller.dart';

class SpaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SpaceController());
    // Get.lazyPut(() => LocationController());
  }
}
