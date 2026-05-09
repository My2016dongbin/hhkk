//
//  EZRTCFilterParam.h
//  EZMediaSession
//
//  Created by Harper Kan on 2022/7/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EZRTCBeautyParam : NSObject
@property (nonatomic, assign) float whiteness;//0~1.0 默认 0.5
@property (nonatomic, assign) float smoothness;//0~1.0 默认 0.5
@property (nonatomic, assign) float ruddyness;//0~1.0 默认 0.5
@end

typedef enum : NSUInteger {
    EZRTC_Basic_Filter_Type_None,
    EZRTC_Basic_Filter_Type_1,      //白皙
    EZRTC_Basic_Filter_Type_2,      //温暖
    EZRTC_Basic_Filter_Type_3,      //青春
    EZRTC_Basic_Filter_Type_4,      //花海
    EZRTC_Basic_Filter_Type_5,      //清新
    EZRTC_Basic_Filter_Type_6,      //甜美
    EZRTC_Basic_Filter_Type_7,      //洛可可
    EZRTC_Basic_Filter_Type_8,      //盛夏
    EZRTC_Basic_Filter_Type_9,      //少女
    EZRTC_Basic_Filter_Type_10,     //明快
    EZRTC_Basic_Filter_Type_11,     //复古
    EZRTC_Basic_Filter_Type_12,     //褪色
} EZRTC_Basic_Filter_Type;



NS_ASSUME_NONNULL_END
