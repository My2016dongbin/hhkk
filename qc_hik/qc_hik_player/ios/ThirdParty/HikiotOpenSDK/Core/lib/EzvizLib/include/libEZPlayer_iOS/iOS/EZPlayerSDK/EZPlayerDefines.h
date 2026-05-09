//
//  EZPlayerDefines.h
//
//  Created by kanhaiping on 16/10/21.
//  Copyright © 2016年. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "EZP2PPublicParam.h"
#import "EZP2PKeyInfo.h"

#define EZ_ERROR_IOSMP4_BASE (EZ_ERROR_PLAYER_BASE)
#define EZ_ERROR_VIDEOPLAYER_BASE (1500)
#define EZ_ERROR_TRANSFORM_BASE (1600)

typedef NS_ENUM(NSUInteger, EZ_VIDEOPLAYER_ERROR) {
//    EZ_VIDEOPLAYER_ERROR_NOSTREAMHEADER = 1,
//    EZ_VIDEOPLAYER_ERROR_TRANSFORM_ERROR = 2,
//    EZ_VIDEOPLAYER_ERROR_RECORD_UNPLAYING = 3,
//    EZ_VIDEOPLAYER_ERROR_RECORD_RECORDING = 4,
//    EZ_VIDEOPLAYER_ERROR_PARAM_ERROR = 5,
//    EZ_VIDEOPLAYER_ERROR_FEC_NOT_PLAYING = 6,
//    EZ_VIDEOPLAYER_ERROR_FEC_INVALID_PORT = 7,
//    EZ_VIDEOPLAYER_ERROR_INPUT_DATA_ERROR = 8,
//    EZ_VIDEOPLAYER_ERROR_FAILED_TO_CREATE_HANDLE = 9,
//    EZ_VIDEOPLAYER_ERROR_FAILED_TO_GET_PORT = 10,
//    EZ_VIDEOPLAYER_ERROR_CLOUD_PAUSE_TIMEOUT = 11,
//    EZ_VIDEOPLAYER_ERROR_NONE_PLAYERPORT = 12,
    
    EZ_VIDEOPLAYER_ERROR_BASE = EZ_ERROR_VIDEOPLAYER_BASE,
    EZ_VIDEOPLAYER_ERROR_C_AUDIOENGINE_ERROR ,
    EZ_VIDEOPLAYER_ERROR_NO_INTERCOM_RESOURCE,
    EZ_VIDEOPLAYER_ERROR_SWITCH_DEV_MIC_ERROR,
    
};

typedef NS_ENUM(NSInteger, EZVideoPlayerMessage)
{
    EZVideoPlayerMessageStart = 1,          //开始播放
//    EZVideoPlayerMessageStop = 2,           //停止播放
//    EZVideoPlayerMessagePause = 3,          //暂停播放
    EZVideoPlayerMessageFinish = 4,         //录像播放结束
    EZVideoPlayerMessageReconnect = 5,      //重连
//    EZVideoPlayerMessageStartStream = 6,    //取流开始（在Start之前，之前的实现，仅回放有）
    EZVideoPlayerMessageMoreToken = 7,
    EZVideoPlayerMessageCloudIFrameChange = 8,//云存储快放时，由全帧快放切换到抽帧快放的提示回调
    EZVideoPlayerMessageStreamFetchTypeChange = 9,//用以通知上层取流方式发生变更
    EZVideoPlayerMessageLowerPlaySpeed = 10,//云存储快放时的降速通知
    //    EZ_MEDIA_PLAYER_REALPLAY_START = 1,        //预览开始
    //    EZ_MEDIA_PLAYER_VIDEOLEVEL_CHANGE = 2,     //预览流清晰度切换中
    //    EZ_MEDIA_PLAYER_STREAM_RECONNECT = 3,      //取流重连中
    //    EZ_MEDIA_PLAYER_VOICE_TALK_START = 4,      //对讲开始
    //    EZ_MEDIA_PLAYER_VOICE_TALK_END = 5,        //对讲结束
    //    EZ_MEDIA_PLAYER_STREAM_START = 10,         //取流命令发起
    //    EZ_MEDIA_PLAYER_PLAYBACK_START = 11,       //录像回放开始播放
    //    EZ_MEDIA_PLAYER_PLAYBACK_FINISHED = 12,    //录像回放结束播放
    //    EZ_MEDIA_PLAYER_PLAYBACK_STOP = 13,        //录像用户主动停止
    //    EZ_MEDIA_PLAYER_PLAYBACK_PAUSE = 14,       //录像回放暂停
    //    EZ_MEDIA_PLAYER_NEED_MORE_TOKEN = 20,      //需要更多的取流token
    //    EZ_MEDIA_PLAYER_CHECK_NETTYPE_CHANGED = 21,//播放器检测到wifi变换过
    //    EZ_MEDIA_PLAYER_NO_NETWORK = 22,           //播放器检测到无网络
    
    
    EZVideoPlayerMessageStreamSwitchToDirectInner   = 20 + 2,
    EZVideoPlayerMessageStreamSwitchToDirectOuter   = 20 + 3,
    EZVideoPlayerMessageStreamSwitchToP2P           = 20 + 4,
    EZVideoPlayerMessageStreamSwitchToProxy         = 20 + 13,
};

