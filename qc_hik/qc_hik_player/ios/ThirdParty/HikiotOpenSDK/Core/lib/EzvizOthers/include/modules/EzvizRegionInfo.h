//
//  EzvizRegionInfo.h
//  EZOpenSDK
//
//  Created by linyong on 2018/3/30.
//  Copyright © 2018年 Ezviz. All rights reserved.
//

#import <Foundation/Foundation.h>


///不同区域的accessToken和服务器信息记录类
@interface EzvizRegionInfo : NSObject

@property (nonatomic,copy) NSString *accessToken;
@property (nonatomic,copy) NSString *openauthAddr;
@property (nonatomic,copy) NSString *openapiAddr;
@property (nonatomic,strong) NSDate *expireTime;
@property (nonatomic,assign) NSInteger area;//国内1和海外0

@end
