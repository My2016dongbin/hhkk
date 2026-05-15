import 'dart:io';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/home/cell/HhTap.dart';
import 'package:iot/pages/home/device/detail/huoxianyinzi/energy_more/hxyz_energy_more_controller.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhColors.dart';

class HXYZEnergyMorePage extends StatelessWidget {
  final logic = Get.find<HXYZEnergyMoreController>();

  HXYZEnergyMorePage({super.key});

  @override
  Widget build(BuildContext context) {
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
    logic.context = context;
    return Scaffold(
      backgroundColor: HhColors.backColorF5,
      body: Container(
        height: 1.sh,
        width: 1.sw,
        color: HhColors.backColorF5,
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                  0, MediaQuery.of(context).padding.top + 23.w * 3, 0, 10.w * 3),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      color: HhColors.trans,
                      margin: EdgeInsets.only(left: 23.w*3),
                      padding: EdgeInsets.fromLTRB(0, 10.w, 20.w, 10.w),
                      child: Image.asset(
                        "assets/images/common/back.png",
                        height: 17.w*3,
                        width: 10.w*3,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "更多",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: HhColors.blackColor,
                          fontSize: 18.sp * 3,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(width: 40.w * 3),
                ],
              ),
            ),
            Expanded(
              child: EasyRefresh(
                onRefresh: () {
                  logic.pageNum = 1;
                  logic.getEnergyList(1);
                },
                onLoad: () {
                  logic.pageNum++;
                  logic.getEnergyList(logic.pageNum);
                },
                controller: logic.easyController,
                child: PagedListView<int, dynamic>(
                  padding: EdgeInsets.fromLTRB(0, 0, 0,
                      MediaQuery.of(context).padding.bottom + 20.w),
                  pagingController: logic.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<dynamic>(
                    noItemsFoundIndicatorBuilder: (context) =>
                        CommonUtils().noneWidget(
                      image: 'assets/images/common/icon_no_message.png',
                      info: '暂无数据',
                      mid: 20.w,
                      height: 0.36.sw,
                      width: 0.44.sw,
                    ),
                    firstPageProgressIndicatorBuilder: (context) => Container(),
                    itemBuilder: (context, item, index) {
                      return buildEnergyItem(item);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEnergyItem(dynamic item) {
    return Container(
      width: 1.sw,
      margin: EdgeInsets.fromLTRB(14.w * 3, 10.w * 3, 14.w * 3, 0),
      padding: EdgeInsets.all(15.w * 3),
      decoration: BoxDecoration(
          color: HhColors.whiteColor,
          borderRadius: BorderRadius.circular(8.w * 3)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "太阳能控制器",
                style: TextStyle(
                    color: HhColors.blackColor,
                    fontSize: 15.sp * 3,
                    fontWeight: FontWeight.w600),
              ),
              Expanded(
                  child: Text(
                CommonUtils().parseLongTime("${item["collectTime"]}"),
                style: TextStyle(
                  color: HhColors.gray9TextColor,
                  fontSize: 15.sp * 3,
                ),
                textAlign: TextAlign.end,
              )),
            ],
          ),
          CommonUtils.line(marginTop: 13.w * 3, marginBottom: 13.w * 3),
          buildInfoRow("负载电压",
              "${CommonUtils().parseDoubleNumber("${item["loadVoltage"] ?? "-"}", 2)}V"),
          CommonUtils.line(marginTop: 13.w * 3, marginBottom: 13.w * 3),
          buildInfoRow("负载电流",
              "${CommonUtils().parseDoubleNumber("${item["loadCurrent"] ?? "-"}", 2)}A"),
          CommonUtils.line(marginTop: 13.w * 3, marginBottom: 13.w * 3),
          buildInfoRow("太阳能电压",
              "${CommonUtils().parseDoubleNumber("${item["solarVoltage"] ?? "-"}", 2)}V"),
          CommonUtils.line(marginTop: 13.w * 3, marginBottom: 13.w * 3),
          buildInfoRow("太阳能电流",
              "${CommonUtils().parseDoubleNumber("${item["solarCurrent"] ?? "-"}", 2)}A"),
          CommonUtils.line(marginTop: 13.w * 3, marginBottom: 13.w * 3),
          buildInfoRow("蓄电池剩余电量",
              "${CommonUtils().parseDoubleNumber("${item["batteryRemain"] ?? "-"}", 2)}%"),
          CommonUtils.line(marginTop: 13.w * 3, marginBottom: 13.w * 3),
          buildInfoRow("蓄电池电压",
              "${CommonUtils().parseDoubleNumber("${item["batteryVoltage"] ?? "-"}", 2)}V"),
          CommonUtils.line(marginTop: 13.w * 3, marginBottom: 13.w * 3),
          buildInfoRow("蓄电池电流",
              "${CommonUtils().parseDoubleNumber("${item["batteryCurrent"] ?? "-"}", 2)}A"),
          CommonUtils.line(marginTop: 13.w * 3, marginBottom: 13.w * 3),
          SizedBox(height: 5.w * 3),
          Row(
            children: [
              Text(
                "土壤传感数据",
                style: TextStyle(
                    color: HhColors.blackColor,
                    fontSize: 15.sp * 3,
                    fontWeight: FontWeight.w600),
              ),
              Expanded(
                  child: Text(
                CommonUtils().parseLongTime("${item["collectTime"]}"),
                style: TextStyle(
                  color: HhColors.gray9TextColor,
                  fontSize: 15.sp * 3,
                ),
                textAlign: TextAlign.end,
              )),
            ],
          ),
          CommonUtils.line(marginTop: 13.w * 3, marginBottom: 13.w * 3),
          buildInfoRow("土壤湿度",
              "${CommonUtils().parseDoubleNumber("${item["soilVolumetricMoisture"] ?? "-"}", 2)}%"),
          CommonUtils.line(marginTop: 13.w * 3, marginBottom: 13.w * 3),
          buildInfoRow("凋落物湿度",
              "${CommonUtils().parseDoubleNumber("${item["litterMassMoisture"] ?? "-"}", 2)}%"),
          CommonUtils.line(marginTop: 13.w * 3, marginBottom: 13.w * 3),
          buildInfoRow("地表温度",
              "${CommonUtils().parseDoubleNumber("${item["surfaceTemperature"] ?? "-"}", 2)}°C"),
          CommonUtils.line(marginTop: 13.w * 3, marginBottom: 13.w * 3),
          buildInfoRow("地表湿度",
              "${CommonUtils().parseDoubleNumber("${item["surfaceHumidity"] ?? "-"}", 2)}%"),
          CommonUtils.line(marginTop: 13.w * 3, marginBottom: 13.w * 3),
          buildInfoRow("倾角X",
              "${CommonUtils().parseDoubleNumber("${item["inclinationX"] ?? "0"}", 2)}°"),
          CommonUtils.line(marginTop: 13.w * 3, marginBottom: 13.w * 3),
          buildInfoRow("倾角Y",
              "${CommonUtils().parseDoubleNumber("${item["inclinationY"] ?? "0"}", 2)}°"),
          CommonUtils.line(marginTop: 13.w * 3, marginBottom: 13.w * 3),
          buildInfoRow("倾角Z",
              "${CommonUtils().parseDoubleNumber("${item["inclinationZ"] ?? "0"}", 2)}°"),
          CommonUtils.line(marginTop: 13.w * 3, marginBottom: 13.w * 3),
          SizedBox(height: 5.w * 3),
          Row(
            children: [
              Text(
                "气象站信息",
                style: TextStyle(
                    color: HhColors.blackColor,
                    fontSize: 15.sp * 3,
                    fontWeight: FontWeight.w600),
              ),
              Expanded(
                  child: Text(
                CommonUtils().parseLongTime("${item["collectTime"]}"),
                style: TextStyle(
                  color: HhColors.gray9TextColor,
                  fontSize: 15.sp * 3,
                ),
                textAlign: TextAlign.end,
              )),
            ],
          ),
          CommonUtils.line(marginTop: 13.w * 3, marginBottom: 13.w * 3),
          buildInfoRow("空气温度",
              "${CommonUtils().parseDoubleNumber("${item["airTemperature"] ?? "-"}", 2)}°C"),
          CommonUtils.line(marginTop: 13.w * 3, marginBottom: 13.w * 3),
          buildInfoRow("空气湿度",
              "${CommonUtils().parseDoubleNumber("${item["airHumidity"] ?? "-"}", 2)}%"),
          CommonUtils.line(marginTop: 13.w * 3, marginBottom: 13.w * 3),
          buildInfoRow("大气压力",
              "${CommonUtils().parseDoubleNumber("${item["airPressure"] ?? "-"}", 2)}hPa"),
          CommonUtils.line(marginTop: 13.w * 3, marginBottom: 13.w * 3),
          buildInfoRow("风向(0-360°)", "${item["windDirection"] ?? "-"}"),
          CommonUtils.line(marginTop: 13.w * 3, marginBottom: 13.w * 3),
          buildInfoRow("风速",
              "${CommonUtils().parseDoubleNumber("${item["windSpeed"] ?? "-"}", 2)}m/s"),
          CommonUtils.line(marginTop: 13.w * 3, marginBottom: 13.w * 3),
          buildInfoRow("光照强度",
              "${CommonUtils().parseDoubleNumber("${item["illuminance"] ?? "-"}", 2)}KLux"),
          CommonUtils.line(marginTop: 13.w * 3, marginBottom: 13.w * 3),
          buildInfoRow("雨量",
              "${CommonUtils().parseDoubleNumber("${item["rainfall"] ?? "0"}", 2)}mm"),
        ],
      ),
    );
  }

  Widget buildInfoRow(String title, String value) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(color: HhColors.blackColor, fontSize: 15.sp * 3),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: HhColors.blackColor, fontSize: 15.sp * 3),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
