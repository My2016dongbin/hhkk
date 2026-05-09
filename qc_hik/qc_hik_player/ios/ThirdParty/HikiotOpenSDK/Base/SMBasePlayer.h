//
//  SMSMPlayer.h
//  PM_EZOpen_SDKCmp
//
//  Created by Lee on 2023/3/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SMCloudRecordFile.h"
#import "SMDeviceRecordFile.h"

NS_ASSUME_NONNULL_BEGIN

@class SMBasePlayer;

@protocol SMBasePlayerDelegate <NSObject>

@optional

- (void)player:(SMBasePlayer *)player didPlayFailed:(NSError *)error;

- (void)player:(SMBasePlayer *)player didReceivedMessage:(NSInteger)messageCode;

- (void)player:(SMBasePlayer *)player didReceivedDisplayHeight:(NSInteger)height displayWidth:(NSInteger)width;

- (void)player:(SMBasePlayer *)player didDecodedData:(NSData *)data width:(NSInteger)width height:(NSInteger)height;

@end

@interface SMBasePlayer : NSObject

@property (nonatomic, weak) id<SMBasePlayerDelegate> delegate;

+ (instancetype)createPlayerWithDeviceSerial:(NSString *)deviceSerial cameraNo:(NSInteger)cameraNo;

+ (instancetype)createPlayerWithDeviceSerial:(NSString *)deviceSerial cameraNo:(NSInteger)cameraNo useSubStream:(BOOL)useSubStream;

+ (instancetype)createPlayerWithUserId:(NSInteger)userId cameraNo:(NSInteger)cameraNo streamType:(NSInteger)streamType;

- (instancetype)initWithDeviceSerial:(NSString *)deviceSerial cameraNo:(NSInteger)cameraNo;

- (instancetype)initWithDeviceSerial:(NSString *)deviceSerial cameraNo:(NSInteger)cameraNo useSubStream:(BOOL)useSubStream;

- (instancetype)initWithUserId:(NSInteger)userId cameraNo:(NSInteger)cameraNo streamType:(NSInteger)streamType;

- (BOOL)destoryPlayer;

- (BOOL)releasePlayer;

- (void)setHDPriority:(BOOL)HDPriority;

- (void)setPlayerView:(UIView *)playerView;

- (BOOL)startRealPlay;

- (BOOL)stopRealPlay;

- (void)setPlayVerifyCode:(NSString * _Nullable)verifyCode;

- (BOOL)openSound;

- (BOOL)closeSound;

- (NSInteger)getStreamFlow;

- (BOOL)startVoiceTalk;

- (BOOL)startVoiceTalkNeedVoiceChannel:(BOOL)needVoiceChannel;

- (BOOL)stopVoiceTalk;

- (BOOL)startLocalRecordWithPathExt:(NSString *)path;

- (void)stopLocalRecordExt:(void (^)(BOOL ret))complete;

- (BOOL)startPlaybackFromCloud:(SMCloudRecordFile *)cloudFile;

- (BOOL)startPlaybackFromDevice:(SMDeviceRecordFile *)deviceFile;

- (BOOL)pausePlayback;

- (BOOL)resumePlayback;

- (void)seekPlayback:(NSDate *)offsetTime;

- (NSDate *)getOSDTime;

- (BOOL)stopPlayback;

- (UIImage *)capturePicture:(NSInteger)quality;

- (int)getPlayPort;

- (int)getStreamFetchType;

- (BOOL)setPlaybackRate:(CGFloat)rate mode:(NSUInteger)mode;

/**
 * 全局p2p开启的情况下，该播放器禁用p2p取流。startRealPlay之前调用
 */
- (void)setPlayerDisableP2P;

/**
 * `EZOpenSDK.enableSDKWithTKToken`开启后，需要设置取流小权限token
 *
 * @param streamToken  取流小权限token
 */
- (void)setStreamToken:(NSString *)streamToken;

@end

NS_ASSUME_NONNULL_END
