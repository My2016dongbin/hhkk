import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WeatherController extends GetxController {
  final index = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final Rx<int> weatherIndex = 0.obs;
  final RxList<dynamic> weatherList = [].obs;
  final Rx<dynamic> weatherModel = Rx<dynamic>({});
  late WebViewController webController = WebViewController()
    ..setBackgroundColor(HhColors.trans)..runJavaScript(
        "document.documentElement.style.overflow = 'hidden';"
            "document.body.style.overflow = 'hidden';");

  @override
  void onInit() {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Future.delayed(const Duration(milliseconds: 2000), () {
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      getLocation();
      getNowWeatherByLocation();
      get7daysWeatherByLocation();
    });
    super.onInit();
  }

  Future<void> getLocation() async {
    weatherModel.value["time"] = CommonUtils().parseLongTime("${DateTime.now().millisecondsSinceEpoch}");
    Map<String, dynamic> map = {};
    map['location'] = "${CommonData.longitude},${CommonData.latitude}";
    var result = await HhHttp()
        .request(RequestUtils.getLocation, method: DioMethod.get,params: map);
    HhLog.d("getLocation --  $result");
    if (result["code"] == 0 && result["data"]!=null) {
      weatherModel.value["adm2"] = result["data"]["adm2"];
      weatherModel.value["adm1"] = result["data"]["adm1"];
      weatherModel.value["country"] = result["data"]["country"];
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> getNowWeatherByLocation() async {
    Map<String, dynamic> map = {};
    map['location'] = "${CommonData.longitude},${CommonData.latitude}";
    var result = await HhHttp()
        .request(RequestUtils.getNowWeatherByLocation, method: DioMethod.get,params: map);
    HhLog.d("getNowWeatherByLocation --  $result");
    if (result["code"] == 0 && result["data"]!=null && result["data"]["now"]!=null) {
      dynamic now = result["data"]["now"];
      weatherModel.value["temp"] = now["temp"];
      weatherModel.value["text"] = now["text"];
      weatherModel.value["icon"] = now["icon"];
      weatherModel.value["humidity"] = now["humidity"];
      weatherModel.value["windDir"] = now["windDir"];
      weatherModel.value["windScale"] = now["windScale"];
      weatherModel.value["pressure"] = now["pressure"];
      weatherModel.value["precip"] = now["precip"];

      String weatherUrl = CommonUtils().getHeFengIcon(
          (now['text'].contains("晴") ? "FFB615" : "368EFF"), now['icon'], "260");
      webController.setJavaScriptMode(JavaScriptMode.unrestricted);
      webController.loadRequest(Uri.parse(weatherUrl));
      webController.enableZoom(true);
      webController.runJavaScript(
          "document.documentElement.style.overflow = 'hidden';"
              "document.body.style.overflow = 'hidden';");
      webController.setBackgroundColor(HhColors.trans);
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> get7daysWeatherByLocation() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {};
    map['location'] = "${CommonData.longitude},${CommonData.latitude}";
    var result = await HhHttp()
        .request(RequestUtils.get7daysWeatherByLocation, method: DioMethod.get,params: map);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("get7daysWeatherByLocation --  $result");
    if (result["code"] == 0 && result["data"]!=null && result["data"]["daily"]!=null) {
      weatherList.value = result["data"]["daily"];
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> getHistoricalWeatherByLocation() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {};
    map['location'] = "${CommonData.longitude},${CommonData.latitude}";
    map['day'] = 7;
    var result = await HhHttp()
        .request(RequestUtils.getHistoricalWeatherByLocation, method: DioMethod.get,params: map);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("getHistoricalWeatherByLocation --  $result");
    if (result["code"] == 0 && result["data"]!=null) {
      weatherList.value = result["data"];
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
}
