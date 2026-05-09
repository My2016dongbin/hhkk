//
//  NSDate+SM.h
//

#import <Foundation/Foundation.h>

@interface NSDate (HIKIOT)

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
                    hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

+ (NSDate *)dateWithCalendar:(NSCalendar *)calendar
                        year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
                        hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

- (void)getYear:(NSInteger *)year month:(NSInteger *)month day:(NSInteger *)day
           hour:(NSInteger *)hour minute:(NSInteger *)minute second:(NSInteger *)second;

- (void)getYear:(NSInteger *)year month:(NSInteger *)month day:(NSInteger *)day
           hour:(NSInteger *)hour minute:(NSInteger *)minute second:(NSInteger *)second
   withCalendar:(NSCalendar *)calendar;

- (void)getUnsignedIntYear:(unsigned int *)year month:(unsigned int *)month day:(unsigned int *)day
               hour:(unsigned int *)hour minute:(unsigned int *)minute second:(unsigned int *)second
       withCalendar:(NSCalendar *)calendar;

// 获取格式化的字符串，如 @"yyyy-MM-dd HH:mm:ss"
- (NSString *)stringWithFormat:(NSString *)format;
// 获取格式化的字符串，如 @"yyyy-MM-dd HH:mm:ss",遵守苹果设置local规范，避免产生系统12小时制，解析失败的问题（后续统一到stringWithFormat中）
- (NSString *)stringWithStandardsFormat:(NSString *)format;
// 获取格式化的Date，遵守苹果设置local规范，避免产生系统12小时制，解析失败的问题
+ (NSDate *)dateWithStandardsDateString:(NSString *)dateString format:(NSString *)format;
// 将timeInterval格式化为HH:mm:ss
+ (NSString *)stringWithTimeInterval:(NSTimeInterval)timeInterval;


- (BOOL)isTheDayBeforeYesterday;

/// 判断日期是否在当前日期的六天以内
- (BOOL)isTheDayWithinSixDays;

/// 根据日期获取星期几
- (NSString *)weekdayStringFromDate;

@end
