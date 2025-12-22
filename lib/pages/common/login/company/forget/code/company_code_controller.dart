import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/login/company/forget/password/company_password_binding.dart';
import 'package:iot/pages/common/login/company/forget/password/company_password_view.dart';
import 'package:iot/pages/common/login/personal/forget/password/personal_password_binding.dart';
import 'package:iot/pages/common/login/personal/forget/password/personal_password_view.dart';
import 'package:iot/pages/home/home_binding.dart';
import 'package:iot/pages/home/home_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyCodeController extends GetxController {
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
      data: {'mobile':mobile,'scene':24},
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
  Future<void> codeCheck() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    var result = await HhHttp().request(
      RequestUtils.codeCheckCommon,
      method: DioMethod.post,
      data: {'mobile':mobile,'code':code},
    );
    HhLog.d("codeCheck -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0 && result["data"] != null) {

      Get.off(()=>CompanyPasswordPage(),binding: CompanyPasswordBinding(),arguments:{"mobile":mobile});
    } else {
      EventBusUtil.getInstance().fire(HhToast(title: '验证码错误'));
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
