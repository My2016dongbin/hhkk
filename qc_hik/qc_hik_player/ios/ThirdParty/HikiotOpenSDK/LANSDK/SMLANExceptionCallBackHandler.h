//
//  SMLANExceptionCallBackHandler.h
//  PM_EZOpen_SDKCmp
//
//  Created by Lee on 2023/3/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern int const SMLANExeceptionExchange;                     ///< 用户交互时异常（注册心跳超时，心跳间隔为2分钟）
extern int const SMLANExeceptionResumeExchange;               ///< 用户交互恢复
extern int const SMLANExeceptionPreviewReconnecting;          ///< 预览时重连
extern int const SMLANExeceptionPreviewReconnectSuccess;      ///< 预览时重连成功
extern int const SMLANExeceptionPlayback;                     ///< 回放异常
extern int const SMLANExeceptionVoiceTalk;                    ///< 语音对讲异常
extern int const SMLANExeceptionRelogining;                   ///< 用户重登陆成功
extern int const SMLANExeceptionReloginSuccess;               ///< 用户重登陆成功
extern int const SMLANExeceptionReloginFailed;                ///< 重登陆失败，停止重登陆

@protocol SMLANExceptionCallBackHandlerDelegate <NSObject>

- (void)netSDKExceptionCallBack:(unsigned int)type userId:(int)userId sdkHandle:(int)sdkHandle;

@end

@interface SMLANExceptionCallBackHandler : NSObject

+ (instancetype)sharedHandler;

- (void)addDelegate:(id<SMLANExceptionCallBackHandlerDelegate>)delegate forEvent:(unsigned int)type;

- (void)removeDelegate:(id<SMLANExceptionCallBackHandlerDelegate>)delegate forEvent:(unsigned int)type;

@end

NS_ASSUME_NONNULL_END
