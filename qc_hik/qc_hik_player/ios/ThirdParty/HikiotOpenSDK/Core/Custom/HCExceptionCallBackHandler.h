//
//  HCExceptionCallBackHandler.h
//  HC_NetSDK
//
//  Created by Joe on 16/10/18.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HCExceptionCallBackHandlerDelegate <NSObject>

-(void)netSDKExceptionCallBack:(unsigned int)type userId:(int)userId sdkHandle:(int)sdkHandle;

@end

@interface HCExceptionCallBackHandler : NSObject

+(instancetype)sharedHandler;

/**
 *  注册网络SDK错误回调（必须用这个方法，不能直接调用网络SDK设置，否则可能导致错误回调被覆盖）
 *
 *  @param delegate  执行代理方法的delegate, 内部弱引用delegate
 *  @param type     注册的异常类型， 如 EXCEPTION_EXCHANGE、EXCEPTION_PREVIEW、EXCEPTION_RECONNECT、PREVIEW_RECONNECTSUCCESS、EXCEPTION_AUDIOEXCHANGE、EXCEPTION_PLAYBACK 等4500里有用到的其他类型也可以直接设置
 */
-(void)addDelegate:(id<HCExceptionCallBackHandlerDelegate>)delegate forEvent:(unsigned int)type;

//在不需要监听时移除delegate
-(void)removeDelegate:(id<HCExceptionCallBackHandlerDelegate>)delegate forEvent:(unsigned int)type;

@end
