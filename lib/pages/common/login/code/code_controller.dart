import 'package:flutter/cupertino.dart';
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

class CodeController extends GetxController {
  final Rx<bool> testStatus = true.obs;
  late String code = '';
  late BuildContext context;
  late String mobile;
  final Rx<int> time = 60.obs;

  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 1),(){
      // sendCode();
      time.value = 60;
      runCode();
    });
    super.onInit();
  }

  Future<void> sendCode() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true,title: '正在发送短信..'));
    var result = await HhHttp().request(
      RequestUtils.codeSend,
      method: DioMethod.post,
      data: {'mobile':mobile,'scene':21},
    );
    HhLog.d("sendCode -- $result");
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
  Future<void> sendLogin() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true,title: '正在验证..'));
    var result = await HhHttp().request(
      RequestUtils.codeLogin,
      method: DioMethod.post,
      data: {'mobile':mobile,'code':code},
    );
    HhLog.d("sendLogin -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SPKeys().token, result["data"]["accessToken"]);
      CommonData.token = result["data"]["accessToken"];

      info();
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    }
  }

  Future<void> info() async {
    var result = await HhHttp().request(RequestUtils.userInfo,method: DioMethod.get,data: {},);
    HhLog.d("info -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0 && result["data"]!=null){
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SPKeys().endpoint, /*'${result["data"]["endpoint"]}'*/CommonData.endpoint??"");
      await prefs.setString(SPKeys().username, '${result["data"]["username"]}');
      await prefs.setString(SPKeys().nickname, '${result["data"]["nickname"]}');
      await prefs.setString(SPKeys().email, '${result["data"]["email"]}');
      await prefs.setString(SPKeys().mobile, '${result["data"]["mobile"]}');
      await prefs.setString(SPKeys().sex, '${result["data"]["sex"]}');
      await prefs.setString(SPKeys().avatar, '${result["data"]["avatar"]}');
      await prefs.setString(SPKeys().roles, '${result["data"]["roles"]}');
      await prefs.setString(SPKeys().socialUsers, '${result["data"]["socialUsers"]}');
      await prefs.setString(SPKeys().posts, '${result["data"]["posts"]}');

      //验证码登录成功后清除账号密码
      prefs.remove(SPKeys().account);
      prefs.remove(SPKeys().password);

      EventBusUtil.getInstance().fire(HhToast(title: '登录成功',type: 1));

      Future.delayed(const Duration(seconds: 1),(){
        Get.offAll(() => HomePage(),binding: HomeBinding(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 1000));
      });
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"]),type: 2));
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
}
