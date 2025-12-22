import 'package:get/get.dart';
import 'package:iot/pages/common/location/search/saerch_controller.dart';

class SearchLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchLocationController());
  }
}
