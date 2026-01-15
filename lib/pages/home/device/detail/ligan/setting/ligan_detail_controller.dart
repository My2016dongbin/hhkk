import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/socket/WebSocketManager.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:iot/utils/SPKeys.dart';
import 'package:iot/widgets/jump_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;

class LiGanDetailController extends GetxController {
  late BuildContext context;
  final Rx<bool> testStatus = true.obs;
  final Rx<bool> warnGANG1 = false.obs;
  final Rx<bool> warnGANG2 = false.obs;
  final Rx<bool> warnGANG3 = false.obs;
  final Rx<bool> warnBALL = false.obs;
  final Rx<bool> warnSENSOR = false.obs;
  final Rx<bool> warnOPEN = false.obs;
  final Rx<bool> energyAction = false.obs;
  final Rx<bool> weatherAction = false.obs;
  final Rx<bool> soilAction = false.obs;
  final Rx<String> recordTimes = '00:00:00'.obs;
  final Rx<String> energyDelay = ''.obs;
  final Rx<String> weatherDelay = ''.obs;
  final Rx<String> soilDelay = ''.obs;
  final Rx<String> deviceVer = ''.obs;
  final Rx<int> deviceFireLevel = 999.obs;
  final Rx<int> tabIndex = 0.obs;
  final Rx<int> fireLevel = 0.obs;//防火等级
  final Rx<int> circle = 0.obs;//枪球联动 0关 1开
  final Rx<int> version = 0.obs;//固件版本号
  final Rx<String> versionStr = ''.obs;//固件版本号
  final Rx<int> playing = 0.obs;//播放1 停止0
  final Rx<int> voiceHuman = 3.obs;//音量
  final Rx<int> voiceCar = 3.obs;//音量
  final Rx<int> voiceCap = 3.obs;//音量
  final Rx<int> speed = 6.obs;//滑动速度
  final Rx<bool> close = false.obs;//息屏开关
  final Rx<int> closeTab = 0.obs;//息屏开关 1常开0常闭2触发
  final Rx<int> direction = 0.obs;//滑动方向 0向上  1向下
  final Rx<String> name = ''.obs;
  final Rx<String> ledContent = ''.obs;
  final Rx<String> ledTime = ''.obs;
  late List<dynamic> voiceTopList = [];
  final Rx<bool> voiceTopStatus = true.obs;
  late List<dynamic> versionList = [];
  final Rx<bool> versionStatus = true.obs;
  late List<dynamic> voiceBottomList = [];
  final Rx<bool> voiceBottomStatus = true.obs;
  late dynamic config = {};
  late String deviceNo = '24070888';
  late WebSocketManager manager;
  late TextEditingController showContentController = TextEditingController();
  late List<dynamic> warnSettingList = [];
  late String id;
  TextEditingController? time1Controller = TextEditingController();
  TextEditingController? time2Controller = TextEditingController();
  TextEditingController? time3Controller = TextEditingController();

  final GlobalKey<AudioDotsVisualizerState> visualizerKey = GlobalKey();
  final Rx<bool> personStatus = false.obs;
  final Rx<String> personStart = ''.obs;
  final Rx<String> personEnd = ''.obs;
  final Rx<bool> carStatus = false.obs;
  final Rx<String> carStart = ''.obs;
  final Rx<String> carEnd = ''.obs;
  final Rx<bool> openStatus = false.obs;
  final Rx<String> openStart = ''.obs;
  final Rx<String> openEnd = ''.obs;
  final Rx<bool> closeStatus = false.obs;
  final Rx<String> closeStart = ''.obs;
  final Rx<String> closeEnd = ''.obs;
  final Rx<int> energySetType = 0.obs;//太阳能 能源类型（锂电、液体、胶体、AMG）

