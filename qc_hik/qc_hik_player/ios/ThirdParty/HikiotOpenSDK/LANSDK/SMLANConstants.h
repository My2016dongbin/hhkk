//
//  SMLANConstants.h
//  PM_EZOpen_SDKCmp
//
//  Created by Lee on 2021/10/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/* SMLANPlayerCode和播放器EZPlayer的状态消息定义枚举值是一致的 */
typedef NS_ENUM(NSInteger, SMLANPlayerCode) {
    SMLANPlayerCodeRealPlayStart = 1,                   ///< 直播开始
    SMLANPlayerCodeVoiceLevelChange = 2,                ///< 直播流清晰度切换中
    SMLANPlayerCodeStreamReconnect = 3,                 ///< 直播流取流正在重连
    SMLANPlayerCodeVoiceTalkStart = 4,                  ///< 对讲开始
    SMLANPlayerCodeVoiceTalkEnd = 5,                    ///< 对讲结束
    SMLANPlayerCodeStreamStart = 10,                    ///< 录像取流开始
    SMLANPlayerCodePlaybackStart = 11,                  ///< 录像回放开始播放
    SMLANPlayerCodePlaybackStop = 12,                   ///< 录像回放结束播放
    SMLANPlayerCodePlaybackFinished = 13,               ///< 录像回放被用户强制中断
    SMLANPlayerCodePlaybackPause = 14,                  ///< 录像回放暂停
    SMLANPlayerCodeNetChanged = 21,                     ///< 播放器检测到wifi变换过
    SMLANPlayerCodeNoNetwork = 22,                      ///< 播放器检测到无网络
    SMLANPlayerCodeCloudframeChanged = 23,              ///< 云存储快放时，由全帧快放切换到抽帧快放的提示回调
    SMLANPlayerCodePlaySpeedLower = 24,                 ///< 云存储快放时的降速通知(存在两次降速：当前倍速大于4倍速时，降到4倍速；当前为4倍速时，降为1倍速)
};

typedef NS_ENUM(NSInteger, SMLANPlayerErrorSecen) {
    SMLANPlayerErrorSecenUnKnown = 0,                   ///< 未知,不处理
    SMLANPlayerErrorSecenExceptionView = 1,             ///< 展示异常弹框
    SMLANPlayerErrorSecenToast = 2,                     ///< 展示toast
};

typedef NS_ENUM(NSInteger, SMLANRecordDownloaderStatus) {
    SMLANRecordDownloaderStatusStart = 1,               ///< 开始下载
    SMLANRecordDownloaderStatusFinish = 2,              ///< 录像下载结束
    SMLANRecordDownloaderStatusError = 3,               ///< 录像下载失败
};

/* 录像类型 */
typedef NS_ENUM(NSUInteger, SMLANVideoRecordType) {
    SMALNVideoRecordTypeAll,                            ///< 所有类SMEZVideoLevelType型
    SMLANVideoRecordTypeCMR,                            ///< 定时录像
    SMLANVideoRecordTypeEvent                           ///< 事件类型
};

/* 设备ptz命令，定义的值与Android定义的不一样，SDK会在内部会做一层转换 */
typedef NS_ENUM(NSUInteger, SMLANPTZCommand) {
    SMLANPTZCommandLeft            = 23,                ///< 向左旋转
    SMLANPTZCommandRight           = 24,                ///< 向右旋转
    SMLANPTZCommandUp              = 21,                ///< 向上旋转
    SMLANPTZCommandDown            = 22,                ///< 向下旋转
    SMLANPTZCommandZoomIn          = 11,                ///< 镜头拉进
    SMLANPTZCommandZoomOut         = 12,                ///< 镜头拉远
};

///< 控制启动/停止, 0开始 1停止
typedef NS_ENUM(NSInteger, SMLANPTZAction) {
    SMLANPTZActionStart = 0,                             ///< PTZ开始
    SMLANPTZActionStop = 1                               ///< PTZ停止
};

///< 局域网倍速枚举
typedef NS_ENUM(NSInteger, SMLANIPCPlaybackRate) {
    SMLANIPCPlaybackRate_1_8       = -3,                 ///< 1/8倍速度播放
    SMLANIPCPlaybackRate_1_4       = -2,                 ///< 1/4倍速度播放
    SMLANIPCPlaybackRate_1_2       = -1,                 ///< 1/2倍速度播放
    SMLANIPCPlaybackRate_1         = 0,                  ///< 1倍速度播放
    SMLANIPCPlaybackRate_2         = 1,                  ///< 2倍速度播放
    SMLANIPCPlaybackRate_4         = 2,                  ///< 4倍速度播放
    SMLANIPCPlaybackRate_8         = 3,                  ///< 8倍速度播放
    SMLANIPCPlaybackRate_Unkown    = 99,                 ///< 未知
};

///< 主子码流
typedef NS_ENUM(NSInteger, SMLANStreamType) {
    SMLANStreamTypeUnknown       = -1,                   ///< 流畅
    SMLANStreamTypeMain          = 0,                    ///< 主码流
    SMLANStreamTypeSub           = 1,                    ///< 子码流
};

typedef void (^SMLANDownloadProgressBlock)(NSUInteger percent);
typedef void (^SMLANDownloadCompletedBlock)(SMLANRecordDownloaderStatus status, NSError * _Nullable error);

// HCNet错误码偏移
extern NSInteger const SMLANPlayerErrorOffset;
extern NSInteger const SMLANHCNetErrorOffset;

@interface SMLANConstants : NSObject

// 用于SMLANPlayer加偏移后，错误码和message的映射
+ (NSString *)getLANHCNetErrorMessage:(NSInteger)errorCode;
+ (NSString *)getLANPlayerErrorMessage:(NSInteger)errorCode;
+ (NSString *)getLANCustomErrorMessage:(NSInteger)errorCode;
// 通道状态映射表
+ (NSString *)getChannelErrorString:(NSInteger)channelStatus;

@end


NS_ASSUME_NONNULL_END
