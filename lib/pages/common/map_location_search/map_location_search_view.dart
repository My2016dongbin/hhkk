import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/home/cell/HhTap.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'map_location_search_controller.dart';

class MapLocationSearchPage extends StatelessWidget {
  final logic = Get.find<MapLocationSearchController>();

  MapLocationSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 在这里设置状态栏字体为深色
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 状态栏背景色
      statusBarBrightness: Brightness.dark, // 状态栏字体亮度
      statusBarIconBrightness: Brightness.dark, // 状态栏图标亮度
    ));
    return Scaffold(
      backgroundColor: HhColors.backColor,
      body: Obx(
        () => Container(
          height: 1.sh,
          width: 1.sw,
          padding: EdgeInsets.zero,
          child: logic.testStatus.value ? modelPage() : const SizedBox(),
        ),
      ),
    );
  }

  modelPage() {
    return Stack(
      children: [
        ///背景-渐变色
        Image.asset(
          "assets/images/common/main_background.png",
          width: 1.sw,
          height: 1.sh,
          fit: BoxFit.fill,
        ),

        ///header
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            height: 42.w*3,
            margin: EdgeInsets.only(top: 42.w*3),
            color: HhColors.trans,
            child: Stack(
              children: [
                ///搜索
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 42.w*3,
                    width: 1.sw,
                    margin: EdgeInsets.fromLTRB(10.w*3, 0, 10.w*3, 0),
                    padding: EdgeInsets.fromLTRB(0, 0, 12.w*3, 0),
                    decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius: BorderRadius.circular(12.w*3)
                    ),
                    child: Row(
                      children: [
                        ///返回
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(12.w*3, 7.w*3, 15.w*3, 7.w*3),
                            color: HhColors.trans,
                            child: Image.asset(
                              "assets/images/common/icon_back_left.png",
                              width: 9.w*3,
                              height: 16.w*3,
                              fit: BoxFit.fill,
                            ),
                          ),
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
                              logic.pageNum = 1;
                              logic.fetchPage();
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              hintText: '搜索设备名称',
                              hintStyle: TextStyle(
                                  color: HhColors.gray9TextColor, fontSize: 14.sp*3),
                            ),
                            style:
                            TextStyle(color: HhColors.textColor, fontSize: 14.sp*3),
                          ),
                        ),
                        Container(
                          width: 3.w,
                          margin: EdgeInsets.fromLTRB(10.w*3, 5.w*3, 0, 5.w*3),
                          color: HhColors.lineColorMain,
                        ),
                        //搜索
                        InkWell(
                          onTap: () {
                            logic.pageNum = 1;
                            logic.fetchPage();
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10.w*3, 5.w*3, 0, 5.w*3),
                            color: HhColors.trans,
                            child: Text("搜索",style: TextStyle(color: HhColors.mainBlueColor,fontSize: 14.sp*3),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        ///高德地图
        Container(
          height: 1.0.sh - 95.w*3,
          width: 1.sw,
          margin: EdgeInsets.only(top: 90.w*3),
          child: AMapWidget(
            apiKey: CommonData.aMapApiKey,
            privacyStatement: const AMapPrivacyStatement(
                hasContains: true, hasShow: true, hasAgree: true),
            onMapCreated: logic.onGDMapCreated,
            mapType: MapType.normal,
            tiltGesturesEnabled: true,
            buildingsEnabled: true,
            compassEnabled: true,
            scaleEnabled: true,
            markers: logic.aMapMarkers.toSet(),
            onTap: (LatLng latLng){
              FocusScope.of(Get.context!).requestFocus(FocusNode());
            },
            onPoiTouched: (poi){
              FocusScope.of(Get.context!).requestFocus(FocusNode());
            },
          ),
        ),

        ///按钮：列表&&位置
        Container(
          margin: EdgeInsets.only(left: 15.w*3,top: 104.w*3),
          child: Row(
            children: [
              HhTap(
                overlayColor: HhColors.trans,
                onTapUp: () async {
                  if(logic.deviceController.itemList == null || logic.deviceController.itemList!.isEmpty){
                    await logic.fetchPage();
                  }
                  deviceListDialog();
                },
                child: Container(
                  margin: EdgeInsets.only(right: 10.w*3),
                  padding: EdgeInsets.fromLTRB(14.w*3, 0, 14.w*3, 0),
                  decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.circular(8.w*3)
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 7.w*3),
                      Image.asset(
                        "assets/images/common/icon_map_list.png",
                        width: 24.w * 3,
                        height: 24.w * 3,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 1.w*3),
                      Text("列表",style: TextStyle(color: HhColors.blackTextColor,fontSize: 10.sp*3),),
                      SizedBox(height: 5.w*3),
                    ],
                  ),
                ),
              ),
              HhTap(
                overlayColor: HhColors.trans,
                onTapUp: () {
                  logic.updateMarker(location: true);
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(14.w*3, 0, 14.w*3, 0),
                  decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.circular(8.w*3)
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 7.w*3),
                      Image.asset(
                        "assets/images/common/icon_map_location.png",
                        width: 24.w * 3,
                        height: 24.w * 3,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 1.w*3),
                      Text("位置",style: TextStyle(color: HhColors.blackTextColor,fontSize: 10.sp*3),),
                      SizedBox(height: 5.w*3),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  ///设备列表弹窗
  void deviceListDialog() {
    showModalBottomSheet(context: Get.context!, builder: (a){
      return Container(
        width: 1.sw,
        height: 0.4.sh,
        decoration: BoxDecoration(
            color: HhColors.whiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(6.w*3))
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 12.w*3,),
            Row(
              children: [
                const Spacer(),
                HhTap(
                  onTapUp: (){
                    Get.back();
                  },
                  child: Container(
                      color: HhColors.trans,
                      padding: EdgeInsets.all(10.w*3),
                      child: Image.asset('assets/images/common/icon_up_x.png',width:12.w*3,height: 12.w*3,fit: BoxFit.fill,)
                  ),
                ),
                SizedBox(width: 15.w*3,),
              ],
            ),
            Expanded(
              child: EasyRefresh(
                onRefresh: (){
                  logic.pageNum = 1;
                  logic.fetchPage();
                },
                onLoad: (){
                  logic.pageNum++;
                  logic.fetchPage();
                },
                controller: logic.deviceEasyController,
                child: PagedListView<int, dynamic>(
                  padding: EdgeInsets.zero,
                  pagingController: logic.deviceController,
                  scrollController: logic.deviceScrollController,
                  builderDelegate: PagedChildBuilderDelegate<dynamic>(
                    noItemsFoundIndicatorBuilder: (context) => CommonUtils().noneWidget(image:'assets/images/common/icon_no_message_search.png',info: '暂无设备信息',mid: 10.w,top: 0.2.sw,
                      height: 0.24.sw,
                      width: 0.3.sw,),
                    firstPageProgressIndicatorBuilder: (context) => Container(),
                    newPageProgressIndicatorBuilder: (context) => Container(),
                    itemBuilder: deviceListItemBuilder,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    },isDismissible: true,enableDrag: false,isScrollControlled: true);
  }
  ///设备列表Item
  Widget deviceListItemBuilder(BuildContext context, item, int index) {
    return InkWell(
      onTap: () async {
        LatLng latLng = LatLng(double.parse("${item["latitude"]}"),double.parse("${item["longitude"]}"));
        logic.gdMapController.moveCamera(CameraUpdate.newLatLngZoom(latLng, 16));
        Get.back();
        logic.deviceDetailDialog(item);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15.w*3),
        child: Row(
          children: [
            SizedBox(width: 20.w*3,),
            SizedBox(width: 40.w*3,child: Text('${index+1}',style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3,fontWeight: FontWeight.w400),)),
            SizedBox(width: 125.w*3,child: Text(CommonUtils().parseNull('${item["name"]}', ""),textAlign:TextAlign.start,maxLines:1,overflow: TextOverflow.ellipsis,style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3,fontWeight: FontWeight.w400),)),
            Expanded(child: Text("${item["longitude"]},${item["latitude"]}",textAlign:TextAlign.start,maxLines:1,overflow: TextOverflow.ellipsis,style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3,fontWeight: FontWeight.w400),)),
            SizedBox(width: 15.w*3,),
          ],
        ),
      ),
    );
  }

}
