import 'dart:ffi';

import 'dart:math';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/login/company/company_login_binding.dart';
import 'package:iot/pages/common/login/company/company_login_view.dart';
import 'package:iot/pages/common/login/personal/personal_login_binding.dart';
import 'package:iot/pages/common/login/personal/personal_login_view.dart';
import 'package:iot/pages/home/device/detail/daozha/daozha_detail_binding.dart';
import 'package:iot/pages/home/device/detail/daozha/daozha_detail_view.dart';
import 'package:iot/pages/home/device/detail/device_detail_binding.dart';
import 'package:iot/pages/home/device/detail/device_detail_view.dart';
import 'package:iot/pages/home/device/detail/huoxianyinzi/device_detail_binding.dart';
import 'package:iot/pages/home/device/detail/huoxianyinzi/device_detail_view.dart';
import 'package:iot/pages/home/device/detail/ligan/device_detail_binding.dart';
import 'package:iot/pages/home/device/detail/ligan/device_detail_view.dart';
import 'package:iot/pages/home/device/detail/yunweixiang/yunwei_detail_binding.dart';
import 'package:iot/pages/home/device/detail/yunweixiang/yunwei_detail_view.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tpns_flutter_plugin/tpns_flutter_plugin.dart';
import 'package:video_player/video_player.dart';

class CommonUtils {
  List<Color> gradientColors() {
    List<Color> gradientColors = [
      HhColors.backTransColor1,
      HhColors.backTransColor1,
      HhColors.backTransColor21,
      HhColors.backTransColor22,
      HhColors.backTransColor3,
      HhColors.backTransColor3,
      HhColors.backTransColor3,
      HhColors.backTransColor3,
      HhColors.backTransColor3
    ];

    return gradientColors;
  }

  List<Color> gradientColors2() {
    List<Color> gradientColors = [
      HhColors.backTransColor1,
      HhColors.backTransColor1,
      HhColors.backTransColor21,
      HhColors.backTransColor22,
      HhColors.backTransColor3
    ];

    return gradientColors;
  }

  List<Color> gradientColors3() {
    List<Color> gradientColors = [
      HhColors.backTransColor1,
      HhColors.backTransColor1a,
      HhColors.backTransColor1b,
      HhColors.backTransColor1b
    ];

    return gradientColors;
  }

  ///百度转高德
  Map<String, double> bdToGd(double bdLng, double bdLat) {
    const xPi = pi * 3000.0 / 180.0;
    var x = bdLng - 0.0065;
    var y = bdLat - 0.006;
    var z = sqrt(x * x + y * y) - 0.00002 * sin(y * xPi);
    var theta = atan2(y, x) - 0.000003 * cos(x * xPi);
    var ggLng = z * cos(theta);
    var ggLat = z * sin(theta);

    //保留小数点后六位
    Map<String, double> data = {
      'longitude': parseDoubleNumberToDouble(ggLng.toString(), 6),
      'latitude': parseDoubleNumberToDouble(ggLat.toString(), 6)
    };
    return data;
  }

  ///高德转百度
  Map<String, double> gdToBd(double ggLon, double ggLat) {
    const xPi = pi * 3000.0 / 180.0;
    double x = ggLon;
    double y = ggLat;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * xPi);
    double theta = atan2(y, x) - 0.000003 * cos(x * xPi);
    double bdLon = z * cos(theta) + 0.0065;
    double bdLat = z * sin(theta) + 0.006;

    //保留小数点后六位
    Map<String, double> data = {
      'longitude': parseDoubleNumberToDouble(bdLon.toString(), 6),
      'latitude': parseDoubleNumberToDouble(bdLat.toString(), 6)
    };

