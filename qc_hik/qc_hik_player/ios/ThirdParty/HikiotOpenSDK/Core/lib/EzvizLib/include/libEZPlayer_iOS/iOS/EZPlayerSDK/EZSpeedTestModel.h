//
//  EZSpeedTestModel.h
//  testSpeed
//
//  Created by kanhaiping on 2017/4/11.
//  Copyright © 2017年. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, EZSpeedTestResultCode) {
    EZSpeedTestResultCode_Unknow,
    EZSpeedTestResultCode_Success,
    EZSpeedTestResultCode_ConnectError,/**< 未能连接服务器 或 中途断开 */
    EZSpeedTestResultCode_TimedOut,/**< 发送数据超时 */ 
    EZSpeedTestResultCode_Cancelled,
    EZSpeedTestResultCode_ServerInnerError,
    EZSpeedTestResultCode_Wait,/**< 需要排队等待 */
    EZSpeedTestResultCode_NoResource,/**< 没有带宽资源 */
    
};


@class EZSpeedTestModel;

@protocol EZSpeedTestDelegate <NSObject>



/**
 测速结果回调

 @param model 测速对象
 @param resultCode 测速结果 详见EZSpeedTestResultCode定义
 @param speed 测速结果 单位 Byte/Second 在EZSpeedTestResultCode_Success时有效
 */
- (void)testModel:(EZSpeedTestModel *)model didFinishWithCode:(EZSpeedTestResultCode)resultCode speed:(double)speed;

@optional

/**
 测速数据回调

 @param model 测速对象
 @param numOfBytes 已经发送的字节数
 */
- (void)testModel:(EZSpeedTestModel *)model didSentBytes:(NSUInteger)numOfBytes;


/**
 测速过程中回调
 
 @param model 测速对象
 @param speed 当前测试网速 单位 Byte/Second
 */
- (void)testModel:(EZSpeedTestModel *)model currentSpeed:(double)speed;

@end

@interface EZSpeedTestModel : NSObject

@property (nonatomic, assign) unsigned short maxTestDuration; /**< 最长测速时间 */


/**
 初始化方法

 @param host 测速主机
 @param port 测速端口
 @param delegate 测速结果委托
 @return 实例
 */
- (instancetype)initWithHost:(NSString *)host port:(NSUInteger)port delegate:(id<EZSpeedTestDelegate>)delegate;


/**
 开始测速
 */
- (void)startTest;


/**
 取消测速
 */
- (void)cancelTest;

@end
