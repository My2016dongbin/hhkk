//
//  EZPlayerParam.h
//
//  Created by kanhaiping on 16/10/14.
//  Copyright © 2016年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZPlayerDefines.h"
#import "EZNetSDKCompressInfo.h"

@class EZP2PServerInfo;

@interface EZPlayerParam : NSObject <NSCoding>

#pragma mark - RealPlay


/// 设备序列号
@property (nonatomic, copy) NSString *deviceSerial;
/// 设备外网IP
@property (nonatomic, copy) NSString *deviceIp;
/// 设备外网取流端口号
@property (nonatomic) NSInteger devicePort;
/// 设备外网cmd端口
@property (nonatomic) NSInteger deviceCmdPort;
/// 设备局域网IP地址
@property (nonatomic, copy) NSString *localIp;
/// 设备局域网cmd端口
@property (nonatomic) NSInteger localCmdPort;
/// 设备局域网取流端口
@property (nonatomic) NSInteger localPort;
/// cas服务器地址
@property (nonatomic, copy) NSString *casIp;
/// cas服务器端口号
@property (nonatomic) NSInteger casPort;
/// 流媒体服务器地址
@property (nonatomic, copy) NSString *vtmIp;

///新增的vtm备用IP，在上面vtmIp字段传入域名的情况下，此字段可以传入备用IP，以防止域名解不出来时可用；如果上面的vtmIp直接使用的IP，则这个字段内部没有使用
@property (nonatomic, copy) NSString *vtmBackupIp;

/// 流媒体服务器端口
@property (nonatomic) NSInteger vtmPort;

///全链路加密新增参数，流媒体服务的公钥，注意serverPublicKey这不是字符串，是一串二进制数据
///服务端的公钥从平台拉取，并且从平台拿到的信息，需要base64解密后设置进来
///如不支持全链路加密，不传入
@property (nonatomic, copy) NSData *vtduServerPublicKey;

///流媒体服务的公钥版本，如不支持全链路加密，传入0或者不传入
@property (nonatomic, assign) NSInteger vtduServerKeyVersion;

/// STUN服务器IP地址
@property (nonatomic, copy) NSString *stunIp;
/// STUN服务器端口号
@property (nonatomic) NSInteger stunPort;
/// 是否需要 蚁兵代理,0 不需要,1需要,2需要代理并且只使用商用代理
@property (nonatomic) NSInteger isNeedProxy;
/// 代理类型，与isNeedProxy组合使用,默认为0；只有当isNeedProxy=1(启用蚁兵)并且设备本身支持加密但却没有加密时设置为2
@property (nonatomic) NSInteger proxyType;

/// 设备的父设备的设备序列号
@property (nonatomic, copy) NSString *superDevSerial;
/// 设备支持的通道数
@property (nonatomic) NSInteger channelCount;
/// 设备通道号
@property (nonatomic) NSInteger channelNo;

///国标使用的通道号，字符串
@property (nonatomic, copy) NSString *szChnlIndex;

/// 码流类型，1-主码流，2-子码流(HCNetSDK需要）
@property (nonatomic) NSInteger streamType;

/// 码流清晰度  流畅、均衡、等，仅用于蚁兵分配资源
@property (nonatomic) NSInteger     iVideoLevel;

/// 取流限制类型
@property (nonatomic) EZStreamFetchDisableType disableType;

/// 设备加密密钥
@property (nonatomic, copy) NSString *deviceEncryptKey;


/// 用户session
@property (nonatomic, copy) NSString *session;
@property (nonatomic, copy) NSString *userID; /**< 登录的userid，用于对和P2P Server交互的信令做加密用 */
@property (nonatomic, copy) NSString *streamToken;//本次取流的token，会覆盖全局的token。

/// 设备是否支持NAT3、4类打洞
@property (nonatomic) BOOL isSupportNAT34;
@property (nonatomic) NSInteger iCheckInterval;/**< P2P取流二次校验 检测的时间间隔 */
@property (nonatomic) NSInteger    iP2PSPS;    // p2p打洞场景，上层传进来，用于数据统计
//P2P v3新增参数
@property (nonatomic, assign) NSInteger p2pVersion; /**< 设置支持p2p的版本号，由设备的能力集获得。 1-P2P_V1  2-P2P_V2  3-P2P_V3 */
@property (nonatomic, strong) NSArray<EZP2PServerInfo *> *p2pServers; /**< 用来给设备做打洞的p2p服务器地址列表 */
@property (nonatomic, strong) EZP2PKeyInfo *p2pServerKeyInfo;//p2p v3 的服务端key信息，如果没有通过全局接口设置，这里可以单独设置,默认为空

