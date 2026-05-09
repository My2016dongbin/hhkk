//
//  SMLANMessageCallback.h
//  PM_EZOpen_SDKCmp
//
//  Created by hik on 2023/3/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMLANMessageCallback : NSObject
/// 设置报警回调
+ (void)setupAlarmMessageCallback;

/// 是否存在本地消息抓图
/// - Parameter savePath: 抓图路径
+ (BOOL)isExistLanMessagePic:(NSString *)savePath;

/// 获取消息抓图
/// - Parameter savePath: 消息沙盒保存路径
+ (UIImage *)getLanMesaagePic:(NSString *)savePath;

@end

NS_ASSUME_NONNULL_END
