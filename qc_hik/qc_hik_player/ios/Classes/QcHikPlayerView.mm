#import "QcHikPlayerView.h"

#import <Flutter/Flutter.h>

#import "SMBasePlayer.h"
#import "SMEZPlayer.h"
#import "SMEZSDK.h"
#import "EZPlayer.h"

static NSString * const kQcHikPlayerConnectingText = @"视频流连接中...";
static NSString * const kQcHikPlayerInvalidParamsText = @"播放参数无效";
static NSString * const kQcHikPlayerMissingParamsText = @"播放参数缺失";

@interface QcHikBusinessPlayParams : NSObject

@property (nonatomic, copy) NSString *tokenAppKey;
@property (nonatomic, copy) NSString *httpUrlToken;
@property (nonatomic, copy) NSString *deviceSerial;
@property (nonatomic, assign) NSInteger channelNo;
@property (nonatomic, copy) NSString *deviceToken;
@property (nonatomic, copy) NSString *deviceGlobalToken;
@property (nonatomic, copy) NSString *deviceVideoToken;
@property (nonatomic, copy) NSString *streamLiveToken;

+ (instancetype _Nullable)paramsWithArguments:(id _Nullable)arguments;
- (BOOL)isValid;

@end

@implementation QcHikBusinessPlayParams

+ (instancetype)paramsWithArguments:(id)arguments {
  if (![arguments isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  NSDictionary *map = (NSDictionary *)arguments;
  QcHikBusinessPlayParams *params = [[QcHikBusinessPlayParams alloc] init];
  params.tokenAppKey = [self stringValue:map[@"tokenAppKey"]];
  params.httpUrlToken = [self stringValue:map[@"httpUrlToken"]];
  params.deviceSerial = [self stringValue:map[@"deviceSerial"]];
  params.channelNo = [self integerValue:map[@"channelNo"] fallback:1];
  params.deviceToken = [self stringValue:map[@"deviceToken"]];
  params.deviceGlobalToken = [self stringValue:map[@"deviceGlobalToken"]];
  params.deviceVideoToken = [self stringValue:map[@"deviceVideoToken"]];
  params.streamLiveToken = [self stringValue:map[@"streamLiveToken"]];
  return params;
}

+ (NSString *)stringValue:(id)value {
  if (value == nil || value == [NSNull null]) {
    return @"";
  }
  return [NSString stringWithFormat:@"%@", value];
}

+ (NSInteger)integerValue:(id)value fallback:(NSInteger)fallback {
  if ([value isKindOfClass:[NSNumber class]]) {
    return [((NSNumber *)value) integerValue];
  }
  if ([value isKindOfClass:[NSString class]]) {
    return [((NSString *)value) integerValue];
  }
  return fallback;
}

- (BOOL)isValid {
  return self.tokenAppKey.length > 0 &&
      self.httpUrlToken.length > 0 &&
      self.deviceSerial.length > 0 &&
      self.deviceToken.length > 0 &&
      self.deviceGlobalToken.length > 0 &&
      self.deviceVideoToken.length > 0 &&
      self.streamLiveToken.length > 0;
}

@end

@interface QcHikPlayerView () <FlutterStreamHandler, SMBasePlayerDelegate>

@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, strong) UIView *playerContainerView;
@property (nonatomic, strong) FlutterMethodChannel *methodChannel;
@property (nonatomic, strong) FlutterEventChannel *eventChannel;
@property (nonatomic, strong, nullable) SMEZPlayer *player;
@property (nonatomic, strong, nullable) QcHikBusinessPlayParams *playParams;
@property (nonatomic, strong, nullable) NSDictionary *pendingEvent;
@property (nonatomic, copy, nullable) FlutterEventSink eventSink;
@property (nonatomic, assign) BOOL isRealPlaying;
@property (nonatomic, assign) BOOL isStopping;
@property (nonatomic, assign) BOOL soundEnabled;

- (BOOL)applySoundEnabled:(BOOL)enabled;
- (NSArray<NSString *> *)missingRequiredResources;

@end

@implementation QcHikPlayerView

static NSString *sCurrentAppKey = nil;

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
  self = [super init];
  if (self) {
    _soundEnabled = YES;
    _rootView = [[UIView alloc] initWithFrame:frame];
    _rootView.backgroundColor = [UIColor blackColor];
    _playerContainerView = [[UIView alloc] initWithFrame:_rootView.bounds];
    _playerContainerView.backgroundColor = [UIColor blackColor];
    _playerContainerView.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_rootView addSubview:_playerContainerView];

    NSString *methodName =
        [NSString stringWithFormat:@"qc_hik_player_view_%lld/method", viewId];
    NSString *eventName =
        [NSString stringWithFormat:@"qc_hik_player_view_%lld/event", viewId];
    _methodChannel =
        [FlutterMethodChannel methodChannelWithName:methodName
                                    binaryMessenger:messenger];
    _eventChannel = [FlutterEventChannel eventChannelWithName:eventName
                                              binaryMessenger:messenger];
    __weak typeof(self) weakSelf = self;
    [_methodChannel setMethodCallHandler:^(FlutterMethodCall *call,
                                           FlutterResult result) {
      __strong typeof(weakSelf) strongSelf = weakSelf;
      if (strongSelf == nil) {
        result(FlutterMethodNotImplemented);
        return;
      }
      [strongSelf handleMethodCall:call result:result];
    }];
    [_eventChannel setStreamHandler:self];
    [self bindParams:args];
  }
  return self;
}

