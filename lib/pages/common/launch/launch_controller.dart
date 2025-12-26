import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/home/home_binding.dart';
import 'package:iot/pages/home/home_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/Permissions.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaunchController extends GetxController {
  final Rx<bool> testStatus = true.obs;
  final Rx<bool> secondStatus = true.obs;
  late BuildContext? context;
  late StreamSubscription showToastSubscription;
  late StreamSubscription showLoadingSubscription;

  @override
  Future<void> onInit() async {
    ///初始化SP
    Permissions.init();
    CommonUtils.init();
    permission();
    showLoadingSubscription =
        EventBusUtil.getInstance().on<HhLoading>().listen((event) {
          if (event.show) {
            if(event.title!=null && event.title!=""){
              CommonData.loadingInfo = event.title??"";
            }else{
              CommonData.loadingInfo = CommonData.loadingInfoFinal;
            }
            context!.loaderOverlay.show();
          } else {
            context!.loaderOverlay.hide();
          }
        });

    showToastSubscription =
        EventBusUtil.getInstance().on<HhToast>().listen((event) {
          if (event.title.isEmpty || event.title == "null") {
            return;
          }
          if(event.title.length > 50){
            event.title = event.title.substring(0,50);
          }

          showToastWidget(
            Container(
              margin: EdgeInsets.fromLTRB(20.w * 3, 15.w * 3, 20.w * 3, 25.w * 3),
              padding: EdgeInsets.fromLTRB(30.w * 3,
                  event.type == 0 ? 18.h * 3 : 25.h * 3, 30.w * 3, 18.h * 3),
              decoration: BoxDecoration(
                  color: HhColors.blackColor.withAlpha(200),
                  borderRadius: BorderRadius.all(Radius.circular(8.w * 3))),
              constraints: BoxConstraints(minWidth: 117.w * 3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // event.type==0?const SizedBox():SizedBox(height: 16.w*3,),
                  event.type == 0
                      ? const SizedBox()
                      : Image.asset(
                    event.type == 1
                        ? 'assets/images/common/icon_success.png'
                        : event.type == 2
                        ? 'assets/images/common/icon_error.png'
                        : event.type == 3
                        ? 'assets/images/common/icon_lock.png'
                        : 'assets/images/common/icon_warn.png',
                    height: 20.w * 3,
                    width: 20.w * 3,
                    fit: BoxFit.fill,
                  ),
                  event.type == 0
                      ? const SizedBox()
                      : SizedBox(
                    height: 16.h * 3,
                  ),
                  // SizedBox(height: 16.h*3,),
                  Text(
                    event.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: HhColors.whiteColor, fontSize: 16.sp * 3),
                  ),
                  // SizedBox(height: 10.h*3,)
                  // event.type==0?SizedBox(height: 10.h*3,):SizedBox(height: 10.h*3,),
                ],
              ),
            ),
            context: context,
            animation: StyledToastAnimation.slideFromBottomFade,
            reverseAnimation: StyledToastAnimation.fade,
            position: StyledToastPosition.center,
            animDuration: const Duration(seconds: 1),
            duration: const Duration(seconds: 2),
            curve: Curves.elasticOut,
            reverseCurve: Curves.linear,
          );
        });
    super.onInit();
  }

  @override
  void onClose() {
    try {
      showToastSubscription.cancel();
      showLoadingSubscription.cancel();
    } catch (e) {
      //
    }
    super.onClose();
  }

  Future<void> info() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true, title: '自动登录中..'));
    var result = await HhHttp().request(
      RequestUtils.userInfo,
      method: DioMethod.get,
      data: {},
    );
    HhLog.d("info -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0 && result["data"] != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SPKeys().endpoint, /*'${result["data"]["endpoint"]}'*/CommonData.endpoint??"");
      await prefs.setString(SPKeys().id, '${result["data"]["id"]}');
      await prefs.setString(SPKeys().username, '${result["data"]["username"]}');
      await prefs.setString(SPKeys().nickname, '${result["data"]["nickname"]}');
      await prefs.setString(SPKeys().email, '${result["data"]["email"]}');
      await prefs.setString(SPKeys().mobile, '${result["data"]["mobile"]}');
      await prefs.setString(SPKeys().sex, '${result["data"]["sex"]}');
      await prefs.setString(SPKeys().avatar, '${result["data"]["avatar"]}');
      await prefs.setString(SPKeys().roles, '${result["data"]["roles"]}');
      await prefs.setString(
          SPKeys().socialUsers, '${result["data"]["socialUsers"]}');
      await prefs.setString(SPKeys().posts, '${result["data"]["posts"]}');

      CommonData.endpoint = prefs.getString(SPKeys().endpoint);
      Future.delayed(const Duration(seconds: 2), () {
        Get.off(() => HomePage(), binding: HomeBinding(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 1000));
      });
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
      // Future.delayed(const Duration(seconds: 2), () {
      //   Get.offAll(() => LoginPage(), binding: LoginBinding());
      // });
      CommonUtils().tokenDown();
    }
  }

  Future<void> next() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(SPKeys().token);
    String? tenant = prefs.getString(SPKeys().tenant);
    String? tenantUserType = prefs.getString(SPKeys().tenantUserType);
    String? tenantName = prefs.getString(SPKeys().tenantName);
    bool? second = prefs.getBool(SPKeys().second);
    secondStatus.value = second == true;
    if (token != null) {
      //获取个人信息
      CommonData.token = token;
      CommonData.tenant = tenant;
      CommonData.tenantUserType = tenantUserType;
      CommonData.tenantName = tenantName;
      info();
    } else {
      if(second == true){
        Future.delayed(const Duration(seconds: 2), () {
          CommonUtils().toLogin();
        });
      }else{
        ///首次进入

      }
    }
  }

  Future<void> permission() async {
    /*if (await Permission.contacts.request().isGranted) {

    }*/
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.camera,
      Permission.microphone,
    ].request();
    if(statuses[Permission.location] != PermissionStatus.denied && statuses[Permission.storage] != PermissionStatus.denied && statuses[Permission.camera] != PermissionStatus.denied&& statuses[Permission.microphone] != PermissionStatus.denied){
      next();
    }else{

      showToastWidget(
        Container(
          margin: EdgeInsets.fromLTRB(20.w*3, 15.w*3, 20.w*3, 25.w*3),
          padding: EdgeInsets.fromLTRB(30.w*3, 25.h*3, 30.w*3, 18.h*3),
          decoration: BoxDecoration(
              color: HhColors.blackColor.withAlpha(200),
              borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
          constraints: BoxConstraints(
              minWidth: 117.w*3
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/common/icon_warn.png',
                height: 20.w*3,
                width: 20.w*3,
                fit: BoxFit.fill,
              ),
              SizedBox(height: 16.h*3,),
              // SizedBox(height: 16.h*3,),
              Text(
                '请授权',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: HhColors.whiteColor,
                    fontSize: 16.sp*3),
              ),
              // SizedBox(height: 10.h*3,)
              // event.type==0?SizedBox(height: 10.h*3,):SizedBox(height: 10.h*3,),
            ],
          ),
        ),
        context: context,
        animation: StyledToastAnimation.slideFromBottomFade,
        reverseAnimation: StyledToastAnimation.fade,
        position: StyledToastPosition.center,
        animDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 2),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear,
      );
      Future.delayed(const Duration(seconds: 1),(){
        SystemNavigator.pop();
      });
    }
  }
}
