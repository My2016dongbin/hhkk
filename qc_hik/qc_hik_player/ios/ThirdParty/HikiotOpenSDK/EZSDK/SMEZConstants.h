//
//  SMEZConstants.h
//  PM_EZOpen_SDKCmp
//
//  Created by Lee on 2021/10/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///< 通道清晰度，请注意不是所有设备都有这些清晰度的，请根据实际场景使用
typedef NS_ENUM(NSInteger, SMEZVideoLevelType) {
    SMEZVideoLevelLow       = 0,                              ///< 流畅
    SMEZVideoLevelMiddle    = 1,                              ///< 均衡
    SMEZVideoLevelHigh      = 2,                              ///< 高清
    SMEZVideoLevelSuperHigh = 3,                              ///< 超清
    SMEZVideoLevelSuperSuperHigh = 4,                         ///< 极清
    SMEZVideoLevelUnKown    = 99
};

/* 录像类型 */
typedef NS_ENUM(NSUInteger, SMEZVideoRecordType) {
    SMEZVideoRecordTypeAll,     // 所有类SMEZVideoLevelType型
    SMEZVideoRecordTypeCMR,     // 定时录像
    SMEZVideoRecordTypeEvent    // 事件类型
};

NS_ASSUME_NONNULL_END
