import 'dart:io';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/bus/event_class.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';


class VideoController extends GetxController {
  final index = 0.obs;
  final marginTop = 120.w;
  final unreadMsgCount = 0.obs;
  final title = "主页".obs;
  final Rx<double?> latitude = CommonData.latitude.obs;
  final Rx<double?> longitude = CommonData.longitude.obs;
  StreamSubscription? pushTouchSubscription;
  StreamSubscription? spaceListSubscription;
  StreamSubscription? catchSubscription;
  StreamSubscription? deviceListSubscription;
  final Rx<bool> containStatus = true.obs;
  final Rx<bool> videoStatus = true.obs;
  ///true列表模式（视频树）  false卡片模式（设备卡片列表）
  final Rx<bool> pageListStatus = false.obs;
  final Rx<String> dateStr = ''.obs;
  final Rx<String> cityStr = '青岛'.obs;
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
  TextEditingController? searchTreeController = TextEditingController();
  final PagingController<int, dynamic> pagingController =
  PagingController(firstPageKey: 1);
  final PagingController<int, dynamic> deviceController =
  PagingController(firstPageKey: 0);
  late EasyRefreshController easyController = EasyRefreshController();
  late String textId = '';
  late int pageNum = 1;
  late int pageSize = 20;
  late WebViewController webController = WebViewController()
    ..setBackgroundColor(HhColors.trans)..runJavaScript(
        "document.documentElement.style.overflow = 'hidden';"
            "document.body.style.overflow = 'hidden';");
  late Rx<bool> secondStatus = true.obs;
  late Directory tempDir;
  ///1屏 4屏 8屏
  final Rx<int> videoCount = 1.obs;
  final Rx<int> videoIndex = 0.obs;
  final Rx<int> treeIndex = 0.obs;
  final RxList<dynamic> treeDetail = [].obs;

  @override
  Future<void> onInit() async {
    tempDir = await getApplicationCacheDirectory();
    DateTime dateTime = DateTime.now();
    dateStr.value = CommonUtils().parseLongTimeWithLength("${dateTime.millisecondsSinceEpoch}",16);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    secondStatus.value = prefs.getBool(SPKeys().second) == true;
    pushTouchSubscription =
        EventBusUtil.getInstance().on<Location>().listen((event) {
          if (CommonData.latitude != null && CommonData.latitude! > 0) {

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
    //天气信息
    getWeather();
    //获取分组列表
    getSpaceList(1,true);
    //获取设备树
    getTreeDetail();
    Future.delayed(const Duration(milliseconds: 3000),(){
      EventBusUtil.getInstance().fire(Version());
    });
    super.onInit();
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
    if(searchController!.text.isNotEmpty){
    map['name'] = searchController!.text;
    }
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

  @override
  onClose() async {
    pushTouchSubscription!.cancel();
    spaceListSubscription!.cancel();
    catchSubscription!.cancel();
    deviceListSubscription!.cancel();
    super.onClose();
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


  Future<void> getTreeDetail() async {
    Map<String, dynamic> map = {
      "collectFlag":treeIndex.value,//0查询全部 1只查询收藏的
      "displayChannel":1,//是否展示通道 0否1是
    };
    if(searchTreeController!.text.isNotEmpty){
      map['keyWord'] = searchTreeController!.text;
    }
    var result = await HhHttp().request(
        RequestUtils.treeDetail,
        method: DioMethod.get,
        params: map
    );
    HhLog.d("treeDetail -- $map");
    HhLog.d("treeDetail -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      treeDetail.value = [];
      treeDetail.value = result["data"];
      EventBusUtil.getInstance().fire(TreeChannelRefresh());
    } else {
      EventBusUtil.getInstance().fire(HhToast(title: /*CommonUtils().msgString(result["msg"])*/"视频树加载失败"));
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    }
  }

  Future<void> collection(String userId,String channelId) async {
    dynamic data = {
      "userId":userId,
      "channelId":channelId,
    };
    var result = await HhHttp().request(
        RequestUtils.collect,
        method: DioMethod.post,
        data: data
    );
    HhLog.d("collection -- $data");
    HhLog.d("collection -- $result");
    if (result["code"] == 0) {
      EventBusUtil.getInstance().fire(HhToast(title: "收藏成功",type: 0));
      getTreeDetail();
    } else {
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().parseNull(result["msg"], "")));
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    }
  }

  Future<void> disCollection(String userId,String channelId) async {
    dynamic data = {
      "userId":userId,
      "channelId":channelId,
    };
    var result = await HhHttp().request(
        RequestUtils.disCollect,
        method: DioMethod.post,
        data: data
    );
    HhLog.d("disCollection -- $data");
    HhLog.d("disCollection -- $result");
    if (result["code"] == 0) {
      EventBusUtil.getInstance().fire(HhToast(title: "已取消收藏",type: 0));
      getTreeDetail();
    } else {
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().parseNull(result["msg"], "")));
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    }
  }

  Future<void> getStream(dynamic channel) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      'channelId': "${channel["id"]}",
    };
    var result = await HhHttp().request(
        RequestUtils.devicePlayUrl,
        method: DioMethod.post,
        data: data
    );
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("getStream -- ${RequestUtils.devicePlayUrl}$data");
    HhLog.d("getStream -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      String url = "${result["data"]["appRelativePath"]}";
      HhLog.d("getStream -- $url");

      ///自适应播放数据到网格中
      if(CommonData.checkedChannels[videoIndex.value]["id"]!=null && videoIndex.value < videoCount.value-1 && CommonData.checkedChannels[videoIndex.value+1]["id"]==null){
        //当前选中的网格已有播放数据且不是最后一个网格-加载到下一网格
        videoIndex.value = videoIndex.value+1;
        CommonData.checkedChannels[videoIndex.value] = channel;
        CommonData.checkedChannels[videoIndex.value]["url"] = url;
      }else{
        //当前选中的网格无播放数据-加载到当前网格
        CommonData.checkedChannels[videoIndex.value] = channel;
        CommonData.checkedChannels[videoIndex.value]["url"] = url;
      }
      videoStatus.value = false;
      videoStatus.value = true;
      //视频树-频道状态刷新
      EventBusUtil.getInstance().fire(TreeChannelRefresh());

    } else {
      EventBusUtil.getInstance().fire(HhToast(title: "视频流获取失败",type: 2));
    }
  }
}
