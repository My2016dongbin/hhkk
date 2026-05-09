//
//  SMLANPlayer.h
//  SM_LANLivePlayBack_BusinessCmp
//
//  Created by Lee on 2022/12/20.
//

#import "SMBasePlayer.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SMLANPlayerErrorType) {
    SMLANPlayerErrorTypeUnKnown = 0,               ///< 未知,不处理
    SMLANPlayerErrorTypePlayerM4 = 1,              ///< 播放库PlayerM4错误
    SMLANPlayerErrorTypeHCNet = 2,                 ///< HCNet错误
    SMLANPlayerErrorTypeCustom = 3,                ///< 自定义错误
};

extern NSInteger const SMLANDeviceEncryptErrorCode;
extern NSInteger const SMLANDeviceGetStreamTimeoutCode;
extern NSInteger const SMLANDevicePlayBackTimeoutCode;
extern NSInteger const SMLANDeviceOffline;

@interface SMLANPlayer : SMBasePlayer

@property (nonatomic, assign, readonly) int realPlayHandle;

// 局域网播放器初始化
+ (instancetype)createPlayerWithUserId:(NSInteger)userId cameraNo:(NSInteger)cameraNo streamType:(NSInteger)streamType;

// 局域网NVR对讲
- (BOOL)startVoiceTalkWithCameraNo:(NSInteger)cameraNo needVoiceChannel:(BOOL)needVoiceChannel;

// 局域网录像偏移
- (void)seekPlayback:(NSDate *)offsetTime stopTime:(NSDate *)stopTime;

// 局域网切换码流
- (void)setStreamType:(NSInteger)streamType
             cameraNo:(NSInteger)cameraNo
           completion:(void (^)(NSError * _Nullable))completion;

@end

NS_ASSUME_NONNULL_END
