#import "AMapFlutterMapPlugin.h"
#import "AMapFlutterFactory.h"
#import "Navi/QcAmapNaviHandler.h"

@interface AMapFlutterMapPlugin ()
@property (nonatomic, weak) NSObject<FlutterPluginRegistrar>* registrar;
@property (nonatomic, strong) QcAmapNaviHandler *naviHandler;
@end

@implementation AMapFlutterMapPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    AMapFlutterFactory* aMapFactory = [[AMapFlutterFactory alloc] initWithRegistrar:registrar];
    [registrar registerViewFactory:aMapFactory
                            withId:@"com.amap.flutter.map"
  gestureRecognizersBlockingPolicy:
     FlutterPlatformViewGestureRecognizersBlockingPolicyWaitUntilTouchesEnded];

    AMapFlutterMapPlugin *instance = [[AMapFlutterMapPlugin alloc] initWithRegistrar:registrar];
    FlutterMethodChannel *naviChannel = [FlutterMethodChannel methodChannelWithName:@"flutter_amap_navi"
                                                                    binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:instance channel:naviChannel];
}

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    self = [super init];
    if (self) {
        _registrar = registrar;
        _naviHandler = [[QcAmapNaviHandler alloc] initWithRegistrar:registrar];
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    [self.naviHandler handleMethodCall:call result:result];
}

@end
