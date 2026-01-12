import 'package:flutter/cupertino.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';

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
  static List<dynamic> checkedChannels = [{},{},{},{},{},{},{},{},];
  static String videoSearch = "";
  static String webSocketUrl = "ws://117.132.5.139:18030/";
  static String mqttIP = "222.173.83.190";
  static int mqttPORT = 10060;
  static String mqttAccount = "admin";
  static String mqttPassword = "QIyG0!bhfS";
  static String chatTopic = "/device/pole/chat/";//$id


  ///高德地图key
  static AMapApiKey aMapApiKey = const AMapApiKey(iosKey: "7d20ebdef372335e82fb6a0a9bfdf208",androidKey: "bc4cc96f5e72f529f67c5295ade91b92");

  ///火险因子
  static const String productKeyFireRiskFactor = "2QWASjR4T7aetr7G";
  ///智慧立杆卡口
  static const String productKeyFireSmartPole= "aSkWAXGKPh4zEcjE";


  static void clear(){
    tenant = CommonData.tenantDef;
    tenantName = CommonData.tenantNameDef;
    token = null;
    checkedChannels = [{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},];
    videoSearch = "";
  }


  static void removeChannel(String id){
    for (int i = 0; i < checkedChannels.length; i++) {
      dynamic channel = checkedChannels[i];
      if(channel["id"]!=null && "${channel["id"]}" == id){
        checkedChannels[i] = {};
        return;
      }
    }
  }

}