import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
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
import 'package:qc_amap_navi/qc_amap_navi.dart';

class MapLocationSearchController extends GetxController {
  final index = 0.obs;
  final Rx<bool> testStatus = true.obs;
  late AMapController gdMapController;
  final RxSet<Marker> aMapMarkers = <Marker>{}.obs;
  late int pageNum = 1;
  final PagingController<int, dynamic> deviceController = PagingController(firstPageKey: 1);
  final ScrollController deviceScrollController = ScrollController();
  late EasyRefreshController deviceEasyController = EasyRefreshController();
  late TextEditingController? searchController = TextEditingController();

  @override
  Future<void> onInit() async {
    dynamic arguments = Get.arguments;
    if(arguments!=null && arguments["name"]!=null){
      searchController!.text = arguments["name"];
    }
    super.onInit();
    //加载设备列表
    fetchPage();
  }

  @override
  Future<void> onClose() async {
    super.onClose();
  }

  /// 创建完成回调
  void onGDMapCreated(AMapController controller) {
    gdMapController = controller;

    if(CommonData.latitude!=null && CommonData.latitude!=0){
      gdMapController.moveCamera(CameraUpdate.newLatLngZoom(LatLng(CommonData.latitude!,CommonData.longitude!), 14));
    }
  }

  void updateMarker({bool location = false}){
    aMapMarkers.clear();
    ///用户位置打点
    if(CommonData.latitude!=null && CommonData.latitude!=0){
      LatLng myLoc = LatLng(CommonData.latitude!,CommonData.longitude!);
      Marker mk = Marker(
          anchor: const Offset(0.5, 1.0),
          position: myLoc,
          icon: BitmapDescriptor.fromIconPath('assets/images/common/icon_point.png'),
          onTap: (v){
            gdMapController.moveCamera(CameraUpdate.newLatLngZoom(myLoc, 16));
          }
      );
      aMapMarkers.add(mk);
    }
    ///设备打点
    List<dynamic> newItems = deviceController.itemList??[];
    for(int i = 0; i < newItems.length; i++){
      try{
        dynamic model = newItems[i];
        LatLng latLng = LatLng(double.parse("${model["latitude"]}"),double.parse("${model["longitude"]}"));
        Marker mk = Marker(
            anchor: const Offset(0.5, 1.0),
            position: latLng,
            icon: BitmapDescriptor.fromIconPath("${model["status"]}"=="1"?'assets/images/common/ic_device_online2.png':'assets/images/common/ic_device_offline2.png'),
            onTap: (v){
              gdMapController.moveCamera(CameraUpdate.newLatLngZoom(latLng, 16));
              deviceDetailDialog(model);
            }
        );
        aMapMarkers.add(mk);
        if(i == 0 && !location){
          gdMapController.moveCamera(CameraUpdate.newLatLngZoom(latLng, 16));
        }
      }catch(e){
        HhLog.e("$e");
      }
    }

    ///用户位置点击
    if(location){
      if(CommonData.latitude!=null && CommonData.latitude!=0){
        LatLng myLoc = LatLng(CommonData.latitude!,CommonData.longitude!);
        gdMapController.moveCamera(CameraUpdate.newLatLngZoom(myLoc, 16));
      }else{
        EventBusUtil.getInstance().fire(HhToast(title: "定位获取中…",type: 0));
      }
    }

  }

