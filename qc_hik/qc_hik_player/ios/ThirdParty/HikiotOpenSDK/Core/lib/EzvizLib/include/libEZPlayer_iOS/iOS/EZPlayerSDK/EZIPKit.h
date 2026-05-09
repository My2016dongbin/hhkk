//
//  EZIPKit.h
//  EZVideoPlayer
//
//  Created by kanhaiping on 2017/8/18.
//  Copyright © 2017年. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, EZIPStackType) {
    EZIPStackType_Unknow = 0,
    EZIPStackType_IPv4 = 1,
    EZIPStackType_IPv6 = 2,
    EZIPStackType_Dual = 3,
};

@interface EZIPKit : NSObject


+ (instancetype)sharedInstance;/**< 单例方法 */

@property (atomic, assign) EZIPStackType stackType; /**< 当前的网络协议类型 */

@property (nonatomic, assign) NSInteger DNSTimeout;/**< 内部域名解析的超时时间，设置<=0使用默认值，默认值3s */

@property (nonatomic, assign) NSInteger DNSDiskCacheOutDatedTime;/**< 缓存到磁盘的域名从超时时间 单位秒 默认 60 * 60 * 24 * 20 必须在setBackupIPs前调用*/ 

/**
 获取当前内部的已经解析的[域名IP对]，上层可以在APP即将被杀掉的时候获取并保存到本地

 @return 返回字典
 */
- (NSDictionary *)getResolvedIPs;


/**
 将之前获取的[域名IP对]设置进通用播放库，必须在初始化EZIPKit后立即调用

 @param backups 之前拉取的缓存的IP
 */
- (void)setBackupIPs:(NSDictionary *)backups;


/**
 更新当前的网络协议栈(在网络变化时）

 @param netDic 网络信息：    key:"EZNetType":0-无网络，1-4G，2-WIFI
                            key:"EZNetName":网络的名称，仅type为2时有效
 */
- (void)updateIPStackIfNeededWithNetInfo:(NSDictionary *)netDic;


/**
 由域名拿到IP，方法可能阻塞一段时间，非主线程调用

 @param host 域名或者是IPv4形式的IP
 @return 返回解析出的IP；如果是IPv6环境，依然返回解析出的IPv4 IP，加上前缀【64:ff9b::】；如果失败，返回原域名
 */
- (NSString *)ipForHost:(NSString *)host;


/**
  由域名拿到IP，方法可能阻塞一段时间，非主线程调用

 @param host 域名或者是IPv4形式的IP
 @param resultOK 输出参数 是否解析成功 YES成功 NOs失败
 @return 成功的话 IPv4下返回解析的IP; IPv6下依然返回解析出的IPv4 IP，加上前缀【64:ff9b::】;如果失败返回host原值
 */
- (NSString *)ipForHost:(NSString *)host isResultOK:(BOOL *)resultOK;

/// 由域名拿到IP，方法可能阻塞一段时间，非主线程调用。成功的话 IPv4下返回解析的IP; IPv6下依然返回解析出的IPv4 IP，加上前缀【64:ff9b::】;如果失败返回host原值
/// @param host host 域名或者是IPv4形式的IP
/// @param timeInSec 超时参数，设置该方法需要同步解析域名时的超时时间，0表示采用默认
/// @param resultOK  输出参数 是否解析成功 YES成功 NOs失败
- (NSString *)ipForHost:(NSString *)host timeOut:(NSInteger)timeInSec isResultOK:(BOOL *)resultOK;



/**
 *  获取默认地址 0.0.0.0
 */
- (NSString *)defaultIpAddress;

/**
 *  获取协议类型  IPv4 返回 AF_INET /IPv6 返回 AF_INET6
 */
- (int)ipAddressFamily;

@end
