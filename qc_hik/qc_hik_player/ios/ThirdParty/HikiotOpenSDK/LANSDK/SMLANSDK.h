//
//  SMLANSDK.h
//  PM_EZOpen_SDKCmp
//
//  Created by Lee on 2022/12/21.
//

#import <Foundation/Foundation.h>
#import "SMLANConstants.h"
#import "SMBasePlayerSDK.h"

@class SMLANPlayer;
@class SMLANPlayerConfig;

#define MAX_PRESET_NUM 300

extern NSString * const SMLANSDKISAPIErrorPayload;

NS_ASSUME_NONNULL_BEGIN

@interface SMLANSDK : SMBasePlayerSDK

/// 打开PlayM4的日志打印
+ (void)openPlayerM4DebugLog;

/// 获取短序列号
/// @param longSerialNo 长序列号
+ (NSString *)shortSerialNo:(NSString *)longSerialNo;

/**
 *  HCNetSDK 登录
 *
 *  @param ipv4        设备IPV4地址
 *  @param portNum     设备端口号，端口号影响byLoginMode值
 *  @param acoount     设备账号
 *  @param acoount     设备密码
 *  @param completed   userId -1时表示登录失败，其他情况为登录成功
 *                      errorCode， 失败原因
 *                      device,  登录成功后的设备信息
 */
+ (void)hcnetLogin:(NSString *)ipv4
              port:(int)portNum
           account:(NSString *)acoount
               psw:(NSString *)psw
         completed:(void (^)(int userId, int errorCode, NSDictionary *device))completedBlock;

/**
 *  HCNetSDK V40登录
 *
 *  @param ipv4      设备IPV4地址
 *  @param portNum   设备端口号，端口号影响byLoginMode值
 *  @param acoount   设备账号
 *  @param acoount   设备密码
 *  @param completed userId -1时表示登录失败，其他情况为登录成功
 *                    errorCode， 失败原因
 *                    device,  登录成功后的设备信息
 */
+ (void)hcnetV40Login:(NSString *)ipv4
                 port:(int)portNum
              account:(NSString *)acoount
                  psw:(NSString *)psw
            completed:(void (^)(int userId, int errorCode, NSDictionary *device))completedBlock;

/**
 *  HCNetSDK 退出登录
 *
 *  @param  userId    登录成功的userId
 *  @param  completed logout  退出登录成功与否, errorCode  接口返回失败时，错误码
 *
 */
+ (void)hcnetLogout:(int)userId completed:(void (^)(BOOL logout, int errorCode))completedBlock;

/**
 *  开启布防消息
 *
 *  @param   userId     登录成功的userId
 *  @param   completion  alarmHandle 开启成功后的句柄，关闭时需要使用该句柄, error 开启失败的原因
 *
 */
+ (void)hcnetSetupAlarm:(int)userId
             completion:(nonnull void (^)(int alarmHandle, NSError * _Nonnull error))completion;

/**
 *  关闭布防消息

 *  @param alarmHandle 开启成功时返回的句柄
 *  @param completion   result关闭成功与否, error 关闭失败的原因
 *
 */
+ (void)hcnetCloseAlarm:(int)alarmHandle
             completion:(nonnull void (^)(BOOL result, NSError * _Nonnull error))completion;

/**
 *  获取通道状态
 *
 *  @param       userId       登录后的userID
 *  @param       startChannel 起始通道号
 *  @param       channelNum   通道总数
 *
 */
+ (void)hcnetGetChannelStatus:(int)userId
                 startChannel:(int)startChannel
                   channelNum:(int)channelNum
                   completion:(void (^)(NSDictionary *data, int errorCode))completion;

/** 局域网获取NVR/IPC的云台能力集
 *
 *  @param userId     设备登录返回userId
 *  @param cameraNo   设备通道号，IPC直连默认是1
 */
+ (NSDictionary *)hcnetPTZAbilityWitUserId:(NSInteger)userId cameraNo:(NSUInteger)cameraNo;

/** 局域网获取NVR/IPC对讲能力集
 *
 *  @param userId     设备登录返回userId
 */
+ (BOOL)hcnetSTDAbilityWitUserId:(NSInteger)userId;

/** 局域网获取预置点信息
 *
 *  @param userId     设备登录返回userId
 *  @param cameraNo   设备通道号，IPC直连默认是1
 *  @param complete   预置点信息结果回调
 */
+ (void)hcnetPresetInfoWitUserId:(NSInteger)userId
                        cameraNo:(NSUInteger)cameraNo
                        complete:(nullable void (^)(NSDictionary * _Nullable responseObject, NSError * _Nullable error))complete;
/** 局域网添加预置点
 *
 *  @param realPlayHandle     设备登录返回userId
 *  @param index              预置点位置
 *  @param complete           操作结果回调
 */
+ (void)hcnetAddPresetWitRealPlayHandle:(NSInteger)realPlayHandle
                                  index:(NSInteger)index
                             completion:(nonnull void (^)(BOOL result, NSError * _Nonnull))completion ;

