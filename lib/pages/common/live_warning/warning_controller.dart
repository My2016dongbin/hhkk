import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LiveWarningController extends GetxController {
  late BuildContext context;
  late DateTime start ;
  late DateTime end ;
  final Rx<bool> pageStatus = true.obs;
  final Rx<String> dateStr = "日期".obs;
  final Rx<String> warnCount = "0".obs;
  final Rx<int> warnCountInt = 0.obs;
  final PagingController<int, dynamic> deviceController =
      PagingController(firstPageKey: 1);
  late int pageNum = 1;
  late int pageSize = 20;
  late int totalPage = 0;
  late EasyRefreshController easyController = EasyRefreshController();
  List<String> dateList = [];
  final Rx<int> chooseListNumber = 0.obs;
  List<num> chooseList = [];
  final Rx<bool> edit = false.obs;
  final TooltipController tipController = TooltipController();
  StreamSubscription ?messageSubscription;
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  final Rx<int> fireType = 0.obs;

  @override
  void onInit() {
    fetchPage(1);
    messageSubscription = EventBusUtil.getInstance()
        .on<Message>()
        .listen((event) {
      pageNum = 1;
      fetchPage(1);
    });


    ///TODO 主页火险预警未读状态
    //EventBusUtil.getInstance().fire(FireWarning(unRead: false));
    super.onInit();
  }

  @override
  void onClose() {
    try{
      messageSubscription!.cancel();
    }catch(e){
      //
    }
    super.onClose();
  }

  Future<void> fetchPage(int pageKey) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {};
    if(fireType.value != 0){
      map['alarmMajor'] = fireType.value == 1?"FireRiskLevel":"Meteorology";
    }
    /*map['pageNum'] = pageKey;
    map['pageSize'] = pageSize;*/
    var result = await HhHttp()
        .request(RequestUtils.liveWarningList, method: DioMethod.get, params: map);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("fetchPage map --  $map");
    HhLog.d("fetchPage --  $pageKey , $result");
    if (result["rows"] != null) {
      /*totalPage = CommonUtils().parseTotalPage("${result["total"]}", pageSize);*/
      List<dynamic> newItems = result["rows"];

      /*if (pageKey == 1) {
        deviceController.itemList = [];
        chooseList = [];
        chooseListNumber.value = 0;
      }else{
        if(pageNum > totalPage){
          newItems = [];
          refreshController.loadNoData();
        }
      }*/
      deviceController.itemList = [];
      deviceController.appendLastPage(newItems);
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
}