/// 私有流媒体取流业务扩展字段
/* 该字段由平台接口获取，用于私有流媒体转发的视频预览，内容如：biz=%d
 * 1-普通用户取流, 2-群组分享取流, 3-视频广场取流, 4-服务内部取流, 5-开放平台普通用户取流, 6-开放平台付费用户取流, 7-设备付费用户取流, 8-值守用户取流 
 * P2P取流二次校验 也需要传入
 */
@property (nonatomic, copy) NSString *extensionParams;


/// 手机硬件特征码
@property (nonatomic, copy) NSString *hardwareCode;
/// 客户端类型
@property (nonatomic) NSInteger clientType;
/// 客户端运营商类型（0-电信，1-联通，2- 移动，3-铁通，4-华数，5-其他）
@property (nonatomic) NSInteger clientIspType;

/**
 * 设备网络及运营商类型  0-未知网络或无网络 1-wifi网络； 2-4G/3G/2G,未知的运营商类型
 */
@property (nonatomic) NSInteger iInternetType;

@property (nonatomic) NSString *appLid;/**< app层的lid，传递到设备端用来做5410优化和日志联合查询 */

//P2P链路加密密钥(P2Pv3专用）
@property (nonatomic) NSInteger usP2PKeyVer; /**< p2p key version, 如果不支持安全加固版本, 默认必现填写0 */
@property (nonatomic, copy) NSData *szP2PLinkKey; /**< 32个字节的链路加密密钥 */

@property (nonatomic, assign) NSInteger iShared; /**< 是否分享设备 0-否 1-是(别人分享过来的) */
@property (nonatomic, assign) NSInteger iSharedForCAS;///< 和iShared传入一样的值，库内部会将该值传递给CAS库，规避海外线上分享问题。现阶段海外需要传入，国内不需要传入（当前国内服务还没上），默认值为0.

@property (nonatomic, assign) NSInteger iSmallStream; /**<  是否使用小码流 0-否 1-是 2/3G模式下使用小码流，重试取流也使用小码流 */

@property (nonatomic, assign) NSInteger iDevSupportAsyn; /**< 设备是否支持流媒体预览信令异步处理 0-否 1-支持 */ 

//@property (nonatomic) NSInteger timeOutOfStreamHeader;/**< 流头超时，开放出来用于电池相机设置流头超时，电池相机因为唤醒原因，流媒体取流的流头可能来的很晚 单位毫秒 当前仅支持设置到秒级，比如 1000， 5000，最小3000，最大30000*/

@property (nonatomic, assign) NSInteger iPreOpWhileStream;//取流时的预操作处理方式，0：按默认的方案处理 1：每次取流均强制异步预操作（取流前清理预操作结果，取流成功后，发起异步预操作）

#pragma mark - Playback

/// 关联设备的取流数据信息（N1、X1等）
//@property (nonatomic, strong) EZPlayerParam *belongObject;


/**
    后端设备通道对应的前端设备序列号，此项必填。如果是N1/R1等设备回放，该值为通道号关联的IPC设备序列号；如果是IPC回放，对应的是IPC自身的序列号或者为空
    分三种情况
    a.IPC 回放 deviceSerial channelCount channelNo 等信息 均传入 IPC信息 szPBChnlSerial 传入 IPC信息 秘钥传入IPC秘钥
    b.后端 直接回放 deviceSerial channelCount channelNo 等信息 均传入 后端信息 szPBChnlSerial 传入 后端信息 秘钥传入后端秘钥
    c.IPC进入关联后端回放（实际回放后端）deviceSerial channelCount channelNo 等信息 均传入 后端信息 szPBChnlSerial 传入 IPC信息 秘钥传入IPC秘钥
 */
@property (nonatomic, copy) NSString *szPBChnlSerial;

/// 回放开始时间(HCNetSDK需要）
@property (nonatomic, copy) NSString *startTime;
/// 回放结束时间(HCNetSDK需要）
@property (nonatomic, copy) NSString *stopTime;
/// 云存储回放时的云存储服务器IP地址
@property (nonatomic, copy) NSString *cloudServerIp;
/// 云存储回放时的云存储服务器端口
@property (nonatomic) NSInteger cloudServerPort;
/// 云存储文件ID
@property (nonatomic, copy) NSString *fileId;
/// 云存储分享
@property (nonatomic, copy) NSString *ticket;
///// 回放类型：0-按时间回放，1-按fileId回放，2-边下边播回放（视频留言）
//@property (nonatomic) NSInteger playbackType;

@property (nonatomic, assign) NSInteger cloudPlaybackSpeed; /**< 云存储I帧快放 支持 1、4、8、16、32五个速度，传参参见 EZ_PLAY_BACK_RATE */

@property (nonatomic, strong) EZNetSDKCompressInfo *netSDKCompressInfo; /**< HCNetSDK专属 参数 用于回放时调整码流 */

