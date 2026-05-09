/********************************************************************* 
 * Copyright (C), 2014-2015, Digital Technology Co., Ltd.
 * 文件名   : EZStreamTypes.h
 * 功能描述 : EZStreamTypes声明文件
 * 作者     ：tanyongfeng
 * 创建日期 ：2016-5-6
 * 修改历史 ：初始版本(2016-5-6)
 *
 * 
**********************************************************************/ 
#ifndef _EZSTREAM_TYPES_H_
#define _EZSTREAM_TYPES_H_

//#include "HPR_Config.h"
//#include "HPR_Types.h"
#include "EZStreamError.h"
#include "EZStreamStatistics.h"
//#include "EZMediaType.h"
#include <vector>

#define EZ_DEV_LEN 128
#define EZ_CHNL_LEN 128

typedef enum _tagEZ_STREAM_INHIBIT
{
	/*
	用于禁止某种或多种取流方式，若都取消则只能用流媒体转发方式取流
	*/
	EZ_STREAM_DISABLE_NONE			= 0,//不禁止任务取流方式
	EZ_STREAM_DISABLE_DIRECT_INNER	= 1,//禁止尝试内网直连取流
	EZ_STREAM_DISABLE_DIRECT_OUTER	= 1 << 1,//禁止尝试公网直连取流
	EZ_STREAM_DISABLE_P2P			= 1 << 2,//禁止尝试P2P取流
	EZ_STREAM_DISABLE_DIRECT_REVERSE  = 1 << 3,//禁止尝试反向直连取流
    EZ_STREAM_DISABLE_PRIVATE_STREAM  = 1 << 4,//禁止蚁兵和流媒体取流
}EZ_STREAM_INHIBIT;

typedef enum _tagMSG_TYPE {
	EZ_MSG_ERROR_RESULT						= 1,//param 对应：EZ_CLIENT_ERROR_E
	EZ_MSG_P2P_STAUTS						= 2,//param 对应：EZ_P2P_STATUS_TYPE
	EZ_MSG_NEED_TOKKENS						= 3,//需要设置tokens
	//EZ_MSG_CLIENT_TYPE						= 4,//当前客户端的取流方式,对应CLIENT_TYPES(保留)
	EZ_MSG_SWITCH_CLIENT_TYPE				= 5,//切换取流方式,对应CLIENT_TYPES
	EZ_MSG_PRECONNECT_CLEARED_WHEN_PLAYING  = 6,//取流过程中,预操作信息被清除,对应CLIENT_TYPES
    EZ_MSG_HCNET_EXCEPTION = 8,                 //正在播放时HCNet回调异常
	EZ_MSG_UDTCONNECT                       = 9,// udtconnect消息
}MSG_TYPE;

/*
 * 消息类型及对对应的param
 */
typedef enum _tagSTATISTICS_TYPE {
	EZ_STATISTICS_DIRECT_PREVIEW			= 0,//直连预览统计数据上报，param 对应：DirectPreviewStatistics的地址
	EZ_STATISTICS_PRIVATE_STREAM_PREVIEW	= 1,//流媒体转发预览统计数据上报，param 对应：PrivateStreamPreviewStatistics的地址
	EZ_STATISTICS_P2P_PREVIEW				= 2,//P2P预览统计数据上报，param 对应：P2PPreviewStatistics的地址
	EZ_STATISTICS_DIRECT_PLAYBACK			= 3,//直连回放统计数据上报,param 对应：DirectPlaybackStatistics的地址
	EZ_STATISTICS_CLOUD_PLAYBACK			= 4,//云存储回放统计数据上报,param 对应：CloudPlaybackStatistics的地址
	EZ_STATISTICS_PRIVATE_STREAM_PLAYBACK	= 5,//私有流媒体转回放统计数据上报,param 对应：PrivateStreamPreviewStatistics的地址
	EZ_STATISTICS_TTS_VOICE					= 6,//TTS对讲,param 对应：TTSVoiceTalkStatistics
	EZ_STATISTICS_DIRECT_VOICE				= 7,//直连对讲,param 对应：DirectVoiceTalkStatistics
    EZ_STATISTICS_NETSDK_PREVIEW			= 8,//NETSDK预览统计数据上报,param 对应：NetSDKPreviewStatistics
    EZ_STATISTICS_NETSDK_PLAYBACK			= 9,//NETSDK回放统计数据上报,param 对应：NetSDKPlaybackStatistics
    EZ_STATISTICS_P2P_PLAYBACK              = 10,//P2P回放统计数据上报，param 对应：P2PPlaybackStatistics的地址
    EZ_STATISTICS_P2P_VOICE                 = 11,//P2P对讲统计数据上报，param 对应：P2PVoiceTalkStatistics的地址
	EZ_STATISTICS_QOS_VOICE                 = 12,//Qos对讲统计数据上报，param 对应：QosTalkStatistics的地址

	EZ_STATISTICS_QOS_TAKL_REAL_NET_STATUS  = 101,//Qos对讲实时网络状态,仅用于调试
}STATISTICS_TYPE;

/*
 * 以下为Client类型
 */
