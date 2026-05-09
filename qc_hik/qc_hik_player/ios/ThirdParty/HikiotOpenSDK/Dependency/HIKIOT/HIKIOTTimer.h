//
//  SMTimer.h
//  PM_SentinelsInstaller_ServiceCmp
//
//  Created by Lee on 2021/8/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HIKIOTTimer : NSObject

+ (instancetype)sharedInstance;



/*
 * schedule GCD Timer 初始化的的时候立即先执行一次
 * @param identifier 唯一标识
 * @param timeInterval timer执行间隔
 * @param queue timer执行队列 默认为main queue
 * @param repeat 是否重复调用
 * @param action timer执行block
 * */
- (void)scheduleTimerWithIdentifier:(NSString *)identifier
                       timeInterval:(NSTimeInterval)timeInterval
                              queue:(dispatch_queue_t)queue
                             repeat:(BOOL)repeat
                             action:(dispatch_block_t)action;

/*
 * schedule GCD Timer 注册的时候立即先执行一次
 * @param identifier 唯一标识
 * @param timeInterval timer执行间隔
 * @param executeImmediately YES表示注册的时候立即执行一次,后面等待timeInterval依次执行
 * @param repeat 是否重复调用
 * @param action timer执行block
 * */
- (void)scheduleTimerWithIdentifier:(NSString *)identifier
                       timeInterval:(NSTimeInterval)timeInterval
                 executeImmediately:(BOOL)executeImmediately
                             repeat:(BOOL)repeat
                             action:(dispatch_block_t)action;
/*
 * 取消timer
 * @param identifier 唯一标识
 * */
- (void)cancelTimerWithIdentifier:(NSString *)identifier;

- (void)cancelTimeWithIdentifierPrefix:(NSString *)prefix;

/**
 timer是否在运行
 
 @param identifier 唯一标识
 */
- (BOOL)isTimerRunningWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
