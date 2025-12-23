import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/home/cell/HhTap.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/ParseLocation.dart';
import 'package:iot/utils/Permissions.dart';
import 'package:screenshot/screenshot.dart';

import 'main_controller.dart';

class MainPage extends StatelessWidget {
  final logic = Get.find<MainController>();

  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    logic.context = context;
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
          child: logic.pageStatus.value ? mainPage() : const SizedBox(),
        ),
      ),
    );
  }

  mainPage() {
    double tabWidth = (1.sw - 8.w * 3 - 8.w * 3 - 14.w * 3 - 14.w * 3) / 3;
    return Stack(
      children: [
        ///背景-渐变色
        Image.asset(
          "assets/images/common/main_background.png",
          width: 1.sw,
          height: 1.sh,
          fit: BoxFit.fill,
        ),

        ///定位
        Container(
          margin: EdgeInsets.fromLTRB(14.w * 3, 51.w * 3, 100.w*3, 0),
          child: Row(
            children: [
              Image.asset(
                "assets/images/common/icon_loc.png",
                width: 24.w * 3,
                height: 24.w * 3,
                fit: BoxFit.fill,
              ),
              SizedBox(width: 4.w*3),
              Expanded(
                child: Text(
                  logic.appLoc.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: HhColors.blackTextColor,
                      fontSize: 14.sp * 3,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),

        ///按钮
        Align(
          alignment: Alignment.topRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Permissions.hasPermission(Permissions.mainMessage)?BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 0.5,
                onPressed: () async {

                },
                child: Container(
                  width: 35.w * 3,
                  height: 50.w * 3,
                  margin: EdgeInsets.fromLTRB(0, 39.w * 3, 14.w * 3, 0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 3.w*3),
                          child: Image.asset(
                            logic.messageCount.value!="0"?"assets/images/common/main_warning.gif":"assets/images/common/main_warn.png",
                            width: logic.messageCount.value!="0"?30.w*3:28.w * 3,
                            height: logic.messageCount.value!="0"?30.w * 3:32.w*3,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      logic.messageCount.value=="0"?const SizedBox():Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          decoration: BoxDecoration(
                              color: HhColors.mainRedColor,
                              borderRadius: BorderRadius.all(Radius.circular(20.w))
                          ),
                          width: 15.w*3 + ((logic.messageCount.value.length-1) * (3.w*3)),
                          height: 15.w*3,
                          child: Center(child: Text(logic.messageCount.value,style: TextStyle(color: HhColors.whiteColor,fontSize: 10.sp*3),)),
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Text("消息",style: TextStyle(color: HhColors.blackTextColor,fontSize: 10.sp*3),)
                      )
                    ],
                  ),
                ),
              ):const SizedBox(),

            ],
          ),
        ),

        ///主页整体列表
        Container(
          margin: EdgeInsets.only(top: 98.w * 3),
          child: EasyRefresh(
            onRefresh: () {
              logic.getWarnCount();
              logic.getMenuList();
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///轮播图
                  Permissions.hasPermission(Permissions.mainBanner)?Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(14.w * 3, 0, 14.w * 3, 0),
                        child: CarouselSlider.builder(
                          itemCount: logic.headerList!.value.length,
                          itemBuilder: (context, index, realIndex) {
                            final path = logic.headerList!.value[index];
                            Widget imageWidget;
                            if (path.startsWith('http')) {
                              // 网络图片
                              imageWidget = Image.network(
                                path,
                                width: 1.sw,
                                height: 150.w * 3,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    "assets/images/common/main_image.png",
                                    width: 1.sw,
                                    height: 150.w * 3,
                                    fit: BoxFit.fill,
                                  );
                                },
                              );
                            } else {
                              // 本地图片
                              imageWidget = Image.asset(
                                path,
                                width: 1.sw,
                                height: 150.w * 3,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    "assets/images/common/main_image.png",
                                    width: 1.sw,
                                    height: 150.w * 3,
                                    fit: BoxFit.fill,
                                  );
                                },
                              );
                            }

                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8.w * 3),
                              child: imageWidget,
                            );
                          },
                          options: CarouselOptions(
                            height: 150.w * 3,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 10),
                            enlargeCenterPage: true,
                            viewportFraction: 1,
                            onPageChanged: (index, reason) {
                              logic.headerIndex!.value = index;
                            },
                          ),
                        ),
                      ),
                      logic.headerList!.value.length > 1
                          ? Positioned(
                              bottom: 5.w * 3, // 指示器距离底部的距离
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: logic.headerList!.value
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  return Container(
                                    width: 6.w * 3,
                                    height: 3.w * 3,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 1.w * 3),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: logic.headerIndex!.value ==
                                                entry.key
                                            ? Colors.blueAccent
                                            : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(2.w * 3)),
                                  );
                                }).toList(),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ):const SizedBox(),

                  ///设备统计
                  Permissions.hasPermission(Permissions.mainDeviceMonitor)?Container(
                    width: 1.sw,
                    height: 90.w * 3,
                    margin:
                    EdgeInsets.fromLTRB(14.w * 3, 10.w * 3, 14.w * 3, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 90.w * 3,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: HhColors.whiteColor,
                              gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [HhColors.backColorMainDevice, HhColors.whiteColor]),
                              borderRadius:
                              BorderRadius.all(Radius.circular(8.w * 3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ///设备总数
                                Container(
                                  margin: EdgeInsets.only(left: 10.w * 3),
                                  padding: EdgeInsets.fromLTRB(
                                      5.w * 3, 0, 5.w * 3, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 68.w * 3,
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Expanded(
                                              child: SizedBox(),
                                            ),
                                            Container(
                                              height: 6.w * 3,
                                              width: 6.w * 3,
                                              decoration: BoxDecoration(
                                                  color: HhColors.tabBlue,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      3.w * 3)),
                                              margin: EdgeInsets.only(
                                                  bottom: 5.w * 3),
                                            ),
                                            SizedBox(width: 3.w*3,),
                                            Text(
                                              "${logic.deviceAllNum!.value}",
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color:
                                                  HhColors.textBlackColor,
                                                  fontSize: 20.sp * 3,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                            SizedBox(width: 3.w*3,),
                                            const Expanded(
                                              child: SizedBox(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2.w * 3,
                                      ),
                                      Text(
                                        "设备总数",
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: HhColors.textBlackColor,
                                            fontSize: 14.sp * 3,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: HhColors.grayLineMainDevice,
                                  height: 41.w * 3,
                                  width: 1.w * 3,
                                  margin: EdgeInsets.fromLTRB(3.w*3, 0 , 3.w*3 , 0),
                                ),

                                ///在线
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      5.w * 3, 0, 5.w * 3, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 65.w * 3,
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Expanded(
                                              child: SizedBox(),
                                            ),
                                            Container(
                                              height: 6.w * 3,
                                              width: 6.w * 3,
                                              decoration: BoxDecoration(
                                                  color: HhColors.tabGreen,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      3.w * 3)),
                                              margin: EdgeInsets.only(
                                                  bottom: 5.w * 3),
                                            ),
                                            SizedBox(width: 3.w*3,),
                                            Text(
                                              "${logic.deviceOnlineNum!.value}",
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color:
                                                  HhColors.textBlackColor,
                                                  fontSize: 20.sp * 3,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                            SizedBox(width: 3.w*3,),
                                            const Expanded(
                                              child: SizedBox(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2.w * 3,
                                      ),
                                      Text(
                                        "在线",
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: HhColors.textBlackColor,
                                            fontSize: 14.sp * 3,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: HhColors.grayLineMainDevice,
                                  height: 41.w * 3,
                                  width: 1.w * 3,
                                  margin: EdgeInsets.fromLTRB(3.w*3, 0 , 3.w*3 , 0),
                                ),

                                ///离线
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      5.w * 3, 0, 5.w * 3, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 65.w * 3,
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Expanded(
                                              child: SizedBox(),
                                            ),
                                            Container(
                                              height: 6.w * 3,
                                              width: 6.w * 3,
                                              decoration: BoxDecoration(
                                                  color: HhColors.tabYellow,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      3.w * 3)),
                                              margin: EdgeInsets.only(
                                                  bottom: 5.w * 3),
                                            ),
                                            SizedBox(width: 3.w*3,),
                                            Text(
                                              "${logic.deviceOfflineNum!.value}",
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color:
                                                  HhColors.textBlackColor,
                                                  fontSize: 20.sp * 3,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                            SizedBox(width: 3.w*3,),
                                            const Expanded(
                                              child: SizedBox(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2.w * 3,
                                      ),
                                      Text(
                                        "离线",
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: HhColors.textBlackColor,
                                            fontSize: 14.sp * 3,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w * 3,
                        ),
                        ///今日报警
                        Container(
                          height: 90.w * 3,
                          width: 76.w * 3,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  HhColors.gradientGreen,
                                  HhColors.whiteColor
                                ]),
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.w * 3)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 68.w * 3,
                                alignment: Alignment.center,
                                child: Text(
                                  CommonUtils().parseDoubleNumber("${logic.deviceOnlineRatio!.value}", 1),
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: HhColors.mainRedColor,
                                      fontSize: 20.sp * 3,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(
                                height: 2.w * 3,
                              ),
                              Text(
                                "今日报警",
                                maxLines: 1,
                                style: TextStyle(
                                    color: HhColors.textBlackColor,
                                    fontSize: 14.sp * 3,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ):const SizedBox(),

                  ///菜单
                  Permissions.hasPermission(Permissions.mainMenu)?Container(
                    height: 100.w*3,
                    width: 1.sw,
                    margin:
                        EdgeInsets.fromLTRB(14.w * 3, 10.w * 3, 14.w * 3, 0),
                    padding:
                        EdgeInsets.fromLTRB(5.w * 3, 5.w * 3, 5.w * 3, 5.w * 3),
                    decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.w * 3)),
                    ),
                    child: Column(
                      children: [
                        ///菜单分页
                        Expanded(
                          child: ScrollConfiguration(
                            behavior: const _NoScrollGlowBehavior(),
                            child: PageView.builder(
                                controller: logic.menuPageController,
                                onPageChanged: (index) {
                                  logic.currentMenuPage.value = index;
                                },
                                itemCount: logic.menuPageCount.value,
                                itemBuilder: (context, pageIndex) {
                                  int start = pageIndex * logic.menuCountInPage;
                                  int end = (start + logic.menuCountInPage > logic.menuList.length)
                                      ? logic.menuList.length
                                      : start + logic.menuCountInPage;
                                  List<dynamic> pageItems = logic.menuList.sublist(start, end);

                                  return GridView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: pageItems.length,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      childAspectRatio: 1,
                                    ),
                                    itemBuilder: (context, index) {
                                      return menuGridView(context, pageItems[index], index);
                                    },
                                  );
                                }),
                          ),
                        ),
                        ///指示器
                        logic.menuPageCount.value>1?Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(logic.menuPageCount.value, (index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 1.w*3, vertical: 2.w*3),
                              width: logic.currentMenuPage.value == index ? 5.w*3 : 13.w*3,
                              height: 4.w*3,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: logic.currentMenuPage.value == index ? HhColors.mainBlueColor : HhColors.grayDDBackColor,
                                borderRadius: BorderRadius.circular(2.w*3)
                              ),
                            );
                          }),
                        ):const SizedBox(),
                      ],
                    ),
                  ):const SizedBox(),

                  ///设备监测
                  Permissions.hasPermission(Permissions.mainDeviceMonitor)?Container(
                    margin:
                    EdgeInsets.fromLTRB(14.w * 3, 10.w * 3, 14.w * 3, 0),
                    height: 36.w * 3,
                    width: 1.sw,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 3.w * 3),
                            child: Image.asset(
                              "assets/images/common/tab_icon.png",
                              width: 6.w * 3,
                              height: 13.w * 3,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 14.w * 3),
                            child: Text(
                              "设备监测",
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 15.sp * 3,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: HhTap(
                            overlayColor: HhColors.trans,
                            onTapUp: (){

                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10.w * 3),
                              padding: EdgeInsets.all(6.w*3),
                              color: HhColors.trans,
                              child: Text(
                                "查看更多",
                                style: TextStyle(
                                    color: HhColors.gray6TextColor,
                                    fontSize: 14.sp * 3,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                            "assets/images/common/icon_more.png",
                            width: 16.w * 3,
                            height: 16.w * 3,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ):const SizedBox(),
                  Permissions.hasPermission(Permissions.mainDeviceMonitor)?Container(
                    margin:
                        EdgeInsets.fromLTRB(14.w * 3, 14.w * 3, 14.w * 3, 0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: tabWidth,
                          height: tabWidth * 0.8,
                          child: Stack(
                            children: [
                              Image.asset(
                                "assets/images/common/main_one.png",
                                width: tabWidth,
                                height: tabWidth * 0.8,
                                fit: BoxFit.fill,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "高点数量",
                                      style: TextStyle(
                                          color: HhColors.whiteColor,
                                          fontSize: 14.sp * 3,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 4.w * 3,
                                    ),
                                    Text(
                                      "${logic.highPointNum!.value}",
                                      maxLines: 1,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: HhColors.whiteColor,
                                          fontSize: 24.sp * 3,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 8.w * 3,
                        ),
                        SizedBox(
                          width: tabWidth,
                          height: tabWidth * 0.8,
                          child: Stack(
                            children: [
                              Image.asset(
                                "assets/images/common/main_two.png",
                                width: tabWidth,
                                height: tabWidth * 0.8,
                                fit: BoxFit.fill,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "卡口数量",
                                      style: TextStyle(
                                          color: HhColors.whiteColor,
                                          fontSize: 14.sp * 3,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 4.w * 3,
                                    ),
                                    Text(
                                      "${logic.kaKouNum!.value}",
                                      maxLines: 1,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: HhColors.whiteColor,
                                          fontSize: 24.sp * 3,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 8.w * 3,
                        ),
                        SizedBox(
                          width: tabWidth,
                          height: tabWidth * 0.8,
                          child: Stack(
                            children: [
                              Image.asset(
                                "assets/images/common/main_three.png",
                                width: tabWidth,
                                height: tabWidth * 0.8,
                                fit: BoxFit.fill,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "无人机数量",
                                      style: TextStyle(
                                          color: HhColors.whiteColor,
                                          fontSize: 14.sp * 3,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 4.w * 3,
                                    ),
                                    Text(
                                      "${logic.droneNum!.value}",
                                      maxLines: 1,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: HhColors.whiteColor,
                                          fontSize: 24.sp * 3,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ):const SizedBox(),

                  ///火险等级
                  Permissions.hasPermission(Permissions.mainFireLevel)?Container(
                    margin:
                        EdgeInsets.fromLTRB(14.w * 3, 14.w * 3, 14.w * 3, 0),
                    height: 30.w * 3,
                    width: 1.sw,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 3.w * 3),
                            child: Image.asset(
                              "assets/images/common/tab_icon_red.png",
                              width: 6.w * 3,
                              height: 13.w * 3,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 14.w * 3),
                            child: Text(
                              "火险等级",
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 15.sp * 3,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ):const SizedBox(),
                  Permissions.hasPermission(Permissions.mainFireLevel)?Container(
                    height: 0.68.sw,
                    width: 1.sw,
                    margin: EdgeInsets.fromLTRB(
                        14.w * 3, 14.w * 3, 14.w * 3, 20.w * 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.5.w * 3),
                    ),
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/images/common/fire_back.png",
                          height: 0.68.sw,
                          width: 1.sw,
                          fit: BoxFit.fill,
                        ),
                        Column(
                          children: [
                            ///图标  &&  地区  &&  火险等级  &&  行政区&&监测站
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  13.w * 3, 10.w * 3, 11.w * 3, 0),
                              width: 1.sw,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.w * 3)),
                                    child: Image.asset(
                                      "assets/images/common/tab_level.png",
                                      width: 45.w * 3,
                                      height: 25.w * 3,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.w * 3,
                                  ),
                                  Text(
                                    "${logic.gridName.value}:",
                                    style: TextStyle(
                                        color: HhColors.blackTextColor,
                                        fontSize: 14.sp * 3,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: 5.w * 3,
                                  ),
                                  Text(
                                    logic.levelName.value,
                                    style: TextStyle(
                                        color: parseLevelColor(logic.levelName.value),
                                        fontSize: 14.sp * 3,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const Expanded(child: SizedBox()),

                                  ///行政区&&监测站
                                  Container(
                                    decoration: BoxDecoration(
                                        color: HhColors.whiteColor,
                                        borderRadius:
                                            BorderRadius.circular(4.w * 3)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        HhTap(
                                          borderRadius:
                                              BorderRadius.circular(4.w * 3),
                                          onTapUp: () async {
                                            //await logic.getFireLevelByGrid(loading: true);
                                            logic.fireLevelByGridOrStation
                                                .value = true;
                                          },
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10.w * 3,
                                                5.w * 3,
                                                10.w * 3,
                                                5.w * 3),
                                            decoration: BoxDecoration(
                                                color: logic
                                                        .fireLevelByGridOrStation
                                                        .value
                                                    ? HhColors.mainBlueColor
                                                    : HhColors.whiteColor,
                                                borderRadius: logic
                                                        .fireLevelByGridOrStation
                                                        .value
                                                    ? BorderRadius.circular(
                                                        4.w * 3)
                                                    : BorderRadius.horizontal(
                                                        left: Radius.circular(
                                                            4.w * 3))),
                                            child: Text(
                                              "行政区",
                                              style: TextStyle(
                                                  color: logic
                                                          .fireLevelByGridOrStation
                                                          .value
                                                      ? HhColors.whiteColor
                                                      : HhColors.gray6TextColor,
                                                  fontSize: 12.sp * 3,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                        HhTap(
                                          borderRadius:
                                              BorderRadius.circular(4.w * 3),
                                          onTapUp: () async {
                                            //await logic.getFireLevelByStation(loading: true);
                                            logic.fireLevelByGridOrStation
                                                .value = false;
                                          },
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10.w * 3,
                                                5.w * 3,
                                                10.w * 3,
                                                5.w * 3),
                                            decoration: BoxDecoration(
                                                color: logic
                                                        .fireLevelByGridOrStation
                                                        .value
                                                    ? HhColors.whiteColor
                                                    : HhColors.mainBlueColor,
                                                borderRadius: logic
                                                        .fireLevelByGridOrStation
                                                        .value
                                                    ? BorderRadius.horizontal(
                                                        right: Radius.circular(
                                                            4.w * 3))
                                                    : BorderRadius.circular(
                                                        4.w * 3)),
                                            child: Text(
                                              "监测站",
                                              style: TextStyle(
                                                  color: logic
                                                          .fireLevelByGridOrStation
                                                          .value
                                                      ? HhColors.gray6TextColor
                                                      : HhColors.whiteColor,
                                                  fontSize: 12.sp * 3,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ///火险等级
                            Container(
                              height: 80.w * 3,
                              margin: EdgeInsets.fromLTRB(
                                  10.w * 3, 10.w * 3, 10.w * 3, 0),
                              decoration: BoxDecoration(
                                  color: HhColors.levelColorBack,
                                  borderRadius:
                                      BorderRadius.circular(10.w * 3)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: BouncingWidget(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      scaleFactor: 0.2,
                                      onPressed: () async {
                                        // 0五级火险   1四级火险   2三级火线   3二级火险   4一级火险
                                        logic.fireLevelIndex.value = 0;
                                        //logic.parseFireLevelList();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                logic.fireLevelIndex.value == 0
                                                    ? HhColors.whiteColor
                                                    : HhColors.levelColorBack,
                                            borderRadius:
                                                BorderRadius.circular(8.w * 3)),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              height: 15.w * 3,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 5.w * 3),
                                              child: Text(
                                                logic.fireLevelByGridOrStation.value?
                                                CommonUtils().parseNull("${logic.fireLevelByGridList[0]["value"]}", "0")
                                                :CommonUtils().parseNull("${logic.fireLevelByStationList[0]["value"]}", "0"),
                                                style: TextStyle(
                                                    color: HhColors.levelColor5,
                                                    fontSize: 20.sp * 3,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.w * 3,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 5.w * 3),
                                              child: Text(
                                                "五级火险",
                                                style: TextStyle(
                                                    color: logic.fireLevelIndex
                                                                .value ==
                                                            0
                                                        ? HhColors.levelColor5
                                                        : HhColors
                                                            .gray9TextColor,
                                                    fontSize: 12.sp * 3,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            const Expanded(child: SizedBox()),
                                            logic.fireLevelIndex.value != 0
                                                ? const SizedBox()
                                                : Container(
                                                    height: 2.w * 3,
                                                    width: 30.w * 3,
                                                    decoration: BoxDecoration(
                                                        color: HhColors
                                                            .levelColor5,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    1.w * 3)),
                                                  )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: BouncingWidget(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      scaleFactor: 0.2,
                                      onPressed: () async {
                                        // 0五级火险   1四级火险   2三级火线   3二级火险   4一级火险
                                        logic.fireLevelIndex.value = 1;
                                        //logic.parseFireLevelList();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                logic.fireLevelIndex.value == 1
                                                    ? HhColors.whiteColor
                                                    : HhColors.levelColorBack,
                                            borderRadius:
                                                BorderRadius.circular(8.w * 3)),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              height: 15.w * 3,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 5.w * 3),
                                              child: Text(
                                                logic.fireLevelByGridOrStation.value?
                                                CommonUtils().parseNull("${logic.fireLevelByGridList[1]["value"]}", "0")
                                                    :CommonUtils().parseNull("${logic.fireLevelByStationList[1]["value"]}", "0"),
                                                style: TextStyle(
                                                    color: HhColors.levelColor4,
                                                    fontSize: 20.sp * 3,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.w * 3,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 5.w * 3),
                                              child: Text(
                                                "四级火险",
                                                style: TextStyle(
                                                    color: logic.fireLevelIndex
                                                                .value ==
                                                            1
                                                        ? HhColors.levelColor4
                                                        : HhColors
                                                            .gray9TextColor,
                                                    fontSize: 12.sp * 3,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            const Expanded(child: SizedBox()),
                                            logic.fireLevelIndex.value != 1
                                                ? const SizedBox()
                                                : Container(
                                                    height: 2.w * 3,
                                                    width: 30.w * 3,
                                                    decoration: BoxDecoration(
                                                        color: HhColors
                                                            .levelColor4,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    1.w * 3)),
                                                  )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: BouncingWidget(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      scaleFactor: 0.2,
                                      onPressed: () async {
                                        // 0五级火险   1四级火险   2三级火线   3二级火险   4一级火险
                                        logic.fireLevelIndex.value = 2;
                                        //logic.parseFireLevelList();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                logic.fireLevelIndex.value == 2
                                                    ? HhColors.whiteColor
                                                    : HhColors.levelColorBack,
                                            borderRadius:
                                                BorderRadius.circular(8.w * 3)),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              height: 15.w * 3,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 5.w * 3),
                                              child: Text(
                                                logic.fireLevelByGridOrStation.value?
                                                CommonUtils().parseNull("${logic.fireLevelByGridList[2]["value"]}", "0")
                                                    :CommonUtils().parseNull("${logic.fireLevelByStationList[2]["value"]}", "0"),
                                                style: TextStyle(
                                                    color: HhColors.levelColor3,
                                                    fontSize: 20.sp * 3,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.w * 3,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 5.w * 3),
                                              child: Text(
                                                "三级火险",
                                                style: TextStyle(
                                                    color: logic.fireLevelIndex
                                                                .value ==
                                                            2
                                                        ? HhColors.levelColor3
                                                        : HhColors
                                                            .gray9TextColor,
                                                    fontSize: 12.sp * 3,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            const Expanded(child: SizedBox()),
                                            logic.fireLevelIndex.value != 2
                                                ? const SizedBox()
                                                : Container(
                                                    height: 2.w * 3,
                                                    width: 30.w * 3,
                                                    decoration: BoxDecoration(
                                                        color: HhColors
                                                            .levelColor3,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    1.w * 3)),
                                                  )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: BouncingWidget(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      scaleFactor: 0.2,
                                      onPressed: () async {
                                        // 0五级火险   1四级火险   2三级火线   3二级火险   4一级火险
                                        logic.fireLevelIndex.value = 3;
                                        //logic.parseFireLevelList();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                logic.fireLevelIndex.value == 3
                                                    ? HhColors.whiteColor
                                                    : HhColors.levelColorBack,
                                            borderRadius:
                                                BorderRadius.circular(8.w * 3)),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              height: 15.w * 3,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 5.w * 3),
                                              child: Text(
                                                logic.fireLevelByGridOrStation.value?
                                                CommonUtils().parseNull("${logic.fireLevelByGridList[3]["value"]}", "0")
                                                    :CommonUtils().parseNull("${logic.fireLevelByStationList[3]["value"]}", "0"),
                                                style: TextStyle(
                                                    color: HhColors.levelColor2,
                                                    fontSize: 20.sp * 3,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.w * 3,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 5.w * 3),
                                              child: Text(
                                                "二级火险",
                                                style: TextStyle(
                                                    color: logic.fireLevelIndex
                                                                .value ==
                                                            3
                                                        ? HhColors.levelColor2
                                                        : HhColors
                                                            .gray9TextColor,
                                                    fontSize: 12.sp * 3,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            const Expanded(child: SizedBox()),
                                            logic.fireLevelIndex.value != 3
                                                ? const SizedBox()
                                                : Container(
                                                    height: 2.w * 3,
                                                    width: 30.w * 3,
                                                    decoration: BoxDecoration(
                                                        color: HhColors
                                                            .levelColor2,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    1.w * 3)),
                                                  )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: BouncingWidget(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      scaleFactor: 0.2,
                                      onPressed: () async {
                                        // 0五级火险   1四级火险   2三级火线   3二级火险   4一级火险
                                        logic.fireLevelIndex.value = 4;
                                        //logic.parseFireLevelList();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                logic.fireLevelIndex.value == 4
                                                    ? HhColors.whiteColor
                                                    : HhColors.levelColorBack,
                                            borderRadius:
                                                BorderRadius.circular(8.w * 3)),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              height: 15.w * 3,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 5.w * 3),
                                              child: Text(
                                                logic.fireLevelByGridOrStation.value?
                                                CommonUtils().parseNull("${logic.fireLevelByGridList[4]["value"]}", "0")
                                                    :CommonUtils().parseNull("${logic.fireLevelByStationList[4]["value"]}", "0"),
                                                style: TextStyle(
                                                    color: HhColors.levelColor1,
                                                    fontSize: 20.sp * 3,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.w * 3,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 5.w * 3),
                                              child: Text(
                                                "一级火险",
                                                style: TextStyle(
                                                    color: logic.fireLevelIndex
                                                                .value ==
                                                            4
                                                        ? HhColors.levelColor1
                                                        : HhColors
                                                            .gray9TextColor,
                                                    fontSize: 12.sp * 3,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            const Expanded(child: SizedBox()),
                                            logic.fireLevelIndex.value != 4
                                                ? const SizedBox()
                                                : Container(
                                                    height: 2.w * 3,
                                                    width: 30.w * 3,
                                                    decoration: BoxDecoration(
                                                        color: HhColors
                                                            .levelColor1,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    1.w * 3)),
                                                  )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.vertical,
                                  itemCount: logic.fireLevelList.length,
                                  itemBuilder: fireLevelBuilder),
                            ),
                            SizedBox(height: 10.w*3,)
                          ],
                        ),
                      ],
                    ),
                  ):SizedBox(height: 20.w*3,),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  menuGridView(BuildContext context, item, int index) {
    double menuWidth = (1.sw - 14.w * 3 - 14.w * 3) / 4;
    return HhTap(
      overlayColor: HhColors.trans,
      onTapUp: () async {
        menuTap(item);
      },
      child: Container(
        color: HhColors.trans,
        width: menuWidth,
        height: menuWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40.w * 3,
              height: 40.w * 3,
              child: Stack(
                children: [
                  Image.asset(
                    "${item['image']}",
                    width: 40.w * 3,
                    height: 40.w * 3,
                    fit: BoxFit.fill,
                  ),
                  item['unRead'] == true
                      ? Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: 10.w * 3,
                            height: 10.w * 3,
                            decoration: BoxDecoration(
                                color: HhColors.mainRedNoticeColor,
                                borderRadius: BorderRadius.circular(5.w * 3)),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
            SizedBox(
              height: 5.w * 3,
            ),
            Text(
              "${item['title']}",
              style: TextStyle(
                  color: HhColors.blackTextColor,
                  fontSize: 12.sp * 3,
                  fontWeight: FontWeight.w400),
            )
          ],
        ),
      ),
    );
  }

  Widget? fireLevelBuilder(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(15.w * 3, 12.w * 3, 15.w * 3, 0),
      child: Row(
        children: [
          Container(
            width: 35.w * 3,
            alignment: Alignment.center,
            child: Text(
              "${index + 1}",
              style: TextStyle(
                  color: HhColors.blackTextColor,
                  fontSize: 14.sp * 3,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Expanded(
            child: Text(
              logic.fireLevelByGridOrStation.value
                  ?CommonUtils().parseNull("${logic.fireLevelList.value[index]['name']}", "")
                  :CommonUtils().parseNull("${logic.fireLevelList.value[index]['stationName']}", ""),
              maxLines: 1,
              style: TextStyle(
                  color: HhColors.blackTextColor,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 14.sp * 3,
                  fontWeight: FontWeight.w400),
            ),
          ),
          HhTap(
            borderRadius: BorderRadius.circular(4.w * 3),
            onTapUp: () async {
              if(logic.fireLevelByGridOrStation.value){
                ///行政区
                String location = await logic.getGeoGridLocation(logic.fireLevelList.value[index]['name']);
                if(location.isNotEmpty){
                  try{
                    List<String> loc = location.split(",");
                    List<double> end = ParseLocation.gps84_To_Gcj02(double.parse(loc[1]), double.parse(loc[0]),);
                    EventBusUtil.getInstance().fire(HhLoading(show: true));
                    /*await QcAmapNavi.startNavigation(
                      fromLat: double.parse("${CommonData.latitude}"),
                      fromLng: double.parse("${CommonData.longitude}"),
                      fromName: "我的位置",
                      toLat: double.parse("${end[0]}"),
                      toLng: double.parse("${end[1]}"),
                      toName: "${logic.fireLevelList.value[index]['name']}",
                    );*/
                    EventBusUtil.getInstance().fire(HhLoading(show: false));
                  }catch(e){
                    HhLog.e(e.toString());
                    EventBusUtil.getInstance().fire(HhToast(title: "该定位不可用"));
                  }
                }
              }else{
                ///监测站
                try{
                  List<double> end = ParseLocation.gps84_To_Gcj02(double.parse("${logic.fireLevelList.value[index]['latitude']}"), double.parse("${logic.fireLevelList.value[index]['longitude']}"),);
                  EventBusUtil.getInstance().fire(HhLoading(show: true));
                  /*await QcAmapNavi.startNavigation(
                    fromLat: double.parse("${CommonData.latitude}"),
                    fromLng: double.parse("${CommonData.longitude}"),
                    fromName: "我的位置",
                    toLat: double.parse("${end[0]}"),
                    toLng: double.parse("${end[1]}"),
                    toName: "${logic.fireLevelList.value[index]['stationName']}",
                  );*/
                  EventBusUtil.getInstance().fire(HhLoading(show: false));
                }catch(e){
                  HhLog.e(e.toString());
                  EventBusUtil.getInstance().fire(HhToast(title: "该定位不可用"));
                }
              }
            },
            child: Container(
              padding:
                  EdgeInsets.fromLTRB(14.w * 3, 4.w * 3, 14.w * 3, 5.w * 3),
              decoration: BoxDecoration(
                  color: HhColors.levelBtnBack,
                  borderRadius: BorderRadius.circular(4.w * 3)),
              child: Text(
                "定位",
                style: TextStyle(
                    color: HhColors.mainBlueColor,
                    fontSize: 13.sp * 3,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void menuTap(item) {
    if (item["title"] == "智慧立杆") {

    }
    if (item["title"] == "火险因子") {

    }
    if (item["title"] == "报警管理") {

    }
    if (item["title"] == "全部设备") {

    }
  }

  Color parseLevelColor(String code) {
    Color color = HhColors.mainBlueColor;
    if(code == "一级火险"){
      color = HhColors.levelColor1;
    }
    if(code == "二级火险"){
      color = HhColors.levelColor2;
    }
    if(code == "三级火险"){
      color = HhColors.levelColor3;
    }
    if(code == "四级火险"){
      color = HhColors.levelColor4;
    }
    if(code == "五级火险"){
      color = HhColors.levelColor5;
    }
    return color;
  }
}

class _NoScrollGlowBehavior extends ScrollBehavior {
  const _NoScrollGlowBehavior();

  @override
  Widget buildOverscrollIndicator(
      BuildContext context,
      Widget child,
      ScrollableDetails details,
      ) {
    // 不显示任何滚动指示效果（即去掉回弹和蓝色光晕）
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // 禁用 iOS 弹性回弹
    return const ClampingScrollPhysics();
  }
}

