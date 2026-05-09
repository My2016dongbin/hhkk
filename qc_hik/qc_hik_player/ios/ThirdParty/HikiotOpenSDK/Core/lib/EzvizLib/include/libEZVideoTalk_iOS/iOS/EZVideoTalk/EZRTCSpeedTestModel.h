//
//  EZRTCSpeedTestModel.h
//  EZVideoTalk
//
//  Created by Harper Kan on 2022/5/25.
//

#import <Foundation/Foundation.h>
#import "EZBAVParam.h"

NS_ASSUME_NONNULL_BEGIN


typedef void(^EZRTCSpeedTestResultBlock)(EZRTCSpeedTestResult *result);

@interface EZRTCSpeedTestModel : NSObject


///开始网络测试
/// @param params  网络测试参数
- (int)startSpeedTest:(EZRTCSpeedTestParams *)params withResultBlock:(EZRTCSpeedTestResultBlock)block;

///停止网络测试
- (int)stopSpeedTest;

@end

NS_ASSUME_NONNULL_END
