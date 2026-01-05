import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/home/device/status/device_status_binding.dart';
import 'package:iot/pages/home/device/status/device_status_view.dart';
import 'package:iot/pages/home/home_binding.dart';
import 'package:iot/pages/home/home_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/ParseLocation.dart';
import 'package:iot/utils/RequestUtils.dart';

class DeviceAddController extends GetxController {
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final Rx<int> addingStatus = 0.obs;//0添加中 1添加成功 2添加失败
  final Rx<int> addingStep = 0.obs;//0初始 1连接设备成功 2标准认证成功 3设备绑定账号成功
  final PagingController<int, dynamic> deviceController = PagingController(firstPageKey: 0);
  late int pageNum = 1;
  late int pageSize = 100;
  final Rx<bool> isEdit = false.obs;//是否为修改页面
  final Rx<String> location = '点击选择设备定位'.obs;
  late dynamic model = {};
  late String snCode = '';
  late String spaceId = '';
  final Rx<String> locText = ''.obs;
  TextEditingController ?snController = TextEditingController();
  TextEditingController ?nameController = TextEditingController(text:'新的设备');
  List<dynamic> newItems = [];
  StreamSubscription ?locTextSubscription;
  StreamSubscription ?spaceListSubscription;
  StreamSubscription ?toastSubscription;
  final Rx<double?> latitude = CommonData.latitude.obs;
  final Rx<double?> longitude = CommonData.longitude.obs;

  @override
  void onInit() {
    getSpaceList();
    locTextSubscription = EventBusUtil.getInstance()
        .on<LocText>()
        .listen((event) {
          HhLog.d("逆地理编码 event ${event.text}");
      locText.value = event.text!;
    });
    spaceListSubscription = EventBusUtil.getInstance()
        .on<SpaceList>()
        .listen((event) {
      getSpaceList();
    });
    toastSubscription = EventBusUtil.getInstance()
        .on<HhToast>()
        .listen((event) {
      if(event.title.isEmpty || event.title == "null"){
        return;
      }
          if(event.title.contains('服务器')){
            addingStatus.value = 2;
          }
    });
    Future.delayed(const Duration(seconds: 1),(){
      if(snCode!=''){
        snController!.text = snCode;
      }
    });

    model = Get.arguments;
    HhLog.d("isEdit $model");
    isEdit.value = model!=null&&model!={};
    if(isEdit.value){
      snController!.text = model['deviceNo']??"";
      nameController!.text = model['name']??"";
      locText.value = model['location']??"";

      if(model['longitude']!=null && model['longitude']!=0 && model['longitude']!=""){
        // dynamic map = CommonUtils().gdToBd(double.parse(model['longitude']), double.parse(model['latitude']));
        List<double> map = ParseLocation.parseTypeToBd09(double.parse("${model['latitude']}"), double.parse("${model['longitude']}"),model['coordinateType']??"0");
        model['longitude'] = "${map[1]}";
        model['latitude'] = "${map[0]}";

        longitude.value = double.parse(model['longitude']);
        latitude.value = double.parse(model['latitude']);
        HhLog.d("isEdit ${longitude.value},${latitude.value}");
        // locSearched();
      }
    }
    super.onInit();
  }


  Future<void> locSearched() async {
    /*// 构造检索参数
    BMFReverseGeoCodeSearchOption reverseGeoCodeSearchOption =
    BMFReverseGeoCodeSearchOption(
        location: BMFCoordinate(latitude.value!, longitude.value!));
    // 检索实例
    BMFReverseGeoCodeSearch reverseGeoCodeSearch = BMFReverseGeoCodeSearch();
    // 逆地理编码回调
    reverseGeoCodeSearch.onGetReverseGeoCodeSearchResult(callback:
        (BMFReverseGeoCodeSearchResult result,
        BMFSearchErrorCode errorCode) {
      HhLog.d("逆地理编码-  errorCode = $errorCode, result = ${result.toMap()}");
      List<BMFPoiInfo> ?poiList = result.poiList;
      if(poiList!=null && poiList.isNotEmpty){
        locText.value = CommonUtils().parseNull("${poiList[0].name}", "定位中..");
      }else{
        locText.value = CommonUtils().parseNull("${result.address}", "定位中..");
      }
      HhLog.d("-----------${locText.value }");
    });
    /// 发起检索
    bool flag = await reverseGeoCodeSearch.reverseGeoCodeSearch(reverseGeoCodeSearchOption);*/
  }


