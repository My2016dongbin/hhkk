import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/home/cell/HhTap.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'today_warning_controller.dart';

class TodayWarningPage extends StatelessWidget {
  final logic = Get.find<TodayWarningController>();

  TodayWarningPage({super.key});

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

        ///title
        BouncingWidget(
          duration: const Duration(milliseconds: 100),
          scaleFactor: 0.5,
          onPressed: () async {
            Get.back();
          },
          child: Container(
            margin: EdgeInsets.only(top: 30.w*3),
            padding: EdgeInsets.all(20.w*3),
            color: HhColors.trans,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/common/icon_back_left.png",
                  width: 9.w*3,
                  height: 16.w*3,
                  fit: BoxFit.fill,
                ),
                SizedBox(width: 12.w*3,),
                Text('今日报警',style: TextStyle(
                    color: HhColors.blackTextColor,
                    fontSize: 18.sp*3,
                    fontWeight: FontWeight.w600
                ),)
              ],
            ),
          ),
        ),

        ///搜索
        Align(
          alignment: Alignment.topRight,
          child: Container(
            height: 42.w*3,
            width: 0.45.sw,
            margin: EdgeInsets.fromLTRB(0, 42.w*3, 15.w*3, 0),
            padding: EdgeInsets.fromLTRB(12.w*3, 0, 12.w*3, 0),
            decoration: BoxDecoration(
              color: HhColors.whiteColor,
              borderRadius: BorderRadius.circular(20.w*3)
            ),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/common/icon_search.png",
                  width: 23.w*3,
                  height: 23.w*3,
                  fit: BoxFit.fill,
                ),
                SizedBox(width: 3.w*3,),
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
                      logic.refreshController.resetNoData();
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
                )
              ],
            ),
          ),
        ),
        ///筛选
        Container(
          margin: EdgeInsets.fromLTRB(15.w*3, 100.w*3, 15.w*3, 0),
          child: Row(
            children: [
              Expanded(
                child: HhTap(
                  borderRadius: BorderRadius.circular(20.w*3),
                  onTapUp: (){
                    showDeviceTypeFilter();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(15.w*3, 0, 15.w*3, 0),
                    height: 40.w*3,
                    decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.circular(20.w*3)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${logic.typeList[logic.deviceType.value]["title"]}',style: TextStyle(
                            color: HhColors.blackTextColor,
                            fontSize: 14.sp*3,
                            fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          width: 5.w*3,
                        ),
                        Image.asset(
                          "assets/images/common/icon_down_choose.png",
                          width: 7.w*3,
                          height: 6.w*3,
                          fit: BoxFit.fill,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 30.w*3,
              ),
              Expanded(
                child: HhTap(
                  borderRadius: BorderRadius.circular(20.w*3),
                  onTapUp: (){
                    showDeviceStatusFilter();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(15.w*3, 0, 15.w*3, 0),
                    height: 40.w*3,
                    decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius: BorderRadius.circular(20.w*3)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${logic.statusList[logic.deviceStatus.value]["title"]}',style: TextStyle(
                            color: HhColors.blackTextColor,
                            fontSize: 14.sp*3,
                            fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          width: 5.w*3,
                        ),
                        Image.asset(
                          "assets/images/common/icon_down_choose.png",
                          width: 7.w*3,
                          height: 6.w*3,
                          fit: BoxFit.fill,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        ///菜单
        Container(
          margin: EdgeInsets.fromLTRB(14.w*3, 155.w*3, 14.w*3, 20.w*3),
          decoration: BoxDecoration(
            color: HhColors.whiteColor,
            borderRadius: BorderRadius.circular(8.w*3)
          ),
          child: SmartRefresher(
            controller: logic.refreshController,
            enablePullUp: true,
            onRefresh: (){
              logic.refreshController.resetNoData();
              logic.pageNum = 1;
              logic.refreshController.refreshCompleted();
              logic.fetchPage();
            },
            onLoading: (){
              logic.pageNum++;
              logic.refreshController.loadComplete();
              logic.fetchPage();
            },
            child: PagedListView<int, dynamic>(
              padding: EdgeInsets.zero,
              pagingController: logic.listController,
              physics: const ClampingScrollPhysics(),
              builderDelegate: PagedChildBuilderDelegate<dynamic>(
                noItemsFoundIndicatorBuilder: (context) => CommonUtils().noneWidget(image:'assets/images/common/icon_no_message.png',info: '暂无设备',mid: 20.w,
                  height: 0.36.sw,
                  width: 0.44.sw,),
                firstPageProgressIndicatorBuilder: (context) => Container(),
                itemBuilder: (context, item, index) {
                  return InkWell(
                    onTap: (){

                    },
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 5.w*3, 0, 0),
                          padding: EdgeInsets.fromLTRB(15.w*3, 5.w*3, 15.w*3, 5.w*3),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              color: HhColors.whiteColor,
                              borderRadius: BorderRadius.all(Radius.circular(8.w*3))
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                CommonUtils().parseNull('${item['deviceName']}',""),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: HhColors.blackRealColor, fontSize: 15.sp*3,fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 8.w*3,),
                              SizedBox(
                                width: 1.sw,
                                child: Row(
                                  children: [
                                    Container(
                                      padding:EdgeInsets.fromLTRB(5.w*3, 1.w*3, 5.w*3, 1.w*3),
                                      decoration: BoxDecoration(
                                        color: "${item['deviceStatus']}"=="1"?HhColors.transBlue2Color:HhColors.grayEEBackColor,
                                        borderRadius: BorderRadius.circular(4.w*3)
                                      ),
                                      child: Text(
                                        "${item['deviceStatus']}"=="1"?'在线':'离线',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: "${item['deviceStatus']}"=="1"?HhColors.mainBlueColor:HhColors.gray9TextColor, fontSize: 12.sp*3),
                                      ),
                                    ),
                                    SizedBox(width: 10.w*3,),
                                    Text(
                                      CommonUtils().parseNull('${item['areaCodeName']}', ""),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: HhColors.gray9TextColor, fontSize: 14.sp*3),
                                    ),
                                    SizedBox(width: 10.w*3,),
                                    Expanded(
                                      child: Text(
                                        CommonUtils().parseNull('${item['address']}', ""),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: HhColors.gray9TextColor, fontSize: 14.sp*3),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: HhColors.line25Color,
                          height: 1.w,
                          width: 1.sw,
                          margin: EdgeInsets.fromLTRB(10.w*3, 6.w*3, 10.w*3, 0),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }


  void showDeviceTypeFilter() {
    showCupertinoDialog(context: Get.context!, builder: (BuildContext context) {
      return Obx(() =>GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: Material(
          color: HhColors.trans,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 0.7.sw,
                  height: 175.w*3,
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.circular(16.w*3)
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                            height: 30.w*3,
                            width: 1.sw,
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(0, 15.w*3, 0, 0),
                            child: Text("设备分类",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3,height: 1.2,fontWeight: FontWeight.bold),)
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.only(top: 50.w*3),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: buildDeviceTypeChildren(context)
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 0.5,
                          onPressed: () async {
                            Get.back();
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 14.w*3, 20.w*3, 0),
                            padding: EdgeInsets.all(10.w),
                            color: HhColors.trans,
                            child: Image.asset(
                              "assets/images/common/icon_up_x.png",
                              width: 12.w*3,
                              height: 12.w*3,
                              fit: BoxFit.fill,
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
      ));
    },barrierDismissible: true);
  }

  buildDeviceTypeChildren(context) {
    List<Widget> listW = [];
    for(int i = 0; i < logic.typeList.length; i++){
      dynamic typeModel = logic.typeList[i];
      listW.add(
          Container(
            height: 0.5.w,
            width: 1.sw,
            margin: EdgeInsets.fromLTRB(15.w*3, 0, 15.w*3, 0),
            color: HhColors.grayDDTextColor,
          ),
      );
      listW.add(
          HhTap(
            overlayColor: HhColors.grayDDTextColor.withAlpha(80),
            onTapUp: () async {
              logic.deviceType.value = i;
              Navigator.pop(context);

              logic.pageNum = 1;
              logic.refreshController.resetNoData();
              logic.fetchPage();
            },
            child: Container(
              height: 40.w*3,
              width: 1.sw,
              color: HhColors.trans,
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(0, 10.w*3, 0, 10.w*3),
              child: Text("${typeModel['title']}",style: TextStyle(color: logic.deviceType.value==i?HhColors.blueTextColor:HhColors.blackColor,fontSize: 14.sp*3,height: 1.2),),
            ),
          )
      );
    }
    return listW;
  }

  void showDeviceStatusFilter() {
    showCupertinoDialog(context: Get.context!, builder: (BuildContext context) {
      return Obx(() =>GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: Material(
          color: HhColors.trans,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 0.7.sw,
                  height: 175.w*3,
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.circular(16.w*3)
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                            height: 30.w*3,
                            width: 1.sw,
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(0, 15.w*3, 0, 0),
                            child: Text("状态分类",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3,height: 1.2,fontWeight: FontWeight.bold),)
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.only(top: 50.w*3),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: buildDeviceStatusChildren(context)
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 0.5,
                          onPressed: () async {
                            Get.back();
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 14.w*3, 20.w*3, 0),
                            padding: EdgeInsets.all(10.w),
                            color: HhColors.trans,
                            child: Image.asset(
                              "assets/images/common/icon_up_x.png",
                              width: 12.w*3,
                              height: 12.w*3,
                              fit: BoxFit.fill,
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
      ));
    },barrierDismissible: true);
  }

  buildDeviceStatusChildren(context) {
    List<Widget> listW = [];
    for(int i = 0; i < logic.statusList.length; i++){
      dynamic statusModel = logic.statusList[i];
      listW.add(
          Container(
            height: 0.5.w,
            width: 1.sw,
            margin: EdgeInsets.fromLTRB(15.w*3, 0, 15.w*3, 0),
            color: HhColors.grayDDTextColor,
          ),
      );
      listW.add(
          HhTap(
            overlayColor: HhColors.grayDDTextColor.withAlpha(80),
            onTapUp: () async {
              logic.deviceStatus.value = i;
              Navigator.pop(context);

              logic.pageNum = 1;
              logic.refreshController.resetNoData();
              logic.fetchPage();
            },
            child: Container(
              height: 40.w*3,
              width: 1.sw,
              color: HhColors.trans,
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(0, 10.w*3, 0, 10.w*3),
              child: Text("${statusModel['title']}",style: TextStyle(color: logic.deviceStatus.value==i?HhColors.blueTextColor:HhColors.blackColor,fontSize: 14.sp*3,height: 1.2),),
            ),
          )
      );
    }
    return listW;
  }

}
