//
//  EZMediaSession.h
//  H264 Encode and Decode
//
//  Created by kanhaiping on 2018/6/21.
//  Copyright © 2018年 AJB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZRTCMediaSessionDefines.h"
#import "EZMediaCapture.h"
#import "EZRTCVideoEncodeParam.h"
#import "EZRTCSampleHandleManager.h"
#import "EZRTCFilterParam.h"


@class UIImage;
@class UIView;
@class EZRTCMediaSession;
@class EZRTCCameraParam;
@class EZRTCVideoEncodeParam;

@protocol EZRTCMediaSessionDelegate <NSObject>

- (void)mediaSession:(EZRTCMediaSession *)session willEncodeData:(NSData *)mediaData pts:(int64_t)ptsInMS type:(EZMediaCaptureSessionType)type;

- (void)mediaSession:(EZRTCMediaSession *)session didReceivedEncodedData:(NSData *)mediaData pts:(int64_t)ptsInMS type:(EZMediaCaptureSessionType)type;

- (void)mediaSession:(EZRTCMediaSession *)session didReceivedError:(NSInteger)error;

@end


@interface EZRTCMediaSession : NSObject

@property (nonatomic, strong, readonly) EZMediaCapture *capture;
/**
 对讲时，强制采用扬声器播放声音，默认为YES
 */
@property (nonatomic, assign) BOOL forceToSpeaker;

- (instancetype)initWithDelegate:(id<EZRTCMediaSessionDelegate>)delegate;

/// 音频编码类型
@property (nonatomic, assign) EZRTCAudioEncodeType audioEncodeType;

/// 设置采集的视频的编码参数，比如采集最终输出的分辨率、码率等
/// @param encodeParam 编码参数
- (void)setVideoEncodeParam:(EZRTCVideoEncodeParam *)encodeParam;

/// 获取视频编码参数
- (EZRTCVideoEncodeParam *)videoEncodeParam;


/// 小码流的编码参数
- (EZRTCVideoEncodeParam *)actualSmallVideoEncodeParam;

/// 视频的方向信息，用户给底层传递旋转信息。
- (NSInteger)rotationOfVideo;

- (NSInteger)enableVideoCapture:(BOOL)enable;
- (NSInteger)enableAudioCatpure:(BOOL)enable;
- (NSInteger)enableThumbnailCatpure:(BOOL)enable;
- (void)enableScreenShareCapture:(BOOL)enable withResultBlock:(EZScreenShareResultBlock)block;
- (void)enableGlobalScreenShareWithStartedBlock:(dispatch_block_t)didStartedBlock
                                  andEndedBlock:(dispatch_block_t)didFinishBlock;
- (void)disableGlobalScreenShare;
- (void)selectBackCamera:(BOOL)backCameraSelected;
- (NSInteger)startEncoding;
- (unsigned)originalMaxBPSForMedia:(EZMediaCaptureSessionType)type;
- (NSInteger)setMaxBPS:(int)maxBPS;
- (NSInteger)setAverageBPS:(int)maxBPS forMedia:(EZMediaCaptureSessionType)type;
- (void)forceNextKeyFrame;
- (void)forceKeyFrameForMedia:(EZMediaCaptureSessionType)type;
- (NSInteger)stop;
- (void)localScreenShotWithBlock:(void (^)(UIImage *image))block;
- (BOOL) startLocalRecord:(NSString*)path;
- (BOOL) stopLocalRecord;
- (void)autoConfigCurrentRoute;

@end
