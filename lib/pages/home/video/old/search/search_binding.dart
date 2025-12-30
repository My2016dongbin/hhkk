import 'package:get/get.dart';
import 'package:iot/pages/home/video/old/search/search_controller.dart';


class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchedController());
  }
}
