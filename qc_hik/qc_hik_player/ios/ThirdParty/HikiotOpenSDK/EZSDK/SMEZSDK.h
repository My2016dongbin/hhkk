//
//  SMEZSDK.h
//  PM_EZOpen_SDKCmp
//
//  Created by Lee on 2021/10/9.
//

#import <Foundation/Foundation.h>
#import "EZConstants.h"
#import "SMEZConstants.h"
#import "SMBasePlayerSDK.h"
#import "SMEZPlayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMEZSDK : SMBasePlayerSDK

+ (SMEZPlayer *)createPlayerWithDeviceSerial:(NSString *)deviceSerial
                                    cameraNo:(NSInteger)cameraNo;

+ (SMEZPlayer *)createPlayerWithDeviceSerial:(NSString *)deviceSerial
                                    cameraNo:(NSInteger)cameraNo
                                useSubStream:(BOOL)useSubStream;

+ (BOOL)initLibWithAppKey:(NSString *)appKey
                   apiUrl:(NSString *)apiUrl
                  authUrl:(NSString *)authUrl;

+ (BOOL)destoryLib;

+ (void)setAccessToken:(NSString *)accessToken;

+ (void)enableP2P:(BOOL)enable;

+ (BOOL)setDebugLogEnable:(BOOL)enable;

+ (void)setVideoLevel:(NSString *)deviceSerial
             cameraNo:(NSInteger)cameraNo
           videoLevel:(SMEZVideoLevelType)videoLevel
           completion:(void (^)(NSError *error))completion;

/**
 *
 *  查询远程SD卡存储录像信息列表接口
 *
 *  @param deviceSerial 设备序列号
 *  @param cameraNo     通道号
 *  @param beginTime    查询时间范围开始时间
 *  @param endTime      查询时间范围结束时间
 *  @param completion   回调block，正常时返回EZDeviceRecordFile的对象数组，错误时返回错误码
 *
 *  @return operation
 */
+ (void)searchRecordFileFromDevice:(NSString *)deviceSerial
                          cameraNo:(NSInteger)cameraNo
                         beginTime:(NSDate *)beginTime
                           endTime:(NSDate *)endTime
                        completion:(void (^)(NSArray *deviceRecords, NSError *error))completion;

/**
 *  @since 4.18.0
 *  查询远程SD卡存储录像信息列表接口
 *
 *  @param deviceSerial 设备序列号
 *  @param cameraNo     通道号
 *  @param beginTime    查询时间范围开始时间
 *  @param endTime      查询时间范围结束时间
 *  @param videoRecordType      录像类型
 *  @param completion   回调block，正常时返回EZDeviceRecordFile的对象数组，错误时返回错误码
 *
 *  @return operation
 */
+ (void)searchRecordFileFromDevice:(NSString *)deviceSerial
                          cameraNo:(NSInteger)cameraNo
                         beginTime:(NSDate *)beginTime
                           endTime:(NSDate *)endTime
                   videoRecordType:(SMEZVideoRecordType)videoRecordType
                        completion:(void (^)(NSArray *deviceRecords, NSError *error))completion;



/**
 *  查询远程SD卡存储录像信息列表接口（接口支持获取浓缩录像）
 *
 *  @param deviceSerial 设备序列号
 *  @param cameraNo     通道号
 *  @param beginTime    查询时间范围开始时间
 *  @param endTime      查询时间范围结束时间
 *  @param completion   回调block，正常时返回EZDeviceRecordFile的对象数组，错误时返回错误码
 *
 *  @return operation
 */
+ (void)searchRecordFileFromDeviceEx:(NSString *)deviceSerial
                            cameraNo:(NSInteger)cameraNo
                           beginTime:(NSDate *)beginTime
                             endTime:(NSDate *)endTime
                          completion:(void (^)(NSArray *deviceRecords, NSError *error))completion;

/**
 *  @since 4.2.0
 *  查询云存储录像信息列表接口
 *
 *  @param deviceSerial 设备序列号
 *  @param cameraNo     通道号
 *  @param beginTime    查询时间范围开始时间
 *  @param endTime      查询时间范围结束时间
 *  @param completion   回调block，正常时返回EZCloudRecordFile的对象数组，错误时返回错误码
 *
 *  @return operation
 */
+ (void)searchRecordFileFromCloud:(NSString *)deviceSerial
                         cameraNo:(NSInteger)cameraNo
                        beginTime:(NSDate *)beginTime
                          endTime:(NSDate *)endTime
                       completion:(void (^)(NSArray *couldRecords, NSError *error))completion;


#pragma mark - Auth认证相关Api（小权限TKToken模式）

/**
 *  SDK是否使用自己服务器生成的tkToken 代替 accessToken，默认NO；在`initLibWithAppKey`前调用
 *  此开关打开后，必须设置如下token，否则将影响各个功能的使用
 *  `EZOpenSDK - setHttpToken:` 设置非设备类小权限token
 *  `EZOpenSDK - setDeviceTokenForDeviceSerial:deviceToken:` 设置设备类小权限token
 *  `EZOpenSDK - setDeviceTokenForDeviceSerial:cameraNo:deviceGlobalToken:deviceVideoToken:` 设置设备类通道级小权限token
 *  `EZPlayer - setStreamToken:` 预览、对讲、回放设置取流小权限token
 *  `EZDeviceRecordDownloadTask - setStreamToken:`下载设置取流小权限token
 *
 *  此开关打开后，以下接口不能使用
 *  `EZOpenSDK - setAccessToken:`
 *  `EZOpenSDK - openLoginPage:`
 *  `EZOpenSDK - openCloudPage:channelNo:`
 *  `EZOpenSDK - openChangePasswordPage:`
 *
 *  @param enable   是否使用自己服务器生成的tkToken
 */
+ (void)enableSDKWithTKToken:(BOOL)enable;

/**
 * SDK是否使用了小权限token模式
 */
+ (BOOL)isEnableSDKWithTKToken;

/**
 *  给EZOpenSDK设置非设备类小权限token接口
 *
 *  @param httpToken 非设备类小权限token
 */
+ (void)setHttpToken:(NSString *)httpToken;

/**
 *  给EZOpenSDK设置【设备类】小权限token接口
 *
 *  @param deviceSerial 设备序列号
 *  @param deviceToken   设备类类型小权限token（action=* resourceCategory=Global channelNo=*生成的小权限token）
 */
+ (void)setDeviceTokenForDeviceSerial:(NSString *)deviceSerial
                          deviceToken:(NSString *)deviceToken;

/**
 *  给EZOpenSDK设置【设备类通道级别】小权限token接口
 *
 *  @param deviceSerial 设备序列号
 *  @param cameraNo          设备通道号
 *  @param deviceGlobalToken 设备类Global类型小权限token（action=* resourceCategory=Global channelNo=对应通道号 生成的小权限token）
 *  @param deviceVideoToken   设备类Video类型小权限token（action=* resourceCategory=Video channelNo=对应通道号 生成的小权限token）
 */
+ (void)setDeviceTokenForDeviceSerial:(NSString *)deviceSerial
                             cameraNo:(NSInteger)cameraNo
                    deviceGlobalToken:(NSString *)deviceGlobalToken
                     deviceVideoToken:(NSString *)deviceVideoToken;

@end

NS_ASSUME_NONNULL_END
