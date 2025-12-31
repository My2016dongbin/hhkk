import 'dart:math';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/share/share_binding.dart';
import 'package:iot/pages/common/share/share_view.dart';
import 'package:iot/pages/common/web/WebViewPage.dart';
import 'package:iot/pages/home/cell/HhTap.dart';
import 'package:iot/pages/home/device/add/device_add_binding.dart';
import 'package:iot/pages/home/device/add/device_add_view.dart';
import 'package:iot/pages/home/home_controller.dart';
import 'package:iot/pages/home/message/message_controller.dart';
import 'package:iot/pages/home/space/manage/space_manage_binding.dart';
import 'package:iot/pages/home/space/manage/space_manage_view.dart';
import 'package:iot/pages/home/video/fijkplayer/fijkplayer.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:iot/widgets/pop_menu.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:screenshot/screenshot.dart';
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
    return Scaffold(
      backgroundColor: HhColors.backColor,
      body: Obx(
            () => Container(
          height: 1.sh,
          width: 1.sw,
          padding: EdgeInsets.zero,
          // child: /*logic.secondStatus.value?*/(logic.pageListStatus.value ? listPage() : cardPage())/* : firstPage()*/,
                child:Stack(
                  children: [
                    Container(
                      height: 1.sh,
                      width: 1.sw,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: CommonUtils().gradientColors()),
                      ),
                    ),
                    Column(
                      children: [
                        ///模式切换&&搜索框&&添加按钮
                        Container(
                          margin: EdgeInsets.fromLTRB(20.w*3, 50.h*3, 0, 0),
                          child: Row(
                            children: [
                              //列表模式
                              BouncingWidget(
                                duration: const Duration(milliseconds: 100),
                                scaleFactor: 0.2,
                                onPressed: (){
                                  //已在列表模式再次点击展示视频树
                                  if(logic.pageListStatus.value){
                                    showVideoTreeDrawer(context);
                                  }
                                  logic.pageListStatus.value = true;
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right:14.w*3),
                                  color: HhColors.trans,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        logic.pageListStatus.value?"assets/images/common/video_list_select.png":"assets/images/common/video_list_un.png",
                                        width: 22.w*3,
                                        height: 22.w*3,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(height: 2.w*3,),
                                      Text('列表模式', style: TextStyle(color: logic.pageListStatus.value?HhColors.mainBlueColor:HhColors.gray9TextColor,fontSize: 10.sp*3,fontWeight: FontWeight.w200),),
                                    ],
                                  ),
                                ),
                              ),
                              //卡片模式
                              BouncingWidget(
                                duration: const Duration(milliseconds: 100),
                                scaleFactor: 0.2,
                                onPressed: (){
                                  logic.pageListStatus.value = false;
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right:14.w*3),
                                  color: HhColors.trans,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        logic.pageListStatus.value?"assets/images/common/video_card_un.png":"assets/images/common/video_card_select.png",
                                        width: 22.w*3,
                                        height: 22.w*3,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(height: 2.w*3,),
                                      Text('卡片模式', style: TextStyle(color: logic.pageListStatus.value?HhColors.gray9TextColor:HhColors.mainBlueColor,fontSize: 10.sp*3,fontWeight: FontWeight.w200),),
                                    ],
                                  ),
                                ),
                              ),
                              //搜索框
                              logic.pageListStatus.value?const Spacer():Expanded(
                                child: Container(
                                  height: 38.w*3,
                                  margin: EdgeInsets.only(right: 14.w*3),
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
                                          child:TextField(
                                            textAlign: TextAlign.left,
                                            maxLines: 1,
                                            cursorColor: HhColors.titleColor_99,
                                            controller: logic.searchController,
                                            keyboardType: TextInputType.text,
                                            textInputAction: TextInputAction.search,
                                            onSubmitted: (s){
                                              ///搜索
                                              logic.getDeviceList(1, true);
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
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //添加按钮
                              BouncingWidget(
                                duration: const Duration(milliseconds: 100),
                                scaleFactor: 0.2,
                                onPressed: (){
                                  Get.to(()=>DeviceAddPage(snCode: '',),binding: DeviceAddBinding());
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right:14.w*3),
                                  color: HhColors.trans,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/images/common/ic_add.png",
                                        width: 24.w*3,
                                        height: 24.w*3,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(height: 2.w*3,),
                                      Text('添加', style: TextStyle(color: HhColors.textBlackColor,fontSize: 10.sp*3,fontWeight: FontWeight.w200),),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ///天气&&地区
                        InkWell(
                          onTap: (){
                            Get.to(WebViewPage(title: '天气', url: 'https://www.qweather.com/weather/qingdao-101120201.html',));
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 17.w*3),
                            height: 36.w*3,
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
                        ),

                        ///列表模式页面&&卡片模式页面
                        logic.pageListStatus.value?listPage(context):cardPage(context)
                      ],
                    ),

                  ],
                )
        ),
      ),
    );
  }

  ///主页-列表模式视图
  listPage(context) {
    return logic.videoIndex.value == 999?const SizedBox():Expanded(
      child: Column(
        children: [
          ///标题&&多画面切换
          Container(
            margin: EdgeInsets.fromLTRB(25.w*3, 10.w*3, 15.w*3, 5.w*3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: (){
                    showVideoTreeDrawer(context);
                  },
                  child: Container(
                    color: HhColors.trans,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/common/icon_video_tab.png",
                          width: 29.w*3,
                          height: 26.w*3,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(width: 10.w*3,),
                        Text('视频树',style: TextStyle(color: HhColors.blackTextColor,fontSize: 14.sp*3,fontWeight: FontWeight.w400),),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTapDown: (details) {
                    HhActionMenu.show(
                      context: context,
                      offset: details.globalPosition,
                      direction: HhMenuDirection.bottom,
                      //backgroundImage: 'assets/images/common/icon_pop_background.png',
                      dx: 40.w*3,
                      items: [
                        HhTap(
                          overlayColor: HhColors.trans,
                          onTapUp: (){
                            HhActionMenu.dismiss();
                            logic.videoCount.value = 1;
                          },
                          child: Container(
                            width: 0.33.sw,
                            padding: EdgeInsets.fromLTRB(0, 20.w*3, 0, 15.w*3),
                            color: HhColors.trans,
                            child: Image.asset(
                              logic.videoCount.value==1?"assets/images/common/icon_video_1_select.png":"assets/images/common/icon_video_1.png",
                              width: 24.w * 3,
                              height: 24.w * 3,
                            ),
                          ),
                        ),
                        HhTap(
                          overlayColor: HhColors.trans,
                          onTapUp: (){
                            HhActionMenu.dismiss();
                            logic.videoCount.value = 4;
                          },
                          child: Container(
                            width: 0.33.sw,
                            padding: EdgeInsets.fromLTRB(0, 20.w*3, 0, 15.w*3),
                            color: HhColors.trans,
                            child: Image.asset(
                              logic.videoCount.value==4?"assets/images/common/icon_video_4_select.png":"assets/images/common/icon_video_4.png",
                              width: 24.w * 3,
                              height: 24.w * 3,
                            ),
                          ),
                        ),
                        HhTap(
                          overlayColor: HhColors.trans,
                          onTapUp: (){
                            HhActionMenu.dismiss();
                            logic.videoCount.value = 8;
                          },
                          child: Container(
                            width: 0.33.sw,
                            padding: EdgeInsets.fromLTRB(0, 20.w*3, 0, 15.w*3),
                            color: HhColors.trans,
                            child: Image.asset(
                              logic.videoCount.value==8?"assets/images/common/icon_video_8_select.png":"assets/images/common/icon_video_8.png",
                              width: 24.w * 3,
                              height: 24.w * 3,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  child: Container(
                    color: HhColors.trans,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/common/icon_video_${logic.videoCount.value}.png",
                          width: 24.w*3,
                          height: 24.w*3,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(height: 2.w*3,),
                        Text('画面', style: TextStyle(color: HhColors.textBlackColor,fontSize: 10.sp*3,fontWeight: FontWeight.w200),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ///视频卡片列表
          Expanded(
            child: logic.videoStatus.value?Container(
              margin: EdgeInsets.fromLTRB(15.w*3, 0, 15.w*3, 0),
              width: 1.sw,
              alignment: Alignment.topCenter,
              child: GridView.builder(
                padding: EdgeInsets.fromLTRB(0, 10.w*3, 0, 10.w*3),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: logic.videoCount.value==1?1:2/*sqrt(logic.videoCount.value).toInt()*/,
                  crossAxisSpacing: 10.w*3,
                  mainAxisSpacing: 10.w*3,
                  childAspectRatio: 168 / 123,
                ),
                itemCount: logic.videoCount.value,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: (){
                      if(CommonData.checkedChannels[index]["url"]==null){
                        showVideoTreeDrawer(context);
                      }
                      logic.videoIndex.value = index;
                    },
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: HhColors.gray6EColor,
                          borderRadius: BorderRadius.circular(16.w*3)
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          //边框
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.w*3),
                              border: logic.videoIndex.value == index?Border.all(color: HhColors.mainBlueColor,width: 5.w):null,
                            ),
                          ),
                          CommonData.checkedChannels[index]["url"]!=null?Column(
                            children: [
                              Expanded(
                                child: VideoPlayerWidget(
                                  key: ValueKey("${CommonData.checkedChannels[index]["url"]}"),
                                  url: "${CommonData.checkedChannels[index]["url"]}",
                                  onOuterTap: () {
                                    logic.videoIndex.value = index;
                                  },
                                ),
                              ),
                              Container(
                                color: HhColors.whiteColor,
                                padding: logic.videoCount.value==1?EdgeInsets.fromLTRB(15.w*3, 8.w*3, 15.w*3, 8.w*3):EdgeInsets.fromLTRB(10.w*3, 4.w*3, 10.w*3, 4.w*3),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(CommonUtils().parseNull("${CommonData.checkedChannels[index]["id"]}", ""),style: TextStyle(color: HhColors.textBlackColor,fontSize: 12.sp*3),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                    ),
                                    SizedBox(width: 5.w*3,),
                                    InkWell(
                                      onTap: (){
                                        CommonData.removeChannel("${CommonData.checkedChannels[index]["id"]}");
                                        logic.videoStatus.value = false;
                                        logic.videoStatus.value = true;
                                      },
                                      child: Container(
                                        color: HhColors.trans,
                                        padding: EdgeInsets.all(2.w*3),
                                        child: Image.asset(
                                          "assets/images/common/icon_video_close.png",
                                          width: logic.videoCount.value==1?16.w*3:12.w*3,
                                          height: logic.videoCount.value==1?16.w*3:12.w*3,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ):Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/images/common/icon_video_adding.png",
                                width: logic.videoCount.value==1?32.w*3:28.w*3,
                                height: logic.videoCount.value==1?32.w*3:28.w*3,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(height: 10.w*3,),
                              Text('请点击左侧视频树\n选择视频', textAlign: TextAlign.center,style: TextStyle(color: HhColors.grayB6Color,fontSize: logic.videoCount.value==1?14.sp*3:12.sp*3,fontWeight: FontWeight.w400),)
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ):const SizedBox()),
        ],
      ),
    );
  }

  ///主页-卡片模式视图
  cardPage(context) {
    return logic.containStatus.value?Expanded(
      child: Column(
        children: [
          ///分组列表滚动
          SizedBox(
            height: 45.w*3,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: logic.spaceListStatus.value?Container(
                    margin: EdgeInsets.fromLTRB(10.w*3, 0, 70.w*3, 10.w),
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
                  alignment: Alignment.centerRight,
                  child: BouncingWidget(
                    duration: const Duration(milliseconds: 100),
                    scaleFactor: 0.2,
                    onPressed: (){

                      Get.to(() => SpaceManagePage(),
                          binding: SpaceManageBinding());
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0,0.w*3,14.w*3,0),
                      // padding: EdgeInsets.fromLTRB(22.w*3, 25.w*3, 15.w*3, 24.w*3),
                      color: HhColors.trans,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/images/common/ic_setting.png",
                            width: 22.w*3,
                            height: 22.w*3,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(height: 2.w*3,),
                          Text('分组设置', style: TextStyle(color: HhColors.textBlackColor,fontSize: 10.sp*3,fontWeight: FontWeight.w200),),
                        ],
                      ),
                    ),
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
                              scaleFactor: 0.2,
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
        ],
      ),
    ):const SizedBox();
  }

  ///主页-卡片模式设备列表视图-网格列表itemView
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
              showEditDeviceDialog(item,context);
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
                          scaleFactor: 0.2,
                          onPressed: (){
                            homeLogic.index.value = 2;
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
                          scaleFactor: 0.2,
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
                      scaleFactor: 0.2,
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
                        child: Text('进入默认分组',style: TextStyle(color: HhColors.whiteColor,fontSize: 13.sp*3),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BouncingWidget(
              duration: const Duration(milliseconds: 100),
              scaleFactor: 0.2,
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

  void showEditDeviceDialog(item,context) {
    showCupertinoDialog(context: context, builder: (context) => Center(
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
                scaleFactor: 0.2,
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
                scaleFactor: 0.2,
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
                scaleFactor: 0.2,
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


  /// 显示左侧弹窗
  void showVideoTreeDrawer(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        double barHeight = MediaQuery.of(Get.context!).padding.top;
        return Obx(() => Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Material(
              color: HhColors.whiteBack,
              child: Padding(
                padding: EdgeInsets.only(top: barHeight),
                child: EasyRefresh(
                  onRefresh: () {
                    logic.getTreeDetail();
                  },
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: 1.sh - barHeight,
                      child: Column(
                        children: [
                          SizedBox(height: 25.w*3,),
                          /// 标题栏
                          Container(
                            height: 40.w*3,
                            margin: EdgeInsets.fromLTRB(15.w*3, 0, 15.w*3, 0),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                HhTap(
                                  overlayColor: HhColors.trans,
                                  onTapUp: (){
                                    logic.treeIndex.value = 0;
                                    logic.getTreeDetail();
                                  },
                                  child: Container(
                                    color: HhColors.trans,
                                    height: 40.w*3,
                                    margin: EdgeInsets.only(right: 20.w*3),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "设备",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: logic.treeIndex.value==0?HhColors.blackTextColor:HhColors.gray9TextColor,
                                            fontSize: logic.treeIndex.value==0?18.sp*3:14.sp*3,
                                            fontWeight: logic.treeIndex.value==0?FontWeight.w600:FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 2.w*3,),
                                        logic.treeIndex.value==0?Container(
                                          decoration: BoxDecoration(
                                              color: HhColors.blackTextColor,
                                              borderRadius: BorderRadius.circular(2.w*3)
                                          ),
                                          height: 3.w*3,
                                          width: 15.w*3,
                                        ):const SizedBox()
                                      ],
                                    ),
                                  ),
                                ),
                                HhTap(
                                  overlayColor: HhColors.trans,
                                  onTapUp: (){
                                    logic.treeIndex.value = 1;
                                    logic.getTreeDetail();
                                  },
                                  child: Container(
                                    color: HhColors.trans,
                                    height: 40.w*3,
                                    margin: EdgeInsets.only(right: 20.w*3),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "收藏",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: logic.treeIndex.value==1?HhColors.blackTextColor:HhColors.gray9TextColor,
                                            fontSize: logic.treeIndex.value==1?18.sp*3:14.sp*3,
                                            fontWeight: logic.treeIndex.value==1?FontWeight.w600:FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 2.w*3,),
                                        logic.treeIndex.value==1?Container(
                                          decoration: BoxDecoration(
                                              color: HhColors.blackTextColor,
                                              borderRadius: BorderRadius.circular(2.w*3)
                                          ),
                                          height: 3.w*3,
                                          width: 15.w*3,
                                        ):const SizedBox()
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// 搜索框
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.w*3, vertical: 10.w*3),
                            padding: EdgeInsets.symmetric(horizontal: 5.w*3),
                            decoration: BoxDecoration(
                              color: HhColors.whiteBackSearch,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/common/icon_search.png",
                                  height: 22.w*3,
                                  width: 22.w*3,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(width: 2.w*3),
                                Expanded(
                                  child: TextField(
                                    controller: logic.searchTreeController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "请输入设备名称",
                                      hintStyle: TextStyle(color: HhColors.gray9TextColor),
                                    ),
                                    style: TextStyle(fontSize: 14.sp*3),
                                    textInputAction: TextInputAction.search,
                                    onSubmitted: (s){
                                      HhLog.d("onSubmitted $s");
                                      CommonData.videoSearch = s;
                                      logic.treeDetail.clear();
                                      logic.getTreeDetail();
                                    },
                                    onChanged: (s){
                                      HhLog.d("onChanged $s");
                                      CommonData.videoSearch = s;
                                      logic.treeDetail.clear();
                                      logic.getTreeDetail();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          ///视频树
                          Expanded(
                            child: Container(
                              width: 1.sw,
                              decoration: BoxDecoration(
                                  color: HhColors.whiteColor,
                                  borderRadius: BorderRadius.circular(8.w*3)
                              ),
                              margin: EdgeInsets.fromLTRB(15.w*3, 0, 15.w*3, 10.w*3),
                              child: ListView.builder(
                                padding: EdgeInsets.fromLTRB(10.w*3, 0, 10.w*3, 0),
                                scrollDirection: Axis.vertical,
                                itemCount: logic.treeDetail.length, itemBuilder: (context, index){
                                return TreeNodeWidget(
                                  node: logic.treeDetail.value[index],
                                  onTap: (node) {
                                    HhLog.d("${node["nodeName"]}");
                                  },
                                  onDeviceTap: (device) {
                                    HhLog.d("${device["name"]}");
                                  },
                                  onStarTap: (channel,star,deviceType) async {
                                    HhLog.d("$channel $star");
                                    HhLog.d("${channel["channelName"]} $star");
                                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                                    String userId = prefs.getString(SPKeys().id)??"";
                                    if(star){
                                      logic.collection(userId,"${channel["id"]}");
                                    }else{
                                      logic.disCollection(userId,"${channel["id"]}");
                                    }
                                  },
                                  onChannelTap: (channel,checked) {
                                    HhLog.d("${channel["channelName"]} $checked");
                                    if(checked){
                                      logic.getStream(channel);
                                    }else{
                                      CommonData.removeChannel("${channel["id"]}");
                                      logic.videoStatus.value = false;
                                      logic.videoStatus.value = true;
                                    }
                                  },
                                );
                              },
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation =
        Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
            .animate(animation);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

}


class TreeNodeWidget extends StatefulWidget {
  final dynamic node;
  final int level;
  final ValueChanged<dynamic>? onTap;
  final ValueChanged<dynamic>? onDeviceTap;
  final void Function(dynamic device, bool star,String deviceType)? onStarTap;
  final void Function(dynamic device, bool star)? onChannelTap;

  const TreeNodeWidget({
    Key? key,
    required this.node,
    this.level = 0,
    this.onTap,
    this.onDeviceTap,
    this.onStarTap,
    this.onChannelTap,
  }) : super(key: key);

  @override
  State<TreeNodeWidget> createState() => _TreeNodeWidgetState();
}

class _TreeNodeWidgetState extends State<TreeNodeWidget> {
  bool expanded = false; // 展开状态

  @override
  void initState() {
    expanded = CommonUtils().parseContainChannels(widget.node,CommonData.checkedChannels);
    if(CommonData.videoSearch.isNotEmpty){
      expanded = widget.node.toString().contains(CommonData.videoSearch);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> devices = widget.node["children"] ?? [];


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            setState(() {
              expanded = !expanded;
            });
            if (widget.onTap != null) widget.onTap!(widget.node);
          },
          child: Container(
            height: 48.w*3,
            padding: EdgeInsets.only(left: widget.level * 15.w*3),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                //展开箭头
                AnimatedRotation(
                  turns: expanded ? 0.25 : 0, //旋转90度
                  duration: const Duration(milliseconds: 200),
                  child: Image.asset(
                    'assets/images/common/icon_down_choose2.png',
                    height: 7.w*3,
                    width: 9.w*3,
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(width: 5.w*3),

                //节点
                Expanded(
                  child: Text(
                    widget.node["name"] ?? "未命名节点",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: HhColors.blackTextColor,
                      fontSize: 14.sp*3,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        //分割线
        Container(
          color: HhColors.line25Color,
          height: 2.w,
        ),

        //设备
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: expanded
              ? Column(
            children: List.generate(devices.length, (i) {
              return TreeDeviceWidget(
                device: devices[i],
                level: widget.level + 1,
                onTap: widget.onDeviceTap,
                onStarTap: widget.onStarTap,
                onChannelTap: widget.onChannelTap,
              );
            }),
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class TreeDeviceWidget extends StatefulWidget {
  final dynamic device;
  final int level;
  final ValueChanged<dynamic>? onTap;
  final void Function(dynamic channel, bool star,String deviceType)? onStarTap;
  final void Function(dynamic channel, bool star)? onChannelTap;

  const TreeDeviceWidget({
    Key? key,
    required this.device,
    this.level = 0,
    this.onTap,
    this.onStarTap,
    this.onChannelTap,
  }) : super(key: key);

  @override
  State<TreeDeviceWidget> createState() => _TreeDeviceWidgetState();
}

class _TreeDeviceWidgetState extends State<TreeDeviceWidget> {
  bool expanded = false; // 展开状态

  bool show = true; //搜索显示状态

  @override
  void initState() {
    expanded = CommonUtils().parseContainChannels(widget.device,CommonData.checkedChannels);
    if(CommonData.videoSearch.isNotEmpty){
      expanded = "${widget.device["name"]}".contains(CommonData.videoSearch);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> channels = widget.device["children"] ?? [];

    return show?Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            setState(() {
              expanded = !expanded;
            });
            if (widget.onTap != null) widget.onTap!(widget.device);
          },
          child: Container(
            height: 48.w*3,
            padding: EdgeInsets.only(left: widget.level * 15.w*3),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                //展开箭头
                AnimatedRotation(
                  turns: expanded ? 0.25 : 0, //旋转90度
                  duration: const Duration(milliseconds: 200),
                  child: Image.asset(
                    'assets/images/common/icon_down_choose2.png',
                    height: 7.w*3,
                    width: 9.w*3,
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(width: 5.w*3),

                //节点
                Text(
                  widget.device["name"] ?? "未命名设备",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: HhColors.blackTextColor,
                    fontSize: 14.sp*3,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer()
              ],
            ),
          ),
        ),

        //分割线
        Container(
          color: HhColors.line25Color,
          height: 2.w,
        ),

        //子节点-channels
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: expanded
              ? Column(
            children: List.generate(channels.length, (i) {
              return TreeChannelWidget(
                key: Key("${channels[i]["id"]}${Random().nextInt(100)}"),
                channel: channels[i],
                onChannelTap: widget.onChannelTap,
                level: widget.level + 1,
                onStarTap: (channel,star){
                  widget.onStarTap!(channel, star,"${widget.device["deviceType"]}");
                },
              );
            }),
          )
              : const SizedBox.shrink(),
        ),
      ],
    ):const SizedBox();
  }
}

class TreeChannelWidget extends StatefulWidget {
  final dynamic channel;
  final int level;
  final void Function(dynamic channel, bool star)? onStarTap;
  final void Function(dynamic channel, bool star)? onChannelTap;

  const TreeChannelWidget({
    Key? key,
    required this.channel,
    this.level = 0,
    this.onStarTap,
    this.onChannelTap,
  }) : super(key: key);

  @override
  State<TreeChannelWidget> createState() => _TreeChannelWidgetState();
}

class _TreeChannelWidgetState extends State<TreeChannelWidget> {
  bool checked = false; //选中状态
  StreamSubscription? refreshSubscription;
  bool star = false; // 收藏状态

  @override
  void initState() {
    checked = CommonUtils().parseContainChannels(widget.channel,CommonData.checkedChannels);

    refreshSubscription =
        EventBusUtil.getInstance().on<TreeChannelRefresh>().listen((event) {
          setState(() {
            checked = CommonUtils().parseContainChannels(widget.channel,CommonData.checkedChannels);
          });
        });
    star = "${widget.channel["collectFlag"]}"=="1";
    super.initState();
  }

  @override
  void dispose() {
    try {
      refreshSubscription!.cancel();
    } catch (e) {
      //
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            setState(() {
              checked = !checked;
            });
            if (widget.onChannelTap != null) widget.onChannelTap!(widget.channel,checked);
          },
          child: Container(
            height: 48.w*3,
            padding: EdgeInsets.only(left: widget.level * 15.w*3),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                //选中状态
                Image.asset(
                  checked?'assets/images/common/yes.png':'assets/images/common/no.png',
                  height: 17.w*3,
                  width: 17.w*3,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 10.w*3),
                //图标
                Image.asset(
                  'assets/images/common/device_online.png',
                  height: 17.w*3,
                  width: 17.w*3,
                  fit: BoxFit.contain,
                ),

                SizedBox(width: 5.w*3),

                //频道
                Expanded(
                  child: Text(
                    widget.channel["name"] ?? "未命名频道",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: checked?HhColors.mainBlueColor:HhColors.blackTextColor,
                      fontSize: 14.sp*3,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                //收藏
                InkWell(
                  onTap: (){
                    setState(() {
                      star = !star;
                    });
                    if (widget.onStarTap != null) widget.onStarTap!(widget.channel,star);
                  },
                  child: Container(
                    color: HhColors.trans,
                    padding: EdgeInsets.all(10.w*3),
                    child: Image.asset(
                      star?'assets/images/common/device_star.png':'assets/images/common/device_un_star.png',
                      height: 17.w*3,
                      width: 17.w*3,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: 10.w*3)
              ],
            ),
          ),
        ),

        //分割线
        Container(
          color: HhColors.line25Color,
          height: 2.w,
        ),

      ],
    );
  }
}
