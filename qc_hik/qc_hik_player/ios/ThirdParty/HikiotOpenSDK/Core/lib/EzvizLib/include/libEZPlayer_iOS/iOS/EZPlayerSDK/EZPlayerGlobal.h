//
//  EZPlayerGlobal.h
//
//  Created by kanhaiping on 16/10/27.
//  Copyright © 2016年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZPlayerDefines.h"

//#define EZVideoPlayerSVNVersion (@"v3.0.0.20181016")


//========================================================
// 所有的接口都是同步接口，所有的回调都在当前线程
//========================================================


@class EZPlayerParam;

@interface EZPlayerGlobal : NSObject

/**
 初始化SDK
 */
+ (void)initSDK;

/// 初始化SDK
/// @param bundleID APP的bundleID 类似 com.google.www
+ (void)initSDKWithBundleID:(NSString *)bundleID;

/**
 *  销毁SDK
 */
+ (void)destroySDK;

/**
 *  获取底层库版本号
 *
 *  @return 版本号字符串
 */
+ (NSDictionary *)getVersion;

/**
 *  设置Debug Log是否打印
 *
 *  @param enable 是否打印debug日志
 */

/// 设置Log
/// @param enable 是否输出日志
/// @param level 日志级别 DEBUG ：1       INFO：2      WARN：3     ERROR：4
/// @param logCallback 日志回调
+ (void)setLogEnable:(BOOL)enable logLevel:(NSInteger)level withLogCallback:(void(^)(NSString *logStr))logCallback;


/// 单例方法
+ (instancetype)sharedInstance;


#pragma mark 调试开关-DEBUG下打开
@property (nonatomic, assign) BOOL openDEBUGInfo;

#pragma mark 取流速度优化开关
- (void)setOptimizedTimeout:(BOOL)optimizedTimeout; /**< 调整流数据超时开关，当前针对国内做了优化,默认是NO，不做优化 */

#pragma mark Ping 模块


/**
 Ping总开关 设置是否允许整个Ping业务,默认不允许

 @param allowPing 是否允许
 */
- (void)setAllowPing:(BOOL)allowPing;


/**
 设置哪些错误码做Ping

 @param errorList   能力集，在能力集中的错误码才会做ping检测  由(EZPingTestType*EZPingTestBase+errorCode)组成
                    e.g. 预览21009错误和对讲30002错误需要做ping检测，参数为[21009，20030002]（NSNumber)
 */
- (void)setPingErrorList:(NSArray *)errorList;

/**
 设置内部的Ping模块的用于对比的主机地址，比如百度的域名、Google的域名，必须设置

 @param host 主机地址
 */
- (void)setPingHost:(NSString *)host;


/**
 设置内部的Ping模块的统计回调,如不设置，Ping操作不会进行

 @param block 回调block
 */
- (void)setPingStatisticBlock:(void (^)(NSDictionary *statisticDict))block;


#pragma mark Token
///设置token
- (void)setTokenList:(NSArray *)tokenList;

/// 用户注销时调用该方法清空剩余token，碰到取流token失效时也可以清除token。
- (void)clearTokenList;

///剩余token数目
- (NSInteger)numOfTokensLeft;

#pragma mark Pre Operation


/**
 开始进行预操作

 @param deviceInfo 设备信息
 */
- (void)startPreOperation:(EZPlayerParam *)deviceInfo;

/**
 清除预操作

 @param deviceSerial 设备序列号
 @return 成功返回EZ_OK 失败返回错误码
 */
- (int)clearPreOperation:(NSString *)deviceSerial;

/**
 *  监听包括P2P状态回调、vtdu缓存等信息
 *
 *  @param block 流状态信息回调block type参见EZ_GLOBAL_EVENT_TYPE
 *  其中的deviceSerial 为设备序列号 可能为空
 *  其中的otherInfo
    为NSString* 在 type 为 EZ_PRE_P2PSERVER_REDIRECT 时 附带 p2pServer 重定向地址组，类似"7.7.7.7:7777,8.8.8.8:8888,9.9.9.9:9999"，上层拿到该回调，需要更新设备信息的p2pServer信息
    为 NSString* 在type为EZ_EVENT_VTDU_CACHE，表示本次流媒体取流使用的vtdu信息，otherInfo的格式为ip:port，app需要缓存vtdu的ip和port
    为 EZ_DEV_INFO* 在type为EZ_EVENT_DEV_INFO_UPDATED，表示设备操作码更新，
    为 EZ_HCNETSDK_EXCEPTION_INFO*  当type为EZ_EVENT_HCNETSDK_EXCEPTION时，表示 HCNetSDK NET_DVR_SetExceptionCallBack_V30 全局异常回调，通用播放库内部已处理 EXCEPTION_PREVIEW EXCEPTION_PLAYBACK 两种异常类型 同时此种情况 deviceSerial为空
 */
- (void)setStreamEventBlock:(void (^)(NSString *deviceSerial,int type, void *otherInfo))block;


