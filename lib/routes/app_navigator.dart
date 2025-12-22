import 'package:get/get.dart';
import 'app_pages.dart';

class AppNavigator {
  AppNavigator._();
  static void startLogin() {
    Get.offAllNamed(AppRoutes.login);
  }

  static void startBackLogin() {
    Get.until((route) => Get.currentRoute == AppRoutes.login);
  }

  static void startMain() {
    Get.offAllNamed(
      AppRoutes.home,
    );
  }

  static void startSplashToMain() {
    Get.offAndToNamed(
      AppRoutes.home,
    );
  }

  static void startBackMain() {
    Get.until((route) => Get.currentRoute == AppRoutes.home);
  }
}
