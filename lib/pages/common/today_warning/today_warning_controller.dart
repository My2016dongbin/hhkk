import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TodayWarningController extends GetxController {
  final index = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final Rx<int> deviceType = 0.obs;
  final Rx<int> deviceStatus = 0.obs;
  late BuildContext context;
  late TextEditingController? searchController = TextEditingController();
  late int pageNum = 1;
  late int pageSize = 20;
  late int totalPage = 0;
  final PagingController<int, dynamic> listController = PagingController(firstPageKey: 1);
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  List<dynamic> dataList = [];
  List<dynamic> typeList = [
    {
      "title":"全部",
      "code":null,
    },
    {
      "title":"一体机",
      "code":"highPointMonitor",
    },
    {
      "title":"卡口",
      "code":"kaKou",
    },
    /*{
      "title":"火险因子监测站",
      "code":"highPointMonitor",
    },*/
    {
      "title":"无人机",
      "code":"drone",
    },
  ];
  List<dynamic> statusList = [
    {
      "title":"全部",
      "code":null,
    },
    {
      "title":"在线",
      "code":"1",
    },
    {
      "title":"离线",
      "code":"0",
    },
  ];

  @override
  Future<void> onInit() async {
    pageNum = 1;
    refreshController.resetNoData();
    fetchPage();
    super.onInit();
  }

  Future<void> fetchPage() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {
      "pageNum":pageNum,
      "pageSize":pageSize,
    };
    if(deviceType.value!=0){
      map["deviceType"] = "${typeList[deviceType.value]["code"]}";
    }
    if(deviceStatus.value!=0){
      map["deviceStatus"] = "${statusList[deviceStatus.value]["code"]}";
    }
    if(searchController!.text.isNotEmpty){
      map["deviceName"] = searchController!.text;
    }
    var result = await HhHttp().request(RequestUtils.liveWarningList,method: DioMethod.get,params: map);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("fetchPage -- $map");
    HhLog.d("fetchPage -- $result");
    totalPage = CommonUtils().parseTotalPage("${result["total"]}", pageSize);
    if(result["data"]!=null && result["data"]["list"]!=null){
      List<dynamic> newItems = result["data"]["list"];
      if (pageNum == 1) {
        listController.itemList = [];
      } else if(newItems.isEmpty){
        refreshController.loadNoData();
      }
      listController.appendLastPage(newItems);
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }

  }

}
