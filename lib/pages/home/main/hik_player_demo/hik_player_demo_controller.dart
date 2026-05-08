import 'dart:convert';

import 'package:get/get.dart';
import 'package:qc_hik_player/qc_hik_player.dart';

class HikPlayerDemoController extends GetxController {
  final Rxn<QcHikPlayerParams> playParams = Rxn<QcHikPlayerParams>();
  final RxInt playerSeed = 0.obs;

  void mockFetchAndPlay() {
    final Map<String, dynamic> response =
        jsonDecode(_mockBusinessApiResponse()) as Map<String, dynamic>;
    playParams.value = QcHikPlayerParams.fromBusinessResponse(response);
    playerSeed.value++;
  }

  String _mockBusinessApiResponse() {
    return "{"
        "\"code\":0,"
        "\"data\":{"
        "\"appAccessToken\":\"at-4PeAVOlqzoASbRCO2P980Nh7TEzw0hYwEXKx9v3H\","
        "\"userAccessToken\":\"ut-a7cbccf8-23d3-426a-bf71-cf450c74569c\","
        "\"ezvizData\":{\"code\":0,\"data\":{"
        "\"tokenAppKey\":\"3068808d4fcd42239e77afd4a874171d\","
        "\"tokenExpire\":1778290186,"
        "\"httpUrlToken\":\"tk.AwRTSTAyAAADLyoqAAP0gGn6mYosRUxyeGVhcVpIdGJsY3RQK1l3aGZPeWQwd2x3aXF3QkI5TkgxOWN5S1Vkbz0eEDBogI1PzUIjnnev1Kh0Fx0kAAAAAAAAAAAA\""
        "}},"
        "\"resourceDetail\":{\"code\":0,\"data\":{"
        "\"deviceSerial\":\"GK8599874\","
        "\"gwDeviceSerial\":\"GK8599874\","
        "\"channelNum\":1,"
        "\"resIdentifier\":1,"
        "\"videoLevel\":1,"
        "\"isEncrypt\":0,"
        "\"status\":1"
        "}},"
        "\"deviceTokens\":{\"code\":0,\"data\":[{"
        "\"streamTalkToken\":\"tk.AgMxLjABMQAAA-SAAAP0gGn7-XIAAgAAAAAAAAAAACxwNGd3R0cxbS9sWXRLK1NxUzh3YWxobytzMVNETWhyK2VXNVFCdzQwV0lFPTBogI1PzUIjnnev1Kh0Fx0A\","
        "\"streamTalk0Token\":\"tk.AgMxLjABMAAAA-SAAAP0gGn7-XIAAgAAAAAAAAAAACxwNGd3R0cxbS9sWXRLK1NxUzh3YWxobytzMVNETWhyK2VXNVFCdzQwV0lFPTBogI1PzUIjnnev1Kh0Fx0A\","
        "\"deviceSerial\":\"GK8599874\","
        "\"streamTokenPlayExpire\":1778123298,"
        "\"deviceVideoToken\":\"tk.BARERTAxCUdLODU5OTg3NAExBXZpZGVvASoAAAP0gGn7-XIAAAAAAAAAACxFODRMdDNVODQ3TEV4akF5Mmdzd3Z0SE1FSkdWdDlIVXJFeXp0YkFySEU0PR4QMGiAjU-NQiOed6-UqHQXHQMvKiokAAA_\","
        "\"channelNo\":1,"
        "\"deviceGlobalToken\":\"tk.BARERTAxCUdLODU5OTg3NAExBmdsb2JhbAEqAAAD9IBp*-1yAAAAAAAAAAAsdVRBakJNQkhJSkZPeUVJbE8xd0dmQzNiRERCQ0graGR2ZDl0dVlRQTBQbz0eEDBogI1PzUIjnnev1Kh0DLyoqJAAA\","
        "\"streamLiveToken\":\"tk.AgMxLjABMQAAAASwAAAEsGn7-XIAAAAAAAAAAAAAACxxSmpMTWJDbEZlZjFPdVVYcmxXREpuUUFhZTgvZWQxYk8rK2JHaW1oanZvPTBogI1PzUIjnnev1Kh0Fx0A\","
        "\"tokenExpire\":1778381298,"
        "\"streamTokenExpire\":1778123298,"
        "\"streamRecToken\":\"tk.AgMxLjABMQAAA-SAAAP0gGn7-XIAAQAAAAAAAAAAACx4S1NZbFVDRkF6dGhZbVpzRy8vd1gzeWNOY3JlS1F3K2x5NWFnVkxwYTZrPTBogI1PzUIjnnev1Kh0Fx0A\","
        "\"deviceToken\":\"tk.BARERTAxCUdLODU5OTg3NAEqBmdsb2JhbAEqAAAD9IBp*-1yAAAAAAAAAAAsK29sM3d5UFp3Mlo3elgySWdoMS8vY0RzeE1DdFpOTzZ6S29mTWlGYk5sWT0eEDBogI1PzUIjnnev1Kh0Fx0DLyoqJAAA\""
        "}]},"
        "\"deviceSerial\":\"GK8599874\","
        "\"channelNo\":1,"
        "\"appKey\":\"2042449721540562998\""
        "},"
        "\"msg\":\"\""
        "}";
  }
}
