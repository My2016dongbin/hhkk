import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditController extends GetxController {
  late BuildContext context;
  final Rx<bool> testStatus = true.obs;
  final Rx<bool> pageStatus = false.obs;
  final Rx<bool> accountStatus = false.obs;
  TextEditingController? accountController = TextEditingController();

  @override
  Future<void> onInit() async {
    accountController!.text = Get.arguments["name"];
    super.onInit();
  }

  Future<void> userEdit() async {
    dynamic data = Get.arguments;
    data['name'] = accountController!.text;
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    var tenantResult = await HhHttp().request(
      RequestUtils.spaceUpdate,
      method: DioMethod.put,
      data: data
    );
    HhLog.d("spaceUpdate -- $data");
    HhLog.d("spaceUpdate -- $tenantResult");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (tenantResult["code"] == 0 && tenantResult["data"] != null) {
      EventBusUtil.getInstance().fire(HhToast(title: '修改成功',type: 0));
      EventBusUtil.getInstance().fire(SpaceList());
      Get.back();
    } else {
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(tenantResult["msg"])));
    }
  }

}
