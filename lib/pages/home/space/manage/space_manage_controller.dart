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

class SpaceManageController extends GetxController {
  final Rx<bool> testStatus = true.obs;
  final PagingController<int, dynamic> pagingController = PagingController(firstPageKey: 0);
  late int pageNum = 1;
  late int pageSize = 20;
  late BuildContext context;
  late List<dynamic> spaceList = [];
  late List<dynamic> spaceListMax = [];
  StreamSubscription ?spaceListSubscription;
  late EasyRefreshController easyController = EasyRefreshController();

  @override
  void onInit() {
    //获取空间列表
    getSpaceList(1);

    spaceListSubscription = EventBusUtil.getInstance()
        .on<SpaceList>()
        .listen((event) {
          if(event.mode==null){
            pageNum = 1;
            getSpaceList(1);
          }
    });
    super.onInit();
  }

  void fetchPage(int pageKey) {
    List<MainGridModel> newItems = [
      MainGridModel("青岛林场", "https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AAOEhRG.img", "", 10, false),
      MainGridModel("城阳林场", "https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AAOEhRG.img", "", 6, true),
      MainGridModel("高新林场", "https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AAOEhRG.img", "", 8, true),
      MainGridModel("崂山林场", "https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AAOEhRG.img", "", 2, false),
    ];
    final isLastPage = newItems.length < pageSize;
    if (isLastPage) {
      pagingController.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + newItems.length;
      pagingController.appendPage(newItems, nextPageKey);
    }
  }

  Future<void> getSpaceList(int pageKey) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {};
    map['pageNo'] = '$pageKey';
    map['pageSize'] = '$pageSize';
    var result = await HhHttp().request(RequestUtils.getAppDeviceBlock,method: DioMethod.get,params: map);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("getSpaceList -- $map");
    HhLog.d("getSpaceList -- $pageKey,$result");
    if(result["code"]==0 && result["data"]!=null){
      spaceList = result["data"];
      if(spaceList.isNotEmpty){
        spaceListMax = spaceList;
      }

      if(pageKey == 1){
        pagingController.itemList = [];
      }else{
        if(spaceList.isEmpty){
          easyController.finishLoad(IndicatorResult.noMore,true);
        }
      }
      pagingController.appendLastPage(spaceList);
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> deleteChangeSpace(dynamic id,dynamic changeId,dynamic type) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['changeId'] = changeId;
    map['deleteType'] = type;//删除类型:1设备转移后删除 2全部删除
    var result = await HhHttp().request(RequestUtils.deleteChangeSpace,method: DioMethod.delete,params: map);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("deleteChangeSpace -- $map");
    HhLog.d("deleteChangeSpace -- $result");
    if(result["code"]==0 && result["data"]!=null){
      EventBusUtil.getInstance().fire(HhToast(title: '操作成功',type: 0));
      EventBusUtil.getInstance().fire(SpaceList());
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> getDeviceList(dynamic item) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {};
    map['spaceId'] = item['id'];
    map['pageNo'] = '1';
    map['pageSize'] = '100';
    map['appSign'] = 1;
    var result = await HhHttp().request(RequestUtils.getAppDeviceBlock,method: DioMethod.get,params: map);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("deviceList ---   $result");
    if(result["code"]==0 && result["data"]!=null){
      List<dynamic> newItems = [];
      try{
        newItems = result["data"]["list"]??[];
        item['deviceList'] = newItems;
        testStatus.value = false;
        testStatus.value = true;
      }catch(e){
        HhLog.e(e.toString());
      }
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> changeDeviceVisible(dynamic model) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true,title: "正在保存.."));
    var result = await HhHttp().request(RequestUtils.saveAppDeviceBlock,method: DioMethod.post,data: model);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("changeDeviceVisible ---   $model");
    HhLog.d("changeDeviceVisible ---   $result");
    if(result["code"]==0 && result["data"]!=null){
      EventBusUtil.getInstance().fire(HhToast(title: "修改成功",type: 1));
      EventBusUtil.getInstance().fire(SpaceList(mode: "hide"));
      EventBusUtil.getInstance().fire(DeviceList());
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
}
