import 'package:get/get.dart';
import 'package:iot/pages/common/launch/launch_binding.dart';
import 'package:iot/pages/common/launch/launch_view.dart';

import '../pages/home/home_binding.dart';
import '../pages/home/home_view.dart';
import '../pages/home/main/main_binding.dart';
import '../pages/home/main/main_view.dart';
import '../pages/home/space/space_binding.dart';
import '../pages/home/space/space_view.dart';

part 'app_routes.dart';

class AppPages {
  /// 左滑关闭页面用于android
  static _pageBuilder({
    required String name,
    required GetPageBuilder page,
    Bindings? binding,
    bool preventDuplicates = true,
  }) =>
      GetPage(
        name: name,
        page: page,
        binding: binding,
        preventDuplicates: preventDuplicates,
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 1000),
        popGesture: true,
      );

  static final routes = <GetPage>[
    _pageBuilder(
      name: AppRoutes.launch,
      page: () => LaunchPage(),
      binding: LaunchBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    // ...OPages.pages, // 组织架构
    // ...WPages.pages, // 工作圈
    // ...MPages.pages, //
  ];
}
