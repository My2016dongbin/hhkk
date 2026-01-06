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
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoController extends GetxController {
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    nickname!.value = prefs.getString(SPKeys().nickname)!;
    account!.value = prefs.getString(SPKeys().username)!;
    if(!CommonData.personal){
      tenantTitle!.value = prefs.getString(SPKeys().tenantTitle)!;
    }
    HhLog.d("tenantTitle ");
    mobile!.value = prefs.getString(SPKeys().mobile)!;
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

  Future<void> fileUpload() async {
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
