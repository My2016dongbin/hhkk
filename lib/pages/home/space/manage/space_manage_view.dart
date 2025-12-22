import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/home/device/add/device_add_binding.dart';
import 'package:iot/pages/home/device/add/device_add_view.dart';
import 'package:iot/pages/home/space/manage/edit/edit_binding.dart';
import 'package:iot/pages/home/space/manage/edit/edit_view.dart';
import 'package:iot/pages/home/space/manage/space_manage_controller.dart';
import 'package:iot/pages/home/space/space_binding.dart';
import 'package:iot/pages/home/space/space_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhColors.dart';

class SpaceManagePage extends StatelessWidget {
  final logic = Get.find<SpaceManageController>();

  SpaceManagePage({super.key});

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
                    '管理空间',
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
                    "assets/images/common/back.png",
                    height: 17.w*3,
                    width: 10.w*3,
                    fit: BoxFit.fill,
                  ),
                ),
              ),

              ///列表
              logic.testStatus.value ? deviceList() : const SizedBox(),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 1.sw,
                  height: 97.w*3,
                  color: HhColors.whiteColor,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 1.sw,
                  height: 0.5.w*3,
                  margin: EdgeInsets.only(bottom: 97.w*3),
                  color: HhColors.grayDDTextColor,
                ),
              ),

              ///新增空间按钮
              Align(
                alignment: Alignment.bottomCenter,
                child: BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: () {
                    Get.to(() => SpacePage(), binding: SpaceBinding());
                  },
                  child: Container(
                    height: 44.w*3,
                    width: 1.sw,
                    margin: EdgeInsets.fromLTRB(14.w*3, 0, 14.w*3, 35.w*3),
                    decoration: BoxDecoration(
                        color: HhColors.mainBlueColor,
                        borderRadius: BorderRadius.all(Radius.circular(22.w*3))),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "添加新空间",
                            style: TextStyle(
                              color: HhColors.whiteColor,
                              fontSize: 16.sp*3,
                            ),
                          ),
                        ],
                      ),
                    ),
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
      margin: EdgeInsets.fromLTRB(0, 88.w*3, 0, 97.w*3),
      child: EasyRefresh(
        onRefresh: () {
          logic.pageNum = 1;
          logic.getSpaceList(logic.pageNum);
        },
        // onLoad: () {
        //   logic.pageNum++;
        //   logic.getSpaceList(logic.pageNum);
        // },
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
            padding: EdgeInsets.fromLTRB(14.w*3, 15.w*3, 14.w*3, 15.w*3),
            clipBehavior: Clip.hardEdge,
            //裁剪
            decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///空间名
                InkWell(
                  onTap: (){
                    item['open'] = item['open']==true?false:true;
                    logic.testStatus.value = false;
                    logic.testStatus.value = true;
                    if(item['open'] == true){
    }
                  },
                  child: Row(
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: 200.w*3),
                        child: Text(
                          "${item['spaceName']}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: HhColors.blackColor,
                              fontSize: 15.sp*3,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(5.w*3, 0, 5.w*3, 0),
                              child: Image.asset(
                                item['open']==true?"assets/images/common/icon_top_status.png":"assets/images/common/icon_down_status.png",
                                width: 14.w*3,
                                height: 14.w*3,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                      ),
                      item['spaceName'] == '默认空间'
                          ? const SizedBox()
                          : InkWell(
                              onTap: () {
                                Get.to(() => EditPage(),
                                    binding: EditBinding(), arguments: item);
                              },
                              child: Container(
                                padding: EdgeInsets.all(5.w),
                                child: Text(
                                  "修改",
                                  style: TextStyle(
                                    color: HhColors.mainBlueColor,
                                    fontSize: 15.sp*3,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),

                ///设备列表

                item['open']==true?Column(
                  mainAxisSize: MainAxisSize.min,
                  children: buildItemDeviceList(item),
                ):const SizedBox()
              ],
            ),
          ),

          ///删除空间
          item['spaceName'] == '默认空间'
              ? const SizedBox()
              : Container(
            height: 1.w,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(1.w)),
            margin: EdgeInsets.fromLTRB(18.w*3, 0, 18.w*3, 0),
            child: DottedDashedLine(
              height: 0,
              width: 1.sw,
              axis: Axis.horizontal,
              dashColor: HhColors.grayDDTextColor,
            ),
          ),
          item['spaceName'] == '默认空间'
              ? const SizedBox()
              : InkWell(
            onTap: () {
              CommonUtils().showDeleteDialog(
                  context, "确定要删除“${item['spaceName']}”?\n请选择如何删除空间", () {
                Get.back();
                // logic.deleteChangeSpace(item['spaceId'],item['spaceId'],1);
                showChooseSpaceDialog(item);
              }, () {
                Get.back();
                logic.deleteChangeSpace(item['spaceId'],null,2);
              }, () {
                Get.back();
              }, leftStr: '设备转移后删除', rightStr: '全部删除');
            },
            child: Container(
              width: 1.sw,
              height: 50.w*3,
              margin: EdgeInsets.fromLTRB(14.w*3, 0, 14.w*3, 0),
              decoration: BoxDecoration(
                  color: HhColors.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(20.w))),
              child: Center(
                  child: Text(
                '删除空间',
                style: TextStyle(color: HhColors.mainRedColor, fontSize: 15.sp*3),
              )),
            ),
          ),
        ],
      ),
    );
  }

  void showChooseSpaceDialog(dynamic item) {
    showModalBottomSheet(context: logic.context, builder: (a){
      bool choose = false;
      return Container(
        width: 1.sw,
        decoration: BoxDecoration(
            color: HhColors.trans,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8.w*3))
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                width: 1.sw,
                height: 90.w,
                margin: EdgeInsets.fromLTRB(14.w*3, 15.w*3, 14.w*3, 25.w),
                decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 15.w*3,),
                    Text('空间删除后，将设备转移至',style: TextStyle(color: HhColors.gray9TextColor,fontSize: 14.sp*3),),
                    SizedBox(height: 20.w*3,),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: buildDialogSpace(item),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BouncingWidget(
              duration: const Duration(milliseconds: 100),
              scaleFactor: 1.2,
              child: Container(
                width: 1.sw,
                height: 50.w*3,
                margin: EdgeInsets.fromLTRB(14.w*3, 20.w*3, 14.w*3, 40.w*3),
                decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
                child: Center(
                  child: Text(
                    "取消",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: HhColors.blackColor, fontSize: 15.sp*3),
                  ),
                ),
              ),
              onPressed: () {
                Get.back();
              },
            )
          ],
        ),
      );
    },isDismissible: true,enableDrag: false,backgroundColor: HhColors.trans);
  }

  buildDialogSpace(dynamic item) {
    List<Widget> list = [];
    for(int i = 0;i < logic.spaceListMax.length;i++){
      dynamic model = logic.spaceListMax[i];
      if(model['id'] != item['id']){
        list.add(
            Container(
              margin: EdgeInsets.fromLTRB(13.w*3, 13.w*3, 13.w*3, 13.w*3),
              child: Row(
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 200.w*3),
                    child: Text(
                      "${model['name']}",
                      style: TextStyle(
                          color: HhColors.blackColor,
                          fontSize: 15.sp*3,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  InkWell(
                    onTap: () {
                      Get.back();
                      logic.deleteChangeSpace(item['id'],model['id'],1);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5.w),
                      child: Text(
                        "转移",
                        style: TextStyle(
                          color: HhColors.mainBlueColor,
                          fontSize: 15.sp*3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
        );
      }
    }
    return list;
  }

  buildItemDeviceList(dynamic item) {
    List<Widget> list = [];
    List<dynamic> deviceList = item['deviceList']??[];
    for(int i = 0;i < deviceList.length;i++){
      dynamic model = deviceList[i];
      list.add(SizedBox(height: 15.w*3,));
      list.add(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: HhColors.grayLineColor,
              height: 1.w*3,
              width: 1.sw,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 14.w*3, 0, 0.w*3),
              child: Row(
                children: [
                  Text(
                    "${model['deviceName']}",
                    style: TextStyle(
                        color: HhColors.blackColor,
                        fontSize: 15.sp*3,
                        fontWeight: FontWeight.w500),
                  ),
                  const Expanded(child: SizedBox()),
                  InkWell(
                    onTap: (){
                      model['isBlock'] = model['isBlock']==1?0:1;
                      logic.testStatus.value = false;
                      logic.testStatus.value = true;
                      logic.changeDeviceVisible(model);
                    },
                    child: Container(
                        padding: EdgeInsets.all(5.w*3),
                        margin: EdgeInsets.fromLTRB(10.w*3, 0, 12.w*3, 0),
                        child: Image.asset(model['isBlock']==1?'assets/images/common/icon_eye_hide.png':'assets/images/common/icon_eye_show.png',
                          height:18.w*3,width: 18.w*3,fit: BoxFit.fill,)
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Get.to(()=>DeviceAddPage(snCode: '${model['deviceNo']}',),binding: DeviceAddBinding(),arguments: model);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      child: Text(
                        "修改",
                        style: TextStyle(
                          color: HhColors.mainBlueColor,
                          fontSize: 15.sp*3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return list;
  }
}
