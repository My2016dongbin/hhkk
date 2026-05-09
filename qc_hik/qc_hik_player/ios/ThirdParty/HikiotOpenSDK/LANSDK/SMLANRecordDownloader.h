//
//  SMLANRecordDownloader.h
//  PM_EZOpen_SDKCmp
//
//  Created by Lee on 2022/12/26.
//

#import <Foundation/Foundation.h>
#import "SMLANRecordDownloadOperation.h"
#import "SMLANRecordDownloadTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMLANRecordDownloader: NSObject

@property (nonatomic, assign) NSInteger maxConcurrentOperationCount;
@property (nonatomic, copy, readonly) NSMutableDictionary<NSNumber *, SMLANRecordDownloadOperation *> *runningOperationCache;

+ (instancetype)sharedInstance;

- (void)startDownloadTask:(SMLANRecordDownloadTask *)task
                 progress:(nullable SMLANDownloadProgressBlock)progress
                completed:(nullable SMLANDownloadCompletedBlock)completed;

@end

NS_ASSUME_NONNULL_END
