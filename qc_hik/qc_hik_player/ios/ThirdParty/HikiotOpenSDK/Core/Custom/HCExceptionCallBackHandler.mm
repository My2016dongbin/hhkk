//
//  HCExceptionCallBackHandler.m
//  HC_NetSDK
//
//  Created by Joe on 16/10/18.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "HCExceptionCallBackHandler.h"
#include "HCNetSDK.h"
#import <libkern/OSAtomic.h>

@implementation HCExceptionCallBackHandler
{
    NSMutableDictionary<NSNumber *, NSHashTable *> *_eventsDic;
    OSSpinLock _lock;
}

+(instancetype)sharedHandler
{
    static HCExceptionCallBackHandler *handler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[[self class] alloc] init];
        handler->_eventsDic = [NSMutableDictionary dictionary];
        handler->_lock = OS_SPINLOCK_INIT;
        
        if (!NET_DVR_SetExceptionCallBack_V30(0, nil, ExceptionCallback, (__bridge void *)handler))
        {
            NSAssert(NO, @"注册网络SDK回调失败");
        }
    });
    return handler;
}

-(void)addDelegate:(id)delegate forEvent:(unsigned int)type
{
    OSSpinLockLock(&_lock);
    NSHashTable *delegates = _eventsDic[@(type)];
    if (!delegates) {
        delegates = [NSHashTable hashTableWithOptions:NSHashTableWeakMemory];
        _eventsDic[@(type)] = delegates;
    }
    
    if (![delegates containsObject:delegate]) {
        [delegates addObject:delegate];
    }
    OSSpinLockUnlock(&_lock);
}

-(void)removeDelegate:(id<HCExceptionCallBackHandlerDelegate>)delegate forEvent:(unsigned int)type
{
    OSSpinLockLock(&_lock);
    NSHashTable *delegates = _eventsDic[@(type)];
    
    if ([delegates containsObject:delegate]) {
        [delegates removeObject:delegate];
    }
    OSSpinLockUnlock(&_lock);
}

static void ExceptionCallback(unsigned int type, int userId, int sdkHandle, void *userData)
{
    HCExceptionCallBackHandler *handler = (__bridge HCExceptionCallBackHandler *)userData;
    
    OSSpinLockLock(&handler->_lock);
    NSHashTable *delegates = handler->_eventsDic[@(type)];
    
    for (id delegate in delegates) {
        if ([delegate respondsToSelector:@selector(netSDKExceptionCallBack:userId:sdkHandle:)]) {
            [delegate netSDKExceptionCallBack:type userId:userId sdkHandle:sdkHandle];
        }
    }
    OSSpinLockUnlock(&handler->_lock);
}

@end
