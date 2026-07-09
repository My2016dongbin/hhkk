import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/home/cell/HhTap.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';

import 'map_controller.dart';
import 'dart:io';

class MapPage extends StatelessWidget {
  final logic = Get.find<MapController>();

  MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    // 在这里设置状态栏字体为深色
    final overlayStyle = Platform.isAndroid
        ? const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          )
        : const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
          );
    SystemChrome.setSystemUIOverlayStyle(overlayStyle);
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
            height: Platform.isAndroid?42.w * 3:52.w*3,
            margin: EdgeInsets.only(top: Platform.isAndroid?42.w * 3:52.w*3),
            color: HhColors.trans,
            child: Stack(
              children: [
                Container(
                  width: 1.sw,
                  margin: EdgeInsets.only(right: 60.w*3),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ///全部
                        logic.searchMode.value
                            ? const SizedBox()
                            : Container(
                          margin: EdgeInsets.only(left: 15.w * 3),
                          child: HhTap(
                            overlayColor: HhColors.trans,
                            onTapUp: () async {
                              logic.tabIndex.value = 0;
                              logic.pageNum = 1;
                              logic.deviceCount.value = "-1";
                              await logic.fetchPage();
                            },
                            child: Container(
                              height: 40.w * 3,
                              width: 62.w * 3,
                              color: HhColors.trans,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '全部',
                                          style: TextStyle(
                                              color: logic.tabIndex.value == 0
                                                  ? HhColors.blackTextColor
                                                  : HhColors.gray9TextColor,
                                              fontSize: logic.tabIndex.value == 0
                                                  ? 18.sp * 3
                                                  : 14.sp * 3,
                                              fontWeight:
                                              logic.tabIndex.value == 0
                                                  ? FontWeight.w600
                                                  : FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 2.w * 3,
                                        ),
                                        logic.tabIndex.value == 0
                                            ? Container(
                                          height: 7.w,
                                          width: 30.w,
                                          decoration: BoxDecoration(
                                              color:
                                              HhColors.blackTextColor,
                                              borderRadius:
                                              BorderRadius.circular(
                                                  2.w * 3)),
                                        )
                                            : SizedBox(
                                          height: 2.w * 3,
                                          width: 12.w * 3,
                                        )
                                      ],
                                    ),
                                  ),
                                  logic.deviceCount.value == "-1" ||
                                      logic.tabIndex.value != 0
                                      ? const SizedBox()
                                      : Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      height: 16.w * 3,
                                      width: 32.w * 3,
                                      padding: EdgeInsets.fromLTRB(
                                          3.w * 3, 5.w, 3.w * 3, 0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: HhColors.mapBlueColors,
                                          borderRadius:
                                          BorderRadius.circular(
                                              8.w * 3)),
                                      child: Text(
                                        logic.deviceCount.value,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: HhColors.whiteColor,
                                          fontSize: 10.sp * 3,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),

                        ///火险因子
                        logic.searchMode.value
                            ? const SizedBox()
                            : HhTap(
                              overlayColor: HhColors.trans,
                              onTapUp: () async {
                                logic.tabIndex.value = 1;
                                logic.pageNum = 1;
                                logic.deviceCount.value = "-1";
                                await logic.fetchPage();
                              },
                              child: Container(
                                height: 40.w * 3,
                                width: 95.w * 3,
                                color: HhColors.trans,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '火险因子',
                                            style: TextStyle(
                                                color: logic.tabIndex.value == 1
                                                    ? HhColors.blackTextColor
                                                    : HhColors.gray9TextColor,
                                                fontSize: logic.tabIndex.value == 1
                                                    ? 18.sp * 3
                                                    : 14.sp * 3,
                                                fontWeight:
                                                logic.tabIndex.value == 1
                                                    ? FontWeight.w600
                                                    : FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 2.w * 3,
                                          ),
                                          logic.tabIndex.value == 1
                                              ? Container(
                                            height: 7.w,
                                            width: 30.w,
                                            decoration: BoxDecoration(
                                                color:
                                                HhColors.blackTextColor,
                                                borderRadius:
                                                BorderRadius.circular(
                                                    2.w * 3)),
                                          )
                                              : SizedBox(
                                            height: 2.w * 3,
                                            width: 12.w * 3,
                                          )
                                        ],
                                      ),
                                    ),
                                    logic.deviceCount.value == "-1" ||
                                        logic.tabIndex.value != 1
                                        ? const SizedBox()
                                        : Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        height: 16.w * 3,
                                        width: 32.w * 3,
                                        padding: EdgeInsets.fromLTRB(
                                            3.w * 3, 5.w, 3.w * 3, 0),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: HhColors.mapBlueColors,
                                            borderRadius:
                                            BorderRadius.circular(
                                                8.w * 3)),
                                        child: Text(
                                          logic.deviceCount.value,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: HhColors.whiteColor,
                                            fontSize: 10.sp * 3,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                        ///一期卡口
                        logic.searchMode.value
                            ? const SizedBox()
                            : HhTap(
                              overlayColor: HhColors.trans,
                              onTapUp: () async {
                                logic.tabIndex.value = 2;
                                logic.pageNum = 1;
                                logic.deviceCount.value = "-1";
                                await logic.fetchPage();
                              },
                              child: Container(
                                height: 40.w * 3,
                                width: 95.w * 3,
                                color: HhColors.trans,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '一期卡口',
                                            style: TextStyle(
                                                color: logic.tabIndex.value == 2
                                                    ? HhColors.blackTextColor
                                                    : HhColors.gray9TextColor,
                                                fontSize: logic.tabIndex.value == 2
                                                    ? 18.sp * 3
                                                    : 14.sp * 3,
                                                fontWeight:
                                                logic.tabIndex.value == 2
                                                    ? FontWeight.w600
                                                    : FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 2.w * 3,
                                          ),
                                          logic.tabIndex.value == 2
                                              ? Container(
                                            height: 7.w,
                                            width: 30.w,
                                            decoration: BoxDecoration(
                                                color:
                                                HhColors.blackTextColor,
                                                borderRadius:
                                                BorderRadius.circular(
                                                    2.w * 3)),
                                          )
                                              : SizedBox(
                                            height: 2.w * 3,
                                            width: 12.w * 3,
                                          )
                                        ],
                                      ),
                                    ),
                                    logic.deviceCount.value == "-1" ||
                                        logic.tabIndex.value != 2
                                        ? const SizedBox()
                                        : Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        height: 16.w * 3,
                                        width: 32.w * 3,
                                        padding: EdgeInsets.fromLTRB(
                                            3.w * 3, 5.w, 3.w * 3, 0),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: HhColors.mapBlueColors,
                                            borderRadius:
                                            BorderRadius.circular(
                                                8.w * 3)),
                                        child: Text(
                                          logic.deviceCount.value,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: HhColors.whiteColor,
                                            fontSize: 10.sp * 3,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                        ///二期卡口
                        logic.searchMode.value
                            ? const SizedBox()
                            : HhTap(
                              overlayColor: HhColors.trans,
                              onTapUp: () async {
                                logic.tabIndex.value = 3;
                                logic.pageNum = 1;
                                logic.deviceCount.value = "-1";
                                await logic.fetchPage();
                              },
                              child: Container(
                                height: 40.w * 3,
                                width: 95.w * 3,
                                color: HhColors.trans,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '二期卡口',
                                            style: TextStyle(
                                                color: logic.tabIndex.value == 3
                                                    ? HhColors.blackTextColor
                                                    : HhColors.gray9TextColor,
                                                fontSize: logic.tabIndex.value == 3
                                                    ? 18.sp * 3
                                                    : 14.sp * 3,
                                                fontWeight:
                                                logic.tabIndex.value == 3
                                                    ? FontWeight.w600
                                                    : FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 2.w * 3,
                                          ),
                                          logic.tabIndex.value == 3
                                              ? Container(
                                            height: 7.w,
                                            width: 30.w,
                                            decoration: BoxDecoration(
                                                color:
                                                HhColors.blackTextColor,
                                                borderRadius:
                                                BorderRadius.circular(
                                                    2.w * 3)),
                                          )
                                              : SizedBox(
                                            height: 2.w * 3,
                                            width: 12.w * 3,
                                          )
                                        ],
                                      ),
                                    ),
                                    logic.deviceCount.value == "-1" ||
                                        logic.tabIndex.value != 3
                                        ? const SizedBox()
                                        : Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        height: 16.w * 3,
                                        width: 32.w * 3,
                                        padding: EdgeInsets.fromLTRB(
                                            3.w * 3, 5.w, 3.w * 3, 0),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: HhColors.mapBlueColors,
                                            borderRadius:
                                            BorderRadius.circular(
                                                8.w * 3)),
                                        child: Text(
                                          logic.deviceCount.value,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: HhColors.whiteColor,
                                            fontSize: 10.sp * 3,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                        ///地表火
                        logic.searchMode.value
                            ? const SizedBox()
                            : HhTap(
                              overlayColor: HhColors.trans,
                              onTapUp: () async {
                                logic.tabIndex.value = 4;
                                logic.pageNum = 1;
                                logic.deviceCount.value = "-1";
                                await logic.fetchPage();
                              },
                              child: Container(
                                height: 40.w * 3,
                                width: 80.w * 3,
                                color: HhColors.trans,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '地表火',
                                            style: TextStyle(
                                                color: logic.tabIndex.value == 4
                                                    ? HhColors.blackTextColor
                                                    : HhColors.gray9TextColor,
                                                fontSize: logic.tabIndex.value == 4
                                                    ? 18.sp * 3
                                                    : 14.sp * 3,
                                                fontWeight:
                                                logic.tabIndex.value == 4
                                                    ? FontWeight.w600
                                                    : FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 2.w * 3,
                                          ),
                                          logic.tabIndex.value == 4
                                              ? Container(
                                            height: 7.w,
                                            width: 30.w,
                                            decoration: BoxDecoration(
                                                color:
                                                HhColors.blackTextColor,
                                                borderRadius:
                                                BorderRadius.circular(
                                                    2.w * 3)),
                                          )
                                              : SizedBox(
                                            height: 2.w * 3,
                                            width: 12.w * 3,
                                          )
                                        ],
                                      ),
                                    ),
                                    logic.deviceCount.value == "-1" ||
                                        logic.tabIndex.value != 4
                                        ? const SizedBox()
                                        : Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        height: 16.w * 3,
                                        width: 32.w * 3,
                                        padding: EdgeInsets.fromLTRB(
                                            3.w * 3, 5.w, 3.w * 3, 0),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: HhColors.mapBlueColors,
                                            borderRadius:
                                            BorderRadius.circular(
                                                8.w * 3)),
                                        child: Text(
                                          logic.deviceCount.value,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: HhColors.whiteColor,
                                            fontSize: 10.sp * 3,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),

                ///搜索
                logic.searchMode.value
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.topRight,
                        child: HhTap(
                          overlayColor: HhColors.trans,
                          onTapUp: () {
                            logic.searchMode.value = true;
                            logic.tabIndex.value = 0;
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              logic.searchFocusNode.requestFocus();
                            });
                          },
                          child: Container(
                            color: HhColors.trans,
                            padding:
                                EdgeInsets.fromLTRB(15.w * 3, 0, 15.w * 3, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/images/common/icon_scan_add.png",
                                  width: 22.w * 3,
                                  height: 22.w * 3,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(height: 1.w * 3),
                                Text(
                                  "搜索",
                                  style: TextStyle(
                                      color: HhColors.blackTextColor,
                                      fontSize: 10.sp * 3),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                logic.searchMode.value
                    ? Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 42.w * 3,
                          width: 1.sw,
                          margin: EdgeInsets.fromLTRB(10.w * 3, 0, 10.w * 3, 0),
                          padding: EdgeInsets.fromLTRB(0, 0, 12.w * 3, 0),
                          child: Row(
                            children: [
                              ///返回
                              InkWell(
                                onTap: () {
                                  logic.searchMode.value = false;
                                  logic.tabIndex.value = 0;
                                  logic.pageNum = 1;
                                  logic.hideSearchResult(clearText: true);
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  logic.fetchPage();
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(
                                      10.w * 3, 9.w * 3, 10.w * 3, 9.w * 3),
                                  color: HhColors.trans,
                                  child: Image.asset(
                                    "assets/images/common/map_back.png",
                                    width: 25.w * 3,
                                    height: 25.w * 3,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: HhColors.whiteColor,
                                      borderRadius: BorderRadius.circular(20.w * 3)),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 12.w * 3),
                                      Image.asset(
                                        "assets/images/common/map_search.png",
                                        width: 20.w * 3,
                                        height: 20.w * 3,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(width: 5.w * 3),
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.left,
                                          maxLines: 1,
                                          cursorColor: HhColors.titleColor_99,
                                          focusNode: logic.searchFocusNode,
                                          controller: logic.searchController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.search,
                                          onChanged: (s) {
                                            logic.onSearchChanged(s);
                                          },
                                          onSubmitted: (s) {
                                            logic.pageNum = 1;
                                            logic.fetchPage();
                                          },
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            border: const OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                            hintText: '搜索设备名称',
                                            hintStyle: TextStyle(
                                                color: HhColors.gray9TextColor,
                                                fontSize: 14.sp * 3),
                                          ),
                                          style: TextStyle(
                                              color: HhColors.textColor,
                                              fontSize: 14.sp * 3),
                                        ),
                                      ),
                                      SizedBox(width: 10.w * 3),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 5.w * 3),
                              ///取消
                              InkWell(
                                onTap: () {
                                  logic.searchMode.value = false;
                                  logic.tabIndex.value = 0;
                                  logic.pageNum = 1;
                                  logic.hideSearchResult(clearText: true);
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  logic.fetchPage();
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(
                                      10.w * 3, 5.w * 3, 0, 5.w * 3),
                                  color: HhColors.trans,
                                  child: Text(
                                    "取消",
                                    style: TextStyle(
                                        color: HhColors.gray9TextColor,
                                        fontSize: 14.sp * 3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),

        ///高德地图
        Container(
          height: 1.0.sh - 95.w * 3,
          width: 1.sw,
          margin: EdgeInsets.only(top: Platform.isAndroid?90.w * 3:100.w * 3),
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
            onTap: (LatLng latLng) {
              FocusScope.of(Get.context!).requestFocus(FocusNode());
              logic.hideSearchResult();
            },
            onPoiTouched: (poi) {
              FocusScope.of(Get.context!).requestFocus(FocusNode());
              logic.hideSearchResult();
            },
          ),
        ),

        ///按钮：列表&&位置
        Container(
          margin: EdgeInsets.only(left: 15.w * 3, top: Platform.isAndroid?104.w * 3:114.w * 3),
          child: Row(
            children: [
              HhTap(
                overlayColor: HhColors.trans,
                onTapUp: () async {
                  if (logic.deviceController.itemList == null ||
                      logic.deviceController.itemList!.isEmpty) {
                    await logic.fetchPage();
                  }
                  deviceListDialog();
                },
                child: Container(
                  margin: EdgeInsets.only(right: 10.w * 3),
                  padding: EdgeInsets.fromLTRB(14.w * 3, 0, 14.w * 3, 0),
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.circular(8.w * 3)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 7.w * 3),
                      Image.asset(
                        "assets/images/common/icon_map_list.png",
                        width: 24.w * 3,
                        height: 24.w * 3,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 1.w * 3),
                      Text(
                        "列表",
                        style: TextStyle(
                            color: HhColors.blackTextColor,
                            fontSize: 10.sp * 3),
                      ),
                      SizedBox(height: 5.w * 3),
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
                  padding: EdgeInsets.fromLTRB(14.w * 3, 0, 14.w * 3, 0),
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.circular(8.w * 3)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 7.w * 3),
                      Image.asset(
                        "assets/images/common/icon_map_location.png",
                        width: 24.w * 3,
                        height: 24.w * 3,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 1.w * 3),
                      Text(
                        "位置",
                        style: TextStyle(
                            color: HhColors.blackTextColor,
                            fontSize: 10.sp * 3),
                      ),
                      SizedBox(height: 5.w * 3),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),


        ///搜索结果
        logic.searchMode.value && logic.showSearchResult.value
            ? Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 1.sw,
            constraints: BoxConstraints(maxHeight: 0.4.sh),
            margin: EdgeInsets.fromLTRB(14.w * 3, Platform.isAndroid?100.w * 3:110.w * 3, 14.w * 3, 0),
            decoration: BoxDecoration(
              color: HhColors.whiteColor,
              borderRadius: BorderRadius.circular(12.w * 3),
              boxShadow: [
                BoxShadow(
                  color: HhColors.blackColor.withOpacity(0.08),
                  blurRadius: 12.w * 3,
                  offset: Offset(0, 4.w * 3),
                )
              ],
            ),
            child: logic.searchResultList.isEmpty
                ? (logic.searchLoading.value
                ? SizedBox(
              height: 80.w * 3,
              child: Center(
                child: SizedBox(
                  width: 18.w * 3,
                  height: 18.w * 3,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.w,
                    color: HhColors.mainBlueColor,
                  ),
                ),
              ),
            )
                : SizedBox(
              height: 80.w * 3,
              child: Center(
                child: Text(
                  "暂无设备信息",
                  style: TextStyle(
                      color: HhColors.gray9TextColor,
                      fontSize: 14.sp * 3),
                ),
              ),
            ))
                : ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: logic.searchResultList.length,
              separatorBuilder: (context, index) {
                return CommonUtils.line(
                    margin: EdgeInsets.only(
                        left: 14.w * 3, right: 14.w * 3));
              },
              itemBuilder: (context, index) {
                dynamic item = logic.searchResultList[index];
                return HhTap(
                  overlayColor: HhColors.trans,
                  onTapUp: () {
                    logic.onTapSearchItem(item);
                  },
                  child: Container(
                    height: 54.w * 3,
                    padding: EdgeInsets.fromLTRB(
                        14.w * 3, 0, 14.w * 3, 0),
                    child: Row(
                      children: [
                        SizedBox(width: 5.w * 3),
                        Image.asset(
                          CommonUtils().parseMapSearchIcon(item),
                          height: 18.w * 3,
                          width: 18.w * 3,
                        ),
                        SizedBox(width: 10.w * 3),
                        Expanded(
                          child: Text(
                            CommonUtils()
                                .parseNull("${item["name"]}", ""),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: HhColors.blackColor,
                                fontSize: 15.sp * 3,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(width: 8.w * 3),
                        SizedBox(
                          width: 34.w * 3,
                          child: HhTap(
                            overlayColor: HhColors.trans,
                            onTapUp: () {
                              EventBusUtil.getInstance().fire(HhLoading(show: true,title: "加载中.."));
                              //隐藏输入法
                              FocusScope.of(logic.context).requestFocus(FocusNode());
                              logic.hideSearchResult();
                              Future.delayed(const Duration(milliseconds: 1000),(){
                                EventBusUtil.getInstance().fire(HhLoading(show: false));
                                logic.onTapSearchNavi(item);
                              });
                            },
                            child: Container(
                              color: HhColors.trans,
                              padding: EdgeInsets.fromLTRB(
                                  0, 8.w * 3, 0, 8.w * 3),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/images/common/map_guide.png",
                                    height: 16.w * 3,
                                    width: 16.w * 3,
                                  ),
                                  SizedBox(height: 2.w * 3),
                                  Text(
                                    "导航",
                                    style: TextStyle(
                                        color:
                                        HhColors.gray6TextColor,
                                        fontSize: 10.sp * 3),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        )
            : const SizedBox(),
      ],
    );
  }

  ///设备列表弹窗
  void deviceListDialog() {
    showModalBottomSheet(
        context: Get.context!,
        builder: (a) {
          return Container(
            width: 1.sw,
            height: 0.4.sh,
            decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(6.w * 3))),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 12.w * 3,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20.w * 3,
                    ),
                    SizedBox(
                        width: 45.w * 3,
                        child: Text(
                          '序号',
                          style: TextStyle(
                              color: HhColors.blackColor,
                              fontSize: 14.sp * 3,
                              fontWeight: FontWeight.w600),
                        )),
                    SizedBox(
                        width: 120.w * 3,
                        child: Text(
                          '设备名称',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: HhColors.blackColor,
                              fontSize: 14.sp * 3,
                              fontWeight: FontWeight.w600),
                        )),
                    Expanded(
                        child: Text(
                      '经纬度',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: HhColors.blackColor,
                          fontSize: 14.sp * 3,
                          fontWeight: FontWeight.w600),
                    )),
                    HhTap(
                      onTapUp: () {
                        Get.back();
                      },
                      child: Container(
                          color: HhColors.trans,
                          padding: EdgeInsets.all(10.w * 3),
                          margin: EdgeInsets.only(bottom: 5.w * 3),
                          child: Image.asset(
                            'assets/images/common/icon_up_x.png',
                            width: 12.w * 3,
                            height: 12.w * 3,
                            fit: BoxFit.fill,
                          )),
                    ),
                    SizedBox(
                      width: 15.w * 3,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.w * 3,
                ),
                CommonUtils.line(
                  margin: EdgeInsets.fromLTRB(15.w * 3, 0, 15.w * 3, 0),
                ),
                SizedBox(
                  height: 10.w * 3,
                ),
                Expanded(
                  child: EasyRefresh(
                    onRefresh: () {
                      logic.pageNum = 1;
                      logic.fetchPage();
                    },
                    onLoad: () {
                      logic.pageNum++;
                      logic.fetchPage();
                    },
                    controller: logic.deviceEasyController,
                    child: PagedListView<int, dynamic>(
                      padding: EdgeInsets.zero,
                      pagingController: logic.deviceController,
                      scrollController: logic.deviceScrollController,
                      builderDelegate: PagedChildBuilderDelegate<dynamic>(
                        noItemsFoundIndicatorBuilder: (context) =>
                            CommonUtils().noneWidget(
                          image:
                              'assets/images/common/icon_no_message_search.png',
                          info: '暂无设备信息',
                          mid: 10.w,
                          top: 0.2.sw,
                          height: 0.24.sw,
                          width: 0.3.sw,
                        ),
                        firstPageProgressIndicatorBuilder: (context) =>
                            Container(),
                        newPageProgressIndicatorBuilder: (context) =>
                            Container(),
                        itemBuilder: deviceListItemBuilder,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
        isDismissible: true,
        enableDrag: false,
        isScrollControlled: true);
  }

  ///设备列表Item
  Widget deviceListItemBuilder(BuildContext context, item, int index) {
    return InkWell(
      onTap: () async {
        try {
          LatLng latLng = LatLng(double.parse("${item["latitude"]}"),
              double.parse("${item["longitude"]}"));
          logic.gdMapController
              .moveCamera(CameraUpdate.newLatLngZoom(latLng, 16));
          Get.back();
          logic.deviceDetailDialog(item);
        } catch (e) {
          EventBusUtil.getInstance().fire(HhToast(title: "定位不可用"));
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15.w * 3),
        child: Row(
          children: [
            SizedBox(
              width: 25.w * 3,
            ),
            SizedBox(
                width: 40.w * 3,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                      color: HhColors.blackColor,
                      fontSize: 14.sp * 3,
                      fontWeight: FontWeight.w400),
                )),
            SizedBox(
                width: 125.w * 3,
                child: Text(
                  CommonUtils().parseNull('${item["name"]}', ""),
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: HhColors.blackColor,
                      fontSize: 14.sp * 3,
                      fontWeight: FontWeight.w400),
                )),
            Expanded(
                child: Text(
              "${CommonUtils().parseDoubleNumber("${item["longitude"] ?? ""}", 6)},${CommonUtils().parseDoubleNumber("${item["latitude"] ?? ""}", 6)}",
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: HhColors.blackColor,
                  fontSize: 14.sp * 3,
                  fontWeight: FontWeight.w400),
            )),
            SizedBox(
              width: 15.w * 3,
            ),
          ],
        ),
      ),
    );
  }
}
