import 'dart:io';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:iot/utils/Utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyController extends GetxController {
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final Rx<bool> testStatus = true.obs;
  late BuildContext context;
  final Rx<String> ?nickname = ''.obs;
  final Rx<String> ?mobile = ''.obs;
  final Rx<String> ?avatar = ''.obs;
  final Rx<int> ?deviceNum = 0.obs;
  final Rx<int> ?spaceNum = 0.obs;
  final Rx<bool> warningVoice = true.obs;
  late StreamSubscription infoSubscription;
  StreamSubscription ?spaceListSubscription;
  late dynamic detail;
  final Rx<double> cache = 0.0.obs;
  final Rx<String> version = ''.obs;

  @override
  Future<void> onInit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    nickname!.value = prefs.getString(SPKeys().nickname)!;
    mobile!.value = prefs.getString(SPKeys().mobile)!;
    avatar!.value = prefs.getString(SPKeys().endpoint)!+prefs.getString(SPKeys().avatar)!;

    spaceListSubscription = EventBusUtil.getInstance()
        .on<SpaceList>()
        .listen((event) {
      getSpaceList();
    });
    infoSubscription =
        EventBusUtil.getInstance().on<UserInfo>().listen((event) async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          nickname!.value = prefs.getString(SPKeys().nickname)!;
          mobile!.value = prefs.getString(SPKeys().mobile)!;
          avatar!.value = prefs.getString(SPKeys().endpoint)!+prefs.getString(SPKeys().avatar)!;
        });
    getSpaceList();
    deviceList();
    getCacheSize();
    getVersion();
    getVoice();
    super.onInit();
  }


  Future<void> getSpaceList() async {
    Map<String, dynamic> map = {};
    map['pageNo'] = '1';
    map['pageSize'] = '100';
    var result = await HhHttp().request(RequestUtils.mainSpaceList,method: DioMethod.get,params: map);
    HhLog.d("getSpaceList $result");
    if(result["code"]==0 && result["data"]!=null){
      try{
        List<dynamic> spaceList = result["data"]["list"];
        spaceNum!.value = spaceList.length;
      }catch(e){
        HhLog.e(e.toString());
      }
    }
  }

  Future<void> deviceList() async {
    Map<String, dynamic> map = {};
    map['pageNo'] = '1';
    map['pageSize'] = '-1';
    map['appSign'] = 1;
    // map['activeStatus'] = '-1';
    var result = await HhHttp().request(RequestUtils.deviceList,method: DioMethod.get,params: map);
    HhLog.d("deviceList $result");
    if(result["code"]==0 && result["data"]!=null){
      try{
        List<dynamic> deviceList = result["data"]["list"];
        deviceNum!.value = deviceList.length;
      }catch(e){
        HhLog.e(e.toString());
      }
    }
  }

  Future<void> getCacheSize() async {
    final tempDir = await getTemporaryDirectory();
    cache.value = await Utils.getTotalSizeOfFilesInDir(tempDir);
    HhLog.d("cache ${cache.value/1000000}");
  }
  Future<void> clearCache() async {
    try {
      final tempDir = await getTemporaryDirectory();
      EventBusUtil.getInstance().fire(HhLoading(show: true));
      await Utils.requestPermission(tempDir);
      EventBusUtil.getInstance().fire(HhLoading(show: false));
      EventBusUtil.getInstance().fire(CatchRefresh());
      EventBusUtil.getInstance().fire(HhToast(title: '已清除缓存',type: 1));
      getCacheSize();
    } catch (err) {
      EventBusUtil.getInstance().fire(HhLoading(show: false));
      EventBusUtil.getInstance().fire(HhToast(title: '缓存清除失败',type: 0));
    }
  }

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version;
    HhLog.d('getVersion ${version.value}');
  }

  Future<void> getVoice() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    warningVoice.value = preferences.getBool(SPKeys().voice)??true;
  }
}
