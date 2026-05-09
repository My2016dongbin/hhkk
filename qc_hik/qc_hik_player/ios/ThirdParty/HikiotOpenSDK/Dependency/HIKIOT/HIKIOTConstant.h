//
//  Constant.h
//  PM_BaseKit_BaseCmp
//
//  Created by hik on 2021/5/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HIKIOTMacros.h"

///---------------------------
/// @name Block
///---------------------------
///
typedef void(^HIKIOTVoidBlock)(void);

typedef void(^HIKIOTResultBlock)(NSDictionary * _Nullable data,  NSError * _Nullable error);

///---------------------------
/// @name Other Constans
///---------------------------
///
@interface HIKIOTConstant : NSObject

/*
appHome下面有Document、Libray、tmp等目录。注意与appBundle区分
 */
@property (nonatomic, readonly, class, nullable) NSString *appHome;
@property (nonatomic, readonly, class, nullable) NSString *appTemp;
@property (nonatomic, readonly, class, nullable) NSString *appDocument;
@property (nonatomic, readonly, class, nullable) NSString *appVersionAndBuild;

// 主应用所在目录
@property (nonatomic, readonly, class, nullable) NSString *appBundle;

// deviceId
//@property (nonatomic, readonly, class, nullable) NSString *deviceId;

// 唯一标识 （UUID + keychain 可用做设备唯一标识）
//@property (nonatomic, readonly, class, nullable) NSString *uuidString;

// KeyWindow
@property (nonatomic, readonly, class, nullable) UIWindow *currentKeyWindow;

/*
 机型/系统适配部分高度
 */
// 顶部状态栏高度（包括安全区）
@property (nonatomic, readonly, class) CGFloat statusBarHeight;

// 导航栏高度,44
@property (nonatomic, readonly, class) CGFloat navigationBarHeight;

// 底部TabBar高度,49
@property (nonatomic, readonly, class) CGFloat tabBarHeight;

// 状态栏+导航栏的高度(包括安全区）
@property (nonatomic, readonly, class) CGFloat navigationFullHeight;

// 底部Tabbar高度（包括安全区）
@property (nonatomic, readonly, class) CGFloat tabBarFullHeight;

// 顶部安全区高度
@property (nonatomic, readonly, class) CGFloat safeDistanceTop;

// 底部安全区高度
@property (nonatomic, readonly, class) CGFloat safeDistanceBottom;

// 空字符串 @""
@property (nonatomic, readonly, class, nullable) NSString *emptyStr;

@end