    return data;
  }

  String parseMessageType(String s) {
    String type = "设备报警";
    if (s == 'deviceAlarm') {
      type = "设备报警";
    }
    if (s == 'spaceAlarm') {
      type = "空间报警";
    }
    return type;
  }

  String parseZero(int s) {
    String type = "00";
    if (s > 9) {
      type = "$s";
    } else {
      type = "0$s";
    }
    return type;
  }

  String parseDouble(String s) {
    String type = "0";
    int index = 0;
    index = s.indexOf('.');
    try {
      type = s.substring(0, index);
    } catch (e) {
      type = s;
    }
    return type;
  }

  double parseIsDouble(String s, double def) {
    try {
      return double.parse(s);
    } catch (e) {
      return def;
    }
  }

  bool validateSpaceName(String spaceName) {
    //空间名称不能包含特殊符号
    final RegExp pattern = RegExp(r'^[a-zA-Z0-9\u4e00-\u9fa5]+$');
    HhLog.d("$spaceName , ${pattern.hasMatch(spaceName)}");
    return pattern.hasMatch(spaceName);
  }

  bool validatePassword(String password) {
    // 正则表达式规则：
    // 最小长度 9 个字符，
    // 必须包含至少一个小写字母，
    // 必须包含至少一个大写字母，
    // 必须包含至少一个数字。
    // RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{9,}$');

    //密码必须为8-16位由字母、数字、特殊字符两种以上组成
    final RegExp pattern = RegExp(
        r'^((?=.*[A-Za-z])(?=.*\d|[!@#$%^&*(),.?":{}|<>])|(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])|(?=.*[A-Za-z])(?=.*\d)).{8,16}$');
    HhLog.d("$password , ${pattern.hasMatch(password)}");
    return pattern.hasMatch(password);
  }

  String parseNull(dynamic s, String def) {
    String r = "$s";
    if (s == null || s == "null") {
      r = def;
    }
    return r;
  }

  String parseLongTimeWithLength(String s, int length) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(s));
    String time = date.toIso8601String();
    time = time.substring(0, length);
    time = time.replaceAll("T", " ");
    return time;
  }

  String parseNameCount(String s, int number) {
    String rt = "";
    try {
      rt = "${s.substring(0, s.indexOf('.') + number + 1)}...";
      if (s.length == number) {
        rt = s.substring(0, s.indexOf('.') + number + 1);
      }
    } catch (e) {
      rt = s;
    }
    return rt;
  }

  String parseLatLngPoint(String s, int number) {
    String rt = "";
    try {
      rt = s.substring(0, s.indexOf('.') + number + 1);
    } catch (e) {
      rt = s;
    }
    return rt;
  }

  String parseLongTime(String s) {
    String time = "";
    try{
      DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(s));
      time = date.toIso8601String();
      time = time.substring(0, 19);
      time = time.replaceAll("T", " ");
    }catch(e){
      //
    }
    return time;
  }

  String parseLongTimeHourMinute(String s) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(s));
    String time = date.toIso8601String();
    time = time.substring(11, 16);
    time = time.replaceAll("T", " ");
    return time;
  }

  String parseLongTimeHourMinuteSecond(String s) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(s));
    String time = date.toIso8601String();
    time = time.substring(11, 19);
    time = time.replaceAll("T", " ");
    return time;
  }

  String parseLongTimeYearDay(String s) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(s));
    String time = date.toIso8601String();
    time = time.substring(0, 10);
    time = time.replaceAll("T", " ");
    return time;
  }

  String parseLongTimeDay(String s) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(s));
    String time = date.toIso8601String();
    time = time.substring(5, 10);
    time = time.replaceAll("T", " ").replaceAll("-", "/");
    return time;
  }

  String msgString(String s) {
    s = s.substring(s.indexOf(':') + 1, s.length);
    return s;
  }

  String subString(String s, int num) {
    try {
      s = s.substring(0, num);
    } catch (e) {
      HhLog.e(e.toString());
    }
    return s;
  }

  Widget noneWidget(
      {double? top,
      double? mid,
      String? image,
      String? info,
      double? height,
      double? width}) {
    return Column(
      children: [
        SizedBox(
          height: top ?? 0.5.sw,
        ),
        Image.asset(
          image ?? 'assets/images/common/icon_no_message.png',
          fit: BoxFit.fill,
          height: height ?? 0.4.sw,
          width: width ?? 0.5.sw,
        ),
        SizedBox(
          height: mid ?? 0,
        ),
        Text(
          info ?? '暂无数据',
          style:
              TextStyle(color: HhColors.grayBBTextColor, fontSize: 14.sp * 3),
        ),
      ],
    );
  }

  Widget noneWidgetSmall({String? image, double? top, String? text}) {
    return Column(
      children: [
        SizedBox(
          height: top ?? 75.w * 3,
        ),
        Image.asset(
          image ?? 'assets/images/common/icon_no_message.png',
          fit: BoxFit.fill,
          height: 67.w * 3,
          width: 87.w * 3,
        ),
        SizedBox(
          height: 11.w * 3,
        ),
        Text(
          text ?? '暂无数据',
          style:
              TextStyle(color: HhColors.grayBBTextColor, fontSize: 13.sp * 3),
        ),
      ],
    );
  }

  /*
    showCupertinoDialog(context: logic.context, builder: (BuildContext context) {
      return Center(
        child: Container(
          width: 1.sw,
          height: 300.w,
          margin: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0),
          decoration: BoxDecoration(
              color: HhColors.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(20.w))
          ),
          child: Stack(
            children: [
              Align(
                alignment:Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 80.w, 0, 0),
                  child: Text('确定要重启设备吗？',style: TextStyle(
                    color: HhColors.grayAATextColor,
                    fontSize: 28.sp,
                    decoration: TextDecoration.none
                  ),),),
              ),
              Align(
                alignment:Alignment.bottomLeft,
                child: BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: () {
                    Get.back();
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(50.w, 0, 0, 40.w),
                    padding: EdgeInsets.fromLTRB(60.w, 15.w, 60.w, 15.w),
                    decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      border: Border.all(color: HhColors.gray9TextColor,width: 1.w),
                      borderRadius: BorderRadius.all(Radius.circular(16.w)),
                    ),
                    child: Text('取消',style: TextStyle(
                      color: HhColors.gray9TextColor,
                      fontSize: 28.sp,
                      decoration: TextDecoration.none
                    ),),),
                ),
              ),
              Align(
                alignment:Alignment.bottomRight,
                child: BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: () {
                    Get.back();
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 50.w, 40.w),
                    padding: EdgeInsets.fromLTRB(60.w, 15.w, 60.w, 15.w),
                    decoration: BoxDecoration(
                      color: HhColors.mainBlueColor,
                      borderRadius: BorderRadius.all(Radius.circular(16.w)),
                    ),
                    child: Text('确定',style: TextStyle(
                      color: HhColors.whiteColor,
                      fontSize: 28.sp,
                        decoration: TextDecoration.none
                    ),),),
                ),
              ),
            ],
          ),
        ),
      );
    },);*/

  ///图片查看Dialog
  showPictureDialog(
    context, {
    String? url,
    String? asset,
  }) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 1.sh,
            width: 1.sw,
            color: HhColors.blackRealColor,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 80.h),
                  width: 1.sw,
                  child: Center(
                    child: PhotoView(
                      imageProvider: /*url==null?AssetImage(asset!):*/
                          NetworkImage(url!),
                      errorBuilder: (c, o, s) {
                        return Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.w * 3)),
                          child: Image.asset(
                            "assets/images/common/ic_message_no.png",
                            fit: BoxFit.fill,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  height: 100.h * 3,
                  width: 1.sw,
                  color: HhColors.whiteColor,
                  padding: EdgeInsets.only(top: 36.h*3),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          '图片查看',
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: HhColors.blackTextColor,
                              fontSize: 18.sp * 3,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.2,
                          onPressed: () {
                            Get.back();
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(23.w * 3, 0, 0, 0),
                            padding: EdgeInsets.fromLTRB(0, 10.w, 20.w, 10.w),
                            color: HhColors.trans,
                            child: Image.asset(
                              "assets/images/common/back.png",
                              height: 17.w * 3,
                              width: 10.w * 3,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        barrierDismissible: true);
  }

  ///通用输入Dialog（取消/确认）
  showCommonInputDialog(context, title, controller, leftClick, rightClick,
      {String? leftStr, String? rightStr}) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              height: 200.w * 3,
              margin: EdgeInsets.fromLTRB(30.w * 3, 0, 30.w * 3, 0),
              decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(8.w * 3)),
              ),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10.w*3),
                          height:40.w*3,
                          color: HhColors.trans,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '录音',
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: HhColors.blackTextColor,
                                      fontSize: 17.sp * 3,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: BouncingWidget(
                                  duration: const Duration(milliseconds: 100),
                                  scaleFactor: 1.2,
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    color: HhColors.trans,
                                    margin: EdgeInsets.fromLTRB(0, 10.w*3, 10.w*3, 0),
                                    padding: EdgeInsets.fromLTRB(12.w*3, 0, 12.w*3, 12.w*3),
                                    child: Image.asset(
                                      "assets/images/common/ic_x.png",
                                      height: 18.w * 3,
                                      width: 18.w * 3,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: HhColors.line9Color,
                            borderRadius: BorderRadius.all(Radius.circular(8.w * 3)),
                          ),
                          margin: EdgeInsets.fromLTRB(20.w*3, 20.w*3, 20.w*3, 40.w * 3),
                          padding: EdgeInsets.fromLTRB(10.w*3, 0, 10.w*3, 0),
                          child: Material(
                            color: HhColors.trans,
                            child: TextField(
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              maxLength: 10,
                              cursorColor: HhColors.titleColor_99,
                              controller: controller,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                counterText: '',
                                hintText: '请输入文件名称',
                                hintStyle: TextStyle(
                                    color: HhColors.grayCCTextColor,
                                    fontSize: 15.sp * 3,
                                    fontWeight: FontWeight.w200),
                              ),
                              style: TextStyle(
                                  color: HhColors.textBlackColor,
                                  fontSize: 15.sp * 3,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 13.w * 3),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: CommonButton(
                              height: 44.w * 3,
                              fontSize: 16.sp * 3,
                              backgroundColor: HhColors.whiteColor,
                              margin:
                                  EdgeInsets.fromLTRB(20.w * 3, 0, 13.w * 3, 0),
                              solid: true,
                              borderRadius: 8.w * 3,
                              solidColor: HhColors.grayEDBackColor,
                              textColor: HhColors.blackColor,
                              text: leftStr ?? "取消",
                              onPressed: leftClick,
                            ),
                          ),
                          Expanded(
                            child: CommonButton(
                              height: 44.w * 3,
                              fontSize: 16.sp * 3,
                              backgroundColor: HhColors.mainBlueColor,
                              margin: EdgeInsets.fromLTRB(0, 0, 20.w * 3, 0),
                              borderRadius: 8.w * 3,
                              textColor: HhColors.whiteColor,
                              text: rightStr ?? "确定",
                              onPressed: rightClick,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        barrierDismissible: true);
  }

  ///通用Dialog（取消/确认）
  showCommonDialog(context, title, leftClick, rightClick,
      {String? leftStr, String? rightStr, String? hint}) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              height: hint == null ? 152.w * 3 : 170.w * 3,
              margin: EdgeInsets.fromLTRB(30.w * 3, 0, 30.w * 3, 0),
              decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(8.w * 3)),
              ),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 40.w * 3),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "$title",
                            style: TextStyle(
                                color: HhColors.blackTextColor,
                                decoration: TextDecoration.none,
                                fontSize: 16.sp * 3,
                                fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          Offstage(
                              offstage: hint == null,
                              child: SizedBox(
                                height: 20.h,
                              )),
                          Offstage(
                              offstage: hint == null,
                              child: Material(
                                  color: HhColors.whiteColor,
                                  child: Text(
                                    "$hint",
                                    style: TextStyle(
                                        color: HhColors.titleColor_33,
                                        fontSize: 16.sp * 3),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ))),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 13.w * 3),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: CommonButton(
                              height: 44.w * 3,
                              fontSize: 16.sp * 3,
                              backgroundColor: HhColors.whiteColor,
                              margin:
                                  EdgeInsets.fromLTRB(20.w * 3, 0, 13.w * 3, 0),
                              solid: true,
                              borderRadius: 8.w * 3,
                              solidColor: HhColors.grayEDBackColor,
                              textColor: HhColors.titleColor_99,
                              text: leftStr ?? "取消",
                              onPressed: leftClick,
                            ),
                          ),
                          Expanded(
                            child: CommonButton(
                              height: 44.w * 3,
                              fontSize: 16.sp * 3,
                              backgroundColor: HhColors.mainBlueColor,
                              margin: EdgeInsets.fromLTRB(0, 0, 20.w * 3, 0),
                              borderRadius: 8.w * 3,
                              textColor: HhColors.whiteColor,
                              text: rightStr ?? "确定",
                              onPressed: rightClick,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        barrierDismissible: true);
  }

  ///通用Dialog（取消/确认）
  showDeleteDialog(context, title, leftClick, rightClick, closeClick,
      {String? leftStr, String? rightStr, String? hint}) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              height: hint == null ? 152.w * 3 : 170.w * 3,
              margin: EdgeInsets.fromLTRB(30.w * 3, 0, 30.w * 3, 0),
              decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(8.w * 3)),
              ),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 40.w * 3),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "$title",
                            style: TextStyle(
                                color: HhColors.blackTextColor,
                                decoration: TextDecoration.none,
                                fontSize: 16.sp * 3,
                                fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          Offstage(
                              offstage: hint == null,
                              child: SizedBox(
                                height: 20.h,
                              )),
                          Offstage(
                              offstage: hint == null,
                              child: Material(
                                  color: HhColors.whiteColor,
                                  child: Text(
                                    "$hint",
                                    style: TextStyle(
                                        color: HhColors.titleColor_33,
                                        fontSize: 16.sp * 3),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ))),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 13.w * 3),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: CommonButton(
                              height: 44.w * 3,
                              fontSize: 16.sp * 3,
                              backgroundColor: HhColors.whiteColor,
                              margin:
                                  EdgeInsets.fromLTRB(20.w * 3, 0, 13.w * 3, 0),
                              solid: true,
                              borderRadius: 8.w * 3,
                              solidColor: HhColors.grayE6BackColor,
                              textColor: HhColors.blackTextColor,
                              text: leftStr ?? "取消",
                              onPressed: leftClick,
                            ),
                          ),
                          Expanded(
                            child: CommonButton(
                              height: 44.w * 3,
                              fontSize: 16.sp * 3,
                              backgroundColor: HhColors.whiteColor,
                              margin: EdgeInsets.fromLTRB(0, 0, 20.w * 3, 0),
                              solid: true,
                              borderRadius: 8.w * 3,
                              solidColor: HhColors.mainRedColor,
                              textColor: HhColors.mainRedColor,
                              text: rightStr ?? "确定",
                              onPressed: rightClick,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: closeClick,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 15.w * 3, 23.w * 3, 0),
                        child: Image.asset(
                          'assets/images/common/ic_x.png',
                          fit: BoxFit.fill,
                          height: 14.w * 3,
                          width: 14.w * 3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        barrierDismissible: true);
  }

  ///通用Dialog（取消/确认）
  showConfirmDialog(context, title, leftClick, rightClick, closeClick,
      {String? leftStr, String? rightStr, String? hint}) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              height: hint == null ? 152.w * 3 : 170.w * 3,
              margin: EdgeInsets.fromLTRB(30.w * 3, 0, 30.w * 3, 0),
              decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(8.w * 3)),
              ),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 40.w * 3),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "$title",
                            style: TextStyle(
                                color: HhColors.gray4TextColor,
                                decoration: TextDecoration.none,
                                fontSize: 16.sp * 3,
                                fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          Offstage(
                              offstage: hint == null,
                              child: SizedBox(
                                height: 20.h,
                              )),
                          Offstage(
                              offstage: hint == null,
                              child: Material(
                                  color: HhColors.whiteColor,
                                  child: Text(
                                    "$hint",
                                    style: TextStyle(
                                        color: HhColors.titleColor_33,
                                        fontSize: 16.sp * 3),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ))),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 13.w * 3),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: CommonButton(
                              height: 44.w * 3,
                              fontSize: 16.sp * 3,
                              backgroundColor: HhColors.whiteColor,
                              margin:
                                  EdgeInsets.fromLTRB(20.w * 3, 0, 13.w * 3, 0),
                              solid: true,
                              borderRadius: 8.w * 3,
                              solidColor: HhColors.grayEDBackColor,
                              textColor: HhColors.blackTextColor,
                              text: leftStr ?? "取消",
                              onPressed: leftClick,
                            ),
                          ),
                          Expanded(
                            child: CommonButton(
                              height: 44.w * 3,
                              fontSize: 16.sp * 3,
                              backgroundColor: HhColors.mainBlueColor,
                              margin: EdgeInsets.fromLTRB(0, 0, 20.w * 3, 0),
                              borderRadius: 8.w * 3,
                              textColor: HhColors.whiteColor,
                              text: rightStr ?? "确定",
                              onPressed: rightClick,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: closeClick,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 15.w * 3, 23.w * 3, 0),
                        child: Image.asset(
                          'assets/images/common/ic_x.png',
                          fit: BoxFit.fill,
                          height: 14.w * 3,
                          width: 14.w * 3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        barrierDismissible: true);
  }

  /// 和风天气图标
  /// @param color 颜色#以后部分
  /// @param icon 和风天气图标id
  /// @return
  String getHeFengIcon(String color, String icon, String size) {
    String url =
        "data:image/svg+xml,<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"$size\" height=\"$size\" fill='%23$color' class=\"qi-$icon-fill\" viewBox=\"0 0 16 16\" overflow=\"hidden\">${getIconPath(icon)}</svg>";

    return url;
  }

  String getIconPath(String id) {
    String path =
        "<path d=\"M8.005 3.5a4.5 4.5 0 1 0 4.5 4.5 4.5 4.5 0 0 0-4.5-4.5zm.001-.997a.5.5 0 0 1-.5-.5v-1.5a.5.5 0 1 1 1 0v1.5a.5.5 0 0 1-.5.5z\"/>\n" +
            "  <path d=\"M8.006 2.503a.5.5 0 0 1-.5-.5v-1.5a.5.5 0 1 1 1 0v1.5a.5.5 0 0 1-.5.5zM3.765 4.255a.498.498 0 0 1-.353-.147L2.35 3.048a.5.5 0 0 1 .707-.707L4.12 3.4a.5.5 0 0 1-.354.854zM2.003 8.493h-1.5a.5.5 0 0 1 0-1h1.5a.5.5 0 0 1 0 1zm.691 5.303a.5.5 0 0 1-.354-.854l1.062-1.06a.5.5 0 0 1 .707.707l-1.062 1.06a.498.498 0 0 1-.353.147zm5.299 2.201a.5.5 0 0 1-.5-.5v-1.5a.5.5 0 0 1 1 0v1.5a.5.5 0 0 1-.5.5zm5.302-2.191a.498.498 0 0 1-.353-.147l-1.06-1.06a.5.5 0 1 1 .706-.707l1.06 1.06a.5.5 0 0 1-.353.854zm2.202-5.299h-1.5a.5.5 0 1 1 0-1h1.5a.5.5 0 0 1 0 1zm-3.252-4.242a.5.5 0 0 1-.354-.854l1.06-1.06a.5.5 0 0 1 .708.707l-1.06 1.06a.498.498 0 0 1-.354.147z\"/>\n";
    switch (id) {
      case "100":
        path = "<path d=\"M8.005 3.5a4.5 4.5 0 1 0 4.5 4.5 4.5 4.5 0 0 0-4.5-4.5zm.001-.997a.5.5 0 0 1-.5-.5v-1.5a.5.5 0 1 1 1 0v1.5a.5.5 0 0 1-.5.5z\"/>\n" +
            "  <path d=\"M8.006 2.503a.5.5 0 0 1-.5-.5v-1.5a.5.5 0 1 1 1 0v1.5a.5.5 0 0 1-.5.5zM3.765 4.255a.498.498 0 0 1-.353-.147L2.35 3.048a.5.5 0 0 1 .707-.707L4.12 3.4a.5.5 0 0 1-.354.854zM2.003 8.493h-1.5a.5.5 0 0 1 0-1h1.5a.5.5 0 0 1 0 1zm.691 5.303a.5.5 0 0 1-.354-.854l1.062-1.06a.5.5 0 0 1 .707.707l-1.062 1.06a.498.498 0 0 1-.353.147zm5.299 2.201a.5.5 0 0 1-.5-.5v-1.5a.5.5 0 0 1 1 0v1.5a.5.5 0 0 1-.5.5zm5.302-2.191a.498.498 0 0 1-.353-.147l-1.06-1.06a.5.5 0 1 1 .706-.707l1.06 1.06a.5.5 0 0 1-.353.854zm2.202-5.299h-1.5a.5.5 0 1 1 0-1h1.5a.5.5 0 0 1 0 1zm-3.252-4.242a.5.5 0 0 1-.354-.854l1.06-1.06a.5.5 0 0 1 .708.707l-1.06 1.06a.498.498 0 0 1-.354.147z\"/>\n";
        break;
      case "101":
        path = "<path d=\"M4.745 1.777a.516.516 0 0 0 .503.404.535.535 0 0 0 .112-.012.517.517 0 0 0 .392-.616L5.496.403A.516.516 0 0 0 4.49.627zM1.023 3.535l.994.633a.516.516 0 0 0 .554-.87l-.994-.633a.516.516 0 0 0-.554.87zM.628 8.043l1.15-.256a.516.516 0 1 0-.223-1.008l-1.15.256a.516.516 0 0 0 .111 1.02.535.535 0 0 0 .112-.012zm10.238-2.28a.535.535 0 0 0 .112-.012l1.15-.256a.516.516 0 1 0-.224-1.008l-1.15.256a.516.516 0 0 0 .112 1.02zM8.522 2.728a.516.516 0 0 0 .712-.158l.633-.994a.516.516 0 0 0-.87-.554l-.633.994a.516.516 0 0 0 .158.712zM2.819 7.032a3.506 3.506 0 0 0 .331.87 3.13 3.13 0 0 0 .908-.486 2.453 2.453 0 0 1-.232-.608 2.504 2.504 0 0 1 1.9-2.988 2.5 2.5 0 0 1 2.988 1.9l.004.038a5.42 5.42 0 0 1 1.064.25 3.509 3.509 0 0 0-.061-.512 3.535 3.535 0 1 0-6.902 1.536z\"/>\n" +
            "  <path d=\"M12.464 8.48a3.236 3.236 0 0 0-.409.04 4.824 4.824 0 0 0-8.086 0 3.234 3.234 0 0 0-.41-.04 3.285 3.285 0 1 0 1.284 6.31 4.756 4.756 0 0 0 6.338 0 3.286 3.286 0 1 0 1.283-6.31z\"/>\n";
        break;
      case "102":
        path = "<path d=\"m3.402 11.875-.002.002h-.002l-.661.662-.396.397H2.34l-.003.003a.5.5 0 1 0 .707.707l.4-.4.665-.664a.5.5 0 1 0-.707-.707zm10.48-.666a2.145 2.145 0 0 0-.265.026 3.144 3.144 0 0 0-5.225 0 2.145 2.145 0 0 0-.264-.026 2.09 2.09 0 1 0 0 4.18 2.145 2.145 0 0 0 .829-.166 3.109 3.109 0 0 0 4.096 0 2.146 2.146 0 0 0 .829.166 2.09 2.09 0 1 0 0-4.18zm0 3.18a1.144 1.144 0 0 1-.444-.088 1 1 0 0 0-1.038.165 2.109 2.109 0 0 1-2.791 0 1 1 0 0 0-1.038-.165 1.144 1.144 0 0 1-.443.088 1.09 1.09 0 1 1-.007-2.18c.025 0 .05.005.075.009l.074.01a1.023 1.023 0 0 0 .122.007 1 1 0 0 0 .832-.446 2.144 2.144 0 0 1 3.56 0 1 1 0 0 0 .833.446 1.024 1.024 0 0 0 .122-.008l.074-.01c.025-.003.05-.007.068-.008a1.09 1.09 0 1 1 0 2.18zM8.003 2.5a.5.5 0 0 0 .5-.5V.5a.5.5 0 0 0-1 0V2a.5.5 0 0 0 .5.5zM3.408 4.105a.5.5 0 0 0 .707-.707l-1.06-1.06a.5.5 0 0 0-.708.706zM2.5 7.99a.5.5 0 0 0-.5-.5H.5a.5.5 0 0 0 0 1H2a.5.5 0 0 0 .5-.5zm10.993.013a.5.5 0 0 0 .5.5h1.5a.5.5 0 0 0 0-1h-1.5a.5.5 0 0 0-.5.5zm-1.252-3.742a.498.498 0 0 0 .354-.146l1.06-1.061a.5.5 0 0 0-.706-.707l-1.061 1.06a.5.5 0 0 0 .353.854z\"/>\n" +
            "  <path d=\"M8.014 10.41a3.846 3.846 0 0 1 4.28-1.132 4.452 4.452 0 0 0 .207-1.282 4.5 4.5 0 1 0-6.868 3.812 2.923 2.923 0 0 1 2.381-1.397z\"/>\n";
        break;
      case "103":
        path = "<path d=\"M4.79 10.68a3.56 3.56 0 0 1 1.91-.55h.22a4.56 4.56 0 0 1 3.13-1.22 4.91 4.91 0 0 1 2 .46 4.29 4.29 0 0 0 .33-1.64 4.38 4.38 0 0 0-8.76 0 4.33 4.33 0 0 0 1.17 2.95zM8 2.52a.5.5 0 0 0 .5-.5V.52A.5.5 0 0 0 8 0a.5.5 0 0 0-.5.5V2a.5.5 0 0 0 .5.52zm-4.58 1.6a.48.48 0 0 0 .7 0 .48.48 0 0 0 0-.7L3.06 2.36a.49.49 0 0 0-.7.7zM2.51 8a.5.5 0 0 0-.5-.5H.51a.5.5 0 1 0 0 1H2a.5.5 0 0 0 .51-.5zm10.95 0a.5.5 0 0 0 .5.5h1.5A.5.5 0 0 0 16 8a.5.5 0 0 0-.5-.5H14a.5.5 0 0 0-.54.5zm-1.21-3.72a.47.47 0 0 0 .35-.15l1.06-1.06a.49.49 0 1 0-.7-.7L11.9 3.43a.48.48 0 0 0 0 .7.47.47 0 0 0 .35.15z\"/>\n" +
            "  <path d=\"M13.58 10.72a2.71 2.71 0 0 0-.59.08 4.12 4.12 0 0 0-2.87-1.23 4.06 4.06 0 0 0-3 1.36 2.78 2.78 0 0 0-.58-.06 2.94 2.94 0 0 0-2.43 1.23 1.62 1.62 0 0 0-.44-.1 1.68 1.68 0 1 0 .89 3.1 3 3 0 0 0 2 .71 3.14 3.14 0 0 0 1.51-.39 4.06 4.06 0 0 0 4.39-.2 2.3 2.3 0 0 0 1.13.3A2.41 2.41 0 0 0 16 13.14a2.52 2.52 0 0 0-2.42-2.42zm0 3.83a1.37 1.37 0 0 1-.66-.18 1 1 0 0 0-.47-.12 1 1 0 0 0-.59.19 2.91 2.91 0 0 1-1.74.56 3 3 0 0 1-1.55-.41 1 1 0 0 0-.51-.14.94.94 0 0 0-.48.13 2.16 2.16 0 0 1-1 .26 2.06 2.06 0 0 1-1.34-.47 1 1 0 0 0-.65-.24c-.19 0-.6.25-.89.25a.68.68 0 0 1 0-1.35c.05 0 .4.06.49.06a.84.84 0 0 0 .78-.43 2 2 0 0 1 1.61-.79c.13 0 .49.07.61.07a1 1 0 0 0 .71-.35 3.13 3.13 0 0 1 2.24-1 3.07 3.07 0 0 1 2.16.93 1 1 0 0 0 .72.3c.1 0 .46-.08.56-.08a1.55 1.55 0 0 1 1.42 1.4 1.42 1.42 0 0 1-1.42 1.41z\"/>\n";
        break;
      case "104":
        path = "<path d=\"M12.603 7.225a3.345 3.345 0 0 0-.423.042 4.987 4.987 0 0 0-8.36 0 3.345 3.345 0 0 0-.423-.042 3.397 3.397 0 1 0 1.326 6.524 4.917 4.917 0 0 0 6.554 0 3.397 3.397 0 1 0 1.326-6.524z\"/>\n" +
            "  <path d=\"M4.008 6.136a1.545 1.545 0 0 1 1.54-1.467.915.915 0 0 1 .108.012l.084.012a1 1 0 0 0 .961-.445 2.74 2.74 0 0 1 4.598 0 1 1 0 0 0 .961.445l.084-.012a.92.92 0 0 1 .108-.012 1.524 1.524 0 0 1 1.455 2.048 3.379 3.379 0 0 1 .86.538A2.484 2.484 0 0 0 12.136 3.7a3.74 3.74 0 0 0-6.27 0 2.508 2.508 0 0 0-.317-.032A2.548 2.548 0 0 0 3 6.216a2.464 2.464 0 0 0 .069.517 1.705 1.705 0 0 1 .94-.597z\"/>\n";
        break;
      case "300":
        path =
            "<path d=\"M5.195 1.897h.007a.5.5 0 0 0 .493-.506L5.683.486a.5.5 0 0 0-.5-.493h-.007a.5.5 0 0 0-.493.506l.012.904a.5.5 0 0 0 .5.494zm-2.892.946a.5.5 0 1 0 .698-.716l-.648-.63a.5.5 0 1 0-.697.715zm-.179 2.203a.5.5 0 0 0-.5-.494h-.007l-.904.012a.5.5 0 0 0 .006 1h.007l.905-.012a.5.5 0 0 0 .493-.506zm5.638-2.121a.5.5 0 0 0 .359-.15l.63-.648a.5.5 0 0 0-.716-.698l-.631.647a.5.5 0 0 0 .358.85zm4.254 2.647a2.938 2.938 0 0 0-.37.037 4.364 4.364 0 0 0-7.315 0 2.937 2.937 0 0 0-.37-.037 2.972 2.972 0 1 0 1.16 5.708 4.302 4.302 0 0 0 5.734 0 2.972 2.972 0 1 0 1.161-5.708zM2.47 5.308a3.53 3.53 0 0 1 1.018-.288 1.831 1.831 0 0 1 1.811-1.603 1.809 1.809 0 0 1 .553.094 4.927 4.927 0 0 1 1.282-.404 2.82 2.82 0 0 0-4.67 2.145c0 .02.006.037.006.056zm7.063 9.696a1 1 0 0 0 2 0 6.605 6.605 0 0 0-1-2 6.605 6.605 0 0 0-1 2zm-5.083 0a1 1 0 0 0 2 0 6.605 6.605 0 0 0-1-2 6.605 6.605 0 0 0-1 2z\" style=\"fill-rule:evenodd\"/>\n";
        break;
      case "301":
        path = "<path d=\"M7.012 14.985a1 1 0 0 0 2 0 6.605 6.605 0 0 0-1-2 6.605 6.605 0 0 0-1 2zM3.959 14a1 1 0 0 0 2 0 6.605 6.605 0 0 0-1-2 6.605 6.605 0 0 0-1 2zm6.028 0a1 1 0 0 0 2 0 6.605 6.605 0 0 0-1-2 6.605 6.605 0 0 0-1 2zM5.207 1.904h.007a.5.5 0 0 0 .493-.506L5.695.494a.5.5 0 0 0-.5-.494h-.007a.5.5 0 0 0-.493.506l.012.905a.5.5 0 0 0 .5.493zm-2.892.946a.5.5 0 1 0 .698-.716l-.648-.63a.5.5 0 1 0-.697.715zm-.179 2.203a.5.5 0 0 0-.5-.493h-.007l-.905.011a.5.5 0 0 0 .007 1h.007l.904-.011a.5.5 0 0 0 .494-.507zm5.638-2.12a.5.5 0 0 0 .359-.151l.63-.648a.5.5 0 0 0-.716-.698l-.631.648a.5.5 0 0 0 .358.849z\"/>\n" +
            "  <path d=\"M12.028 5.579a2.927 2.927 0 0 0-.37.037 4.364 4.364 0 0 0-7.316 0 2.926 2.926 0 0 0-.37-.037 2.972 2.972 0 1 0 1.16 5.709 4.302 4.302 0 0 0 5.735 0 2.972 2.972 0 1 0 1.16-5.71zm-9.546-.264A3.53 3.53 0 0 1 3.5 5.027a1.831 1.831 0 0 1 1.81-1.603 1.81 1.81 0 0 1 .553.095 4.933 4.933 0 0 1 1.281-.405A2.82 2.82 0 0 0 2.476 5.26c0 .02.006.037.006.056z\"/>\n";
        break;
      case "302":
        path =
            "<path d=\"M12.315 2.086a3.146 3.146 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.146 3.146 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0 3.185 3.185 0 1 0 1.243-6.116zM2.998 12.5a1 1 0 1 0 2 0 6.604 6.604 0 0 0-1-2 6.604 6.604 0 0 0-1 2zm8.028 0a1 1 0 0 0 2 0 6.604 6.604 0 0 0-1-2 6.604 6.604 0 0 0-1 2zm-2.352-.86c-.058 0-.096-.051-.07-.095l.858-1.462c.026-.044-.012-.096-.07-.096h-1.71a.167.167 0 0 0-.145.078l-1.514 2.681c-.045.08.024.172.128.172H7.69c.054 0 .091.045.074.088l-.8 1.976c-.03.07.078.12.134.064l3.227-3.297c.042-.043.006-.109-.06-.109z\"/>\n";
        break;
      case "303":
        path =
            "<path d=\"M3.685 8.455a3.172 3.172 0 0 0 1.243-.253 4.61 4.61 0 0 0 6.144 0 3.185 3.185 0 1 0 1.243-6.116 3.146 3.146 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.146 3.146 0 0 0-.397-.04 3.184 3.184 0 1 0 0 6.369zM2.998 12.5a1 1 0 1 0 2 0 6.604 6.604 0 0 0-1-2 6.604 6.604 0 0 0-1 2zm-2-1.552a.786.786 0 1 0 1.573 0 5.193 5.193 0 0 0-.787-1.573 5.193 5.193 0 0 0-.786 1.573zm12.429 0a.786.786 0 1 0 1.573 0 5.193 5.193 0 0 0-.786-1.573 5.193 5.193 0 0 0-.787 1.573zM11.026 12.5a1 1 0 0 0 2 0 6.604 6.604 0 0 0-1-2 6.604 6.604 0 0 0-1 2zm-2.352-.86c-.058 0-.096-.051-.07-.095l.858-1.462c.026-.044-.012-.096-.07-.096h-1.71a.167.167 0 0 0-.145.078l-1.514 2.681c-.045.08.024.172.128.172H7.69c.054 0 .091.045.074.088l-.8 1.976c-.03.07.078.12.134.064l3.227-3.297c.042-.043.006-.109-.06-.109z\"/>\n";
        break;
      case "304":
        path =
            "<path d=\"M12.315 2.086a3.146 3.146 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.146 3.146 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0 3.185 3.185 0 1 0 1.243-6.116zM2.998 12.5a1 1 0 1 0 2 0 6.604 6.604 0 0 0-1-2 6.604 6.604 0 0 0-1 2zm5.676-.86c-.058 0-.096-.051-.07-.095l.858-1.462c.026-.044-.012-.096-.07-.096h-1.71a.167.167 0 0 0-.145.078l-1.514 2.681c-.045.08.024.172.128.172H7.69c.054 0 .091.045.074.088l-.8 1.976c-.03.07.078.12.134.064l3.227-3.297c.042-.043.006-.109-.06-.109z\" style=\"fill-rule:evenodd\"/>\n" +
                "  <circle cx=\"12.5\" cy=\"12\" r=\"1\"/>\n";
        break;
      case "305":
        path =
            "<path d=\"M12.315 2.086a3.146 3.146 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.146 3.146 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0 3.185 3.185 0 1 0 1.243-6.116zM9.6 12.526a1 1 0 0 0 2 0 6.606 6.606 0 0 0-1-2 6.606 6.606 0 0 0-1 2zm-5.082 0a1 1 0 0 0 2 0 6.606 6.606 0 0 0-1-2 6.606 6.606 0 0 0-1 2z\" style=\"fill-rule:evenodd\"/>\n";
        break;
      case "306":
        path =
            "<path d=\"M12.315 2.086a3.146 3.146 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.146 3.146 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0 3.185 3.185 0 1 0 1.243-6.116zM7 13.41a1 1 0 0 0 2 0 6.606 6.606 0 0 0-1-2 6.606 6.606 0 0 0-1 2zm-4.002-1.717a1 1 0 0 0 2 0 6.604 6.604 0 0 0-1-2 6.604 6.604 0 0 0-1 2zm8.003 0a1 1 0 0 0 2 0 6.604 6.604 0 0 0-1-2 6.604 6.604 0 0 0-1 2z\" style=\"fill-rule:evenodd\"/>\n";
        break;
      case "307":
        path =
            "<path d=\"M15.5 5.27a3.184 3.184 0 0 0-3.185-3.184 3.146 3.146 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.146 3.146 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0A3.185 3.185 0 0 0 15.5 5.27zm-8.45 8.179a1 1 0 0 0 2 0 6.606 6.606 0 0 0-1-2 6.606 6.606 0 0 0-1 2zm-3.052-1.5a1 1 0 0 0 2 0 6.606 6.606 0 0 0-1-2 6.606 6.606 0 0 0-1 2zm6.028 0a1 1 0 0 0 2 0 6.606 6.606 0 0 0-1-2 6.606 6.606 0 0 0-1 2zm-8.976-.825a.786.786 0 0 0 1.572 0 5.192 5.192 0 0 0-.786-1.573 5.192 5.192 0 0 0-.786 1.573zm12.43 0a.786.786 0 0 0 1.572 0 5.192 5.192 0 0 0-.787-1.573 5.192 5.192 0 0 0-.786 1.573z\" style=\"fill-rule:evenodd\"/>\n";
        break;
      case "308":
        path = "<path d=\"M6.99 13.449a1 1 0 0 0 2 0 6.606 6.606 0 0 0-1-2 6.606 6.606 0 0 0-1 2zm-3.052-1.5a1 1 0 1 0 2 0 6.606 6.606 0 0 0-1-2 6.606 6.606 0 0 0-1 2zm6.028 0a1 1 0 0 0 2 0 6.606 6.606 0 0 0-1-2 6.606 6.606 0 0 0-1 2zm3.802-1.947a.5.5 0 0 0-.5.5v2.953a.5.5 0 1 0 1 0v-2.953a.5.5 0 0 0-.5-.5zm-11.702 0a.5.5 0 0 0-.5.5v2.953a.5.5 0 1 0 1 0v-2.953a.5.5 0 0 0-.5-.5zm12.02-4.272a1.407 1.407 0 0 0-.172.02.536.536 0 0 1-.061.004.486.486 0 0 1-.407-.22 2.268 2.268 0 0 0-3.803 0 .551.551 0 0 1-.45.213.52.52 0 0 1-.073-.005.793.793 0 0 0-.117-.012 1.39 1.39 0 0 0 0 2.779 1.372 1.372 0 0 0 .542-.11.485.485 0 0 1 .51.082 2.229 2.229 0 0 0 2.978 0 .486.486 0 0 1 .51-.082 1.375 1.375 0 0 0 .543.11 1.39 1.39 0 0 0 0-2.78z\"/>\n" +
            "  <path d=\"M7.343 8.553c.08 0 .154-.017.233-.022a1.9 1.9 0 0 1 1.48-3.373A2.834 2.834 0 0 1 11.43 3.87a3.295 3.295 0 0 1 .803.116 4.006 4.006 0 0 1 1.836 1.47 2.683 2.683 0 0 0 .115-.648 2.808 2.808 0 0 0-3.267-2.869 4.266 4.266 0 0 0-7.15 0 2.87 2.87 0 0 0-.363-.036 2.905 2.905 0 1 0 1.135 5.58 4.241 4.241 0 0 0 2.803 1.07z\"/>\n";
        break;
      case "309":
        path =
            "<path d=\"M12.315 2.086a3.146 3.146 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.146 3.146 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0 3.185 3.185 0 1 0 1.243-6.116zm-4.211 8.207a.255.255 0 0 0-.325.14l-.966 2.423a.251.251 0 0 0 .14.326.256.256 0 0 0 .093.017.25.25 0 0 0 .232-.157l.966-2.423a.251.251 0 0 0-.14-.326zm-3.728.207a.248.248 0 0 0-.325.137l-.71 1.747a.25.25 0 0 0 .138.325.243.243 0 0 0 .093.019.25.25 0 0 0 .232-.156l.71-1.746a.25.25 0 0 0-.138-.326zm7.247.1a.248.248 0 0 0-.325.136l-.71 1.747a.25.25 0 0 0 .137.326.243.243 0 0 0 .094.018.25.25 0 0 0 .232-.156l.71-1.746a.25.25 0 0 0-.138-.326z\"/>\n";
        break;
      case "310":
        path =
            "<path d=\"M3.685 8.455a3.172 3.172 0 0 0 1.243-.253 4.61 4.61 0 0 0 6.144 0 3.185 3.185 0 1 0 1.243-6.116 3.146 3.146 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.146 3.146 0 0 0-.397-.04 3.184 3.184 0 1 0 0 6.369zM7 13.713a1 1 0 0 0 2 0 6.604 6.604 0 0 0-1-2 6.604 6.604 0 0 0-1 2zm-2.527-2.02a1 1 0 0 0 2 0 6.604 6.604 0 0 0-1-2 6.604 6.604 0 0 0-1 2zm5.011 0a1 1 0 0 0 2 0 6.604 6.604 0 0 0-1-2 6.604 6.604 0 0 0-1 2zm-6.732-.833a5.192 5.192 0 0 0-.786-1.573 5.192 5.192 0 0 0-.786 1.573.786.786 0 0 0 1.572 0zm-.347 2.746a.786.786 0 0 0 1.572 0 5.192 5.192 0 0 0-.786-1.573 5.192 5.192 0 0 0-.786 1.573zm10.835-2.738a.786.786 0 0 0 1.573 0 5.194 5.194 0 0 0-.786-1.573 5.194 5.194 0 0 0-.787 1.573zm-1.209 2.738a.786.786 0 0 0 1.573 0 5.192 5.192 0 0 0-.786-1.573 5.192 5.192 0 0 0-.787 1.573z\" style=\"fill-rule:evenodd\"/>\n";
        break;
      case "311":
        path =
            "<path d=\"M12.254 2.086a3.147 3.147 0 0 0-.397.04 4.675 4.675 0 0 0-7.838 0 3.147 3.147 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0 3.185 3.185 0 1 0 1.244-6.116zM6.938 13.362a1 1 0 0 0 2 0 6.604 6.604 0 0 0-1-2 6.604 6.604 0 0 0-1 2zm-5-1.669a1 1 0 0 0 2 0 6.604 6.604 0 0 0-1-2 6.604 6.604 0 0 0-1 2zm10.026 0a1 1 0 0 0 2 0 6.604 6.604 0 0 0-1-2 6.604 6.604 0 0 0-1 2zM.734 8.975a.5.5 0 0 0-.5.5v1.999a.5.5 0 0 0 1 0V9.475a.5.5 0 0 0-.5-.5zm4.72 1.382a.5.5 0 0 0-.5.5v1.999a.5.5 0 0 0 1 0v-2a.5.5 0 0 0-.5-.5zm4.996.006a.5.5 0 0 0-.5.5v1.999a.5.5 0 0 0 1 0v-2a.5.5 0 0 0-.5-.5zm4.816-1.388a.5.5 0 0 0-.5.5v1.999a.5.5 0 0 0 1 0V9.475a.5.5 0 0 0-.5-.5z\"/>\n";
        break;
      case "312":
        path =
            "<path d=\"M12.254 2.086a3.147 3.147 0 0 0-.397.04 4.675 4.675 0 0 0-7.838 0 3.147 3.147 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0 3.185 3.185 0 1 0 1.244-6.116zM.734 8.975a.5.5 0 0 0-.5.5v1.999a.5.5 0 0 0 1 0V9.475a.5.5 0 0 0-.5-.5zm4.72 1.718a.5.5 0 0 0-.5.5v1.999a.5.5 0 0 0 1 0v-2a.5.5 0 0 0-.5-.5zM3.06 9.975a.5.5 0 0 0-.5.5v1.998a.5.5 0 0 0 1 0v-1.998a.5.5 0 0 0-.5-.5zm9.903 0a.5.5 0 0 0-.5.5v1.998a.5.5 0 0 0 1 0v-1.998a.5.5 0 0 0-.5-.5zm-5.025 1.382a.5.5 0 0 0-.5.5v1.999a.5.5 0 0 0 1 0v-2a.5.5 0 0 0-.5-.5zm2.512-.657a.5.5 0 0 0-.5.5v1.998a.5.5 0 1 0 1 0V11.2a.5.5 0 0 0-.5-.5zm4.816-1.725a.5.5 0 0 0-.5.5v1.999a.5.5 0 0 0 1 0V9.475a.5.5 0 0 0-.5-.5z\"/>\n";
        break;
      case "313":
        path =
            "<path d=\"M15.5 5.27a3.184 3.184 0 0 0-3.185-3.184 3.146 3.146 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.146 3.146 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0A3.185 3.185 0 0 0 15.5 5.27zM1.148 10.095l.978 1.397.977-1.397-.977-1.396-.978 1.396zm2.938 1.456.977 1.397.978-1.397-.978-1.396-.977 1.396zm2.936 1.789L8 14.736l.977-1.396L8 11.943l-.978 1.397zm2.937-1.789.978 1.397.977-1.397-.977-1.396-.978 1.396zm2.937-1.456.978 1.397.978-1.397-.978-1.396-.978 1.396z\"/>\n";
        break;
      case "314":
        path =
            "<path d=\"M10.435 12.443a1 1 0 0 0 2 0 6.603 6.603 0 0 0-1-2 6.603 6.603 0 0 0-1 2zm1.88-10.357a3.146 3.146 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.146 3.146 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0 3.185 3.185 0 1 0 1.243-6.116zm-8.917 10.25a.786.786 0 0 0 1.573 0 5.193 5.193 0 0 0-.786-1.572 5.193 5.193 0 0 0-.787 1.572zm5.043-2.186a.502.502 0 0 0-.626.329L6.73 13.958a.5.5 0 0 0 .955.297l1.085-3.478a.5.5 0 0 0-.329-.627z\"/>\n";
        break;
      case "315":
        path =
            "<path d=\"M9.435 12.443a1 1 0 0 0 2 0 6.603 6.603 0 0 0-1-2 6.603 6.603 0 0 0-1 2zm2.88-10.357a3.146 3.146 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.146 3.146 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0 3.185 3.185 0 1 0 1.243-6.116zm-9.917 10.25a.786.786 0 0 0 1.573 0 5.193 5.193 0 0 0-.786-1.572 5.193 5.193 0 0 0-.787 1.572zm9.633-1.179a.786.786 0 1 0 1.573 0 5.193 5.193 0 0 0-.786-1.573 5.193 5.193 0 0 0-.787 1.573zm-4.59-1.007a.502.502 0 0 0-.626.329L5.73 13.958a.5.5 0 0 0 .955.297l1.085-3.478a.5.5 0 0 0-.329-.627z\"/>\n";
        break;
      case "316":
        path =
            "<path d=\"M10.022 12.443a1 1 0 0 0 2 0 6.603 6.603 0 0 0-1-2 6.603 6.603 0 0 0-1 2zm2.746-1.179a1 1 0 1 0 2 0 6.603 6.603 0 0 0-1-2 6.603 6.603 0 0 0-1 2zM15.5 5.27a3.184 3.184 0 0 0-3.185-3.184 3.146 3.146 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.146 3.146 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0A3.185 3.185 0 0 0 15.5 5.27zM3.909 12.336a.786.786 0 0 0 1.573 0 5.193 5.193 0 0 0-.787-1.572 5.193 5.193 0 0 0-.786 1.572zm-2.326-1.179a.786.786 0 1 0 1.572 0 5.193 5.193 0 0 0-.786-1.573 5.193 5.193 0 0 0-.786 1.573zm6.444-1.007a.503.503 0 0 0-.626.329l-1.085 3.479a.5.5 0 0 0 .955.297l1.085-3.478a.5.5 0 0 0-.329-.627z\"/>\n";
        break;
      case "317":
        path =
            "<path d=\"M12.768 11.264a1 1 0 1 0 2 0 6.603 6.603 0 0 0-1-2 6.603 6.603 0 0 0-1 2zM15.5 5.27a3.184 3.184 0 0 0-3.185-3.184 3.146 3.146 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.146 3.146 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0A3.185 3.185 0 0 0 15.5 5.27zM1.583 11.157a.786.786 0 1 0 1.572 0 5.193 5.193 0 0 0-.786-1.573 5.193 5.193 0 0 0-.786 1.573zm6.754-1.007a.499.499 0 0 0-.627.329l-1.086 3.479a.5.5 0 0 0 .955.297l1.086-3.478a.5.5 0 0 0-.328-.626zm-2.707.196a.502.502 0 0 0-.626.328l-.818 2.62a.501.501 0 0 0 .328.626.516.516 0 0 0 .15.023.501.501 0 0 0 .477-.351l.818-2.62a.501.501 0 0 0-.328-.626zm5.406 0a.502.502 0 0 0-.627.328l-.818 2.62a.501.501 0 0 0 .329.626.516.516 0 0 0 .149.023.501.501 0 0 0 .478-.351l.817-2.62a.501.501 0 0 0-.328-.626z\"/>\n";
        break;
      case "318":
        path =
            "<path d=\"M12.768 11.264a1 1 0 1 0 2 0 6.603 6.603 0 0 0-1-2 6.603 6.603 0 0 0-1 2zM15.5 5.27a3.184 3.184 0 0 0-3.185-3.184 3.146 3.146 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.146 3.146 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0A3.185 3.185 0 0 0 15.5 5.27zM1.583 11.157a.786.786 0 1 0 1.572 0 5.193 5.193 0 0 0-.786-1.573 5.193 5.193 0 0 0-.786 1.573zm6.754-1.007a.499.499 0 0 0-.627.329l-1.086 3.479a.5.5 0 0 0 .955.297l1.086-3.478a.5.5 0 0 0-.328-.626zm-2.707.196a.502.502 0 0 0-.626.328l-.818 2.62a.501.501 0 0 0 .328.626.516.516 0 0 0 .15.023.501.501 0 0 0 .477-.351l.818-2.62a.501.501 0 0 0-.328-.626zm5.406 0a.502.502 0 0 0-.627.328l-.818 2.62a.501.501 0 0 0 .329.626.516.516 0 0 0 .149.023.501.501 0 0 0 .478-.351l.817-2.62a.501.501 0 0 0-.328-.626zm-9.312 3.88a.645.645 0 1 0 1.29 0 4.258 4.258 0 0 0-.645-1.29 4.258 4.258 0 0 0-.645 1.29zm11.426.028a.617.617 0 0 0 1.235 0 4.078 4.078 0 0 0-.617-1.235 4.078 4.078 0 0 0-.617 1.235z\" style=\"fill-rule:evenodd\"/>\n";
        break;
      case "399":
        path =
            "<path d=\"M.28 9.372a4.514 4.514 0 1 0 9.029 0c0-2.495-4.514-9.028-4.514-9.028S.28 6.877.28 9.372zM13.212 6.3s-2.569 3.718-2.569 5.138a2.569 2.569 0 1 0 5.138 0c0-1.42-2.569-5.138-2.569-5.138z\"/>\n";
        break;
      case "400":
        path =
            "<path d=\"M12.315 2.086a3.146 3.146 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.146 3.146 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0 3.185 3.185 0 1 0 1.243-6.116zm-1.055 10.38-.44-.254.434-.251a.35.35 0 0 0-.35-.607l-.435.251v-.508a.35.35 0 1 0-.699 0v.509l-.435-.251a.35.35 0 0 0-.35.606l.434.25-.44.255a.35.35 0 1 0 .35.606l.441-.255v.503a.35.35 0 1 0 .7 0v-.502l.44.254a.35.35 0 0 0 .35-.606zm-4.739 0-.44-.254.434-.251a.35.35 0 0 0-.35-.607l-.434.251v-.508a.35.35 0 1 0-.699 0v.509l-.436-.251a.35.35 0 0 0-.35.606l.435.25-.44.255a.35.35 0 1 0 .35.606l.441-.255v.503a.35.35 0 1 0 .7 0v-.502l.44.254a.35.35 0 0 0 .35-.606z\"/>\n";
        break;
      case "401":
        path =
            "<path d=\"M12.315 2.086a3.146 3.146 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.146 3.146 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0 3.185 3.185 0 1 0 1.243-6.116zm-3.312 11.38-.44-.254.434-.251a.35.35 0 0 0-.35-.607l-.434.251v-.508a.35.35 0 1 0-.7 0v.509l-.435-.251a.35.35 0 0 0-.35.606l.434.25-.44.255a.35.35 0 1 0 .35.606l.441-.255v.503a.35.35 0 1 0 .7 0v-.502l.44.254a.35.35 0 0 0 .35-.606zm-3.547-1.985-.44-.254.434-.25a.35.35 0 0 0-.35-.607l-.434.25v-.508a.35.35 0 1 0-.7 0v.51l-.435-.252a.35.35 0 0 0-.35.606l.435.25-.44.255a.35.35 0 1 0 .35.606l.44-.254v.502a.35.35 0 1 0 .7 0v-.502l.44.254a.35.35 0 0 0 .35-.606zm7.19 0-.44-.254.434-.25a.35.35 0 0 0-.35-.607l-.434.25v-.508a.35.35 0 1 0-.7 0v.509l-.434-.251a.35.35 0 0 0-.35.606l.434.25-.44.255a.35.35 0 1 0 .35.606l.44-.254v.502a.35.35 0 1 0 .7 0v-.502l.44.254a.35.35 0 0 0 .35-.606z\"/>\n";
        break;
      case "402":
        path =
            "<path d=\"M3.661 8.455a3.172 3.172 0 0 0 1.244-.253 4.61 4.61 0 0 0 6.144 0 3.185 3.185 0 1 0 1.243-6.116 3.147 3.147 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.147 3.147 0 0 0-.397-.04 3.184 3.184 0 1 0 0 6.369zm4.783 4.893.514-.297a.303.303 0 0 0-.304-.524l-.513.296v-.6a.302.302 0 0 0-.605 0v.601l-.514-.297a.303.303 0 0 0-.304.524l.514.297-.52.3a.303.303 0 0 0 .304.525l.52-.3v.593a.302.302 0 0 0 .605 0v-.593l.52.3a.303.303 0 0 0 .303-.525zm-3.579-1.559.514-.297a.303.303 0 0 0-.303-.524l-.514.296v-.6a.302.302 0 0 0-.605 0v.6l-.514-.296a.303.303 0 0 0-.303.524l.514.297-.52.3a.303.303 0 0 0 .303.524l.52-.3v.593a.302.302 0 0 0 .605 0v-.593l.52.3a.303.303 0 0 0 .303-.524zm7.255 0 .514-.297a.303.303 0 0 0-.304-.524l-.513.296v-.6a.302.302 0 1 0-.605 0v.6l-.513-.296a.303.303 0 0 0-.304.524l.514.296-.52.3a.303.303 0 0 0 .303.525l.52-.3v.593a.302.302 0 1 0 .605 0v-.593l.52.3a.303.303 0 0 0 .303-.524zm3.729-1.516-.52-.3.514-.297a.303.303 0 0 0-.304-.524l-.514.297v-.6a.302.302 0 0 0-.605 0v.6l-.513-.297a.303.303 0 0 0-.304.524l.514.297-.52.3a.303.303 0 0 0 .304.525l.52-.3v.593a.302.302 0 0 0 .604 0v-.594l.52.3a.303.303 0 0 0 .304-.524zm-13.966-.3.514-.297a.303.303 0 0 0-.304-.524l-.514.297v-.6a.302.302 0 0 0-.605 0v.6L.46 9.151a.303.303 0 0 0-.304.524l.514.297-.52.3a.303.303 0 0 0 .304.525l.519-.3v.593a.302.302 0 0 0 .605 0v-.594l.52.3a.303.303 0 0 0 .304-.524z\"/>\n";
        break;
      case "403":
        path =
            "<path d=\"M3.685 8.455a3.172 3.172 0 0 0 1.243-.253 4.61 4.61 0 0 0 6.144 0 3.185 3.185 0 1 0 1.243-6.116 3.147 3.147 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.147 3.147 0 0 0-.397-.04 3.184 3.184 0 1 0 0 6.369zm4.759 5.929.514-.297a.303.303 0 0 0-.304-.524l-.513.296v-.6a.302.302 0 1 0-.605 0v.6l-.514-.296a.303.303 0 0 0-.304.524l.514.297-.52.3a.303.303 0 1 0 .304.524l.52-.3v.593a.302.302 0 1 0 .605 0v-.593l.52.3a.302.302 0 0 0 .413-.11.302.302 0 0 0-.11-.414zM4.865 12.35l.514-.298a.303.303 0 0 0-.303-.524l-.514.297v-.6a.302.302 0 0 0-.605 0v.6l-.514-.297a.303.303 0 0 0-.303.524l.514.297-.52.3a.303.303 0 0 0 .303.525l.52-.3v.593a.302.302 0 0 0 .605 0v-.593l.52.3a.303.303 0 0 0 .303-.524zm7.255 0 .514-.298a.303.303 0 0 0-.304-.524l-.513.297v-.6a.302.302 0 0 0-.605 0v.6l-.513-.297a.303.303 0 0 0-.304.525l.514.296-.52.3a.303.303 0 0 0 .303.525l.52-.3v.593a.302.302 0 1 0 .605 0v-.593l.52.3a.303.303 0 0 0 .303-.524zm-4.233.04a.302.302 0 0 0 .302-.302v-.356l.314.18a.302.302 0 0 0 .413-.11.302.302 0 0 0-.11-.414l-.313-.18.309-.179a.303.303 0 0 0-.303-.524l-.31.179v-.363a.302.302 0 0 0-.605 0v.362l-.308-.178a.303.303 0 0 0-.304.524l.309.178-.314.181a.303.303 0 1 0 .304.525l.313-.181v.356a.302.302 0 0 0 .303.303zm7.962-1.983-.52-.3.514-.297a.303.303 0 0 0-.304-.524l-.514.297v-.601a.302.302 0 0 0-.605 0v.6l-.513-.296a.303.303 0 0 0-.304.524l.514.297-.52.3a.303.303 0 0 0 .304.524l.52-.3v.593a.302.302 0 0 0 .604 0v-.593l.52.3a.303.303 0 0 0 .304-.524zm-13.966-.3.514-.297a.303.303 0 0 0-.304-.524l-.514.297v-.601a.302.302 0 0 0-.605 0v.6L.46 9.286a.303.303 0 0 0-.304.524l.514.297-.52.3a.303.303 0 0 0 .304.524l.519-.3v.593a.302.302 0 0 0 .605 0v-.593l.52.3a.303.303 0 0 0 .304-.524z\"/>\n";
        break;
      case "404":
        path =
            "<path d=\"M12.315 2.086a3.146 3.146 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.146 3.146 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0 3.185 3.185 0 1 0 1.243-6.116zm-7.79 10.623a1 1 0 1 0 2 0 6.603 6.603 0 0 0-1-2 6.603 6.603 0 0 0-1 2zm6.935-.113-.664-.383.658-.38a.35.35 0 0 0-.35-.606l-.658.38v-.768a.35.35 0 1 0-.7 0v.768l-.657-.38a.35.35 0 0 0-.35.606l.657.38-.664.383a.35.35 0 1 0 .35.607l.665-.384v.76a.35.35 0 1 0 .699 0v-.76l.665.384a.35.35 0 0 0 .35-.607z\"/>\n";
        break;
      case "405":
        path =
            "<path d=\"M8.407 9.998a.499.499 0 0 0-.626.33l-1.085 3.478a.5.5 0 0 0 .33.626.489.489 0 0 0 .148.022.5.5 0 0 0 .477-.351l1.085-3.479a.5.5 0 0 0-.329-.626zm3.908-7.912a3.146 3.146 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.146 3.146 0 0 0-.396-.04 3.185 3.185 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0 3.185 3.185 0 1 0 1.243-6.116zm-8.79 10.623a1 1 0 0 0 2 0 6.603 6.603 0 0 0-1-2 6.603 6.603 0 0 0-1 2zm8.935-.112-.665-.384.658-.38a.35.35 0 0 0-.35-.605l-.657.379v-.768a.35.35 0 0 0-.699 0v.768l-.658-.38a.35.35 0 0 0-.35.606l.658.38-.666.384a.35.35 0 0 0 .175.652.343.343 0 0 0 .175-.047l.666-.384v.76a.35.35 0 0 0 .7 0v-.76l.664.384a.343.343 0 0 0 .175.047.35.35 0 0 0 .175-.652z\"/>\n";
        break;
      case "406":
        path =
            "<path d=\"M4.436 14.968a1 1 0 0 0 2 0 6.604 6.604 0 0 0-1-2 6.604 6.604 0 0 0-1 2zm6.827-.272-.557-.322.551-.318a.35.35 0 0 0-.35-.606l-.55.319v-.645a.35.35 0 1 0-.7 0v.645l-.552-.319a.35.35 0 0 0-.35.606l.552.319-.557.321a.35.35 0 1 0 .35.607l.557-.322v.636a.35.35 0 1 0 .7 0v-.636l.557.322a.35.35 0 0 0 .35-.607zM5.195 1.904h.007a.5.5 0 0 0 .493-.506L5.683.494a.5.5 0 0 0-.5-.494h-.007a.5.5 0 0 0-.493.506l.012.905a.5.5 0 0 0 .5.493zm-2.892.946a.5.5 0 1 0 .698-.716l-.648-.63a.5.5 0 1 0-.697.715zm-.179 2.203a.5.5 0 0 0-.5-.493h-.007l-.904.011a.5.5 0 0 0 .006 1h.007l.905-.011a.5.5 0 0 0 .493-.507zm5.638-2.12a.5.5 0 0 0 .359-.151l.63-.648a.5.5 0 0 0-.716-.698l-.631.647a.5.5 0 0 0 .358.85zm4.254 2.646a2.938 2.938 0 0 0-.37.037 4.364 4.364 0 0 0-7.315 0 2.937 2.937 0 0 0-.37-.037 2.972 2.972 0 1 0 1.16 5.709 4.302 4.302 0 0 0 5.734 0 2.972 2.972 0 1 0 1.161-5.71zM2.47 5.315a3.53 3.53 0 0 1 1.018-.288 1.831 1.831 0 0 1 1.811-1.603 1.809 1.809 0 0 1 .553.095 4.926 4.926 0 0 1 1.282-.405 2.82 2.82 0 0 0-4.67 2.145c0 .02.006.037.006.056z\"/>\n";
        break;
      case "407":
        path =
            "<path d=\"M5.241 1.904h.007a.5.5 0 0 0 .493-.506L5.73.494A.5.5 0 0 0 5.23 0h-.007a.5.5 0 0 0-.493.506l.011.905a.5.5 0 0 0 .5.493zM2.35 2.85a.5.5 0 1 0 .697-.716l-.647-.63a.5.5 0 1 0-.698.715zm-.18 2.203a.5.5 0 0 0-.5-.493h-.007l-.903.01a.5.5 0 0 0 .007 1h.007l.904-.011a.5.5 0 0 0 .493-.507zm5.639-2.12a.5.5 0 0 0 .358-.151l.631-.648a.5.5 0 0 0-.717-.698l-.63.647a.5.5 0 0 0 .358.85zm4.253 2.646a2.938 2.938 0 0 0-.37.037 4.364 4.364 0 0 0-7.315 0 2.937 2.937 0 0 0-.37-.037 2.972 2.972 0 1 0 1.16 5.709 4.302 4.302 0 0 0 5.735 0 2.972 2.972 0 1 0 1.16-5.71zm-9.546-.264a3.53 3.53 0 0 1 1.018-.288 1.831 1.831 0 0 1 1.812-1.603 1.809 1.809 0 0 1 .552.095 4.926 4.926 0 0 1 1.282-.405A2.82 2.82 0 0 0 2.51 5.26c0 .02.006.037.006.056zm8.738 9.481-.44-.254.434-.251a.35.35 0 0 0-.35-.606l-.435.25v-.508a.35.35 0 1 0-.699 0v.509l-.435-.251a.35.35 0 0 0-.35.606l.434.25-.44.255a.35.35 0 1 0 .35.606l.441-.255v.503a.35.35 0 1 0 .7 0v-.502l.44.254a.35.35 0 0 0 .35-.606zm-4.739 0-.44-.254.435-.251a.35.35 0 0 0-.35-.606l-.435.25v-.508a.35.35 0 1 0-.699 0v.509l-.435-.251a.35.35 0 0 0-.35.606l.434.25-.44.255a.35.35 0 1 0 .35.606l.441-.255v.503a.35.35 0 1 0 .7 0v-.502l.44.254a.35.35 0 0 0 .35-.606z\"/>\n";
        break;
      case "408":
        path =
            "<path d=\"m12.035 11.946.51-.294a.3.3 0 0 0-.301-.52l-.509.295v-.595a.3.3 0 1 0-.6 0v.595l-.51-.294a.3.3 0 0 0-.3.52l.51.293-.516.298a.3.3 0 0 0 .3.52l.516-.298v.588a.3.3 0 0 0 .6 0v-.588l.515.298a.3.3 0 0 0 .3-.52zm-7.25 0 .306-.177a.3.3 0 0 0-.3-.52l-.307.177v-.359a.3.3 0 0 0-.6 0v.359l-.305-.177a.3.3 0 0 0-.301.52l.306.177-.31.179a.3.3 0 0 0 .15.56.303.303 0 0 0 .15-.04l.31-.18v.354a.3.3 0 0 0 .6 0v-.354l.31.18a.3.3 0 0 0 .41-.11.3.3 0 0 0-.109-.41zm7.53-9.86a3.146 3.146 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.146 3.146 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0 3.185 3.185 0 1 0 1.243-6.116zM8.441 10.15a.501.501 0 0 0-.626.329L6.73 13.957a.5.5 0 0 0 .955.298l1.085-3.478a.5.5 0 0 0-.329-.627z\"/>\n";
        break;
      case "409":
        path =
            "<path d=\"m11.035 11.946.51-.294a.3.3 0 0 0-.301-.52l-.509.295v-.595a.3.3 0 1 0-.6 0v.595l-.51-.294a.3.3 0 0 0-.3.52l.51.293-.516.298a.3.3 0 0 0 .3.52l.516-.298v.588a.3.3 0 0 0 .6 0v-.588l.515.298a.3.3 0 0 0 .3-.52zm-7.25 0 .306-.177a.3.3 0 0 0-.3-.52l-.307.177v-.359a.3.3 0 0 0-.6 0v.359l-.305-.177a.3.3 0 0 0-.301.52l.306.177-.31.179a.3.3 0 0 0 .15.56.303.303 0 0 0 .15-.04l.31-.18v.354a.3.3 0 0 0 .6 0v-.354l.31.18a.3.3 0 0 0 .41-.11.3.3 0 0 0-.109-.41zM14.29 10.63l.306-.176a.3.3 0 0 0-.3-.52l-.306.177v-.359a.3.3 0 1 0-.6 0v.36l-.306-.178a.3.3 0 0 0-.301.52l.306.177-.31.179a.3.3 0 0 0 .15.56.303.303 0 0 0 .15-.04l.311-.18v.353a.3.3 0 0 0 .6 0v-.353l.31.18a.3.3 0 0 0 .301-.52zm1.21-5.36a3.184 3.184 0 0 0-3.185-3.184 3.146 3.146 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.146 3.146 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0A3.185 3.185 0 0 0 15.5 5.27zm-8.059 4.88a.502.502 0 0 0-.626.329L5.73 13.957a.5.5 0 0 0 .955.298l1.085-3.478a.5.5 0 0 0-.329-.627z\"/>\n";
        break;
      case "410":
        path =
            "<path d=\"m11.144 11.71.51-.294a.3.3 0 0 0-.3-.52l-.51.295v-.595a.3.3 0 1 0-.6 0v.595l-.509-.294a.3.3 0 0 0-.3.52l.509.294-.516.297a.3.3 0 0 0 .301.52l.516-.298v.589a.3.3 0 0 0 .6 0v-.588l.514.297a.3.3 0 0 0 .3-.52zm3.44-1.309.51-.294a.3.3 0 0 0-.301-.52l-.51.295v-.595a.3.3 0 1 0-.6 0v.595l-.509-.294a.3.3 0 0 0-.3.52l.51.293-.516.298a.3.3 0 0 0 .3.52l.515-.297v.587a.3.3 0 0 0 .6 0v-.588l.516.298a.3.3 0 0 0 .3-.52zm-11.861.433.306-.176a.3.3 0 0 0-.3-.52l-.306.177v-.36a.3.3 0 0 0-.6 0v.36l-.306-.177a.3.3 0 0 0-.3.52l.306.176-.311.18a.3.3 0 0 0 .15.56.303.303 0 0 0 .15-.04l.31-.18v.353a.3.3 0 0 0 .6 0v-.353l.311.18a.3.3 0 0 0 .41-.11.3.3 0 0 0-.11-.41zm2.615 1.536.306-.177a.3.3 0 0 0-.3-.52l-.307.178v-.36a.3.3 0 1 0-.6 0v.36l-.305-.177a.3.3 0 0 0-.301.52l.306.176-.31.18a.3.3 0 0 0 .15.56.303.303 0 0 0 .15-.041l.31-.179v.353a.3.3 0 1 0 .6 0v-.354l.31.18a.3.3 0 0 0 .41-.11.3.3 0 0 0-.109-.41zM15.5 5.27a3.184 3.184 0 0 0-3.185-3.184 3.146 3.146 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.146 3.146 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0A3.185 3.185 0 0 0 15.5 5.27zm-7.473 4.88a.501.501 0 0 0-.626.329l-1.085 3.478a.5.5 0 0 0 .955.298l1.085-3.478a.5.5 0 0 0-.329-.627z\"/>\n";
        break;
      case "499":
        path =
            "<path d=\"M14.483 9.172a.504.504 0 0 0-.612-.354l-2.233.599-.98-.566a2.655 2.655 0 0 0-.056-1.884l1.022-.59 2.108.565a.542.542 0 0 0 .13.017.5.5 0 0 0 .13-.983l-1.143-.306.809-.467a.5.5 0 1 0-.5-.865l-.886.512.338-1.265a.501.501 0 0 0-.353-.613.508.508 0 0 0-.612.353l-.598 2.232-.979.564a2.782 2.782 0 0 0-1.661-.884V4.05l1.542-1.542a.5.5 0 0 0-.707-.707l-.835.835v-.933a.5.5 0 1 0-1 0v1.023L6.48 1.8a.5.5 0 1 0-.707.707l1.633 1.632v1.123a2.791 2.791 0 0 0-1.595 1.005l-1.03-.595-.565-2.108a.5.5 0 1 0-.966.26l.306 1.141L2.75 4.5a.5.5 0 1 0-.5.865l.886.512-1.265.339A.5.5 0 0 0 2 7.198a.541.541 0 0 0 .13-.016l2.232-.599.98.566a2.655 2.655 0 0 0 .056 1.884l-1.022.59-2.108-.565a.507.507 0 0 0-.613.353.501.501 0 0 0 .354.613l1.142.306-.809.467a.5.5 0 0 0 .25.932.493.493 0 0 0 .25-.067l.886-.512-.338 1.265a.501.501 0 0 0 .353.613.542.542 0 0 0 .13.017.5.5 0 0 0 .482-.37l.598-2.232.979-.564a2.782 2.782 0 0 0 1.661.884v1.188l-1.542 1.542a.5.5 0 0 0 .707.707l.835-.835v.933a.5.5 0 0 0 1 0v-1.023l.926.925a.5.5 0 0 0 .707-.707l-1.633-1.632v-1.123a2.791 2.791 0 0 0 1.595-1.005l1.03.595.565 2.108a.5.5 0 0 0 .482.37.541.541 0 0 0 .13-.017.501.501 0 0 0 .354-.613l-.306-1.141.807.466a.493.493 0 0 0 .25.067.5.5 0 0 0 .25-.932l-.886-.512 1.265-.339a.501.501 0 0 0 .354-.613z\"/>\n";
        break;
      case "500":
        path =
            "<path d=\"M7.031 9.208a.5.5 0 0 1 0-1h8.45a3.05 3.05 0 0 0-3.543-2.77 4.675 4.675 0 0 0-7.838 0 3.149 3.149 0 0 0-.397-.04 3.184 3.184 0 1 0 1.244 6.117 4.61 4.61 0 0 0 6.144 0 3.184 3.184 0 0 0 4.365-2.307z\"/>\n";
        break;
      case "501":
        path =
            "<path d=\"M12.315 3.086a3.146 3.146 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.146 3.146 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0 3.185 3.185 0 1 0 1.243-6.116zm1.187 8.214H4.525a.5.5 0 0 0 0 1h8.977a.5.5 0 0 0 0-1zm-2.518 2.313a.5.5 0 0 0-.5-.5H1.508a.5.5 0 0 0 0 1h8.976a.5.5 0 0 0 .5-.5z\"/>\n";
        break;
      case "502":
        path =
            "<path d=\"M12.543 4.487c-1.581 0-3.876 1.712-4.57 2.888C7.282 6.2 4.987 4.487 3.406 4.487a3.486 3.486 0 0 0 0 6.97c1.58 0 3.876-1.75 4.569-2.906.693 1.156 2.988 2.906 4.569 2.906a3.486 3.486 0 0 0 0-6.97z\"/>\n";
        break;
      case "503":
        path = "<circle cx=\"5.332\" cy=\"7.142\" r=\".581\"/>\n" +
            "  <path d=\"M4.156 3.654a.581.581 0 1 0-.581-.582.58.58 0 0 0 .58.582zm6.081 2.674a.581.581 0 1 0-.581-.581.581.581 0 0 0 .581.58zM8.97 3.654a.581.581 0 1 0-.582-.582.582.582 0 0 0 .581.582z\"/>\n" +
            "  <circle cx=\"2.412\" cy=\"5.398\" r=\".581\"/>\n" +
            "  <path d=\"M9.507 10.61a.581.581 0 1 0-.76.317.581.581 0 0 0 .76-.316zm-3.637.218a.581.581 0 1 0-.76.317.581.581 0 0 0 .76-.317zm.845 2.564a.581.581 0 1 0 .316.759.581.581 0 0 0-.316-.76zm.36-7.878a.582.582 0 1 0-.581-.581.582.582 0 0 0 .581.581z\"/>\n" +
            "  <path d=\"M14.438 6.226a2.869 2.869 0 0 0 .239-.984c.13-2.698-3.196-3.84-3.337-3.888a.45.45 0 0 0-.286.854c.028.009 2.821.974 2.724 2.99a2.26 2.26 0 0 1-.863 1.612C11.232 8.268 7.249 8.932 2.77 8.505a.458.458 0 0 0-.492.404.45.45 0 0 0 .406.491c.943.09 1.86.134 2.74.134 3.59 0 6.563-.73 8.08-2.044.01-.008.016-.018.026-.026a5.517 5.517 0 0 1-.168 1.159c-.571 1.837-3.716 3.541-8.41 3.097a.458.458 0 0 0-.491.405.45.45 0 0 0 .405.49c.55.054 1.078.079 1.587.079 3.117 0 5.432-.943 6.727-2.211a3.823 3.823 0 0 1-.176 1.013c-.25.708-1.35 2.996-4.901 2.723a.432.432 0 0 0-.483.415.45.45 0 0 0 .414.483q.321.024.622.024a5.2 5.2 0 0 0 5.196-3.345 6.914 6.914 0 0 0 .205-2.53l-.003-.007a3.356 3.356 0 0 0 .168-.369 10.64 10.64 0 0 0 .234-2.57.52.52 0 0 0-.018-.094z\"/>\n";
        break;
      case "504":
        path = "<defs>\n" +
            "    <style>\n" +
            "      .cls-1{fill-rule:evenodd}\n" +
            "    </style>\n" +
            "  </defs>\n" +
            "  <path d=\"M9.712 2.908c1.786.733 2.906 1.784 2.906 2.953 0 2.213-4.008 4.007-8.953 4.007a18.977 18.977 0 0 1-3.299-.282 16.37 16.37 0 0 0 6.048 1.052 16.768 16.768 0 0 0 5.719-.924 5.344 5.344 0 0 0 1.341-.62c1.164-.716 1.892-1.534 1.892-2.462 0-1.69-2.342-3.136-5.654-3.724z\" class=\"cls-1\"/>\n" +
            "  <path d=\"M5.285 7.363a.988.988 0 1 0-.987-.988.988.988 0 0 0 .987.988zm3.856-1.455a.988.988 0 1 0-.987-.988.988.988 0 0 0 .987.988zm1.156 5.462a.988.988 0 1 0 .988.987.987.987 0 0 0-.988-.988zm-2.54 1.24a.597.597 0 1 0 .597.597.597.597 0 0 0-.597-.597zm4.743-1.902a.597.597 0 1 0 .598.597.597.597 0 0 0-.597-.597zM3.533 8.46a.637.637 0 1 0-.636-.637.637.637 0 0 0 .636.637zm3.792-4.528a.541.541 0 1 0-.541-.542.541.541 0 0 0 .541.542zm-.04 3.073a.636.636 0 1 0 .637-.637.636.636 0 0 0-.637.637z\" class=\"cls-1\"/>\n";
        break;
      case "507":
        path =
            "<path d=\"M12.565 8.867a.028.028 0 0 0 .048.018l1.593-1.462a.074.074 0 0 0 0-.11L12.599 5.84a.027.027 0 0 0-.045.017l.003.654H5.863c-1.106-.706-1.54-1.5-1.52-2.126.034-.988 1.058-1.819 2.552-2.069a3.433 3.433 0 0 1 3.68 1.43.7.7 0 0 0 1.157-.788A4.818 4.818 0 0 0 6.664.936C4.494 1.299 3 2.667 2.945 4.339a3.231 3.231 0 0 0 .782 2.172H2.72a.888.888 0 1 0 0 1.775h3.506a13.08 13.08 0 0 0 2.313.766c2.255.532 3.115 1.555 3.168 2.336.05.742-.565 1.47-1.567 1.854a5.479 5.479 0 0 1-5.503-.75.7.7 0 1 0-.928 1.049 6.697 6.697 0 0 0 4.263 1.523 7.402 7.402 0 0 0 2.67-.515 3.413 3.413 0 0 0 2.462-3.255 3.798 3.798 0 0 0-2.497-3.008h1.957z\"/>\n";
        break;
      case "508":
        path =
            "<path d=\"M12.495 7.754a.029.029 0 0 0 .048.018l1.593-1.461a.074.074 0 0 0 0-.11l-1.607-1.474a.027.027 0 0 0-.045.018l.003.654H4.499a1.795 1.795 0 0 1-.323-.996c.032-.987 1.057-1.818 2.55-2.068a3.45 3.45 0 0 1 3.68 1.43.7.7 0 0 0 1.158-.79A4.825 4.825 0 0 0 6.495.956c-2.169.362-3.663 1.73-3.718 3.402A3.006 3.006 0 0 0 2.949 5.4h-.3a.888.888 0 0 0 0 1.775h1.544A10.022 10.022 0 0 0 8.37 9.07c.187.044.35.096.517.146H2.649a.888.888 0 0 0 0 1.776h8.78a1.372 1.372 0 0 1 .108.413c.05.742-.565 1.47-1.567 1.856a5.48 5.48 0 0 1-5.502-.75.7.7 0 0 0-.928 1.049 6.696 6.696 0 0 0 4.262 1.523 7.396 7.396 0 0 0 2.67-.516 3.413 3.413 0 0 0 2.462-3.256c-.001-.024-.01-.045-.012-.068l1.214-1.114a.074.074 0 0 0 0-.11l-1.607-1.474a.027.027 0 0 0-.045.017l.003.654h-.659a7.045 7.045 0 0 0-3.137-1.509A11.943 11.943 0 0 1 7 7.174h5.493z\"/>\n";
        break;
      case "509":
        path =
            "<path d=\"M12.315 2.086a3.146 3.146 0 0 0-.396.04 4.675 4.675 0 0 0-7.838 0 3.149 3.149 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0 3.185 3.185 0 1 0 1.243-6.116zm1.186 8.214H4.525a.5.5 0 0 0 0 1h8.976a.5.5 0 0 0 0-1zm-2.517 2.313a.5.5 0 0 0-.5-.5H1.508a.5.5 0 1 0 0 1h8.976a.5.5 0 0 0 .5-.5zm1.11 1.344H3.118a.5.5 0 0 0 0 1h8.976a.5.5 0 0 0 0-1z\"/>\n";
        break;
      case "510":
        path =
            "<path d=\"M6.47 5.396a.5.5 0 0 1 .5-.5h8.45a3.05 3.05 0 0 0-3.544-2.77 4.675 4.675 0 0 0-7.838 0 3.149 3.149 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0 3.184 3.184 0 0 0 4.365-2.306H6.97a.5.5 0 0 1-.5-.5zm7.031 4.904H4.525a.5.5 0 0 0 0 1h8.976a.5.5 0 0 0 0-1zm-2.517 2.313a.5.5 0 0 0-.5-.5H1.508a.5.5 0 1 0 0 1h8.976a.5.5 0 0 0 .5-.5zm1.11 1.344H3.118a.5.5 0 0 0 0 1h8.976a.5.5 0 0 0 0-1z\"/>\n";
        break;
      case "511":
        path =
            "<path d=\"M12.543 4.487c-1.581 0-3.876 1.712-4.57 2.888C7.282 6.2 4.987 4.487 3.406 4.487a3.486 3.486 0 0 0 0 6.97c1.58 0 3.876-1.75 4.569-2.906.693 1.156 2.988 2.906 4.569 2.906a3.486 3.486 0 0 0 0-6.97z\"/>\n" +
                "  <circle cx=\"2.989\" cy=\"2.481\" r=\"1\"/>\n" +
                "  <circle cx=\"13\" cy=\"2.481\" r=\"1\"/>\n" +
                "  <circle cx=\"2.989\" cy=\"13.457\" r=\"1\"/>\n" +
                "  <circle cx=\"13\" cy=\"13.457\" r=\"1\"/>\n";
        break;
      case "512":
        path = "<circle cx=\"2.989\" cy=\"2.481\" r=\"1\"/>\n" +
            "  <path d=\"M12.543 4.487c-1.581 0-3.876 1.712-4.57 2.888C7.282 6.2 4.987 4.487 3.406 4.487a3.486 3.486 0 0 0 0 6.97c1.58 0 3.876-1.75 4.569-2.906.693 1.156 2.988 2.906 4.569 2.906a3.486 3.486 0 0 0 0-6.97z\"/>\n" +
            "  <circle cx=\"8.031\" cy=\"2.958\" r=\"1\"/>\n" +
            "  <circle cx=\"8.031\" cy=\"12.98\" r=\"1\"/>\n" +
            "  <circle cx=\"13\" cy=\"2.481\" r=\"1\"/>\n" +
            "  <circle cx=\"2.989\" cy=\"13.457\" r=\"1\"/>\n" +
            "  <circle cx=\"13\" cy=\"13.457\" r=\"1\"/>\n";
        break;
      case "513":
        path = "<circle cx=\"1.989\" cy=\"2.481\" r=\"1\"/>\n" +
            "  <path d=\"M15.947 7.972a3.445 3.445 0 0 0-3.404-3.485c-1.581 0-3.876 1.712-4.57 2.888C7.282 6.2 4.987 4.487 3.406 4.487a3.486 3.486 0 0 0 0 6.97c1.58 0 3.876-1.75 4.569-2.906.693 1.156 2.988 2.906 4.569 2.906a3.445 3.445 0 0 0 3.404-3.485z\"/>\n" +
            "  <circle cx=\"6.031\" cy=\"2.958\" r=\"1\"/>\n" +
            "  <circle cx=\"10.076\" cy=\"2.958\" r=\"1\"/>\n" +
            "  <circle cx=\"6.031\" cy=\"12.987\" r=\"1\"/>\n" +
            "  <circle cx=\"10.076\" cy=\"12.987\" r=\"1\"/>\n" +
            "  <circle cx=\"14\" cy=\"2.481\" r=\"1\"/>\n" +
            "  <circle cx=\"1.989\" cy=\"13.457\" r=\"1\"/>\n" +
            "  <circle cx=\"14\" cy=\"13.457\" r=\"1\"/>\n";
        break;
      case "514":
        path =
            "<path d=\"M13.502 11.3H4.525a.5.5 0 0 1 0-1h8.977a.5.5 0 0 1 0 1zm-3.019 1.813H1.508a.5.5 0 1 1 0-1h8.975a.5.5 0 0 1 0 1zm1.611 1.844H3.118a.5.5 0 1 1 0-1h8.976a.5.5 0 0 1 0 1zM6.047 7.173a.502.502 0 1 1 0-1h8.807A3.15 3.15 0 0 0 15 5.27a3.187 3.187 0 0 0-.059-.583H8.394a.5.5 0 0 1 0-1h6.17a3.17 3.17 0 0 0-2.748-1.601 3.146 3.146 0 0 0-.397.04 4.675 4.675 0 0 0-7.838 0 3.149 3.149 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116 4.61 4.61 0 0 0 6.144 0 3.166 3.166 0 0 0 3.783-1.029z\"/>\n";
        break;
      case "515":
        path =
            "<path d=\"M4.428 8.202a4.61 4.61 0 0 0 6.144 0 3.166 3.166 0 0 0 3.783-1.029H6.047a.502.502 0 1 1 0-1h8.807A3.15 3.15 0 0 0 15 5.27a3.187 3.187 0 0 0-.059-.583H8.394a.5.5 0 0 1 0-1h6.17a3.17 3.17 0 0 0-2.748-1.601 3.146 3.146 0 0 0-.397.04 4.675 4.675 0 0 0-7.838 0 3.149 3.149 0 0 0-.396-.04 3.184 3.184 0 1 0 1.243 6.116zM14.502 10.3H7.525a.5.5 0 0 0 0 1h6.977a.5.5 0 0 0 0-1zm-10.496 0a.5.5 0 0 0 0 1h1.99a.5.5 0 1 0 0-1zm8.807 2.813a.5.5 0 1 0 0-1h-1.989a.5.5 0 0 0 0 1zm-8.316.813h-1.99a.5.5 0 1 0 0 1h1.99a.5.5 0 1 0 0-1zm5.486-1.313a.5.5 0 0 0-.5-.5H1.508a.5.5 0 1 0 0 1h7.975a.5.5 0 0 0 .5-.5zm3.111 1.344H6.118a.5.5 0 0 0 0 1h6.976a.5.5 0 0 0 0-1z\"/>\n";
        break;
    }
    return path;
  }

  String mobileString(String s) {
    if (s.length == 11) {
      s = "${s.substring(0, 3)}****${s.substring(7, s.length)}";
    }
    return s;
  }

  String emailString(String s) {
    if (s.contains('@')) {
      int index = s.indexOf('@');
      try {
        s = "${s.substring(0, 3)}****${s.substring(index, s.length)}";
      } catch (e) {
        //
      }
    }
    return s;
  }

  tokenDown() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString(SPKeys().id);
    String? token = prefs.getString(SPKeys().token);
    try{
      XgFlutterPlugin().deleteAccount(id!, AccountType.UNKNOWN);
      XgFlutterPlugin().deleteAccount(token!, AccountType.UNKNOWN);
      XgFlutterPlugin().deleteTags([id,"test"]);
    }catch(e){
      //
    }
    prefs.remove(SPKeys().token);
    CommonData.tenant = CommonData.tenantDef;
    CommonData.tenantName = CommonData.tenantNameDef;
    CommonData.token = null;
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - CommonData.time > 2000) {
      CommonData.time = now;
      toLogin();
      Future.delayed(const Duration(seconds: 1), () {
        EventBusUtil.getInstance().fire(HhToast(title: '登录信息失效,请重新登录'));
      });
    }
  }

  tokenOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString(SPKeys().id);
    String? token = prefs.getString(SPKeys().token);
    XgFlutterPlugin().deleteAccount(id!, AccountType.UNKNOWN);
    XgFlutterPlugin().deleteAccount(token!, AccountType.UNKNOWN);
    XgFlutterPlugin().deleteTags([id,"test"]);
    prefs.remove(SPKeys().token);
    CommonData.tenant = CommonData.tenantDef;
    CommonData.tenantName = CommonData.tenantNameDef;
    CommonData.token = null;
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - CommonData.time > 2000) {
      CommonData.time = now;
      toLogin();
      Future.delayed(const Duration(seconds: 1), () {
        EventBusUtil.getInstance().fire(HhToast(title: '该账号于其他设备登录,请重新登录'));
      });
    }
  }

  toLogin() async {
    if (CommonData.personal) {
      Get.offAll(() => PersonalLoginPage(),
          binding: PersonalLoginBinding(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 1000));
    } else {
      Get.offAll(() => CompanyLoginPage(),
          binding: CompanyLoginBinding(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 1000));
    }
  }

  parseCache(double size) {
    if (size < 999) {
      return "${parseDoubleNumber("$size", 1)}bit";
    } else if (size < 999999) {
      return "${parseDoubleNumber("${size / 1000}", 1)}Kb";
    } else {
      return "${parseDoubleNumber("${size / 1000000}", 1)}M";
    }
  }

  String parseDoubleNumber(String str, int number) {
    String rt = "0";
    int index = 0;
    index = str.indexOf('.');
    try {
      rt = str.substring(0, index + 1 + number);
    } catch (e) {
      rt = str;
    }
    return rt;
  }
  String parseMinuteUpload(String str) {
    int a = 0;
    try {
      a = int.parse(str);
      a = parseDoubleToInt("${a/60}");
    } catch (e) {
      a = 0;
    }
    return "$a";
  }
  int parseDoubleToInt(String str) {
    int rt = 0;
    int index = 0;
    index = str.indexOf('.');
    try {
      rt = int.parse(str.substring(0, index));
    } catch (e) {
      rt = 0;
    }
    return rt;
  }
  double parseDoubleNumberToDouble(String str, int number) {
    String rt = "0";
    int index = 0;
    index = str.indexOf('.');
    try {
      rt = str.substring(0, index + 1 + number);
    } catch (e) {
      rt = str;
    }
    return double.parse(rt);
  }

  Future<void> parseRouteDetail(item) async {
    /*EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {};
    map['pageNo'] = 1;
    map['pageSize'] = 10;
    // map['label'] = "";
    map['dictType'] = "device_type";
    var result = await HhHttp().request(RequestUtils.productType,
        method: DioMethod.get, params: map);
    HhLog.d("productType -- $item");
    HhLog.d("productType -- $map");
    HhLog.d("productType -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0) {
      // EventBusUtil.getInstance().fire(HhToast(title: "操作成功", type: 1));
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }*/

    if(item['productKey'] == '5MiTcinKdSasKdKQ'){
      ///道闸
      Get.to(()=>DaoZhaDetailPage('${item['deviceNo']}','${item['id']}',item['shareMark'],"${item['status']}"!="1"),binding: DaoZhaDetailBinding());
    // }else if(item['productKey'] == 'R45bbC4eBxm3555D'){//TODO 测试调试
    }else if(item['productKey'] == 'Dhs5Kt8bbZaKrCCz'){
      ///运维箱
      Get.to(()=>YunWeiDetailPage('${item['deviceNo']}','${item['id']}',item['shareMark']),binding: YunWeiDetailBinding());
    }else if (item['productKey'] == 'aSkWAXGKPh4zEcjE'){
      ///浩海智慧立杆
      Get.to(()=>LiGanDeviceDetailPage('${item['deviceNo']}','${item['id']}',item['shareMark'],"${item['status']}"!="1"),binding: LiGanDeviceDetailBinding());
    }else if (item['productKey'] == '2QWASjR4T7aetr7G'){
      ///火险因子监测站
      Get.to(()=>HXYZDeviceDetailPage('${item['deviceNo']}','${item['id']}',item['shareMark'],"${item['status']}"!="1"),binding: HXYZDeviceDetailBinding());
    }else if (item['productKey'] == 'R45bbC4eBxm3555D'){
      ///一体机
      Get.to(()=>DeviceDetailPage('${item['deviceNo']}','${item['id']}',item['shareMark'],"${item['status']}"!="1"),binding: DeviceDetailBinding());
    }else{
      Get.to(()=>DeviceDetailPage('${item['deviceNo']}','${item['id']}',item['shareMark'],"${item['status']}"!="1"),binding: DeviceDetailBinding());
    }
  }

  parseDeviceImage(item){
    if(item['productKey'] == '5MiTcinKdSasKdKQ'){
      ///道闸-高清车牌识别一体机
      return "assets/images/common/icon_b.png";
    // }else if (item['productKey'] == 'R45bbC4eBxm3555D'){//TODO 测试调试
    }else if (item['productKey'] == 'Dhs5Kt8bbZaKrCCz'){
      ///智能运维箱
      return "assets/images/common/icon_e.png";
    }else if (item['productKey'] == 'aSkWAXGKPh4zEcjE'){
      ///浩海智慧立杆
      return "assets/images/common/icon_d.png";
    }else if (item['productKey'] == '2QWASjR4T7aetr7G'){
      ///火险因子监测站
      return "assets/images/common/icon_e.png";
    }else if (item['productKey'] == 'R45bbC4eBxm3555D'){
      ///一体机
      return "assets/images/common/icon_c.png";
    }else{
      return "assets/images/common/icon_c.png";
    }
  }
  parseDeviceBackImage(item){
    if(item['productKey'] == '5MiTcinKdSasKdKQ'){
      ///道闸-高清车牌识别一体机
      return "assets/images/common/test_video.jpg";
    // }else if (item['productKey'] == 'R45bbC4eBxm3555D'){//TODO 测试调试
    }else if (item['productKey'] == 'Dhs5Kt8bbZaKrCCz'){
      ///智能运维箱
      return "assets/images/common/test_video_ywx.png";
    }else if (item['productKey'] == 'aSkWAXGKPh4zEcjE'){
      ///浩海智慧立杆
      return "assets/images/common/test_video.jpg";
    }else if (item['productKey'] == '2QWASjR4T7aetr7G'){
      ///火险因子监测站
      return "assets/images/common/test_video.jpg";
    }else if (item['productKey'] == 'R45bbC4eBxm3555D'){
      ///一体机
      return "assets/images/common/test_video.jpg";
    }else{
      return "assets/images/common/test_video.jpg";
    }
  }

  static line({double? marginTop,double? marginBottom,EdgeInsets? margin,Color? color,double? height}) {
    return Container(
      margin: margin??EdgeInsets.fromLTRB(0, marginTop??0, 0, marginBottom??0),
      color: color??HhColors.grayE8BackColor,
      width: 1.sw,
      height: height??1.w,
    );
  }

  static backView({EdgeInsets? margin,EdgeInsets? padding,bool? white,String? title}) {
    return Container(
      margin: margin??EdgeInsets.only(top:30.w*3),
      padding: padding??EdgeInsets.all(20.w*3),
      color: HhColors.trans,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            white==true?"assets/images/common/back_white.png":"assets/images/common/icon_back_left.png",
            width: 9.w*3,
            height: 16.w*3,
            fit: BoxFit.fill,
          ),
          SizedBox(width: 7.w*3,),
          Text(title??'返回',style: TextStyle(
              color: white==true?HhColors.whiteColor:HhColors.textBlackColor,
              fontSize: 16.sp*3,
              fontWeight: FontWeight.w400
          ),)
        ],
      ),
    );
  }


  String parseStringTimeYearDay(String s) {
    s = s.replaceAll(" ", "");
    s = "${s.substring(0,10)} ${s.substring(10,s.length)}";
    DateTime date = DateTime.parse(s);
    String time = date.toIso8601String();
    time = time.substring(0, 10);
    time = time.replaceAll("T", " ");
    return time;
  }


  String parseStringTimeAll(String s) {
    s = s.replaceAll(" ", "");
    s = "${s.substring(0,10)} ${s.substring(10,s.length)}";
    DateTime date = DateTime.parse(s);
    String time = date.toIso8601String();
    time = time.substring(0, 19);
    time = time.replaceAll("T", " ");
    return time;
  }


  String parseNullExpect(dynamic s, String def) {
    String r = "$s";
    if (s == null || s == "null") {
      r = def;
    }
    return r.replaceAll("null", "");
  }

  late VideoPlayerController _controller;
  final Rx<bool> _showControls = true.obs;//控制是否显示播放按钮&进度条
  final Rx<bool> playStatus = true.obs;//播放暂停
  final Rx<bool> state = true.obs;//状态
  Future<bool> onWillPop() async {
    _controller.dispose();
    state.value = false;
    return true; // 返回 false 阻止对话框关闭
  }
  void checkVideoEnded() {
    if (_controller != null &&
        _controller!.value.position >= _controller!.value.duration) {
      _showControls.value = true;//播放结束显示控制按钮
      playStatus.value = false;
    }
  }
  ///视频查看Dialog
  showVideoFileDialog(
      context, {
        required String url,
        String? asset,
      }) async {
    _controller = VideoPlayerController.network(url,videoPlayerOptions: VideoPlayerOptions(
      mixWithOthers: true,
      allowBackgroundPlayback: false, // <— 强制texture输出关键配置
    ))
      ..initialize().then((_) {
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
        ));
        state.value = true;
        EventBusUtil.getInstance().fire(HhLoading(show: false));
        _controller.play();
        Get.dialog(
          WillPopScope(
            onWillPop: () async {
              _controller.pause();
              _controller.dispose();
              SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.dark,
              ));
              return true;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Obx(() => state.value?SafeArea(
                top: false,
                child: Container(
                  height: 1.sh,
                  width: 1.sw,
                  color: HhColors.blackRealColor,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 1.sw,
                        child: Center(
                          child: _controller == null
                              ? const Text("视频不存在",style: TextStyle(color: HhColors.whiteColor),)
                              : _controller.value.isInitialized
                              ? GestureDetector(
                            onTap: () {
                              _showControls.value = !_showControls.value; // 点击切换控制条显示
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                RepaintBoundary(
                                  child: Opacity(
                                    opacity: 1,
                                    child: AspectRatio(
                                      aspectRatio: _controller.value.aspectRatio,
                                      child: VideoPlayer(_controller),
                                    ),
                                  ),
                                ),

                                // 播放/暂停按钮
                                if (_showControls.value)
                                  Positioned(
                                    child: IconButton(
                                      iconSize: 60,
                                      icon: Icon(
                                        playStatus.value
                                            ? Icons.pause_circle_filled
                                            : Icons.play_circle_filled,
                                        color: Colors.white.withAlpha(100),
                                      ),
                                      onPressed: () {
                                        _controller.value.isPlaying
                                            ? _controller.pause()
                                            : _controller.play();
                                        Future.delayed(const Duration(milliseconds: 200),(){
                                          if(_controller.value.isPlaying){
                                            playStatus.value = true;
                                          }else{
                                            playStatus.value = false;
                                          }
                                        });
                                      },
                                    ),
                                  ),

                                // 视频进度条
                                if (_showControls.value)
                                  Positioned(
                                    bottom: 10,
                                    left: 0,
                                    right: 0,
                                    child: VideoProgressIndicator(
                                      _controller,
                                      allowScrubbing: true, // 允许拖动进度条
                                      colors: const VideoProgressColors(
                                        playedColor: Colors.blue,
                                        bufferedColor: Colors.grey,
                                        backgroundColor: Colors.black,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )
                              : CircularProgressIndicator(),
                        ),
                      ),
                      Container(
                        height: 50.w * 3,
                        width: 1.sw,
                        color: HhColors.whiteColor,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                '视频查看',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: HhColors.blackTextColor,
                                    fontSize: 18.sp * 3,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: BouncingWidget(
                                duration: const Duration(milliseconds: 100),
                                scaleFactor: 0.5,
                                onPressed: () {
                                  _controller.pause();
                                  _controller.dispose();
                                  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
                                    statusBarColor: Colors.transparent,
                                    statusBarBrightness: Brightness.dark,
                                    statusBarIconBrightness: Brightness.dark,
                                  ));
                                  Get.back();
                                },
                                child: Material(
                                  child: CommonUtils.backView(
                                    margin: EdgeInsets.fromLTRB(20.w * 3, 0, 0, 0),
                                    padding: EdgeInsets.fromLTRB(0, 10.w, 20.w, 10.w),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ):const SizedBox()),
            ),
          ),
          barrierColor: Colors.black87,
          useSafeArea: true,
        );
      });
  }


  int parseTotalPage(String s, int pageSize) {
    int page = 1;
    try{
      int allCount = int.parse(s);
      page = (allCount + pageSize - 1) ~/ pageSize;
    }catch(e){
      //
    }
    return page;
  }

}

///通用Button
class CommonButton extends StatelessWidget {
  String text;
  double? width;
  double? height;
  double? widthPercent;
  EdgeInsets? margin;
  EdgeInsets? padding;
  double? fontSize;
  bool? solid;
  Color? backgroundColor;
  Color? solidColor;
  Color? textColor;
  double? borderRadius;
  double? elevation;
  Function onPressed;
  Alignment? textAlign;
  Function? onPointerDown;
  Function? onPointerUp;
  LinearGradient? gradient;
  String? image;

  CommonButton(
      {required this.text,
      required this.onPressed,
      this.width,
      this.textAlign,
      this.height,
      this.image,
      this.gradient,
      this.widthPercent,
      this.margin,
      this.onPointerDown,
      this.onPointerUp,
      this.padding,
      this.fontSize,
      this.solid,
      this.backgroundColor,
      this.solidColor,
      this.textColor,
      this.borderRadius,
      this.elevation});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Listener(
      onPointerDown: (down) {
        onPointerDown!();
      },
      onPointerUp: (up) {
        onPointerUp!();
      },
      child: Container(
        height: height ?? 85.w,
        width: width != null
            ? width
            : widthPercent != null
                ? screenWidth * widthPercent!
                : screenWidth,
        margin: margin ?? EdgeInsets.fromLTRB(15, 0, 15, 0),
        decoration: (solid != null && solid!) || solidColor != null
            ? BoxDecoration(
                border: Border.all(
                    color: solidColor ?? HhColors.transYellow, width: 1),
                borderRadius: BorderRadius.circular(borderRadius ?? 10.w),
              )
            : null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius ?? 10.w),
          child: Material(
            elevation: elevation ?? 0.6,
            color: gradient != null
                ? null
                : (backgroundColor ??
                    ((solid != null && solid!) || solidColor != null
                        ? HhColors.whiteColor
                        : HhColors.transYellow)),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(borderRadius ?? 10.w))),
            child: InkWell(
              child: Container(
                  decoration: BoxDecoration(gradient: gradient),
                  alignment: textAlign ?? Alignment.center,
                  padding: padding,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      image == null
                          ? SizedBox()
                          : Container(
                              margin: EdgeInsets.fromLTRB(0, 5.w, 10.w, 0),
                              child: Image.asset(
                                "${image ?? ""}",
                                width: 36.w,
                                height: 36.w,
                              )),
                      Text(
                        text,
                        style: TextStyle(
                            color: textColor ?? HhColors.whiteColor,
                            fontSize: fontSize ?? 16),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
              onTap: () {
                onPressed();
              },
            ),
          ),
        ),
      ),
    );
  }
}
