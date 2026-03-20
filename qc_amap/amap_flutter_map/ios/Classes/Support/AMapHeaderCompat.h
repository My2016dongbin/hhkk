#ifndef AMapHeaderCompat_h
#define AMapHeaderCompat_h

#import <Foundation/Foundation.h>

#if __has_include(<AMapNavi/AMapNaviKit.h>)
#import <AMapNavi/AMapNaviKit.h>
#elif __has_include(<AMapNaviKit/AMapNaviKit.h>)
#import <AMapNaviKit/AMapNaviKit.h>
#endif

#if __has_include(<AMap3DMap/MAMapKit.h>)
#import <AMap3DMap/MAMapKit.h>
#elif __has_include(<AMapNavi/MAMapKit.h>)
#import <AMapNavi/MAMapKit.h>
#elif __has_include(<AMapNaviKit/MAMapKit.h>)
#import <AMapNaviKit/MAMapKit.h>
#elif __has_include("MAMapKit.h")
#import "MAMapKit.h"
#elif __has_include(<MAMapKit/MAMapKit.h>)
#import <MAMapKit/MAMapKit.h>
#endif

#endif /* AMapHeaderCompat_h */
