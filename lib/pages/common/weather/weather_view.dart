import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/home/cell/HhTap.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../utils/HhColors.dart';
import 'weather_controller.dart';

class WeatherPage extends StatelessWidget {
  final logic = Get.find<WeatherController>();

  WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 在这里设置状态栏字体为深色
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 状态栏背景色
      statusBarBrightness: Brightness.dark, // 状态栏字体亮度
      statusBarIconBrightness: Brightness.dark, // 状态栏图标亮度
    ));
    return WillPopScope(
      onWillPop: () {
        Get.back();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: HhColors.backColor,
        body: Obx(
          () => Container(
            height: 1.sh,
            width: 1.sw,
            color: HhColors.backColorF5,
            padding: EdgeInsets.zero,
            child: logic.testStatus.value ? weatherPage() : const SizedBox(),
          ),
        ),
      ),
    );
  }

  weatherPage() {
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
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 42.w*3),
            child: Text('天气',style: TextStyle(
                color: HhColors.blackTextColor,
                fontSize: 18.sp*3,
                fontWeight: FontWeight.w600
            ),),
          ),
        ),

        ///菜单
        Container(
          margin: EdgeInsets.only(top: 80.w*3),
          child: EasyRefresh(
            onRefresh: (){
              logic.getLocation();
              logic.getNowWeatherByLocation();
              if(logic.weatherIndex.value==0){
                logic.get7daysWeatherByLocation();
              }else{
                logic.getHistoricalWeatherByLocation();
              }
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ///现在天气
                  Container(
                    height: 194.w*3,
                    margin: EdgeInsets.fromLTRB(14.w*3, 10.w*3, 14.w*3, 10.w*3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.w*3),
                      gradient: const LinearGradient(
                        colors: [
                          HhColors.weatherLeft,
                          HhColors.weatherLeft2,
                          HhColors.weatherMid,
                          HhColors.weatherRight,
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        ///省市国家&&时间
                        Container(
                          margin: EdgeInsets.fromLTRB(14.w*3, 10.w*3, 14.w*3, 0),
                          child: Row(
                            children: [
                              Text(
                                CommonUtils().parseNull("${logic.weatherModel.value["adm2"]}", ""),
                                style: TextStyle(
                                    color: HhColors.blackTextColor,
                                    fontSize: 14.sp * 3,fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: 10.w*3,),
                              Text(
                                CommonUtils().parseNull("${logic.weatherModel.value["adm1"]}", ""),
                                style: TextStyle(
                                    color: HhColors.gray9TextColor,
                                    fontSize: 11.sp * 3,fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "/",
                                style: TextStyle(
                                    color: HhColors.gray9TextColor,
                                    fontSize: 11.sp * 3,fontWeight: FontWeight.w400),
                              ),
                              Text(
                                CommonUtils().parseNull("${logic.weatherModel.value["country"]}", ""),
                                style: TextStyle(
                                    color: HhColors.gray9TextColor,
                                    fontSize: 11.sp * 3,fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              Text(
                                CommonUtils().parseNull("${logic.weatherModel.value["time"]}", ""),
                                style: TextStyle(
                                    color: HhColors.gray9TextColor,
                                    fontSize: 11.sp * 3,fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        ///天气
                        logic.weatherModel.value["temp"]!=null?Container(
                          margin: EdgeInsets.only(top: 10.w*3),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  width: 62.w*3,
                                  height: 62.w*3,
                                  child: WebViewWidget(controller: logic.webController,)),
                              SizedBox(width: 10.w*3,),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    CommonUtils().parseNull("${logic.weatherModel.value["temp"]}°", ""),
                                    style: TextStyle(
                                        color: HhColors.blackTextColor,
                                        fontSize: 32.sp * 3,fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    CommonUtils().parseNull("${logic.weatherModel.value["text"]}", ""),
                                    style: TextStyle(
                                        color: HhColors.blackTextColor,
                                        fontSize: 14.sp * 3,fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ):const SizedBox(),
                        Container(
                          height: 56.w*3,
                          width: 1.sw,
                          margin: EdgeInsets.only(top: 15.w*3,left: 14.w*3,right: 14.w*3),
                          decoration: BoxDecoration(
                              color: HhColors.whiteColor,
                              borderRadius: BorderRadius.circular(10.w*3)
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 15.w*3,),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 5.w*3),
                                      child: Text(
                                        "湿度",
                                        style: TextStyle(
                                            color: HhColors.blackTextColor,
                                            fontSize: 11.sp * 3,fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(height: 5.w*3,),
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/common/icon_weather_sd.png",
                                          width: 20.w * 3,
                                          height: 20.w * 3,
                                          fit: BoxFit.fill,
                                        ),
                                        SizedBox(width: 2.w*3,),
                                        Expanded(
                                          child: Text(
                                            "${CommonUtils().parseNull("${logic.weatherModel.value["humidity"]}", "")}%",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: HhColors.blackTextColor,
                                                fontSize: 13.sp * 3,fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 5.w*3),
                                      child: Text(
                                        CommonUtils().parseNull("${logic.weatherModel.value["windDir"]}", ""),
                                        style: TextStyle(
                                            color: HhColors.blackTextColor,
                                            fontSize: 11.sp * 3,fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(height: 5.w*3,),
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/common/icon_weather_wind.png",
                                          width: 20.w * 3,
                                          height: 20.w * 3,
                                          fit: BoxFit.fill,
                                        ),
                                        SizedBox(width: 2.w*3,),
                                        Expanded(
                                          child: Text(
                                            "${CommonUtils().parseNull("${logic.weatherModel.value["windScale"]}", "")}级",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: HhColors.blackTextColor,
                                                fontSize: 13.sp * 3,fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 5.w*3),
                                      child: Text(
                                        "气压",
                                        style: TextStyle(
                                            color: HhColors.blackTextColor,
                                            fontSize: 11.sp * 3,fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(height: 5.w*3,),
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/common/icon_weather_sd.png",
                                          width: 20.w * 3,
                                          height: 20.w * 3,
                                          fit: BoxFit.fill,
                                        ),
                                        SizedBox(width: 2.w*3,),
                                        Expanded(
                                          child: Text(
                                            "${CommonUtils().parseNull("${logic.weatherModel.value["pressure"]}", "")}hpa",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: HhColors.blackTextColor,
                                                fontSize: 13.sp * 3,fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 5.w*3),
                                      child: Text(
                                        "降水量",
                                        style: TextStyle(
                                            color: HhColors.blackTextColor,
                                            fontSize: 11.sp * 3,fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(height: 5.w*3,),
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/common/icon_weather_water.png",
                                          width: 20.w * 3,
                                          height: 20.w * 3,
                                          fit: BoxFit.fill,
                                        ),
                                        SizedBox(width: 2.w*3,),
                                        Expanded(
                                          child: Text(
                                            CommonUtils().parseNull("${logic.weatherModel.value["precip"]}", ""),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: HhColors.blackTextColor,
                                                fontSize: 13.sp * 3,fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ///tab
                  Row(
                    children: [
                      SizedBox(width: 14.w*3,),
                      HhTap(
                        overlayColor: HhColors.trans,
                        onTapUp: (){
                          logic.weatherIndex.value = 0;
                          logic.get7daysWeatherByLocation();
                        },
                        child: Container(
                          height: 40.w*3,
                          width: 88.w*3,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: HhColors.whiteColor,
                              borderRadius: BorderRadius.circular(8.w*3),
                              border: Border.all(color: HhColors.grayDDTextColor, width: 2.w)
                          ),
                          child: Text(
                            '最新天气',
                            style: TextStyle(
                                color: logic.weatherIndex.value == 0
                                    ? HhColors.mainBlueColor
                                    : HhColors.blackTextColor,
                                fontSize: 14.sp * 3),
                          ),
                        ),
                      ),
                      SizedBox(width: 20.w*3,),
                      HhTap(
                        overlayColor: HhColors.trans,
                        onTapUp: (){
                          logic.weatherIndex.value = 1;
                          logic.getHistoricalWeatherByLocation();
                        },
                        child: Container(
                          height: 40.w*3,
                          width: 88.w*3,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: HhColors.whiteColor,
                              borderRadius: BorderRadius.circular(8.w*3),
                              border: Border.all(color: HhColors.grayDDTextColor, width: 2.w)
                          ),
                          child: Text(
                            '过去7天',
                            style: TextStyle(
                                color: logic.weatherIndex.value == 1
                                    ? HhColors.mainBlueColor
                                    : HhColors.blackTextColor,
                                fontSize: 14.sp * 3),
                          ),
                        ),
                      ),
                    ],
                  ),

                  ///七天天气
                  Container(
                    width: 1.sw,
                    margin: EdgeInsets.fromLTRB(14.w*3, 10.w*3, 14.w*3, 10.w*3),
                    padding: EdgeInsets.only(bottom: 15.w*3),
                    decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.circular(8.w*3),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: build7Days(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  build7Days() {
    List<Widget> list = [];
    for (int i = 0; i < logic.weatherList.length; i++) {
      dynamic model = logic.weatherList.value[i];
      late WebViewController webController = WebViewController()
        ..setBackgroundColor(HhColors.trans)..runJavaScript(
            "document.documentElement.style.overflow = 'hidden';"
                "document.body.style.overflow = 'hidden';");
      webController.setJavaScriptMode(JavaScriptMode.unrestricted);
      webController.enableZoom(true);
      webController.runJavaScript(
          "document.documentElement.style.overflow = 'hidden';"
              "document.body.style.overflow = 'hidden';");
      webController.setBackgroundColor(HhColors.trans);
      String weatherUrl = CommonUtils().getHeFengIcon(
          ((logic.weatherIndex.value==0?"${model['textDay']}".contains("晴"):"${model['text']}".contains("晴") )? "FFB615" : "368EFF"), logic.weatherIndex.value==0?"${model['iconDay']}":"${model['icon']}", "100");
      webController.loadRequest(Uri.parse(weatherUrl));
      String week = CommonUtils().parseWeek(logic.weatherIndex.value==0?CommonUtils().parseNull('${model["fxDate"]}', "")
          :CommonUtils().parseNull('${model["date"]}', ""));
      String time = CommonUtils().parseTime(logic.weatherIndex.value==0?CommonUtils().parseNull('${model["fxDate"]}', "")
          :CommonUtils().parseNull('${model["date"]}', ""));
      list.add(
          Container(
            margin: EdgeInsets.fromLTRB(20.w*3, 15.w*3, 20.w*3, 0),
            child: Row(
              children: [
                SizedBox(
                  width: 100.w*3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        week,
                        style: TextStyle(
                            color: HhColors.blackTextColor,
                            fontSize: 14.sp * 3),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                            color: HhColors.gray9TextColor,
                            fontSize: 12.sp * 3),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    width: 26.w*3,
                    height: 26.w*3,
                    child: WebViewWidget(controller: webController,)),
                const Spacer(),
                Text(
                  '${CommonUtils().parseNull("${model["tempMax"]}", "")}°',
                  style: TextStyle(
                      color: HhColors.blackTextColor,
                      fontSize: 14.sp * 3),
                ),
                SizedBox(width: 3.w*3,),
                Container(
                  height: 4.w*3,
                  width: 63.w*3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.w*3),
                    gradient: const LinearGradient(
                      colors: [
                        HhColors.weather1,
                        HhColors.weather2,
                        HhColors.weather3,
                        HhColors.weather4,
                        HhColors.weather5,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
                SizedBox(width: 5.w*3,),
                Text(
                  '${CommonUtils().parseNull("${model["tempMin"]}", "")}°',
                  style: TextStyle(
                      color: HhColors.blackTextColor,
                      fontSize: 14.sp * 3),
                ),
                SizedBox(width: 10.w*3,),
              ],
            ),
          )
      );
      webController.loadRequest(Uri.parse(weatherUrl));
    }
    return list;
  }
}