- (UIView *)view {
  return self.rootView;
}

- (void)bindParams:(id)args {
  self.playParams = [QcHikBusinessPlayParams paramsWithArguments:args];
  if (self.playParams == nil) {
    [self emitState:@"error"
            message:kQcHikPlayerInvalidParamsText
          errorCode:0];
    return;
  }
  if (![self.playParams isValid]) {
    [self emitState:@"error"
            message:kQcHikPlayerMissingParamsText
          errorCode:0];
    return;
  }
  [self startPlayWithParams:self.playParams];
}

- (void)startPlayWithParams:(QcHikBusinessPlayParams *)params {
  self.playParams = params;
  self.isStopping = NO;
  [self releasePlayer];
  [[self class] prepareSDKWithParams:params];
  [self ensurePlayer];
  [self startRealPlayInternal];
}

+ (void)prepareSDKWithParams:(QcHikBusinessPlayParams *)params {
  @synchronized(self) {
#ifdef DEBUG
    [SMEZSDK setDebugLogEnable:YES];
#endif
    [SMEZSDK enableSDKWithTKToken:YES];
    if (sCurrentAppKey == nil || ![sCurrentAppKey isEqualToString:params.tokenAppKey]) {
      [SMEZSDK initLibWithAppKey:params.tokenAppKey
                         apiUrl:@"https://open.ys7.com"
                        authUrl:@"https://auth.ys7.com"];
      sCurrentAppKey = [params.tokenAppKey copy];
    }
    [SMEZSDK setHttpToken:params.httpUrlToken];
    [SMEZSDK setDeviceTokenForDeviceSerial:params.deviceSerial
                               deviceToken:params.deviceToken];
    [SMEZSDK setDeviceTokenForDeviceSerial:params.deviceSerial
                                  cameraNo:params.channelNo
                         deviceGlobalToken:params.deviceGlobalToken
                          deviceVideoToken:params.deviceVideoToken];
  }
}

- (void)ensurePlayer {
  if (self.player != nil || self.playParams == nil) {
    return;
  }
  self.player = [SMEZSDK createPlayerWithDeviceSerial:self.playParams.deviceSerial
                                             cameraNo:self.playParams.channelNo
                                         useSubStream:NO];
  self.player.delegate = self;
  [self.player setHDPriority:YES];
  [self.player setPlayerView:self.playerContainerView];
  [self.player setStreamToken:self.playParams.streamLiveToken];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  if ([@"startRealPlay" isEqualToString:call.method]) {
    [self startRealPlayInternal];
    result(@(self.isRealPlaying));
    return;
  }
  if ([@"stopRealPlay" isEqualToString:call.method]) {
    [self stopRealPlayInternal];
    result(@YES);
    return;
  }
  if ([@"restartPlay" isEqualToString:call.method]) {
    [self stopRealPlayInternal];
    [self ensurePlayer];
    [self startRealPlayInternal];
    result(@YES);
    return;
  }
  if ([@"setSoundEnabled" isEqualToString:call.method]) {
    NSDictionary *arguments =
        [call.arguments isKindOfClass:[NSDictionary class]]
            ? (NSDictionary *)call.arguments
            : @{};
    NSNumber *enabled = arguments[@"enabled"];
    BOOL success = [self applySoundEnabled:[enabled boolValue]];
    result(@(success));
    return;
  }
  if ([@"disposePlayer" isEqualToString:call.method]) {
    [self releasePlayer];
    result(@YES);
    return;
  }
  result(FlutterMethodNotImplemented);
}

- (void)startRealPlayInternal {
  if (self.player == nil || self.playParams == nil || self.isRealPlaying || self.isStopping) {
    return;
  }
  NSArray<NSString *> *missingResources = [self missingRequiredResources];
  if (missingResources.count > 0) {
    NSString *message = [NSString
        stringWithFormat:@"iOS播放器资源缺失: %@",
                         [missingResources componentsJoinedByString:@", "]];
    [self emitState:@"error" message:message errorCode:0];
    return;
  }
  [self.player setPlayerView:self.playerContainerView];
  [self.player setStreamToken:self.playParams.streamLiveToken];
  [self emitState:@"connecting"
          message:kQcHikPlayerConnectingText
        errorCode:0];
  BOOL started = [self.player startRealPlay];
  self.isRealPlaying = started;
  if (!started) {
    [self emitState:@"error"
            message:@"startRealPlay 调用失败"
          errorCode:0];
  }
}

