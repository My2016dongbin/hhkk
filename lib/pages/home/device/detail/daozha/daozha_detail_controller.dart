import 'dart:io';

import 'package:draggable_widget/draggable_widget.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/model/model_class.dart';
import 'package:iot/pages/common/socket/WebSocketManager.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screen_recorder/screen_recorder.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DaoZhaDetailController extends GetxController {
  final index = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final Rx<String> name = ''.obs;
  final Rx<int> tabIndex = 0.obs;
  final Rx<bool> playTag = true.obs;
  final Rx<bool> playLoadingTag = true.obs;
  final Rx<bool> playErrorTag = false.obs;
  final Rx<bool> offlineTag = false.obs;
  final Rx<bool> recordTag = false.obs;
  final Rx<bool> recordTag2 = false.obs;
  final Rx<bool> videoTag = false.obs;
  final Rx<bool> voiceTag = true.obs;
  final Rx<int> liveIndex = 0.obs;
  final Rx<double> scale = 1.0.obs;
  final Rx<double> dx = 0.0.obs;
  final Rx<double> dy = 0.0.obs;
  final Rx<int> videoMinute = 0.obs;
  final Rx<int> videoSecond = 0.obs;
  final Rx<bool> liveStatus = true.obs;
  final Rx<bool> upTap = false.obs;
  final Rx<bool> downTap = false.obs;
  final Rx<bool> leftTap = false.obs;
  final Rx<bool> rightTap = false.obs;
  final Rx<bool> upStatus = false.obs;
  final Rx<bool> downStatus = false.obs;
  final Rx<bool> leftStatus = false.obs;
  final Rx<bool> rightStatus = false.obs;
  final PagingController<int, dynamic> deviceController =
      PagingController(firstPageKey: 0);
  late int pageNum = 1;
  late int pageSize = 10;
  late String ip = "1.1.1.1";
  late int port = 8888;
  late DragController dragController;
  late BuildContext context;
  late String deviceNo;
  late String id;
  late int shareMark;
  late String deviceId;
  late String channelNumber;
  late String commandLast;
  late String command = "";
  late Rx<bool> fixLeft = false.obs;
  late Rx<bool> fixRight = false.obs;
  late int controlTime = 0;
  late String nickname = '';
  late Rx<String> productName = ''.obs;
  late Rx<String> functionItem = ''.obs;
  late Rx<bool> isPlaying = false.obs;
  late Rx<bool> fix = false.obs;
  FijkPlayer player = FijkPlayer();
  late WebSocketManager manager;

  late List<dynamic> liveList = [];
  late AnimationController animationController;
  late Animation<Offset> animation;
  late Alignment animateAlign = Alignment.center;
  final Rx<Alignment> dragAlignment = Rx<Alignment>(Alignment.center);
  late String? endpoint;
  late StreamSubscription? moveSubscription;
  late StreamSubscription? scaleSubscription;
  late StreamSubscription? deviceSubscription;
  late StreamSubscription? recordSubscription;
  late TransformationController transformationController = TransformationController();
  late ScreenshotController screenshotController = ScreenshotController();
  late ScreenRecorderController recordController = ScreenRecorderController(
    pixelRatio: 1,
    skipFramesBetweenCaptures: 0,
  );
  late dynamic item = {};
  late List<dynamic> typeList = [
    {
      "label":"类型",
      "value":null,
    },
  ];

  @override
  void onInit() {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dragController = DragController();
    Future.delayed(const Duration(milliseconds: 500), () {
      getDeviceInfo();
      getDeviceHistory(1);
      getWarnType();
    });
    moveSubscription =
        EventBusUtil.getInstance().on<Move>().listen((event) {
          int time = DateTime.now().millisecondsSinceEpoch;
          if (time - controlTime > 1000 || event.action==1) {
            controlTime = time;
            if(event.code.isNotEmpty){
              command = event.code;
            }
            controlPost(event.action);
          }
    });
    scaleSubscription =
        EventBusUtil.getInstance().on<Scale>().listen((event) {
          HhLog.d("Scale ${event.scale},${event.dx},${event.dy}");
          scale.value = event.scale;
          dx.value = event.dx;
          dy.value = event.dy;
    });
    deviceSubscription =
        EventBusUtil.getInstance().on<DeviceInfo>().listen((event) {
      getDeviceInfo();
      getDeviceHistory(1);
    });
    recordSubscription =
        EventBusUtil.getInstance().on<Record>().listen((event) {
          recordTag2.value = true;
    });

    ///TODO 测试缓存视频流截图
    /*Future.delayed(const Duration(milliseconds: 5000),(){
      saveCatchImage();
    });*/
    super.onInit();
  }

  saveImageToGallery() async {
    HhLog.d("saveImageToGallery ");
    screenshotController.capture().then((value) async {
      HhLog.d("saveImageToGallery ");
      /*// 将图片保存到相册
      final tempDir = await getDownloadsDirectory();
      final filePath =
          '${tempDir!.path}/image_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      File a = await file.writeAsBytes(value!);
      HhLog.d("saveImageToGallery $a");
      EventBusUtil.getInstance().fire(HhToast(title: '拍照已保存至“$filePath”'));*/

      // 保存图片到相册
      final result = await ImageGallerySaver.saveImage(value!, quality: 100);
      if (result != null && result['isSuccess']) {
        EventBusUtil.getInstance().fire(HhToast(title: '拍照已保存至相册'));
      } else {
        EventBusUtil.getInstance().fire(HhToast(title: '保存图片失败'));
      }


    }).catchError((onError) {
      HhLog.d("onError$onError");
      EventBusUtil.getInstance().fire(HhToast(title: '拍照失败请重试'));
    });
  }

  saveCatchImage() async {
    screenshotController.capture().then((value) async {
      // 将图片保存到缓存目录
      final tempDir = await getApplicationCacheDirectory();
      final filePath =
          '${tempDir.path}/catch_$deviceNo.png';
      final file = File(filePath);
      File a = await file.writeAsBytes(value!);
      HhLog.d("saveCatchImage $a");
      EventBusUtil.getInstance().fire(CatchRefresh());
    }).catchError((onError) {
      // EventBusUtil.getInstance().fire(HhToast(title: '拍照失败请重试'));
    });
  }

  void runRecordTimer() {
    Future.delayed(const Duration(seconds: 1),(){
      videoSecond.value++;
      if(videoSecond.value == 60){
        videoSecond.value = 0;
        videoMinute.value++;
      }
      if(videoTag.value){
        runRecordTimer();
      }
    });
  }

  void startRecord() {
    recordController.start();
    videoSecond.value = 0;
    videoMinute.value = 0;
    runRecordTimer();
  }

  Future<void> stopRecord() async {
    recordController.stop();
    List<int>? exportGif = await recordController.exporter.exportGif();

    HhLog.d("stopRecord ");
    /*// 将图片保存到相册
    final tempDir = await getDownloadsDirectory();
    final filePath =
        '${tempDir!.path}/video_${DateTime.now().millisecondsSinceEpoch}.gif';
    final file = File(filePath);
    File a = await file.writeAsBytes(exportGif!);
    HhLog.d("stopRecord $a");
    EventBusUtil.getInstance().fire(HhToast(title: '录像已保存至“$filePath”'));*/

    // 保存图片到相册
    Uint8List audioBytes = Uint8List.fromList(exportGif!);
    // final result = await ImageGallerySaver.saveImage(audioBytes, quality: 100);
    final tempDir = await getDownloadsDirectory();
    final filePath = '${tempDir!.path}/video_${DateTime.now().millisecondsSinceEpoch}.gif';
    final file = File(filePath);
    File a = await file.writeAsBytes(exportGif);
    final result = await ImageGallerySaver.saveFile(filePath);
    if (result != null && result['isSuccess']) {
      EventBusUtil.getInstance().fire(HhToast(title: '录像已保存至相册'));
    } else {
      EventBusUtil.getInstance().fire(HhToast(title: '保存录像失败'));
    }
  }

  void fetchPageDevice(int pageKey) {
    List<Device> newItems = [
      Device("人员入侵报警", "08:59:06", "", "", true, true),
      Device("区域入侵", "19:36:06", "", "", false, true),
      Device("人员入侵报警", "10:59:06", "", "", false, false),
      Device("区域入侵", "12:59:06", "", "", false, false),
    ];
    final isLastPage = newItems.length < pageSize;
    if (isLastPage) {
      deviceController.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + newItems.length;
      deviceController.appendPage(newItems, nextPageKey);
    }
  }

  void openOnce(){
    postDoor(2);
  }
  void openDoor(){
    postDoor(1);
  }
  void closeDoor(){
    postDoor(0);
  }

  Future<void> postDoor(int value) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "cmd": "ioctl",
      "host": ip,
      "port": port,
      "value": value //0 ：关 1：常开 2：先开后关（自动）
    };
    var result = await HhHttp().request(RequestUtils.dzControl,
        method: DioMethod.post, data: data);
    HhLog.d("dzControl -- $data");
    HhLog.d("dzControl -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0) {
      EventBusUtil.getInstance().fire(HhToast(title: "操作成功", type: 1));
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> getDeviceStream() async {
    Map<String, dynamic> map = {};
    map['deviceNo'] = deviceNo;
    var result = await HhHttp()
        .request(RequestUtils.dzLiveUrl, method: DioMethod.get, params: map);
    HhLog.d("getDeviceStream -- $deviceNo");
    HhLog.d("getDeviceStream -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      liveStatus.value = false;
      liveStatus.value = true;
      try {
        String url = result["data"];
        playLoadingTag.value = false;
        // url = "rtsp://172.16.50.44:554/visible";
        playTag.value = false;
        player.release();
        player = FijkPlayer();
        player.setDataSource(url, autoPlay: true);
        player.setOption(FijkOption.playerCategory, "mediacodec-hevc", 1);
        player.setOption(FijkOption.playerCategory, "framedrop", 1);
        player.setOption(FijkOption.playerCategory, "start-on-prepared", 0);
        player.setOption(FijkOption.playerCategory, "opensles", 0);
        player.setOption(FijkOption.playerCategory, "mediacodec", 0);
        player.setOption(FijkOption.playerCategory, "start-on-prepared", 1);
        player.setOption(FijkOption.playerCategory, "packet-buffering", 0);
        player.setOption(
            FijkOption.playerCategory, "mediacodec-auto-rotate", 0);
        player.setOption(FijkOption.playerCategory,
            "mediacodec-handle-resolution-change", 0);
        player.setOption(FijkOption.playerCategory, "min-frames", 2);
        player.setOption(FijkOption.playerCategory, "max_cached_duration", 3);
        player.setOption(FijkOption.playerCategory, "infbuf", 1);
        player.setOption(FijkOption.playerCategory, "reconnect", 5);
        player.setOption(FijkOption.playerCategory, "framedrop", 5);
        player.setOption(FijkOption.formatCategory, "rtsp_transport", 'tcp');
        player.setOption(
            FijkOption.formatCategory, "http-detect-range-support", 0);
        player.setOption(FijkOption.formatCategory, "analyzeduration", 1);
        player.setOption(FijkOption.formatCategory, "rtsp_flags", "prefer_tcp");
        player.setOption(FijkOption.formatCategory, "buffer_size", 1024);
        player.setOption(FijkOption.formatCategory, "max-fps", 0);
        player.setOption(FijkOption.formatCategory, "analyzemaxduration", 50);
        player.setOption(FijkOption.formatCategory, "dns_cache_clear", 1);
        player.setOption(FijkOption.formatCategory, "flush_packets", 1);
        player.setOption(FijkOption.formatCategory, "max-buffer-size", 0);
        player.setOption(FijkOption.formatCategory, "fflags", "nobuffer");
        player.setOption(FijkOption.formatCategory, "probesize", 200);
        player.setOption(
            FijkOption.formatCategory, "http-detect-range-support", 0);
        player.setOption(FijkOption.codecCategory, "skip_loop_filter", 48);
        player.setOption(FijkOption.codecCategory, "skip_frame", 0);
        // 添加播放器状态变化监听
        player.addListener(() {
          if (player.state == FijkState.started) {
            // 播放成功开始
            HhLog.d('Playback started successfully ${player.state}');
            //截图并保存
            Future.delayed(const Duration(milliseconds: 3000),(){
              if(Get.isRegistered<DaoZhaDetailController>()){
                saveCatchImage();
              }
            });
            Future.delayed(const Duration(milliseconds: 10000),(){
              if(Get.isRegistered<DaoZhaDetailController>()){
                saveCatchImage();
              }
            });
          }
          if (player.state == FijkState.stopped) {
            // 播放停止
            HhLog.d('Playback stopped ${player.state}');
          }
          if (player.state == FijkState.error) {
            videoError();
            player.reset();
          }
          if (player.state == FijkState.prepared) {
            final duration = player.value.duration;
            HhLog.d("加载进度 $duration");
            // if (duration > 0) {
            //   final buffered = player.value.buffered;
            //   if (buffered.isNotEmpty) {
            //     final end = buffered.last.end.inMilliseconds.toDouble();
            //     final percent = (end / duration) * 100;
            //   }
            // }
          }
        });
        Future.delayed(const Duration(seconds: 1), () {
          playTag.value = true;
        });

      } catch (e) {
        HhLog.e(e.toString());
        EventBusUtil.getInstance().fire(HhLoading(show: false));
        //视频加载失败
        videoError();
      }
    } else {
      EventBusUtil.getInstance().fire(HhLoading(show: false));
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
      //视频加载失败
      videoError();
    }

    EventBusUtil.getInstance().fire(HhLoading(show: false));
  }

  Future<void> getDeviceInfo() async {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['shareMark'] = shareMark;
    var result = await HhHttp()
        .request(RequestUtils.deviceInfo, method: DioMethod.get, params: map);
    HhLog.d("getDeviceInfo -- $id");
    HhLog.d("getDeviceInfo -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      item = result["data"];
      name.value = CommonUtils().parseNull(result["data"]["name"] ?? '', "");
      productName.value = result["data"]["productName"] ?? '';
      ip = result["data"]["ip"] ?? '';
      port = int.parse("${result["data"]["port"]}");
      functionItem.value = item['functionItem'];

      getDeviceStream();
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> getDeviceHistory(int page) async {
    // EventBusUtil.getInstance().fire(HhLoading(show: true, title: "数据加载中.."));
    Map<String, dynamic> map = {};
    map['pageNo'] = page;
    map['pageSize'] = pageSize;
    var result = await HhHttp().request(RequestUtils.dzHistory,
        method: DioMethod.get, params: map);
    HhLog.d("getDeviceHistory -- $pageNum , $result");
    Future.delayed(const Duration(seconds: 1), () {
      // EventBusUtil.getInstance().fire(HhLoading(show: false));
    });
    if (result["code"] == 0 && result["data"] != null) {
      List<dynamic> newItems = [];
      try {
        newItems = result["data"]["list"];
      } catch (e) {
        HhLog.e(e.toString());
      }

      if (pageNum == 1) {
        deviceController.itemList = [];
      }
      deviceController.appendLastPage(newItems);
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  String parseDate(date) {
    String s = '$date';
    try {
      DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
      s = format.format(DateTime.fromMillisecondsSinceEpoch(date));
    } catch (e) {
      HhLog.e(e.toString());
    }
    return s;
  }

  String parseType(type) {
    for(int i = 0;i < typeList.length;i++){
      dynamic model = typeList[i];
      if(model["value"] == type){
        return model["label"];
      }
    }
    return "人员入侵报警";
  }

  Future<void> chatStatus() async {
    Map<String, dynamic> map = {};
    map['deviceNo'] = deviceNo;
    map['state'] = '1';
    var tenantResult = await HhHttp()
        .request(RequestUtils.chatStatus, method: DioMethod.get, params: map);
    HhLog.d("chatStatus socket -- $tenantResult");
    if (tenantResult["code"] == 0 && tenantResult["data"] != null) {
      nickname = tenantResult["data"];
      connect();
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(tenantResult["msg"])));
      recordTag.value = false;
      recordTag2.value = false;
    }
  }

  Future<void> connect() async {
    HhLog.d("socket nickname $nickname");
    /*final channel =
        IOWebSocketChannel.connect('${CommonData.webSocketUrl}$nickname');

    channel.stream.listen((event) {
      HhLog.e("socket listen $nickname -- ${event.toString()}");
    });
    channel.sink.add({"CallType": "Active", "Dest": "000001"});*/

    manager =
        // WebSocketManager('${CommonData.webSocketUrl}$nickname', '');
        WebSocketManager('${CommonData.webSocketUrl}$nickname', '');
    manager.sendMessage({"CallType": "Active", "Dest": deviceNo});
    CommonData.deviceNo = deviceNo;
  }

  void chatClose() {
    chatClosePost();
    dynamic o = {"CallType": "Close", "SessionId": CommonData.sessionId};
    // manager.sendMessage(jsonEncode(o));
    manager.sendMessage(o);
    manager.disconnect();
    manager = WebSocketManager('', '');
  }

  Future<void> chatClosePost() async {
    var tenantResult = await HhHttp()
        .request(RequestUtils.chatCreate, method: DioMethod.post, data: {
      "deviceNo": deviceNo,
      "state": '0',
      "sessionId": CommonData.sessionId,
    });
    HhLog.d("chatClose socket -- $tenantResult");
    if (tenantResult["code"] == 0 && tenantResult["data"] != null) {
      EventBusUtil.getInstance().fire(HhToast(title: '对讲已结束'));
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(tenantResult["msg"])));
    }
  }

  Future<void> controlPost(int action) async {
    dynamic data = {
      "action": action, //0 开始  1 结束
      "channelNumber": channelNumber,
      "command": command,
      "deviceId": deviceId,
      "speed": 15,
    };
    var tenantResult = await HhHttp()
        .request(RequestUtils.videoControl, method: DioMethod.post, data: data);
    HhLog.d("controlPost data -- $data");
    HhLog.d("controlPost result -- $tenantResult");
    /*if (tenantResult["code"] == 200 && tenantResult["data"] != null) {
      // EventBusUtil.getInstance().fire(HhToast(title: ''));
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(tenantResult["data"][0]["msg"])));
    }*/
  }

  Future<void> deleteDevice(item) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {};
    map['id'] = '${item['id']}';
    map['shareMark'] = '${item['shareMark']}';
    var result = await HhHttp().request(RequestUtils.deviceDelete,
        method: DioMethod.delete, params: map);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("deleteDevice -- $map");
    HhLog.d("deleteDevice -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      EventBusUtil.getInstance().fire(HhToast(title: '操作成功', type: 0));
      Get.back();
      EventBusUtil.getInstance().fire(SpaceList());
      EventBusUtil.getInstance().fire(DeviceList());
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> resetDevice() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {"deviceNo": deviceNo, "cmdType": "deviceSetReboot"};
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


  Future<void> initData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    endpoint = prefs.getString(SPKeys().endpoint);
  }

  Future<void> getWarnType() async {
    Map<String, dynamic> map = {};
    map['pageNo'] = 1;
    map['pageSize'] = -1;
    map['label'] = "";
    map['dictType'] = "alarm_type";
    var result = await HhHttp()
        .request(RequestUtils.alarmType, method: DioMethod.get,params: map);
    HhLog.d("getWarnType --  $result");
    if (result["code"] == 0) {
      dynamic data = result["data"];
      if(data!=null){
        typeList.addAll(data["list"]);
      }
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  void videoError() {
    playErrorTag.value = true;
  }
}
