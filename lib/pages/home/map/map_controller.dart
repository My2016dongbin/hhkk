import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/home/cell/HhTap.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:iot/utils/ParseLocation.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qc_amap_navi/qc_amap_navi.dart';

class MapController extends GetxController {
  final index = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final Rx<bool> searchMode = false.obs;

  ///0全部 1智慧立杆 2火险因子
  final Rx<int> tabIndex = 0.obs;
  final Rx<String> deviceCount = "-1".obs;
  late BuildContext context;
  late AMapController gdMapController;
  final RxSet<Marker> aMapMarkers = <Marker>{}.obs;
  late int pageNum = 1;
  late int pageSize = 20;
  late int totalPage = 0;
  bool deviceLoadMoreLoading = false;
  Future<void>? deviceLoadMoreFuture;
  Future<void>? deviceFetchPageFuture;
  String deviceFetchPageKey = "";
  final PagingController<int, dynamic> deviceController =
      PagingController(firstPageKey: 1);
  final ScrollController deviceScrollController = ScrollController();
  final RefreshController deviceRefreshController =
      RefreshController(initialRefresh: false);
  late TextEditingController? searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final RxList<dynamic> searchResultList = <dynamic>[].obs;
  final Rx<bool> showSearchResult = false.obs;
  final Rx<bool> searchLoading = false.obs;
  Timer? _searchDebounce;
  StreamSubscription? mapSearchSubscription;
  StreamSubscription? deviceListSubscription;

  @override
  Future<void> onInit() async {
    searchFocusNode.addListener(() {
      if (searchFocusNode.hasFocus) {
        String keyword = searchController?.text.trim() ?? "";
        if (keyword.isNotEmpty) {
          if (searchResultList.isNotEmpty) {
            showSearchResult.value = true;
          } else {
            autoSearchDevice();
          }
        }
      }
    });
    mapSearchSubscription =
        EventBusUtil.getInstance().on<MapSearch>().listen((event) {
      searchController!.text = event.name;
      searchMode.value = true;
      autoSearchDevice();
    });
    deviceListSubscription =
        EventBusUtil.getInstance().on<DeviceList>().listen((event) {
      pageNum = 1;
      fetchPage();
    });
    super.onInit();
    //加载设备列表
    fetchPage();
  }

  @override
  Future<void> onClose() async {
    mapSearchSubscription?.cancel();
    deviceListSubscription?.cancel();
    _searchDebounce?.cancel();
    deviceRefreshController.dispose();
    searchFocusNode.dispose();
    searchController?.dispose();
    super.onClose();
  }

  /// 创建完成回调
  void onGDMapCreated(AMapController controller) {
    gdMapController = controller;

    if (CommonData.latitude != null && CommonData.latitude != 0) {
      gdMapController.moveCamera(CameraUpdate.newLatLngZoom(
          LatLng(CommonData.latitude!, CommonData.longitude!), 14));
    }
  }

  void updateMarker({bool location = false}) {
    aMapMarkers.clear();

    ///用户位置打点
    if (CommonData.latitude != null && CommonData.latitude != 0) {
      LatLng myLoc = LatLng(CommonData.latitude!, CommonData.longitude!);
      Marker mk = Marker(
          anchor: const Offset(0.5, 1.0),
          infoWindowEnable: false,
          position: myLoc,
          icon: BitmapDescriptor.fromIconPath(
              'assets/images/common/icon_point.png'),
          onTap: (v) {
            gdMapController.moveCamera(CameraUpdate.newLatLngZoom(myLoc, 16));
          });
      aMapMarkers.add(mk);
    }

    ///设备打点
    List<dynamic> newItems = deviceController.itemList ?? [];
    for (int i = 0; i < newItems.length; i++) {
      try {
        dynamic model = newItems[i];
        LatLng latLng = LatLng(double.parse("${model["latitude"]}"),
            double.parse("${model["longitude"]}"));
        Marker mk = Marker(
            anchor: const Offset(0.5, 1.0),
            infoWindowEnable: false,
            position: latLng,
            icon: BitmapDescriptor.fromIconPath("${model["status"]}" == "1"
                ? CommonUtils().parseOnlineIcon(model)
                : CommonUtils().parseOfflineIcon(model)),
            onTap: (v) {
              gdMapController
                  .moveCamera(CameraUpdate.newLatLngZoom(latLng, 16));
              deviceDetailDialog(model);
            });
        aMapMarkers.add(mk);
        if (i == 0 && !location) {
          gdMapController.moveCamera(CameraUpdate.newLatLngZoom(latLng, 16));
        }
      } catch (e) {
        HhLog.e("$e");
      }
    }

    ///用户位置点击
    if (location) {
      if (CommonData.latitude != null && CommonData.latitude != 0) {
        LatLng myLoc = LatLng(CommonData.latitude!, CommonData.longitude!);
        gdMapController.moveCamera(CameraUpdate.newLatLngZoom(myLoc, 16));
      } else {
        EventBusUtil.getInstance().fire(HhToast(title: "定位获取中…", type: 0));
      }
    }
  }

