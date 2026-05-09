//
//  SMBasePlaySDK.h
//  PM_EZOpen_SDKCmp
//
//  Created by Lee on 2023/3/13.
//

#import <Foundation/Foundation.h>
#import "SMBasePlayer.h"
#import "EZOpenSDK+EZPrivateHeader.h"

@class SMPlayerConfig;

NS_ASSUME_NONNULL_BEGIN

@interface SMBasePlayerSDK : NSObject

- (instancetype)initWithDeviceSerial:(NSString *)deviceSerial
                            cameraNo:(NSInteger)cameraNo;

- (instancetype)initWithDeviceSerial:(NSString *)deviceSerial
                            cameraNo:(NSInteger)cameraNo
                        useSubStream:(BOOL)useSubStream;

/**抓图，直播或回放*/
+(UIImage *)caputureForPlayer:(SMBasePlayerSDK *)player;

/**电子放大*/
+ (BOOL)setDisplayRegion:(CGRect)originalRect virtualRect:(CGRect)rect playingView:(UIView *)playView ForPlayer:(SMBasePlayer *)player;

/**
 *  切换到广角模式,正常取流不调用该方法,默认是广角
 */
+ (BOOL)switchToWideAngleModeWithplayingView:(UIView *)playView player:(SMBasePlayer *)player;
/**
 *  从广角模式切换到鱼眼模式
 */
+ (BOOL)switchTofishEyeModeWithplayingView:(UIView *)playView player:(SMBasePlayer *)player;
/**
 *  云台控制,上下左右,镜头拉进/拉远等
 */
+ (void)PTZControlWithConfig:(SMPlayerConfig *)config completion:(void (^ __nullable)(NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
