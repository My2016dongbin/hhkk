import 'dart:math';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/share/share_binding.dart';
import 'package:iot/pages/common/share/share_view.dart';
import 'package:iot/pages/common/web/WebViewPage.dart';
import 'package:iot/pages/home/device/add/device_add_binding.dart';
import 'package:iot/pages/home/device/add/device_add_view.dart';
import 'package:iot/pages/home/device/detail/device_detail_binding.dart';
import 'package:iot/pages/home/device/detail/device_detail_view.dart';
import 'package:iot/pages/home/home_controller.dart';
import 'package:iot/pages/home/video/search/search_binding.dart';
import 'package:iot/pages/home/video/search/search_view.dart';
import 'package:iot/pages/home/message/message_controller.dart';
import 'package:iot/pages/home/mqtt/mqtt_binding.dart';
import 'package:iot/pages/home/mqtt/mqtt_controller.dart';
import 'package:iot/pages/home/mqtt/mqtt_view.dart';
import 'package:iot/pages/home/my/setting/edit_user/edit_binding.dart';
import 'package:iot/pages/home/space/manage/space_manage_binding.dart';
import 'package:iot/pages/home/space/manage/space_manage_view.dart';
import 'package:iot/pages/home/space/space_binding.dart';
import 'package:iot/pages/home/space/space_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/ParseLocation.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
// import 'package:qc_amap_navi/qc_amap_navi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'video_controller.dart';

class VideoPage extends StatelessWidget {
  final logic = Get.find<VideoController>();
  final homeLogic = Get.find<HomeController>();
  final messageLogic = Get.find<MessageController>();

  VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    return OverlayTooltipScaffold(
      overlayColor: Colors.red.withOpacity(.4),
      tooltipAnimationCurve: Curves.linear,
      tooltipAnimationDuration: const Duration(milliseconds: 0),
      controller: logic.tipController,
      preferredOverlay: GestureDetector(
        onTap: () {
          logic.tipController.dismiss();
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: HhColors.mainGrayColor,
        ),
      ),
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: HhColors.backColor,
          body: Obx(
                () => Container(
              height: 1.sh,
              width: 1.sw,
              padding: EdgeInsets.zero,
              child: logic.secondStatus.value?(logic.pageMapStatus.value ? mapPage() : containPage()) : firstPage(),
            ),
          ),
        );
      },
    );
  }

  ///地图视图-搜索
  buildSearchView() {
    return Container(
      width: 178.w*3,
      height: logic.searchDown.value?293.w*3:55.w*3,
      margin: EdgeInsets.fromLTRB(14.w*3, 100.w*3, 0, 0),
      padding: EdgeInsets.fromLTRB(8.w*3, 10.w*3, 6.w*3, 10.w*3),
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: HhColors.trans_77,

              ///控制阴影的位置
              offset: Offset(0, 10),

              ///控制阴影的大小
              blurRadius: 24.0,
            ),
          ],
          color: HhColors.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///搜索框
                Container(
                  height:28.w*3,
                  padding: EdgeInsets.fromLTRB(8.w*3, 0, 8.w*3, 0),
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      border: Border.all(color: HhColors.mainBlueColor),
                      borderRadius: BorderRadius.all(Radius.circular(16.w*3))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/common/icon_search.png",
                        width: 14.w*3,
                        height: 14.w*3,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          cursorColor: HhColors.titleColor_99,
                          controller: logic.searchController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (s){
                            // if(logic.searchController!.text.isEmpty){
                            //   EventBusUtil.getInstance().fire(HhToast(title: '请输入名称'));
                            //   return;
                            // }
                            logic.deviceSearch();
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none
                            ),
                            hintText: '请输入名称',
                            hintStyle: TextStyle(
                                color: HhColors.gray9TextColor, fontSize: 12.sp*3),
                          ),
                          style:
                              TextStyle(color: HhColors.textColor, fontSize: 12.sp*3),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          logic.searchDown.value = !logic.searchDown.value;
                        },
                        child: Container(
                          padding: EdgeInsets.all(5.w),
                          margin: EdgeInsets.only(bottom: 2.w),
                          child: Image.asset(
                            logic.searchDown.value?"assets/images/common/icon_top_status.png":"assets/images/common/icon_down_status.png",
                            width: 15.w*3,
                            height: 15.w*3,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      // SizedBox(width: 20.w,),
                    ],
                  ),
                ),
                logic.searchDown.value?SizedBox(height: 5.w*3,):const SizedBox(),
                ///列表数据
                logic.searchDown.value?Expanded(
                  child: PagedListView<int, dynamic>(
                    pagingController: logic.deviceController,
                    padding: EdgeInsets.zero,
                    builderDelegate: PagedChildBuilderDelegate<dynamic>(
                      noItemsFoundIndicatorBuilder: (context) =>CommonUtils().noneWidgetSmall(image:'assets/images/common/icon_no_message_search.png',text: '没有找到匹配的结果'),
                      itemBuilder: (context, item, index) =>
                          InkWell(
                            onTap: (){
                              HhLog.d("touch ${item["latitude"]},${item["longitude"]}");
                              List<double> point = ParseLocation.parseTypeToBd09(double.parse('${item["latitude"]}'), double.parse('${item["longitude"]}'),item['coordinateType']??"0");
                              logic.controller?.setCenterCoordinate(
                                BMFCoordinate(point[0],point[1]), false,
                              );
                              logic.controller?.setZoomTo(17);
                              logic.searchDown.value = false;
                              logic.searchListIndex.value = index;
                              logic.model = item;
                              logic.videoStatus.value = false;
                              logic.videoStatus.value = true;
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(4.w*3, 5.w*3, 16.w*3, 4.w*3),
                                  decoration: BoxDecoration(
                                      color: logic.searchListIndex.value == index?HhColors.blueBackColor:HhColors.whiteColor,
                                      borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "${item['name']}",
                                          style: TextStyle(
                                              color: HhColors.textBlackColor,
                                              fontSize: 14.sp*3,fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      "${item['location']}"=='null'?const SizedBox():Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10.w),
                                          child: Text(
                                            "${item['location']}",
                                            style: TextStyle(
                                                color: HhColors.gray9TextColor,
                                                fontSize: 12.sp*3),
                                          ),
                                        ),
                                      ),
                                      "${item['longitude']}"=="null"?const SizedBox():Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10.w),
                                          child: Text(
                                            "(${CommonUtils().subString("${item['longitude']}", 8)},${CommonUtils().subString("${item['latitude']}", 8)})",
                                            style: TextStyle(
                                                color: HhColors.gray9TextColor,
                                                fontSize: 12.sp*3),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w*3,
                                  width: 1.sw,
                                  margin: EdgeInsets.fromLTRB(0, 5.w*3, 0, 10.w*3),
                                  color: HhColors.grayF3TextColor,
                                )
                              ],
                            ),
                          )
                    ),
                  ),
                ):const SizedBox(),
              ],
            ),
          ),
          InkWell(
            onTap: (){
              logic.restartSearchClick();
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 30.w, 0, 30.w),
              child: Image.asset(
                'assets/images/common/icon_map_left.png',
                width: 16.w*3,
                height: 16.w*3,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///主页-地图视图
  mapPage() {
    return Stack(
      children: [
        BMFMapWidget(
          onBMFMapCreated: (controller) {
            logic.onBMFMapCreated(controller);
          },
          mapOptions: BMFMapOptions(
              center: BMFCoordinate(CommonData.latitude ?? 36.30865,
                  CommonData.longitude ?? 120.314037),
              zoomLevel: 12,
              mapType: BMFMapType.Standard,
              mapPadding:
                  BMFEdgeInsets(left: 30.w, top: 0, right: 30.w, bottom: 0)),
        ),
        Container(
          height: 88.w*3,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: CommonUtils().gradientColors()),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: (){
                    logic.pageMapStatus.value = false;
                    logic.videoStatus.value = false;
                    Future.delayed(const Duration(seconds: 5),(){
                      logic.refreshMarkers();
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(16.w*3, 0, 0, 10.w*3),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/common/back.png",
                          height: 17.w*3,
                          width: 10.w*3,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(width: 14.w*3,),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              CommonUtils().parseNameCount("${logic.spaceList[logic.spaceListIndex.value]['name']}", 10),
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 18.sp*3,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 3.w*3,
                            ),
                            Container(                                
                              height:2.w*3,
                              width: 10.w*3,
                              decoration: BoxDecoration(
                                color: HhColors.blackTextColor,
                                borderRadius: BorderRadius.circular(2.w)
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: () {
                        logic.pageMapStatus.value = false;
                        logic.videoStatus.value = false;
                        Future.delayed(const Duration(seconds: 5),(){
                          logic.refreshMarkers();
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10.w*3),
                        padding:EdgeInsets.fromLTRB(11.w*3, 4.w*3, 11.w*3, 4.w*3),
                        decoration: BoxDecoration(
                          color: HhColors.whiteColor,
                          borderRadius:
                          BorderRadius.all(Radius.circular(12.w*3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/common/ic_jk.png",
                              width: 16.w*3,
                              height: 16.w*3,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              width: 5.h,
                            ),
                            Text(
                              "空间",
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 14.sp*3),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 59.w*3,),
                    /*BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: (){
                        logic.tipController.start();
                      },
                      child: OverlayTooltipItem(
                        displayIndex: 0,
                        tooltip: (controller) {
                          return BouncingWidget(
                            duration: const Duration(milliseconds: 100),
                            scaleFactor: 1.2,
                            onPressed: (){
                              logic.tipController.dismiss();
                              Get.to(() => SpaceManagePage(),
                                  binding: SpaceManageBinding());
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0,8.w*3,14.w*3,0),
                              padding: EdgeInsets.fromLTRB(22.w*3, 25.w*3, 15.w*3, 24.w*3),
                              decoration: BoxDecoration(
                                  color: HhColors.whiteColor,
                                  borderRadius: BorderRadius.circular(16.w*3)
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('管理空间', style: TextStyle(color: HhColors.textBlackColor,fontSize: 15.sp*3,fontWeight: FontWeight.w200),),
                                  SizedBox(width: 20.w*3,),
                                  Image.asset(
                                    "assets/images/common/ic_setting.png",
                                    width: 18.w*3,
                                    height: 18.w*3,
                                    fit: BoxFit.fill,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(18.w*3, 0, 18.w*3, 10.w),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              color: HhColors.trans,
                              borderRadius: BorderRadius.all(Radius.circular(20.w))
                          ),
                          child: Image.asset(
                            "assets/images/common/icon_menu.png",
                            width: 24.w*3,
                            height: 24.w*3,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),*/
                  ],
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: logic.searchStatus.value
              ? buildSearchView()
              : Column(
                  children: [
                    Row(
                      children: [
                        BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.2,
                          onPressed: logic.onSearchClick,
                          child: Container(
                            decoration: BoxDecoration(
                              color: HhColors.whiteColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.w*3)),
                              boxShadow: const [
                                BoxShadow(
                                  color: HhColors.trans_77,

                                  ///控制阴影的位置
                                  offset: Offset(0, 10),

                                  ///控制阴影的大小
                                  blurRadius: 24.0,
                                ),
                              ],
                            ),
                            margin: EdgeInsets.fromLTRB(
                                14.w*3, 100.w*3, 0, 0),
                            padding:
                                EdgeInsets.fromLTRB(10.w*3, 5.w*3, 10.w*3, 3.w*3),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/images/common/icon_search.png",
                                  width: 24.w*3,
                                  height: 24.w*3,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(
                                  height: 5.w,
                                ),
                                Text(
                                  "搜索",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: HhColors.blackTextColor,
                                      fontSize: 10.sp*3),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
        logic.videoStatus.value
            ? Align(
                alignment: Alignment.bottomCenter,
                child:
                Container(
                  width: 1.sw,
                  margin: EdgeInsets.fromLTRB(14.w*3, 0, 14.w*3, 30.w*3),
                  clipBehavior: Clip.hardEdge,
                  //裁剪
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(16.w*3))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(16.w*3, 15.w*3, 0, 0),
                        child: Text(
                          "${logic.model["name"]}",
                          style: TextStyle(
                              color: HhColors.blackTextColor, fontSize: 14.sp*3,fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        color: HhColors.line252Color,
                        height: 1,
                        margin: EdgeInsets.fromLTRB(15.w*3, 15.w*3, 15.w*3, 0),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(16.w*3, 15.w*3, 16.w*3, 0),
                        child: Row(
                          children: [
                            Text(
                              "设备类型",
                              style: TextStyle(
                                  color: HhColors.blackTextColor, fontSize: 14.sp*3,fontWeight: FontWeight.w500),
                            ),
                            const Expanded(child: SizedBox()),
                            Text(
                              "${logic.model["productName"]}",
                              style: TextStyle(
                                  color: HhColors.gray9TextColor, fontSize: 14.sp*3,fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: HhColors.line252Color,
                        height: 1,
                        margin: EdgeInsets.fromLTRB(15.w*3, 15.w*3, 15.w*3, 0),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(16.w*3, 15.w*3, 16.w*3, 0),
                        child: Row(
                          children: [
                            Text(
                              "经纬度",
                              style: TextStyle(
                                  color: HhColors.blackTextColor, fontSize: 14.sp*3,fontWeight: FontWeight.w500),
                            ),
                            const Expanded(child: SizedBox()),
                            Text(
                              "(${CommonUtils().parseDoubleNumber("${logic.model["longitude"]}", 6)},${CommonUtils().parseDoubleNumber("${logic.model["latitude"]}", 6)})",
                              style: TextStyle(
                                  color: HhColors.gray9TextColor, fontSize: 14.sp*3,fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: HhColors.line252Color,
                        height: 1,
                        margin: EdgeInsets.fromLTRB(15.w*3, 15.w*3, 15.w*3, 0),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(16.w*3, 15.w*3, 16.w*3, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "位置",
                              style: TextStyle(
                                  color: HhColors.blackTextColor, fontSize: 14.sp*3,fontWeight: FontWeight.w500),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 2.w*3),
                              child: Text(
                                "${logic.model["location"]}",
                                maxLines: 2,
                                style: TextStyle(
                                    color: HhColors.gray9TextColor, fontSize: 14.sp*3,fontWeight: FontWeight.w500,overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: HhColors.line252Color,
                        height: 1,
                        margin: EdgeInsets.fromLTRB(15.w*3, 15.w*3, 15.w*3, 0),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15.w*3, 0, 15.w*3, 15.w*3),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              BouncingWidget(
                                duration: const Duration(milliseconds: 100),
                                scaleFactor: 1.2,
                                onPressed: () {
                                  CommonUtils().parseRouteDetail(logic.model);
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 13.w*3, 0, 0),
                                  padding: EdgeInsets.fromLTRB(50.w*3, 12.w*3, 50.w*3, 12.w*3),
                                  decoration: BoxDecoration(
                                      color: HhColors.whiteColor,
                                      border: Border.all(color: HhColors.grayCCTextColor,width: 2.w),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(8.w*3))),
                                  child: Text(
                                    "查看",
                                    style: TextStyle(
                                        color: HhColors.blackTextColor, fontSize: 16.sp*3),
                                  ),
                                ),
                              ),
                              SizedBox(width: 15.w*3,),
                              BouncingWidget(
                                duration: const Duration(milliseconds: 100),
                                scaleFactor: 1.2,
                                onPressed: () {
                                  /*try{
                                    List<num> start = ParseLocation.bd09_To_Gcj02(num.parse("${CommonData.latitude!}"), num.parse("${CommonData.longitude}"));
                                    List<num> end = ParseLocation.parseTypeToGcj02(num.parse("${logic.model["latitude"]}"), num.parse("${logic.model["longitude"]}"),logic.model['coordinateType']??"0");
                                    QcAmapNavi.startNavigation(
                                      fromLat: double.parse("${start[0]}"),
                                      fromLng: double.parse("${start[1]}"),
                                      fromName: "我的位置",
                                      toLat: double.parse("${end[0]}"),
                                      toLng: double.parse("${end[1]}"),
                                      toName: "${logic.model["name"]}",
                                    );
                                  }catch(e){
                                    HhLog.e(e.toString());
                                  }*/
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 13.w*3, 0, 0),
                                  padding: EdgeInsets.fromLTRB(50.w*3, 12.w*3, 50.w*3, 12.w*3),
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(6.w*3))),
                                  child: Text(
                                    "导航",
                                    style: TextStyle(
                                        color: HhColors.whiteColor, fontSize: 16.sp*3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  ///主页-我的空间视图
  containPage() {
    return logic.containStatus.value?Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: CommonUtils().gradientColors()),
          ),
        ),
        Column(
          children: [
            ///搜索
            BouncingWidget(
              duration: const Duration(milliseconds: 100),
              scaleFactor: 1.2,
              onPressed: () {
                Get.to(()=>SearchPage(),binding: SearchBinding());
              },
              child: Container(
                height: 38.w*3,
                margin: EdgeInsets.fromLTRB(14.w*3, 72.h*3, 14.w*3, 0),
                decoration: BoxDecoration(
                  color: HhColors.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(19.w*3)),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 12.w*3,
                    ),
                    Image.asset(
                      "assets/images/common/icon_search.png",
                      width: 24.w*3,
                      height: 24.w*3,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      width: 4.w*3,
                    ),
                    Expanded(
                      child: Text(
                        '搜索设备、空间、消息...',
                        style: TextStyle(
                            color: HhColors.gray9TextColor, fontSize: 14.sp*3),
                      ),
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    /*Image.asset(
                      "assets/images/common/ic_record.png",
                      width: 44.w,
                      height: 44.w,
                      fit: BoxFit.fill,
                    ),*/
                    SizedBox(
                      width: 40.w,
                    )
                  ],
                ),
              ),
            ),
            ///天气
            InkWell(
              onTap: (){
                Get.to(WebViewPage(title: '天气', url: 'https://www.qweather.com/weather/qingdao-101120201.html',));
                // Get.to(WebViewPage(title: '天气', url: 'https://www.qweather.com/',));
              },
              child: Container(
                margin: EdgeInsets.only(top: 17.w*3),
                height: 36.w*3,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(logic.text.value.contains('未获取')?10.w*3:16.w*3, 0, 0, 10.w),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            logic.text.value.contains('未获取')?const SizedBox():SizedBox(
                              width: 22.w*3,
                              height: 22.w*3,
                              child: Stack(
                                children: [
                                  SizedBox(
                                      width: 22.w*3,
                                      height: 22.w*3,
                                      child: WebViewWidget(controller: logic.webController,)),
                                  logic.iconStatus.value?const SizedBox():Image.asset(
                                    "assets/images/common/icon_weather.png",
                                    width: 22.w*3,
                                    height: 22.w*3,
                                    fit: BoxFit.fill,
                                  ),
                                  Container(
                                    color: HhColors.trans,
                                      width: 22.w*3,
                                      height: 22.w*3),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: logic.text.value.contains('未获取')?2.w*3:6.w*3,
                            ),
                            Text(
                              logic.text.value.contains('未获取')?logic.text.value:"${logic.dateStr.value} ${logic.cityStr.value}",
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 14.sp*3),
                            ),
                            SizedBox(
                              width: 6.w*3,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 6.w),
                              child: Image.asset(
                                "assets/images/common/back_role.png",
                                width: 14.w*3,
                                height: 14.w*3,
                                fit: BoxFit.fill,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.2,
                          onPressed: (){
                            //TODO Socket测试
                            homeLogic.index.value = 2;
                            // Get.to(()=>SocketPage(),binding: SocketBinding());
                          },
                            child: Container(
                              width: 40.w*3,
                              height: 36.w*3,
                              margin: EdgeInsets.only(bottom: 10.w),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "assets/images/common/icon_message_main.png",
                                      width: 24.w*3,
                                      height: 24.w*3,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  messageLogic.noticeCountInt.value+messageLogic.warnCountInt.value==0?const SizedBox():Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: HhColors.mainRedColor,
                                        borderRadius: BorderRadius.all(Radius.circular(10.w*3))
                                      ),
                                      width: 15.w*3 + ((parseCount(messageLogic.noticeCountInt.value+messageLogic.warnCountInt.value>99?"99+":"${messageLogic.noticeCountInt.value+messageLogic.warnCountInt.value}")) * (3.w*3)),
                                      height: 15.w*3,
                                      child: Center(child: Text(messageLogic.noticeCountInt.value+messageLogic.warnCountInt.value>99?"99+":"${messageLogic.noticeCountInt.value+messageLogic.warnCountInt.value}",style: TextStyle(color: HhColors.whiteColor,fontSize: 10.sp*3),)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          BouncingWidget(
                            duration: const Duration(milliseconds: 100),
                            scaleFactor: 1.2,
                            onPressed: (){
                              Get.to(()=>DeviceAddPage(snCode: '',),binding: DeviceAddBinding());
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10.w*3, 0, 14.w*3, 10.w),
                              child: Image.asset(
                                "assets/images/common/ic_add.png",
                                width: 24.w*3,
                                height: 24.w*3,
                                fit: BoxFit.fill,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ///空间列表滚动
            SizedBox(
              height: 36.w*3,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: logic.spaceListStatus.value?Container(
                      margin: EdgeInsets.fromLTRB(10.w*3, 0, 140.w*3, 10.w),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: buildSpaces(),
                        ),
                      ),
                    ):const SizedBox(),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.2,
                          onPressed: () {
                            logic.pageMapStatus.value = true;
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10.w),
                            padding:
                                EdgeInsets.fromLTRB(11.w*3, 4.w*3, 11.w*3, 4.w*3),
                            decoration: BoxDecoration(
                              color: HhColors.whiteColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.w*3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/images/common/icon_map.png",
                                  width: 16.w*3,
                                  height: 16.w*3,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(
                                  width: 2.w*3,
                                ),
                                Text(
                                  "地图",
                                  style: TextStyle(
                                      color: HhColors.mainBlueColor,
                                      fontSize: 14.sp*3),
                                ),
                              ],
                            ),
                          ),
                        ),
                        BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.2,
                          onPressed: (){
                            logic.tipController.start();
                          },
                          child: OverlayTooltipItem(
                            displayIndex: 0,
                            tooltip: (controller) {
                              return BouncingWidget(
                                duration: const Duration(milliseconds: 100),
                                scaleFactor: 1.2,
                                onPressed: (){
                                  logic.tipController.dismiss();
                                  Get.to(() => SpaceManagePage(),
                                      binding: SpaceManageBinding());
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0,8.w*3,14.w*3,0),
                                  padding: EdgeInsets.fromLTRB(22.w*3, 25.w*3, 15.w*3, 24.w*3),
                                  decoration: BoxDecoration(
                                    color: HhColors.whiteColor,
                                    borderRadius: BorderRadius.circular(16.w*3)
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('管理空间', style: TextStyle(color: HhColors.textBlackColor,fontSize: 15.sp*3,fontWeight: FontWeight.w200),),
                                      SizedBox(width: 20.w*3,),
                                      Image.asset(
                                        "assets/images/common/ic_setting.png",
                                        width: 18.w*3,
                                        height: 18.w*3,
                                        fit: BoxFit.fill,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(16.w*3, 0, 18.w*3, 10.w),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                color: HhColors.trans,
                                borderRadius: BorderRadius.all(Radius.circular(20.w))
                              ),
                              child: Image.asset(
                                "assets/images/common/icon_menu.png",
                                width: 24.w*3,
                                height: 24.w*3,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ///GridView
            Expanded(
              child: EasyRefresh(
                onRefresh: (){
                  logic.pageNum = 1;
                  logic.getDeviceList(logic.pageNum,true);

                  DateTime dateTime = DateTime.now();
                  logic.dateStr.value = CommonUtils().parseLongTimeWithLength("${dateTime.millisecondsSinceEpoch}",16);
                  logic.getWeather();
                },
                onLoad: (){
                  logic.pageNum++;
                  logic.getDeviceList(logic.pageNum,false);
                },
                controller: logic.easyController,
                canLoadAfterNoMore: false,
                canRefreshAfterNoMore: true,
                child: PagedGridView<int, dynamic>(
                    pagingController: logic.pagingController,
                    padding: EdgeInsets.zero,
                    builderDelegate: PagedChildBuilderDelegate<dynamic>(
                      firstPageProgressIndicatorBuilder: (c){
                        return Container();
                      }, // 关闭首次加载动画
                      newPageProgressIndicatorBuilder:  (c){
                        return Container();
                      },   // 关闭新页加载动画
                      itemBuilder: (context, item, index) =>
                          gridItemView(context, item, index),
                      noItemsFoundIndicatorBuilder:  (context) =>
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              BouncingWidget(
                                duration: const Duration(milliseconds: 100),
                                scaleFactor: 1.2,
                                onPressed: (){
                                  Get.to(()=>DeviceAddPage(snCode: '',),binding: DeviceAddBinding());
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(14.w*3, 10.w*3, 14.w*3, 0),
                                  padding: EdgeInsets.fromLTRB(14.w*3, 13.w*3, 9.w*3, 14.w*3),
                                  width: 1.sw,
                                  decoration: BoxDecoration(
                                    color: HhColors.whiteColor,
                                    borderRadius: BorderRadius.circular(8.w*3),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/common/ic_camera.png",
                                        width: 48.w*3,
                                        height: 48.w*3,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(width: 11.w*3,),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('添加新设备',style: TextStyle(color: HhColors.textBlackColor,fontSize: 16.sp*3,fontWeight: FontWeight.bold),),
                                            SizedBox(height: 6.w*3,),
                                            Text('按步骤将设备添加到APP',style: TextStyle(color: HhColors.gray9TextColor,fontSize: 14.sp*3),),
                                          ],
                                        ),
                                      ),
                                      Image.asset(
                                        "assets/images/common/icon_go.png",
                                        width: 15.w*3,
                                        height: 14.w*3,
                                        fit: BoxFit.fill,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, //横轴n个子widget
                        childAspectRatio: 1.35 //宽高比
                    )),
              ),
            ),
            buttonView()
          ],
        ),

      ],
    ):const SizedBox();
  }

  ///设备列表视图-网格列表itemView
  gridItemView(BuildContext context, dynamic item, int index) {
    return Container(
      height: 123.w*3,
      clipBehavior: Clip.hardEdge, //裁剪
      margin: EdgeInsets.fromLTRB(index%2==0?14.w*3:11.w*3, 15.w*3, index%2==0?0:14.w*3, 0),
      decoration: BoxDecoration(
          color: HhColors.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(16.w*3))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 90.w*3,
            width: 0.5.sw,
            child: Stack(
              children: [
                InkWell(
                  onTap: (){
                    CommonUtils().parseRouteDetail(item);
                  },
                  child: Container(
                    height: 90.w*3,
                    width: 0.5.sw,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top:Radius.circular(16.w*3))),
                    child: item['status']==1?logic.parseCacheImageView('${item['deviceNo']}',item):Image.asset(
                      "assets/images/common/test_video.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                /*item['status']==1?const SizedBox():Container(
                  height: 90.w*3,
                  width: 0.5.sw,
                  decoration: BoxDecoration(
                      color: HhColors.grayEDBackColor.withAlpha(160),
                      borderRadius: BorderRadius.vertical(top:Radius.circular(16.w*3))),
                ),*/
                item['status']==1?const SizedBox():Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: (){
                      CommonUtils().parseRouteDetail(item);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/common/icon_wifi.png",
                          width: 30.w*3,
                          height: 30.w*3,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(height: 6.w*3,),
                        Text('设备离线',style: TextStyle(color: HhColors.whiteColor,fontSize: 14.sp*3),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: (){
              showEditDeviceDialog(item);
            },
            child: Container(
              height: 33.w*3,
              padding: EdgeInsets.fromLTRB(12.w*3, 5.w*3, 15.w*3, 7.w*3),
              color: HhColors.whiteColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      CommonUtils().parseNameCount("${item['name']}", 4),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: HhColors.textBlackColor,
                          fontSize: 15.sp*3,),
                    ),
                  ),
                  SizedBox(width: 9.w*3,),
                  CommonData.personal?(item["shareMark"]==1 || item["shareMark"]==2 ?Container(
                    padding: EdgeInsets.fromLTRB(8.w*3, 3.w*3, 8.w*3, 2.w*3),
                    decoration: BoxDecoration(
                      color: HhColors.grayEFBackColor,
                      borderRadius: BorderRadius.all(Radius.circular(4.w*3))
                    ),
                    child: Text(
                      item["shareMark"]==1?"分享中":item["shareMark"]==2?"好友分享":'',
                      style: TextStyle(color: item["shareMark"]==1?HhColors.mainBlueColor:HhColors.textColor, fontSize: 12.sp*3),
                    ),
                  ):const SizedBox()):const SizedBox(),
                  Container(padding: EdgeInsets.only(left:8.w*3),
                      child: Text(':',style: TextStyle(color: HhColors.gray9TextColor,fontSize: 15.sp*3,fontWeight: FontWeight.bold),)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  ///我的空间视图-添加空间按钮
  buttonView() {
    return
      BouncingWidget(
        duration: const Duration(milliseconds: 100),
        scaleFactor: 1.2,
      child: Container(
        width: 1.sw,
        height: 48.w*3,
        margin: EdgeInsets.fromLTRB(36.w*3, 24.w*3, 36.w*3, 25.w*3),
        decoration: BoxDecoration(
            color: HhColors.mainBlueColor,
            borderRadius: BorderRadius.all(Radius.circular(24.w*3))),
        child: Center(
          child: Text(
            "添加新空间",
            textAlign: TextAlign.center,
            style: TextStyle(color: HhColors.whiteColor, fontSize: 16.sp*3),
          ),
        ),
      ),
      onPressed: () {
        Get.to(()=>SpacePage(),binding: SpaceBinding());
        // Get.to(()=>MqttPage(),binding: MqttBinding());///MQTT测试
      },
    );
  }

  ///首次进入页面
  firstPage(){
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: CommonUtils().gradientColors()),
          ),
        ),
        Column(
          children: [
            ///位置
            Container(
              margin: EdgeInsets.fromLTRB(9.w*3, 54.w*3, 0, 10.w),
              height: 36.w*3,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 24.w*3,
                          height: 24.w*3,
                          child: Stack(
                            children: [
                              Image.asset(
                                "assets/images/common/icon_loc.png",
                                width: 24.w*3,
                                height: 24.w*3,
                                fit: BoxFit.fill,
                              ),
                              Container(
                                  color: HhColors.trans,
                                  width: 24.w*3,
                                  height: 24.w*3),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Expanded(
                          child: Text(
                            logic.locText.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: HhColors.blackTextColor,
                                fontSize: 14.sp*3,fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 210.w*3,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.2,
                          onPressed: (){
                            //TODO Socket测试
                            homeLogic.index.value = 2;
                            // Get.to(()=>SocketPage(),binding: SocketBinding());
                          },
                          child: Container(
                            width: 40.w*3,
                            height: 36.w*3,
                            margin: EdgeInsets.only(bottom: 10.w),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/images/common/icon_message_main.png",
                                    width: 24.w*3,
                                    height: 24.w*3,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                messageLogic.noticeCountInt.value+messageLogic.warnCountInt.value==0?const SizedBox():Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: HhColors.mainRedColor,
                                        borderRadius: BorderRadius.all(Radius.circular(10.w*3))
                                    ),
                                    width: 15.w*3 + ((parseCount(messageLogic.noticeCountInt.value+messageLogic.warnCountInt.value>99?"99+":"${messageLogic.noticeCountInt.value+messageLogic.warnCountInt.value}")) * (3.w*3)),
                                    height: 15.w*3,
                                    child: Center(child: Text(messageLogic.noticeCountInt.value+messageLogic.warnCountInt.value>99?"99+":"${messageLogic.noticeCountInt.value+messageLogic.warnCountInt.value}",style: TextStyle(color: HhColors.whiteColor,fontSize: 10.sp*3),)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.2,
                          onPressed: (){
                            Get.to(()=>DeviceAddPage(snCode: '',),binding: DeviceAddBinding());
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(15.w*3, 0, 14.w*3, 10.w),
                            child: Image.asset(
                              "assets/images/common/ic_add.png",
                              width: 24.w*3,
                              height: 24.w*3,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(14.w*3, 21.w*3, 14.w*3, 0),
              width: 1.sw,
              height: 0.53.sw,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.w*3)
              ),
              child: Stack(
                children: [
                  Image.asset(
                    "assets/images/common/icon_default.png",
                    width: 1.sw,
                    height: 0.53.sw,
                    fit: BoxFit.fill,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: () async {
                        logic.secondStatus.value = true;
                        /// 初次进入设置
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setBool(SPKeys().second, true);
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(18.w*3, 3.w*3, 18.w*3, 4.w*3),
                        decoration: BoxDecoration(
                          color: HhColors.transBlack,
                          borderRadius: BorderRadius.circular(12.w*3)
                        ),
                        child: Text('进入默认空间',style: TextStyle(color: HhColors.whiteColor,fontSize: 13.sp*3),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BouncingWidget(
              duration: const Duration(milliseconds: 100),
              scaleFactor: 1.2,
              onPressed: (){
                Get.to(()=>DeviceAddPage(snCode: '',),binding: DeviceAddBinding());
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(14.w*3, 10.w*3, 14.w*3, 0),
                padding: EdgeInsets.fromLTRB(14.w*3, 13.w*3, 9.w*3, 14.w*3),
                width: 1.sw,
                decoration: BoxDecoration(
                  color: HhColors.whiteColor,
                  borderRadius: BorderRadius.circular(8.w*3),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/common/ic_camera.png",
                      width: 48.w*3,
                      height: 48.w*3,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(width: 11.w*3,),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('添加新设备',style: TextStyle(color: HhColors.textBlackColor,fontSize: 16.sp*3,fontWeight: FontWeight.bold),),
                          SizedBox(height: 6.w*3,),
                          Text('按步骤将设备添加到APP',style: TextStyle(color: HhColors.gray9TextColor,fontSize: 14.sp*3),),
                        ],
                      ),
                    ),
                    Image.asset(
                      "assets/images/common/icon_go.png",
                      width: 15.w*3,
                      height: 14.w*3,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

      ],
    );
  }

  buildSpaces() {
    List<Widget> list = [];
    for(int i = 0;i < logic.spaceList.length;i++){
      dynamic model = logic.spaceList[i];
      list.add(
          InkWell(
            onTap: (){
              logic.spaceListIndex.value = i;
              logic.pageNum = 1;
              logic.getDeviceList(1,true);
            },
            child: Container(
              margin: EdgeInsets.only(left: 10.w*3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    CommonUtils().parseNameCount("${model['name']}", 5),
                    style: TextStyle(
                        color: logic.spaceListIndex.value == i?HhColors.blackTextColor:HhColors.gray9TextColor,
                        fontSize: logic.spaceListIndex.value == i?18.sp*3:16.sp*3,
                        fontWeight: logic.spaceListIndex.value == i?FontWeight.bold:FontWeight.w500),
                  ),
                  SizedBox(
                    height: 2.w,
                  ),
                  logic.spaceListIndex.value == i?Container(
                    height: 5.w,
                    width: 20.w,
                    decoration: BoxDecoration(
                      color: HhColors.blackTextColor,
                      border:
                      Border.all(color: HhColors.blackTextColor),
                      borderRadius:
                      BorderRadius.all(Radius.circular(2.w)),
                    ),
                  ):const SizedBox(),
                ],
              ),
            ),
          )
      );
    }
    
    return list;
  }

  void showEditDeviceDialog(item) {
    showCupertinoDialog(context: logic.context, builder: (context) => Center(
      child: Container(
        width: 1.sw,
        height: 70.w*3,
        margin: EdgeInsets.fromLTRB(14.w*3, 0, 14.w*3, 0),
        // padding: EdgeInsets.fromLTRB(30.w, 35.w, 45.w, 25.w),
        decoration: BoxDecoration(
            color: HhColors.whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
        child: Row(
          children: [
            CommonData.personal?Expanded(
              child: BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 1.2,
                onPressed: (){
                  if(item["shareMark"]==2){
                    return;
                  }
                  Get.back();
                  DateTime date = DateTime.now();
                  String time = date.toIso8601String().substring(0,19).replaceAll("T", " ");
                  Get.to(()=>SharePage(),binding: ShareBinding(),arguments: {
                    "shareType": "2",
                    "expirationTime": time,
                    "appShareDetailSaveReqVOList": [
                      {
                        "spaceId": "${item["spaceId"]}",
                        "spaceName": "${item["spaceName"]}",
                        "deviceId": "${item["id"]}",
                        "deviceName": "${item["name"]}"
                      }
                    ]
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      item["shareMark"]==2?"assets/images/common/icon_edit_share_no.png":"assets/images/common/icon_edit_share.png",
                      width: 24*3.w,
                      height: 24*3.w,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(height: 4.w*3),
                    Text('分享',style: TextStyle(color: item["shareMark"]==2?HhColors.grayCCTextColor:HhColors.textBlackColor,fontSize: 14.sp*3,
                      decoration: TextDecoration.none,fontWeight: FontWeight.w500),),
                  ],
                ),
              ),
            ):const SizedBox(),
            CommonData.personal?SizedBox(width: 50.w,):const SizedBox(),
            Expanded(
              child: BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 1.2,
                onPressed: () {
                  Get.back();
                  Get.to(()=>DeviceAddPage(snCode: '${item['deviceNo']}',),binding: DeviceAddBinding(),arguments: item);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/common/icon_edit_edit.png",
                      width: 24.w*3,
                      height: 24.w*3,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(height: 10.w,),
                    Text('修改',style: TextStyle(color: HhColors.textBlackColor,fontSize: 14.sp*3,
                      decoration: TextDecoration.none,fontWeight: FontWeight.w500),),
                  ],
                ),
              ),
            ),
            SizedBox(width: 50.w,),
            Expanded(
              child: BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 1.2,
                onPressed: () {
                  Get.back();
                  CommonUtils().showDeleteDialog(context, item["shareMark"]==2?'确定要删除“${item['name']}”?\n此设备是好友分享给你的设备':'确定要删除“${item['name']}”?\n删除设备后无法恢复', (){
                    Get.back();
                  }, (){
                    Get.back();
                    logic.deleteDevice(item);
                  }, (){
                    Get.back();
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/common/icon_edit_delete.png",
                      width: 24.w*3,
                      height: 24.w*3,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(height: 4.w*3,),
                    Text('删除',style: TextStyle(color: HhColors.mainRedColor,fontSize: 14.sp*3,
                      decoration: TextDecoration.none,fontWeight: FontWeight.w500),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),barrierDismissible: true);
  }

  parseCount(String s) {
    if(s.length>=3){
      return 3;
    }else if(s.length == 2){
      return 2;
    }else{
      return 1;
    }
  }
}
