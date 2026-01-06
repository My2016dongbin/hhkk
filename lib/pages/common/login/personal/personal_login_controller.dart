import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/login/code/code_binding.dart';
import 'package:iot/pages/common/login/code/code_view.dart';
import 'package:iot/pages/home/home_binding.dart';
import 'package:iot/pages/home/home_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tpns_flutter_plugin/tpns_flutter_plugin.dart';

class PersonalLoginController extends GetxController {
  late BuildContext context;
  final Rx<bool> testStatus = true.obs;
  final Rx<bool> pageStatus = false.obs;
  final Rx<bool> tenantStatus = false.obs;
  final Rx<bool> accountStatus = false.obs;
  final Rx<bool> passwordStatus = false.obs;
  final Rx<bool> passwordShowStatus = false.obs;
  final Rx<bool> confirmStatus = false.obs;
  TextEditingController? accountController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  late StreamSubscription showToastSubscription;
  late StreamSubscription showLoadingSubscription;
  late String? account;
  late String? password;

  @override
  Future<void> onInit() async {

    showToastSubscription =
        EventBusUtil.getInstance().on<HhToast>().listen((event) {
          if(event.title.isEmpty || event.title == "null"){
            return;
          }

          showToastWidget(
            Container(
              margin: EdgeInsets.fromLTRB(20.w*3, 15.w*3, 20.w*3, 25.w*3),
              padding: EdgeInsets.fromLTRB(30.w*3, event.type==0?18.h*3:25.h*3, 30.w*3, 18.h*3),
              decoration: BoxDecoration(
                  color: HhColors.blackColor.withAlpha(200),
                  borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
              constraints: BoxConstraints(
                  minWidth: 117.w*3
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // event.type==0?const SizedBox():SizedBox(height: 16.w*3,),
                  event.type==0?const SizedBox():Image.asset(
                    event.type==1?'assets/images/common/icon_success.png':event.type==2?'assets/images/common/icon_error.png':event.type==3?'assets/images/common/icon_lock.png':'assets/images/common/icon_warn.png',
                    height: 20.w*3,
                    width: 20.w*3,
                    fit: BoxFit.fill,
                  ),
                  event.type==0?const SizedBox():SizedBox(height: 16.h*3,),
                  // SizedBox(height: 16.h*3,),
                  Text(
                    event.title,
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
    });
    showLoadingSubscription =
        EventBusUtil.getInstance().on<HhLoading>().listen((event) {
          if (event.show) {
            if(event.title!=null && event.title!=""){
              CommonData.loadingInfo = event.title??"";
            }else{
              CommonData.loadingInfo = CommonData.loadingInfoFinal;
            }
            context.loaderOverlay.show();
          } else {
            context.loaderOverlay.hide();
          }
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString(SPKeys().token);
    account = prefs.getString(SPKeys().account);
    password = prefs.getString(SPKeys().password);
    if (account != null && password != null) {
      accountController?.text = account!;
      passwordController?.text = password!;
    }

    super.onInit();
  }

  Future<void> getTenantId() async {
    Map<String, dynamic> map = {};
    map['name'] = CommonData.tenantName;
    var tenantResult = await HhHttp().request(
      RequestUtils.tenantId,
      method: DioMethod.get,
      params: map,
    );
    HhLog.d("tenant -- $tenantResult");
    if (tenantResult["code"] == 0 && tenantResult["data"] != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SPKeys().tenant, '${tenantResult["data"]['id']}');
      await prefs.setString(SPKeys().tenantName, CommonData.tenantName!);
      CommonData.tenant = '${tenantResult["data"]['id']}';
      CommonData.tenantName = CommonData.tenantName;
      CommonData.tenantUserType = '${tenantResult["data"]['userType']}';
      await prefs.setString(SPKeys().tenantUserType, CommonData.tenantUserType!);
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString("租户信息不存在"/*tenantResult["msg"]*/),type: 2));
    }
  }

  Future<void> sendCode() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true,title: '正在发送短信..'));
    var result = await HhHttp().request(
      RequestUtils.codeSend,
      method: DioMethod.post,
      data: {'mobile':accountController!.text,'scene':21},
    );
    HhLog.d("sendCode -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0 && result["data"] != null) {
      Get.to(()=>CodePage(accountController!.text),binding: CodeBinding());
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"]),type: 2));
    }
  }

  Future<void> getTenant() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true, title: '正在登录..'));
    Map<String, dynamic> map = {};
    map['name'] = CommonData.tenantName;
    var tenantResult = await HhHttp().request(
      RequestUtils.tenantId,
      method: DioMethod.get,
      params: map,
    );
    HhLog.d("tenant -- ${RequestUtils.tenantId}");
    HhLog.d("tenant -- $map");
    HhLog.d("tenant -- $tenantResult");
    if (tenantResult["code"] == 0 && tenantResult["data"] != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SPKeys().tenant, '${tenantResult["data"]['id']}');
      await prefs.setString(SPKeys().tenantName, CommonData.tenantName!);
      CommonData.tenant = '${tenantResult["data"]["id"]}';
      CommonData.tenantUserType = '${tenantResult["data"]["userType"]}';
      await prefs.setString(SPKeys().tenantUserType, CommonData.tenantUserType!);
      login();
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString("租户信息不存在"/*tenantResult["msg"]*/),type: 2));
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    }
  }

  Future<void> login() async {
    var result = await HhHttp().request(
      RequestUtils.login,
      method: DioMethod.post,
      data: {
        "username": accountController?.text,
        "password": passwordController?.text,
        "tenantName": "${CommonData.tenantName}"
      },
    );
    HhLog.d("login -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SPKeys().token, result["data"]["accessToken"]);
      await prefs.setString(SPKeys().account, accountController!.text);
      await prefs.setString(SPKeys().password, passwordController!.text);
      CommonData.token = result["data"]["accessToken"];

      info();

    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"]),type: 2));
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    }
  }

  Future<void> info() async {
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
      // CommonData.endpoint = '${result["data"]["endpoint"]}';
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
      await prefs.setBool(SPKeys().voice, true);


      // XgFlutterPlugin().setTags(["${result["data"]["id"]}"]);
      // XgFlutterPlugin().setAccount("${result["data"]["id"]}",AccountType.UNKNOWN);
      XgFlutterPlugin().deleteAccount('${result["data"]["id"]}',AccountType.UNKNOWN);
      XgFlutterPlugin().deleteAccount("${CommonData.token}", AccountType.UNKNOWN);
      XgFlutterPlugin().deleteTags(["${CommonData.token}","test"]);
      EventBusUtil.getInstance().fire(HhToast(title: '登录成功',type: 1));

      Future.delayed(const Duration(seconds: 1), () {
        XgFlutterPlugin().setAccount("${CommonData.token}",AccountType.UNKNOWN);
        if(CommonData.test){
          XgFlutterPlugin().setTags(["test"]);
        }
        Get.offAll(() => HomePage(), binding: HomeBinding(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 1000));
      });
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"]),type: 2));
    }
  }
}
