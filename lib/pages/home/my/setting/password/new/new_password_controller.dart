import 'package:flutter/cupertino.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/home/home_binding.dart';
import 'package:iot/pages/home/home_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewPasswordController extends GetxController {
  late BuildContext context;
  final Rx<bool> testStatus = true.obs;
  final Rx<bool> pageStatus = false.obs;
  final Rx<bool> passwordStatus = false.obs;
  final Rx<bool> passwordShowStatus = false.obs;
  final Rx<bool> passwordNew1Status = false.obs;
  final Rx<bool> passwordShowNew1Status = false.obs;
  final Rx<bool> passwordNew2Status = false.obs;
  final Rx<bool> passwordShowNew2Status = false.obs;
  final Rx<bool> confirmStatus = false.obs;
  final Rx<String> titles = ''.obs;
  TextEditingController? passwordController = TextEditingController();
  TextEditingController? passwordNew1Controller = TextEditingController();
  TextEditingController? passwordNew2Controller = TextEditingController();
  late String? tenantName;
  late String? keys;
  late String? values;
  final Rx<int> time = 0.obs;
  final Rx<String> mobile = ''.obs;
  final Rx<String> password = ''.obs;

  @override
  Future<void> onInit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    mobile.value = prefs.getString(SPKeys().mobile)!;
    password.value = prefs.getString(SPKeys().password)!;
    // passwordController!.text = mobile.value;
    super.onInit();
  }

  Future<void> sendCode() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true,title: '正在发送短信..'));
    var result = await HhHttp().request(
      RequestUtils.codeRegisterSend,
      method: DioMethod.post,
      data: {'mobile':passwordController!.text,'scene':24},
    );
    HhLog.d("codeRegisterSend -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0 && result["data"] != null) {
      time.value = 60;
      runCode();
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
      time.value = 0;
    }
  }

  Future<void> judgeCode() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true, title: '正在保存..'));
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    var result = await HhHttp().request(
      RequestUtils.codeCheckCommon,
      method: DioMethod.post,
      data: {'mobile':passwordController!.text,'code':passwordNew1Controller!.text},
    );
    HhLog.d("codeCheck -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0 && result["data"] != null) {
      Future.delayed(const Duration(milliseconds: 500),(){
        values = passwordNew2Controller!.text;
        userEdit();
      });
    } else {
      EventBusUtil.getInstance().fire(HhToast(title: '验证码错误'));
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    }
  }

  void runCode() {
    Future.delayed(const Duration(seconds: 1),(){
      time.value--;
      if(time.value > 0){
        runCode();
      }else{

      }
    });
  }

  Future<void> userEdit() async {
    var tenantResult = await HhHttp().request(
      RequestUtils.password,
      method: DioMethod.put,
      data: {
        "oldPassword":password.value,
        "newPassword":passwordNew2Controller!.text,
      }
    );
    HhLog.d("userEdit -- $tenantResult");
    if (tenantResult["code"] == 0 && tenantResult["data"] != null) {
      info();
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(tenantResult["msg"])));
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    }
  }


  Future<void> info() async {
    var result = await HhHttp().request(
      RequestUtils.userInfo,
      method: DioMethod.get,
      data: {},
    );
    HhLog.d("info -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0 && result["data"] != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SPKeys().password, passwordNew2Controller!.text);
      await prefs.setString(SPKeys().endpoint, /*'${result["data"]["endpoint"]}'*/CommonData.endpoint??"");
      await prefs.setString(SPKeys().id, '${result["data"]["id"]}');
      await prefs.setString(SPKeys().username, '${result["data"]["username"]}');
      await prefs.setString(SPKeys().nickname, '${result["data"]["nickname"]}');
      await prefs.setString(SPKeys().email, '${result["data"]["email"]}');
      await prefs.setString(SPKeys().mobile, '${result["data"]["mobile"]}');
      await prefs.setString(SPKeys().sex, '${result["data"]["sex"]}');
      await prefs.setString(SPKeys().avatar, '${result["data"]["avatar"]}');
      await prefs.setString(SPKeys().roles, '${result["data"]["roles"]}');
      await prefs.setString(
          SPKeys().socialUsers, '${result["data"]["socialUsers"]}');
      await prefs.setString(SPKeys().posts, '${result["data"]["posts"]}');

      EventBusUtil.getInstance().fire(UserInfo());

      EventBusUtil.getInstance().fire(HhToast(title: '修改成功',type: 1));
      Get.back();
    } else {
      // EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
}
