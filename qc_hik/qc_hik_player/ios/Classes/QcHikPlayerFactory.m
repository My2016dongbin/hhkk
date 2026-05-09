#import "QcHikPlayerFactory.h"
#import "QcHikPlayerView.h"

@interface QcHikPlayerFactory ()

@property (nonatomic, strong) NSObject<FlutterBinaryMessenger> *messenger;

@end

@implementation QcHikPlayerFactory

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec {
  return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame
                                    viewIdentifier:(int64_t)viewId
                                         arguments:(id)args {
  return [[QcHikPlayerView alloc] initWithFrame:frame
                                 viewIdentifier:viewId
                                      arguments:args
                                binaryMessenger:self.messenger];
}

@end
