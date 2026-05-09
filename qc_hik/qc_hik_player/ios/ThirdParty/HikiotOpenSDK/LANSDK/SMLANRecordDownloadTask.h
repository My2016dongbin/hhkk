//
//  SMLANRecordDownloadTask.h
//  PM_EZOpen_SDKCmp
//
//  Created by Lee on 2022/12/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMLANRecordDownloadTask : NSObject

// 每个下载任务的唯一标识
@property (nonatomic, assign) NSUInteger taskId;

// 设备登录useId
@property (nonatomic, assign) NSInteger userId;

// 下载的文件名
@property (nonatomic, strong) NSString *fileName;

// 本地存放路径
@property (nonatomic, strong) NSString *saveFilePath;

@end

NS_ASSUME_NONNULL_END