  Future<void> fetchPage() {
    final int requestPage = pageNum;
    final int requestTabIndex = tabIndex.value;
    final bool requestSearchMode = searchMode.value;
    final String requestKeyword = searchController?.text ?? "";
    final String requestKey =
        "$requestPage-$requestTabIndex-$requestSearchMode-$requestKeyword";
    if (deviceFetchPageFuture != null && deviceFetchPageKey == requestKey) {
      return deviceFetchPageFuture!;
    }
    deviceFetchPageKey = requestKey;
    deviceFetchPageFuture = fetchPageRequest(
      requestPage: requestPage,
      requestTabIndex: requestTabIndex,
      requestSearchMode: requestSearchMode,
      requestKeyword: requestKeyword,
    ).whenComplete(() {
      if (deviceFetchPageKey == requestKey) {
        deviceFetchPageFuture = null;
        deviceFetchPageKey = "";
      }
    });
    return deviceFetchPageFuture!;
  }

  Future<void> fetchPageRequest({
    required int requestPage,
    required int requestTabIndex,
    required bool requestSearchMode,
    required String requestKeyword,
  }) async {
    if (requestPage == 1) {
      deviceRefreshController.resetNoData();
    }
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {
      "pageNo": requestPage,
      "pageSize": pageSize,
      "status": null,
      "activeStatus": 1,
    };
    if (requestTabIndex != 0) {
      map["productKey"] = CommonUtils().parseProductKey(requestTabIndex);
    }
    if (requestSearchMode && requestKeyword.isNotEmpty) {
      map["name"] = requestKeyword;
    }
    dynamic result;
    try {
      result = await HhHttp().request(RequestUtils.mainDeviceList,
          method: DioMethod.get, params: map);
    } catch (e) {
      EventBusUtil.getInstance().fire(HhLoading(show: false));
      if (requestPage == 1) {
        deviceRefreshController.refreshFailed();
      } else {
        deviceRefreshController.loadFailed();
      }
      HhLog.e(e.toString());
      rethrow;
    }
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("fetchPage -- ${RequestUtils.mainDeviceList}");
    HhLog.d("fetchPage -- $map");
    HhLog.d("fetchPage -- total ${result['data']["total"]}");
    HhLog.d("fetchPage -- $result");
    deviceCount.value = "${result['data']["total"] ?? -1}";

    totalPage =
        CommonUtils().parseTotalPage("${result["data"]["total"]}", pageSize);
    HhLog.d("fetchPage -- totalPage $totalPage");

    if (result["data"] != null && result["data"]["list"] != null) {
      List<dynamic> newItems = result["data"]["list"];
      if (requestPage == 1) {
        deviceController.itemList = [];
      }
      if (requestPage > totalPage) {
        deviceController.appendLastPage([]);
        deviceRefreshController.loadNoData();
      } else {
        deviceController.appendLastPage(newItems);
        if (requestPage >= totalPage) {
          deviceRefreshController.loadNoData();
        } else if (requestPage > 1) {
          deviceRefreshController.loadComplete();
        }
      }
      if (requestPage == 1) {
        deviceRefreshController.refreshCompleted();
      }
      updateMarker();
    } else {
      if (requestPage == 1) {
        deviceRefreshController.refreshCompleted();
      } else {
        deviceRefreshController.loadFailed();
      }
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> refreshDevicePage() async {
    pageNum = 1;
    deviceRefreshController.resetNoData();
    await fetchPage();
  }

  Future<void> loadMoreDevicePage() async {
    if (deviceLoadMoreLoading) {
      return deviceLoadMoreFuture ?? Future.value();
    }
    if (totalPage > 0 && pageNum >= totalPage) {
      deviceRefreshController.loadNoData();
      return;
    }
    deviceLoadMoreLoading = true;
    pageNum++;
    try {
      deviceLoadMoreFuture = fetchPage();
      await deviceLoadMoreFuture;
    } catch (e) {
      pageNum--;
    } finally {
      deviceLoadMoreLoading = false;
      deviceLoadMoreFuture = null;
    }
  }

  void onSearchChanged(String value) {
    _searchDebounce?.cancel();
    String keyword = value.trim();
    if (keyword.isEmpty) {
      hideSearchResult();
      return;
    }
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      autoSearchDevice();
    });
  }