typedef enum _tagCLIENT_TYPES {
	CLIENT_TYPE_NONE = -1,//无有效客户端
	CLIENT_TYPE_PRIVATE_STREAM = 0,//通过流媒体服务器转发
	CLIENT_TYPE_P2P = 1,//p2p方式
	CLIENT_TYPE_DIRECT_INNER = 2,//内网直连方式
	CLIENT_TYPE_DIRECT_OUTER = 3,//外网直连方式
	CLIENT_TYPE_CLOUD_PLAYBACK = 4,//云存储回放
	CLIENT_TYPE_CLOUD_RECORDING = 5,//云存储留言
	CLIENT_TYPE_DIRECT_REVERSE = 6,//反向直连
    CLIENT_TYPE_HCNETSDK = 7,//NETSDK取流
    CLIENT_TYPE_ANT_PROXY = 8, //蚁兵
//    CLIENT_TYPE_DIRECT_REVERSE_UPNP = 8,//反向直连UPNP统计
    CLIENT_TYPE_NETPROTOCOL = 9,//网络协议取流
    CLIENT_TYPE_EZLINK = 10, //EZLINK取流
    CLIENT_TYPE_PROXY = 100,//保留
    CLIENT_TYPE_PRECONNECT = 101,//保留,预连接

}CLIENT_TYPES;

/*
* INIT_PARAM中的用到的iStreamSource，当iStreamSource为EZ_STREAM_SOURCE_LIVE_MINE，EZ_STREAM_SOURCE_PLAYBACK_LOCAL，EZ_STREAM_SOURCE_PLAYBACK_CLOUD，EZ_STREAM_SOURCE_LOCAL_DOWNLOAD
*之一时调用ezstream_createClient函数来创建取流客户端；当EZ_STREAM_SOURCE_LIVE_SQUERE调用ezstream_createClientWithUrl来创建取流客户端
*/
typedef enum _tagEZ_STREAM_SOURCE {
	EZ_STREAM_SOURCE_LIVE_MINE			= 0,//自己账号下面的设备直播
	EZ_STREAM_SOURCE_LIVE_SQUERE		= 1,//广场上面的设备直播,此类型的视频以URL形式创建Client,见ezstream_createClientWithUrl函数
	EZ_STREAM_SOURCE_PLAYBACK_LOCAL		= 2,//存在本地的视频回放
	EZ_STREAM_SOURCE_PLAYBACK_CLOUD		= 3,//自己账号存在云存储服务器的视频回放
	EZ_STREAM_SOURCE_RECORDING_CLOUD	= 4,//留言
    EZ_STREAM_SOURCE_LOCAL_DOWNLOAD     = 5,//下载SD卡中的录像
	EZ_STREAM_SOURCE_TALKBACK           = 6,//自己账号下面的设备对讲
	EZ_STREAM_SOURCE_LOCAL_FILE         = 7,//本地文件播放
    EZ_STREAM_SOURCE_PLAYBACK_LOCAL_EX  = 8,//SD卡筛选回放
    EZ_STREAM_SOURCE_PLAYBACK_CLOUD_EX  = 9,//云存储筛选回放（新协议）

}EZ_STREAM_SOURCE;

typedef enum _tagSTREAM_DATA_TYPE {

	EZ_STREAM_TYPE_IDLE       = 0,     // 无效类型
	EZ_STREAM_TYPE_HEADER     = 1,     // 流头
	EZ_STREAM_TYPE_DATA       = 2,     // 数据
	EZ_STREAM_TYPE_AUDIO_DATA = 3,		// 音频数据数据
	EZ_STREAM_TYPE_STREAMKEY  = 4,		// stream key
	EZ_STREAM_TYPE_AESMD5     = 5,      //蚁兵加密的MD5码,如果对没有加密的设备启用蚁兵加密,该值为操作码的Md5码
    EZ_STREAM_TYPE_UDP_HEADER = 6,      //UDP流头
    EZ_STREAM_TYPE_CLOUD_IFRAME = 7,    //云存储快放时，由全帧快放切换到抽帧快放的提示回调
    EZ_STREAM_TYPE_LOWER_PLAY_SPEED = 8,// 服务器返回的降低快放倍速消息
    EZ_STREAM_TYPE_SEEK_UUID  = 9,      //SD卡seek后流来之前会给UUID
    EZ_STREAM_TYPE_FIRST_DATA = 50,     //第一次流数据到达，只用于android,用于把第一次流到信息通知到java
    EZ_STREAM_TYPE_ERROR      = 60,    //异常
	EZ_STREAM_TYPE_END        = 100,   // 流结束标识
}STREAM_DATA_TYPE;

typedef enum _tagEZ_GLOBAL_EVENT_TYPE
{
    EZ_EVENT_VTDU_CACHE                                = 11,  //vtdu缓存信息回传
    
    // EZ_EVENT_HCNETSDK_EXCEPTION 为 HCNetSDK NET_DVR_SetExceptionCallBack_V30 全局异常回调，通用播放库内部已处理 EXCEPTION_PREVIEW EXCEPTION_PLAYBACK 两种异常类型，其他type的异常直接上抛 回调中没有设备序列号 pData 为 EZ_HCNETSDK_EXCEPTION_INFO* （指针）
    EZ_EVENT_HCNETSDK_EXCEPTION                        = 12,
    EZ_EVENT_DEV_INFO_UPDATED                          = 100,  //设备操作码发生变化,pdata为EZ_DEV_INFO*
	EZ_PRE_P2P_ESTABLISHED                             = EZ_ERROR_CAS_P2P_STATUS_BASE + 1,   //P2P预链接建立成功（保留）,pdata为NULL
	EZ_PRE_P2P_DISCONNECTED_STREAM_DATA_STOPPED        = EZ_ERROR_CAS_P2P_STATUS_BASE + 2,   //P2P预链接断开(播放过程中断开),pdata为NULL
	EZ_PRE_P2P_DISCONNECTED_NO_DATA_AFTER_PLAY         = EZ_ERROR_CAS_P2P_STATUS_BASE + 3,   //P2P预链接断开(发送play信令后一直没收到设备的流),pdata为NULL
	EZ_PRE_P2P_DISCONNECTED                            = EZ_ERROR_CAS_P2P_STATUS_BASE + 4,   //P2P预链接状态感知线程10秒内没有收到设备心跳包,pdata为NULL
    EZ_PRE_P2PSERVER_REDIRECT                          = EZ_ERROR_CAS_P2P_STATUS_BASE + 100, //P2P server重定向,pdata为char*的server地址,类似"7.7.7.7:7777,8.8.8.8:8888,9.9.9.9:9999"

}EZ_GLOBAL_EVENT_TYPE;

