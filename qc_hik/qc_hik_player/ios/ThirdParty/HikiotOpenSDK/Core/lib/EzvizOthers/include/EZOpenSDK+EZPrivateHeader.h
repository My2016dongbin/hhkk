//
//  EZOpenSDK+EZPrivateHeader.h
//  EZOpenSDK-Lite
//
//  Created by JuneCheng on 2022/7/26.
//

#import "EZOpenSDK.h"
#import "EZGlobalSDK.h"

@class EZServerInfo;
@class EZTransferMessage;
@class EZDeviceDetailInfo;
@class EzvizRegionInfo;

NS_ASSUME_NONNULL_BEGIN

@interface EZOpenSDK (EZPrivateHeader)

/**
 *  萤石开放平台SDK私有方法--根据关键字获取Http请求中公共参数的值的方法（4530专用接口）
 *
 *  @param key 关键字
 *
 *  @return 公共参数的值
 */
+ (NSString *)getHTTPPublicParam:(NSString *)key;


/**
 *  获取透明通道消息详情接口
 *
 *  @param messageId  消息ID
 *  @param completion 回调block
 *
 *  @return operation
 */
+ (NSURLSessionDataTask *)getTransferMessageInfo:(NSString *)messageId
                                      completion:(void (^)(EZTransferMessage *message, NSError *error))completion;

/**
 *  获取设备详细信息
 *
 *  @param deviceSerial 设备序列号
 *  @param cameraNo     通道号
 *  @param bizType       设备归属业务来源
 *  @param platFormId    平台id
 *  @param completion   回调block
 *
 *  @return operation
 */
+ (NSURLSessionDataTask *)getDeviceDetailInfo:(NSString *)deviceSerial
                                     cameraNo:(NSString *)cameraNo
                                      bizType:(NSString *)bizType
                                   platFormId:(NSString *)platFormId
                                   completion:(void (^)(EZDeviceDetailInfo *detailInfo, NSError *error))completion;

/**
 *  获取设备详细信息 （门口机等专用）
 *
 *  @param deviceSerial 设备序列号
 *  @param completion   回调block
 *
 *  @return operation
 */
+ (NSURLSessionDataTask *)getTransparentDeviceDetailInfo:(NSString *)deviceSerial completion:(void (^)(EZDeviceDetailInfo *, NSError *))completion;



/**
 *  获取取流token数组接口
 *
 *  @param tokenCount token单次数量
 *  @param completion 回调block
 *
 *  @return operation
 */
+ (NSURLSessionDataTask *)getStreamTokenList:(NSInteger)tokenCount
                                  completion:(void (^)(NSArray *tokenList, NSError *error))completion;

/**
 *  获取服务器信息接口
 *
 *  @param completion 回调block
 *
 *  @return operation
 */
+ (NSURLSessionDataTask *)getServerInfo:(void (^)(EZServerInfo *serverInfo, NSError *error))completion;

/**
 *  门口机专用构建EZPlayer接口（for 4500）
 *
 *  @param deviceSerial 设备序列号
 *  @param cameraNo     虚拟通道号
 *  @param streamType   码流类型：1-主码流，2-子码流
 *
 *  @return EZPlayer对象
 */
+ (EZPlayer *)createPlayerWithDeviceSerial:(NSString *)deviceSerial cameraNo:(NSInteger)cameraNo streamType:(NSInteger)streamType;

/**
 *  设置上报扩展字段
 *
 *  @param str   扩展字符串，用于上报
 */
+ (void)setExtendString:(NSString *)str;

/**
 *  设置取流url扩展字段
 *
 *  @param dic   扩展参数，用于专版私有云取流
 */
+ (void)setExtendStreamParam:(NSDictionary *)dic;

/**
 *  获取指定时间内的所有录像文件
 *
 *  @param deviceSerial 设备序列号
 *  @param cameraNo     通道号，传入<=0的值则为默认值
 *  @param beginTime    开始时间，传入nil则为当天00:00:00
 *  @param endTime      结束时间，传入nil则为当天23:59:59
 *  @param rectype      回放源，0-系统自动选择，1-云存储，2-本地录像。非必选，默认为0，传入负值则为默认值
 *  @param completion   回调block records:EzvizRecordFileInfo的数组
 *
 *  @return operation
 */
+ (NSURLSessionDataTask *)searchRecordFile:(NSString *)deviceSerial
                                  cameraNo:(NSInteger)cameraNo
                                 beginTime:(NSDate *)beginTime
                                   endTime:(NSDate *)endTime
                                   recType:(NSInteger)rectype
                                completion:(void (^)(id records, NSError *error))completion;


/**
 *  获取指定告警Id的所有录像文件
 *
 *  @param deviceSerial 设备序列号
 *  @param cameraNo     通道号，传入<=0的值则为默认值
 *  @param alarmId      告警Id
 *  @param completion   回调block record:EzvizRecordFileInfo
 *
 *  @return operation
 */
+ (NSURLSessionDataTask *)searchRecordFile:(NSString *)deviceSerial
                                  cameraNo:(NSInteger)cameraNo
                                   alarmId:(NSString *)alarmId
                                completion:(void (^)(id records, NSError *error))completion;

/**
 获取不同区域appkey对应的accessToken和服务器信息
 
 @param regionId 获取哪几个区域的AccessToken，0或者不传参数：所有区域，包括国内和海外；1：国内；2：海外；
 @param completion 结果回调
 @return operation
 */
+ (NSURLSessionDataTask *)getRegionInfoWithRegion:(NSInteger)regionId
                                       completion:(void(^)(NSArray<EzvizRegionInfo*> *regionInfos,NSError *error))completion;
@end








@interface EZGlobalSDK (EZPrivateHeader)
/**
 *  设置上报扩展字段
 *
 *  @param str   扩展字符串，用于上报
 */
+ (void)setExtendString:(NSString *)str;

/**
 *  获取指定时间内的所有录像文件
 *
 *  @param deviceSerial 设备序列号
 *  @param cameraNo     通道号，传入<=0的值则为默认值
 *  @param beginTime    开始时间，传入nil则为当天00:00:00
 *  @param endTime      结束时间，传入nil则为当天23:59:59
 *  @param rectype      回放源，0-系统自动选择，1-云存储，2-本地录像。非必选，默认为0，传入负值则为默认值
 *  @param completion   回调block records:EzvizRecordFileInfo的数组
 *
 *  @return operation
 */
+ (NSURLSessionDataTask *)searchRecordFile:(NSString *)deviceSerial
                                  cameraNo:(NSInteger)cameraNo
                                 beginTime:(NSDate *)beginTime
                                   endTime:(NSDate *)endTime
                                   recType:(NSInteger)rectype
                                completion:(void (^)(id records, NSError *error))completion;

/**
 *  获取指定告警Id的所有录像文件
 *
 *  @param deviceSerial 设备序列号
 *  @param cameraNo     通道号，传入<=0的值则为默认值
 *  @param alarmId      告警Id
 *  @param completion   回调block record:EzvizRecordFileInfo
 *
 *  @return operation
 */
+ (NSURLSessionDataTask *)searchRecordFile:(NSString *)deviceSerial
                                  cameraNo:(NSInteger)cameraNo
                                   alarmId:(NSString *)alarmId
                                completion:(void (^)(id records, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
