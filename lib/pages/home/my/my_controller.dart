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
  late StreamSubscription infoSubscription;
  StreamSubscription ?spaceListSubscription;
  late dynamic detail;

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

  Future<void> getShareDetail(String requestUrl) async {
    var result = await HhHttp().request(requestUrl,method: DioMethod.get);
    HhLog.d("getShareDetail $result");
    if(result["code"]==0 && result["data"]!=null){
      try{
        detail = result["data"];
        if (!context.mounted) return;
        showCupertinoDialog(context: context, builder: (context) => Center(
          child: Container(
            width: 1.sw,
            height: 650.w,
            margin: EdgeInsets.fromLTRB(50.w, 0, 50.w, 0),
            padding: EdgeInsets.fromLTRB(30.w, 35.w, 45.w, 25.w),
            decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(20.w))),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: BouncingWidget(
                    duration: const Duration(milliseconds: 100),
                    scaleFactor: 1.2,
                    onPressed: () {
                      Get.back();
                    },
                    child: Image.asset(
                      "assets/images/common/ic_x.png",
                      width: 35.w,
                      height: 35.w,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 25.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          CommonUtils().parseNull("${detail["shareUrerName"]}", ""),
                          style: TextStyle(
                              color: HhColors.blackTextColor,
                              fontSize: 32.sp,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.w,),
                        Text(
                          "邀请您共享",
                          style: TextStyle(
                              color: HhColors.blackTextColor,
                              fontSize: 32.sp,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 20.w,),
                        Image.asset(
                          "assets/images/common/icon_camera_space.png",
                          width: 260.w,
                          height: 260.w,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(height: 20.w,),
                        Text(
                          CommonUtils().parseNull("${detail["shareDetailDOList"][0]["deviceName"]}", ""),
                          style: TextStyle(
                              color: HhColors.gray6TextColor,
                              fontSize: 32.sp,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w200),
                        ),
                        BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.2,
                          onPressed: (){
                            shareReceive();
                          },
                          child: Container(
                            height: 90.w,
                            width: 1.sw,
                            margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
                            decoration: BoxDecoration(
                                color: HhColors.mainBlueColor,
                                borderRadius: BorderRadius.all(Radius.circular(20.w))),
                            child: Center(
                              child: Text(
                                "同意分享",
                                style: TextStyle(
                                  color: HhColors.whiteColor,
                                  decoration: TextDecoration.none,
                                  fontSize: 30.sp,),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
      }catch(e){
        HhLog.e(e.toString());
      }
    }
  }


  Future<void> shareReceive() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString(SPKeys().id)!;
    String nickname = prefs.getString(SPKeys().nickname)!;
    dynamic content = {
      "id":null,
      "shareType":"2",
      "shareUrerId":"${detail["shareUrerId"]}",
      "shareUrerName":"${detail["shareUrerId"]}",
      "receiveUrerId":id,
      "receiveUrerName":nickname,
      "shareLogId":null,
      "appReceiveDetailSaveReqVOList":[
        {
          "id":null,
          "spaceId":"${detail["shareDetailDOList"][0]["spaceId"]}",
          "spaceName":"${detail["shareDetailDOList"][0]["spaceName"]}",
          "deviceId":"${detail["shareDetailDOList"][0]["deviceId"]}",
          "deviceName":"${detail["shareDetailDOList"][0]["deviceName"]}",
          "shareType":"2",
          "shareUrerId":"${detail["shareUrerId"]}",
          "shareUrerName":"${detail["shareUrerId"]}",
          "receiveUrerId":id,
          "receiveUrerName":nickname,
          "receiveLogId":null,
        }
      ],
    };
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    var shareReceiveResult = await HhHttp().request(
        RequestUtils.shareReceive,
        method: DioMethod.post,
        data: content
    );
    HhLog.d("shareReceive shareReceiveResult -- $shareReceiveResult");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (shareReceiveResult["code"] == 0 && shareReceiveResult["data"] != null) {
      EventBusUtil.getInstance().fire(HhToast(title: "设备已接收",type: 0));
      Get.back();
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(shareReceiveResult["msg"]),type: 2));
    }
  }
}
