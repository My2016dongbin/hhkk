import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';

class ShareController extends GetxController {
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  late dynamic arguments = {};
  late BuildContext context;
  final Rx<bool> testStatus = true.obs;
  final Rx<String> codeUrl = ''.obs;
  TextEditingController ?nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    arguments = Get.arguments;

    ///分享二维码信息 shareCreate();
  }


  ///分享二维码信息获取
  Future<void> shareCreate() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    HhLog.d("shareCreate map -- $arguments");
    var shareCreateResult = await HhHttp().request(
      RequestUtils.shareCreate,
      method: DioMethod.post,
      data: arguments
    );
    HhLog.d("shareCreate shareCreateResult -- $shareCreateResult");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (shareCreateResult["code"] == 0 && shareCreateResult["data"] != null) {
      codeUrl.value = shareCreateResult["data"]["qrCodeImage"];
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(shareCreateResult["msg"]),type: 2));
    }
  }

  ///发起分享
  Future<void> shareSend() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "shareType":"2",
      "appReceiveDetailSaveReqVOList":arguments["appShareDetailSaveReqVOList"],
      "username":nameController!.text,
    };
    HhLog.d("shareSend data -- $data");
    var shareCreateResult = await HhHttp().request(
      RequestUtils.shareSend,
      method: DioMethod.post,
      data: data
    );
    HhLog.d("shareSend shareCreateResult -- $shareCreateResult");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (shareCreateResult["code"] == 0 && shareCreateResult["data"] != null) {
      EventBusUtil.getInstance().fire(HhToast(title: '“${arguments["appShareDetailSaveReqVOList"][0]["deviceName"]}”\n已共享',type: 0,color: 0));
      EventBusUtil.getInstance().fire(SpaceList());
      EventBusUtil.getInstance().fire(DeviceList());
    } else {
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(shareCreateResult["msg"]),type: 2));
    }
  }
}
