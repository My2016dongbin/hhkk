import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/home/cell/HhTap.dart';
import 'package:iot/pages/home/device/add/device_add_binding.dart';
import 'package:iot/pages/home/device/add/device_add_view.dart';
import 'package:iot/pages/home/my/scan/scan_binding.dart';
import 'package:iot/pages/home/my/scan/scan_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/widgets/pop_menu.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:screenshot/screenshot.dart';

import 'device_list_controller.dart';

class DeviceListPage extends StatelessWidget {
  final logic = Get.find<DeviceListController>();

  DeviceListPage({super.key});

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
                Text(logic.title.value,style: TextStyle(
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
            margin: EdgeInsets.fromLTRB(0, 42.w*3, 65.w*3, 0),
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
        ///添加设备
        Align(
          alignment: Alignment.topRight,
          child: BouncingWidget(
            duration: const Duration(milliseconds: 100),
            scaleFactor: 0.5,
            onPressed: () async {
              Get.to(() => ScanPage(), binding: ScanBinding());
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 43.w * 3, 15.w * 3, 0),
              color: HhColors.trans,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/images/common/icon_scanner.png",
                    width: 22.w * 3,
                    height: 22.w * 3,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(height: 3.w*3),
                  Text("添加设备",style: TextStyle(color: HhColors.blackTextColor,fontSize: 10.sp*3),)
                ],
              ),
            ),
          ),
        ),

        ///菜单
        Container(
          margin: EdgeInsets.fromLTRB(14.w*3, 95.w*3, 14.w*3, 20.w*3),
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
                  final GlobalKey moreKey = GlobalKey();
                  return InkWell(
                    onTap: (){
                      CommonUtils().parseRouteDetail(item);
                    },
                    child: SizedBox(
                      height: 75.w*3,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(15.w*3, 5.w*3, 15.w*3, 5.w*3),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  color: HhColors.whiteColor,
                                  borderRadius: BorderRadius.all(Radius.circular(8.w*3))
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 50.w*3,
                                    width: 50.w*3,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4.w*3)
                                    ),
                                    child: item['status']==1?CommonUtils.parseCacheImageView('${item['deviceNo']}',item):Image.asset(
                                      "assets/images/common/icon_offline_image.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 10.w*3,),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 90.w*3),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            CommonUtils().parseNull('${item['name']}',""),
                                            maxLines: 1,
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
                                                    color: "${item['status']}"=="1"?HhColors.transBlue2Color:HhColors.transRed2Color,
                                                    borderRadius: BorderRadius.circular(4.w*3)
                                                  ),
                                                  child: Text(
                                                    "${item['status']}"=="1"?'在线':'离线',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                        color: "${item['status']}"=="1"?HhColors.mainBlueColor:HhColors.mainRedColor, fontSize: 12.sp*3),
                                                  ),
                                                ),
                                                SizedBox(width: 10.w*3,),
                                                Expanded(
                                                  child: Text(
                                                    CommonUtils().parseNull('${item['spaceName']}', ""),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: HhColors.gray9TextColor, fontSize: 14.sp*3),
                                                  ),
                                                ),
                                                SizedBox(width: 10.w*3,),
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
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: EdgeInsets.only(right: 15.w*3),
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  '${item['productKey']}'==CommonData.productKeyFireRiskFactor? Text(
                                    parseLevelText('${item['fireLevel']}'),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: parseLevelColor('${item['fireLevel']}'), fontSize: 14.sp*3),
                                  ):Container(
                                    width: 25.w*3,
                                    height: 25.w*3,
                                    margin: EdgeInsets.only(right: 5.w*3),
                                    child: Image.asset(
                                      "assets/images/common/icon_live.png",
                                      width: 25.w*3,
                                      height: 25.w*3,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  SizedBox(width: 10.w*3,),
                                  GestureDetector(
                                    onTapDown: (details) {
                                      HhActionMenu.show(
                                        context: context,
                                        offset: details.globalPosition,
                                        direction: HhMenuDirection.bottom,
                                        backgroundImage: 'assets/images/common/icon_pop_background.png',
                                        dx: 40.w*3,
                                        items: [
                                          PopMenuItem(title: "修改", image: "assets/images/common/icon_pop_edit.png", onTap: (){
                                            Get.to(
                                                    () => DeviceAddPage(
                                                  snCode: '${item['deviceNo']}',
                                                ),
                                                binding: DeviceAddBinding(),
                                                arguments: item);
                                          }),
                                          PopMenuItem(title: "地图", image: "assets/images/common/icon_pop_map.png", onTap: (){}),
                                          PopMenuItem(title: "删除", image: "assets/images/common/icon_pop_delete.png", color: HhColors.mainRedColor, onTap: (){
                                            CommonUtils().showDeleteDialog(
                                                context,
                                                '确定要删除“${item['name']}”?\n删除设备后无法恢复', () {
                                              Get.back();
                                            }, () {
                                              Get.back();
                                              logic.deleteDevice(item);
                                            }, () {
                                              Get.back();
                                            });
                                          }),
                                        ],
                                      );
                                    },
                                    child: Image.asset(
                                      "assets/images/common/icon_more_horizontal.png",
                                      width: 26.w * 3,
                                      height: 26.w * 3,
                                    ),
                                  )

                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              color: HhColors.line25Color,
                              height: 1.w,
                              width: 1.sw,
                              margin: EdgeInsets.fromLTRB(10.w*3, 0, 10.w*3, 0),
                            ),
                          )
                        ],
                      ),
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

  String parseLevelText(String l) {
    if(l == "1"){
      return "火险一级";
    }
    if(l == "2"){
      return "火险二级";
    }
    if(l == "3"){
      return "火险三级";
    }
    if(l == "4"){
      return "火险四级";
    }
    if(l == "5"){
      return "火险五级";
    }
    return "";
  }

  Color parseLevelColor(String l) {
    if(l == "1"){
      return HhColors.levelColor1;
    }
    if(l == "2"){
      return HhColors.levelColor2;
    }
    if(l == "3"){
      return HhColors.levelColor3;
    }
    if(l == "4"){
      return HhColors.levelColor4;
    }
    if(l == "5"){
      return HhColors.levelColor5;
    }
    return HhColors.levelColor5;
  }
}

class PopMenuItem extends StatelessWidget {
  final String title;
  final String image;
  final Color? color;
  final Function onTap;
  const PopMenuItem({super.key, required this.title,required this.image, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return HhTap(
      overlayColor: HhColors.trans,
      onTapUp: (){
        onTap();
        HhActionMenu.dismiss();
      },
      child: Container(
        width: 60.w * 3,
        color: HhColors.trans,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 15.w*3),
            Image.asset(
              image,
              width: 18.w * 3,
              height: 18.w * 3,
            ),
            SizedBox(height: 6.w),
            Text(title,style: TextStyle(color: color??HhColors.blackTextColor,fontSize: 14.sp*3,fontWeight: FontWeight.w500),),
            SizedBox(height: 10.w*3),
          ],
        ),
      ),
    );
  }

}
