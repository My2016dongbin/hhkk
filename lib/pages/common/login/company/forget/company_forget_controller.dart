import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/login/company/forget/code/company_code_binding.dart';
import 'package:iot/pages/common/login/company/forget/code/company_code_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyForgetController extends GetxController {
  late BuildContext context;
  final Rx<bool> accountStatus = false.obs;
  final Rx<bool> confirmStatus = false.obs;
  final Rx<bool> testStatus = true.obs;
  TextEditingController? accountController = TextEditingController();
  late String? account;

  @override
  Future<void> onInit() async {

    super.onInit();
  }

  Future<void> getTenantId() async {
    Map<String, dynamic> map = {};
    map['name'] = CommonData.tenantName;
    var tenantResult = await HhHttp().request(
      RequestUtils.tenantId,
      method: DioMethod.get,
      params: map,
    );
    HhLog.d("tenant -- $tenantResult");
    if (tenantResult["code"] == 0 && tenantResult["data"] != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SPKeys().tenant, '${tenantResult["data"]['id']}');
      await prefs.setString(SPKeys().tenantName, CommonData.tenantName!);
      CommonData.tenant = '${tenantResult["data"]['id']}';
      CommonData.tenantName = CommonData.tenantName;
      CommonData.tenantUserType = '${tenantResult["data"]['userType']}';
      await prefs.setString(SPKeys().tenantUserType, CommonData.tenantUserType!);
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString("租户信息不存在"/*tenantResult["msg"]*/),type: 2));
    }
  }

  Future<void> searchTenant() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {};
    map['username'] = accountController!.text;
    var result = await HhHttp().request(
      RequestUtils.tenantSearch,
      method: DioMethod.get,
      params: map
    );
    HhLog.d("searchTenant -- ${RequestUtils.tenantSearch}");
    HhLog.d("searchTenant -- $map");
    HhLog.d("searchTenant -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0 && result["data"] != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SPKeys().tenant, '${result["data"]['id']}');
      CommonData.tenant = '${result["data"]['id']}';
      CommonData.tenantUserType = '${result["data"]['userType']}';
      await prefs.setString(SPKeys().tenantUserType, CommonData.tenantUserType!);
      sendCode();
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"]),type: 2));
    }
  }
  Future<void> sendCode() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    var result = await HhHttp().request(
      RequestUtils.codeSend,
      method: DioMethod.post,
      data: {'mobile':accountController!.text,'scene':24},
    );
    HhLog.d("sendCode -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0 && result["data"] != null) {
      Get.to(()=>CompanyCodePage(accountController!.text),binding: CompanyCodeBinding());
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"]),type: 2));
    }
  }
}