  Future<void> autoSearchDevice() async {
    String keyword = searchController?.text.trim() ?? "";
    if (keyword.isEmpty) {
      hideSearchResult();
      pageNum = 1;
      fetchPage();
      return;
    }
    searchLoading.value = true;
    Map<String, dynamic> map = {
      "pageNum": 1,
      "pageSize": 20,
      "status": null,
      "activeStatus": 1,
      "name": keyword,
    };
    if (tabIndex.value != 0) {
      map["productKey"] = tabIndex.value == 1
          ? CommonData.productKeyFireSmartPole
          : CommonData.productKeyFireRiskFactor;
    }
    var result = await HhHttp().request(RequestUtils.mainDeviceList,
        method: DioMethod.get, params: map);
    searchLoading.value = false;
    HhLog.d("autoSearchDevice -- $map");
    HhLog.d("autoSearchDevice -- $result");
    if ((searchController?.text.trim() ?? "") != keyword) {
      return;
    }
    if (result["code"] == 0 && result["data"] != null) {
      List<dynamic> newItems = [];
      try {
        newItems = result["data"]["list"] ?? [];
      } catch (e) {
        HhLog.e(e.toString());
      }
      deviceCount.value = "${result['data']["total"] ?? -1}";
      totalPage =
          CommonUtils().parseTotalPage("${result["data"]["total"]}", pageSize);
      pageNum = 1;
      deviceController.itemList = [];
      deviceController.appendLastPage(newItems);
      updateMarker();
      searchResultList.value = newItems;
      showSearchResult.value = true;
    } else {
      deviceCount.value = "-1";
      pageNum = 1;
      deviceController.itemList = [];
      deviceController.appendLastPage([]);
      updateMarker();
      searchResultList.value = [];
      showSearchResult.value = true;
    }
  }

  void hideSearchResult({bool clearText = false}) {
    _searchDebounce?.cancel();
    showSearchResult.value = false;
    searchLoading.value = false;
    searchResultList.value = [];
    if (clearText) {
      searchController?.clear();
    }
  }

  Future<void> onTapSearchItem(dynamic item) async {
    //await CommonUtils().parseRouteDetail(item);
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    hideSearchResult();
    try {
      LatLng latLng = LatLng(double.parse("${item["latitude"]}"),
          double.parse("${item["longitude"]}"));
      gdMapController
          .moveCamera(CameraUpdate.newLatLngZoom(latLng, 16));
      Get.back();
      deviceDetailDialog(item);
    } catch (e) {
      EventBusUtil.getInstance().fire(HhToast(title: "定位不可用"));
    }
  }

  Future<void> onTapSearchNavi(dynamic item) async {
    try {
      List<double> end = ParseLocation.parseTypeToGcj02(
        double.parse("${item['latitude']}"),
        double.parse("${item['longitude']}"),
        "${item["coordinateType"]}"
      );
      EventBusUtil.getInstance().fire(HhLoading(show: true));
      await QcAmapNavi.startNavigation(
        fromLat: double.parse("${CommonData.latitude}"),
        fromLng: double.parse("${CommonData.longitude}"),
        fromName: "我的位置",
        toLat: double.parse("${end[0]}"),
        toLng: double.parse("${end[1]}"),
        toName: "${item['name']}",
      );
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    } catch (e) {
      HhLog.e(e.toString());
      EventBusUtil.getInstance().fire(HhLoading(show: false));
      EventBusUtil.getInstance().fire(HhToast(title: "该定位不可用"));
    }
  }

  ///设备详情弹窗
  void deviceDetailDialog(dynamic device) {
    showModalBottomSheet(
        context: Get.context!,
        builder: (a) {
          return Container(
            width: 1.sw,
            height: 350.w * 3,
            padding: EdgeInsets.fromLTRB(15.w * 3, 0, 15.w * 3, 0),
            decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(6.w * 3))),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 6.w * 3,
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      HhTap(
                        onTapUp: () {
                          Get.back();
                        },
                        child: Container(
                            color: HhColors.trans,
                            padding: EdgeInsets.fromLTRB(
                                15.w * 3, 8.w * 3, 5.w * 3, 5.w * 3),
                            child: Image.asset(
                              'assets/images/common/icon_up_x.png',
                              width: 12.w * 3,
                              height: 12.w * 3,
                              fit: BoxFit.fill,
                            )),
                      ),
                    ],
                  ),

                  ///设备名称
                  Text(CommonUtils().parseNull("${device["name"]}", ""),
                      style: TextStyle(
                          fontSize: 15.sp * 3,
                          fontWeight: FontWeight.w600,
                          color: HhColors.textBlackColor)),
                  CommonUtils.line(
                      margin: EdgeInsets.only(top: 15.w * 3, bottom: 15.w * 3)),