/** 局域网删除预置点
 *
 *  @param realPlayHandle     设备登录返回userId
 *  @param index              预置点位置
 *  @param complete           操作结果回调
 */
+ (void)hcnetDeletePresetWitRealPlayHandle:(NSInteger)realPlayHandle
                                     index:(NSInteger)index
                                completion:(nonnull void (^)(BOOL result, NSError * _Nonnull))completion;

/** 局域网使用预置点
 *
 *  @param realPlayHandle     设备登录返回userId
 *  @param index              预置点位置
 *  @param complete           操作结果回调
 */
+ (void)hcnetUsePresetWithRealPlayHandle:(NSInteger)realPlayHandle
                                   index:(NSInteger)index
                              completion:(nonnull void (^)(BOOL result, NSError * _Nonnull))completion;

/** 局域网辅助聚焦
 *
 *  @param userId     设备登录返回userId
 *  @param cameraNo   设备通道号，IPC直连默认是1
 *  @param complete           操作结果回调
 */
+ (void)hcnetFocusOnePushWitUserId:(NSInteger)userId
                          cameraNo:(NSUInteger)cameraNo
                        completion:(nonnull void (^)(BOOL result, NSError * _Nonnull))completion;

/** 设置NVR通道管理员密码
 * 
 *  @param userId           设备登录返回userId
 *  @param cameraNo         设备通道号，IPC直连默认是1
 *  @param pwd              管理员密码
 *  @param successBlock     设置管理员密码成功
 *  @param failBlock        设置管理员密码失败
 */
+ (void)hcnetSetupNVRChannelManagerPwdWithUserId:(NSInteger)userId
                                        cameraNo:(NSInteger)cameraNo
                                             pwd:(NSString *)pwd
                                    successBlock:(nullable void (^)(void))successBlock
                                       failBlock:(nullable void (^)(NSError * _Nullable error))failBlock;


/// 获取通道信息
/// @param userId 设备登录返回userId
/// @param cameraNo 设备通道号，IPC直连默认是1
/// @param successBlock  获取成功
/// @param failBlock 获取失败
+ (void)hcnetGetNVRChanelAblityUserId:(NSInteger)userId
                             cameraNo:(NSInteger)cameraNo
                         successBlock:(nullable void (^)(NSDictionary * _Nullable responseObject))successBlock
                            failBlock:(nullable void (^)(NSError * _Nullable error))failBlock;

/** 局域网查询录像
 *
 *  @param deviceSerial 设备序列号
 *  @param cameraNo     通道号
 *  @param beginTime    查询时间范围开始时间
 *  @param endTime      查询时间范围结束时间
 *  @param videoRecordType      录像类型
 *  @param completion   回调block，正常时返回EZDeviceRecordFile的对象数组，错误时返回错误码
 */
+ (void)hcnetSearchRecordFileWithUserId:(NSInteger)userId
                               cameraNo:(NSInteger)cameraNo
                              beginTime:(NSDate *)beginTime
                                endTime:(NSDate *)endTime
                        videoRecordType:(SMLANVideoRecordType)videoRecordType
                             completion:(nonnull void (^)(NSArray * _Nullable, NSError * nullable))completion;

/** 局域网下载录像
 *
 *  @param fileName     录像文件名
 *  @param savePath     录像存储路径
 *  @param beginTime    设备登录返回的userId
 *  @param progress     下载录像进度
 *  @param completed    下载结果回调block
 */
+ (void)hcnetStartDownloadRecordWithFileName:(NSString *)fileName
                                    savePath:(NSString *)savePath
                                      userId:(NSInteger)userId
                                    progress:(SMLANDownloadProgressBlock)progress
                                   completed:(SMLANDownloadCompletedBlock)completed;

/** HCNET透传使用ISAPI
 * 
 *  @param url              加了Method前缀的ISAPI协议URL
 *  @param userId           设备登录返回userId
 *  @param paramterString   协议参数
 *  @param complete         ISAPI结果回调
 */
+ (void)hcnetRequestISAPIWithURL:(NSString *)url
                          userId:(NSInteger)userId
                  paramterString:(NSString *)paramterString
                        complete:(void (^)(NSDictionary * _Nullable responseObject, NSError * _Nullable error))complete;


/// 获取设备信息
/// @param userId 设备登录返回userId
/// @param portNum  设备端口号
/// @param devicePwd  密码
/// @param deviceIP 设备ip地址
/// @param logindeviceInfo NET_DVR_DEVICEINFO_V30  结构体
+ (NSMutableDictionary *)hcnetGetDeviceDictWithInfoUserId:(int)userId
                                             portNum:(int)portNum
                                           devicePwd:(NSString *)devicePwd
                                            deviceIP:(NSString *)deviceIP
                                           loginInfo:(NSData *)logindeviceInfo;
@end

NS_ASSUME_NONNULL_END
