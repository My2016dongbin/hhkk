//
//  SMLANRecordOperation.h
//  PM_EZOpen_SDKCmp
//
//  Created by Lee on 2022/12/26.
//

#import <Foundation/Foundation.h>
#import "SMLANConstants.h"

NS_ASSUME_NONNULL_BEGIN

@class SMLANRecordDownloadOperation;
@class SMLANRecordDownloadTask;

@protocol SMLANRecordDownloadOperationDelegate <NSObject>

- (void)operationStart:(SMLANRecordDownloadOperation *)operation;

@optional

- (void)operationCancel:(SMLANRecordDownloadOperation *)operation;

@end

@interface SMLANRecordDownloadOperation : NSOperation

@property (nonatomic, readonly, strong) SMLANRecordDownloadTask *task;
@property (nonatomic, weak) id <SMLANRecordDownloadOperationDelegate> delegate;
@property (nonatomic, strong) SMLANDownloadCompletedBlock completed;
@property (nonatomic, strong) SMLANDownloadProgressBlock progress;

- (instancetype)initWithTask:(SMLANRecordDownloadTask *)task
                    progress:(SMLANDownloadProgressBlock)progress
                   completed:(SMLANDownloadCompletedBlock)completed;

@end

NS_ASSUME_NONNULL_END
