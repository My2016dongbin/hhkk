#import "QcAmapNaviPlugin.h"
#import <AMapNaviKit/AMapNaviKit.h>

@interface QcAmapNaviPlugin () <AMapNaviDriveManagerDelegate, AMapNaviDriveViewDelegate>
@property (nonatomic, strong) AMapNaviDriveView *driveView;
@property (nonatomic, strong) AMapNaviDriveManager *driveManager;
@end

@implementation QcAmapNaviPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_amap_navi"
            binaryMessenger:[registrar messenger]];
  QcAmapNaviPlugin* instance = [[QcAmapNaviPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"startNavi" isEqualToString:call.method]) {
    NSDictionary *args = call.arguments;
    double fromLat = [args[@"fromLat"] doubleValue];
    double fromLng = [args[@"fromLng"] doubleValue];
    double toLat = [args[@"toLat"] doubleValue];
    double toLng = [args[@"toLng"] doubleValue];

    // 初始化导航视图
    self.driveView = [[AMapNaviDriveView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.driveView.delegate = self;
    self.driveView.showMoreButton = NO;
    self.driveView.showCompass = YES;

    // 初始化导航管理器
    self.driveManager = [AMapNaviDriveManager sharedInstance];
    self.driveManager.delegate = self;
    [self.driveManager addDataRepresentative:self.driveView];

    // 规划路线
    AMapNaviPoint *start = [AMapNaviPoint locationWithLatitude:fromLat longitude:fromLng];
    AMapNaviPoint *end = [AMapNaviPoint locationWithLatitude:toLat longitude:toLng];
    [self.driveManager calculateDriveRouteWithStartPoints:@[start]
                                               endPoints:@[end]
                                               wayPoints:nil
                                         drivingStrategy:0];

    // 获取当前显示的 controller 并显示导航 view
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    UIViewController *rootVC = window.rootViewController;
    [rootVC.view addSubview:self.driveView];

    result(@"iOS navigation started");
  } else {
    result(FlutterMethodNotImplemented);
  }
}

#pragma mark - AMapNaviDriveManagerDelegate

- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager {
  // 路径规划成功后开始导航
  [driveManager startGPSNavi];
}

@end