typedef struct _tagP2P_SERVER_INFO
{
    string    szP2PServerIp;
	int32_t 	iP2PServerPort;
}EZ_P2PSERVER_INFO;


typedef struct
{
    int8_t szP2PKey[64];                          ///< key used to encrypt/decrypt message body while communicate with P2P Server,
    //   which need to get from platform same as P2P Serve
    uint8_t saltIndex;                            ///< salt index, value [0, 7]
    uint8_t saltVer;                              ///< salt version, only two value: 0 or 1
    int8_t enabled;                             //该结构体内字段是否有效
}EZ_P2P_KEYINFO;

/*
 * 用于设置回放的速度
 */
typedef enum _tagEZ_PLAY_BACK_RATE {
    
    /**
     *
     */
    EZ_PLAY_RATE_NONE = -1,
    
    /**
     * 以1/16倍速度播放
     */
    EZ_PLAY_RATE_1_16 = 9,
    /**
     * 以1/8倍速度播放
     */
    EZ_PLAY_RATE_1_8 = 7,
    /**
     * 以1/4倍速度播放
     */
    EZ_PLAY_RATE_1_4 = 5,
    /**
     * 以1/2倍速播放
     */
    EZ_PLAY_RATE_1_2 = 3,
    /**
     * 以正常速度播放
     */
    EZ_PLAY_RATE_1 = 1,
    /**
     * 以2倍速播放
     */
    EZ_PLAY_RATE_2 = 2,
    
    /**
     * 以4倍速度播放
     */
    EZ_PLAY_RATE_4 = 4,
    
    /**
     * 以8倍速度播放
     */
    EZ_PLAY_RATE_8 = 6,
    
    /**
     * 以16倍速度播放
     */
    EZ_PLAY_RATE_16 = 8,
    
    /**
     * 以32倍速度播放
     */
    EZ_PLAY_RATE_32 = 10,
    
}EZ_PLAY_BACK_RATE;

/*
 * 用于创建取流客户端的初始化参数
 */
struct INIT_PARAM {
    
	int32_t   iStreamSource = EZ_STREAM_SOURCE_LIVE_MINE;			//EZ_STREAM_SOURCE(必填项)
    
    //-----------------取流配置------------------------
	int32_t	iStreamInhibit = EZ_STREAM_DISABLE_NONE;			//取流方式禁止位,见EZ_STREAM_INHIBIT，默认0(直连，P2P等都去尝试)；
    int32_t   iNeedProxy = 0; //是否需要蚁兵代理,0 不需要,1需要,2需要代理并且只使用商用代理
    int32_t   isSmallMtu = 0;  // P2P取流，是否使用小MTU，设置为私有，app层无需调用
    int32_t   iSmallStream = 0;  // 是否使用小码流 0-否 1-是 2/3G模式下使用小码流，重试取流也使用小码流
    int32_t   iPreOpWhileStream = 0; //取流时的预操作处理方式，0：按最初的方案处理 1：每次取流均强制异步预操作（取流前清理预操作结果，取流成功后，发起异步预操作）2:若直连非成功状态，则在预览、对讲和回放前强制进行一次内网直连检测
    
    //----------------客户端基本信息----------------
    string      szHardwareCode = "";    //客户端硬件号
    int32_t     iClnType = 0;                //标识客户端类型，1-iOS，3-Android，9-工作室
    int32_t     iIPV6 = 0;                    //是否ipv6,0 ipv4,1 ipv6
    int32_t     iInternetType = 0;  // 网络及运营商类型
    string      szLid = "";// app层的lid，传递到设备端用来做5410优化和日志联合查询
    //----------------客户端认证信息----------------
    string      szClientSession = "";    // 用户登陆Session(或开放平台access_token)
    string      szUserID = "";  // 登录的userid，用于对和P2P Server交互的信令做加密用
    int32_t     iNetSDKUserId = -1;//NETSDK登录ID，默认-1,当不为-1时强制走hcnet协议
    string      szStreamToken = "";//本次取流的token

    
    //----------------设备公共信息----------------
    string      szDevSerial = "";        //设备序列号
    string      szPreSerial = "";        //用于预连接的设备序列号，如果设备序列号为A，则相应为A.如果设备序列号为A-B，则预连接序列号也为A
    string      szSuperDeviceSerial = "";//父设备
    int32_t     iChannelCount = 0; // 设备直持的通道数
    int32_t     iShared = 0;  // 是否分享设备 0-否 1-是(别人分享过来的)
    string        szExtensionParas = "";//该字段由平台接口获取，用于私有流媒体转发的视频预览，内容如：biz=%d

//    int32_t     iSharedForCAS;///< 和iShared传入一样的值，库内部会将该值传递给CAS库，规避海外线上分享问题。现阶段海外需要传入，国内不需要传入（国内服务还没上），默认值为0.
    
    //----------------取流能力信息----------------
    int32_t iPlayBackLinkEncrypt = 0;///< 设备是否支持回放全链路加密, 0:不支持, 1:支持，不传入的话默认为0
    int32_t iLinkEncryptV2 = 0;      ///< 设备能力级是否支持全链路加密V2, 0:不支持, 1:支持 后续版本新增
    int32_t udpEcdh = 0;            ///< 设备能力级是否支持流媒体取流方式中的UDP全链路加密

