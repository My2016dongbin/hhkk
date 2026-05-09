//
//  SMEZPlayer.h
//  PM_EZOpen_SDKCmp
//
//  Created by Lee on 2023/3/13.
//

#import "SMBasePlayer.h"

NS_ASSUME_NONNULL_BEGIN

@class EZPlayer;

@interface SMEZPlayer : SMBasePlayer

- (instancetype)initWithEZPlayer:(EZPlayer *)ezPlayer;

@end

NS_ASSUME_NONNULL_END
