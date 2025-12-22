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

class ShareManageController extends GetxController {
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
    getTabList();
    super.onInit();
  }

  Future<void> handleShare(String id,int status,String name) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "id":id,
      "status":status,
    };
    var result = await HhHttp().request(RequestUtils.shareHandle,method: DioMethod.post,data: data);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("handleShare -- $result");
    if(result["code"]==0 && result["data"]!=null){
      EventBusUtil.getInstance().fire(HhToast(title: status==2?'操作成功':'“$name”\n已共享至“默认空间”',type: 0,color: 0));
      pageNum = 1;
      shareList(1);
      EventBusUtil.getInstance().fire(SpaceList());
      EventBusUtil.getInstance().fire(DeviceList());
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> getTabList() async {
    spaceList = [];
    spaceList.add({
      'id': -999,
      'name': '全部',
      'status': null,//状态：0待处理 1同意 2拒绝
      'filter': null,
    });
    spaceList.add({
      'id': 1,
      'name': '未操作',
      'status': 0,
      'filter': [0],
    });
    spaceList.add({
      'id': 2,
      'name': '已操作',
      'status': 1,
      'filter': [1,2],
    });
    shareList(1);
  }

  Future<void> shareList(int pageKey) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {};
    map['shareType'] = '2';
    // map['status'] = spaceList[tabIndex.value]["status"];
    map['statusList'] = spaceList[tabIndex.value]["filter"];
    map['pageNo'] = '$pageKey';
    map['pageSize'] = '$pageSize';
    var result = await HhHttp().request(RequestUtils.shareList,method: DioMethod.get,params: map);
    HhLog.d("shareList -- $spaceList");
    HhLog.d("shareList -- $map");
    HhLog.d("shareList -- $result");
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

      if(pageKey == 1){
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