    //----------------直连取流----------------
    string     szDevIP = "";            //设备IP (外网)
    string     szDevLocalIP = "";        //设备IP （内网）
    int32_t    iDevCmdPort = 0;            //信令端口(外网)
    int32_t    iDevCmdLocalPort = 0;        //信令端口(内网)
    int32_t    iDevStreamPort = 0;            //取流端口(外网)
    int32_t    iDevStreamLocalPort = 0;    //取流端口(内网)
    int32_t    iSupportPlayBackEndFlag = 0;  // 设备是否支持直连回放结束标记


    //----------------P2P取流----------------
    int32_t    iP2PVersion = 0;  // 支持p2p的版本号，由设备的能力集获得。 1-P2P_V1  2-P2P_V2  3-P2P_V3
    string      szP2pServerList = "";//p2p server list 格式：ip1:port1,ip2:port2,ip3:port3:ip4:port4...
    EZ_P2P_KEYINFO stP2PServerKey = {{},0,0,0};//p2p server key, 用于多账号体系下，SDK内部通过p2pServerKey.enabled字段是否为1，来确定是否向底层传入结构体中的其他参数（如果调用了ezstream_setP2PV3ConfigInfo，则该参数enabled可以设置为0）
    int32_t      usP2PKeyVer = 0;               ///< p2p key version, 如果不支持安全加固版本, 默认必现填写0
    int8_t       szP2PLinkKey[32] = {};//P2P链路加密密钥
    int32_t    iP2PSPS = 0;          // p2p打洞场景，上层传进来，用于数据统计
    int32_t   iSupportNAT34 = 0; // 设备是否支持3，4类NAT打洞逻辑,0 i不扶持，1 支持
    string	    szCasServerIP = "";		// CAS IP
	int32_t	iCasServerPort = 0;			// CAS Port
    string	    szStunIP = "";			// Stun IP 用于查询UDP套节字在路由上的NAT地址
	int32_t	iStunPort = 0;				// Stun port
    int32_t        iCheckInterval = 0;//P2P分享二次鉴权用
    
    //----------------对讲取流----------------
    string        szTtsIP = "";            //对讲服务器ip(对讲时选填)
    string        szTtsBackupIP = "";      //对讲服务器ip(对讲时选填) 上述二者至少有其一不能为空
    int32_t    iTtsPort = 0;              //对讲端口
    int32_t    iTalkType = 0;             //对讲呼叫类型，0-APP呼叫，3-设备呼叫
    string     szCallingId = "";           //对讲呼叫id
    int32_t    iMicType;              //麦克风类型，0-默认，(目前仅针对3摄锁，0-门外对讲；1-门内对讲麦克)


    //----------------流媒体取流----------------
    int32_t   iDevSupportAsyn = 0;  // 设备是否支持预览信令异步处理 0-否 1-支持 （解析能力集support_signal_aysn拿到）
    string        szVtmIP = "";            //私有化流媒体服务器IP
    string        szVtmBackIP = "";          //私有流媒体取流的备用IP，底层在某些条件下会使用该IP
    int32_t	iVtmPort = 0;               //私有化流媒体服务器端口
    //流媒体服务的公钥版本，如不支持全链路加密，一定要设置为0
    int32_t  vtduServerKeyVersion = 0;
    //全链路加密新增参数，流媒体服务的公钥，注意serverPublicKey这不是字符串，是一串二进制数据
    //服务端的公钥从平台拉取，并且从平台拿到的信息，APP需要base64解密后设置进来
    char  vtduServerPublicKey[91] = {0};
    
    //----------------云存储取流----------------
    string	    szCloudServerIP = "";	// 云存储服务器地址信息(回放云存储服务器上的视频时必填)
	int32_t	iCloudServerPort = 0;		//云存储服务器端口(回放云存储服务器上的视频时必填)
	string	szCloudServerBackupIP = "";		//云存储服务器备用IP(回放云存储服务器上的视频时选填)


    //----------------本次取流业务信息----------------
    int32_t    iStreamType = 0;            //码流类型 主子码流 1-主 2-子
    int32_t    iVideoLevel = 0;            //码流清晰度 0-流畅，仅用于蚁兵分配资源
    /**
        后端设备通道对应的前端设备序列号，此项必填。如果是N1/R1等设备回放，该值为通道号关联的IPC设备序列号；如果是IPC回放，对应的是IPC自身的序列号或者为空
        分三种情况
        a.IPC 回放 deviceSerial channelCount channelNo 等信息 均传入 IPC信息 szPBChnlSerial 传入IPC信息 秘钥传入IPC秘钥
        b.后端 直接回放 deviceSerial channelCount channelNo 等信息 均传入 后端信息 szPBChnlSerial 传入后端信息 秘钥传入后端秘钥
        c.IPC进入关联后端回放（实际回放后端）deviceSerial channelCount channelNo 等信息 均传入 后端信息 szPBChnlSerial 传入IPC信息 秘钥传入IPC秘钥
     */
    string        szPBChnlSerial = "";
    /**
        通道索引-用于GB28181
        老的国标设备的预览和回放的通道信息通过szChnlIndex该字段传入，
        新的国标设备预览最好通过iChannelNumber（int值）传入通道号,也可以通过szChnlIndex传入通道号
        新的国标设备回放最好通过szPBChnlSerial传入通道序列号，也可以通过szChnlIndex传入通道序列号
     */
    string         szChnlIndex = "";
    int32_t   iChannelNumber = 0;            //预览、回放的通道号
    int32_t   iVoiceChannelNumber = 0;      //对讲通道号
    int32_t   iNetSDKChannelNumber = 0;     //NetSDK取流通道号，不同于iChannelNumber[NETSDK取流必填]
    string        szPermanetkey = "";        // 存储密钥、码流加密密钥
    string        szTicketToken = "";       //云存储服分享用
    int32_t   iStorageVersion = 0;            ///< 存储版本,1 单文件存储模式；2 连续存储模式；3 待定
    
//    int32_t   iVideoType = 0;               ///< 本字段废弃，使用如下两个字段替代
    int32_t   iCloudVideoType = -1;         ///< 表示云存储录像类型，仅老协议云存储回放使用, -1 全部录像；1 连续录像；2 活动录像（默认值），用以替换原有的iVideoType字段
    int32_t   iSDCardVideoType = 0;         ///< 表示SD卡录像类型吗，仅SD卡回放业务使用  0:所有录像 1:定时录像 2:事件录像 3:智能-车 4:智能-人形 5:自动浓缩录像 6:定时浓缩录像 7:手动浓缩录像
    
                                        

