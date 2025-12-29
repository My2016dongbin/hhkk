import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/bus/event_class.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/ParseLocation.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../utils/EventBusUtils.dart';
import '../../common/model/model_class.dart';

class VideoController extends GetxController {
  final index = 0.obs;
  final marginTop = 120.w;
  final unreadMsgCount = 0.obs;
  final title = "主页".obs;
  final Rx<double?> latitude = CommonData.latitude.obs;
  final Rx<double?> longitude = CommonData.longitude.obs;
  BMFMapController? controller;
  StreamSubscription? pushTouchSubscription;
  StreamSubscription? spaceListSubscription;
  StreamSubscription? catchSubscription;
  StreamSubscription? deviceListSubscription;
  StreamSubscription? messageSubscription;
  final Rx<bool> containStatus = true.obs;
  final Rx<bool> searchStatus = false.obs;
  final Rx<bool> videoStatus = false.obs;
  final Rx<bool> pageMapStatus = false.obs;
  final Rx<String> dateStr = ''.obs;
  final Rx<String> cityStr = ''.obs;
  final Rx<String> temp = ''.obs;
  final Rx<String> icon = '305'.obs;
  final Rx<bool> iconStatus = false.obs;
  final Rx<String> locText = '定位中...'.obs;
  final Rx<String> text = '未获取到天气信息，请重试'.obs;
  final Rx<String> count = '0'.obs;
  final Rx<bool> searchDown = true.obs;
  final Rx<bool> spaceListStatus = true.obs;
  late List<dynamic> spaceList = [];
  final Rx<int> spaceListIndex = 0.obs;
  final Rx<int> searchListIndex = 0.obs;
  TextEditingController? searchController = TextEditingController();
  final PagingController<int, dynamic> pagingController =
  PagingController(firstPageKey: 1);
  final PagingController<int, dynamic> deviceController =
  PagingController(firstPageKey: 0);
  late EasyRefreshController easyController = EasyRefreshController();
  late String textId = '';
  late int pageNum = 1;
  late int pageSize = 20;
  late BuildContext context;
  final LocationFlutterPlugin _myLocPlugin = LocationFlutterPlugin();
  late WebViewController webController = WebViewController()
    ..setBackgroundColor(HhColors.trans)..runJavaScript(
        "document.documentElement.style.overflow = 'hidden';"
            "document.body.style.overflow = 'hidden';");
  /*onPageFinished: (String url) {
          _controller.runJavascript(
              "document.documentElement.style.overflow = 'hidden';");
        },*/
  late bool _suc;
  late List<dynamic> newItems = [];
  late Rx<bool> secondStatus = true.obs;
  final TooltipController tipController = TooltipController();
  late Directory tempDir;

  @override
  Future<void> onInit() async {
    tempDir = await getApplicationCacheDirectory();
    DateTime dateTime = DateTime.now();
    dateStr.value = CommonUtils().parseLongTimeWithLength("${dateTime.millisecondsSinceEpoch}",16);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    secondStatus.value = prefs.getBool(SPKeys().second) == true;
    //接受定位回调
    _myLocPlugin.seriesLocationCallback(callback: (BaiduLocation result) {
      HhLog.d('BaiduLocation -> ${result.longitude},${result.latitude}');
      if(result.longitude!=null){
        CommonData.longitude = result.longitude;
      }
      if(result.latitude!=null){
        CommonData.latitude = result.latitude;
      }
      latitude.value = CommonData.latitude;
      longitude.value = CommonData.longitude;

      locSearch();

    });
    //定位
    location();
    pushTouchSubscription =
        EventBusUtil.getInstance().on<Location>().listen((event) {
          if (CommonData.latitude != null && CommonData.latitude! > 0) {
            controller!.updateMapOptions(BMFMapOptions(
                center: BMFCoordinate(CommonData.latitude ?? 36.30865,
                    CommonData.longitude ?? 120.314037),
                zoomLevel: 12,
                mapType: BMFMapType.Standard,
                mapPadding: BMFEdgeInsets(
                    left: 30, top: 0, right: 30, bottom: 0)));
          }
        });
    spaceListSubscription =
        EventBusUtil.getInstance().on<SpaceList>().listen((event) {
          getSpaceList(1,false);
          spaceListIndex.value = 0;
        });
    catchSubscription =
        EventBusUtil.getInstance().on<CatchRefresh>().listen((event) {
          containStatus.value = false;
          containStatus.value = true;
          getSpaceList(1,false);
        });
    deviceListSubscription =
        EventBusUtil.getInstance().on<DeviceList>().listen((event) {
          pageNum = 1;
          getDeviceList(1,false);
        });
    messageSubscription =
        EventBusUtil.getInstance().on<Message>().listen((event) {
          getUnRead();
        });
    // pagingController.addPageRequestListener((pageKey) {
    //   // fetchPage(pageKey);
    //   getSpaceList(pageKey);
    // });
    //天气信息
    getWeather();
    //未读消息数量
    getUnRead();
    //获取分组列表
    getSpaceList(1,true);
    Future.delayed(const Duration(milliseconds: 3000),(){
      EventBusUtil.getInstance().fire(Version());
    });
    super.onInit();
  }