  Future<void> getSpaceList() async {
    Map<String, dynamic> map = {};
    map['pageNo'] = '1';
    map['pageSize'] = '100';
    var result = await HhHttp().request(RequestUtils.mainSpaceList,method: DioMethod.get,params: map);
    HhLog.d("getSpaceList -- $result");
    if(result["code"]==0 && result["data"]!=null){
      try{
        newItems = result["data"]["list"];
        if(newItems.isNotEmpty){
          spaceId = "${newItems[0]["id"]}";
        }

        if(isEdit.value){
          for(int i = 0;i < newItems.length;i++){
            dynamic m = newItems[i];
            if(m['id'] == model['spaceId']){
              index.value = i;
            }
          }
        }
      }catch(e){
        HhLog.e(e.toString());
      }

      if(pageNum == 1){
        deviceController.itemList = [];
      }
      deviceController.appendLastPage(newItems);
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> createDevice() async {
    Get.to(()=>DeviceStatusPage(),binding: DeviceStatusBinding());
    addingStatus.value = 0;
    addingStep.value = 0;
    futureStep();
    // dynamic map = CommonUtils().bdToGd(longitude.value!, latitude.value!);
    // List<num> map = ParseLocation.bd09_To_gps84(num.parse("${latitude.value!}"), num.parse("${longitude.value!}"));
    dynamic data = {
      "deviceNo":snController!.text,
    "name":nameController!.text==''?null:nameController!.text,
    "spaceId":spaceId,
    "longitude":"${longitude.value!}",
    "latitude":"${latitude.value!}",
    "location":locText.value,
    "coordinateType":2
    };
    var result = await HhHttp().request(RequestUtils.deviceCreate,method: DioMethod.post,data: data);
    HhLog.d("createDevice data -- $data");
    HhLog.d("createDevice result -- $result");
    if(result["code"]==0 && result["data"]!=null){
      Future.delayed(const Duration(seconds: 2),(){
        addingStatus.value = 1;
        addingStep.value = 3;
        EventBusUtil.getInstance().fire(SpaceList());
        EventBusUtil.getInstance().fire(DeviceList());
        EventBusUtil.getInstance().fire(HhToast(title: '添加成功',type: 1));
      });
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
      addingStatus.value = 2;
    }
  }

  Future<void> updateDevice(bool hasLocation) async {
    try{
      HhLog.d("newItems[index.value] ${newItems[index.value]}");
      model['spaceName'] = newItems[index.value]['name'];
      model['spaceId'] = newItems[index.value]['id'];
      if(hasLocation){
        // dynamic map = CommonUtils().bdToGd(longitude.value!, latitude.value!);
        // List<num> map = ParseLocation.bd09_To_gps84(num.parse("${latitude.value!}"), num.parse("${longitude.value!}"));
        model['longitude'] = "${longitude.value!}";
        model['latitude'] = "${latitude.value!}";
        model['location'] = locText.value;
        model['coordinateType'] = 2;
      }
      HhLog.d("model $model ，${locText.value}");
    }catch(e){
      //
    }
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    var result = await HhHttp().request(RequestUtils.deviceUpdate,method: DioMethod.put,data: model);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("updateDevice model -- $model");
    HhLog.d("updateDevice result -- $result");
    if(result["code"]==0 && result["data"]!=null){
      EventBusUtil.getInstance().fire(HhToast(title: '修改设备成功',type: 0));
      EventBusUtil.getInstance().fire(DeviceList());
      EventBusUtil.getInstance().fire(SpaceList());
      EventBusUtil.getInstance().fire(DeviceInfo());
      // Get.back();
      Get.offAll(() => HomePage(), binding: HomeBinding());
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
      addingStatus.value = 2;
    }
  }

  void futureStep() {
    if(addingStep.value > 1){
      return;
    }
    Future.delayed(const Duration(seconds: 1),(){
      addingStep.value++;
      futureStep();
    });
  }
}