    int32_t   iBusType = 0;                 ///< 业务类型，1：普通云录像，2：筛选录像，3：云空间，4：回收站
    string szStartTime = ""; //3.0.0 增加的回放参数
    string szStopTime = ""; //3.0.0 增加的回放参数
    string szFileID = ""; //3.0.0 增加的回放参数
    int32_t iFrameInterval = 0; ///< 浓缩录像的帧间隔(可选项) 单位:秒。浓缩录像下载时使用
    EZ_PLAY_BACK_RATE   iPlaybackSpeed = EZ_PLAY_RATE_NONE;
    string        szExtInfo = "";    //透传扩展信息

    
};


typedef struct
{
    //以下所有字段必须填入
    char                szDevSerial[EZ_DEV_LEN];            ///< 设备序列号
    char                szSuperDevSerial[EZ_DEV_LEN];       ///< 父设备序列号
    int                 iDevChannel;                  ///< 取流通道：1开始 or 对讲通道：0设备本身 其他标识接的IPC
    char                szContent[1024];            ///< 透传字段, 需要字符串
    int                 iContentLen;                ///< 透传信令长度, 最大不超过1024
    //以下是P2Pv3的信息，必须填入
    char                szUserId[64];              ///< 客户端UserId
    char                szServerGroup[256];        ///< P2P server集群信息, 格式 "192.168.111.111:10032;192.168.111.111:10033"
    unsigned int        usP2PKeyVer;               ///< p2p key version, 如果不支持安全加固版本, 默认必现填写0
    char                szP2PLinkKey[32];          ///< p2p link key
    
}EZ_P2PTRANSREQ_INFO, *pEZ_P2PTRANSREQ_INFO;

typedef struct
{
    char                szContent[1024];            ///< 透传字段, 需要字符串
    unsigned int        iContentLen;                ///< 透传信令长度
}EZ_P2PTRANSRSP_INFO, *pEZ_P2PTRANSRSP_INFO;

typedef struct
{
    char ezplayer[1024];    //通用库的所有新增配置
    char casclient[1024];   //CAS的所有新增配置
    char streamclient[1024];//streamclient的所有配置
}EZ_TIMEOUT_PARAM;


//************************************
// 函数名称 :  fnDataCallback
// 访问属性 :  public 
// 返回值   :  
// 参数     :  [OUT] userdata 自定义数据
// 参数     :  [OUT] datatype 数据类型,见STREAM_DATA_TYPE
// 参数     :  [OUT] pdata  数据内存地址
// 参数     :  [OUT] ilen 数据长度
// 参数     :  [out] iClientType 当前的取流方式
// 功能描述 :  取流数据回调,请不要在回调里面再直接或间接调用本SDK的任何接口
// 修改历史 :  初始版本(2016-3-28)
//************************************
typedef int32_t (*fnDataCallback)(void *userdata,int32_t datatype, int8_t* pdata, int32_t ilen, int32_t iClientType);
//************************************
// 函数名称 :  fnMsgCallback
// 访问属性 :  public 
// 返回值   :  
// 参数     :  [OUT] userdata 自定义数据
// 参数     :  [OUT] msg 消息类型,见MSG_TYPE
// 参数     :  [OUT] param 消息内容.msg及param对应关系见MSG_TYPE
// 功能描述 :  取流消息回调,请不要在回调里面再直接或间接调用本SDK的任何接口
// 修改历史 :  初始版本(2016-3-28)
//************************************
typedef int32_t (*fnMsgCallback)(void *userdata,int32_t msg, void* param);

//************************************
// 函数名称 :  fnStatisticsCallback
// 访问属性 :  public 
// 返回值   :  
// 参数     :  [OUT] userdata 自定义数据
// 参数     :  [OUT] statisticsType 统计类型类型,见STATISTICS_TYPE
// 参数     :  [OUT] pStatistics 统计信息体.statisticsType及pStatistics对应关系见STATISTICS_TYPE
// 功能描述 :  统计信息回调
// 修改历史 :  初始版本(2016-3-28)
//************************************
typedef int32_t (*fnStatisticsCallback)(void *userdata,int32_t statisticsType, BaseStatistics* pStatistics);

//************************************
// 函数名称 :  fnP2PPreconnectStatisticsCallback
// 访问属性 :  public
// 返回值   :
// 参数     :  [OUT] userdata 自定义数据
// 参数     :  [OUT] devSerial 设备序列号
// 参数     :  [OUT] pStatistics P2P预操作统计信息
// 功能描述 :  P2P预操作统计信息上报
// 修改历史 :  初始版本(2016-7-28)
//************************************
typedef int32_t (*fnPreconnectStatisticsCallback)(void *userdata,CLIENT_TYPES type, string devSerial, BaseStatistics* pStatistics);

