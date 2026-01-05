import 'dart:convert';
import 'dart:io';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/amap_location/location_service.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/share/manage/share_manage_binding.dart';
import 'package:iot/pages/common/share/manage/share_manage_view.dart';
import 'package:iot/res/strings.dart';
import 'package:iot/routes/app_pages.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/CustomNavigatorObserver.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/widgets/app_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tpns_flutter_plugin/tpns_flutter_plugin.dart';

Future<void> main() async {
  //1125, 2436
  WidgetsFlutterBinding.ensureInitialized();
  //竖屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  ///高德地图同意隐私政策（必须）
  await AmapLocationService().init();

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
        builder: (locale, builder) => RefreshConfiguration(
          headerBuilder: () => const WaterDropHeader(
            refresh: Text(''),
            complete: Text('刷新成功'),
          ),
          footerBuilder:  () => CustomFooter(builder: (BuildContext context, LoadStatus? mode) {
            Widget body ;
            if(mode==LoadStatus.idle){
              body =  const Text("上拉加载");
            }
            else if(mode==LoadStatus.loading){
              body =  const CupertinoActivityIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = const Text("加载失败！点击重试！");
            }
            else if(mode == LoadStatus.canLoading){
              body = const Text("松手,加载更多!");
            }
            else{
              body = const Text("没有更多数据了!");
            }
            return SizedBox(
              height: 55.0,
              child: Center(child:body),
            );
          },),        // 配置默认底部指示器
          headerTriggerDistance: 80.0,        // 头部触发刷新的越界距离
          springDescription:const SpringDescription(stiffness: 170, damping: 16, mass: 1.9),         // 自定义回弹动画,三个属性值意义请查询flutter api
          maxOverScrollExtent :100, //头部最大可以拖动的范围,如果发生冲出视图范围区域,请设置这个属性
          maxUnderScrollExtent:0, // 底部最大可以拖动的范围
          enableScrollWhenRefreshCompleted: true, //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
          enableLoadingWhenFailed : true, //在加载失败的状态下,用户仍然可以通过手势上拉来触发加载更多
          hideFooterWhenNotFull: false, // Viewport不满一屏时,禁用上拉加载更多功能
          enableBallisticLoad: true, // 可以通过惯性滑动触发加载更多
          child: GetMaterialApp(
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
          ),
        ));
  }
}

class InitBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put<HomeController>(HomeController());
    // Get.put<LaunchController>(LaunchController());
  }
}
