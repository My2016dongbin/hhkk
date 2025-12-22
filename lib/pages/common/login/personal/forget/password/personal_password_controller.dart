import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/login/personal/forget/code/personal_code_binding.dart';
import 'package:iot/pages/common/login/personal/forget/code/personal_code_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalPasswordController extends GetxController {
  late BuildContext context;
  final Rx<bool> confirmStatus = false.obs;
  final Rx<bool> testStatus = true.obs;
  final Rx<bool> passwordStatus = false.obs;
  final Rx<bool> passwordShowStatus = false.obs;
  final Rx<bool> password2Status = false.obs;
  final Rx<bool> password2ShowStatus = false.obs;
  TextEditingController? passwordController = TextEditingController();
  TextEditingController? password2Controller = TextEditingController();
  late String? account;
  late dynamic argument;
  late String mobile;

  @override
  Future<void> onInit() async {
    argument = Get.arguments;
    mobile = argument["mobile"];
    super.onInit();
  }

  Future<void> submit() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      'password':passwordController!.text,
      'mobile':mobile,
    };
    var result = await HhHttp().request(
      RequestUtils.putBackPassword,
      method: DioMethod.put,
      data: data,
    );
    HhLog.d("submit -- ${RequestUtils.putBackPassword}");
    HhLog.d("submit -- $data");
    HhLog.d("submit -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0 && result["data"] != null) {
      EventBusUtil.getInstance().fire(HhToast(title: "密码设置成功",type: 1));
      //密码设置成功后清除账号密码
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(SPKeys().account);
      prefs.remove(SPKeys().password);
      CommonUtils().toLogin();
    } else {
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"]),type: 2));
    }
  }
}
