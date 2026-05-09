//
//  EZPlayerUtility.h
//
//  Created by kanhaiping on 16/12/9.
//  Copyright © 2016年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZPlayerDefines.h"
#import "EZStreamTypes.h"

@class EZPlayerParam;
@interface EZPlayerUtility : NSObject

/// 单例方法
+ (instancetype)sharedInstance;

+ (NSString *)strFromFetchType:(EZStreamFetchType)type;


/**
 取流禁止类型转换,从player到ez_stream

 @param type 上层的禁止类型
 @return 底层的禁止类型
 */
+ (int)ezStreamClientDisableFromPlayerDisable:(EZStreamFetchDisableType)type;

/**
 取流类型转换 从ez_stream到player

 @param type 底层的取流类型
 @return 上层的取流类型
 */
+ (EZStreamFetchType)playerFetchTypeFromEZStreamClientType:(CLIENT_TYPES)type;


/**
 从上层的player的参数构建底层的ez_stream的参数

 @param param 上层的参数
 @return 底层的参数
 */
+ (INIT_PARAM)ezStreamClientParamForType:(EZPlayerType)streamType withPlayerParam:(EZPlayerParam *)param;


+ (DOWNLOAD_CLOUD_PARAM)ezStreamClintCloudParamFromPlayerParam:(EZPlayerParam *)param;

+ (ez_stream_sdk::CloudStreamReqBasicInfo)CloudBasicPlayInfoFromPlayerParam:(EZPlayerParam *)param;



#pragma mark 音频路由管理

+ (BOOL)isHeadsetOutPutDeviceAvailable;

+ (BOOL)isBluetoothOutPutDeviceAvailable;

+ (void)overrideOutputToSpeaker;

+ (void)overrideOutputToDefault;

//设置默认mode
+ (void)changeInputModeToDefault;

//设置默认mode
+ (void)changeInputModeToVideoChat;

//设置对讲category
+ (void)setIntercomCategory;

//设置播放category
+ (void)setPlayCategory;

//根据当前音频路由状况自动配置
+ (void)autoConfigCurrentRoute;




@end
