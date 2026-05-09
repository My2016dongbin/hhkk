//
//  HikOldAlertView.h
//  HIK-SecuritySupport
//
//  Created by 黄梦炜 on 2019/4/17.
//  Copyright © 2019 HIKVISION. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSObject (HIKIOTImpChangeTool)
/**
 *  交换两个函数实现指针  参数均为NSString类型
 *
 *  @param systemMethodString 系统方法名string
 *  @param systemClassString  系统实现方法类名string
 *  @param safeMethodString   自定义hook方法名string
 *  @param targetClassString  目标实现类名string
 */
+ (void)SwizzlingMethod:(NSString *)systemMethodString systemClassString:(NSString *)systemClassString toSafeMethodString:(NSString *)safeMethodString targetClassString:(NSString *)targetClassString;


+ (void)methodExchange:(SEL)originalSelector to:(SEL)swizzledSelector;

+ (void)methodExchange:(SEL)originalSelector preFix:(NSString *)px;

+ (BOOL)swizzleOrAddInstanceMethod:(SEL)originalSel
                        withNewSel:(SEL)newSel
                   withNewSelClass:(Class)newSelClass;

@end
