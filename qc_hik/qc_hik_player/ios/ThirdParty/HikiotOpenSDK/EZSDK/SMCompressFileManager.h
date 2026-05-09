//
//  SMCompressFileManager.h
//  PM_EZOpen_SDKCmp
//
//  Created by hik on 2024/4/8.
//

#import <Foundation/Foundation.h>
#import "EZDeviceRecordDownloadTask.h"
#import "EZRecordDownloader.h"

#define SMIPCCompressRecordSupport


NS_ASSUME_NONNULL_BEGIN

@interface SMCompressFileManager : NSObject

/**
 *  查询远程SD卡存储录像信息列表接口（接口支持获取浓缩录像）
 *
 *  @param deviceSerial 设备序列号
 *  @param cameraNo     通道号
 *  @param beginTime    查询时间范围开始时间
 *  @param endTime      查询时间范围结束时间
 *  @param videoRecordTypeEx      录像类型扩展
 *  @param completion   回调block，正常时返回EZDeviceRecordFile的对象数组，错误时返回错误码
 *
 */
- (void)searchCompressFile:(NSString *)deviceSerial
                  cameraNo:(NSInteger)cameraNo
                 beginTime:(NSDate *)beginTime
                   endTime:(NSDate *)endTime
                completion:(void (^)(NSArray *deviceRecords, NSError *error))completion;

/**
 * sd卡浓缩录像下载
 * 下载的录像为PS文件，
 *
 * @param taskID 下载任务唯一标识ID
 * @param recordFile 设备录像文件
 * @param deviceSerial 设备序列号
 * @param cameraNo 通道号
 * @param verifyCode 设备验证码
 * @param savePath 下载存储路径
 * @param isComplete 当前文件是否是完整的
 * @param completion 完成回调，成功返回task，失败返回nil
 */
- (void)startCompressRecordDownloadWithTaskID:(NSUInteger)taskID
                         deviceRecordFileInfo:(EZDeviceRecordFile *)recordFile
                                 deviceSerial:(NSString *)deviceSerial
                                     cameraNo:(NSInteger)cameraNo
                                   verifyCode:(NSString *)verifyCode
                                     savePath:(NSString *)savePath
                                   isComplete:(BOOL)isComplete
                                   completion:(void (^)(EZDeviceRecordDownloadTask *task, NSString *path))completion;


/// 浓缩录像路径
/// @param playDate 回放时间
/// @param deviceSerial 设备序列号
/// @param cameraNo 设备通道号
- (NSString *)compressRecordPathWithPlayDate:(NSDate *)playDate
                       compressRecordEndDate:(NSDate *)compressRecordEndDate
                                deviceSerial:(NSString *)deviceSerial
                                    cameraNo:(NSInteger)cameraNo;


/// 获取浓缩录像路径
/// @param pathDate 区间路径时间
/// @param deviceSerial 设备序列号
/// @param cameraNo 设备通道号
/// @param isComplete 是否下载完整
- (NSString *)compressRecordPathWithPathDate:(NSDate *)pathDate
                                deviceSerial:(NSString *)deviceSerial
                                    cameraNo:(NSInteger)cameraNo
                                  isComplete:(BOOL)isComplete;

/// 创建浓缩录像路径
/// @param pathDate 区间路径时间
/// @param deviceSerial 设备序列号
/// @param cameraNo 设备通道号
/// @param isComplete 是否下载完整
- (NSString *)createCompressRecordPathWithPathDate:(NSDate *)pathDate
                                     deviceSerial:(NSString *)deviceSerial
                                         cameraNo:(NSInteger)cameraNo
                                       isComplete:(BOOL)isComplete;


/// 浓缩片段文件名称
/// @param pathDate 区间路径时间
/// @param deviceSerial 设备序列号
/// @param cameraNo 设备通道号
/// @param isComplete 是否下载完整
- (NSString *)compressRecordFileNameWithPathDate:(NSDate *)pathDate
                                    deviceSerial:(NSString *)deviceSerial
                                        cameraNo:(NSInteger)cameraNo
                                      isComplete:(BOOL)isComplete;

/// 浓缩录像下载时间
/// @param playDate 回放时间
- (NSDictionary *)startDownloadCompressRecordTime:(NSDate *)playDate ompressRecordEndDate:(NSDate *)compressRecordEndDate;

/// 下载压缩录像的分区时间
/// @param playDate playDate
-  (NSArray *)downloadCompressRecordPartitionTime:(NSDate *)playDate;

/// 结束下载任务
- (void)stopAllDownloadTask;

@end

NS_ASSUME_NONNULL_END