  BaiduLocationAndroidOption initAndroidOptions() {
    BaiduLocationAndroidOption options = BaiduLocationAndroidOption(
      // 定位模式，可选的模式有高精度、仅设备、仅网络。默认为高精度模式
        locationMode: BMFLocationMode.hightAccuracy,
        // 是否需要返回地址信息
        isNeedAddress: true,
        // 是否需要返回海拔高度信息
        isNeedAltitude: true,
        // 是否需要返回周边poi信息
        isNeedLocationPoiList: true,
        // 是否需要返回新版本rgc信息
        isNeedNewVersionRgc: true,
        // 是否需要返回位置描述信息
        isNeedLocationDescribe: true,
        // 是否使用gps
        openGps: true,
        // 可选，设置场景定位参数，包括签到场景、运动场景、出行场景
        locationPurpose: BMFLocationPurpose.sport,
        // 坐标系
        coordType: BMFLocationCoordType.bd09ll,
        // 设置发起定位请求的间隔，int类型，单位ms
        // 如果设置为0，则代表单次定位，即仅定位一次，默认为0
        scanspan: 4000);
    return options;
  }

  BaiduLocationIOSOption initIOSOptions() {
    BaiduLocationIOSOption options = BaiduLocationIOSOption(
      // 坐标系
      coordType: BMFLocationCoordType.bd09ll,
      // 位置获取超时时间
      locationTimeout: 10,
      // 获取地址信息超时时间
      reGeocodeTimeout: 10,
      // 应用位置类型 默认为automotiveNavigation
      activityType: BMFActivityType.automotiveNavigation,
      // 设置预期精度参数 默认为best
      desiredAccuracy: BMFDesiredAccuracy.best,
      // 是否需要最新版本rgc数据
      isNeedNewVersionRgc: true,
      // 指定定位是否会被系统自动暂停
      pausesLocationUpdatesAutomatically: false,
      // 指定是否允许后台定位,
      // 允许的话是可以进行后台定位的，但需要项目
      // 配置允许后台定位，否则会报错，具体参考开发文档
      allowsBackgroundLocationUpdates: false,
      // 设定定位的最小更新距离
      distanceFilter: 10,
    );
    return options;
  }

  late dynamic model;