/**
 回调预操作数据统计，包括P2P 以及 内外网直连，根据type区分是P2P、内网直连还是外网直连*（只有这三种），p2p的字典和原来一模一样，内外网直连的字典参考新的定义

 @param block 预操作信息回调block
 */
- (void)setStatisticsInfoBlock:(void (^)(NSDictionary *statisticDict, EZStreamFetchType type))block;



/**
 设置预操作结果回调
 block中 result 为 1 表示成功 0 表示失败
 type 为 可能为EZStreamFetchTypePrivate、EZStreamFetchTypeP2p、EZStreamFetchTypeDirectInner、EZStreamFetchTypeDirectOuter、EZStreamFetchTypeDirectReverse
 其中如果是EZStreamFetchTypePrivate 表示内外网直连、P2P、反向直连等均未通，预操作的结果是只能流媒体

 @param block 预操作结果回调block
 */
- (void)setPreconnectResultBlock:(void (^)(int32_t result, NSString *serial, EZStreamFetchType type))block;


/**
 设备P2p状态查询，同步接口

 @param deviceSerial 设备序列号
 @return 状态
 */
- (BOOL)isPreConnectionSucceed:(NSString *)deviceSerial;


/**
 判断设备是否正在通过预操作预览（P2P或者直连）

 @param deviceSerial 设备序列号
 @return 状态
 */
- (BOOL)isPlayingWithPreconnect:(NSString *)deviceSerial;


/**
 判断设备是否正在P2P打洞

 @param deviceSerial 设备序列号
 @return 状态
 */
- (BOOL)isP2PPreconnecting:(NSString *)deviceSerial;


/**
 设置P2P公共参数 是原来setP2PServerInfo的简化版

 @param param 参数
 */
- (void)setP2PPublicParam:(EZP2PPublicParam *)param;


/**
 P2P V3 服务器配置设置接口，必须在打洞前调用

 @param keyInfo p2p key
 */
- (void)setP2PV3ConfigWithKeyInfo:(EZP2PKeyInfo *)keyInfo;



/**
 CAS内部有默认的MTU，本接口用于外部统一设置一个合适的更低的MTU，用于在P2P不来流的情况下内部依据此值调整MTU

 @param smallerMTU 更小的合适的MTU值
 */
- (void)setP2PMTU:(NSInteger)smallerMTU;

/**
 客户端依据灰度配置项设置4G网络下43组合打洞次数上限，修复用户反馈的萤石云App断网问题, 0表示不限制
 
 @param maxcount 最大43穿透尝试设备数
 */
-(void) setMax43PunchDevices:(NSUInteger) maxcount;

/**
 设备本机的外网IP，尽量在预操作前设置，同时在网络变化后，要及时更新该值

 @param ip 手机的外网IP
 */
- (void)setLocalWLANIP:(NSString *)ip;

/**
 更新设备操作码信息

 @param serial 设备序列号
 @param info 设备操作码信息 （请传入const EZ_DEV_INFO *）
 */
- (void)updateDevInfoToCache:(NSString *)serial devInfoIn:(const void*)info;


/**
 获取设备操作码信息

 @param serial 设备序列号
 @param info 输出，操作码信息 （请传入EZ_DEV_INFO * 用于接受设备信息）
 @return 是否成功
 */
- (BOOL)getDevInfoFromCache:(NSString *)serial devInfoOut:(void *)info;


#pragma mark Reverse Connection
/**
 *  开启反向直连服务,当手机连接到wifi时才能调用
 *
 *  @param stunIp       STUN IP地址
 *  @param port         STUN Port
 *  @param timeInterval 检测时间，单位s
 */
- (BOOL)startServerOfReverseDirect:(NSString *)stunIp stunPort:(NSInteger)port checkTimeInterval:(NSInteger)timeInterval;

/**
 *  停止反向直连服务,当手机wifi断开或退出应用时调用
 */
- (void)stopServerOfReverseDirect;

/**
 *  根据设备序列号清理反向直连服务
 *
 *  @param deviceSerial 设备序列号，当设备序列号为空时表示清理全部
 */
- (void)clearServerOfReverseDirect:(NSString *)deviceSerial;

#pragma mark Others

/**
 内部域名解析的超时时间，设置<=0使用默认值，默认值3s (海外和HC可以使用更长的时间）
 
 @param timeout 超时时间
 */
- (void)setDNSTimeout:(NSInteger)timeout;


/**
 设备SDK内部的相关流程中的超时

 @param timeoutDic 键为超时名称NSString 值为具体超时时间NSNumber单位是毫秒 具体可以设置的超时见EZPlayerDefines.h
 
 
 如果某项键没有，则保持原有值
 
 */
- (void)setPlayerSDKTimeout:(NSDictionary *)timeoutDic;

- (void)setStreamConfigByUser:(NSDictionary *)dic;

/**
 debug下check主要依赖底层库的版本
 */
- (void)checkAllSubLibraryVersion;


@end
