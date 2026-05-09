//
//  SMLANMessageAlarmType.h
//  PM_EZOpen_SDKCmp
//
//  Created by hik on 2023/3/28.
//

#import <Foundation/Foundation.h>
#import "HCNetSDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMLANMessageAlarmType : NSObject
NSString* alarmTypeStringForCommAlarmRule(VCA_EVENT_TYPE dwEventType);
NSString* alarmTypeStringForCommAlarm(DWORD dwAlarmTyp);
@end

NS_ASSUME_NONNULL_END
