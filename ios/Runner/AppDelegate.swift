import UIKit
import Flutter
import AMapFoundationKit
import AMapLocationKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

                // 全局状态栏文字改为黑色
                if #available(iOS 13.0, *) {
                  UIApplication.shared.statusBarStyle = .darkContent
                } else {
                  UIApplication.shared.statusBarStyle = .default
                }

                // 高德 Key
                AMapServices.shared().apiKey = "7d20ebdef372335e82fb6a0a9bfdf208"

                // 先做定位 SDK 隐私合规
                AMapLocationManager.updatePrivacyShow(.didShow, privacyInfo: .didContain)
                AMapLocationManager.updatePrivacyAgree(.didAgree)

                GeneratedPluginRegistrant.register(with: self)

                return super.application(application, didFinishLaunchingWithOptions: launchOptions)
              }
}
