import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/home/device/detail/yunweixiang/detail/ywx_in_controller.dart';
import 'package:iot/pages/home/my/network/network_controller.dart';
import 'package:iot/pages/home/my/setting/setting_controller.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:screenshot/screenshot.dart';
class YWXInPage extends StatelessWidget {
  final logic = Get.find<YWXInController>();
  YWXInPage(dynamic item, {super.key}) {
  logic.item = item;
  }


  @override
  Widget build(BuildContext context) {
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
          child: logic.testStatus.value ? myPage() : const SizedBox(),
        ),
      ),
    );
  }

  myPage() {
    return Stack(
      children: [
        ///背景-渐变色
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [HhColors.backColorF5, HhColors.backColorF5]),
          ),
        ),
        Container(
          height: 90.w*3,
          width: 1.sw,
          color: HhColors.whiteColor,
        ),

        ///title
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 54.w*3),
            color: HhColors.trans,
            child: Text(
              '总览',
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

        Container(
          margin: EdgeInsets.only(top: 105.w*3),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(15.w*3, 0, 5.w*3, 0),
                        padding: EdgeInsets.only(right: 5.w*3),
                        height: 78.w*3,
                        decoration: BoxDecoration(
                          color: HhColors.whiteColor,
                          borderRadius: BorderRadius.circular(4.w*3)
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 10.w*3),
                                child: Image.asset(
                                  "assets/images/common/ywx_a.png",
                                  width: 42.w * 3,
                                  height: 42.w * 3,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 62.w*3),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '市电',
                                      style: TextStyle(
                                          color: HhColors.black25Color,
                                          fontSize: 14.sp * 3,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '231.3V/30mA',
                                      style: TextStyle(
                                          color: HhColors.gray5FTextColor,
                                          fontSize: 14.sp * 3,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(5.w*3, 0, 15.w*3, 0),
                        padding: EdgeInsets.only(right: 5.w*3),
                        height: 78.w*3,
                        decoration: BoxDecoration(
                          color: HhColors.whiteColor,
                          borderRadius: BorderRadius.circular(4.w*3)
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 10.w*3),
                                child: Image.asset(
                                  "assets/images/common/ywx_b.png",
                                  width: 42.w * 3,
                                  height: 42.w * 3,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 62.w*3),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '温度/湿度',
                                      style: TextStyle(
                                          color: HhColors.black25Color,
                                          fontSize: 14.sp * 3,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '24.8.°C/27%RH',
                                      style: TextStyle(
                                          color: HhColors.gray5FTextColor,
                                          fontSize: 14.sp * 3,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
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
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(15.w*3, 10.w*3, 5.w*3, 0),
                        padding: EdgeInsets.only(right: 5.w*3),
                        height: 78.w*3,
                        decoration: BoxDecoration(
                          color: HhColors.whiteColor,
                          borderRadius: BorderRadius.circular(4.w*3)
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 10.w*3),
                                child: Image.asset(
                                  "assets/images/common/ywx_c.png",
                                  width: 42.w * 3,
                                  height: 42.w * 3,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 62.w*3),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '门锁',
                                      style: TextStyle(
                                          color: HhColors.black25Color,
                                          fontSize: 14.sp * 3,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    BouncingWidget(
                                      duration: const Duration(milliseconds: 100),
                                      scaleFactor: 0.6,
                                      onPressed: (){

                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 4.w*3),
                                        padding: EdgeInsets.fromLTRB(9.w*3, 4.w*3, 7.w*3, 3.w*3),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(2.w*3),
                                          border: Border.all(color: HhColors.line25Color,width: 1.w*3)
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '操作',
                                              style: TextStyle(
                                                  color: HhColors.gray5FTextColor,
                                                  fontSize: 12.sp * 3,
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(width: 3.w*3,),
                                            Image.asset(
                                              "assets/images/common/ywx_down.png",
                                              width: 12.w * 3,
                                              height: 12.w * 3,
                                              fit: BoxFit.fill,
                                            )
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
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(5.w*3, 10.w*3, 15.w*3, 0),
                        padding: EdgeInsets.only(right: 5.w*3),
                        height: 78.w*3,
                        decoration: BoxDecoration(
                          color: HhColors.whiteColor,
                          borderRadius: BorderRadius.circular(4.w*3)
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 10.w*3),
                                child: Image.asset(
                                  "assets/images/common/ywx_d.png",
                                  width: 42.w * 3,
                                  height: 42.w * 3,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 62.w*3),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '风扇',
                                      style: TextStyle(
                                          color: HhColors.black25Color,
                                          fontSize: 14.sp * 3,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    BouncingWidget(
                                      duration: const Duration(milliseconds: 100),
                                      scaleFactor: 0.6,
                                      onPressed: (){

                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 4.w*3),
                                        padding: EdgeInsets.fromLTRB(9.w*3, 4.w*3, 7.w*3, 3.w*3),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(2.w*3),
                                            border: Border.all(color: HhColors.line25Color,width: 1.w*3)
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '操作',
                                              style: TextStyle(
                                                  color: HhColors.gray5FTextColor,
                                                  fontSize: 12.sp * 3,
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(width: 3.w*3,),
                                            Image.asset(
                                              "assets/images/common/ywx_down.png",
                                              width: 12.w * 3,
                                              height: 12.w * 3,
                                              fit: BoxFit.fill,
                                            )
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
                    ),
                  ],
                ),
                ///告警统计
                Container(
                  margin: EdgeInsets.fromLTRB(15.w*3, 20.w*3, 15.w*3, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 19.w * 3,
                        width: 3.w * 3,
                        margin: EdgeInsets.only(right: 7.w * 3),
                        decoration: BoxDecoration(
                            color: HhColors.mainBlueColor,
                            borderRadius: BorderRadius.all(
                                Radius.circular(2.w * 3))),
                      ),
                      Text(
                        '告警统计',
                        style: TextStyle(
                            color: HhColors.blackTextColor,
                            fontSize: 15.sp * 3,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 170.w*3,
                  width: 1.sw,
                  margin: EdgeInsets.fromLTRB(15.w*3, 15.w*3, 15.w*3, 0),
                  decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.circular(8.w*3)
                  ),
                  child: PieChart(
                    PieChartData(
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 0, // 设置环形的空隙
                      centerSpaceRadius: 40.w*3, // 中心空白区域的半径
                      sections: showingSections(),
                    ),
                  ),
                ),
                ///恢复/重启
                Container(
                  margin: EdgeInsets.fromLTRB(15.w*3, 20.w*3, 15.w*3, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 19.w * 3,
                        width: 3.w * 3,
                        margin: EdgeInsets.only(right: 7.w * 3),
                        decoration: BoxDecoration(
                            color: HhColors.mainBlueColor,
                            borderRadius: BorderRadius.all(
                                Radius.circular(2.w * 3))),
                      ),
                      Text(
                        '恢复/重启',
                        style: TextStyle(
                            color: HhColors.blackTextColor,
                            fontSize: 15.sp * 3,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 146.w*3,
                  width: 1.sw,
                  margin: EdgeInsets.fromLTRB(15.w*3, 15.w*3, 15.w*3, 0),
                  decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.circular(8.w*3)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 18.w*3,),
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 0.6,
                        onPressed: (){

                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/common/ywx_reset.png",
                              width: 58.w * 3,
                              height: 58.w * 3,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(height: 13.w*3,),
                            Text(
                              '恢复出厂设置',
                              style: TextStyle(
                                  color: HhColors.black25Color,
                                  fontSize: 14.sp * 3,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 40.w*3,),
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 0.6,
                        onPressed: (){

                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/common/ywx_restart.png",
                              width: 58.w * 3,
                              height: 58.w * 3,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(height: 13.w*3,),
                            Text(
                              '重启设备',
                              style: TextStyle(
                                  color: HhColors.black25Color,
                                  fontSize: 14.sp * 3,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ///输入电压折线图
                Container(
                  margin: EdgeInsets.fromLTRB(15.w*3, 20.w*3, 15.w*3, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 19.w * 3,
                        width: 3.w * 3,
                        margin: EdgeInsets.only(right: 7.w * 3),
                        decoration: BoxDecoration(
                            color: HhColors.mainBlueColor,
                            borderRadius: BorderRadius.all(
                                Radius.circular(2.w * 3))),
                      ),
                      Text(
                        '输入电压折线图',
                        style: TextStyle(
                            color: HhColors.blackTextColor,
                            fontSize: 15.sp * 3,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 246.w*3,
                  width: 1.sw,
                  margin: EdgeInsets.fromLTRB(15.w*3, 15.w*3, 15.w*3, 0),
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.circular(8.w*3)
                  ),
                  child: LineChart(
                    LineChartData(
                      //设置网格线
                      gridData: FlGridData(show: true, getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: HhColors.grayDDTextColor,
                          strokeWidth: 0.5,
                        );
                      },getDrawingVerticalLine: (value){
                        return FlLine(
                          color: HhColors.trans,);
                      }),
                      titlesData: FlTitlesData(
                        bottomTitles: SideTitles(showTitles: true, getTextStyles: (context, value) {
                          return const TextStyle(color: Color(0xff727272), fontSize: 10);
                        }),
                        leftTitles: SideTitles(showTitles: true, getTextStyles: (context, value) {
                          return const TextStyle(color: Color(0xff727272), fontSize: 10);
                        }),
                      ),
                      borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
                      minX: 0,
                      maxX: 6,
                      minY: 0,
                      maxY: 250,
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            const FlSpot(0, 250),
                            const FlSpot(1, 220),
                            const FlSpot(2, 210),
                            const FlSpot(3, 230),
                            const FlSpot(4, 240),
                            const FlSpot(5, 250),
                          ],
                          isCurved: true,
                          colors: [Colors.blue],
                          barWidth: 3,
                          belowBarData: BarAreaData(show: false),
                          dotData: FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
                ///输出电压折线图
                Container(
                  margin: EdgeInsets.fromLTRB(15.w*3, 20.w*3, 15.w*3, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 19.w * 3,
                        width: 3.w * 3,
                        margin: EdgeInsets.only(right: 7.w * 3),
                        decoration: BoxDecoration(
                            color: HhColors.mainBlueColor,
                            borderRadius: BorderRadius.all(
                                Radius.circular(2.w * 3))),
                      ),
                      Text(
                        '输出电压折线图',
                        style: TextStyle(
                            color: HhColors.blackTextColor,
                            fontSize: 15.sp * 3,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 246.w*3,
                  width: 1.sw,
                  margin: EdgeInsets.fromLTRB(15.w*3, 15.w*3, 15.w*3, 0),
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.circular(8.w*3)
                  ),
                  child: LineChart(
                    LineChartData(
                      //设置网格线
                      gridData: FlGridData(show: true, getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: HhColors.grayDDTextColor,
                          strokeWidth: 0.5,
                        );
                      },getDrawingVerticalLine: (value){
                        return FlLine(
                        color: HhColors.trans,);
                      }),
                      titlesData: FlTitlesData(
                        bottomTitles: SideTitles(showTitles: true, getTextStyles: (context, value) {
                          return const TextStyle(color: Color(0xff727272), fontSize: 10);
                        }),
                        leftTitles: SideTitles(showTitles: true, getTextStyles: (context, value) {
                          return const TextStyle(color: Color(0xff727272), fontSize: 10);
                        }),
                      ),
                      borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
                      minX: 0,
                      maxX: 6,
                      minY: 0,
                      maxY: 250,
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            const FlSpot(0, 250),
                            const FlSpot(1, 220),
                            const FlSpot(2, 210),
                            const FlSpot(3, 230),
                            const FlSpot(4, 240),
                            const FlSpot(5, 250),
                          ],
                          isCurved: true,
                          colors: [Colors.blue],
                          barWidth: 3,
                          belowBarData: BarAreaData(show: false),
                          dotData: FlDotData(show: true),
                        ),
                        LineChartBarData(
                          spots: [
                            const FlSpot(0, 50),
                            const FlSpot(1, 60),
                            const FlSpot(2, 70),
                            const FlSpot(3, 65),
                            const FlSpot(4, 75),
                            const FlSpot(5, 80),
                          ],
                          isCurved: true,
                          colors: [Colors.green],
                          barWidth: 3,
                          belowBarData: BarAreaData(show: false),
                          dotData: FlDotData(show: true),
                        ),
                        LineChartBarData(
                          spots: [
                            const FlSpot(0, 40),
                            const FlSpot(1, 60),
                            const FlSpot(2, 70),
                            const FlSpot(3, 80),
                            const FlSpot(4, 90),
                            const FlSpot(5, 100),
                          ],
                          isCurved: true,
                          colors: [Colors.red],
                          barWidth: 3,
                          belowBarData: BarAreaData(show: false),
                          dotData: FlDotData(show: true),
                        ),
                        LineChartBarData(
                          spots: [
                            const FlSpot(0, 20),
                            const FlSpot(1, 30),
                            const FlSpot(2, 40),
                            const FlSpot(3, 35),
                            const FlSpot(4, 50),
                            const FlSpot(5, 60),
                          ],
                          isCurved: true,
                          colors: [Colors.purple],
                          barWidth: 3,
                          belowBarData: BarAreaData(show: false),
                          dotData: FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
                ///设备告警
                Container(
                  margin: EdgeInsets.fromLTRB(15.w*3, 20.w*3, 15.w*3, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 19.w * 3,
                        width: 3.w * 3,
                        margin: EdgeInsets.only(right: 7.w * 3),
                        decoration: BoxDecoration(
                            color: HhColors.mainBlueColor,
                            borderRadius: BorderRadius.all(
                                Radius.circular(2.w * 3))),
                      ),
                      Text(
                        '设备告警',
                        style: TextStyle(
                            color: HhColors.blackTextColor,
                            fontSize: 15.sp * 3,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1.sw,
                  margin: EdgeInsets.fromLTRB(15.w*3, 15.w*3, 15.w*3, 0),
                  padding: EdgeInsets.fromLTRB(15.w*3,0,15.w*3,0),
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.circular(8.w*3)
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //告警分类
                      SizedBox(
                        height: 50.w*3,
                        child: Row(
                          children: [
                            Text(
                              '告警分类',
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 15.sp * 3,
                                  fontWeight: FontWeight.w500),
                            ),
                            const Expanded(child: SizedBox()),
                            Container(
                              padding: EdgeInsets.fromLTRB(8.w*3, 4.w*3, 8.w*3, 4.w*3),
                              decoration: BoxDecoration(
                                color: HhColors.blue25InColor,
                                borderRadius: BorderRadius.circular(2.w*3),
                                border: Border.all(color: HhColors.blue25Color,width: 1.w*3)
                              ),
                              child: Text(
                                '内部告警',
                                style: TextStyle(
                                    color: HhColors.mainBlueColor,
                                    fontSize: 13.sp * 3,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //line
                      Container(
                        color: HhColors.line252Color,
                        width: 1.sw,
                        height: 1.w*3,
                      ),
                      //告警类型
                      SizedBox(
                        height: 50.w*3,
                        child: Row(
                          children: [
                            Text(
                              '告警类型',
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 15.sp * 3,
                                  fontWeight: FontWeight.w500),
                            ),
                            const Expanded(child: SizedBox()),
                            Text(
                              '设备链路告警',
                              style: TextStyle(
                                  color: HhColors.gray9TextColor,
                                  fontSize: 15.sp * 3,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      //line
                      Container(
                        color: HhColors.line252Color,
                        width: 1.sw,
                        height: 1.w*3,
                      ),
                      //描述
                      SizedBox(
                        height: 50.w*3,
                        child: Row(
                          children: [
                            Text(
                              '描述',
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 15.sp * 3,
                                  fontWeight: FontWeight.w500),
                            ),
                            const Expanded(child: SizedBox()),
                            Text(
                              '设备与平台连接...',
                              style: TextStyle(
                                  color: HhColors.gray9TextColor,
                                  fontSize: 15.sp * 3,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      //line
                      Container(
                        color: HhColors.line252Color,
                        width: 1.sw,
                        height: 1.w*3,
                      ),
                      //告警时间
                      SizedBox(
                        height: 50.w*3,
                        child: Row(
                          children: [
                            Text(
                              '告警时间',
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 15.sp * 3,
                                  fontWeight: FontWeight.w500),
                            ),
                            const Expanded(child: SizedBox()),
                            Text(
                              '2025-01-11 18:18:02',
                              style: TextStyle(
                                  color: HhColors.gray9TextColor,
                                  fontSize: 15.sp * 3,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1.sw,
                  margin: EdgeInsets.fromLTRB(15.w*3, 10.w*3, 15.w*3, 10.w*3),
                  padding: EdgeInsets.fromLTRB(15.w*3,0,15.w*3,0),
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.circular(8.w*3)
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //告警分类
                      SizedBox(
                        height: 50.w*3,
                        child: Row(
                          children: [
                            Text(
                              '告警分类',
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 15.sp * 3,
                                  fontWeight: FontWeight.w500),
                            ),
                            const Expanded(child: SizedBox()),
                            Container(
                              padding: EdgeInsets.fromLTRB(8.w*3, 4.w*3, 8.w*3, 4.w*3),
                              decoration: BoxDecoration(
                                color: HhColors.blue25InColor,
                                borderRadius: BorderRadius.circular(2.w*3),
                                border: Border.all(color: HhColors.blue25Color,width: 1.w*3)
                              ),
                              child: Text(
                                '内部告警',
                                style: TextStyle(
                                    color: HhColors.mainBlueColor,
                                    fontSize: 13.sp * 3,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //line
                      Container(
                        color: HhColors.line252Color,
                        width: 1.sw,
                        height: 1.w*3,
                      ),
                      //告警类型
                      SizedBox(
                        height: 50.w*3,
                        child: Row(
                          children: [
                            Text(
                              '告警类型',
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 15.sp * 3,
                                  fontWeight: FontWeight.w500),
                            ),
                            const Expanded(child: SizedBox()),
                            Text(
                              '设备链路告警',
                              style: TextStyle(
                                  color: HhColors.gray9TextColor,
                                  fontSize: 15.sp * 3,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      //line
                      Container(
                        color: HhColors.line252Color,
                        width: 1.sw,
                        height: 1.w*3,
                      ),
                      //描述
                      SizedBox(
                        height: 50.w*3,
                        child: Row(
                          children: [
                            Text(
                              '描述',
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 15.sp * 3,
                                  fontWeight: FontWeight.w500),
                            ),
                            const Expanded(child: SizedBox()),
                            Text(
                              '设备与平台连接...',
                              style: TextStyle(
                                  color: HhColors.gray9TextColor,
                                  fontSize: 15.sp * 3,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      //line
                      Container(
                        color: HhColors.line252Color,
                        width: 1.sw,
                        height: 1.w*3,
                      ),
                      //告警时间
                      SizedBox(
                        height: 50.w*3,
                        child: Row(
                          children: [
                            Text(
                              '告警时间',
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 15.sp * 3,
                                  fontWeight: FontWeight.w500),
                            ),
                            const Expanded(child: SizedBox()),
                            Text(
                              '2025-01-11 18:18:02',
                              style: TextStyle(
                                  color: HhColors.gray9TextColor,
                                  fontSize: 15.sp * 3,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /*PagedListView<int, dynamic>(
                  pagingController: logic.warnController,
                  padding: EdgeInsets.zero,
                  builderDelegate: PagedChildBuilderDelegate<dynamic>(
                    firstPageProgressIndicatorBuilder: (c){
                      return Container();
                    }, // 关闭首次加载动画
                    newPageProgressIndicatorBuilder:  (c){
                      return Container();
                    },   // 关闭新页加载动画
                    noItemsFoundIndicatorBuilder: (context) =>Column(
                      children: [
                        const Expanded(child: SizedBox()),
                        Image.asset('assets/images/common/no_message.png',fit: BoxFit.fill,
                          height: 0.32.sw,
                          width: 0.6.sw,),
                      ],
                    ),
                    itemBuilder: (context, item, index) =>
                        InkWell(
                          onTap: (){

                          },
                          child: Container(
                            width: 1.sw,
                            margin: EdgeInsets.fromLTRB(15.w*3, 15.w*3, 15.w*3, 0),
                            padding: EdgeInsets.fromLTRB(15.w*3,0,15.w*3,0),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius: BorderRadius.circular(8.w*3)
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //告警分类
                                SizedBox(
                                  height: 50.w*3,
                                  child: Row(
                                    children: [
                                      Text(
                                        '告警分类',
                                        style: TextStyle(
                                            color: HhColors.blackTextColor,
                                            fontSize: 15.sp * 3,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(8.w*3, 4.w*3, 8.w*3, 4.w*3),
                                        decoration: BoxDecoration(
                                            color: HhColors.blue25InColor,
                                            borderRadius: BorderRadius.circular(2.w*3),
                                            border: Border.all(color: HhColors.blue25Color,width: 1.w*3)
                                        ),
                                        child: Text(
                                          '内部告警',
                                          style: TextStyle(
                                              color: HhColors.mainBlueColor,
                                              fontSize: 13.sp * 3,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //line
                                Container(
                                  color: HhColors.line252Color,
                                  width: 1.sw,
                                  height: 1.w*3,
                                ),
                                //告警类型
                                SizedBox(
                                  height: 50.w*3,
                                  child: Row(
                                    children: [
                                      Text(
                                        '告警类型',
                                        style: TextStyle(
                                            color: HhColors.blackTextColor,
                                            fontSize: 15.sp * 3,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      Text(
                                        '设备链路告警',
                                        style: TextStyle(
                                            color: HhColors.gray9TextColor,
                                            fontSize: 15.sp * 3,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                //line
                                Container(
                                  color: HhColors.line252Color,
                                  width: 1.sw,
                                  height: 1.w*3,
                                ),
                                //描述
                                SizedBox(
                                  height: 50.w*3,
                                  child: Row(
                                    children: [
                                      Text(
                                        '描述',
                                        style: TextStyle(
                                            color: HhColors.blackTextColor,
                                            fontSize: 15.sp * 3,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      Text(
                                        '设备与平台连接...',
                                        style: TextStyle(
                                            color: HhColors.gray9TextColor,
                                            fontSize: 15.sp * 3,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                //line
                                Container(
                                  color: HhColors.line252Color,
                                  width: 1.sw,
                                  height: 1.w*3,
                                ),
                                //告警时间
                                SizedBox(
                                  height: 50.w*3,
                                  child: Row(
                                    children: [
                                      Text(
                                        '告警时间',
                                        style: TextStyle(
                                            color: HhColors.blackTextColor,
                                            fontSize: 15.sp * 3,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      Text(
                                        '2025-01-11 18:18:02',
                                        style: TextStyle(
                                            color: HhColors.gray9TextColor,
                                            fontSize: 15.sp * 3,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ),
                  physics: const NeverScrollableScrollPhysics(), // 禁用滚动
                ),*/
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return [
      PieChartSectionData(
        color: Colors.yellow,
        value: 82.2, // 数量
        title: '设备链路异常告警', // 标签名称
        radius: 60, // 半径大小
        titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      PieChartSectionData(
        color: Colors.grey,
        value: 17.8, // 数量
        title: '其他',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    ];
  }
}
