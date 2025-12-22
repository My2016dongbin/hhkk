import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/home/device/detail/call/call_binding.dart';
import 'package:iot/pages/home/device/detail/call/call_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MqttController extends GetxController {
  final Rx<bool> test = true.obs;
  late BuildContext context;
  late MqttServerClient client;
  late String id;
  late String clientId;

  @override
  void onClose() {
    try {
      ///通过 disconnect 方法安全断开连接
      // client.disconnect();
    } catch (e) {
      //
    }
  }

  @override
  Future<void> onInit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString(SPKeys().id)!;
    initMqtt();
    super.onInit();
  }

  Future<void> initMqtt() async {
    clientId = getRandomId();
    ///创建并配置 MQTT 客户端
    client = MqttServerClient('222.173.83.190', 'flutter_mqtt-client-$clientId');
    client.port = 10060;
    client.logging(on: true); // 开启日志输出
    client.keepAlivePeriod = 20; // 设置保活时间
    client.onDisconnected = onDisconnected; // 断开连接回调
    client.onConnected = onConnected; // 连接成功回调
    client.onSubscribed = onSubscribed; // 订阅成功回调

    // 配置自动重连
    client.autoReconnect = true;
    client.setProtocolV311(); // 使用 MQTT 3.1.1 协议


    ///通过 MqttConnectMessage 设置连接参数
    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientId) // 客户端 ID
        .authenticateAs('admin', 'QIyG0!bhfS') // 设置用户名和密码
        .withWillTopic('/device/pole/chat/$id') // 遗嘱消息主题
        .withWillMessage('Disconnected') // 遗嘱消息内容
        .startClean() // 清理会话
        .withWillQos(MqttQos.atLeastOnce); // 遗嘱消息的 QoS 等级

    client.connectionMessage = connMessage;


    ///调用 connect 方法发起连接
    try {
      HhLog.d('mqtt_page Connecting...   $clientId');
      await client.connect();
    } on Exception catch (e) {
      HhLog.d('mqtt_page Connection failed: $e   $clientId');
      client.disconnect();
    }


    ///连接成功后，订阅主题
    client.subscribe('/device/pole/chat/$id', MqttQos.atLeastOnce);


    ///监听消息更新，通过 updates 或 published 流处理收到的消息
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      try{
        final recMessage = messages[0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);
        HhLog.d('mqtt_page Received message: $payload from topic: ${messages[0].topic}   $clientId');
        dynamic model = jsonDecode(payload);
        //被呼叫
        if(model['cmd'] == 'deviceReqChart'){
          /// chatReceive(model['deviceNo'],model['reqChatCode']);
          Get.to(()=>CallPage('${model['deviceNo']}','id',0),binding: CallBinding());
        }
        //准备接听
        if(model['cmd'] == "deviceReqSession"){
          /// Get.to(()=>CallPage('${model['deviceNo']}','id',0),binding: CallBinding());
        }
      }catch(e){
        HhLog.e("mqtt_listen_error ${e.toString()}");
      }
    });


    /*///通过 publishMessage 方法发送消息
    final builder = MqttClientPayloadBuilder();
    builder.addString('Hello MQTT!');
    client.publishMessage('/device/pole/chat/$id', MqttQos.atLeastOnce, builder.payload!);*/

  }


  void onConnected() {
    HhLog.d('mqtt_page Connected successfully $clientId');
  }

  void onDisconnected() {
    HhLog.d('mqtt_page Disconnected $clientId');
  }

  void onSubscribed(String topic) {
    HhLog.d('mqtt_page Subscribed to topic: $topic   $clientId');
  }

  getRandomId() {
    Random random = Random();
    String id = "${random.nextInt(999999)}";
    return id;
  }


  Future<void> chatReceive(String deviceNo,String reqChatCode) async {
    dynamic data = {};
    data['deviceNo'] = deviceNo;
    data['reqChatCode'] = reqChatCode;
    var tenantResult = await HhHttp()
        .request(RequestUtils.chatStatus, method: DioMethod.get, data: data);
    HhLog.d("chatReceive socket -- $tenantResult   $clientId");
    if (tenantResult["code"] == 0 && tenantResult["data"] != null) {

    } else {
      //EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(tenantResult["msg"])));
    }
  }

}
