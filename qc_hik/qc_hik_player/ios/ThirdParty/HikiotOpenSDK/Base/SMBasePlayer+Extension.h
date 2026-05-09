//
//  SMBasePlayer+Extension.h
//  SM_LivePlayBack_BusinessCmp
//
//  Created by hik on 2021/11/1.
//

#import "SMBasePlayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMBasePlayer (Extension)

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *captureURL;
@property (nonatomic, assign) BOOL isChannelValid;
@property (nonatomic, assign) NSInteger playerStatus;

@end

NS_ASSUME_NONNULL_END