//************************************
// 函数名称 :  fnOnDataCallback
// 访问属性 :  public
// 返回值   :
// 参数     :  [OUT] userdata 自定义数据
// 参数     :  [OUT] iDataLen 流数据长度
// 功能描述 :  只要有流数据,就会上报
// 修改历史 :  初始版本(2016-10-12)
//************************************
typedef int32_t (*fnOnDataCallback)(void *userdata,int32_t iDataLen);

//************************************
// 函数名称 :  fnP2PPreconnectStatusCallback
// 访问属性 :  public
// 返回值   :
// 参数     :  [OUT] userdata 自定义数据
// 参数     :  [OUT] szDevSerial 设备序列号
// 参数     :  [OUT] statusType P2P状态,EZ_P2P_STATUS_TYPE
// 参数     :  [OUT] pdata，根据statusType类型取不同类型的值
// 功能描述 :  P2P预操作感知回调
// 修改历史 :  初始版本(2016-7-28)
//************************************
typedef int32_t (*fnOnEventCallback)(void *userdata,int8_t	*szDevSerial,int32_t eventType,int8_t* pdata);

//************************************
// 函数名称 :  fnPreconnectResultCallback
// 访问属性 :  public
// 返回值   :
// 参数     :  [OUT] userdata 自定义数据
// 参数     :  [OUT] szDevSerial 设备序列号
// 参数     :  [OUT] CLIENT_TYPES 当前序列号的设备返回当前取流方式
// 参数     :  [OUT] isSuccess 操作是否成功
// 功能描述 :  预操作结果回调
// 修改历史 :  初始版本(2016-7-28)
//************************************
typedef int32_t (*fnPreconnectResultCallback)(void *userdata,int8_t	*szDevSerial,CLIENT_TYPES type,int32_t isSuccess);

//token回调接口，如果设置了全局的token回调，库内部在需要token的时候，会调用该回调，向外部请求token
//外部返回值为0表示token获取成功
typedef int32_t (*fnTokenCallback)(void *userdata, const char *userid, const char *serial, char *tokenBuffer, int bufferLength);


//日志回调函数
#ifdef ANDROID
    typedef void (ezLogCallback)(const char* tag, int level, char * logStr, void* user);
#else
    typedef void (ezLogCallback)(char * logStr);
#endif
/*
 * 用于创建上传留言的客户端的初始化参数
 */
typedef struct _tagUPLOAD_VOICE_PARAM {
    int32_t			iFrontType;				    // 前端类型，1-Web客户端, 2-iPhone客户端,3-iPad客户端, 4-android客户端, 5-android Pad客户端
    int32_t			iServerPort;	//服务器或设备端口
    int32_t			iIPV6;////是否ipv6,0 ipv4,1 ipv6
    int32_t           iFileType;					// -1-没有传值 0-普通文件 1-视频流 2-图片 3-音频 4-视频留言 5-音频留言
    string				szAuthorization;		// 认证号，客户端不用
    string				szClientSession;		// 客户端session
    string				szFileID;				// 上传文件ID 暂由客户端生成
    string				szFileName;				// 上传文件文件名
    string				szTimestamp;			// 上传文件时间戳
    string				szServerIP;	// 服务器或设备IP
    string              szTicketToken;            // 该请求对象的凭证
}UPLOAD_VOICE_PARAM;

/*
 * 用于创建下载云视频留言的客户端的初始化参数
 */
typedef struct _tagDOWNLOAD_CLOUD_PARAM {
    int32_t			iServerPort;	// 服务器或设备端口
    int32_t			iIPV6;////是否ipv6,0 ipv4,1 ipv6
    int32_t  			iChannelNumber;//通道号
    int32_t			iFileType;					// -1-没有传值 0-普通文件 1-视频流 2-图片 3-音频 4-视频留言 5-音频留言
    int32_t           iStreamType;				// 0-播放模式有流控 1-下载模式
    int32_t		    iPlayType;					// 1-正常回放模式 2-下载回放模式
    int32_t			iFrontType;				    // 前端类型，设备1，客户端2
    string				szAuthorization;		// 认证号，客户端不用
    string				szClientSession;		// 客户端session
    string				szTicketToken;			// 该请求对象的凭证
    string				szFileID;				// 文件ID 用于按文件回放，按时间回放则置空字符
    string				szCamera;				// 摄像机ID
    string				szBeginTime;			// 开始时间格式为20130617T102030Z 用于按时间回放，按文件回放则置空字符
    string				szEndTime;				// 结束时间格式为20130617T102030Z 用于按时间回放，按文件回放则置空字符
    string				szServerIP;	// 服务器或设备IP
    int32_t           iStorageVersion;            ///< 存储版本,1 单文件存储模式；2 连续存储模式；3 待定
    int32_t           iVideoType;                 ///< 录像类型, -1 全部录像；1 连续录像；2 活动录像（默认值）
    int32_t           iBusType;                   ///< 业务类型，1：普通云录像，2：筛选录像，3：云空间，4：回收站
    int32_t             iPlaySpeed;               ///< 播放速度：1-4倍速，2-8倍速，3-16倍速 4-32倍速
    int32_t             iInterlaceFlag;         //交织流标识，0：普通设备，1：交织流设备，字段为空时默认为0

}DOWNLOAD_CLOUD_PARAM;


typedef struct
{
    char			szDevSerial[EZ_DEV_LEN];	///< 设备序列号
    char			szOperationCode[64];		///< 设备操作码
    char			szKey[64];					///< 信令密钥
    int32_t			iEncryptType;				///< 密钥类型

}EZ_DEV_INFO;

typedef struct
{
	int32_t encode;
	int32_t sample;
	int32_t bitrate;
	int32_t payload;
	int32_t tracks;
}EZ_VOICE_PARAM;


typedef struct
{
	int32_t iCltNatType;    						///< 客户端nat type
}EZ_P2P_PUBLICPARAM;

