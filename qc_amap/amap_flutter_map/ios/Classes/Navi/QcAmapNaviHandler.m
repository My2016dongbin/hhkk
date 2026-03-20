#import "QcAmapNaviHandler.h"
#import "AMapHeaderCompat.h"
#import <UIKit/UIKit.h>

#if __has_include(<MAMapKit/MAOfflineMapViewController.h>)
#import <MAMapKit/MAOfflineMapViewController.h>
#elif __has_include(<AMap3DMap/MAOfflineMapViewController.h>)
#import <AMap3DMap/MAOfflineMapViewController.h>
#endif

@interface QcAmapNaviHandler () <AMapNaviDriveManagerDelegate, AMapNaviDriveViewDelegate>
@property (nonatomic, weak) NSObject<FlutterPluginRegistrar>* registrar;
@property (nonatomic, strong, nullable) AMapNaviDriveView *driveView;
@property (nonatomic, strong, nullable) AMapNaviDriveManager *driveManager;
@property (nonatomic, copy, nullable) FlutterResult pendingResult;
@end

@implementation QcAmapNaviHandler

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    self = [super init];
    if (self) {
        _registrar = registrar;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"startNavi" isEqualToString:call.method]) {
        [self startNaviWithArguments:call.arguments result:result];
    } else if ([@"stopNavi" isEqualToString:call.method]) {
        [self stopNavigation];
        result(nil);
    } else if ([@"openOfflineMap" isEqualToString:call.method]) {
        [self openOfflineMapWithResult:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)startNaviWithArguments:(NSDictionary *)args result:(FlutterResult)result {
    NSNumber *fromLatNum = args[@"fromLat"];
    NSNumber *fromLngNum = args[@"fromLng"];
    NSNumber *toLatNum = args[@"toLat"];
    NSNumber *toLngNum = args[@"toLng"];
    if (!fromLatNum || !fromLngNum || !toLatNum || !toLngNum) {
        result([FlutterError errorWithCode:@"INVALID_ARGS"
                                   message:@"fromLat/fromLng/toLat/toLng are required"
                                   details:nil]);
        return;
    }

    [self stopNavigation];

    self.driveView = [[AMapNaviDriveView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.driveView.delegate = self;
    self.driveView.showMoreButton = NO;
    self.driveView.showCompass = YES;

    // 强制锁车跟随，避免画面停留在起点
    if ([self.driveView respondsToSelector:@selector(setShowMode:)]) {
        self.driveView.showMode = AMapNaviDriveViewShowModeCarPositionLocked;
    }
    if ([self.driveView respondsToSelector:@selector(setTrackingMode:)]) {
        self.driveView.trackingMode = AMapNaviViewTrackingModeCarNorth;
    }

    self.driveManager = [AMapNaviDriveManager sharedInstance];
    self.driveManager.delegate = self;
    self.driveManager.isUseInternalTTS = YES;
    [self.driveManager addDataRepresentative:self.driveView];

    AMapNaviPoint *start = [AMapNaviPoint locationWithLatitude:fromLatNum.doubleValue
                                                     longitude:fromLngNum.doubleValue];
    AMapNaviPoint *end = [AMapNaviPoint locationWithLatitude:toLatNum.doubleValue
                                                   longitude:toLngNum.doubleValue];

    BOOL success = [self.driveManager calculateDriveRouteWithStartPoints:@[start]
                                                               endPoints:@[end]
                                                               wayPoints:nil
                                                         drivingStrategy:0];
    if (!success) {
        [self stopNavigation];
        result([FlutterError errorWithCode:@"CALCULATE_ROUTE_FAILED"
                                   message:@"Failed to start route calculation"
                                   details:nil]);
        return;
    }

    UIViewController *hostVC = [self hostViewController];
    if (!hostVC) {
        [self stopNavigation];
        result([FlutterError errorWithCode:@"NO_VIEW_CONTROLLER"
                                   message:@"Unable to find an iOS host view controller"
                                   details:nil]);
        return;
    }

    self.driveView.frame = hostVC.view.bounds;
    self.driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [hostVC.view addSubview:self.driveView];

    self.pendingResult = result;
}

- (void)openOfflineMapWithResult:(FlutterResult)result {
    UIViewController *hostVC = [self hostViewController];
    if (!hostVC) {
        result([FlutterError errorWithCode:@"NO_VIEW_CONTROLLER"
                                   message:@"Unable to find iOS host view controller"
                                   details:nil]);
        return;
    }

    UIViewController *offlineVC = nil;
    Class offlineCls = NSClassFromString(@"MAOfflineMapViewController");
    if (offlineCls) {
        offlineVC = [[offlineCls alloc] init];
    }

    if (!offlineVC) {
        result([FlutterError errorWithCode:@"OFFLINE_MAP_UNAVAILABLE"
                                   message:@"MAOfflineMapViewController not found in current iOS AMap SDK"
                                   details:nil]);
        return;
    }

    __weak typeof(self) weakSelf = self;

    dispatch_async(dispatch_get_main_queue(), ^{

        // 状态栏文字改为黑色
        if (@available(iOS 13.0, *)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDarkContent;
#pragma clang diagnostic pop
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
#pragma clang diagnostic pop
        }

        // 添加返回按钮
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:weakSelf
                                                                    action:@selector(qc_closeOfflineMapPage)];
        offlineVC.navigationItem.leftBarButtonItem = backItem;

        if (hostVC.navigationController) {
            offlineVC.hidesBottomBarWhenPushed = YES;
            [hostVC.navigationController pushViewController:offlineVC animated:YES];
        } else {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:offlineVC];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [hostVC presentViewController:nav animated:YES completion:nil];
        }

        result(nil);
    });
}

- (void)qc_closeOfflineMapPage {
    UIViewController *hostVC = [self hostViewController];
    if (!hostVC) {
        return;
    }

    if (hostVC.navigationController && hostVC.navigationController.viewControllers.count > 1) {
        [hostVC.navigationController popViewControllerAnimated:YES];
    } else if (hostVC.presentingViewController) {
        [hostVC dismissViewControllerAnimated:YES completion:nil];
    } else if (hostVC.navigationController.presentingViewController) {
        [hostVC.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIViewController *)hostViewController {
    UIWindow *keyWindow = nil;

    if (@available(iOS 13.0, *)) {
        NSSet<UIScene *> *scenes = UIApplication.sharedApplication.connectedScenes;
        for (UIScene *scene in scenes) {
            if (![scene isKindOfClass:[UIWindowScene class]]) {
                continue;
            }
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            for (UIWindow *window in windowScene.windows) {
                if (window.isKeyWindow) {
                    keyWindow = window;
                    break;
                }
            }
            if (keyWindow) {
                break;
            }
        }
    }

    if (!keyWindow) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        keyWindow = UIApplication.sharedApplication.keyWindow;
#pragma clang diagnostic pop
    }

    UIViewController *vc = keyWindow.rootViewController;

    while (true) {
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
            continue;
        }

        if ([vc isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)vc;
            if (nav.topViewController) {
                vc = nav.topViewController;
                continue;
            }
        }

        if ([vc isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)vc;
            if (tab.selectedViewController) {
                vc = tab.selectedViewController;
                continue;
            }
        }

        break;
    }

    return vc;
}

- (void)stopNavigation {
    if (self.driveManager) {
        [self.driveManager stopNavi];
        if (self.driveView) {
            [self.driveManager removeDataRepresentative:self.driveView];
        }
        self.driveManager.delegate = nil;
    }

    [self.driveView removeFromSuperview];
    self.driveView.delegate = nil;
    self.driveView = nil;
    self.driveManager = nil;
    self.pendingResult = nil;
}

#pragma mark - AMapNaviDriveManagerDelegate

- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager {
    if ([self.driveView respondsToSelector:@selector(setShowMode:)]) {
        self.driveView.showMode = AMapNaviDriveViewShowModeCarPositionLocked;
    }
    if ([self.driveView respondsToSelector:@selector(setTrackingMode:)]) {
        self.driveView.trackingMode = AMapNaviViewTrackingModeCarNorth;
    }

    [driveManager startGPSNavi];

    if (self.pendingResult) {
        self.pendingResult(nil);
        self.pendingResult = nil;
    }
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error {
    FlutterResult result = self.pendingResult;
    [self stopNavigation];
    if (result) {
        result([FlutterError errorWithCode:@"CALCULATE_ROUTE_FAILED"
                                   message:error.localizedDescription ?: @"Route calculation failed"
                                   details:nil]);
    }
}

#pragma mark - AMapNaviDriveViewDelegate

- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView {
    [self stopNavigation];
}

@end