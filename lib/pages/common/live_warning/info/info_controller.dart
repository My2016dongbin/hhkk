import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WarningInfoController extends GetxController {
  final index = 0.obs;
  final Rx<bool> testStatus = true.obs;
  late List<String> imageVideos = [];
  late List<String> uploadImageVideos = [];
  final Rx<bool> picture = false.obs;
  late dynamic detail = {
    "content":{},
  };
  late BuildContext context;
  final RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  Future<void> onInit() async {
    if(Get.arguments!=null){
      detail = Get.arguments['info'];
      testStatus.value = false;
      testStatus.value = true;
    }

    super.onInit();
  }

}
