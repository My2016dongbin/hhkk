//
//  EZPingTestModel.h
//  testSpeed
//
//  Created by kanhaiping on 2017/4/12.
//  Copyright © 2017年. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, EZPingResultCode) {
    EZPingResultCode_Unknow,
    EZPingResultCode_Success,
    EZPingResultCode_ConnectError,
    EZPingResultCode_Cancelled,
};

@class EZPingTestModel;

@protocol EZPingTestDelegate <NSObject>

- (void)pingModel:(EZPingTestModel *)model didEndPingTest:(EZPingResultCode)resultCode
            delay:(NSUInteger)delay max:(NSUInteger)max min:(NSUInteger)min lost:(double)lost;
@optional
- (void)pingModel:(EZPingTestModel *)model didReceivedPackage:(NSUInteger)sequenceNumber;
@end

@interface EZPingTestModel : NSObject

@property (nonatomic, strong, readonly) NSString *host;

- (instancetype)initWithHost:(NSString *)host numOfPings:(NSInteger)numOfPings delegate:(id<EZPingTestDelegate>)delegate;
- (instancetype)initWithHost:(NSString *)host numOfPings:(NSInteger)numOfPings delegate:(id<EZPingTestDelegate>)delegate queue:(dispatch_queue_t)queue;

/**
 开始测速
 */
- (void)startTest;


/**
 取消测速
 */
- (void)cancelTest;

@end
