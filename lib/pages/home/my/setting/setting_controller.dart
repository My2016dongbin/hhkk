import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingController extends GetxController {
  final Rx<bool> testStatus = true.obs;
  final Rx<String> ?mobile = ''.obs;
  late StreamSubscription infoSubscription;

  @override
  Future<void> onInit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    mobile!.value = prefs.getString(SPKeys().mobile)!;

    infoSubscription =
        EventBusUtil.getInstance().on<UserInfo>().listen((event) async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          mobile!.value = prefs.getString(SPKeys().mobile)!;
        });

    super.onInit();
  }
}
