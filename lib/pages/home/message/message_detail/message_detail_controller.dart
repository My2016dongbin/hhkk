import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';

class MessageDetailController extends GetxController {
  final index = 0.obs;
  final Rx<bool> testStatus = true.obs;
  late List<dynamic> typeList = [];
  late String id = "";
  late dynamic fireInfo = {};

  @override
  Future<void> onInit() async {
    if(Get.arguments!=null){
      id = Get.arguments["id"]??"";
    }
    getWarnType();
    getLiveWarningInfo(id);
    super.onInit();
  }


  Future<void> getWarnType() async {
    typeList.clear();
    var result = await HhHttp()
        .request(RequestUtils.getAlarmConfig, method: DioMethod.get);
    HhLog.d("getWarnType --  $result");
    if (result["code"] == 0) {
      dynamic data = result["data"];
      if(data!=null){
        for(dynamic model in data){
          if(model["chose"]==1){
            typeList.add(model);
          }
        }
      }
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }


  Future<void> getLiveWarningInfo(String id) async {
    dynamic param = {
      "id": id,
    };
    var result = await HhHttp()
        .request(RequestUtils.liveWarningInfo, method: DioMethod.get,params: param);
    HhLog.d("liveWarningInfo --  $result");
    if (result["code"] == 0 && result["data"]!=null) {
      fireInfo = result["data"];
      testStatus.value = false;
      testStatus.value = true;
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> alarmHandle(String id, String auditResult) async {
    dynamic data = {
      "id": id,
      "auditResult": auditResult,
    };
    var result = await HhHttp()
        .request(RequestUtils.alarmHandle, method: DioMethod.post,data: data);
    HhLog.d("alarmHandle --  $result");
    if (result["code"] == 0) {
      EventBusUtil.getInstance().fire(HhToast(title: '操作成功',type: 0));
      getLiveWarningInfo(id);
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

}
