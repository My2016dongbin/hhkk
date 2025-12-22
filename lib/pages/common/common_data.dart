import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:iot/utils/HhColors.dart';

class CommonData{
  static int time = 0;
  static double ?latitude;
  static double ?longitude;
  static String ?token;
  ///false企业 true个人
  static bool personal = false;
  ///false正式版 true测试版
  static bool test = false;
  static String ?tenantName = personal?'haohai':null;
  static String ?tenant = personal?'1':null;
  static String ?tenantTitle = '';
  static String ?tenantUserType;
  static String ?tenantNameDef = personal?'haohai':null;
  static String ?tenantDef = personal?'1':null;
  static String ?deviceNo;
  static String ?sessionId;
  static String ?endpoint = "http://117.132.5.139:18033/iot-file";
  static String info = "";
  static String loadingInfo = "正在加载，请稍后…";
  static const String loadingInfoFinal = "正在加载，请稍后…";
  static int versionTime = 0;
  static BuildContext? context;
}