/*typedef enum _tagEZ_NETSDK_KEY_PROJECT
{
    *//*
    加密类型
    *//*
    EZ_NETSDK_KEY_DEFAULT,//保留
    EZ_NETSDK_KEY_NORMAL, //普通不加密
    EZ_NETSDK_KEY_BULE, //蓝精灵
    EZ_NETSDK_KEY_GREEN, //绿巨人
    EZ_NETSDK_KEY_OEM3, //蓝猫
    EZ_NETSDK_KEY_BULE_AND_NORMAL,//兼容基线和蓝精灵
    EZ_NETSDK_KEY_GREEN_AND_NORMAL, //兼容基线和绿巨人
    EZ_NETSDK_KEY_BLUE_BLACK_AND_NORMAL,//兼容基线和蓝黑版本
    EZ_NETSDK_KEY_OEM3_AND_NORMAL//兼容基线和蓝猫密钥
}EZ_NETSDK_KEY_PROJECT;*/

typedef enum _tagEZ_PLAYBACK_OP
{
    /*
    回放操作类型
    */
    EZ_PLAYBACK_OP_PLAY = 0,//播放
    EZ_PLAYBACK_OP_PAUSE = 1,//暂停
    EZ_PLAYBACK_OP_RESUME = 2,//从暂停中恢复
    EZ_PLAYBACK_OP_SPEED = 3,//改变回放速度
    EZ_PLAYBACK_OP_SEEK = 4,//SEEK操作
    EZ_PLAYBACK_OP_CONTINUE = 5,//新协议的continue

    EZ_PLAYBACK_OP_RETRY = 10,// 通用库内部重试
}EZ_PLAYBACK_OP;

typedef enum _tagEZ_FAST_PLAY_MODE
{
    /*
    倍速类型
    */
    EZ_FAST_PLAY_MODE_DEFAULT = 0,//默认，未传该参数默认为0，即4倍速全帧，8倍速以上抽帧
    EZ_FAST_PLAY_MODE_EXTRACT_FRAME = 1,//抽帧
    EZ_FAST_PLAY_MODE_FULL_FRAME = 2,//全帧
}EZ_FAST_PLAY_MODE;


typedef struct {
    unsigned dwType;     //异常类型
    long lUserID;   //产生异常的登录userid
    long lHandle;   //产生异常的handle
}EZ_HCNETSDK_EXCEPTION_INFO;

typedef enum {
    EZ_TRANSFORM_TYPE_PS = 0x02,
    EZ_TRANSFORM_TYPE_MP4 = 0x05,
}EZ_TRANSFORM_TYPE;

typedef enum _tagEZ_STREAM_VIA
{
    EZ_STREAM_VIA_DIRECT_INNER = 0,             //内网直连
    EZ_STREAM_VIA_DIRECT_OUTER = 1,             //公网（外网）直连
    EZ_STREAM_VIA_VTDU = 2,                     //流媒体
    EZ_STREAM_VIA_SQUARE = 4,                   //流媒体广场取流
    EZ_STREAM_VIA_P2PV2 = 7,                    //P2PV2取流
    EZ_STREAM_VIA_VTDU_TO_P2PV2 = 8,            //流媒体切P2PV2
    EZ_STREAM_VIA_PROXY = 9,                    //蚁兵取流
    EZ_STREAM_VIA_DIRECT_REVERSE = 20,          //反向直连
    EZ_STREAM_VIA_VTDU_TO_DIRECT_INNER = 21,    //流媒体切内网直连
    EZ_STREAM_VIA_VTDU_TO_DIRECT_OUTER = 22,    //流媒体切外网直连
    EZ_STREAM_VIA_VTDU_TO_DIRECT_REVERSE = 23,  //流媒体切反向直连
    EZ_STREAM_VIA_P2PV3 = 25,                   //P2PV3
    EZ_STREAM_VIA_VTDU_TO_P2PV3 = 26,           //流媒体切P2PV3
    EZ_STREAM_VIA_VTDU_TO_PROXY = 28,           //流媒体切蚁兵
    EZ_STREAM_VIA_NETSDK = 30,                  //NETSDK取流
    EZ_STREAM_VIA_VTDU_TO_NETSDK = 31,          //流媒体切NETSDK取流
    EZ_STREAM_VIA_PLAYBACK_DIRECT_INNER = 10,   //内网直连回放
    EZ_STREAM_VIA_PLAYBACK_DIRECT_OUTER = 11,   //外网直连回放
    EZ_STREAM_VIA_PLAYBACK_VTDU = 12,           //流媒体回放
    EZ_STREAM_VIA_PLAYBACK_CLOUD = 14,          //云录像回放
    EZ_STREAM_VIA_PLAYBACK_NETSDK = 15,         //NETSDK本地回放
    EZ_STREAM_VIA_PLAYBACK_P2P = 17,            //P2P回放，仅支持V2
    EZ_STREAM_VIA_PLAYBACK_PROXY = 19,          //蚁兵回放

    EZ_STREAM_VIA_DOWNLOAD_DIRECT_INNER = 50,          //内网直连下载
	EZ_STREAM_VIA_DOWNLOAD_DIRECT_OUTER = 51,          //外网直连下载
	EZ_STREAM_VIA_DOWNLOAD_VTDU = 52,          //流媒体转发下载
	EZ_STREAM_VIA_DOWNLOAD_P2P = 57,          //P2P下载（V3）


}EZ_STREAM_VIA;

