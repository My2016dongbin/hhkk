#import <Flutter/Flutter.h>

@interface QcHikPlayerView : NSObject<FlutterPlatformView>

- (instancetype _Nonnull)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger> * _Nonnull)messenger;

@end
