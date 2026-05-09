#import <Flutter/Flutter.h>

@interface QcHikPlayerFactory : NSObject<FlutterPlatformViewFactory>

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messenger;

@end
