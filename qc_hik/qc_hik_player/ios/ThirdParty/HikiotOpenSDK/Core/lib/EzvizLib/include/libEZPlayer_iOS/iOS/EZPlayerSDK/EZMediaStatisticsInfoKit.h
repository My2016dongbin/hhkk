//
//  EZMediaStatisticsInfoKit.h
//
//  Created by DeJohn Dong on 16/6/8.
//  Copyright © 2016年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZStreamStatistics.h"

NS_ASSUME_NONNULL_BEGIN

#define EZ_STATISTICS_P2P_PREOPERATION (99)
#define EZ_STATISTICS_DIRECT_PREOPERATION (98)
#define EZ_STATISTICS_DIRECTREVERSE_UPNP (97)


@interface EZMediaStatisticsInfoKit : NSObject

+ (NSDictionary *)getStatisticsInfo:(NSInteger)infoType
                     statisticsInfo:(BaseStatistics *)baseInfos;

+ (NSInteger)infoTypeFromSystemName:(NSString *)systemName;

@end

NS_ASSUME_NONNULL_END
