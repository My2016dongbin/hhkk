import 'dart:convert';
import 'dart:io';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/launch/launch_controller.dart';
import 'package:iot/pages/common/share/manage/share_manage_binding.dart';
import 'package:iot/pages/common/share/manage/share_manage_view.dart';
import 'package:iot/pages/home/device/detail/call/call_binding.dart';
import 'package:iot/pages/home/device/detail/call/call_view.dart';
import 'package:iot/pages/home/home_controller.dart';
import 'package:iot/pages/home/home_view.dart';
import 'package:iot/res/strings.dart';
import 'package:iot/routes/app_pages.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/CustomNavigatorObserver.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/widgets/app_view.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:tpns_flutter_plugin/tpns_flutter_plugin.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';

void main() {
  //1334*750
  WidgetsFlutterBinding.ensureInitialized();
  //竖屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  FlutterError.onError = (FlutterErrorDetails details) {
    /*"<user:'${CustomerModel.phone}'>\n<token:'${CustomerModel.token}'>\n${details.stack}"*/
  };

  FlutterError.onError = (FlutterErrorDetails details) {
    /*FlutterBugly.uploadException(
        message: "${details.toStringShort()}",
        detail:
        "<user:'${CustomerModel.phone}'>\n<token:'${CustomerModel.token}'>\n${details.stack}");*/
  };

  /*///使用flutter异常上报
  FlutterBugly.postCatchedException(() {
    runApp(MyApp());
  });*/
  WidgetsFlutterBinding.ensureInitialized();//package_info_plus
  FlutterBugly.postCatchedException(() async {
    // 如果需要 ensureInitialized，请在这里运行。
    // WidgetsFlutterBinding.ensureInitialized();
    // 强制竖屏
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,    // 竖屏（正常）
    ]);
    runApp(const HhApp());
    ///注册bugly
    FlutterBugly.init(
        androidAppId: "0e51144628",
        iOSAppId: "ed96239f50");
  });

  if (Platform.isAndroid) {
    // android沉浸式。
    SystemUiOverlayStyle systemUiOverlayStyle =
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class HhApp extends StatefulWidget {
  const HhApp({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

class MyAppState extends State<HhApp> {
  @override
  void initState() {
    super.initState();

    ///百度地图sdk初始化鉴权
    /// 设置是否隐私政策
    LocationFlutterPlugin myLocPlugin = LocationFlutterPlugin();
    myLocPlugin.setAgreePrivacy(true);
    BMFMapSDK.setAgreePrivacy(true);
    if (Platform.isIOS) {
      BMFMapSDK.setApiKeyAndCoordType(
          'wARV9WoE9vC8q8QE7n7oTTC59541zYTy', BMF_COORD_TYPE.BD09LL);
    } else if (Platform.isAndroid) {
      // Android 目前不支持接口设置Apikey,
      // 请在主工程的Manifest文件里设置，详细配置方法请参考官网(https://lbsyun.baidu.com/)demo
      BMFMapSDK.setCoordType(BMF_COORD_TYPE.BD09LL);
    }

    ///推送注册
    if (Platform.isIOS) {
      XgFlutterPlugin().startXg("1600040929", "II8XISAN9WTV");
    } else {
      XgFlutterPlugin().startXg(CommonData.personal?"1500040929":"1500041692", CommonData.personal?"A2UCA4MQX4ST":"AAST7H0KI7QE");
    }
    XgFlutterPlugin().setEnableDebug(true);
    //注册回调
    XgFlutterPlugin().addEventHandler(
      onRegisteredDone: (String msg) async {
        HhLog.e("HomePage -> onRegisteredDone -> $msg");
      },
    );
    //通知类消息事件
    XgFlutterPlugin().addEventHandler(
      xgPushClickAction: (Map<String, dynamic> msg) async {
        HhLog.d("HomePage -> xgPushClickAction -> $msg");
        dynamic custom = jsonDecode(msg['customMessage']);
        if(CommonData.personal && custom!=null && custom['otherInfomation']['messageType']== "deviceShare"){
          Get.to(() => ShareManagePage(), binding: ShareManageBinding());
        }
      },
      onReceiveNotificationResponse: (Map<String, dynamic> msg) async {
        HhLog.d("HomePage -> onReceiveNotificationResponse -> $msg");
        EventBusUtil.getInstance().fire(Message());
        try{
          dynamic custom = jsonDecode(msg['customMessage']);
          HhLog.d("HomePage -> $custom ");

/*          //设备呼叫
          if(custom!=null && custom['devCode']!=null ){
            HhLog.d("HomePage  deviceNo ${custom['deviceNo']}");

            Get.to(()=>CallPage('${custom['deviceNo']}','id',0),binding: CallBinding());
          }*/
          //分享
          if(custom!=null && custom['otherInfomation']['messageType']== "deviceShare" && CommonData.personal){
            EventBusUtil.getInstance().fire(Share(model:custom['otherInfomation']));
          }
          //其他设备登录
          if(custom!=null && custom['otherInfomation']['messageType']== "logoutdelete"){
            CommonUtils().tokenOut();
          }
        }catch(e){
          //
        }
        ///消息刷新
        EventBusUtil.getInstance().fire(Message());
      },
      onReceiveMessage: (Map<String, dynamic> msg) async {
        HhLog.d("HomePage -> onReceiveMessage -> $msg");
      },
    );
    // 全局设置
    EasyRefresh.defaultHeaderBuilder = () => const CupertinoHeader(triggerOffset: 20);
    EasyRefresh.defaultFooterBuilder = () => const CupertinoFooter();
  }

  @override
  Widget build(BuildContext context) {
    //设置适配尺寸 (单位dp)
    return AppView(
        builder: (locale, builder) => GetMaterialApp(
              navigatorObservers: [CustomNavigatorObserver.getInstance()],
              title: CommonData.personal?'浩海卡口':'浩海卡口',
              theme: ThemeData(
                fontFamily: '.SF UI Display',
                // 使用系统默认字体
                // bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: CXColors.WhiteColor),
                primarySwatch: const MaterialColor(
                  0xFF293446,
                  <int, Color>{
                    50: Color(0xFFE3F2FD),
                    100: Color(0xFFBBDEFB),
                    200: Color(0xFF90CAF9),
                    300: Color(0xFF64B5F6),
                    400: Color(0xFF42A5F5),
                    500: Color(0xFF67A6F2),
                    600: Color(0xFF1E88E5),
                    700: Color(0xFF1976D2),
                    800: Color(0xFF1565C0),
                    900: Color(0xFF0D47A1),
                  },
                ),
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              builder: builder,
              // home: HomePage(),
              //显示debug
              debugShowCheckedModeBanner: false,
              //配置如下两个国际化的参数
              supportedLocales: const [
                Locale('zh', 'CH'),
                Locale('en', 'US'),
              ],

              enableLog: CommonData.test,
              //logWriterCallback: Logger.print,
              translations: TranslationService(),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                // DefaultCupertinoLocalizations.delegate,
              ],
              fallbackLocale: TranslationService.fallbackLocale,
              locale: locale,
              localeResolutionCallback: (locale, list) {
                Get.locale ??= locale;
                return locale;
              },
              getPages: AppPages.routes,
              initialBinding: InitBinding(),
              initialRoute: AppRoutes.launch,
            ));
  }
}

class InitBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put<HomeController>(HomeController());
    Get.put<LaunchController>(LaunchController());
  }
}