//player初始化类型
typedef NS_ENUM(NSUInteger, EZPlayerType) {
    EZPlayerTypeMin,
    EZPlayerTypeRealTime,
    EZPlayerTypePlaybackLocal,
    EZPlayerTypePlaybackLocalEx,
    EZPlayerTypePlaybackCloud,
    EZPlayerTypePlaybackCloudEx,//新协议云存储
    EZPlayerTypePlaybackRecord,
    EZPlayerTypeSDCardDownload,
    EZPlayerTypeIntercom, //对讲
    EZPlayerTypeLive,
    EZPlayerTypeLANRealTime,
    EZPlayerTypeLANPlayback,
    EZPlayerTypeLocalFile,
    EZPlayerTypeMax,
};

//实际取流方式
typedef NS_ENUM(NSInteger, EZStreamFetchType) {
    EZStreamFetchTypeNone = -1,
    EZStreamFetchTypePrivate = 0,/**< 私有流媒体 */
    EZStreamFetchTypeP2p,
    EZStreamFetchTypeDirectInner,
    EZStreamFetchTypeDirectOuter,
    EZStreamFetchTypeCloudPlayback,/**< 云回放 */
    EZStreamFetchTypeCloudRecord,/**< 云存储留言 */
    EZStreamFetchTypeDirectReverse,
//    EZStreamFetchTypeDirectReverseUpnp,
    EZStreamFetchTypeNetSDKLAN, /**< 采用HCNetSDK的方式取流 */
    EZStreamFetchTypeLocalFile = 200, /**< 本地文件 */
    EZStreamFetchTypeProxy ,
};


/// 取流类型限制设置参数，可以混合搭配使用来多样化取流，无法禁止私有化取流方式。
typedef NS_OPTIONS(NSInteger, EZStreamFetchDisableType) {
    EZStreamFetchDisableTypeNone          = 0,      ///默认值，不禁止任何方式的取流
    EZStreamFetchDisableTypeDirectInner   = 1,      ///禁止内网直连取流
    EZStreamFetchDisableTypeDirectOuter   = 1 << 1, ///禁止外网直连取流
    EZStreamFetchDisableTypeP2P           = 1 << 2, ///禁止P2P方式取流
    EZStreamFetchDisableTypeDirectReverse = 1 << 3,  ///禁止反向直连取流
    EZStreamFetchDisablePrivateStream     = 1 << 4,  ///禁止流媒体取流
};


/**
 播放过程中上报的卡顿类型

 - EZVideoPlayerDelayTypeSlight: 轻微卡顿
 - EZVideoPlayerDelayTypeMiddle: 中度卡顿
 - EZVideoPlayerDelayTypeSerious: 严重卡顿
 */
typedef NS_ENUM(NSUInteger, EZVideoPlayerDelayType) {
    EZVideoPlayerDelayTypeSlight,
    EZVideoPlayerDelayTypeMiddle,
    EZVideoPlayerDelayTypeSerious,
};