  //锂电
  final Rx<double> liVP = 0.0.obs;//太阳能 过充保护
  final Rx<double> liVR = 0.0.obs;//太阳能 过充恢复
  final Rx<int> liS = 0.obs;//太阳能 零度充电 （正常、禁冲、慢充）index
  final List<String> liSList = ["正常","禁冲","慢充"];//太阳能 零度充电 （正常、禁冲、慢充）
  //液体、胶体、AMG
  final Rx<double> equalV = 14.8.obs;//太阳能 均衡充电压
  final Rx<double> strongV = 14.5.obs;//太阳能 强充电压
  final Rx<double> floatV = 13.7.obs;//太阳能 浮充电压
  //公共
  final Rx<int> ratedL = 0.obs;//太阳能 电压等级
  final Rx<double> lowVR = 12.0.obs;//太阳能 低压恢复
  final Rx<double> lowVP = 11.2.obs;//太阳能 低压保护

  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  final Rx<String> localVoice = ''.obs;

  @override
  Future<void> onInit() async {
    Future.delayed(const Duration(seconds: 1),(){
      //getDeviceInfo();
      getDeviceConfig();
      getVoiceUse();
      getVersion();
      _recorder.openRecorder();
    });
    super.onInit();
  }


  Future<void> getDeviceInfo() async {
    Map<String, dynamic> map = {};
    map['id'] = id;
    var result = await HhHttp().request(RequestUtils.deviceInfo,method: DioMethod.get,params: map);
    HhLog.d("getDeviceInfo -- $id");
    HhLog.d("getDeviceInfo -- $result");
    if(result["code"]==0 && result["data"]!=null){
      name.value = "${result["data"]["spaceName"]}-${result["data"]["name"]}";
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> getVoiceUse() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    var result = await HhHttp().request(RequestUtils.deviceVoiceTop,method: DioMethod.get);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("getVoiceUse -- $result");
    if(result["code"]==0 && result["data"]!=null){
      voiceTopList = result["data"]["list"];
      voiceTopStatus.value = false;
      voiceTopStatus.value = true;
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> getVersion() async {
    var result = await HhHttp().request(RequestUtils.deviceVersion,method: DioMethod.get);
    HhLog.d("getVersion -- $result");
    if(result["code"]==0 && result["data"]!=null){
      versionList = result["data"]["list"];
      if(versionList.isNotEmpty){
        versionStr.value = versionList[0]['version'];
      }
      versionStatus.value = false;
      versionStatus.value = true;
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> postScreenTop() async {
    dynamic data = {
      "deviceNo": deviceNo,
      "cmdType": "ledSetParam",
      "speed": speed.value,
      "direction": direction.value==1?"down":"up",
      "content": showContentController.text
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("postScreenTop -- $data");
    HhLog.d("postScreenTop -- $result");
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "设置成功",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> postScreenBottom() async {
    dynamic data = {
      "deviceNo": deviceNo,
      "cmdType": "ledSetSwitch",
      "switchType": closeTab.value,
      "time": ledTime.value,
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("postScreenBottom -- $data");
    HhLog.d("postScreenBottom -- $result");
    /*if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "设置成功",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }*/
  }

  Future<void> getDeviceConfig() async {
    Map<String, dynamic> map = {};
    map['deviceNo'] = deviceNo;
    var result = await HhHttp().request(RequestUtils.deviceConfig,method: DioMethod.get,params: map);
    HhLog.d("getDeviceConfig -- $deviceNo");
    HhLog.d("getDeviceConfig -- $result");
    if(result["code"]==0 && result["data"]!=null){
      config = result["data"];
      try{
        personStart.value = "${config["audioHumanTime"]}".substring(0,8);
        personEnd.value = "${config["audioHumanTime"]}".substring(9,17);
      }catch(e){
        //
      }
      try{
        carStart.value = "${config["audioCarTime"]}".substring(0,8);
        carEnd.value = "${config["audioCarTime"]}".substring(9,17);
      }catch(e){
        //
      }
      try{
        openStart.value = "${config["audioOpenTime"]}".substring(0,8);
        openEnd.value = "${config["audioOpenTime"]}".substring(9,17);
      }catch(e){
        //
      }
      try{
        closeStart.value = "${config["ledTime"]}".substring(0,8);
        closeEnd.value = "${config["ledTime"]}".substring(9,17);
      }catch(e){
        //
      }
      voiceBottomList = result["data"]["audioArray"];
      voiceBottomStatus.value = false;
      voiceBottomStatus.value = true;
      warnGANG1.value = config["gcam1Enable"] == "ON";
      warnGANG2.value = config["gcam2Enable"] == "ON";
      warnGANG3.value = config["gcam3Enable"] == "ON";
      warnBALL.value = config["scam1Enable"] == "ON";
      warnSENSOR.value = config["sensorEnable"] == "ON";
      warnOPEN.value = config["capEnable"] == "ON";
      energyAction.value = config["energyAction"] == "ON";
      weatherAction.value = config["weatherAction"] == "ON";
      soilAction.value = config["soilAction"] == "ON";
      energyDelay.value = CommonUtils().parseMinuteUpload('${config["energyDelay"]}');
      weatherDelay.value = CommonUtils().parseMinuteUpload('${config["weatherDelay"]}');
      soilDelay.value = CommonUtils().parseMinuteUpload('${config["soilDelay"]}');
      time1Controller!.text = energyDelay.value;
      time2Controller!.text = weatherDelay.value;
      time3Controller!.text = soilDelay.value;
      deviceVer.value = '${config["deviceVer"]}';
      versionStr.value = '${config["deviceVer"]}';
      deviceFireLevel.value = config["deviceFireLevel"];
      fireLevel.value = deviceFireLevel.value;
      direction.value = config["ledDirection"]=="down"?1:0;
      speed.value = config["ledSpeed"];
      ledContent.value = config["ledContent"];
      showContentController.text = ledContent.value;
      close.value = config["ledEnable"]==1;
      ledTime.value = config["ledTime"];
      voiceHuman.value = config["audioHumanVolume"];
      voiceCar.value = config["audioCarVolume"];
      voiceCap.value = config["audioOpenVolume"];
      ///太阳能
      energySetType.value = config["energySetType"];//太阳能 能源类型（锂电、液体、胶体、AMG）
      //锂电
      liVP.value = config["liVP"];//太阳能 过充保护
      liVR.value = config["liVR"];//太阳能 过充恢复
      liS.value = config["liS"];//太阳能 零度充电 （正常、禁冲、慢充）
      //液体、胶体、AMG
      equalV.value = config["equalV"];//太阳能 均衡充电压
      strongV.value = config["strongV"];//太阳能 强充电压
      floatV.value = config["floatV"];//太阳能 浮充电压
      //公共
      ratedL.value = config["ratedL"];//太阳能 电压等级
      lowVR.value = config["lowVR"];//太阳能 低压恢复
      lowVP.value = config["lowVP"];//太阳能 低压保护
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> uploadVoice(String name,String url) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "switchType": "start",
      "cmdType": "audioSetData",
      "url": url,
      "name": name,
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("uploadVoice -- $data");
    HhLog.d("uploadVoice -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "上传成功",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> playVoice(String name) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "switchType": "play",
      "cmdType": "audioSetData",
      "name": name
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("playVoice -- $data");
    HhLog.d("playVoice -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "播放成功",type: 1));
      playing.value = 1;
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> stopVoiceLocal() async {
    _player.stopPlayer();
  }
  Future<void> playVoiceLocal(String url) async {
    await _player.openPlayer();

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      return;
    }

    // 假设你知道采样率、声道数等信息
    const sampleRate = 16000;
    const numChannels = 1;
    const bitsPerSample = 16;

    final data = response.bodyBytes;

    await _player.startPlayer(
      fromDataBuffer: data,
      codec: Codec.pcm16,
      sampleRate: sampleRate,
      numChannels: numChannels,
      whenFinished: (){
        localVoice.value = "";
      },
    );
  }
  Future<void> stopVoice() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "switchType": "stop",
      "cmdType": "audioSetData"
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("stopVoice -- $data");
    HhLog.d("stopVoice -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "已停止播放",type: 1));
      playing.value = 0;
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> deleteVoice(String name) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true,title: "正在删除，请稍后…"));
    dynamic data = {
      "deviceNo": deviceNo,
      "switchType": "delet",
      "cmdType": "audioSetData",
      "name": name
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("deleteVoice -- $data");
    HhLog.d("deleteVoice -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "删除成功",type: 1));
      getVoiceUse();
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> deleteWebVoice(dynamic model) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true,title: "正在删除，请稍后…"));
    Map<String, dynamic> map = {};
    map['id'] = model["id"];
    var result = await HhHttp().request(RequestUtils.voiceDelete,method: DioMethod.delete,params: map);
    HhLog.d("deleteWebVoice -- $map");
    HhLog.d("deleteWebVoice -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "删除成功",type: 1));
      getVoiceUse();
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> voiceSubmitHuman() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "cmdType": "audioSetParam",
      "switchType": config["audioHumanEnable"],
      "alarmType": "human",
      "name": config["audioHumanName"],
      "volume": voiceHuman.value,
      "time": config["audioHumanTime"]
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("voiceSubmitHuman -- $data");
    HhLog.d("voiceSubmitHuman -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "设置成功",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> voiceSubmitCar() async {
    // EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "cmdType": "audioSetParam",
      "switchType": config["audioCarEnable"],
      "alarmType": "car",
      "name": config["audioCarName"],
      "volume": voiceCar.value,
      "time": config["audioCarTime"]
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("voiceSubmitCar -- $data");
    HhLog.d("voiceSubmitCar -- $result");
    // EventBusUtil.getInstance().fire(HhLoading(show: false));
    /*if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }*/
  }
  Future<void> voiceSubmitCap() async {
    // EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "cmdType": "audioSetParam",
      "switchType": config["audioOpenEnable"],
      "alarmType": "open",
      "name": config["audioOpenName"],
      "volume": voiceCap.value,
      "time": config["audioOpenTime"]
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("voiceSubmitCap -- $data");
    HhLog.d("voiceSubmitCap -- $result");
    // EventBusUtil.getInstance().fire(HhLoading(show: false));
    /*if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }*/
  }
  Future<void> settingLevel() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "cmdType": "deviceSetLevel",
      "value": fireLevel.value
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("settingLevel -- $data");
    HhLog.d("settingLevel -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "设置成功",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> resetDevice() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "cmdType": "deviceSetReboot"
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("resetDevice -- $data");
    HhLog.d("resetDevice -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "重启下发成功",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> versionUpdate() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "cmdType": "deviceSetOTA",
      "url": "${versionList[version.value]["url"]}",
      "version": "${versionList[version.value]["version"]}"
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("versionUpdate -- $data");
    HhLog.d("versionUpdate -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "下发成功",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> warnSet(String value,String type) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "cmdType": "alarmSetSwitch",
      "value": value,
      "switchType": type
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("versionUpdate -- $data");
    HhLog.d("versionUpdate -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "设置成功",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> warnUploadSet(String value,String type,int delay,String time) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "cmdType": "dataSetSwitch",
      "value": value,
      "switchType": type,
      "delay": delay,
      "time": time,
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("versionUpdate -- $data");
    HhLog.d("versionUpdate -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "设置成功",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> sunSetting() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "cmdType": "energySetParam",
      "liVP": liVP.value,
      "ratedL": ratedL.value,
      "liVR": liVR.value,
      "liS": liS.value,
      "lowVP": lowVP.value,
      "lowVR": lowVR.value,
      "equalV": equalV.value,
      "strongV": strongV.value,
      "floatV": floatV.value,
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("sunSetting -- $data");
    HhLog.d("sunSetting -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "设置成功",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  void startRecord() {
    visualizerKey.currentState?.start();
    recordDateTime = DateTime(2025);
    videoTag.value = true;
    runRecordTimer();
    recording();
  }

  void stopRecord() {
    visualizerKey.currentState?.stop();
    videoTag.value = false;
    recordingComplete();

    CommonUtils().showCommonInputDialog(context, "录音", controller, (){
      Get.back();
    }, (){
      Get.back();
      uploadFile(_pcmPath??"","${controller.text}.pcm");
    });
  }

  late TextEditingController controller = TextEditingController();
  late DateTime recordDateTime = DateTime(2025);
  final Rx<bool> videoTag = false.obs;
  void runRecordTimer() {
    Future.delayed(const Duration(seconds: 1),(){
      recordDateTime = recordDateTime.add(const Duration(seconds: 1));
      recordTimes.value = "${CommonUtils().parseZero(recordDateTime.hour)}:${CommonUtils().parseZero(recordDateTime.minute)}:${CommonUtils().parseZero(recordDateTime.second)}";
      if(recordDateTime.minute >= 3){
        Get.back();
        return;
      }
      if(videoTag.value){
        runRecordTimer();
      }
    });
  }

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool isRecording = false;
  String? _pcmPath;
  Future<void> recording() async {
    await Permission.microphone.request();
    if (await Permission.microphone.isGranted) {
      _pcmPath = await _getPCMPath();

      await _recorder.startRecorder(
        toFile: _pcmPath,
        codec: Codec.pcm16,
        sampleRate: 16000,
        numChannels: 1,
        bitRate: 16000 * 16,
      );
    } else {
      EventBusUtil.getInstance().fire(HhToast(title: "麦克风权限未授权"));

      videoTag.value = false;
      Get.back();
    }
  }
  Future<void> recordingComplete() async {
    await _recorder.stopRecorder();
  }

  Future<String> _getPCMPath() async {
    final dir = await getApplicationCacheDirectory();
    return '${dir.path}/recording.pcm';
  }


  void uploadFile(String filePath,String fileName) async {
    final oldFile = File(filePath);

    // 确保文件存在
    if (await oldFile.exists()) {
      // 获取目录路径
      final dir = oldFile.parent.path;
      // 新文件路径
      final newFilePath = '$dir/$fileName';
      final newFile = await oldFile.rename(newFilePath);


      EventBusUtil.getInstance().fire(HhLoading(show: true,title: "文件上传中..."));
      var dio = Dio();
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(newFile.path,
            filename: fileName),
        "path": newFile.path,
      });

      try {
        var response = await dio.post(
          RequestUtils.fileUpload,
          data: formData,
          options: Options(
            headers: {
              "Authorization": "Bearer ${CommonData.token}",
              "Tenant-Id":"${CommonData.tenant}",
            },
          ),
        );
        EventBusUtil.getInstance().fire(HhLoading(show: false));
        if(response.data.toString().contains("401")){
          CommonUtils().tokenDown();
        }
        HhLog.d("上传成功: ${response.data}");
        String url = response.data["data"];
        postAudioUrl(url,fileName);
      } catch (e) {
        HhLog.d("上传失败: $e");
      }
    } else {
      //print('文件不存在: $filePath');
    }
  }

  Future<void> postAudioUrl(String url,String fileName) async {
    dynamic data = {};
    data['name'] = fileName;
    data['pcmUrl'] = url;
    data['description'] = "App上传";
    var result = await HhHttp().request(RequestUtils.audioCreate,method: DioMethod.post,data: data);
    HhLog.d("postAudioUrl -- $data");
    HhLog.d("postAudioUrl -- $result");
    if(result["code"]==0 && result["data"]!=null){
      getVoiceUse();
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

}
