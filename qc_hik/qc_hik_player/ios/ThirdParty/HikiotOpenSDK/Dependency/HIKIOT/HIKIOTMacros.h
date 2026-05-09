//
//  SMMacros.h
//  Pods
//
//  Created by Lee on 2022/4/6.
//

#define HIKIOTNSUINT_BIT (CHAR_BIT * sizeof(NSUInteger))
#define HIKIOTNSUINTROTATE(val, howmuch) ((((NSUInteger)val) << howmuch) | (((NSUInteger)val) >> (NSUINT_BIT - howmuch)))

#ifndef __OPTIMIZE__
    #define NSLog(...) NSLog(__VA_ARGS__)
#else
    #define NSLog(...) {}
#endif

// 防止多次调用
#define HIKIOTRepeatClickTime(_seconds_) \
static BOOL shouldClick; \
if (shouldClick) return; \
shouldClick = YES; \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_seconds_) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
shouldClick = NO; \
}); \

#define HIKIOT_MAINSCREEN_FRAME    [[UIScreen mainScreen] bounds]
#define HIKIOT_MAINSCREEN_WIDTH    HIKIOT_MAINSCREEN_FRAME.size.width
#define HIKIOT_MAINSCREEN_HEIGHT   HIKIOT_MAINSCREEN_FRAME.size.height
#define HIKIOT_ONE_PIXEL           (1/[UIScreen mainScreen].scale)
#define HIKIOT_APP_VERSION         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define HIKIOT_APP_BUILD_VERSION   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#define HIKIOT_FONT_SCALE(value)   getFontSizeScale(value)
// 横向缩放比例
#define HIKIOT_H_SCALE(value)      getHorizontalScale(value)
// 纵向缩放比例
#define HIKIOT_V_SCALE(value)      getVerticalScale(value)

// 默认分割线高度
#define HIKIOT_SEPARATOR_HEIGHT             0.5
// 默认水平偏移
#define HIKIOT_DEFAULT_HORIZONTAL_MARGIN    HIKIOT_H_SCALE(16)

// 小屏幕（小于667的屏幕）
#define HIKIOT_IS_SMALL_SCREEN    (HIKIOT_MAINSCREEN_HEIGHT <= 667.f)

#define HIKIOT_IS_IPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define HIKIOT_IS_IPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX && HIKIOT_IS_IPhone);})

/*状态栏高度*/
#define kHIKIOTStatusBarHeight                  HIKIOTConstant.statusBarHeight
/*导航栏高度*/
#define kHIKIOTNavBarHeight                     HIKIOTConstant.navigationBarHeight
/*状态栏和导航栏总高度*/
#define kHIKIOTNavBarAndStatusBarHeight         HIKIOTConstant.navigationFullHeight
/*TabBar高度*/
#define kHIKIOTTabBarHeight                     HIKIOTConstant.tabBarFullHeight
/*底部安全区域远离高度*/
#define kHIKIOTBottomSafeHeight                 HIKIOTConstant.safeDistanceBottom

//字符串是否为空
#define HIKIOTStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
#define HIKIOTIsValidString(string) (nil != string && [string isKindOfClass:[NSString class]] && ![string isKindOfClass:[NSNull class]] && [string length] > 0 && ![string isEqual:@"(null)"] && ![string isEqual:@"<null>"] && ![string isEqual:@"<Null>"])
#define HIKIOTIsInvalidString(string) (!HIKIOTIsValidString(string))
#define HIKIOTAttrIsEmpty(attr) ([attr isKindOfClass:[NSNull class]] || attr == nil || [attr length] < 1 ? YES : NO )
//数组是否为空
#define HIKIOTArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
#define HIKIOTIsValidArray(arr) (nil != arr && [arr isKindOfClass:[NSArray class]] && [arr count] > 0)
//字典是否为空
#define HIKIOTDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
#define HIKIOTIsValidDict(dict) (nil != dict && [dict isKindOfClass:[NSDictionary class]] && [dict count] > 0)
#define HIKIOTIsInvalidDict(dict) (!HIKIOTIsValidDict(dict))
#define HIKIOTSafeString(str) (HIKIOTIsValidString(str) ? str : @"")

#define KHIKIOTIOSVersion(x)        ([[[UIDevice currentDevice] systemVersion] doubleValue] >= x)
#define HIKIOTImageName(n)           [UIImage imageNamed:n]

#ifndef HIKIOTGCDMain
#define HIKIOTGCDMain(block)\
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }
#endif

#ifndef dispatch_sync_main_safe
#define dispatch_sync_main_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_sync(dispatch_get_main_queue(), block);\
    }
#endif

#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

// debug log
#ifdef DEBUG
#define HIKIOTLog(FORMAT, ...) NSLog(@"LOG >> Function:%s Line:%d Content:%@\n", __FUNCTION__, __LINE__, [NSString stringWithFormat:FORMAT, ##__VA_ARGS__])
#else
#define HIKIOTLog(FORMAT, ...)
#endif

// Color

#define HIKIOT_RGBCOLOR_HEX(x) [UIColor colorWithRed:((x>>16)&0xff)/255.0f green:((x>>8)&0xff)/255.0f blue:(x&0xff)/255.0f alpha:1]
#define HIKIOT_RGBACOLOR_HEX(x, a) [UIColor colorWithRed:((x>>16)&0xff)/255.0f green:((x>>8)&0xff)/255.0f blue:(x&0xff)/255.0f alpha:a]

#define HIKIOT_SEPARATOR_COLOR  HIKIOT_RGBCOLOR_HEX(0xF6F7FB)
#define HIKIOT_BACKGROUND_COLOR HIKIOT_RGBCOLOR_HEX(0xF6F7FB)

// Font

#define HIKIOTFONT(a)  [UIFont systemFontOfSize:a]           // 默认字重就是 UIFontWeightRegular
#define HIKIOTBFONT(a) [UIFont boldSystemFontOfSize:a]
#define HIKIOTSFONT(a) [UIFont systemFontOfSize:a weight:UIFontWeightSemibold]
#define HIKIOTMFONT(a) [UIFont systemFontOfSize:a weight:UIFontWeightMedium]
#define HIKIOTLFONT(a) [UIFont systemFontOfSize:a weight:UIFontWeightLight]

#define HIKIOTNameFONT(name, a)       [UIFont fontWithName:name size:a]
#define HIKIOTAvenirMediumFONT(a)     HIKIOTNameFONT(@"Avenir-Medium", a)
#define HIKIOTAvenirLightFONT(a)      HIKIOTNameFONT(@"Avenir-Light", a)
#define HIKIOTAvenirBookFONT(a)       HIKIOTNameFONT(@"Avenir-Book", a)
#define HIKIOTAvenirHeavyFONT(a)      HIKIOTNameFONT(@"Avenir-Heavy", a)
#define HIKIOTRomanFONT(a)            HIKIOTNameFONT(@"Times New Roman", a)
#define HIKIOTAvenirRomanFONT(a)      HIKIOTNameFONT(@"Avenir-Roman", a)

// 默认苹方字体
#define HIKIOTPingFangRegularFONT(a)        HIKIOTNameFONT(@"PingFangSC-Regular", a)
#define HIKIOTPingFangMediumFONT(a)         HIKIOTNameFONT(@"PingFangSC-Medium", a)
#define HIKIOTPingFangSemiboldFONT(a)       HIKIOTNameFONT(@"PingFangSC-Semibold", a)