/**
 播放过程中的录制类型

 - EZPlayerTransformTypeNone: 无效类型
 - EZPlayerTransformTypeMOV: 录制的文件为MP4
 - EZPlayerTransformTypePS: 录制的文件为PS
 */
typedef NS_ENUM(NSUInteger, EZPlayerTransformType) {
    EZPlayerTransformTypeNone,
    EZPlayerTransformTypeMOV,
    EZPlayerTransformTypePS,
};


/**
 对讲取流类型

 - EZIntercomStreamFetchTypeNone: 无效类型
 - EZIntercomStreamFetchTypeTTS: tts对讲
 - EZIntercomStreamFetchTypeDirect: 直连对讲
 */
typedef NS_ENUM(NSUInteger, EZIntercomStreamFetchType) {
    EZIntercomStreamFetchTypeNone,
    EZIntercomStreamFetchTypeTTS,
    EZIntercomStreamFetchTypeDirect,
};



/**
 Ping 的业务类型

 - EZPingTestTypePreview: 预览
 - EZPingTestTypePlayback: 回放
 - EZPingTestTypeIntercom: 对讲
 - EZPingTestTypeP2PStun: 打洞
 */
typedef NS_ENUM(NSInteger, EZPingTestType) {
    EZPingTestTypeUnknown = -1,
    EZPingTestTypePreview = 0,
    EZPingTestTypePlayback = 1,
    EZPingTestTypeIntercom = 2,
    EZPingTestTypeP2PStun = 3,
    EZPingTestTypeCloudPB = 4,
};


typedef NS_ENUM(NSInteger, EZRecordDownloaderMessage)
{
    EZRecordDownloaderMessageStart = 1,          //开始下载
    EZRecordDownloaderMessageFinish = 2,         //录像下载结束
    EZRecordDownloaderMessageMoreToken = 3,
};



/**
 * 播放窗口region定义
 */
typedef struct _EZPlayerDisplayRect {
    unsigned long nLeft;
    unsigned long nTop;
    unsigned long nRight;
    unsigned long nBottom;
}EZPlayerDisplayRect;


#define EZPingTestBase (10000000)


 //取流库内部超时
extern NSString *const iVtmConTimeout;/**< connect vtm 超时 */
extern NSString *const iVtduConTimeout;/**< connect vtdu 超时 */
extern NSString *const iVtduRspTimeout;/**< vtdu等待信令回应 */
extern NSString *const iDevConTimeout;/**< 直连connect device */
extern NSString *const iEzDevRetry;/**< 取流库内部直连特定错误码重试次数 */
 //播放层内部超时
extern NSString *const iEzP2PHeaderTimeout;/**< 播放层P2P/直连取流流头超时 */
extern NSString *const iEzVtduHeaderTimeout;/**< 播放层VTDU/Proxy取流流头超时 */
extern NSString *const iEzP2PDataTimeout;/**< 播放层P2P/直连取流流数据超时 */
extern NSString *const iEzVtduDataTimeout;/**< 播放层VTDU/Proxy取流流数据超时 */
extern NSString *const iEzIFrameTimeout;/**< 播放层解码超时 */
extern NSString *const iEzRetry;/**< 播放层总重试次数 */
//其他超时
extern NSString *const iEzPTZ;/**< 云台超时 */

extern NSString *const strEZPlayer;/**< 通用播放库层的新增配置 */
extern NSString *const strCASClient;/**< CAS层的新增配置 */
extern NSString *const strStreamClient;/**< streamclient层的新增配置 */


@interface EZVideoStreamInfo : NSObject
@property (nonatomic, copy) NSString *videoID;/**< 云存储、SD卡录像的文件ID */
@property (nonatomic, copy) NSString *begin;/**< 云存储、SD卡录像的起始时间，形式如20190801T102030Z */
@property (nonatomic, copy) NSString *end;/**< 云存储、SD卡录像的结束时间，形式如20190801T102030Z */
@end



