import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/Permissions.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';

class MainController extends GetxController {
  final Rx<bool> pageStatus = true.obs;
  late BuildContext context;
  final Rx<int> ?deviceAllNum = 0.obs;
  final Rx<int> ?deviceOnlineNum = 0.obs;
  final Rx<int> ?deviceOfflineNum = 0.obs;
  final Rx<int> ?deviceOnlineRatio = 0.obs;
  //fireLevelIndex 5五级火险   4四级火险   3三级火线   2二级火险   1一级火险
  final Rx<int> fireLevelIndex = 5.obs;
  StreamSubscription ?fireMessageSubscription;
  StreamSubscription ?fireWarningSubscription;
  StreamSubscription ?messageSubscription;
  final Rx<int> ?headerIndex = 0.obs;
  final RxList<String> ?headerList = ["assets/images/common/main_image.png"].obs;
  late List<dynamic> menuList = [];
  final RxList<dynamic> liveWarningList = [].obs;
  final RxList<dynamic> fireLevelList = [].obs;
  final PageController menuPageController = PageController();
  final Rx<int> currentMenuPage = 0.obs;
  late Rx<int> menuPageCount = 1.obs;
  late Rx<String> messageCount = "0".obs;
  late Rx<String> appLoc = "青岛市城阳区物联网产业园".obs;
  late Rx<bool> warnManageNoRead = false.obs;
  late Rx<bool> fireWarnNoRead = true.obs;
  late int menuCountInPage = 4;
  late List<int> fireLevelByStationList = [0,0,0,0,0];
  late Rx<String> gridName = "".obs;
  late Rx<String> levelName = "".obs;

  final PagingController<int, dynamic> deviceController = PagingController(firstPageKey: 1);
  final ScrollController deviceScrollController = ScrollController();
  late EasyRefreshController deviceEasyController = EasyRefreshController();
  final Rx<int> deviceStatus = 2.obs;//2全部设备  1在线  0离线
  late int devicePageNo = 1;
  late List<dynamic> typeList = [
    {
      "alarmName":"类型",
      "alarmType":null,
    },
  ];
  final TooltipController handleController = TooltipController();

  @override
  Future<void> onInit() async {
    messageSubscription = EventBusUtil.getInstance()
        .on<Message>()
        .listen((event) {
      getWarnCount();
    });
    getWarnCount();
    getMenuList();
    getDeviceStatistics();
    getFireLevelStatistics();
    getFireLevelList();
    getLiveWarningList();
    getWarnType();
    super.onInit();
  }

  @override
  Future<void> onClose() async {
    try{
      fireMessageSubscription?.cancel();
      fireWarningSubscription?.cancel();
      messageSubscription?.cancel();
    }catch(e){
      //
    }
    super.onClose();
  }

  Future<void> getMenuList() async {
    menuList.clear();
    if(Permissions.hasPermission(Permissions.mainWarnManage)){
      menuList.add(
          {
            "title":"智慧立杆",
            "image":"assets/images/common/menu_video.png",
            "route":"/warnManage",
            "unRead":warnManageNoRead.value,
          }
      );
    }
    if(Permissions.hasPermission(Permissions.mainWarnManage)){
      menuList.add(
          {
            "title":"火险因子",
            "image":"assets/images/common/menu_fire.png",
            "route":"/warnManage",
            "unRead":warnManageNoRead.value,
          }
      );
    }
    if(Permissions.hasPermission(Permissions.mainWarnManage)){
      menuList.add(
          {
            "title":"报警管理",
            "image":"assets/images/common/menu_fire_manage.png",
            "route":"/warnManage",
            "unRead":warnManageNoRead.value,
          }
      );
    }
    if(Permissions.hasPermission(Permissions.mainWarnManage)){
      menuList.add(
          {
            "title":"全部设备",
            "image":"assets/images/common/menu_all_device.png",
            "route":"/warnManage",
            "unRead":warnManageNoRead.value,
          }
      );
    }

    menuPageCount.value = (menuList.length / menuCountInPage).ceil();
  }

