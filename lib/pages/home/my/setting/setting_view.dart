import 'dart:io';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/home/my/setting/by_us/us_binding.dart';
import 'package:iot/pages/home/my/setting/by_us/us_view.dart';
import 'package:iot/pages/home/my/setting/edit_user/edit_binding.dart';
import 'package:iot/pages/home/my/setting/edit_user/edit_view.dart';
import 'package:iot/pages/home/my/setting/password/new/new_password_binding.dart';
import 'package:iot/pages/home/my/setting/password/new/new_password_view.dart';
import 'package:iot/pages/home/my/setting/password/password_binding.dart';
import 'package:iot/pages/home/my/setting/password/password_view.dart';
import 'package:iot/pages/home/my/setting/phone/phone_binding.dart';
import 'package:iot/pages/home/my/setting/phone/phone_view.dart';
import 'package:iot/pages/home/my/setting/setting_controller.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tpns_flutter_plugin/tpns_flutter_plugin.dart';

class SettingPage extends StatelessWidget {
  final logic = Get.find<SettingController>();

  SettingPage({super.key});

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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [HhColors.backColorF5, HhColors.backColorF5]),
          ),
        ),

        ///title
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 54.w*3),
            color: HhColors.trans,
            child: Text(
              '设置',
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

        ///菜单
        Container(
          margin: EdgeInsets.fromLTRB(14.w*3, 108.w*3, 14.w*3, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///个人信息
                Container(
                  margin: EdgeInsets.fromLTRB(9.w*3, 30.w, 0, 20.w),
                  child: Text(
                    "个人信息",
                    style: TextStyle(
                        color: HhColors.gray6TextColor, fontSize: 14.sp*3),
                  ),
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ///头像
                      SizedBox(
                        height: 80.w*3,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 15.w*3),
                                child: Text(
                                  "头像",
                                  style: TextStyle(
                                      color: HhColors.textBlackColor,
                                      fontSize: 15.sp*3,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  showChooseTypeDialog();
                                },
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  margin: EdgeInsets.only(right: 37.w*3),
                                  decoration: BoxDecoration(
                                      color: HhColors.whiteColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.w*3))),
                                  child: logic.picture.value == true
                                      ? Image.file(
                                          File(logic.file.path),
                                          width: 50.w*3,
                                          height: 50.w*3,
                                          fit: BoxFit.fill,
                                        )
                                      : Image.network(
                                          logic.avatar!.value,
                                          width: 50.w*3,
                                          height: 50.w*3,
                                          fit: BoxFit.fill,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
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
                                  margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                  color: HhColors.grayDDTextColor,
                                ))
                          ],
                        ),
                      ),

                      ///昵称
                      InkWell(
                        onTap: () {
                          Get.to(
                              () => EditPage(
                                    keys: 'nickname',
                                    titles: '修改昵称',
                                  ),
                              binding: EditBinding());
                        },
                        child: SizedBox(
                          height: 50.w*3,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 15.w*3),
                                  child: Text(
                                    "昵称",
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
                                    logic.nickname!.value,
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

                      ///账号
                      SizedBox(
                        height: 50.w*3,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 15.w*3),
                                child: Text(
                                  "账号",
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
                                margin: EdgeInsets.only(right: 15.w*3),
                                child: Text(
                                  logic.account!.value,
                                  style: TextStyle(
                                      color: HhColors.grayCCTextColor,
                                      fontSize: 15.sp*3),
                                ),
                              ),
                            ),
                            /*Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin:EdgeInsets.fromLTRB(0,6.w,30.w,0),
                                child: Image.asset(
                                  "assets/images/common/back_role.png",
                                  width: 25.w,
                                  height: 25.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),*/
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

                      ///公司信息
                      CommonData.personal
                          ? const SizedBox()
                          : SizedBox(
                              height: 50.w*3,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 15.w*3),
                                      child: Text(
                                        "公司信息",
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
                                      margin: EdgeInsets.only(right: 15.w*3),
                                      child: Text(
                                        logic.tenantTitle!.value,
                                        style: TextStyle(
                                            color: HhColors.grayCCTextColor,
                                            fontSize: 15.sp*3),
                                      ),
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 0.5.w,
                                        width: 1.sw,
                                        margin: EdgeInsets.fromLTRB(
                                            20.w, 0, 20.w, 0),
                                        color: HhColors.grayDDTextColor,
                                      ))
                                ],
                              ),
                            ),
                    ],
                  ),
                ),

                ///安全设置
                Container(
                  margin: EdgeInsets.fromLTRB(9.w*3, 30.w, 0, 20.w),
                  child: Text(
                    "安全设置",
                    style: TextStyle(
                        color: HhColors.gray6TextColor, fontSize: 14.sp*3),
                  ),
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ///安全手机
                      InkWell(
                        onTap: () {
                          Get.to(
                              () => PhonePage(
                                    keys: 'phone',
                                    titles: '修改手机号',
                                  ),
                              binding: PhoneBinding());
                        },
                        child: SizedBox(
                          height: 50.w*3,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 15.w*3),
                                  child: Text(
                                    "安全手机",
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
                                    CommonUtils()
                                        .mobileString(logic.mobile!.value),
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
                      /*///安全邮箱
                      InkWell(
                        onTap: (){
                          Get.to(() => EditPage(keys: 'email',titles: '修改邮箱',), binding: EditBinding());
                        },
                        child: SizedBox(
                          height:110.w,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin:EdgeInsets.only(left: 30.w),
                                  child: Text(
                                    "安全邮箱",
                                    style: TextStyle(
                                        color: HhColors.textBlackColor,
                                        fontSize: 28.sp,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin:EdgeInsets.only(right: 65.w),
                                  child: Text(
                                    CommonUtils().emailString(logic.email!.value),
                                    style: TextStyle(
                                        color: HhColors.gray9TextColor,
                                        fontSize: 26.sp),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin:EdgeInsets.fromLTRB(0,6.w,30.w,0),
                                  child: Image.asset(
                                    "assets/images/common/back_role.png",
                                    width: 25.w,
                                    height: 25.w,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child:Container(
                                  height: 0.5.w,
                                  width: 1.sw,
                                  margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                  color: HhColors.grayDDTextColor,
                                )
                              )
                            ],
                          ),
                        ),
                      ),*/

                      ///设置新密码
                      SizedBox(
                        height: 50.w*3,
                        child: InkWell(
                          onTap: () {
                            Get.to(
                                () => NewPasswordPage(
                                      keys: 'password',
                                      titles: '修改密码',
                                    ),
                                binding: NewPasswordBinding());
                          },
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 15.w*3),
                                  child: Text(
                                    "设置新密码",
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
                                    "",
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
                    ],
                  ),
                ),

                ///地区和语言
                /*Container(
                  margin: EdgeInsets.fromLTRB(15.w, 20.w, 0, 20.w),
                  child: Text(
                    "地区和语言",
                    style: TextStyle(
                        color: HhColors.gray6TextColor,
                        fontSize: 28.sp),
                  ),
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(14.w))
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ///地区
                      SizedBox(
                        height:110.w,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin:EdgeInsets.only(left: 30.w),
                                child: Text(
                                  "地区",
                                  style: TextStyle(
                                      color: HhColors.textBlackColor,
                                      fontSize: 28.sp,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin:EdgeInsets.only(right: 65.w),
                                child: Text(
                                  "中国大陆",
                                  style: TextStyle(
                                      color: HhColors.gray9TextColor,
                                      fontSize: 26.sp),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin:EdgeInsets.fromLTRB(0,6.w,30.w,0),
                                child: Image.asset(
                                  "assets/images/common/back_role.png",
                                  width: 25.w,
                                  height: 25.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child:Container(
                                  height: 0.5.w,
                                  width: 1.sw,
                                  margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                  color: HhColors.grayDDTextColor,
                                )
                            )
                          ],
                        ),
                      ),
                      ///多语言
                      SizedBox(
                        height:110.w,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin:EdgeInsets.only(left: 30.w),
                                child: Text(
                                  "多语言",
                                  style: TextStyle(
                                      color: HhColors.textBlackColor,
                                      fontSize: 28.sp,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin:EdgeInsets.only(right: 65.w),
                                child: Text(
                                  "简体中文",
                                  style: TextStyle(
                                      color: HhColors.gray9TextColor,
                                      fontSize: 26.sp),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin:EdgeInsets.fromLTRB(0,6.w,30.w,0),
                                child: Image.asset(
                                  "assets/images/common/back_role.png",
                                  width: 25.w,
                                  height: 25.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child:Container(
                                  height: 0.5.w,
                                  width: 1.sw,
                                  margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                  color: HhColors.grayDDTextColor,
                                )
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),*/

                ///其他设置
                Container(
                  margin: EdgeInsets.fromLTRB(9.w*3, 30.w, 0, 20.w),
                  child: Text(
                    "其他设置",
                    style: TextStyle(
                        color: HhColors.gray6TextColor, fontSize: 14.sp*3),
                  ),
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                                  margin: EdgeInsets.only(left: 15.w*3),
                                  child: Text(
                                    "清除缓存",
                                    style: TextStyle(
                                        color: HhColors.textBlackColor,
                                        fontSize: 14.sp*3,
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
                                  margin: EdgeInsets.only(left: 15.w*3),
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
                    ],
                  ),
                ),

                InkWell(
                  onTap: () async {
                    CommonUtils().showConfirmDialog(
                        logic.context, '退出后将不能接收信息，确定要退出?', () {
                      Get.back();
                    }, () async {
                      Get.back();
                      logic.loginOut();
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? id = prefs.getString(SPKeys().id);
                      String? token = prefs.getString(SPKeys().token);
                      XgFlutterPlugin().deleteAccount(id!, AccountType.UNKNOWN);
                      XgFlutterPlugin().deleteAccount(token!, AccountType.UNKNOWN);
                      XgFlutterPlugin().deleteTags([id,"test"]);
                      prefs.remove(SPKeys().token);
                      CommonData.tenant = CommonData.tenantDef;
                      CommonData.tenantName = CommonData.tenantNameDef;
                      CommonData.token = null;
                      CommonUtils().toLogin();
                    }, () {
                      Get.back();
                    });
                  },
                  child: Container(
                    width: 1.sw,
                    height: 44.w*3,
                    margin: EdgeInsets.fromLTRB(0, 50.w, 0, 50.w),
                    decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
                    child: Center(
                      child: Text(
                        "退出登录",
                        style: TextStyle(
                            color: HhColors.titleColorRed, fontSize: 15.sp*3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future getImageFromGallery(int num) async {
    final List<XFile> pickedFileList = await ImagePicker().pickMultiImage(
      maxWidth: 3000,
      maxHeight: 3000,
      imageQuality: 1,
    );
    if (pickedFileList.isNotEmpty) {
      logic.file = pickedFileList[0];
      logic.picture.value = false;
      logic.picture.value = true;

      logic.fileUpload();
    }
  }

  Future<void> getImageFromCamera() async {
    final XFile? photo = await ImagePicker().pickImage(source: ImageSource.camera);
    if (photo != null) {
      logic.file = photo;
      logic.picture.value = false;
      logic.picture.value = true;
      logic.fileUpload();
    }
  }


  void showChooseTypeDialog() {
    showModalBottomSheet(context: logic.context, builder: (a){
      return Container(
        width: 1.sw,
        decoration: BoxDecoration(
            color: HhColors.trans,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8.w*3))
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BouncingWidget(
              duration: const Duration(milliseconds: 100),
              scaleFactor: 0,
              child: Container(
                width: 1.sw,
                height: 50.w*3,
                margin: EdgeInsets.fromLTRB(0, 20.w*3, 0, 0),
                decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8.w*3))
                ),
                child: Center(
                  child: Text(
                    "拍摄",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: HhColors.blackColor, fontSize: 15.sp*3),
                  ),
                ),
              ),
              onPressed: () {
                getImageFromCamera();
                Get.back();
              },
            ),
            Container(
              color: HhColors.grayLineColor,
              height: 2.w,
              width: 1.sw,
            ),
            BouncingWidget(
              duration: const Duration(milliseconds: 100),
              scaleFactor: 0,
              child: Container(
                width: 1.sw,
                height: 50.w*3,
                color: HhColors.whiteColor,
                child: Center(
                  child: Text(
                    "从相册选择",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: HhColors.blackColor, fontSize: 15.sp*3),
                  ),
                ),
              ),
              onPressed: () {
                getImageFromGallery(1);
                Get.back();
              },
            ),
            Container(
              color: HhColors.grayLineColor,
              height: 2.w,
              width: 1.sw,
            ),
            BouncingWidget(
              duration: const Duration(milliseconds: 100),
              scaleFactor: 0,
              child: Container(
                width: 1.sw,
                height: 60.w*3,
                color: HhColors.whiteColor,
                padding: EdgeInsets.only(bottom: 10.w*3),
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
            ),
          ],
        ),
      );
    },isDismissible: true,enableDrag: false,backgroundColor: HhColors.trans);
  }
}
