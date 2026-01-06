import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/home/device/manage/device_manage_binding.dart';
import 'package:iot/pages/home/device/manage/device_manage_view.dart';
import 'package:iot/pages/home/my/info/setting_binding.dart';
import 'package:iot/pages/home/my/info/setting_view.dart';
import 'package:iot/pages/home/my/scan/scan_binding.dart';
import 'package:iot/pages/home/my/scan/scan_view.dart';
import 'package:iot/pages/home/my/setting/by_us/us_binding.dart';
import 'package:iot/pages/home/my/setting/by_us/us_view.dart';
import 'package:iot/pages/home/my/setting/setting_binding.dart';
import 'package:iot/pages/home/my/setting/setting_view.dart';
import 'package:iot/pages/home/space/manage/space_manage_binding.dart';
import 'package:iot/pages/home/space/manage/space_manage_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/HhColors.dart';
import 'my_controller.dart';

class MyPage extends StatelessWidget {
  final logic = Get.find<MyController>();

  MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    logic.context = context;
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: CommonUtils().gradientColors3()),
          ),
        ),

        ///title
        Container(
          margin: EdgeInsets.fromLTRB(14.w*3, 53.w*3, 0, 0),
          child: Text(
            "我的",
            style: TextStyle(
                color: HhColors.blackTextColor,
                fontSize: 18.sp*3,
                fontWeight: FontWeight.w600),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: BouncingWidget(
            duration: const Duration(milliseconds: 100),
            scaleFactor: 1.2,
            onPressed: () async {
              Get.to(() => ScanPage(), binding: ScanBinding());
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 53.w*3, 14.w*3, 0),
              color: HhColors.trans,
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/common/icon_scanner.png",
                    width: 22.w*3,
                    height: 22.w*3,
                    fit: BoxFit.fill,
                  ),
                  Text(
                    "扫一扫",
                    style: TextStyle(
                        color: HhColors.blackTextColor,
                        fontSize: 10.sp*3,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          ),
        ),

        Container(
          margin: EdgeInsets.only(top: 114.w*3),
          child: EasyRefresh(
            onRefresh: () {
              logic.getSpaceList();
              logic.deviceList();
              logic.getVersion();
              logic.getCacheSize();
              logic.getVoice();
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      ///头像等信息
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: () {
                          Get.to(() => UserInfoPage(), binding: UserInfoBinding());
                        },
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          margin: EdgeInsets.fromLTRB(22.w*3, 0, 0.w, 0),
                          decoration: BoxDecoration(
                              color: HhColors.whiteColor,
                              borderRadius: BorderRadius.all(Radius.circular(25.w*3))),
                          child: Image.network(
                            logic.avatar!.value,
                            width: 50.w*3,
                            height: 50.w*3,
                            fit: BoxFit.fill,
                            errorBuilder: (BuildContext context,Object exception,StackTrace? stackTrace){
                              return Image.asset(
                                "assets/images/common/user.png",
                                width: 50.w*3,
                                height: 50.w*3,
                                fit: BoxFit.fill,
                              );
                            },
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => UserInfoPage(), binding: UserInfoBinding());
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(80.w*3, 0, 0, 0),
                          child: Text(
                            logic.nickname!.value,
                            style: TextStyle(
                                color: HhColors.blackTextColor,
                                fontSize: 18.sp*3,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => UserInfoPage(), binding: UserInfoBinding());
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(80.w*3, 30.w*3, 0, 0),
                          child: Text(
                            CommonUtils().mobileString(logic.mobile!.value),
                            style: TextStyle(color: HhColors.gray6TextColor, fontSize: 13.sp*3),
                          ),
                        ),
                      ),
                    ],
                  ),

                  ///设备&&分组
                  Container(
                    margin: EdgeInsets.fromLTRB(14.w*3, 24.w*3, 14.w*3, 0),
                    child: Row(
                      children: [
                        Expanded(
                            child: InkWell(
                              onTap: (){
                                Get.to(() => DeviceManagePage(),
                                    binding: DeviceManageBinding());
                              },
                              child: Container(
                                height: 80.w*3,
                                decoration: BoxDecoration(
                                    color: HhColors.whiteColor,
                                    borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        clipBehavior: Clip.hardEdge,
                                        margin: EdgeInsets.fromLTRB(21.w*3, 0.w, 0.w, 0.w),
                                        decoration: BoxDecoration(
                                            color: HhColors.whiteColor,
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(21.w*3))),
                                        child: Image.asset(
                                          "assets/images/common/ic_my_left.png",
                                          width: 42.w*3,
                                          height: 42.w*3,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(82.w*3, 15.w*3, 0.w, 0),
                                        child: Text(
                                          "${logic.deviceNum}",
                                          style: TextStyle(
                                              color: HhColors.blackColor,
                                              fontSize: 24.sp*3,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(82.w*3, 50.w*3, 0.w, 0.w),
                                        child: Text(
                                          "智能设备",
                                          style: TextStyle(
                                              color: HhColors.gray9TextColor,
                                              fontSize: 13.sp*3),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        Expanded(
                            child: InkWell(
                              onTap: (){
                                Get.to(() => SpaceManagePage(),
                                    binding: SpaceManageBinding());
                              },
                              child: Container(
                                height: 80.w*3,
                                margin: EdgeInsets.only(left: 10.w*3),
                                decoration: BoxDecoration(
                                    color: HhColors.whiteColor,
                                    borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        clipBehavior: Clip.hardEdge,
                                        margin: EdgeInsets.fromLTRB(21.w*3, 0.w, 0.w, 0.w),
                                        decoration: BoxDecoration(
                                            color: HhColors.whiteColor,
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(21.w*3))),
                                        child: Image.asset(
                                          "assets/images/common/ic_my_right.png",
                                          width: 42.w*3,
                                          height: 42.w*3,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(82.w*3, 15.w*3, 0.w, 45.w),
                                        child: Text(
                                          "${logic.spaceNum}",
                                          style: TextStyle(
                                              color: HhColors.blackColor,
                                              fontSize: 24.sp*3,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(82.w*3, 50.w*3, 0.w, 0.w),
                                        child: Text(
                                          "分组管理",
                                          style: TextStyle(
                                              color: HhColors.gray9TextColor,
                                              fontSize: 13.sp*3),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),

                  ///菜单
                  Container(
                    margin: EdgeInsets.fromLTRB(14.w*3, 10.w*3, 14.w*3, 0),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ///个人信息
                        InkWell(
                          onTap: () {
                            Get.to(() => UserInfoPage(), binding: UserInfoBinding());
                          },
                          child: Container(
                            height: 50.w*3,
                            color: HhColors.trans,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10.w*3),
                                    child: Image.asset(
                                      "assets/images/common/ic_setting.png",
                                      width: 20.w*3,
                                      height: 20.w*3,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 40.w*3),
                                    child: Text(
                                      "个人信息",
                                      style: TextStyle(
                                          color: HhColors.textBlackColor,
                                          fontSize: 15.sp*3,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 6.w, 30.w, 0),
                                    child: Image.asset(
                                      "assets/images/common/back_role.png",
                                      width: 14.w*3,
                                      height: 14.w*3,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 0.5.w,
                                      width: 1.sw,
                                      margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                      color: HhColors.grayDDTextColor,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        ///安全设置
                        InkWell(
                          onTap: () {
                            Get.to(() => SettingPage(), binding: SettingBinding());
                          },
                          child: Container(
                            height: 50.w*3,
                            color: HhColors.trans,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10.w*3),
                                    child: Image.asset(
                                      "assets/images/common/mine_safe.png",
                                      width: 20.w*3,
                                      height: 20.w*3,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 40.w*3),
                                    child: Text(
                                      "安全设置",
                                      style: TextStyle(
                                          color: HhColors.textBlackColor,
                                          fontSize: 15.sp*3,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 6.w, 30.w, 0),
                                    child: Image.asset(
                                      "assets/images/common/back_role.png",
                                      width: 14.w*3,
                                      height: 14.w*3,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 0.5.w,
                                      width: 1.sw,
                                      margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                      color: HhColors.grayDDTextColor,
                                    ))
                              ],
                            ),
                          ),
                        ),

                        ///更新
                        InkWell(
                          onTap: () {
                            EventBusUtil.getInstance().fire(Version(info: true));
                          },
                          child: SizedBox(
                            height: 50.w*3,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10.w*3),
                                    child: Image.asset(
                                      "assets/images/common/mine_update.png",
                                      width: 20.w*3,
                                      height: 20.w*3,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 40.w*3),
                                    child: Text(
                                      "更新",
                                      style: TextStyle(
                                          color: HhColors.textBlackColor,
                                          fontSize: 15.sp*3,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 28.w*3),
                                    child: Text(
                                      "版本V${logic.version.value}",
                                      style: TextStyle(
                                          color: HhColors.gray9TextColor,
                                          fontSize: 15.sp*3),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 6.w, 11.w*3, 0),
                                    child: Image.asset(
                                      "assets/images/common/back_role.png",
                                      width: 14.w*3,
                                      height: 14.w*3,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 0.5.w,
                                      width: 1.sw,
                                      margin:
                                      EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                      color: HhColors.grayDDTextColor,
                                    ))
                              ],
                            ),
                          ),
                        ),

                        ///清除缓存
                        InkWell(
                          onTap: () {
                            CommonUtils().showConfirmDialog(
                                logic.context, '确定要清除缓存吗？', () {
                              Get.back();
                            }, () {
                              Get.back();
                              logic.clearCache();
                            }, () {
                              Get.back();
                            });
                          },
                          child: SizedBox(
                            height: 50.w*3,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10.w*3),
                                    child: Image.asset(
                                      "assets/images/common/mine_clear_cache.png",
                                      width: 20.w*3,
                                      height: 20.w*3,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 40.w*3),
                                    child: Text(
                                      "清除缓存",
                                      style: TextStyle(
                                          color: HhColors.textBlackColor,
                                          fontSize: 15.sp*3,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 28.w*3),
                                    child: Text(
                                      logic.cache.value == 0
                                          ? "无缓存"
                                          : "${CommonUtils().parseCache(logic.cache.value)}",
                                      style: TextStyle(
                                          color: HhColors.gray9TextColor,
                                          fontSize: 15.sp*3),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 6.w, 11.w*3, 0),
                                    child: Image.asset(
                                      "assets/images/common/back_role.png",
                                      width: 14.w*3,
                                      height: 14.w*3,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 0.5.w,
                                      width: 1.sw,
                                      margin:
                                      EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                      color: HhColors.grayDDTextColor,
                                    ))
                              ],
                            ),
                          ),
                        ),

                        ///关于我们
                        InkWell(
                          onTap: () {
                            Get.to(
                                    () => UsPage(),
                                binding: UsBinding());
                          },
                          child: SizedBox(
                            height: 50.w*3,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10.w*3),
                                    child: Image.asset(
                                      "assets/images/common/ic_help.png",
                                      width: 20.w*3,
                                      height: 20.w*3,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 40.w*3),
                                    child: Text(
                                      "关于我们",
                                      style: TextStyle(
                                          color: HhColors.textBlackColor,
                                          fontSize: 15.sp*3,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 6.w, 11.w*3, 0),
                                    child: Image.asset(
                                      "assets/images/common/back_role.png",
                                      width: 14.w*3,
                                      height: 14.w*3,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 0.5.w,
                                      width: 1.sw,
                                      margin:
                                      EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                      color: HhColors.grayDDTextColor,
                                    ))
                              ],
                            ),
                          ),
                        ),

                        ///预警提示音
                        SizedBox(
                          height: 50.w*3,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 10.w*3),
                                  child: Image.asset(
                                    "assets/images/common/mine_voice.png",
                                    width: 20.w*3,
                                    height: 20.w*3,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 40.w*3),
                                  child: Text(
                                    "预警提示音",
                                    style: TextStyle(
                                        color: HhColors.textBlackColor,
                                        fontSize: 15.sp*3,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin: EdgeInsets.only(right: 12.w*3),
                                  child: Switch(
                                    value: logic.warningVoice.value,
                                    thumbColor: MaterialStateProperty.all(HhColors.whiteColor),
                                    trackColor: logic.warningVoice.value?MaterialStateProperty.all(HhColors.mainBlueColor):MaterialStateProperty.all(HhColors.grayEEBackColor),
                                    trackOutlineColor: logic.warningVoice.value?MaterialStateProperty.all(HhColors.mainBlueColor):MaterialStateProperty.all(HhColors.grayEEBackColor),
                                    onChanged: (bool value) async {
                                    logic.warningVoice.value = value;
                                    SharedPreferences preferences = await SharedPreferences.getInstance();
                                    preferences.setBool(SPKeys().voice,value);
                                    EventBusUtil.getInstance().fire(HhToast(title: "设置成功",type: 0));
                                  },),
                                ),
                              ),
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 0.5.w,
                                    width: 1.sw,
                                    margin:
                                    EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                    color: HhColors.grayDDTextColor,
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 0.2.sh,),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
