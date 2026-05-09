//
//  EZFileTransformer.h
//  EZVideoPlayer
//
//  Created by kanhaiping on 17/1/23.
//  Copyright © 2017年. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "EZStreamTypes.h"

/**
 该类用于将本地PS文件转换为MP4文件,方法请勿并发调用（可以在主线程调用）
 */
@interface EZFileTransformer : NSObject

//ps转mp4
+ (void)fileTransFormerPSPath:(NSString *)psPath
                       toPath:(NSString *)targetPath
                         type:(EZ_TRANSFORM_TYPE)type
                      withKey:(NSString *)key
                    succBlock:(void (^)())succBlock
                 processBlock:(void(^)(int rate))processBlock
                    failBlock:(void(^)(int errCode))failBlock;

+ (int)fileTransFormerPSPath:(NSString *)psPath toPath:(NSString *)targetPath type:(EZ_TRANSFORM_TYPE)type withKey:(NSString *)key processBlock:(void(^)(int rate))processBlock;

@end
