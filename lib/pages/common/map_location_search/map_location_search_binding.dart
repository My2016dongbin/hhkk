import 'package:get/get.dart';

import 'map_location_search_controller.dart';

class MapLocationSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MapLocationSearchController());
  }
}
