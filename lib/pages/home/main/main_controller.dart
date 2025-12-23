import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/Permissions.dart';
import 'package:iot/utils/RequestUtils.dart';

class MainController extends GetxController {
  final Rx<bool> pageStatus = true.obs;
  late BuildContext context;
  final Rx<int> ?highPointNum = 0.obs;
  final Rx<int> ?kaKouNum = 0.obs;
  final Rx<int> ?droneNum = 0.obs;
  final Rx<int> ?deviceAllNum = 0.obs;
  final Rx<int> ?deviceOnlineNum = 0.obs;
  final Rx<double> ?deviceOnlineRatio = 0.0.obs;
  final Rx<int> ?deviceOfflineNum = 0.obs;
  final Rx<bool> fireLevelByGridOrStation = true.obs;
  //fireLevelIndex 0五级火险   1四级火险   2三级火线   3二级火险   4一级火险
  final Rx<int> fireLevelIndex = 0.obs;
  StreamSubscription ?fireMessageSubscription;
  StreamSubscription ?fireWarningSubscription;
  StreamSubscription ?messageSubscription;
  final Rx<int> ?headerIndex = 0.obs;
  final RxList<String> ?headerList = ["assets/images/common/iot/main_image.png"].obs;
  late List<dynamic> menuList = [];
  final RxList<dynamic> fireLevelList = [].obs;
  final PageController menuPageController = PageController();
  final Rx<int> currentMenuPage = 0.obs;
  late Rx<int> menuPageCount = 1.obs;
  late Rx<String> messageCount = "0".obs;
  late Rx<String> appLoc = "青岛市市北区万科大厦C座".obs;
  late Rx<bool> warnManageNoRead = false.obs;
  late Rx<bool> fireWarnNoRead = true.obs;
  late int menuCountInPage = 12;
  late List<dynamic> fireLevelByGridList = [{},{},{},{},{}];
  late List<dynamic> fireLevelByStationList = [{},{},{},{},{}];
  late Rx<String> gridName = "".obs;
  late Rx<String> levelName = "".obs;

  @override
  Future<void> onInit() async {
    messageSubscription = EventBusUtil.getInstance()
        .on<Message>()
        .listen((event) {
      getWarnCount();
    });
    getWarnCount();
    getMenuList();
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
}
