import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:loader_overlay/loader_overlay.dart';


class AppView extends StatelessWidget {
  const AppView({Key? key, required this.builder}) : super(key: key);
  final Widget Function(Locale? locale, TransitionBuilder builder) builder;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      init: AppController(),
      builder: (ctrl) => ScreenUtilInit(
        designSize: const Size(1125, 2436),//const Size(750, 1334),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) => builder(ctrl.getLocale(), _builder()),
      ),
    );
  }

  static TransitionBuilder _builder() => (context,widget){
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        //textScaleFactor: Config.textScaleFactor,
      ),
      child: LoaderOverlay(
        overlayColor: HhColors.trans,
        closeOnBackButton: true,
        useDefaultLoading: false,
        overlayWidgetBuilder: (_) { //ignored progress for the moment
          return  Center(
            child: Container(
              height: 100.w*3,
              width: 125.w*3,
              decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius: BorderRadius.circular(10.w*3),
              ),
              clipBehavior: Clip.hardEdge,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10.w*3,),
                    SpinKitDualRing(
                      color: HhColors.mainBlueColor,
                      size: 24.w*3,
                      lineWidth: 2.5.w*3,
                    ),
                    SizedBox(height: 13.w*3,),
                    Text(CommonData.loadingInfo,style: TextStyle(color: HhColors.gray3TextColor,fontSize: 12.sp*3,fontWeight: FontWeight.w500,decoration: TextDecoration.none,),
                      maxLines: 1,textAlign: TextAlign.center,)
                  ],
                ),
              ),
            ),
          );
        },
        child: GestureDetector(
          onTap: () {
            //全局空白焦点
            FocusScopeNode focusScopeNode = FocusScope.of(context);
            if (!focusScopeNode.hasPrimaryFocus &&
                focusScopeNode.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
            //easyLoading
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: widget!,
        ),
      ),
    );
  };
}

class AppController extends GetxController {

  Locale? getLocale() {
    var local = Get.locale;
    var index = 1;//DataSp.getLanguage() ?? 0;
    switch (index) {
      case 1:
        local = const Locale('zh', 'CN');
        break;
      case 2:
        local = const Locale('en', 'US');
        break;
    }
    return local;
  }
}
