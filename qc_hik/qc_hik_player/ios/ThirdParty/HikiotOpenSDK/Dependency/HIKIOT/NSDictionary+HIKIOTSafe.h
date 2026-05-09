//
//  HikOldAlertView.h
//  HIK-SecuritySupport
//
//  Created by 黄梦炜 on 2019/4/17.
//  Copyright © 2019 HIKVISION. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSDictionary (HIKIOTSafe)

- (NSString *)stringForKey:(id)key;
- (NSString *)stringForKey:(id)key or:(NSString *)fall;

- (NSNumber *)numberForKey:(id)key;
- (NSNumber *)numberForKey:(id)key or:(NSNumber *)fall;

- (NSDictionary *)dictionaryForKey:(id)key;
- (NSDictionary *)dictionaryForKey:(id)key or:(NSDictionary *)fall;

- (NSArray *)arrayForKey:(id)key;
- (NSArray *)arrayForKey:(id)key or:(NSArray *)fall;

- (NSData *)dataForKey:(id)key;
- (NSData *)dataForKey:(id)key or:(NSData *)fall;

- (id)objectForKey:(id)key expectedClass:(Class)cls;
- (id)objectForKey:(id)key expectedClass:(Class)cls or:(id)fall;

@end
