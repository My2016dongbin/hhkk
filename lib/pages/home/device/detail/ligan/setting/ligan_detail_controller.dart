import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:audio_session/audio_session.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/socket/WebSocketManager.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:iot/widgets/jump_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  final Rx<String> sensorDelay = '0'.obs;
  final Rx<String> capDelay = '0'.obs;
  final Rx<String> energyDelay = ''.obs;
  final Rx<String> weatherDelay = ''.obs;
  final Rx<String> soilDelay = ''.obs;
  final Rx<String> energyStart = '00:00:00'.obs;
  final Rx<String> energyEnd = '23:59:59'.obs;
  final Rx<String> weatherStart = '00:00:00'.obs;
  final Rx<String> weatherEnd = '23:59:59'.obs;
  final Rx<String> soilStart = '00:00:00'.obs;
  final Rx<String> soilEnd = '23:59:59'.obs;
  final Rx<int> alarmLedEnable = 0.obs;
  final Rx<String> alarmLedStart = '00:00:00'.obs;
  final Rx<String> alarmLedEnd = '23:59:59'.obs;
  final Rx<String> deviceVer = ''.obs;
  final Rx<int> deviceFireLevel = 999.obs;
  final Rx<int> tabIndex = 0.obs;
  final Rx<int> fireLevel = 0.obs; //防火等级
  final Rx<int> circle = 0.obs; //枪球联动 0关 1开
  final Rx<int> version = 0.obs; //固件版本号
  final Rx<String> versionStr = ''.obs; //固件版本号
  final Rx<int> playing = 0.obs; //播放1 停止0
  final Rx<int> voiceHuman = 3.obs; //音量
  final Rx<int> voiceCar = 3.obs; //音量
  final Rx<int> voiceCap = 3.obs; //音量
  final Rx<int> speed = 6.obs; //滑动速度
  final Rx<bool> close = false.obs; //息屏开关
  final Rx<int> closeTab = 0.obs; //息屏开关 1常开0常闭2触发
  final Rx<int> direction = 0.obs; //滑动方向 0向上  1向下
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
  final Rx<int> energySetType = 0.obs; //太阳能 能源类型（锂电、液体、胶体、AMG）

  //锂电
  final Rx<double> liVP = 0.0.obs; //太阳能 过充保护
  final Rx<double> liVR = 0.0.obs; //太阳能 过充恢复
  final Rx<int> liS = 0.obs; //太阳能 零度充电 （正常、禁冲、慢充）index
  final List<String> liSList = ["正常", "禁冲", "慢充"]; //太阳能 零度充电 （正常、禁冲、慢充）
  //液体、胶体、AMG
  final Rx<double> equalV = 14.8.obs; //太阳能 均衡充电压
  final Rx<double> strongV = 14.5.obs; //太阳能 强充电压
  final Rx<double> floatV = 13.7.obs; //太阳能 浮充电压
  //公共
  final Rx<int> ratedL = 0.obs; //太阳能 电压等级
  final Rx<double> lowVR = 12.0.obs; //太阳能 低压恢复
  final Rx<double> lowVP = 11.2.obs; //太阳能 低压保护

  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  final Rx<String> localVoice = ''.obs;

  @override
  Future<void> onInit() async {
    Future.delayed(const Duration(seconds: 1), () async {
      //getDeviceInfo();
      getDeviceConfig();
      getVoiceUse();
      getVersion();
      await _configureRecorderAudioSession();
      await _ensureRecorderOpened();
    });
    super.onInit();
  }

  @override
  void onClose() {
    try {
      _recorder.closeRecorder();
    } catch (e) {
      //
    }
    _iosRecordingSubscription?.cancel();
    _iosRecordingDataController?.close();
    super.onClose();
  }

  Future<void> getDeviceInfo() async {
    Map<String, dynamic> map = {};
    map['id'] = id;
    var result = await HhHttp()
        .request(RequestUtils.deviceInfo, method: DioMethod.get, params: map);
    HhLog.d("getDeviceInfo -- $id");
    HhLog.d("getDeviceInfo -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      name.value = "${result["data"]["spaceName"]}-${result["data"]["name"]}";
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> getVoiceUse() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    var result = await HhHttp()
        .request(RequestUtils.deviceVoiceTop, method: DioMethod.get);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("getVoiceUse -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      voiceTopList = result["data"]["list"];
      voiceTopStatus.value = false;
      voiceTopStatus.value = true;
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> getVersion() async {
    var result = await HhHttp()
        .request(RequestUtils.deviceVersion, method: DioMethod.get);
    HhLog.d("getVersion -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      versionList = result["data"]["list"];
      if (versionList.isNotEmpty) {
        versionStr.value = versionList[0]['version'];
      }
      versionStatus.value = false;
      versionStatus.value = true;
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> postScreenTop() async {
    final Map<String, dynamic> data = {
      "deviceNo": deviceNo,
      "cmdType": "ledSetParam",
      "speed": speed.value,
      "direction": direction.value == 1 ? "down" : "up",
      "content": showContentController.text
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,
        method: DioMethod.post, data: data);
    HhLog.d("postScreenTop -- $data");
    HhLog.d("postScreenTop -- $result");
    if (result["code"] == 0) {
      EventBusUtil.getInstance().fire(HhToast(title: "设置成功", type: 1));
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> postScreenBottom() async {
    final Map<String, dynamic> data = {
      "deviceNo": deviceNo,
      "cmdType": "ledSetSwitch",
      "switchType": closeTab.value,
      "time": ledTime.value,
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,
        method: DioMethod.post, data: data);
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
    var result = await HhHttp()
        .request(RequestUtils.deviceConfig, method: DioMethod.get, params: map);
    HhLog.d("getDeviceConfig -- $deviceNo");
    HhLog.d("getDeviceConfig -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      config = result["data"];
      _parseTimeRange(config["audioHumanTime"], personStart, personEnd);
      _parseTimeRange(config["audioCarTime"], carStart, carEnd);
      _parseTimeRange(config["audioOpenTime"], openStart, openEnd);
      closeTab.value = config["ledEnable"]??0;
      _parseTimeRange(config["ledTime"], closeStart, closeEnd);
      _parseTimeRange(config["energyOpenTime"], energyStart, energyEnd);
      _parseTimeRange(config["weatherOpenTime"], weatherStart, weatherEnd);
      _parseTimeRange(config["soilOpenTime"], soilStart, soilEnd);
      _parseTimeRange(config["alarmLedTime"], alarmLedStart, alarmLedEnd,
          defaultStart: '07:00:00', defaultEnd: '18:59:59');
      voiceBottomList = result["data"]["audioArray"];
      voiceBottomStatus.value = false;
      voiceBottomStatus.value = true;
      warnGANG1.value = config["gcam1Enable"] == "ON";
      warnGANG2.value = config["gcam2Enable"] == "ON";
      warnGANG3.value = config["gcam3Enable"] == "ON";
      warnBALL.value = config["scam1Enable"] == "ON";
      warnSENSOR.value = config["sensorEnable"] == "ON";
      warnOPEN.value = config["capEnable"] == "ON";
      sensorDelay.value = '${config["sensorTime"] ?? 0}';
      capDelay.value = '${config["capTime"] ?? 0}';
      energyAction.value = config["energyAction"] == "ON";
      weatherAction.value = config["weatherAction"] == "ON";
      soilAction.value = config["soilAction"] == "ON";
      alarmLedEnable.value = config["alarmLedEnable"] ?? 0;
      energyDelay.value =
          CommonUtils().parseMinuteUpload('${config["energyDelay"]}');
      weatherDelay.value =
          CommonUtils().parseMinuteUpload('${config["weatherDelay"]}');
      soilDelay.value =
          CommonUtils().parseMinuteUpload('${config["soilDelay"]}');
      time1Controller!.text = energyDelay.value;
      time2Controller!.text = weatherDelay.value;
      time3Controller!.text = soilDelay.value;
      deviceVer.value = '${config["deviceVer"]}';
      versionStr.value = '${config["deviceVer"]}';
      deviceFireLevel.value = config["deviceFireLevel"];
      fireLevel.value = deviceFireLevel.value;
      direction.value = config["ledDirection"] == "down" ? 1 : 0;
      speed.value = config["ledSpeed"];
      ledContent.value = config["ledContent"];
      showContentController.text = ledContent.value;
      close.value = config["ledEnable"] == 1;
      ledTime.value = config["ledTime"];
      voiceHuman.value = config["audioHumanVolume"];
      voiceCar.value = config["audioCarVolume"];
      voiceCap.value = config["audioOpenVolume"];

      ///太阳能
      energySetType.value = config["energySetType"]; //太阳能 能源类型（锂电、液体、胶体、AMG）
      //锂电
      liVP.value = config["liVP"]; //太阳能 过充保护
      liVR.value = config["liVR"]; //太阳能 过充恢复
      liS.value = config["liS"]; //太阳能 零度充电 （正常、禁冲、慢充）
      //液体、胶体、AMG
      equalV.value = config["equalV"]; //太阳能 均衡充电压
      strongV.value = config["strongV"]; //太阳能 强充电压
      floatV.value = config["floatV"]; //太阳能 浮充电压
      //公共
      ratedL.value = config["ratedL"]; //太阳能 电压等级
      lowVR.value = config["lowVR"]; //太阳能 低压恢复
      lowVP.value = config["lowVP"]; //太阳能 低压保护
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  void _parseTimeRange(
    dynamic range,
    Rx<String> start,
    Rx<String> end, {
    String defaultStart = '00:00:00',
    String defaultEnd = '23:59:59',
  }) {
    final String value = '${range ?? ''}';
    if (value.length >= 17 && value.contains('-')) {
      start.value = value.substring(0, 8);
      end.value = value.substring(9, 17);
    } else {
      start.value = defaultStart;
      end.value = defaultEnd;
    }
  }

  int parseDelayOrZero(String value) {
    try {
      final int parsed = int.parse(value.trim());
      return max(0, parsed);
    } catch (e) {
      return 0;
    }
  }

  void changeAlarmDelay(Rx<String> target, int delta) {
    final int current = parseDelayOrZero(target.value);
    target.value = max(0, current + delta).toString();
  }

  String buildTimeRange(String start, String end) {
    return '$start-$end';
  }

  void updateUploadTime(String value, String start, String end) {
    final String time = buildTimeRange(start, end);
    if (value == "energy") {
      config["energyOpenTime"] = time;
      return;
    }
    if (value == "weather") {
      config["weatherOpenTime"] = time;
      return;
    }
    if (value == "soil") {
      config["soilOpenTime"] = time;
    }
  }

  Future<void> uploadVoice(String name, String url) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    final Map<String, dynamic> data = {
      "deviceNo": deviceNo,
      "switchType": "start",
      "cmdType": "audioSetData",
      "url": url,
      "name": name,
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,
        method: DioMethod.post, data: data);
    HhLog.d("uploadVoice -- $data");
    HhLog.d("uploadVoice -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0) {
      EventBusUtil.getInstance().fire(HhToast(title: "上传成功", type: 1));
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> playVoice(String name) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    final Map<String, dynamic> data = {
      "deviceNo": deviceNo,
      "switchType": "play",
      "cmdType": "audioSetData",
      "name": name
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,
        method: DioMethod.post, data: data);
    HhLog.d("playVoice -- $data");
    HhLog.d("playVoice -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0) {
      EventBusUtil.getInstance().fire(HhToast(title: "播放成功", type: 1));
      playing.value = 1;
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> stopVoiceLocal() async {
    _player.stopPlayer();
  }

  Future<void> playVoiceLocal(String url) async {
    await _player.openPlayer();

    final response = await Dio().get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    if (response.statusCode != 200 || response.data == null) {
      return;
    }

    // 假设你知道采样率、声道数等信息
    const sampleRate = 16000;
    const numChannels = 1;

    final data = Uint8List.fromList(response.data!);

    await _player.startPlayer(
      fromDataBuffer: data,
      codec: Codec.pcm16,
      sampleRate: sampleRate,
      numChannels: numChannels,
      whenFinished: () {
        localVoice.value = "";
      },
    );
  }

  Future<void> stopVoice() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    final Map<String, dynamic> data = {
      "deviceNo": deviceNo,
      "switchType": "stop",
      "cmdType": "audioSetData"
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,
        method: DioMethod.post, data: data);
    HhLog.d("stopVoice -- $data");
    HhLog.d("stopVoice -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0) {
      EventBusUtil.getInstance().fire(HhToast(title: "已停止播放", type: 1));
      playing.value = 0;
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> deleteVoice(String name) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true, title: "正在删除，请稍后…"));
    final Map<String, dynamic> data = {
      "deviceNo": deviceNo,
      "switchType": "delet",
      "cmdType": "audioSetData",
      "name": name
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,
        method: DioMethod.post, data: data);
    HhLog.d("deleteVoice -- $data");
    HhLog.d("deleteVoice -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0) {
      EventBusUtil.getInstance().fire(HhToast(title: "删除成功", type: 1));
      getVoiceUse();
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> deleteWebVoice(dynamic model) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true, title: "正在删除，请稍后…"));
    Map<String, dynamic> map = {};
    map['id'] = model["id"];
    var result = await HhHttp().request(RequestUtils.voiceDelete,
        method: DioMethod.delete, params: map);
    HhLog.d("deleteWebVoice -- $map");
    HhLog.d("deleteWebVoice -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0) {
      EventBusUtil.getInstance().fire(HhToast(title: "删除成功", type: 1));
      getVoiceUse();
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> voiceSubmitHuman() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    final Map<String, dynamic> data = {
      "deviceNo": deviceNo,
      "cmdType": "audioSetParam",
      "switchType": config["audioHumanEnable"],
      "alarmType": "human",
      "name": config["audioHumanName"],
      "volume": voiceHuman.value,
      "time": config["audioHumanTime"]
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,
        method: DioMethod.post, data: data);
    HhLog.d("voiceSubmitHuman -- $data");
    HhLog.d("voiceSubmitHuman -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0) {
      EventBusUtil.getInstance().fire(HhToast(title: "设置成功", type: 1));
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> voiceSubmitCar() async {
    // EventBusUtil.getInstance().fire(HhLoading(show: true));
    final Map<String, dynamic> data = {
      "deviceNo": deviceNo,
      "cmdType": "audioSetParam",
      "switchType": config["audioCarEnable"],
      "alarmType": "car",
      "name": config["audioCarName"],
      "volume": voiceCar.value,
      "time": config["audioCarTime"]
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,
        method: DioMethod.post, data: data);
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
    final Map<String, dynamic> data = {
      "deviceNo": deviceNo,
      "cmdType": "audioSetParam",
      "switchType": config["audioOpenEnable"],
      "alarmType": "open",
      "name": config["audioOpenName"],
      "volume": voiceCap.value,
      "time": config["audioOpenTime"]
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,
        method: DioMethod.post, data: data);
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
    final Map<String, dynamic> data = {
      "deviceNo": deviceNo,
      "cmdType": "deviceSetLevel",
      "value": fireLevel.value
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,
        method: DioMethod.post, data: data);
    HhLog.d("settingLevel -- $data");
    HhLog.d("settingLevel -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0) {
      EventBusUtil.getInstance().fire(HhToast(title: "设置成功", type: 1));
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> resetDevice() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    final Map<String, dynamic> data = {
      "deviceNo": deviceNo,
      "cmdType": "deviceSetReboot"
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,
        method: DioMethod.post, data: data);
    HhLog.d("resetDevice -- $data");
    HhLog.d("resetDevice -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0) {
      EventBusUtil.getInstance().fire(HhToast(title: "重启下发成功", type: 1));
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> versionUpdate() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    final Map<String, dynamic> data = {
      "deviceNo": deviceNo,
      "cmdType": "deviceSetOTA",
      "url": "${versionList[version.value]["url"]}",
      "version": "${versionList[version.value]["version"]}"
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,
        method: DioMethod.post, data: data);
    HhLog.d("versionUpdate -- $data");
    HhLog.d("versionUpdate -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0) {
      EventBusUtil.getInstance().fire(HhToast(title: "下发成功", type: 1));
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> warnSet(String value, String type, {int? delay}) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    final Map<String, dynamic> data = {
      "deviceNo": deviceNo,
      "cmdType": "alarmSetSwitch",
      "value": value,
      "switchType": type
    };
    if (delay != null) {
      data["delay"] = delay;
    }
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,
        method: DioMethod.post, data: data);
    HhLog.d("versionUpdate -- $data");
    HhLog.d("versionUpdate -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0) {
      EventBusUtil.getInstance().fire(HhToast(title: "设置成功", type: 1));
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> submitAlarmDelaySetting(String value) async {
    final bool enabled;
    final int delay;
    if (value == "sensor") {
      enabled = warnSENSOR.value;
      delay = parseDelayOrZero(sensorDelay.value);
      config["sensorTime"] = '$delay';
    } else {
      enabled = warnOPEN.value;
      delay = parseDelayOrZero(capDelay.value);
      config["capTime"] = '$delay';
    }
    await warnSet(value, enabled ? "ON" : "OFF", delay: delay);
  }

  Future<void> warnUploadSet(
      String value, String type, int delay, String time) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    final Map<String, dynamic> data = {
      "deviceNo": deviceNo,
      "cmdType": "dataSetSwitch",
      "value": value,
      "switchType": type,
      "delay": delay,
      "time": time,
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,
        method: DioMethod.post, data: data);
    HhLog.d("versionUpdate -- $data");
    HhLog.d("versionUpdate -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0) {
      EventBusUtil.getInstance().fire(HhToast(title: "设置成功", type: 1));
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> submitUploadSetting(String value) async {
    int delay = 0;
    String type = "OFF";
    String time = "";
    if (value == "energy") {
      delay = parseDelayOrZero(time1Controller!.text) * 60;
      type = energyAction.value ? "ON" : "OFF";
      time = buildTimeRange(energyStart.value, energyEnd.value);
      energyDelay.value = time1Controller!.text;
      config["energyDelay"] = delay;
    } else if (value == "weather") {
      delay = parseDelayOrZero(time2Controller!.text) * 60;
      type = weatherAction.value ? "ON" : "OFF";
      time = buildTimeRange(weatherStart.value, weatherEnd.value);
      weatherDelay.value = time2Controller!.text;
      config["weatherDelay"] = delay;
    } else {
      delay = parseDelayOrZero(time3Controller!.text) * 60;
      type = soilAction.value ? "ON" : "OFF";
      time = buildTimeRange(soilStart.value, soilEnd.value);
      soilDelay.value = time3Controller!.text;
      config["soilDelay"] = delay;
    }
    updateUploadTime(value, time.substring(0, 8), time.substring(9, 17));
    await warnUploadSet(value, type, delay, time);
  }

  Future<void> alarmLedSetting() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    final Map<String, dynamic> data = {
      "deviceNo": deviceNo,
      "cmdType": "alarmledSetSwitch",
      "switchType": alarmLedEnable.value,
      "time": buildTimeRange(alarmLedStart.value, alarmLedEnd.value),
    };
    final dynamic result = await HhHttp().request(
      RequestUtils.deviceConfigScreenTop,
      method: DioMethod.post,
      data: data,
    );
    HhLog.d("alarmLedSetting -- $data");
    HhLog.d("alarmLedSetting -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0) {
      config["alarmLedEnable"] = alarmLedEnable.value;
      config["alarmLedTime"] =
          buildTimeRange(alarmLedStart.value, alarmLedEnd.value);
      EventBusUtil.getInstance().fire(HhToast(title: "设置成功", type: 1));
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> sunSetting() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    final Map<String, dynamic> data = {
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
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,
        method: DioMethod.post, data: data);
    HhLog.d("sunSetting -- $data");
    HhLog.d("sunSetting -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0) {
      EventBusUtil.getInstance().fire(HhToast(title: "设置成功", type: 1));
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> startRecord() async {
    if (videoTag.value || _recordStarting) {
      return;
    }
    _recordStarting = true;
    recordDateTime = DateTime(2025);
    recordTimes.value = "00:00:00";

    final bool started = await recording();
    _recordStarting = false;
    if (!started) {
      visualizerKey.currentState?.stop();
      videoTag.value = false;
      return;
    }

    visualizerKey.currentState?.start();
    videoTag.value = true;
    EventBusUtil.getInstance().fire(HhToast(title: "开始录音", type: 0));
    runRecordTimer();
  }

  Future<void> stopRecord() async {
    if (!videoTag.value && !isRecording) return;

    visualizerKey.currentState?.stop();
    videoTag.value = false;

    // 必须等录音真正停止
    await recordingComplete();

    // 给部分机型一点落盘时间，红米尤其需要
    await Future.delayed(const Duration(milliseconds: 800));

    final String path = ((await _prepareUploadPcmPath()) ?? "").trim();
    if (path.isEmpty) {
      EventBusUtil.getInstance().fire(HhToast(title: "录音文件路径为空"));
      return;
    }

    final file = File(path);
    final bool fileReady = await _waitForFileReady(file);
    if (!fileReady) {
      EventBusUtil.getInstance().fire(HhToast(title: "录音文件不存在"));
      return;
    }

    final int length = await file.length();
    if (length <= 0) {
      EventBusUtil.getInstance().fire(HhToast(title: "录音文件为空，请重试"));
      return;
    }

    controller.text = "";
    CommonUtils().showCommonInputDialog(
      Get.context,
      "录音",
      controller,
      () {
        Get.back();
      },
      () async {
        final String name = controller.text.trim().isEmpty
            ? "录音_${DateTime.now().millisecondsSinceEpoch}.pcm"
            : "${controller.text.trim()}.pcm";

        Get.back();
        uploadFile(path, name);
      },
    );
  }

  late TextEditingController controller = TextEditingController();
  late DateTime recordDateTime = DateTime(2025);
  final Rx<bool> videoTag = false.obs;
  void runRecordTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      recordDateTime = recordDateTime.add(const Duration(seconds: 1));
      recordTimes.value =
          "${CommonUtils().parseZero(recordDateTime.hour)}:${CommonUtils().parseZero(recordDateTime.minute)}:${CommonUtils().parseZero(recordDateTime.second)}";
      if (recordDateTime.minute >= 3) {
        Get.back();
        return;
      }
      if (videoTag.value) {
        runRecordTimer();
      }
    });
  }

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool isRecording = false;
  bool _recordStarting = false;
  bool _recorderOpened = false;
  DateTime? _recordStartedAt;
  String? _recordFilePath;
  String? _pcmPath;
  Codec _recordCodec = Codec.pcm16;
  StreamController<Food>? _iosRecordingDataController;
  StreamSubscription<Food>? _iosRecordingSubscription;
  BytesBuilder? _iosRecordingBytesBuilder;
  Future<bool> recording() async {
    PermissionStatus status = await Permission.microphone.status;

    // 未授权时再请求一次
    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }

    if (status.isGranted) {
      try {
        await _configureRecorderAudioSession();
        await _ensureRecorderOpened();
        _recordCodec = _getRecordCodec();
        _recordStartedAt = DateTime.now();
        _pcmPath = null;
        _recordFilePath = null;

        if (Platform.isIOS) {
          _iosRecordingDataController?.close();
          await _iosRecordingSubscription?.cancel();
          _iosRecordingBytesBuilder = BytesBuilder(copy: false);
          _iosRecordingDataController = StreamController<Food>();
          _iosRecordingSubscription =
              _iosRecordingDataController!.stream.listen(
            (food) {
              if (food is FoodData && food.data != null) {
                _iosRecordingBytesBuilder?.add(food.data!);
              }
            },
          );
          await _recorder.startRecorder(
            toStream: _iosRecordingDataController!.sink,
            codec: Codec.pcm16,
            sampleRate: 16000,
            numChannels: 1,
            bitRate: 16000 * 16,
          );
        } else {
          _recordFilePath = await _getRecordFilePath();
          final file = File(_recordFilePath!);
          if (!await file.parent.exists()) {
            await file.parent.create(recursive: true);
          }

          await _recorder.startRecorder(
            toFile: _recordFilePath,
            codec: _recordCodec,
            sampleRate: 16000,
            numChannels: 1,
            bitRate: 16000 * 16,
          );
        }
        isRecording = true;
        return true;
      } catch (e) {
        isRecording = false;
        _recordStartedAt = null;
        _recordFilePath = null;
        _pcmPath = null;
        _iosRecordingBytesBuilder = null;
        HhLog.e("startRecorder error: $e");
        EventBusUtil.getInstance().fire(
          HhToast(title: "录音启动失败，请检查麦克风权限或是否被其他应用占用"),
        );
        return false;
      }
    }

    videoTag.value = false;

    if (status.isPermanentlyDenied || status.isDenied || status.isRestricted) {
      EventBusUtil.getInstance().fire(HhToast(title: "请在系统设置中开启麦克风权限"));
      HhLog.e("microphone permission status: $status");
      Get.back();
      CommonUtils().showCommonDialog(
        Get.context,
        "麦克风权限已被关闭，请前往系统设置开启后再使用录音功能",
        () {
          Get.back();
        },
        () async {
          Get.back();
          await openAppSettings();
        },
        leftStr: "取消",
        rightStr: "去设置",
      );
      return false;
    }

    EventBusUtil.getInstance().fire(HhToast(title: "麦克风权限未授权"));
    HhLog.e("microphone permission status: $status");
    return false;
  }

  Future<void> recordingComplete() async {
    if (!isRecording) {
      return;
    }
    try {
      final String? stopPath = await _recorder.stopRecorder();
      if (stopPath != null &&
          stopPath.trim().isNotEmpty &&
          stopPath != 'Recorder is not open') {
        _recordFilePath = stopPath.trim();
      }
    } catch (e) {
      HhLog.e("stopRecorder error: $e");
    } finally {
      isRecording = false;
      await _iosRecordingSubscription?.cancel();
      _iosRecordingSubscription = null;
      await _iosRecordingDataController?.close();
      _iosRecordingDataController = null;
    }
  }

  Future<String?> _prepareUploadPcmPath() async {
    if (Platform.isIOS) {
      final bytes = _iosRecordingBytesBuilder?.toBytes();
      if (bytes == null || bytes.isEmpty) {
        return null;
      }
      final dir = await getApplicationCacheDirectory();
      final pcmPath =
          '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.pcm';
      await File(pcmPath).writeAsBytes(bytes, flush: true);
      _pcmPath = pcmPath;
      _iosRecordingBytesBuilder = null;
      return _pcmPath;
    }

    _recordFilePath = await _resolveRecordFilePath();
    if (Platform.isAndroid) {
      _pcmPath = _recordFilePath;
      return _pcmPath;
    }

    _pcmPath = _recordFilePath;
    return _pcmPath;
  }

  Future<String?> _resolveRecordFilePath() async {
    final String currentPath = (_recordFilePath ?? "").trim();
    if (currentPath.isNotEmpty) {
      return currentPath;
    }
    return _findLatestRecordFilePath();
  }

  Future<bool> _waitForFileReady(
    File file, {
    Duration timeout = const Duration(seconds: 4),
    Duration interval = const Duration(milliseconds: 250),
  }) async {
    final DateTime deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      if (await file.exists()) {
        return true;
      }
      await Future.delayed(interval);
    }
    return await file.exists();
  }

  Future<String?> _findLatestRecordFilePath() async {
    try {
      final List<Directory> directories = [
        await getTemporaryDirectory(),
        await getApplicationCacheDirectory(),
        await getApplicationSupportDirectory(),
        await getApplicationDocumentsDirectory(),
      ];
      final List<File> files = [];
      for (final dir in directories) {
        if (!await dir.exists()) {
          continue;
        }
        final List<FileSystemEntity> entities = dir.listSync(recursive: true);
        files.addAll(
          entities.whereType<File>().where(_isPossibleRecordFile),
        );
      }
      if (files.isEmpty) {
        return null;
      }
      final DateTime? startedAt = _recordStartedAt;
      final List<File> recentFiles = startedAt == null
          ? files
          : files.where((file) {
              final modified = file.statSync().modified;
              return !modified.isBefore(
                startedAt.subtract(const Duration(seconds: 5)),
              );
            }).toList();
      final List<File> candidateFiles =
          recentFiles.isNotEmpty ? recentFiles : files;
      candidateFiles.sort(
          (a, b) => b.statSync().modified.compareTo(a.statSync().modified));
      return candidateFiles.first.path;
    } catch (e) {
      HhLog.e("findLatestRecordFilePath error: $e");
      return null;
    }
  }

  bool _isPossibleRecordFile(File file) {
    final path = file.path.toLowerCase();
    final bool matchesExtension =
        path.endsWith('.wav') || path.endsWith('.pcm');
    if (!matchesExtension) {
      return false;
    }
    return path.contains('record') ||
        path.contains('sound') ||
        path.contains('audio') ||
        path.contains('taudio');
  }

  Codec _getRecordCodec() {
    return Codec.pcm16;
  }

  Future<String> _getRecordFilePath() async {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final dir = await getApplicationCacheDirectory();
    return '${dir.path}/recording_$timestamp.pcm';
  }

  Future<void> _ensureRecorderOpened() async {
    if (_recorderOpened) {
      return;
    }
    try {
      await _recorder.openRecorder();
      _recorderOpened = true;
    } catch (e) {
      _recorderOpened = false;
      HhLog.e("openRecorder error: $e");
      rethrow;
    }
  }

  Future<void> _configureRecorderAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(
      AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.allowBluetooth |
                AVAudioSessionCategoryOptions.defaultToSpeaker,
        avAudioSessionMode: AVAudioSessionMode.spokenAudio,
        avAudioSessionRouteSharingPolicy:
            AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: const AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.voiceCommunication,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ),
    );
    await session.setActive(true);
  }

  void uploadFile(String filePath, String fileName) async {
    final oldFile = File(filePath);

    // 确保文件存在
    if (await oldFile.exists()) {
      // 获取目录路径
      final dir = oldFile.parent.path;
      // 新文件路径
      final newFilePath = '$dir/$fileName';
      final newFile = await oldFile.rename(newFilePath);

      EventBusUtil.getInstance().fire(HhLoading(show: true, title: "文件上传中..."));
      var dio = Dio();
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(newFile.path, filename: fileName),
        "path":
            "/${DateTime.now().millisecondsSinceEpoch.toString()}/$fileName",
      });

      try {
        var response = await dio.post(
          RequestUtils.fileUpload,
          data: formData,
          options: Options(
            headers: {
              "Authorization": "Bearer ${CommonData.token}",
              "Tenant-Id": "${CommonData.tenant}",
            },
          ),
        );
        EventBusUtil.getInstance().fire(HhLoading(show: false));
        if (response.data.toString().contains("401")) {
          CommonUtils().tokenDown();
        }
        HhLog.d("上传成功: ${response.data}");
        String url = response.data["data"];
        postAudioUrl(url, fileName);
      } catch (e) {
        HhLog.d("上传失败: $e");
      }
    } else {
      //print('文件不存在: $filePath');
    }
  }

  Future<void> postAudioUrl(String url, String fileName) async {
    final Map<String, dynamic> data = {};
    data['name'] = fileName;
    data['pcmUrl'] = url;
    data['description'] = "App上传";
    var result = await HhHttp()
        .request(RequestUtils.audioCreate, method: DioMethod.post, data: data);
    HhLog.d("postAudioUrl -- $data");
    HhLog.d("postAudioUrl -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      getVoiceUse();
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
}
