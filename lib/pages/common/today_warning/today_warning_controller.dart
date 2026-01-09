import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';

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
  late EasyRefreshController easyController = EasyRefreshController();
  List<dynamic> dataList = [];
  late List<dynamic> typeList = [];
  late bool isLoading = false;

  @override
  Future<void> onInit() async {
    pageNum = 1;
    fetchPage();
    getWarnType();
    super.onInit();
  }

  Future<void> fetchPage() async {
    String now = CommonUtils().parseLongTimeYearDay("${DateTime.now().millisecondsSinceEpoch}");
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {
      "pageNum":pageNum,
      "pageSize":pageSize,
      "createTime":"$now 00:00:00,$now 23:59:59",
    };
    if(searchController!.text.isNotEmpty){
      map["deviceName"] = searchController!.text;
    }
    var result = await HhHttp().request(RequestUtils.liveWarningList,method: DioMethod.get,params: map);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("fetchPage -- $map");
    HhLog.d("fetchPage -- $result");
    HhLog.d("fetchPage -- total ${result["data"]["total"]}");
    if(result["data"]!=null && result["data"]["list"]!=null){
      List<dynamic> newItems = result["data"]["list"];
      /*if (pageNum == 1) {
        listController.itemList = [];
      } else if(newItems.isEmpty){
        easyController.finishLoad(IndicatorResult.noMore,true);
      }
      listController.appendLastPage(newItems);*/
      totalPage = CommonUtils().parseTotalPage("${result["data"]["total"]}", pageSize);
      HhLog.d("fetchPage -- total $totalPage");
      if(pageNum == 1){
        listController.itemList = [];
      }
      if(pageNum > totalPage){
        listController.appendLastPage([]);
        easyController.finishLoad(IndicatorResult.noMore,true);
      }else{
        listController.appendLastPage(newItems);
      }
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }

  }

  Future<void> getWarnType() async {
    typeList.clear();
    var result = await HhHttp()
        .request(RequestUtils.getAlarmConfig, method: DioMethod.get);
    HhLog.d("getWarnType --  $result");
    if (result["code"] == 0) {
      dynamic data = result["data"];
      if(data!=null){
        for(dynamic model in data){
          if(model["chose"]==1){
            typeList.add(model);
          }
        }
      }
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> readOne(String id) async {
    Map<String, dynamic> map = {};
    map['ids'] = [id];
    var result = await HhHttp().request(RequestUtils.leftRead, method: DioMethod.post, params: map);
    if (result["code"] == 0 && result["data"] == true) {
      HhLog.d("readOne $result");
      fetchPage();
    } else {

    }
  }

}
