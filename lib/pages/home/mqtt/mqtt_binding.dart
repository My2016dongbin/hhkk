import 'package:get/get.dart';
import 'package:iot/pages/home/mqtt/mqtt_controller.dart';

class MqttBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MqttController());
  }
}
