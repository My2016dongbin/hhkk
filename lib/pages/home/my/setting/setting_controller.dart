import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:iot/utils/Utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingController extends GetxController {
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final Rx<double> cache = 0.0.obs;
  final Rx<String> version = ''.obs;
  final Rx<String> ?nickname = ''.obs;
  final Rx<String> ?account = ''.obs;
  final Rx<String> ?tenantTitle = ''.obs;
  final Rx<String> ?mobile = ''.obs;
  final Rx<String> ?email = ''.obs;
  final Rx<String> ?avatar = ''.obs;
  final Rx<bool> picture = false.obs;
  late XFile file;
  late BuildContext context;
  late StreamSubscription infoSubscription;

  @override
  Future<void> onInit() async {
    getCacheSize();
    getVersion();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    nickname!.value = prefs.getString(SPKeys().nickname)!;
    account!.value = prefs.getString(SPKeys().username)!;
    if(!CommonData.personal){
      tenantTitle!.value = prefs.getString(SPKeys().tenantTitle)!;
    }
    HhLog.d("tenantTitle ");
    mobile!.value = prefs.getString(SPKeys().mobile)!;
    // email!.value = prefs.getString(SPKeys().email)!;
    avatar!.value = prefs.getString(SPKeys().endpoint)!+prefs.getString(SPKeys().avatar)!;

    infoSubscription =
        EventBusUtil.getInstance().on<UserInfo>().listen((event) async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          nickname!.value = prefs.getString(SPKeys().nickname)!;
          account!.value = prefs.getString(SPKeys().username)!;
          mobile!.value = prefs.getString(SPKeys().mobile)!;
          email!.value = prefs.getString(SPKeys().email)!;
          avatar!.value = prefs.getString(SPKeys().endpoint)!+prefs.getString(SPKeys().avatar)!;
          HhLog.d("avatar ${avatar!.value}");
        });

    super.onInit();
  }
  // 将文件转换为字节数组
  Future<List<int>> readFileByte(File file) async {
    List<int> bytes = await file.readAsBytes();
    return bytes;
  }
  Future<void> fileUpload() async {
    /*Map<String, dynamic> map = {};
    List<int> byteData = await readFileByte(File(file.path));
    var multipartFile = http.MultipartFile.fromBytes(
      'file',
      byteData,
      filename: file.path.split('/').last,
    );
    map['avatarFile'] = multipartFile;
    var result = await HhHttp().request(RequestUtils.headerUpload,method: DioMethod.put,params: map,data: {
      "avatarFile":multipartFile
    });

    HhLog.d("fileUpload -- $result");
    if(result["code"]==0 && result["data"]!=null){

    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }*/

    uploadFile(file.path);
  }
  void uploadFile(String filePath) async {
    var dio = Dio();
    FormData formData = FormData.fromMap({
      "avatarFile": await MultipartFile.fromFile(filePath,
          filename: "header.jpg"),
    });

    try {
      var response = await dio.put(
        RequestUtils.headerUpload,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer ${CommonData.token}",
            "Tenant-Id":"${CommonData.tenant}",
          },
        ),
      );
      if(response.data.toString().contains("401")){
        CommonUtils().tokenDown();
      }
      HhLog.d("上传成功: ${response.data}");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(SPKeys().avatar, response.data["data"]);
      avatar!.value = prefs.getString(SPKeys().endpoint)!+response.data["data"];
      EventBusUtil.getInstance().fire(UserInfo());
    } catch (e) {
      HhLog.d("上传失败: $e");
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

  Future<void> loginOut() async {
    var result = await HhHttp().request(RequestUtils.logout,method: DioMethod.post);
    HhLog.d("loginOut $result");
    if(result["code"]==0 && result["data"]!=null){
      try{
        //
      }catch(e){
        HhLog.e(e.toString());
      }
    }
  }
}
