import 'dart:io';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/model/model_class.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:pinput/pinput.dart';

class DeviceManageController extends GetxController {
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final Rx<bool> tabsTag = true.obs;
  final Rx<int> tabIndex = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final PagingController<int, dynamic> deviceController = PagingController(firstPageKey: 0);
  late int pageNum = 1;
  late int pageSize = 20;
  late List<dynamic> spaceList = [];
  late EasyRefreshController easyController = EasyRefreshController();

  @override
  void onInit() {
    getSpaceList();
    super.onInit();
  }

  void fetchPageDevice(int pageKey) {
    List<Device> newItems = [
      Device("F1-HH160双枪机", "红外报警-光感报警", "", "",true,true),
      Device("F1-HH160双枪机", "红外报警-光感报警", "", "",false,true),
      Device("智能语音卡口", "", "", "",false,false),
      Device("智能语音卡口", "", "", "",false,false),
    ];
    final isLastPage = newItems.length < pageSize;
    if (isLastPage) {
      deviceController.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + newItems.length;
      deviceController.appendPage(newItems, nextPageKey);
    }
  }

  Future<void> getSpaceList() async {
    Map<String, dynamic> map = {};
    map['pageNo'] = '1';
    map['pageSize'] = '100';
    var result = await HhHttp().request(RequestUtils.mainSpaceList,method: DioMethod.get,params: map);
    HhLog.d("getSpaceList -- $result");
    if(result["code"]==0 && result["data"]!=null){
      spaceList = [];
      spaceList.add({
        'id': -999,
        'name': '全部',
        'comment': 123,
        'imgUrl': null,
        'createTime': 1722222436000,
        'contacts': null,
        'contactsPhone': null,
        'deviceCount': 0,
        'alarmCount': 0,
        'longitude': 120.419905,
        'latitude': 36.083425
      });
      spaceList.addAll(result["data"]["list"]);
      tabsTag.value = false;
      tabsTag.value = true;
      deviceList(1);
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> deviceList(int pageKey) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true,title: '设备加载中..'));
    Map<String, dynamic> map = {};
    if(spaceList[tabIndex.value]['id']!=-999){
      map['spaceId'] = spaceList[tabIndex.value]['id'];
    }
    map['pageNo'] = '$pageKey';
    map['pageSize'] = '$pageSize';
    map['appSign'] = 1;
    // map['activeStatus'] = '-1';
    var result = await HhHttp().request(RequestUtils.deviceList,method: DioMethod.get,params: map);
    HhLog.d("deviceList -- $result");
    Future.delayed(const Duration(seconds: 1),(){
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    });
    if(result["code"]==0 && result["data"]!=null){
      List<dynamic> newItems = [];
      try{
        newItems = result["data"]["list"]??[];
      }catch(e){
        HhLog.e(e.toString());
      }

      if(pageNum == 1){
        deviceController.itemList = [];
      }else{
        if(newItems.isEmpty){
          easyController.finishLoad(IndicatorResult.noMore,true);
        }
      }
      deviceController.appendLastPage(newItems);
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
}
