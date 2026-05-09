//
//  SMEZManager.h
//  PM_EZOpen_SDKCmp
//
//  Created by Lee on 2021/10/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMEZManager : NSObject

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *appkey;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