  Future<void> fetchPage() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {
      "pageNum":pageNum,
      "pageSize":100,
      "status":null,
      "activeStatus":1,
    };
    map["name"] = searchController!.text;
    var result = await HhHttp().request(RequestUtils.mainDeviceList,method: DioMethod.get,params: map);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("fetchPage -- $map");
    HhLog.d("fetchPage -- total ${result['data']["total"]}");
    HhLog.d("fetchPage -- $result");
    if(result["data"]!=null && result["data"]["list"]!=null){
      List<dynamic> newItems = result["data"]["list"];
      if (pageNum == 1) {
        deviceController.itemList = [];
      }
      deviceController.appendLastPage(newItems);
      updateMarker();
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }

  }

  ///设备详情弹窗
  void deviceDetailDialog(dynamic device) {
    showModalBottomSheet(context: Get.context!, builder: (a){
      return Container(
        width: 1.sw,
        height: 350.w*3,
        padding: EdgeInsets.fromLTRB(15.w*3, 0, 15.w*3, 0),
        decoration: BoxDecoration(
            color: HhColors.whiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(6.w*3))
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 6.w*3,),
              Row(
                children: [
                  const Spacer(),
                  HhTap(
                    onTapUp: (){
                      Get.back();
                    },
                    child: Container(
                        color: HhColors.trans,
                        padding: EdgeInsets.fromLTRB(15.w*3, 8.w*3, 5.w*3, 5.w*3),
                        child: Image.asset('assets/images/common/icon_up_x.png',width:12.w*3,height: 12.w*3,fit: BoxFit.fill,)
                    ),
                  ),
                ],
              ),
              ///设备名称
              Text(CommonUtils().parseNull("${device["name"]}", ""),style: TextStyle(fontSize: 15.sp*3,fontWeight: FontWeight.w600,color: HhColors.textBlackColor)),
              CommonUtils.line(margin: EdgeInsets.only(top: 15.w*3,bottom: 15.w*3)),
              ///设备类型
              Row(
                children: [
                  Text("设备类型",style: TextStyle(fontSize: 15.sp*3,fontWeight: FontWeight.w500,color: HhColors.textBlackColor)),
                  SizedBox(width: 10.w*3,),
                  Expanded(child: Text(CommonUtils().parseNull("${device["productName"]}", ""),style: TextStyle(fontSize: 15.sp*3,fontWeight: FontWeight.w400,color: HhColors.gray9TextColor),textAlign: TextAlign.right,overflow: TextOverflow.ellipsis,)),
                  SizedBox(width: 2.w*3,)
                ],
              ),
              CommonUtils.line(margin: EdgeInsets.only(top: 15.w*3,bottom: 15.w*3)),
              ///经纬度
              Row(
                children: [
                  Text("经纬度",style: TextStyle(fontSize: 15.sp*3,fontWeight: FontWeight.w500,color: HhColors.textBlackColor)),
                  SizedBox(width: 10.w*3,),
                  Expanded(child: Text("(${device["longitude"]??""},${device["latitude"]??""})",style: TextStyle(fontSize: 15.sp*3,fontWeight: FontWeight.w400,color: HhColors.gray9TextColor),textAlign: TextAlign.right,overflow: TextOverflow.ellipsis,)),
                  SizedBox(width: 2.w*3,)
                ],
              ),
              CommonUtils.line(margin: EdgeInsets.only(top: 15.w*3,bottom: 10.w*3)),
              ///位置
              Text("位置",style: TextStyle(fontSize: 15.sp*3,fontWeight: FontWeight.w500,color: HhColors.textBlackColor)),
              SizedBox(height: 5.w*3,),
              Text(
                CommonUtils().parseNull("${device["location"]}", ""),
                style: TextStyle(fontSize: 15.sp*3,fontWeight: FontWeight.w400,color: HhColors.gray9TextColor),
                overflow: TextOverflow.ellipsis,maxLines: 3,
              ),
              CommonUtils.line(margin: EdgeInsets.only(top: 15.w*3,bottom: 12.w*3)),
              ///按钮
              Row(
                children: [
                  Expanded(
                      child: BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 0.2,
                          onPressed: (){
                            CommonUtils().parseRouteDetail(device);
                          },
                      child: Container(
                        decoration: BoxDecoration(
                          color: HhColors.whiteColor,
                          borderRadius: BorderRadius.circular(8.w*3),
                          border: Border.all(color: HhColors.grayLineColor,width: 1.w*3)
                        ),
                          padding: EdgeInsets.all(12.w*3),
                          child: Text("视频",style: TextStyle(fontSize: 15.sp*3,fontWeight: FontWeight.w500,color: HhColors.textBlackColor),textAlign: TextAlign.center,)
                      )
                    )
                  ),
                  SizedBox(width: 15.w*3,),
                  Expanded(
                      child: BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 0.2,
                          onPressed: () async {
                            try{
                              List<double> end = ParseLocation.gps84_To_Gcj02(double.parse("${device['latitude']}"), double.parse("${device['longitude']}"),);
                              EventBusUtil.getInstance().fire(HhLoading(show: true));
                              await QcAmapNavi.startNavigation(
                                fromLat: double.parse("${CommonData.latitude}"),
                                fromLng: double.parse("${CommonData.longitude}"),
                                fromName: "我的位置",
                                toLat: double.parse("${end[0]}"),
                                toLng: double.parse("${end[1]}"),
                                toName: "${device['name']}",
                              );
                              EventBusUtil.getInstance().fire(HhLoading(show: false));
                            }catch(e){
                              HhLog.e(e.toString());
                              EventBusUtil.getInstance().fire(HhToast(title: "该定位不可用"));
                            }
                          },
                      child: Container(
                        decoration: BoxDecoration(
                          color: HhColors.mainBlueColor,
                          borderRadius: BorderRadius.circular(8.w*3),
                        ),
                          padding: EdgeInsets.all(12.w*3),
                          child: Text("导航",style: TextStyle(fontSize: 15.sp*3,fontWeight: FontWeight.w500,color: HhColors.whiteColor),textAlign: TextAlign.center,)
                      )
                    )
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },isDismissible: true,enableDrag: false,isScrollControlled: true);
  }

}