@property (nonatomic, assign) NSInteger iCloudStorageVersion; /**< 存储版本(云存储回放和下载可能用到),1 单文件存储模式(默认值)；2 连续存储模式；3 待定 */

///< 云存储业务，表示录像类型, -1 全部录像；1 连续录像；2 活动录像（默认值）
@property (nonatomic, assign) NSInteger iCloudVideoType;

///< SD卡业务，表示录像类型  0:所有录像 1:定时录像 2:事件录像 3:智能-车 4:智能-人形 5:自动浓缩录像 6:定时浓缩录像 7:手动浓缩录像
@property (nonatomic, assign) NSInteger iSDCardVideoType;

@property (nonatomic, assign) NSInteger iCloudBusType;      /**< 业务类型，1：普通云录像，2：筛选录像，3：云空间，4：回收站，5：精彩回忆，6：一天快放，7：云录制，8：家人日记*/

@property (nonatomic, assign) NSInteger iSupportPlayBackEndFlag;/**< 设备是否支持直连回放结束标记 */

//@property (nonatomic, assign) NSInteger iPlayBackLinkEncrypt;/**< 设备是否支持回放全链路加密, 0:不支持, 1:支持，默认为0，当前版本注释掉，外层不需要再设置该参数 */

@property (nonatomic, assign) NSInteger iLinkEncryptV2;/**< 设备是否支持v2版本全链路加密（包括预览和回放）, 0:不支持, 1:支持，默认为0 */

@property (nonatomic, assign) NSInteger iFrameInterval;///< 浓缩录像的帧间隔(可选项) 单位:秒。浓缩录像下载时使用

@property (nonatomic, assign) NSInteger interlaceFlag;///< 交织流标识，0：普通设备，1：交织流设备，默认为0 （当前仅云存储回放使用）

#pragma mark - Live

@property (nonatomic, copy) NSString *liveUrl;

#pragma mark - Talk

/// 对讲通道号
@property (nonatomic) NSInteger voiceTalkChannelNo;
/// 对讲服务器地址
@property (nonatomic, copy) NSString *ttsIp;

/// 对讲服务器备用IP，库内部在ttsIp尝试失败的情况下，会用该IP重试（如果有）
@property (nonatomic, copy) NSString *ttsBackupIP;

/// 对讲服务器端口
@property (nonatomic) NSInteger ttsPort;
/// 是否使用上麦克风采集声音
@property (nonatomic) BOOL isTopMicCapture;
/// 是否是半双工对讲，默认全双工对讲
@property (nonatomic) BOOL isSemiduplex;
/// 是否使用新版本的tts协议
@property (nonatomic) BOOL isUseNewTTSPotocol;
///设备能力集报备，0表示不支持新QOS对讲，其他表示支持 该参数 与 isUseNewTTSPotocol 冲突，
///设备只有isUseNewTTSPotocol为YES iQosTalkVersion 为 0
///         isUseNewTTSPotocol为NO iQosTalkVersion 为 1 npq模式的 QOS 对讲
///         isUseNewTTSPotocol为NO iQosTalkVersion 为 0
///         isUseNewTTSPotocol为NO iQosTalkVersion 为 -101 ezrtc模式 的 QOS 对讲
///三种情况
@property (nonatomic) NSInteger iQosTalkVersion;
@property (nonatomic,assign,readonly) BOOL isQosTalk;
///对讲服务器地址，平台获取，方法同儿童手表的视频通话
@property (nonatomic, copy) NSString *szQosTaklIP;
///对讲服务器地址，平台获取，方法同儿童手表的视频通话
@property (nonatomic) NSInteger iQosTakPort;

/// base64后的QOS对讲服务的公钥（区别于vtduServerPublicKey）
@property (nonatomic, copy) NSString *szQosServerPublicKey;

///QOS对讲服务的公钥版本，如不支持全链路加密，传入0或者不传入
@property (nonatomic, assign) NSInteger iQosServerKeyVersion;

///对讲呼叫类型，0-APP呼叫，3-设备呼叫
@property (nonatomic) NSInteger iTalkType;
///对讲呼叫id
@property (nonatomic, copy) NSString *szCallingId;


/// 选择设备对讲的mic，0表示默认麦克风（目前仅针对3摄锁，0-门外对讲；1-门内对讲麦克)
@property (nonatomic, assign) NSInteger devMicIndex;


#pragma mark - HCNetSDK局域网预览和回放

///局域网预览回放对讲登录ID
@property (nonatomic) NSInteger localUserID;

@property (nonatomic) NSInteger iNetSDKChannelNumber;/**< NetSDK取流通道号[NETSDK取流必填]，不同于channelNo，channelNo是萤石的通道  */

#pragma mark - 本地文件播放

@property (nonatomic, copy) NSString *filePath;






@end
