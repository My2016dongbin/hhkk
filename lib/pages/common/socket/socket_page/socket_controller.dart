import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/socket/WebSocketManager.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocketController extends GetxController {
  late BuildContext context;
  final Rx<bool> testStatus = true.obs;
  late String deviceNo = '24070888';
  late WebSocketManager manager;
  final audioRecord = AudioRecorder();
  late Stream<Uint8List> stream;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late Directory? recordDir;
  late String nickname = '';

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> chatStatus() async {
    Map<String, dynamic> map = {};
    map['deviceNo'] = deviceNo;
    var tenantResult = await HhHttp()
        .request(RequestUtils.chatStatus, method: DioMethod.get, params: map);
    HhLog.d("chatStatus socket -- $tenantResult");
    if (tenantResult["code"] == 0 && tenantResult["data"] != null) {
      nickname = tenantResult["data"];
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(tenantResult["msg"])));
    }
  }

  Future<void> chatCreate() async {
    var tenantResult = await HhHttp()
        .request(RequestUtils.chatCreate, method: DioMethod.post, data: {
      "deviceNo": deviceNo,
      "state": '1',
      "sessionId": CommonData.sessionId,
    });
    HhLog.d("chatCreate socket -- $tenantResult");
    if (tenantResult["code"] == 0 && tenantResult["data"] != null) {
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(tenantResult["msg"])));
    }
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
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(tenantResult["msg"])));
    }
  }

  Future<void> connect() async {
    HhLog.d("socket nickname $nickname");
    /*final channel =
        IOWebSocketChannel.connect('ws://172.16.50.85:6002/$nickname');

    channel.stream.listen((event) {
      HhLog.e("socket listen $nickname -- ${event.toString()}");
    });
    channel.sink.add({"CallType": "Active", "Dest": "000001"});*/

    manager =
        WebSocketManager('ws://172.16.50.85:6002/$nickname', '');
    manager.sendMessage({"CallType": "Active", "Dest": deviceNo});
  }

  void chatClose() {
    chatClosePost();
    dynamic o = {"CallType": "Close", "SessionId": CommonData.sessionId};
    // manager.sendMessage(jsonEncode(o));
    manager.sendMessage(o);
    manager.disconnect();
    manager = WebSocketManager('', '');
  }

  Future<void> startRecording() async {
    try {
      recordDir = await getExternalStorageDirectory();
      if (await audioRecord.hasPermission()) {
        final file = File("${recordDir!.path}/iosRecord.pcm");
        HhLog.d("recording downloadsDir!.path ${recordDir!.path}/iosRecord.pcm");
        // await audioRecord.start(const RecordConfig(/*encoder: AudioEncoder.pcm16bits, echoCancel: true, noiseSuppress: true*/), path: "${recordDir!.path}/iosRecord.pcm");
        stream = await audioRecord.startStream(const RecordConfig(/*encoder: AudioEncoder.pcm16bits, echoCancel: true, noiseSuppress: true*/));
        stream.listen((data) {
          // audioDataBuffer.addAll(data.toList());
          file.writeAsBytesSync(data, mode: FileMode.append);
        }, onDone: () => {
          // sendFileToBackend()
          onRecordDone()
        },
            onError: (e) => HhLog.e(e.toString())
        );
      }
    } catch (e) {
      HhLog.e(e.toString());
    }
  }

  Future<void> stopRecording() async {
    try {
      await audioRecord.stop();
      // onRecordDone();
    } catch (e) {
      HhLog.e(e.toString());

    }
  }

  onRecordDone() async {
    HhLog.d('recording onDone() ');
    await _audioPlayer.setUrl(
        "${recordDir!.path}/iosRecord.pcm");
    await _audioPlayer.play();
    manager.sendMessage(File("${recordDir!.path}/iosRecord.pcm"));
  }
}