                  ///设备类型
                  Row(
                    children: [
                      Text("设备类型",
                          style: TextStyle(
                              fontSize: 15.sp * 3,
                              fontWeight: FontWeight.w500,
                              color: HhColors.textBlackColor)),
                      SizedBox(
                        width: 10.w * 3,
                      ),
                      Expanded(
                          child: Text(
                        CommonUtils().parseNull("${device["productName"]}", ""),
                        style: TextStyle(
                            fontSize: 15.sp * 3,
                            fontWeight: FontWeight.w400,
                            color: HhColors.gray9TextColor),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                      )),
                      SizedBox(
                        width: 2.w * 3,
                      )
                    ],
                  ),
                  CommonUtils.line(
                      margin: EdgeInsets.only(top: 15.w * 3, bottom: 15.w * 3)),

                  ///经纬度
                  Row(
                    children: [
                      Text("经纬度",
                          style: TextStyle(
                              fontSize: 15.sp * 3,
                              fontWeight: FontWeight.w500,
                              color: HhColors.textBlackColor)),
                      SizedBox(
                        width: 10.w * 3,
                      ),
                      Expanded(
                          child: Text(
                        "(${CommonUtils().parseDoubleNumber("${device["longitude"] ?? ""}", 6)},${CommonUtils().parseDoubleNumber("${device["latitude"] ?? ""}", 6)})",
                        style: TextStyle(
                            fontSize: 15.sp * 3,
                            fontWeight: FontWeight.w400,
                            color: HhColors.gray9TextColor),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                      )),
                      SizedBox(
                        width: 2.w * 3,
                      )
                    ],
                  ),
                  CommonUtils.line(
                      margin: EdgeInsets.only(top: 15.w * 3, bottom: 10.w * 3)),

                  ///位置
                  Text("位置",
                      style: TextStyle(
                          fontSize: 15.sp * 3,
                          fontWeight: FontWeight.w500,
                          color: HhColors.textBlackColor)),
                  SizedBox(
                    height: 5.w * 3,
                  ),
                  Text(
                    CommonUtils().parseNull("${device["location"]}", ""),
                    style: TextStyle(
                        fontSize: 15.sp * 3,
                        fontWeight: FontWeight.w400,
                        color: HhColors.gray9TextColor),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  CommonUtils.line(
                      margin: EdgeInsets.only(top: 15.w * 3, bottom: 12.w * 3)),

                  ///按钮
                  Row(
                    children: [
                      Expanded(
                          child: BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 0.2,
                              onPressed: () {
                                CommonUtils().parseRouteDetail(device);
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: HhColors.whiteColor,
                                      borderRadius:
                                          BorderRadius.circular(8.w * 3),
                                      border: Border.all(
                                          color: HhColors.grayLineColor,
                                          width: 1.w * 3)),
                                  padding: EdgeInsets.all(12.w * 3),
                                  child: Text(
                                    "视频",
                                    style: TextStyle(
                                        fontSize: 15.sp * 3,
                                        fontWeight: FontWeight.w500,
                                        color: HhColors.textBlackColor),
                                    textAlign: TextAlign.center,
                                  )))),
                      SizedBox(
                        width: 15.w * 3,
                      ),
                      Expanded(
                          child: BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 0.2,
                              onPressed: () async {
                                try {
                                  List<double> end =
                                      ParseLocation.parseTypeToGcj02(
                                    double.parse("${device['latitude']}"),
                                    double.parse("${device['longitude']}"),
                                        "${device['coordinateType']}"
                                  );
                                  EventBusUtil.getInstance()
                                      .fire(HhLoading(show: true));
                                  await QcAmapNavi.startNavigation(
                                    fromLat:
                                        double.parse("${CommonData.latitude}"),
                                    fromLng:
                                        double.parse("${CommonData.longitude}"),
                                    fromName: "我的位置",
                                    toLat: double.parse("${end[0]}"),
                                    toLng: double.parse("${end[1]}"),
                                    toName: "${device['name']}",
                                  );
                                  EventBusUtil.getInstance()
                                      .fire(HhLoading(show: false));
                                } catch (e) {
                                  HhLog.e(e.toString());
                                  EventBusUtil.getInstance()
                                      .fire(HhToast(title: "该定位不可用"));
                                }
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: HhColors.mainBlueColor,
                                    borderRadius:
                                        BorderRadius.circular(8.w * 3),
                                  ),
                                  padding: EdgeInsets.all(12.w * 3),
                                  child: Text(
                                    "导航",
                                    style: TextStyle(
                                        fontSize: 15.sp * 3,
                                        fontWeight: FontWeight.w500,
                                        color: HhColors.whiteColor),
                                    textAlign: TextAlign.center,
                                  )))),
                    ],
                  )
                ],
              ),
            ),
          );
        },
        isDismissible: true,
        enableDrag: false,
        isScrollControlled: true);
  }
}
