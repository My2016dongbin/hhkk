//
//  EZNetSDKCompressInfo.h
//  EZVideoPlayer
//
//  Created by kanhaiping on 2017/7/29.
//  Copyright © 2017年. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZNetSDKCompressInfo : NSObject <NSCoding>

@property (nonatomic, assign) unsigned resolution; /**< 分辨率 */

@property (nonatomic, assign) unsigned videoBitrate; /**< 码率 */

@property (nonatomic, assign) unsigned videoFrameRate; /**< 帧率 */

@end
