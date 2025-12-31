import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/home/cell/HhTap.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'message_detail_controller.dart';

class MessageDetailPage extends StatelessWidget {
  final logic = Get.find<MessageDetailController>();

  MessageDetailPage({super.key});

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
                      logic.getWarnType();
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

        ///菜单
        Container(
          margin: EdgeInsets.fromLTRB(14.w*3, 95.w*3, 14.w*3, 20.w*3),
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
                noItemsFoundIndicatorBuilder: (context) => CommonUtils().noneWidget(image:'assets/images/common/icon_no_message_search.png',info: '暂无报警信息',mid: 20.w,
                  height: 0.36.sw,
                  width: 0.44.sw,),
                firstPageProgressIndicatorBuilder: (context) => Container(),
                itemBuilder: (context, item, index) {
                  return InkWell(
                    onTap: (){
                      logic.readOne("${item["id"]}");

                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10.w*3),
                      padding: EdgeInsets.fromLTRB(8.w*3, 12.w*3, 10.w*3, 12.w*3),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: HhColors.whiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(8.w*3))
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 113.w*3,
                            height: 70.w*3,
                            child: Stack(
                              children: [
                                Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.w*3),
                                  ),
                                  child: item['alarmType']=='openCap'||item['alarmType']=='openSensor'||item['alarmType']=='tilt'?Image.asset(
                                    "assets/images/common/icon_message_back.png",
                                    width: 113.w*3,
                                    height: 70.w*3,
                                    fit: BoxFit.fill,
                                  ):("${item['alarmType']}".contains("offline"))?Image.asset(
                                    "assets/images/common/icon_offline_warn.png",
                                    width: 113.w*3,
                                    height: 70.w*3,
                                    fit: BoxFit.fill,
                                  ):InkWell(
                                    onTap: (){
                                      CommonUtils().showPictureDialog(context, url:"${CommonData.endpoint}${item['alarmImageUrl']}");
                                      logic.readOne("${item["id"]}");
                                    },
                                    child: Image.network("${CommonData.endpoint}${item['alarmImageUrl']}",errorBuilder: (a,b,c){
                                      return Image.asset(
                                        "assets/images/common/ic_message_no.png",
                                        width: 113.w*3,
                                        height: 70.w*3,
                                        fit: BoxFit.fill,
                                      );
                                    },
                                      width: 113.w*3,
                                      height: 70.w*3,
                                      fit: BoxFit.fill,),
                                  ),
                                ),
                                item['alarmType']=='tilt'?Align(
                                  alignment:Alignment.center,
                                  child: Image.asset(
                                    "assets/images/common/icon_message_y.png",
                                    width: 30.w*3,
                                    height: 30.w*3,
                                    fit: BoxFit.fill,
                                  ),
                                ):item['alarmType']=='openCap'||item['alarmType']=='openSensor'?Align(
                                  alignment:Alignment.center,
                                  child: Image.asset(
                                    "assets/images/common/icon_message_open.png",
                                    width: 30.w*3,
                                    height: 30.w*3,
                                    fit: BoxFit.fill,
                                  ),
                                ):const SizedBox(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 70.w*3,
                              child: Stack(
                                children: [
                                  item['status'] == true?const SizedBox():Container(
                                    height: 6.w*3,
                                    width: 6.w*3,
                                    margin: EdgeInsets.fromLTRB(0, 5.w, 0, 0),
                                    decoration: BoxDecoration(
                                        color: HhColors.backRedInColor,
                                        borderRadius: BorderRadius.all(Radius.circular(3.w*3))
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(30.w, 5.w, 0, 0),
                                    child: Text(
                                      parseType("${item['alarmType']}"),
                                      style: TextStyle(
                                          color: HhColors.textBlackColor, fontSize: 15.sp*3,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(30.w, 26.w*3, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          CommonUtils().parseNull('${item['deviceName']}',""),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: HhColors.gray9TextColor, fontSize: 14.sp*3),
                                        ),
                                        SizedBox(height: 5.w,),
                                        Text(
                                          CommonUtils().parseNull('${item['spaceName']}', ""),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: HhColors.gray9TextColor, fontSize: 13.sp*3),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 5.w*3),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            CommonUtils().parseLongTimeYearDay('${item['createTime']}'),
                                            style: TextStyle(
                                                color: HhColors.gray9TextColor, fontSize: 12.sp*3),
                                          ),
                                          SizedBox(height: 5.w*3,),
                                          Text(
                                            CommonUtils().parseLongTimeHourMinuteSecond('${item['createTime']}'),
                                            style: TextStyle(
                                                color: HhColors.gray9TextColor, fontSize: 12.sp*3),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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

  String parseType(String s) {
    for(int i = 0;i < logic.typeList.length;i++){
      dynamic model = logic.typeList[i];
      if(model["alarmType"] == s){
        return model["alarmName"];
      }
    }
    return "报警";
  }

}