/** 海康头定义 */
typedef struct _tagEZ_HIK_MEDIAINFO             // modified by gb 080425
{
	unsigned  int     media_fourcc;            // "HKMI": 0x484B4D49 Hikvision Media Information
	unsigned  short  media_version;         // 版本号升级为0x0103,即1.03版本，01：主版本号；02：子版本号。添加区分intra码流标志。
	unsigned  short  device_id;                 // 设备ID，便于跟踪/分析
	unsigned  short  system_format;          // 系统封装层
	unsigned  short  video_format;            // 视频编码类型
	unsigned  short  audio_format;            // 音频编码类型
	unsigned  char   audio_channels;         // 通道数，1：单通道；2：双通道
	unsigned  char   audio_bits_per_sample;  // 样位率
	unsigned  int     audio_samplesrate;        // 采样率
	unsigned  int     audio_bitrate;              // 压缩音频码率,单位：bit
	unsigned  char   flag;                        //8bit,0x81表示是 smart标记，0x82表示是intra标记，0x84表示为Infinit  GOP标记，0x85表示多轨视频流，其余为普通码流
	unsigned  char  stream_tag;           //8bit,0x81表示码流中含有SDP信息
	unsigned  char    reserved[14];               // 保留
}EZ_HIK_MEDIAINFO;


namespace ez_stream_sdk {



// 以下宏定义用于HIK_MEDIAINFO结构
#define FOURCC_HKMI                   0x484B4D49     // "HKMI" HIK_MEDIAINFO结构标记
// 系统封装格式
#define SYSTEM_NULL                   0x0            // 没有系统层，纯音频流或视频流
#define SYSTEM_HIK                    0x1            // 海康文件层
#define SYSTEM_MPEG2_PS               0x2            // PS封装
#define SYSTEM_MPEG2_TS               0x3            // TS封装
#define SYSTEM_RTP                    0x4            // rtp封装
#define SYSTEM_RTPHIK                 0x401          // rtp封装
#define SYSTEM_MP4                    0x5
#define SYSTEM_RTMP                   0xD

// 视频编码类型
#define VIDEO_NULL                    0x0           // 没有视频
#define VIDEO_H264                    0x1           // 标准H.264和海康H.264都可以用这个定义
#define VIDEO_MPEG4                   0x3           // 标准MPEG4
#define VIDEO_MJPEG                   0x4
#define VIDEO_AVC264                  0x0100

// 音频编码类型
#define AUDIO_NULL                    0x0000        // 没有音频
#define AUDIO_ADPCM                   0x1000        // ADPCM
#define AUDIO_MPEG                    0x2000        // MPEG 系列音频，解码器能自适应各种MPEG音频
#define AUDIO_AAC                     0x2001
// G系列音频
#define AUDIO_RAW_DATA8               0x7000        // 采样率为8k的原始数据
#define AUDIO_RAW_UDATA16             0x7001        // 采样率为16k的原始数据，即L16
#define AUDIO_G711_U                  0x7110
#define AUDIO_G711_A                  0x7111
#define AUDIO_G722_1                  0x7221
#define AUDIO_G723_1                  0x7231
#define AUDIO_G726_U                  0x7260
#define AUDIO_G726_A                  0x7261
#define AUDIO_G729                    0x7290
#define AUDIO_AMR_NB                  0x3000

    
    struct ClientInfo {
//        int32_t clientType;
//        string clientVersion;
        int32_t isIPv6 = 0;
//        ClientInfo():isIPv6(0){}
    };
    
    struct DeviceInfo {
        string devSerial = "";
        int32_t channelNo = 0;
//        DeviceInfo():devSerial(""),channelNo(0){}
    };
    
    
    struct CloudServerInfo {
        string ip = "";
        string backUpIp = "";
        int32_t port = 0;
//        CloudServerInfo():ip(""),backUpIp(0),port(0){}
    };
    
    struct CloudStreamInfo {
        string ticket = "";
        int32_t playType = 0;
        int32_t storageVersion = 0;
        int32_t busType = 0;
        int32_t interlaceFlag = 0;//交织流标识，0：普通设备，1：交织流设备，字段为空时默认为0
        string extInfo = "";
//        CloudStreamInfo():ticket(""),playType(0),storageVersion(0),busType(0),interlaceFlag(0),extInfo(""){}
    };

    struct VideoStreamInfo {
        string seqId; //仅在筛选时传值，否则可能无法播放
        string beginTime;
        string endTime;
//        VideoStreamInfo(string seq,string begin,string end):seqId(seq),beginTime(begin),endTime(end){}
    };
    
    typedef vector<VideoStreamInfo> VideoStreamInfoList;
    
    struct CloudStreamReqBasicInfo {
        ClientInfo client = {};
        CloudServerInfo server = {};
        DeviceInfo deviceInfo = {};
        CloudStreamInfo cloudInfo = {};
//        CloudStreamReqBasicInfo():client(),server(),deviceInfo(),cloudInfo(){}
    };

    struct VideoControlInfo{
        EZ_PLAYBACK_OP op;
        EZ_PLAY_BACK_RATE speed;
        EZ_FAST_PLAY_MODE fastPlayMode;
        string currentTime;
        VideoStreamInfoList videoList;
        string seek_id;
    };


    typedef struct _EZQosReport {
        int transfer_type;
        float lost_rate;
        float rtt;          /*milliseconds*/
        float jitter;
        float bandwidth;
        float bitrate;     /*kbps*/
        float framerate;   /*fps*/
        float delay;       /*average*/
        float lag_slight_rate;
        float lag_middle_rate;
        float lag_serious_rate;
    }EZQosReport;


    struct NPStreamParam {
        string url;
    };

    struct AutoDefReportParam {
        int delay_slight;
        int delay_middle;
        int delay_serious;
        int period;

        int reduce_slight;
        int reduce_middle;
        int reduce_serious;
        int improve_slight;
        int improve_middle;
        int improve_serious;
    };
}

#endif /* _EZSTREAM_TYPES_H_ */