  void onBMFMapCreated(BMFMapController controller_){
    controller = controller_;
    controller?.setMapClickedMarkerCallback(
        callback: (BMFMarker marker){
      for (int i = 0; i < newItems.length; i++) {
        if(newItems[i]["deviceNo"] == marker.customMap!["deviceNo"]){
          model = newItems[i];
          // dynamic mapLatLng = CommonUtils().gdToBd(double.parse(model['longitude']), double.parse(model['latitude']));
          List<double> mapLatLng = ParseLocation.parseTypeToBd09(double.parse("${model['latitude']}"), double.parse("${model['longitude']}"),model['coordinateType']??"0");
          controller?.setCenterCoordinate(
            BMFCoordinate(mapLatLng[0],mapLatLng[1]), false,
          );
          controller?.setZoomTo(17);

          try{
            controller?.removeOverlay(textId);
          }catch(e){
            //
          }
          //添加标题框
          /// text经纬度信息
          BMFCoordinate position = BMFCoordinate(double.parse("${mapLatLng[0]}"),double.parse("${mapLatLng[1]}"));

          /// 构造text
          BMFText bmfText = BMFText(
              text: '${model["name"]}',
              position: position,
              bgColor: HhColors.whiteColor,
              fontColor: HhColors.blackColor,
              fontSize: 30,
              typeFace: BMFTypeFace( familyName: BMFFamilyName.sMonospace,
                  textStype: BMFTextStyle.BOLD_ITALIC),
              alignY: BMFVerticalAlign.ALIGN_TOP,
              alignX: BMFHorizontalAlign.ALIGN_CENTER_HORIZONTAL,
              alignment: BMFTextAlignment.center,
              rotate: 0);
          textId = bmfText.id;

          /// 添加text
          controller?.addText(bmfText);

          searchDown.value = false;

          videoStatus.value = false;
          videoStatus.value = true;
        }
      }

      userMarker();
    });

    controller?.setMapOnClickedMapPoiCallback(callback: (a){
      videoStatus.value = false;
    });
    controller?.setMapOnClickedMapBlankCallback(callback: (a){
      videoStatus.value = false;
    });

    //获取设备检索列表
    deviceSearch();
  }

  void userMarker() {
    /// 创建BMFMarker
    BMFMarker point = BMFMarker(
        position: BMFCoordinate(CommonData.latitude!,CommonData.longitude!),
        enabled: false,
        visible: true,
        identifier: "location",
        icon: 'assets/images/common/icon_point.png');

    /// 添加Marker
    controller?.addMarker(point);
  }

  void onSearchClick() {
    searchStatus.value = true;
    videoStatus.value = false;
  }

  void restartSearchClick() {
    searchStatus.value = false;
  }

  void fetchPage(int pageKey) {
    List<dynamic> newItems = [
      MainGridModel(
          "青岛林场",
          "https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AAOEhRG.img",
          "",
          10,
          false),
      MainGridModel(
          "城阳林场",
          "https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AAOEhRG.img",
          "",
          6,
          true),
      MainGridModel(
          "高新林场",
          "https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AAOEhRG.img",
          "",
          8,
          true),
      MainGridModel(
          "崂山林场",
          "https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AAOEhRG.img",
          "",
          2,
          false),
    ];
    final isLastPage = newItems.length < pageSize;
    if (isLastPage) {
      pagingController.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + newItems.length;
      pagingController.appendPage(newItems, nextPageKey);
    }
  }

