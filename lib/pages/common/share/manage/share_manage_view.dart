import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/common/share/manage/share_manage_controller.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhColors.dart';

class ShareManagePage extends StatelessWidget {
  final logic = Get.find<ShareManageController>();

  ShareManagePage({super.key});

  @override
  Widget build(BuildContext context) {
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
              ///title
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 54.w*3),
                  color: HhColors.trans,
                  child: Text(
                    "分享管理",
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

              ///tab
              Container(
                margin: EdgeInsets.fromLTRB(24.w*3, 110.w*3, 0, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: logic.tabsTag.value ? buildTabs() : [],
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
      margin: EdgeInsets.only(top: 149.w*3),
      child: EasyRefresh(
        onRefresh: () {
          logic.pageNum = 1;
          logic.shareList(logic.pageNum);
        },
        onLoad: () {
          logic.pageNum++;
          logic.shareList(logic.pageNum);
        },
        controller: logic.easyController,
        child: PagedListView<int, dynamic>(
          padding: EdgeInsets.zero,
          pagingController: logic.deviceController,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            noItemsFoundIndicatorBuilder: (context) =>
                CommonUtils().noneWidget(),
            firstPageProgressIndicatorBuilder: (context) => Container(),
            itemBuilder: (context, item, index) => InkWell(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.fromLTRB(14.w*3, 14.w*3, 14.w*3, 0),
                padding: EdgeInsets.all(10.w*3),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.w))),
                      child: Image.asset(
                        item['productName']=='浩海一体机'?"assets/images/common/icon_c.png":"assets/images/common/icon_d.png",
                        width: 52.w*3,
                        height: 52.w*3,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(8.w*3, 0, 8.w*3, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              parseTitle('${item['shareUrerName']}',item['receiveDetailDOList']??[]),
                              maxLines: 2,
                              style: TextStyle(
                                  color: HhColors.textBlackColor,
                                  fontSize: 15.sp*3,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 6.w*3,
                            ),
                            Text(
                              "时间：${CommonUtils().parseLongTime('${item['createTime']}')}",
                              maxLines: 2,
                              style: TextStyle(
                                  color: HhColors.grayBBTextColor,
                                  fontSize: 13.sp*3,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 6.w*3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                item['status'] == 0
                                    ? InkWell(
                                        onTap: () {
                                          CommonUtils().showDeleteDialog(
                                              context, '确定要拒绝该设备的分享邀请吗?', () {
                                            Get.back();
                                          }, () {
                                            Get.back();
                                            logic.handleShare("${item['id']}", 2,"");
                                          }, () {
                                            Get.back();
                                          }, rightStr: "拒绝");
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10.w),
                                          child: Text(
                                            "拒绝",
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: HhColors.mainRedColor,
                                                fontSize: 14.sp*3,
                                                fontWeight: FontWeight.w200),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                SizedBox(
                                  width: 20.w*3,
                                ),
                                item['status'] == 0
                                    ? InkWell(
                                        onTap: () {
                                          CommonUtils().showConfirmDialog(
                                              context, '确定要同意该设备的分享邀请吗?', () {
                                            Get.back();
                                          }, () {
                                            Get.back();
                                            logic.handleShare("${item['id']}", 1, parseName('${item['shareUrerName']}',item['receiveDetailDOList']??[]),);
                                          }, () {
                                            Get.back();
                                          }, rightStr: "同意");
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10.w),
                                          child: Text(
                                            "同意共享",
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: HhColors.mainBlueColor,
                                                fontSize: 14.sp*3,
                                                fontWeight: FontWeight.w200),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                item['status'] != 0
                                    ? Container(
                                        padding: EdgeInsets.all(10.w),
                                        child: Text(
                                          item['status']==1?"已同意":"已拒绝",
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: HhColors.grayBBTextColor,
                                              fontSize: 14.sp*3,
                                              fontWeight: FontWeight.w200),
                                        ),
                                      )
                                    : const SizedBox(),
                                SizedBox(
                                  width: 10.w*3,
                                ),
                              ],
                            ),
                          ],
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
    );
  }

  List<Widget> buildTabs() {
    List<Widget> list = [];
    for (int i = 0; i < logic.spaceList.length; i++) {
      dynamic model = logic.spaceList[i];
      list.add(Container(
        margin: EdgeInsets.only(left: i == 0 ? 0 : 30.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                logic.tabIndex.value = i;
                logic.pageNum = 1;
                logic.shareList(logic.pageNum);
              },
              child: Text(
                '${model['name']}',
                style: TextStyle(
                    color: logic.tabIndex.value == i
                        ? HhColors.mainBlueColor
                        : HhColors.gray9TextColor,
                    fontSize: logic.tabIndex.value == i ? 18.sp*3 : 15.sp*3,
                    fontWeight: logic.tabIndex.value == i
                        ? FontWeight.bold
                        : FontWeight.w200),
              ),
            ),
            SizedBox(
              height: 5.w,
            ),
            logic.tabIndex.value == i
                ? Container(
                    height: 6.w,
                    width: 30.w,
                    decoration: BoxDecoration(
                        color: HhColors.mainBlueColor,
                        borderRadius: BorderRadius.all(Radius.circular(3.w))),
                  )
                : const SizedBox()
          ],
        ),
      ));
    }

    return list;
  }

  parseTitle(String name, List<dynamic> list) {
    String rt = "";
    if(list.isNotEmpty){
      rt = "$name邀请您共享${list[0]['deviceName']}";
    }else{
      rt = "$name邀请您共享";
    }
    return rt;
  }
  parseName(String name, List<dynamic> list) {
    String rt = "";
    if(list.isNotEmpty){
      rt = "${list[0]['deviceName']}";
    }else{
      rt = "";
    }
    return rt;
  }
}
