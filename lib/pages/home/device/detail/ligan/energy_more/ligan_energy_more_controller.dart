import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';

class LiGanEnergyMoreController extends GetxController {
  late BuildContext context;
  late String deviceNo = "";
  final Rx<bool> pageStatus = true.obs;
  final PagingController<int, dynamic> pagingController =
      PagingController(firstPageKey: 1);
  late EasyRefreshController easyController = EasyRefreshController();
  late int pageNum = 1;
  late int pageSize = 10;

  @override
  void onInit() {
    dynamic args = Get.arguments;
    if (args is Map && args["deviceNo"] != null) {
      deviceNo = "${args["deviceNo"]}";
    }
    getEnergyList(1);
    super.onInit();
  }

  Future<void> getEnergyList(int pageKey) async {
    if (deviceNo.isEmpty) {
      return;
    }
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {};
    map['deviceCode'] = deviceNo;
    map['pageNo'] = pageKey;
    map['pageSize'] = pageSize;
    var result = await HhHttp()
        .request(RequestUtils.energyPage, method: DioMethod.get, params: map);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("getEnergyList -- $map");
    HhLog.d("getEnergyList -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      List<dynamic> newItems = [];
      try {
        newItems = result["data"]["list"] ?? [];
      } catch (e) {
        HhLog.e(e.toString());
      }

      if (pageKey == 1) {
        pagingController.itemList = [];
      } else {
        if (newItems.isEmpty) {
          easyController.finishLoad(IndicatorResult.noMore, true);
        }
      }
      pagingController.appendLastPage(newItems);
      pageStatus.value = false;
      pageStatus.value = true;
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
      if (pageKey > 1) {
        pageNum--;
      }
    }
  }
}
