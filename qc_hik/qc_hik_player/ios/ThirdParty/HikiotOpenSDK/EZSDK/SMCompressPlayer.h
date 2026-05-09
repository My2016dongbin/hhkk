//
//  SMCompressPlayer.h
//  AFNetworking
//
//  Created by hik on 2024/4/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SMCompressFileManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMCompressPlayer : NSObject

@property (nonatomic, assign, readonly) BOOL hidden;
@property (nonatomic, copy, readonly) NSString *currentPath;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *,NSArray*> *packetInfoDict;
@property (nonatomic, strong, readonly) SMCompressFileManager *fileManager;

/// 帧分析
/// - Parameter path: 视频文件路径
- (void)analyzeBufferAtPath:(NSString *)path;

/// 加密验证码
/// - Parameter verifyCode: 验证码
- (void)setPlayVerifyCode:(NSString * _Nullable)verifyCode;

/// 画布view
/// - Parameter playerView: playerView
- (void)setPlayerView:(UIView *)playerView;

/// 设置画布的隐藏显示
/// - Parameter hidden: hidden
- (void)setPlayerViewHidden:(BOOL)hidden;

/// 读文件流
/// - Parameter path: 视频文件路径
- (void)readFileAtPath:(NSString *)path;

/// 开始回放
/// - Parameter timeInterval: 时间戳
- (BOOL)startPlaybackAtTime:(NSDate *)time atPath:(NSString *)path;

/// 播放器释放
- (void)destoryPlayer;

/// 清空帧数据
- (void)clearBuffers;

/// 清空帧数据
/// - Parameter path: 文件路径
- (void)clearBuffersAtPath:(NSString *)path;

- (void)refreshSecret;

@end

NS_ASSUME_NONNULL_END
