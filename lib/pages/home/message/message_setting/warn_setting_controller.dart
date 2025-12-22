import 'dart:convert';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/model/model_class.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';

class WarnSettingController extends GetxController {
  final Rx<bool> testStatus = true.obs;
  final PagingController<int, dynamic> pagingController = PagingController(firstPageKey: 0);
  late BuildContext context;
  late List<dynamic> spaceList = [];
  late EasyRefreshController easyController = EasyRefreshController();
  final Rx<int> chooseListLeftNumber = 0.obs;

  @override
  void onInit() {
    //获取类型列表
    getWarnType();

    super.onInit();
  }

  Future<void> getWarnType() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    var result = await HhHttp()
        .request(RequestUtils.getAlarmConfig, method: DioMethod.get);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("getWarnType --  $result");
    if (result["code"] == 0) {
      dynamic data = result["data"];
      if(data!=null){
        spaceList = data;
        pagingController.itemList = [];
        pagingController.appendLastPage(spaceList);
        parseChooseNumber();
      }
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  void parseChooseNumber() {
    int number = 0;
    for(dynamic model in spaceList){
      if(model["chose"]==1){
        number++;
      }
    }
    chooseListLeftNumber.value = number;
  }

  Future<void> getWarnTypeOld() async {
    Map<String, dynamic> map = {};
    map['pageNo'] = 1;
    map['pageSize'] = -1;
    map['label'] = "";
    map['dictType'] = "alarm_type";
    var result = await HhHttp()
        .request(RequestUtils.alarmType, method: DioMethod.get,params: map);
    HhLog.d("getWarnType --  $result");
    if (result["code"] == 0) {
      dynamic data = result["data"];
      if(data!=null){
        spaceList = data["list"];
        pagingController.itemList = [];
        pagingController.appendLastPage(spaceList);
      }
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> commitSetting() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true,title: "正在保存.."));
    var result = await HhHttp()
        .request(RequestUtils.saveAlarmConfig, method: DioMethod.post,data: jsonEncode(spaceList));
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("commitSetting --  ${RequestUtils.saveAlarmConfig}");
    HhLog.d("commitSetting --  $spaceList");
    HhLog.d("commitSetting --  $result");
    if (result["code"] == 0) {
      dynamic data = result["data"];
      if(data!=null){
        EventBusUtil.getInstance().fire(WarnList());
        EventBusUtil.getInstance()
            .fire(HhToast(title: "保存成功",type: 1));
      }
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

}
