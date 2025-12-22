import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/home/device/add/device_add_binding.dart';
import 'package:iot/pages/home/device/add/device_add_view.dart';
import 'package:iot/pages/home/message/message_setting/warn_setting_controller.dart';
import 'package:iot/pages/home/space/manage/edit/edit_binding.dart';
import 'package:iot/pages/home/space/manage/edit/edit_view.dart';
import 'package:iot/pages/home/space/space_binding.dart';
import 'package:iot/pages/home/space/space_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';

class WarnSettingPage extends StatelessWidget {
  final logic = Get.find<WarnSettingController>();

  WarnSettingPage({super.key});

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
          color: HhColors.backColorF5,
          padding: EdgeInsets.zero,
          child: Stack(
            children: [
              Container(
                color: HhColors.whiteColor,
                height: 88.w*3,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 54.w*3),
                  color: HhColors.trans,
                  child: Text(
                    '报警设置',
                    style: TextStyle(
                        color: HhColors.blackTextColor,
                        fontSize: 18.sp*3,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(23.w*3, 59.h*3, 0, 0),
                  padding: EdgeInsets.fromLTRB(0, 10.w, 20.w, 10.w),
                  color: HhColors.trans,
                  child: Image.asset(
                    "assets/images/common/ic_x.png",
                    height: 17.w*3,
                    width: 17.w*3,
                    fit: BoxFit.fill,
                  ),
                ),
              ),

              ///列表
              logic.testStatus.value ? deviceList() : const SizedBox(),



              ///确定全选按钮
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 70.w*3,
                  width: 1.sw,
                  padding: EdgeInsets.only(top: 12.w*3),
                  color: HhColors.whiteColor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 21.w*3,),
                      SizedBox(
                        height: 35.w*3,
                        child: Center(
                          child: Row(
                            children: [
                              Text(
                                '已选：',
                                style: TextStyle(
                                    color: HhColors.gray6TextColor, fontSize: 14.sp*3),
                              ),
                              Text(
                                '${logic.chooseListLeftNumber.value}条',
                                style: TextStyle(
                                    color: HhColors.gray6TextColor, fontSize: 14.sp*3),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 1.0,
                              onPressed: (){
                                if(logic.chooseListLeftNumber.value == 0){
                                  EventBusUtil.getInstance().fire(HhToast(title: "请至少选择一条数据"));
                                  return;
                                }
                                logic.commitSetting();
                              },
                              child: Container(
                                width: 90.w*3,
                                height: 35.w*3,
                                padding:EdgeInsets.fromLTRB(30.w, 15.w, 30.w, 15.w),
                                decoration: BoxDecoration(
                                    color: HhColors.mainBlueColor,
                                    borderRadius: BorderRadius.circular(8.w*3)
                                ),
                                child: Center(
                                  child: Text(
                                    '确定',
                                    style: TextStyle(
                                        color: HhColors.whiteColor, fontSize: 14.sp*3),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 9.w*3,),
                            BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 1.0,
                              onPressed: (){
                                chooseAll();
                              },
                              child: Container(
                                width: 90.w*3,
                                height: 35.w*3,
                                padding:EdgeInsets.fromLTRB(30.w, 15.w, 30.w, 15.w),
                                decoration: BoxDecoration(
                                    color: HhColors.whiteColor,
                                    border: Border.all(color: HhColors.mainBlueColor,width: 2.w),
                                    borderRadius: BorderRadius.circular(8.w*3)
                                ),
                                child: Center(
                                  child: Text(
                                    '全选',
                                    style: TextStyle(
                                        color: HhColors.mainBlueColor, fontSize: 14.sp*3),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 14.w*3,),
                          ],
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
    );
  }

  deviceList() {
    return Container(
      clipBehavior: Clip.hardEdge,
      //裁剪
      decoration: BoxDecoration(
          color: HhColors.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
      margin: EdgeInsets.fromLTRB(15.w*3, 100.w*3, 15.w*3, 97.w*3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(20.w*3, 10.w*3, 0, 0),
            child: Text(
              "请选择设备报警类型",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: HhColors.gray9TextColor,
                  fontSize: 15.sp*3,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: EasyRefresh(
              onRefresh: () {
                logic.getWarnType();
              },
              controller: logic.easyController,
              child: PagedListView<int, dynamic>(
                padding: EdgeInsets.zero,
                pagingController: logic.pagingController,
                builderDelegate: PagedChildBuilderDelegate<dynamic>(
                  firstPageProgressIndicatorBuilder: (c){
                    return Container();
                  }, // 关闭首次加载动画
                  newPageProgressIndicatorBuilder:  (c){
                    return Container();
                  },   // 关闭新页加载动画
                  noItemsFoundIndicatorBuilder: (context) => CommonUtils().noneWidget(
                    image: 'assets/images/common/no_message.png',
                    info: '暂无消息',
                    mid: 50.w,
                    height: 0.32.sw,
                    width: 0.6.sw,
                  ),
                  itemBuilder: (context, item, index) =>
                      gridItemView(context, item, index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  gridItemView(BuildContext context, dynamic item, int index) {
    return InkWell(
      onTap: () {
        // Get.to(()=>DeviceListPage(id: "${item['id']}",),binding: DeviceListBinding());
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(14.w*3, 9.w*3, 14.w*3, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///选择面板
                InkWell(
                  onTap: (){
                    item['chose'] = item['chose']==1?0:1;
                    logic.parseChooseNumber();
                    logic.testStatus.value = false;
                    logic.testStatus.value = true;
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(5.w*3, 5.w*3, 5.w*3, 5.w*3),
                        child: Image.asset(
                          item['chose']==1?"assets/images/common/yes.png":"assets/images/common/no.png",
                          width: 16.w*3,
                          height: 16.w*3,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 200.w*3),
                        child: Text(
                          "${item['alarmName']}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: item['chose']==1?HhColors.mainBlueColor:HhColors.blackColor,
                              fontSize: 15.sp*3,
                              fontWeight: FontWeight.w500),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  void chooseAll() {
    for(dynamic model in logic.spaceList){
      model["chose"] = 1;
    }
    logic.chooseListLeftNumber.value = logic.spaceList.length;
    logic.testStatus.value = false;
    logic.testStatus.value = true;
  }
}