  Future<void> getWeather() async {
    Map<String, dynamic> map = {};
    map["location"] = '${CommonData.longitude},${CommonData.latitude}';
    if (CommonData.latitude != null) {
      var result = await HhHttp().request(
        RequestUtils.weatherLocation,
        method: DioMethod.get,
        params: map,
      );
      HhLog.d("getWeather -- $result");
      if (result["code"] == 0 && result["data"] != null) {
        var now = result["data"]['now'];
        if (now != null) {
          temp.value = '${now['temp']}';
          icon.value = '${now['icon']}';
          text.value = '${now['text']}';
          HhLog.d("weatherUrl now['icon'] = ${now['icon']}");
          String weatherUrl = CommonUtils().getHeFengIcon(
              (now['text'] == "晴" ? "FFF68F" : "F5CD5B"), now['icon'], "80");
          HhLog.d("weatherUrl = $weatherUrl");
          webController.setJavaScriptMode(JavaScriptMode.unrestricted);
          webController.loadRequest(Uri.parse(weatherUrl));
          webController.enableZoom(true);
          webController.runJavaScript(
              "document.documentElement.style.overflow = 'hidden';"
              "document.body.style.overflow = 'hidden';");
          webController.setBackgroundColor(HhColors.trans);
          iconStatus.value = false;
          iconStatus.value = true;
        }
      } else {
        EventBusUtil.getInstance()
            .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
      }
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        getWeather();
      });
    }
  }

  Future<void> location() async {
    Map iosMap = initIOSOptions().getMap();
    Map androidMap = initAndroidOptions().getMap();

    _suc = await _myLocPlugin.prepareLoc(androidMap, iosMap);

    _suc = await _myLocPlugin.startLocation();
  }

  Future<void> getUnRead() async {
    var result = await HhHttp().request(
      RequestUtils.unReadCount,
      method: DioMethod.get,
    );
    HhLog.d("getUnRead -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      count.value = '${result["data"]}';
    } else {
      // EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> getSpaceList(int pageKey,bool loading) async {
    Map<String, dynamic> map = {};
    map['pageNo'] = '$pageKey';
    map['pageSize'] = '$pageSize';
    var result = await HhHttp().request(RequestUtils.mainSpaceList,
        method: DioMethod.get, params: map);
    HhLog.d("getSpaceList -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      spaceList = result["data"]["list"]??[];
      spaceListStatus.value = false;
      spaceListStatus.value = true;

      getDeviceList(1,loading);
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> getDeviceList(int pageKey,bool loading) async {
    if(loading){
      EventBusUtil.getInstance().fire(HhLoading(show: true));
    }
    Map<String, dynamic> map = {};
    if(spaceList.isNotEmpty){
      map['spaceId'] = spaceList[spaceListIndex.value]['id'];
    }
    map['pageNo'] = '$pageKey';
    map['pageSize'] = '$pageSize';
    map['appSign'] = 1;
    // map['activeStatus'] = '-1';
    var result = await HhHttp().request(RequestUtils.deviceList,method: DioMethod.get,params: map);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("deviceList --- $pageKey , $result");
    if(result["code"]==0 && result["data"]!=null){
      List<dynamic> newItems = [];
      try{
        newItems = result["data"]["list"]??[];
      }catch(e){
        HhLog.e(e.toString());
      }

      if (pageKey == 1) {
        pagingController.itemList = [];
      }else{
        if(newItems.isEmpty){
          easyController.finishLoad(IndicatorResult.noMore,true);
        }
      }
      pagingController.appendLastPage(newItems);
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> deviceSearch() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true, title: '设备加载中..'));
    Map<String, dynamic> map = {};
    map['name'] = searchController!.text;
    map['pageNo'] = '1';
    map['pageSize'] = '100';
    map['appSign'] = 1;
    // map['activeStatus'] = '-1';
    try{
      int spaceId = spaceList[spaceListIndex.value]['id'];
      map['spaceId'] = spaceId;
    }catch(e){
      //
    }
    var result = await HhHttp()
        .request(RequestUtils.deviceList, method: DioMethod.get, params: map);
    HhLog.d("deviceSearch map -- $spaceList");
    HhLog.d("deviceSearch map -- ${spaceListIndex.value}");
    HhLog.d("deviceSearch map -- ${spaceList[spaceListIndex.value]['id']}");
    HhLog.d("deviceSearch map -- $map");
    HhLog.d("deviceSearch result -- $result");
    Future.delayed(const Duration(seconds: 1), () {
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    });
    if (result["code"] == 0 && result["data"] != null) {
      newItems = [];
      try {
        newItems = result["data"]["list"];
      } catch (e) {
        HhLog.e(e.toString());
      }

      if (pageNum == 1) {
        deviceController.itemList = [];
      }
      deviceController.appendLastPage(newItems);
      searchDown.value = true;

      ///地图打点
      refreshMarkers();
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  void refreshMarkers() {
    if (newItems.isEmpty) {
      return;
    }

    ///地图打点
    controller?.cleanAllMarkers();
    for (int i = 0; i < newItems.length; i++) {
      try {
        dynamic model = newItems[i];
        if (model['latitude'] == null ||
            model['longitude'] == null ||
            model['latitude'] == '' ||
            model['longitude'] == '') {
          continue;
        }
        HhLog.d('BMFMarker ${model['longitude']} , ${model['latitude']}');

        /// 创建BMFMarker

        Map<String, dynamic> map = {};
        map["deviceNo"] = "${model['deviceNo']}";

        // dynamic mapLatLng = CommonUtils().gdToBd(double.parse(model['longitude']), double.parse(model['latitude']));
        List<double> mapLatLng = ParseLocation.parseTypeToBd09(double.parse("${model['latitude']}"), double.parse("${model['longitude']}"),model['coordinateType']??"0");
        BMFMarker marker = BMFMarker(
            position: BMFCoordinate(mapLatLng[0], mapLatLng[1]),
            enabled: true,
            visible: true,
            title: "${model['name']}",
            customMap: map,
            identifier: "location",
            icon: '${model['status']}' == '1'
                ? 'assets/images/common/ic_device_online2.png'
                : 'assets/images/common/ic_device_offline2.png');

        /// 添加Marker
        controller?.addMarker(marker);
      } catch (e) {
        HhLog.e("search ${e.toString()}");
        continue;
      }
    }
    userMarker();
  }

  Future<void> locSearch() async {
    // 构造检索参数
    BMFReverseGeoCodeSearchOption reverseGeoCodeSearchOption =
    BMFReverseGeoCodeSearchOption(
        location: BMFCoordinate(latitude.value!, longitude.value!));
    // 检索实例
    BMFReverseGeoCodeSearch reverseGeoCodeSearch = BMFReverseGeoCodeSearch();
    // 逆地理编码回调
    reverseGeoCodeSearch.onGetReverseGeoCodeSearchResult(callback:
        (BMFReverseGeoCodeSearchResult result,
        BMFSearchErrorCode errorCode) {
      HhLog.d("逆地理编码  errorCode = $errorCode, result = ${result.toMap()}");
      List<BMFPoiInfo> ?poiList = result.poiList;
      if(poiList!=null && poiList.isNotEmpty){
        locText.value = CommonUtils().parseNull("${poiList[0].name}", "定位中..");
      }else{
        locText.value = CommonUtils().parseNull("${result.address}", "定位中..");
      }
      try{
        cityStr.value = result.addressDetail!.city!.replaceAll("市", '');
      }catch(e){
        //error
      }
    });
    /// 发起检索
    bool flag = await reverseGeoCodeSearch.reverseGeoCodeSearch(reverseGeoCodeSearchOption);
  }

  Future<void> deleteDevice(item) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {};
    map['id'] = '${item['id']}';
    map['shareMark'] = '${item['shareMark']}';
    var result = await HhHttp().request(RequestUtils.deviceDelete,method: DioMethod.delete,params: map);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("deleteDevice -- $map");
    HhLog.d("deleteDevice -- $result");
    if(result["code"]==0 && result["data"]!=null){
      EventBusUtil.getInstance().fire(HhToast(title: '操作成功',type: 0));
      pageNum = 1;
      getDeviceList(1,false);
      EventBusUtil.getInstance().fire(SpaceList());
      EventBusUtil.getInstance().fire(DeviceList());
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  parseCacheImageView(String deviceNo,dynamic item) {
    try{
      // 将图片保存到缓存目录
      final filePath =
          '${tempDir.path}/catch_$deviceNo.png';
      final file = File(filePath);

      FileImage fileImage = FileImage(file);
      // 同步清除指定文件的缓存
      fileImage.evict();
      if(fileImage.file.lengthSync() < 2600){
        //处理白屏问题
        return Image.asset(
          CommonUtils().parseDeviceBackImage(item),
          // "assets/images/common/test_video.jpg",
          fit: BoxFit.fill,
        );
      }
      return Image(image: fileImage,errorBuilder: (c,d,e){
        HhLog.d("parseCacheImageView error $deviceNo");
        return Image.asset(
          CommonUtils().parseDeviceBackImage(item),
          // "assets/images/common/test_video.jpg",
          fit: BoxFit.fill,
        );
      }, fit: BoxFit.fill,);
    }catch(e){
      //
      return Image.asset(
        CommonUtils().parseDeviceBackImage(item),
        // "assets/images/common/test_video.jpg",
        fit: BoxFit.fill,
      );
    }
  }
}
