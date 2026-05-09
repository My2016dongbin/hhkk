//
//  SMPlayerConfig.h
//  PM_EZOpen_SDKCmp
//
//  Created by Lee on 2023/3/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMPlayerConfig : NSObject

/**回放参数设置*/

///< 设备录像文件的开始时间
@property (nonatomic, strong) NSDate *startTime;
///< 设备录像文件的结束时间
@property (nonatomic, strong) NSDate *stopTime;
///< 文件类型 -2:UNKNOW -1:ALLEVENT 0:ALARM 1:TIMING 2:IO 3:CMR 4:event 5:all
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString *channelType;

/*云台配置参数设置*/
@property (nonatomic, strong) NSString *deviceSerial;                                      ///< 序列号
@property (nonatomic, assign) NSUInteger cameraNo;                                         ///< 录像通道,默认是1
@property (nonatomic, assign) NSInteger command;                                           ///< 云台方向或者缩放命令 EZPTZCommand/SMLANPTZCommand
@property (nonatomic, assign) NSInteger action;                                            ///< 云台控制参数
@property (nonatomic, assign) NSInteger speed;                                             ///< 云台速度参
@property (nonatomic, assign) NSInteger userId;                                            ///< 局域网登录userId

@end

NS_ASSUME_NONNULL_END