- (NSArray<NSString *> *)missingRequiredResources {
  NSBundle *mainBundle = [NSBundle mainBundle];
  NSMutableArray<NSString *> *missingResources = [NSMutableArray array];

  if ([mainBundle pathForResource:@"com.hri.hpc.mobile.ios.player" ofType:@"metallib"].length == 0) {
    [missingResources addObject:@"com.hri.hpc.mobile.ios.player.metallib"];
  }
  if ([mainBundle pathForResource:@"dependency_EZPlayerSDK" ofType:@"ini"].length == 0) {
    [missingResources addObject:@"dependency_EZPlayerSDK.ini"];
  }
  if ([mainBundle pathForResource:@"ezrtc_media_session_skin_lookup" ofType:@"png"].length == 0) {
    [missingResources addObject:@"ezrtc_media_session_skin_lookup.png"];
  }
  if ([mainBundle pathForResource:@"ezrtc_media_session_filter01" ofType:@"fsh"].length == 0) {
    [missingResources addObject:@"ezrtc_media_session_filter01.fsh"];
  }

  return missingResources;
}

- (void)stopRealPlayInternal {
  if (self.player == nil || self.isStopping) {
    return;
  }
  self.isStopping = YES;
  @try {
    if (self.isRealPlaying) {
      [self.player stopRealPlay];
    }
  } @catch (NSException *exception) {
  } @finally {
    self.isRealPlaying = NO;
    self.isStopping = NO;
    [self emitState:@"stopped" message:@"" errorCode:0];
  }
}

- (BOOL)applySoundEnabled:(BOOL)enabled {
  self.soundEnabled = enabled;
  if (self.player == nil) {
    return NO;
  }
  BOOL success = enabled ? [self.player openSound] : [self.player closeSound];
  if (success) {
    self.soundEnabled = enabled;
  }
  return success;
}

- (void)releasePlayer {
  if (self.player == nil) {
    return;
  }
  if (self.isRealPlaying && !self.isStopping) {
    [self stopRealPlayInternal];
  }
  self.player.delegate = nil;
  @try {
    [self.player releasePlayer];
  } @catch (NSException *exception) {
  }
  self.player = nil;
  self.isRealPlaying = NO;
  self.isStopping = NO;
}

- (void)emitState:(NSString *)state
          message:(NSString *)message
        errorCode:(NSInteger)errorCode {
  NSDictionary *payload = @{
    @"state": state ?: @"",
    @"message": message ?: @"",
    @"errorCode": @(errorCode),
  };
  self.pendingEvent = payload;
  if (self.eventSink == nil) {
    return;
  }
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self.eventSink != nil) {
      self.eventSink(payload);
    }
  });
}

- (NSString *)playFailMessageWithError:(NSError *)error {
  NSInteger errorCode = error.code;
  if (errorCode == 400035 || errorCode == 400036) {
    return @"取流密码错误或缺失";
  }
  return [NSString stringWithFormat:@"直播失败: %ld", (long)errorCode];
}

#pragma mark - FlutterStreamHandler

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments
                                        eventSink:(FlutterEventSink)events {
  self.eventSink = events;
  if (self.pendingEvent != nil) {
    events(self.pendingEvent);
  }
  return nil;
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
  self.eventSink = nil;
  return nil;
}

#pragma mark - SMBasePlayerDelegate

- (void)player:(SMBasePlayer *)player didPlayFailed:(NSError *)error {
  self.isRealPlaying = NO;
  [self emitState:@"error"
          message:[self playFailMessageWithError:error]
        errorCode:error.code];
}

- (void)player:(SMBasePlayer *)player didReceivedMessage:(NSInteger)messageCode {
  if (messageCode == PLAYER_REALPLAY_START) {
    self.isRealPlaying = YES;
    if (self.soundEnabled) {
      [self.player openSound];
    } else {
      [self.player closeSound];
    }
    [self emitState:@"playing" message:@"直播播放成功" errorCode:0];
  } else if (messageCode == PLAYER_NET_CHANGED) {
    [self emitState:@"connecting" message:kQcHikPlayerConnectingText errorCode:0];
  } else if (messageCode == PLAYER_NO_NETWORK) {
    self.isRealPlaying = NO;
    [self emitState:@"error" message:@"当前网络不可用" errorCode:0];
  }
}

- (void)dealloc {
  [self dispose];
}

- (void)dispose {
  [self.methodChannel setMethodCallHandler:nil];
  [self.eventChannel setStreamHandler:nil];
  self.eventSink = nil;
  [self releasePlayer];
}

@end
