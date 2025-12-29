import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/today_warning/today_warning_binding.dart';
import 'package:iot/pages/common/today_warning/today_warning_view.dart';
import 'package:iot/pages/home/cell/HhTap.dart';
import 'package:iot/pages/home/device/add/device_add_binding.dart';
import 'package:iot/pages/home/device/add/device_add_view.dart';
import 'package:iot/pages/home/device/list/device_list_binding.dart';
import 'package:iot/pages/home/device/list/device_list_view.dart';
import 'package:iot/pages/home/space/space_binding.dart';
import 'package:iot/pages/home/space/space_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/ParseLocation.dart';
import 'package:iot/utils/Permissions.dart';
import 'package:iot/widgets/pop_menu.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';

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
          child: logic.pageStatus.value ? mainPage(context) : const SizedBox(),
        ),
      ),
    );
  }

  mainPage(context) {
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ///报警
              Permissions.hasPermission(Permissions.mainMessage)?BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 0.5,
                onPressed: () async {

                },
                child: Container(
                  width: 35.w * 3,
                  height: 50.w * 3,
                  margin: EdgeInsets.fromLTRB(0, 39.w * 3, 9.w * 3, 0),
                  color: HhColors.trans,
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
                          child: Text("报警",style: TextStyle(color: HhColors.blackTextColor,fontSize: 10.sp*3),)
                      )
                    ],
                  ),
                ),
              ):const SizedBox(),
              ///添加
              GestureDetector(
                onTapDown: (details) {
                  HhActionMenu.show(
                    context: context,
                    offset: details.globalPosition,
                    direction: HhMenuDirection.bottom,
                    itemDirection: HhItemDirection.vertical,
                    //backgroundImage: 'assets/images/common/icon_pop_background.png',
                    dx: 20.w*3,
                    dy: 10.w*3,
                    items: [
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: (){
                          HhActionMenu.dismiss();
                          Get.to(()=>DeviceAddPage(snCode: '',),binding: DeviceAddBinding());
                        },
                        child: Container(
                          color:HhColors.trans,
                          padding: EdgeInsets.fromLTRB(15.w*3, 15.w*3, 15.w*3, 12.w*3),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/images/common/icon_scanner.png",
                                width: 18.w * 3,
                                height: 18.w * 3,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(width: 5.w*3),
                              Text('添加设备', style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3,fontWeight: FontWeight.w200),),
                            ],
                          ),
                        ),
                      ),
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: (){
                          HhActionMenu.dismiss();
                          Get.to(()=>SpacePage(),binding: SpaceBinding());
                        },
                        child: Container(
                          color:HhColors.trans,
                          padding: EdgeInsets.fromLTRB(15.w*3, 12.w*3, 15.w*3, 15.w*3),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/images/common/icon_zu.png",
                                width: 18.w * 3,
                                height: 18.w * 3,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(width: 5.w*3),
                              Text('添加分组', style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3,fontWeight: FontWeight.w200),),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 39.w * 3, 15.w * 3, 0),
                  color: HhColors.trans,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/common/ic_add.png",
                        width: 24.w * 3,
                        height: 24.w * 3,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 3.w*3),
                      Text("添加",style: TextStyle(color: HhColors.blackTextColor,fontSize: 10.sp*3),)
                    ],
                  ),
                ),
              ),
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
              logic.getDeviceStatistics();
              logic.getFireLevelStatistics();
              logic.getFireLevelList();
              logic.getLiveWarningList();
              logic.getWarnType();
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
                                InkWell(
                                  onTap: () async {
                                    logic.deviceStatus.value = 2;
                                    await logic.mainDeviceList();
                                    deviceListDialog();
                                  },
                                  child: Container(
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
                                ),
                                Container(
                                  color: HhColors.grayLineMainDevice,
                                  height: 41.w * 3,
                                  width: 1.w * 3,
                                  margin: EdgeInsets.fromLTRB(3.w*3, 0 , 3.w*3 , 0),
                                ),

                                ///在线
                                InkWell(
                                  onTap: () async {
                                    logic.deviceStatus.value = 1;
                                    await logic.mainDeviceList();
                                    deviceListDialog();
                                  },
                                  child: Container(
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
                                ),
                                Container(
                                  color: HhColors.grayLineMainDevice,
                                  height: 41.w * 3,
                                  width: 1.w * 3,
                                  margin: EdgeInsets.fromLTRB(3.w*3, 0 , 3.w*3 , 0),
                                ),

                                ///离线
                                InkWell(
                                  onTap: () async {
                                    logic.deviceStatus.value = 0;
                                    await logic.mainDeviceList();
                                    deviceListDialog();
                                  },
                                  child: Container(
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
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w * 3,
                        ),
                        ///今日报警
                        InkWell(
                          onTap: (){
                            Get.to(() => TodayWarningPage(), binding: TodayWarningBinding());
                          },
                          child: Container(
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
                                    "${logic.deviceOnlineRatio!.value}",
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

                  ///实时预警
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
                              "实时预警",
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
                    margin: EdgeInsets.fromLTRB(14.w * 3, 9.w * 3, 14.w * 3, 0),
                    height: 240.w * 3,
                    width: 1.sw,
                    decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.circular(8.w * 3),
                    ),
                    child: logic.liveWarningList.isNotEmpty?ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemCount: logic.liveWarningList.length,
                        itemBuilder: liveWarningBuilder):CommonUtils().noneWidgetSmall(image: "assets/images/common/icon_no_message_search.png",text: "暂无预警信息"),
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
                            ///火险等级
                            Container(
                              height: 80.w * 3,
                              margin: EdgeInsets.fromLTRB(
                                  10.w * 3, 14.w * 3, 10.w * 3, 0),
                              decoration: BoxDecoration(
                                  color: HhColors.levelColorBack,
                                  borderRadius:
                                      BorderRadius.circular(10.w * 3)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        // 5五级火险   4四级火险   3三级火线   2二级火险   1一级火险
                                        logic.fireLevelIndex.value = 5;
                                        logic.getFireLevelList();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                logic.fireLevelIndex.value == 5
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
                                                CommonUtils().parseNull("${logic.fireLevelByStationList[0]}", "0"),
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
                                                            5
                                                        ? HhColors.levelColor5
                                                        : HhColors
                                                            .gray9TextColor,
                                                    fontSize: 12.sp * 3,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            const Expanded(child: SizedBox()),
                                            logic.fireLevelIndex.value != 5
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
                                    child: GestureDetector(
                                      onTap: () async {
                                        // 5五级火险   4四级火险   3三级火线   2二级火险   1一级火险
                                        logic.fireLevelIndex.value = 4;
                                        logic.getFireLevelList();
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
                                                CommonUtils().parseNull("${logic.fireLevelByStationList[1]}", "0"),
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
                                                            4
                                                        ? HhColors.levelColor4
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
                                    child: GestureDetector(
                                      onTap: () async {
                                        // 5五级火险   4四级火险   3三级火线   2二级火险   1一级火险
                                        logic.fireLevelIndex.value = 3;
                                        logic.getFireLevelList();
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
                                                CommonUtils().parseNull("${logic.fireLevelByStationList[2]}", "0"),
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
                                                            3
                                                        ? HhColors.levelColor3
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
                                    child: GestureDetector(
                                      onTap: () async {
                                        // 5五级火险   4四级火险   3三级火线   2二级火险   1一级火险
                                        logic.fireLevelIndex.value = 2;
                                        logic.getFireLevelList();
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
                                                CommonUtils().parseNull("${logic.fireLevelByStationList[3]}", "0"),
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
                                                            2
                                                        ? HhColors.levelColor2
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
                                    child: GestureDetector(
                                      onTap: () async {
                                        // 5五级火险   4四级火险   3三级火线   2二级火险   1一级火险
                                        logic.fireLevelIndex.value = 1;
                                        logic.getFireLevelList();
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
                                                CommonUtils().parseNull("${logic.fireLevelByStationList[4]}", "0"),
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
                                                            1
                                                        ? HhColors.levelColor1
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


  void deviceListDialog() {
    showModalBottomSheet(context: Get.context!, builder: (a){
      return Container(
        width: 1.sw,
        height: 0.6.sh,
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
                SizedBox(width: 15.w*3,),
                SizedBox(width: 50.w*3,child: Text('序号',style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3,fontWeight: FontWeight.w600),)),
                SizedBox(width: 145.w*3,child: Text('设备名称',textAlign:TextAlign.start,style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3,fontWeight: FontWeight.w600),)),
                Expanded(child: Text(logic.deviceStatus.value == 0?'离线状态':'创建时间',textAlign:TextAlign.start,style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3,fontWeight: FontWeight.w600),)),
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
            SizedBox(height: 10.w*3,),
            CommonUtils.line(margin: EdgeInsets.fromLTRB(20.w*3, 0, 20.w*3, 0),),
            Expanded(
              child: EasyRefresh(
                onRefresh: (){
                  logic.devicePageNo = 1;
                  logic.mainDeviceList();
                },
                onLoad: (){
                  logic.devicePageNo++;
                  logic.mainDeviceList();
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
        CommonUtils().parseRouteDetail(item);
      },
      child: Container(
        margin: EdgeInsets.only(top: 17.w*3),
        child: Row(
          children: [
            SizedBox(width: 15.w*3,),
            SizedBox(width: 50.w*3,child: Text('${index+1}',style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3,fontWeight: FontWeight.w400),)),
            SizedBox(width: 145.w*3,child: Text(CommonUtils().parseNull('${item["name"]}', ""),textAlign:TextAlign.start,maxLines:1,overflow: TextOverflow.ellipsis,style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3,fontWeight: FontWeight.w400),)),
            Expanded(child: Text(logic.deviceStatus.value == 0?parseOfflineDays('${item["alarmType"]}'):CommonUtils().parseLongTime('${item["createTime"]}'),textAlign:TextAlign.start,maxLines:1,overflow: TextOverflow.ellipsis,style: TextStyle(color: logic.deviceStatus.value == 0?HhColors.mainRedColor:HhColors.blackColor,fontSize: 14.sp*3,fontWeight: FontWeight.w400),)),
            SizedBox(width: 15.w*3,),
          ],
        ),
      ),
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

  Widget? liveWarningBuilder(BuildContext context, int index) {
    return InkWell(
      onTap: () async {
        showLiveWarningInfoDialog(logic.liveWarningList.value[index]);
        //logic.getLiveWarningInfo("${logic.liveWarningList.value[index]["id"]}");
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(15.w * 3, 12.w * 3, 15.w * 3, 0),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                CommonUtils().parseDeviceImageWarn(logic.liveWarningList.value[index]),
                width: 40.w*3,
                height: 40.w*3,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(width: 10.w*3,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${CommonUtils().parseNull("${logic.liveWarningList.value[index]['deviceName']}", "")}接收${parseAlarmType("${logic.liveWarningList.value[index]['alarmType']}")}",
                    maxLines: 1,
                    style: TextStyle(
                        color: HhColors.blackTextColor,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14.sp * 3,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 5.w*3,),
                  Text(
                    CommonUtils().parseLongTime("${logic.liveWarningList.value[index]['alarmTimestamp']}"),
                    maxLines: 1,
                    style: TextStyle(
                        color: HhColors.gray9TextColor,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14.sp * 3,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10.w * 3, 4.w * 3, 10.w * 3, 5.w * 3),
              decoration: BoxDecoration(
                  color: "${logic.liveWarningList.value[index]['auditStatus']}"=="1"?HhColors.levelBtnBackGreen:HhColors.levelBtnBack,
                  borderRadius: BorderRadius.circular(4.w * 3)),
              child: Text(
                "${logic.liveWarningList.value[index]['auditStatus']}"=="1"?"已处理":"未处理",
                style: TextStyle(
                    color: "${logic.liveWarningList.value[index]['auditStatus']}"=="1"?HhColors.backgroundColorGreen:HhColors.mainBlueColor,
                    fontSize: 13.sp * 3,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? fireLevelBuilder(BuildContext context, int index) {
    return HhTap(
      overlayColor: HhColors.trans,
      onTapUp: () {
        CommonUtils().parseRouteDetail(logic.fireLevelList.value[index]);
      },
      child: Container(
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
                CommonUtils().parseNull("${logic.fireLevelList.value[index]['name']}", ""),
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
                ///设备
                /*try{
                  List<double> end = ParseLocation.gps84_To_Gcj02(double.parse("${logic.fireLevelList.value[index]['latitude']}"), double.parse("${logic.fireLevelList.value[index]['longitude']}"),);
                  EventBusUtil.getInstance().fire(HhLoading(show: true));
                  *//*await QcAmapNavi.startNavigation(
                      fromLat: double.parse("${CommonData.latitude}"),
                      fromLng: double.parse("${CommonData.longitude}"),
                      fromName: "我的位置",
                      toLat: double.parse("${end[0]}"),
                      toLng: double.parse("${end[1]}"),
                      toName: "${logic.fireLevelList.value[index]['stationName']}",
                    );*//*
                  EventBusUtil.getInstance().fire(HhLoading(show: false));
                }catch(e){
                  HhLog.e(e.toString());
                  EventBusUtil.getInstance().fire(HhToast(title: "该定位不可用"));
                }*/
                EventBusUtil.getInstance().fire(HhToast(title: "跳转地图 - 地图暂未开发"));
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
      ),
    );
  }

  void menuTap(item) {
    if (item["title"] == "智慧立杆") {
      Get.to(() => DeviceListPage(), binding: DeviceListBinding(), arguments: {"productKey": CommonData.productKeyFireSmartPole,"title": "智慧立杆"});
    }
    if (item["title"] == "火险因子") {
      Get.to(() => DeviceListPage(), binding: DeviceListBinding(), arguments: {"productKey": CommonData.productKeyFireRiskFactor,"title": "火险因子"});
    }
    if (item["title"] == "报警管理") {

    }
    if (item["title"] == "全部设备") {
      Get.to(() => DeviceListPage(), binding: DeviceListBinding(), arguments: {"productKey": "","title": "全部"});
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

  parseOfflineDays(String type) {
    if(type == "offline3days"){
      return "离线3天";
    }
    if(type == "offline5days"){
      return "离线5天";
    }
    if(type == "offline10days"){
      return "离线10天";
    }
    if(type == "offlineOver10days"){
      return "离线10天以上";
    }
    return "离线";
  }

  String parseAlarmType(String s) {
    for(int i = 0;i < logic.typeList.length;i++){
      dynamic model = logic.typeList[i];
      if(model["alarmType"] == s){
        return model["alarmName"];
      }
    }
    return "报警";
  }

  void showLiveWarningInfoDialog(dynamic fireInfo) {
      CommonUtils.closeAllOverlays();
      showModalBottomSheet(context: Get.context!, builder: (context){
        return Container(
          width: 1.sw,
          height: 0.62.sh,
          decoration: BoxDecoration(
              color: HhColors.whiteColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.w*3))
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 10.w*3,),
              Row(
                children: [
                  SizedBox(width: 20.w*3,),
                  Text('报警详情',style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3,fontWeight: FontWeight.w600),),
                  const Expanded(child: SizedBox()),
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
                  SizedBox(width: 20.w*3,),
                ],
              ),
              Container(
                height: 0.5.w,
                width: 1.sw,
                margin: EdgeInsets.fromLTRB(20.w*3, 6.w*3, 20.w*3, 0),
                color: HhColors.grayDDTextColor,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ///报警时间
                      Container(
                        margin: EdgeInsets.fromLTRB(20.w*3, 10.w*3, 20.w*3, 0),
                        child: Row(
                          children: [
                            Text('报警时间',style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3),),
                            SizedBox(width: 10.w*3,),
                            Expanded(child: Text(CommonUtils().parseLongTime('${fireInfo["alarmTimestamp"]}'),textAlign:TextAlign.end,style: TextStyle(color: HhColors.gray9TextColor,fontSize: 14.sp*3),)),
                          ],
                        ),
                      ),
                      ///报警类型
                      Container(
                        margin: EdgeInsets.fromLTRB(20.w*3, 10.w*3, 20.w*3, 0),
                        child: Row(
                          children: [
                            Text('报警类型',style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3),),
                            SizedBox(width: 10.w*3,),
                            Expanded(child: Text(parseAlarmType(fireInfo["alarmType"]),textAlign:TextAlign.end,style: TextStyle(color: HhColors.mainBlueColor,fontSize: 14.sp*3),)),
                          ],
                        ),
                      ),
                      ///报警经纬度
                      Container(
                        margin: EdgeInsets.fromLTRB(20.w*3, 10.w*3, 20.w*3, 0),
                        child: Row(
                          children: [
                            Text('报警经纬度',style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3),),
                            SizedBox(width: 10.w*3,),
                            Expanded(child: Text("${CommonUtils().parseNull('${fireInfo["longitude"]}', "")},${CommonUtils().parseNull('${fireInfo["latitude"]}', "")}",textAlign:TextAlign.end,style: TextStyle(color: HhColors.gray9TextColor,fontSize: 14.sp*3),)),
                          ],
                        ),
                      ),
                      ///详细地址
                      Container(
                        width: 1.sw,
                        margin: EdgeInsets.fromLTRB(20.w*3, 10.w*3, 20.w*3, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('详细地址',style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3),),
                            SizedBox(height: 5.w*3,),
                            Text(CommonUtils().parseNull('${fireInfo["location"]}', ""),style: TextStyle(color: HhColors.gray9TextColor,fontSize: 14.sp*3),),
                          ],
                        ),
                      ),
                      ///报警图片
                      Container(
                        width: 1.sw,
                        margin: EdgeInsets.fromLTRB(20.w*3, 10.w*3, 20.w*3, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('报警图片',style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3),),
                            SizedBox(height: 10.w*3,),
                            HhTap(
                              overlayColor: HhColors.trans,
                              onTapUp: (){
                                CommonUtils().showPictureDialog(Get.context, url:"${CommonData.endpoint}${fireInfo['alarmImageUrl']}");
                              },
                              child: Image.network(
                                "${CommonData.endpoint}${fireInfo["alarmImageUrl"]}",
                                width: 50.w*3,
                                height: 50.w*3,
                                fit: BoxFit.fill,
                                errorBuilder: (BuildContext context,Object exception,StackTrace? stackTrace){
                                  return Image.asset(
                                    "assets/images/common/icon_no_picture_big.png",
                                    width: 1.sw,
                                    height: 0.45.sw,
                                    fit: BoxFit.fill,
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      ///按钮
                      Container(
                        height: 32.w*3,
                        width: 1.sw,
                        margin: EdgeInsets.fromLTRB(20.w*3, 20.w*3, 20.w*3, 0),
                        child: Row(
                          children: [
                            ///视频
                            Expanded(
                              child: HhTap(
                                overlayColor: HhColors.trans,
                                onTapUp: (){
                                  CommonUtils().parseRouteDetail(fireInfo);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: HhColors.whiteColor,
                                    borderRadius: BorderRadius.all(Radius.circular(4.w*3)),
                                    border: Border.all(color: HhColors.grayEEBackColor,width: 3.w),
                                  ),
                                  child: Text('视频',style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3,fontWeight: FontWeight.w500)),
                                ),
                              ),
                            ),
                            SizedBox(width: 15.w*3,),
                            ///auditStatus处理状态 1已处理 0未处理   ///auditResult处理结果 1真实 0误报
                            "${fireInfo["auditStatus"]}" == "1"?Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: HhColors.whiteColor,
                                  borderRadius: BorderRadius.all(Radius.circular(4.w*3)),
                                  border: Border.all(color: HhColors.grayEEBackColor,width: 3.w),
                                ),
                                child: Text("${fireInfo["auditResult"]}" == "1"?'真实':"误报",style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3,fontWeight: FontWeight.w500)),
                              ),
                            ):Expanded(
                              child: GestureDetector(
                                onTapDown: (details) {
                                  HhActionMenu.show(
                                    context: context,
                                    offset: details.globalPosition,
                                    direction: HhMenuDirection.top,
                                    itemDirection: HhItemDirection.vertical,
                                    //backgroundImage: 'assets/images/common/icon_pop_background.png',
                                    dx: 50.w*3,
                                    items: [
                                      BouncingWidget(
                                        duration: const Duration(milliseconds: 100),
                                        scaleFactor: 1.2,
                                        onPressed: (){
                                          HhActionMenu.dismiss();
                                          logic.alarmHandle("${fireInfo["id"]}", "1");
                                        },
                                        child: Container(
                                          color:HhColors.trans,
                                          padding: EdgeInsets.fromLTRB(35.w*3, 10.w*3, 35.w*3, 10.w*3),
                                          child: Text('真实', style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3,fontWeight: FontWeight.w200),),
                                        ),
                                      ),
                                      BouncingWidget(
                                        duration: const Duration(milliseconds: 100),
                                        scaleFactor: 1.2,
                                        onPressed: (){
                                          HhActionMenu.dismiss();
                                          logic.alarmHandle("${fireInfo["id"]}", "0");
                                        },
                                        child: Container(
                                          color:HhColors.trans,
                                          padding: EdgeInsets.fromLTRB(35.w*3, 10.w*3, 35.w*3, 10.w*3),
                                          child: Text('误报', style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3,fontWeight: FontWeight.w200),),
                                        ),
                                      )
                                    ],
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: HhColors.whiteColor,
                                    borderRadius: BorderRadius.all(Radius.circular(4.w*3)),
                                    border: Border.all(color: HhColors.grayEEBackColor,width: 3.w),
                                  ),
                                  child: Text('处理',style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3,fontWeight: FontWeight.w500)),
                                ),
                              ),
                            ),
                            SizedBox(width: 15.w*3,),
                            ///定位
                            Expanded(
                              child: HhTap(
                                overlayColor: HhColors.trans,
                                onTapUp: (){

                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: HhColors.whiteColor,
                                    borderRadius: BorderRadius.all(Radius.circular(4.w*3)),
                                    border: Border.all(color: HhColors.grayEEBackColor,width: 3.w),
                                  ),
                                  child: Text('定位',style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3,fontWeight: FontWeight.w500)),
                                ),
                              ),
                            ),
                            SizedBox(width: 15.w*3,),
                            ///导航
                            Expanded(
                              child: HhTap(
                                overlayColor: HhColors.trans,
                                onTapUp: (){

                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: HhColors.mainBlueColor,
                                    borderRadius: BorderRadius.all(Radius.circular(4.w*3)),
                                  ),
                                  child: Text('导航',style: TextStyle(color: HhColors.whiteColor,fontSize: 14.sp*3,fontWeight: FontWeight.w500)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },isDismissible: true,enableDrag: false,isScrollControlled: true,);
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

