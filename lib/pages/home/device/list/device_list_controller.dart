import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/widgets/pop_menu.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DeviceListController extends GetxController {
  final index = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final Rx<int> deviceType = 0.obs;
  final Rx<int> deviceStatus = 0.obs;
  final Rx<String> title = "设备列表".obs;
  late String productKey;
  late BuildContext context;
  late TextEditingController? searchController = TextEditingController();
  late int pageNum = 1;
  late int pageSize = 100;
  late int totalPage = 0;
  final PagingController<int, dynamic> listController = PagingController(firstPageKey: 1);
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  StreamSubscription ?deviceListSubscription;

  @override
  Future<void> onInit() async {
    dynamic arguments = Get.arguments;
    if(arguments!=null){
      title.value = arguments["title"];
      productKey = arguments["productKey"]??"";
    }
    pageNum = 1;
    refreshController.resetNoData();
    fetchPage();
    deviceListSubscription = EventBusUtil.getInstance()
        .on<DeviceList>()
        .listen((event) {
      pageNum = 1;
      refreshController.resetNoData();
      fetchPage();
    });
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    HhActionMenu.dismiss();
    deviceListSubscription?.cancel();
  }

  Future<void> fetchPage() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {
      "pageNum":pageNum,
      "pageSize":pageSize,
      "status":null,
      "activeStatus":1,
      "productKey":productKey,
    };
    if(searchController!.text.isNotEmpty){
      map["name"] = searchController!.text;
    }
    var result = await HhHttp().request(RequestUtils.mainDeviceList,method: DioMethod.get,params: map);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("fetchPage -- $map");
    HhLog.d("fetchPage -- total ${result["total"]}");
    HhLog.d("fetchPage -- $result");
    if(result["data"]!=null && result["data"]["list"]!=null){
      List<dynamic> newItems = result["data"]["list"];
      if (pageNum == 1) {
        listController.itemList = [];
      }
      listController.appendLastPage(newItems);
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }

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
      EventBusUtil.getInstance().fire(SpaceList());
      EventBusUtil.getInstance().fire(DeviceList());
      pageNum = 1;
      refreshController.resetNoData();
      fetchPage();
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

}
