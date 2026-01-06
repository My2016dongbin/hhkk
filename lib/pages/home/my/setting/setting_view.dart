import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/pages/home/my/setting/password/new/new_password_binding.dart';
import 'package:iot/pages/home/my/setting/password/new/new_password_view.dart';
import 'package:iot/pages/home/my/setting/phone/phone_binding.dart';
import 'package:iot/pages/home/my/setting/phone/phone_view.dart';
import 'package:iot/pages/home/my/setting/setting_controller.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhColors.dart';

class SettingPage extends StatelessWidget {
  final logic = Get.find<SettingController>();

  SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              '安全设置',
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}
