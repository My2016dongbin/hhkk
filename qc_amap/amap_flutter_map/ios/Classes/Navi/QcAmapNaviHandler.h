#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface QcAmapNaviHandler : NSObject

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar;
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;

@end

NS_ASSUME_NONNULL_END