  Future<void> getWarnCount() async {
    var result = await HhHttp()
        .request(RequestUtils.unReadCountWarn, method: DioMethod.get);
    HhLog.d("getWarnCount --  $result");
    if (result["code"] == 200) {
      int number = result["data"]??0;
      messageCount.value = number>99?"99+":"$number";
    } else {
      //EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }


  Future<void> getDeviceStatistics() async {
    var result = await HhHttp().request(
      RequestUtils.statistics,
      method: DioMethod.get,
    );
    HhLog.d("statistics -- $result");
    if (result["data"] != null) {

      deviceAllNum!.value = result["data"]["count"];
      deviceOnlineNum!.value = result["data"]["online"];
      deviceOfflineNum!.value = result["data"]["offline"];

    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"]),type: 2));
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    }
  }


  Future<void> getFireLevelStatistics() async {
    var result = await HhHttp().request(
      RequestUtils.fireLevelStatistics,
      method: DioMethod.get,
    );
    HhLog.d("getFireLevelStatistics -- $result");
    if (result["data"] != null) {
      for (int i = 0; i < result["data"].length; i++) {
        dynamic model = result["data"][i];
        if("${model["fireLevel"]}" == "1"){
          fireLevelByStationList[4] = model["count"];
        }
        if("${model["fireLevel"]}" == "2"){
          fireLevelByStationList[3] = model["count"];
        }
        if("${model["fireLevel"]}" == "3"){
          fireLevelByStationList[2] = model["count"];
        }
        if("${model["fireLevel"]}" == "4"){
          fireLevelByStationList[1] = model["count"];
        }
        if("${model["fireLevel"]}" == "5"){
          fireLevelByStationList[0] = model["count"];
        }
      }
    } else {
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"]),type: 2));
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    }
  }

  Future<void> getFireLevelList() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    var result = await HhHttp().request(
      RequestUtils.fireLevelList,
      method: DioMethod.get,
      params: {
        "pageNo":"1",
        "pageSize":"100",
        "fireLevel":"${fireLevelIndex.value}",
      }
    );
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("getFireLevelList -- $result");
    fireLevelList.value = [];
    if (result["data"] != null && result["data"]["list"] != null) {
      fireLevelList.value = result["data"]["list"];
    } else {
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"]),type: 2));
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    }
  }


  Future<void> getLiveWarningList() async {
    String now = CommonUtils().parseLongTimeYearDay("${DateTime.now().millisecondsSinceEpoch}");
    var result = await HhHttp().request(
      RequestUtils.liveWarningList,
      method: DioMethod.get,
      params: {
        "pageNum":1,
        "pageSize":4,
        "createTime":"$now 00:00:00,$now 23:59:59",
      }
    );
    HhLog.d("getLiveWarningList -- $result");
    if (result["data"] != null) {
      deviceOnlineRatio!.value = result["data"]["total"]??0;

      liveWarningList.value = result["data"]["list"]??[];

    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"]),type: 2));
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    }
  }

  String parseLevelName(String level) {
    String levelName = "";
    if(level == "1"){
      levelName = "一级火险";
    }
    if(level == "2"){
      levelName = "二级火险";
    }
    if(level == "3"){
      levelName = "三级火险";
    }
    if(level == "4"){
      levelName = "四级火险";
    }
    if(level == "5"){
      levelName = "五级火险";
    }
    return levelName;
  }

  Future<String> getGeoGridLocation(String grid) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    var result = await HhHttp().request(
        "https://restapi.amap.com/v3/geocode/geo?address=$grid&key=a94a9e0e144b7a5cf77c229713275500",
        method: DioMethod.get);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result!=null && result["geocodes"]!=null && result["geocodes"].length>0){
      dynamic geoModel = result["geocodes"][0];
      return "${geoModel["location"]}";
    }

    return "";
  }

  Future<void> mainDeviceList() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic params = {
      "pageNo":devicePageNo,
      "pageSize":100,
      "status":deviceStatus.value==2?null:deviceStatus.value,
      "activeStatus":1,
    };
    var result = await HhHttp().request(
      RequestUtils.mainDeviceList,
      method: DioMethod.get,
      params: params,
    );
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("mainDeviceList -- $params");
    HhLog.d("mainDeviceList -- $result");
    if (result["data"] != null && result["data"]["list"] != null) {
      if(devicePageNo == 1){
        deviceController.itemList = [];
      }
      deviceController.appendLastPage(result["data"]["list"]);
    } else {
      deviceController.itemList = [];
      devicePageNo = 1;
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"]),type: 2));
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    }


    /*await Future.delayed(const Duration(milliseconds: 2000),(){
      EventBusUtil.getInstance().fire(HhLoading(show: false));
      deviceController.itemList = [
        {
          "name":"北港沟庄户北坡",
          "createTime":"2025-10-10 12:12:12",
          "offlineTime":"离线10天以上",
        },
        {
          "name":"曹家铺小龙潭",
          "createTime":"2025-10-10 12:12:12",
          "offlineTime":"离线10天以上",
        },
        {
          "name":"摘唐山莲花坑",
          "createTime":"2025-10-10 12:12:12",
          "offlineTime":"离线10天",
        },
      ];
      deviceController.appendLastPage([]);
    });*/
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

  Future<void> alarmHandle(String id, String auditResult) async {
    dynamic data = {
      "id": id,
      "auditResult": auditResult,
    };
    var result = await HhHttp()
        .request(RequestUtils.alarmHandle, method: DioMethod.post,data: data);
    HhLog.d("alarmHandle --  $result");
    if (result["code"] == 0) {
      getLiveWarningList();
      Get.back();
      EventBusUtil.getInstance().fire(HhToast(title: '操作成功',type: 0));
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
    if (result["code"] == 0) {

    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }


}
