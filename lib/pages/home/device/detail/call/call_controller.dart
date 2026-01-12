import 'dart:io';

import 'package:draggable_widget/draggable_widget.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/model/model_class.dart';
import 'package:iot/pages/common/socket/WebSocketManager.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallController extends GetxController {
  final index = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final Rx<bool> callStatus = false.obs;
  final Rx<String> name = ''.obs;
  final Rx<String> timeStr = '00:00'.obs;
  final Rx<int> timeLeft = 0.obs;
  final Rx<int> timeRight = 0.obs;
  final Rx<bool> recordTag = false.obs;
  final Rx<bool> voice = true.obs;
  late BuildContext context;
  late Rx<String> deviceNo = ''.obs;
  late String id;
  late int shareMark;
  late String deviceId;
  late String nickname = '';
  late Rx<String> productName = ''.obs;
  FijkPlayer player = FijkPlayer();
  late WebSocketManager manager;
  late String? endpoint;
  late dynamic item = {};

  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 1), () {
      // getDeviceInfo();
    });
    /*callStatus.value = true;
    timer();*/
    super.onInit();
  }

  @override
  void dispose() {
    callStatus.value = false;
    super.dispose();
  }


  Future<void> getDeviceInfo() async {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['shareMark'] = shareMark;
    var result = await HhHttp().request(
        RequestUtils.deviceInfo, method: DioMethod.get, params: map);
    HhLog.d("getDeviceInfo -- $id");
    HhLog.d("getDeviceInfo -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      item = result["data"];
      name.value = CommonUtils().parseNull(result["data"]["name"] ?? '', "");
      productName.value = result["data"]["productName"] ?? '';
    } else {
      EventBusUtil.getInstance().fire(
          HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  String parseDate(date) {
    String s = '$date';
    try {
      DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
      s = format.format(DateTime.fromMillisecondsSinceEpoch(date));
    } catch (e) {
      HhLog.e(e.toString());
    }
    return s;
  }


  Future<void> chatStatus() async {
    Map<String, dynamic> map = {};
    map['deviceNo'] = deviceNo.value;
    var tenantResult = await HhHttp()
        .request(RequestUtils.chatStatus, method: DioMethod.get, params: map);
    HhLog.d("chatStatus socket -- $tenantResult");
    if (tenantResult["code"] == 0 && tenantResult["data"] != null) {
      nickname = tenantResult["data"];
      connect();
      recordTag.value = true;
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(tenantResult["msg"])));
      recordTag.value = false;
      Get.back();
    }
  }

  Future<void> connect() async {
    HhLog.d("socket nickname $nickname");
    /*final channel =
        IOWebSocketChannel.connect('${CommonData.webSocketUrl}$nickname');

    channel.stream.listen((event) {
      HhLog.e("socket listen $nickname -- ${event.toString()}");
    });
    channel.sink.add({"CallType": "Active", "Dest": "000001"});*/

    manager =
    // WebSocketManager('${CommonData.webSocketUrl}$nickname', '');
    WebSocketManager('${CommonData.webSocketUrl}$nickname', '');
    manager.sendMessage({"CallType": "Active", "Dest": deviceNo.value});
    CommonData.deviceNo = deviceNo.value;

    callStatus.value = true;
    timer();
  }

  void chatClose() {
    chatClosePost();
    dynamic o = {"CallType": "Close", "SessionId": CommonData.sessionId};
    // manager.sendMessage(jsonEncode(o));
    manager.sendMessage(o);
    manager.disconnect();
    manager = WebSocketManager('', '');
  }

  Future<void> chatClosePost() async {
    var tenantResult = await HhHttp()
        .request(RequestUtils.chatCreate, method: DioMethod.post, data: {
      "deviceNo": deviceNo.value,
      "state": '0',
      "sessionId": CommonData.sessionId,
    });
    HhLog.d("chatClose socket -- $tenantResult");
    if (tenantResult["code"] == 0 && tenantResult["data"] != null) {
      EventBusUtil.getInstance().fire(HhToast(title: '对讲已结束'));
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(tenantResult["msg"])));
    }
  }

  Future<void> initData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    endpoint = prefs.getString(SPKeys().endpoint);
  }

  void timer() {
    Future.delayed(const Duration(seconds: 1), () {
      try{
        timeRight.value++;
        if(timeRight.value==60){
          timeRight.value = 0;
          timeLeft.value++;
        }
        if(callStatus.value){
          timer();
        }
      }catch(e){
        //
      }
    });
  }

}
