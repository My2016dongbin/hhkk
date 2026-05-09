//
//  SMDeviceRecordFile.h
//  PM_EZOpen_SDKCmp
//
//  Created by Lee on 2023/3/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMDeviceRecordFile : NSObject

/// 设备录像文件的开始时间
@property (nonatomic, strong) NSDate *startTime;
/// 设备录像文件的结束时间
@property (nonatomic, strong) NSDate *stopTime;
/// 文件类型 -2:UNKNOW -1:ALLEVENT 0:ALARM 1:TIMING 2:IO 3:CMR 4:event 5:all
@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString *channelType;
@property (nonatomic, assign) int seq;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSString *fileName;

- (instancetype)initWithStartTime:(NSDate *)startTime stopTime:(NSDate *)stopTime;

@end

NS_ASSUME_NONNULL_END
