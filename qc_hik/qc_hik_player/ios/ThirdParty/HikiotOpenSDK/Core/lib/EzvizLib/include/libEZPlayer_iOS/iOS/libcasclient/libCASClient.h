/**	@file libCASClient.h
 *	@note HangZhou Ezivz Co., Ltd. All Right Reserved.
 *	@brief 视频7 V1.7 同CAS服务器和设备交互的库
 *
 *	@author		qinfengwei
 *	@date		2013/07/11
 *
 *	@version V1.7.0.2  
 *	@note 本库封装了同CAS服务器和设备交互的协议。实现了预览、回放、对讲及信令收发的功能。支持1.7及以上设备协议。
 *	@note 历史记录：
 *		日期     版本			   人员     事项
 *	1. 20130711 创建
 *  2. 20131225 版本修改为1.7.2   强光杰  增加接口CASClient_SetGlintLight、CASClient_QueryGlintLight、CASClient_SerchRecordByMounth
 *  3  20140219 版本修改为1.7.3   强光杰  增加接口CASClient_GetLastDetailError
 *  4. 20140226 版本修改为1.7.4   秦峰巍  增加接口CASClient_CollectDevLogInfo、CASClient_PtzCtrl、CASClient_PtzPresetCtrl
 *  5. 20140308 版本修改为1.7.5   秦峰巍  增加接口CASClient_CapturePicture
 *  6. 20140310 版本修改为1.7.6   秦峰巍  增加接口CASClient_VerifyAndInviteStreamStart CASClient_VerifyAndRecordStreamStart CASClient_VerifyAndTalkStart
 *  7. 20140331 版本修改为1.7.7   秦峰巍  增加接口CASClient_DisplayCtrl
 *  8. 20140331 版本修改为1.7.8   秦峰巍  增加接口CASClient_ForceIFrame
 *  9. 20140331 版本修改为1.7.9   强光杰  增加接口CASClient_VoiceTalkStartEx CASClient_VerifyAndTalkStartEx
 * 10. 20141010 版本修改为1.8.0   peter	 增加接口CASClient_SetSwitchEnable
 * 11. 20141021 版本修改为1.8.1   费晨曦  增加接口CASClient_AddDetector CASClient_DelDetector
 */

#ifndef __LIBCASCLIENT_H__
#define __LIBCASCLIENT_H__

#define LIBCASCLIENT_VERSION  "v2.16.1"
#define LIBCASCLIENT_MOBILE_VERSION "v2.16.1.20240906"

#if defined (_WIN32) || defined(_WIN64)
    #ifdef LIBCASCLIENT_EXPORTS
        #define LIBCASCLIENT_API __declspec(dllexport)
    #else
        #define LIBCASCLIENT_API __declspec(dllimport)
    #endif
    
    #define CALLBACK __stdcall
    #define _USE_HLOG_

#elif defined (OS_POSIX) || defined (__APPLE__) || defined(ANDROID) || defined(__linux__)
    #define LIBCASCLIENT_API 

    #define CALLBACK
    #define __stdcall

#else
    #error OS unsupport!
#endif

// macro definition for string length
#define CASCLIENT_SERIAL_LEN   128  ///< string length of device serial number
#define CASCLIENT_KEY_LEN      64   ///< string length of key
#define CASCLIENT_IP_LEN       64   ///< string length of IP address
#define CASCLIENT_TIME_LEN     64   ///< string length of time
#define CASCLIENT_USERID_LEN   64   ///< string length of user id
#define CASCLIENT_TICKET_LEN   512  ///< string length of ticket
#define CASCLIENT_TID_LEN      128  ///< string length of tid
#define CASCLIENT_DESC_LEN     512  ///< string length of description
#define CASCLIENT_SEEKUUID_LEN 64   ///< string length of seekuuid

//MsgFunc Type
#define STREAM_STATISTICS       10 ///< 取流统计消息回调
#define AUDIO_NOTIFY			20 ///< 语音对讲相关消息回调
#define STREAM_NOTIFY			30 ///< 取流相关消息回调

//语音编码类型定义如下：
#define AUDIO_CODE_TYPE_G722_1      0   ///< G722_1
#define AUDIO_CODE_TYPE_G711_MU     1   ///< G711_MU
#define AUDIO_CODE_TYPE_G711_A      2   ///< G711_A
#define AUDIO_CODE_TYPE_G723        3   ///< G723
#define AUDIO_CODE_TYPE_MP1L2       4   ///< MP1L2
#define AUDIO_CODE_TYPE_MP2L2       5   ///< MP2L2
#define AUDIO_CODE_TYPE_G726        6   ///< G726
#define AUDIO_CODE_TYPE_AAC         7   ///< AAC
#define AUDIO_CODE_TYPE_RAW         99  ///< RAW

/**	@enum
 *  @brief 码流数据类型
 *	
 */
enum
{
    CASCLIENT_DVR_SYSHEAD                    =  1,          //系统头数据
    CASCLIENT_DVR_STREAMDATA                 =  2,          //视频流数据（包括复合流和音视频分开的视频流数据）
    CASCLIENT_DVR_AUDIOSTREAMDATA            =  3,          //音频流数据
    CASCLTENT_PLAYBACK_SEEKUUID              =  21,         //回放seek操作时，设备返回的seekuuid
    CASCLIENT_DVR_PLAYBACK_OVER              =  100,        //回放异常(异常错误从数据回调的pdata中获取),回放过程中上报, 处理方法: 关闭连接，重新请求
    CASCLIENT_PLAYBACK_REALOVER              =  200,        //服务器返回的结束标志，表示真正结束（云存储录像下载时)
    CASCLIENT_CLOUDPLAYBACK_SWITCH_TO_IFRAME =  201,        //服务器返回的快放模式切换标记，当收到此标记时，快放模式从全帧快放切换成抽帧快放(网络质量不足以满足全帧快放时)
    CASCLIENT_CLOUDPLAYBACK_LOWER_PLAY_SPEED =  202,        //服务器返回的降低快放倍速消息
    CASCLIENT_RELAY_SESSION_ERROR            =  300,        //Relay建立链路异常(int类型错误码从数据回调的pdata中获取,可参考libCASClient_Error.h),建立链路过程中上报, 处理方法: 关闭连接，重新请求
};

/**	@enum ENCRYPT_TYPE
 *  @brief 1.7平台支持的加密算法类型。
 *	暂只持不加密和AES128类型的加密方式
 */
typedef enum
{	
    NO_ENCRYPT = 0,	///< 不加密
    AES128,			///<AES128 加密
    AES192,			///<AES192 加密，暂不支持
    AES256			///<AES256 加密，暂不支持
}ENCRYPT_TYPE;

/**	@enum CAS_DEV_TYPE
 *  @brief 标识设备类型
 */
typedef enum
{	
    DEV_SINGLE_CHANNEL = 0,	    ///< 单通道
    DEV_MULTI_CHANNEL			///< 多通道
}CAS_DEV_TYPE;

/** @enum CAS_PRECONN_TYPE
 *  @brief 标识预链接类型
 */
typedef enum
{	
    PRECONN_TO_DEVICE = 0,	    ///< 针对设备建预链接
    PRECONN_TO_CHANNEL			///< 针对通道建预链接
}CAS_PRECONN_TYPE;

/** @enum ENNAT_TYPE
 *  @brief 标识路由器Nat类型
 */
typedef enum
{
    NAT_TYPE_BASE = 0,
    NAT_TYPE_FULLCONE,
    NAT_TYPE_RESTRICTCONE,
    NAT_TYPE_PORTRESTRICTCONE,
    NAT_TYPE_SYMMETRIC,
    NAT_TYPE_OPENNET,
    NAT_TYPE_OPENNET_FW,
    NAT_TYPE_UDPBLOCK,
    NAT_TYPE_UNKNOW
}ENNAT_TYPE;

/** @enum CAS_VOICE_CMDTYPE
 *  @brief 标识语音数据类型
 */
typedef enum
{
    VOICETALK_BASE_CMD = 0x4100,
    VOICETALK_BUTTON_PRESS_CMD = 0x4200,
    VOICETALK_BUTTON_UNPRESS_CMD = 0x4201
}CAS_VOICE_CMDTYPE;


/** @enum CAS_CONFIG_TYPE
 *  @brief 全局配置信息
 */
typedef enum
{
    CONFIG_CLIENT_NATTYPE = 0,      ///< 客户端NAT类型
    CONFIG_DYNAMIC_INFO,            ///< 平台动态配置信息,格式: "key1:value1;key2:value2;key3:value3"
    CONFIG_SSLCONNECT_TRYCOUNT,     ///< 设置libCASClient和CAS服务器SSL链接重试次数,[0-不走新的SSL链接方式，最大3]
    CONFIG_MAX43PUNCH_DEVICES,      ///< 客户端依据灰度配置项设置4G网络下43组合打洞次数上限，修复用户反馈的萤石云App断网问题, 范围[0-3]。如果App获取参数配置失败，则无需调用该接口进行设置
    CONFIG_REVERSEDIRECT_CHECKTTYPE,///< 设置反向直连检测类型, 0:同步检测, 1:异步检测
    CONFIG_CLIENT_TYPE,             ///< 设置客户端类型
    CONFIG_CLIENT_VERSION,          ///< 设置客户端版本
    CONFIG_CLIENT_IPV,              ///< 设置客户端网络类型,填写 AF_INET|AF_INET6
    CONFIG_LOG_LEVEL,               ///< 设置log级别
    CONFIG_APP_LOCALIP,             ///< 设置客户端本地ip地址
    CONFIG_P2PV3_TO_P2PV2,          ///< 支持p2pv3转p2pv2
    CONFIG_P2PV3_NONAT34_PUNCHTIME, ///< P2PV3非nat34 打洞超时时间
    CONFIG_NAT34_LIMIT,             ///< 限制Nat34下的打洞链接数，保持30秒内不超过500个链接
    CONFIG_NAT34_FORBIT,            ///< 禁止Nat34的端口开放和猜测逻辑
}CAS_CONFIG_TYPE;

/** @enum CAS_P2P_SELECTINFO_TYPE
 *  @brief P2P优选信息配置
 */
typedef enum
{
    P2P_SELECTINFO_PLAYCOUNT = 0,      ///< 取流次数
    P2P_SELECTINFO_PRERES,             ///< 预操作结果, 0:表示成功, 否则为失败错误码
}CAS_P2P_SELECTINFO_TYPE;


/** @struct CAS_BUS_TYPE
 *  @brief  业务类型
 */
typedef enum
{
    CAS_BUS_PREVIEW = 1,                 ///< 预览
    CAS_BUS_PLAYBACK = 2,                ///< 回放
    CAS_BUS_VOICETALK = 3,               ///< 对讲
    CAS_BUS_DOWNLOAD = 4,                ///< 下载
}CAS_BUS_TYPE;

/** @struct CAS_PLAYBACK_CONTROL_TYPE
 *  @brief  回放相关控制类型
 */
typedef enum
{
    CAS_PLAYBACK_PAUSE = 1,                 ///< P2P回放暂停
    CAS_PLAYBACK_RESUME = 2,                    ///< P2P回放恢复
    CAS_PLAYBACK_RATE_CONTROL = 3,              ///< P2P回放速率调整
    CAS_PLAYBACK_SEEK = 4,                      ///< 回放SEEK
    CAS_PLAYBACK_CONTINUE = 5,                  ///< 回放Continue
}CAS_PLAYBACK_CONTROL_TYPE;

/**	@enum E_INTERNET_TYPE[libCASClient.h]
 *  @brief  客户端当前所处网络环境。
 */
typedef enum  
{
    NET_UNKNOWN = 0,             //网络类型未知
    NET_WIFI,                    //手机连接的wifi
    NET_4G,                      //4G，但未检测出网络供应商
    NET_MOBILE_4G,               //移动4G
    NET_UNICOM_4G,               //联通4G
    NET_TELECOM_4G               //电信4G
}E_INTERNET_TYPE;

/**	@enum EN_STEP_TYPE
 *  @brief 取流步骤。
 *	枚举的细节描述
 */
typedef enum
{
    QUERY_MAP_SOCKET_V17= 0	,	    ///< 0  p2p-查询本机外网IP
    SETUP_V17 = 1,				    ///< 1	p2p-setup信令
    WAIT_KEEPLIVE = 3,              ///< 3  等待打洞成功
    P2P_SERVER_REDIRECT = 13        ///< 13 P2P Server地址重定向
                                    ///     如果消息类型是重定向，那么回调的ST_PLAYINFO_V17中的nRes对应的不再是结果
                                    ///     而是ST_P2PSERVER_REDIRECT_INFO的地址，外层需要对地址做解引用，然后才能取出地址信息
}EN_STEP_TYPE;

/**	@enum P2P_VERSION[libCASClient.h]
 *  @brief  
 * 
 *	P2P版本信息
 */
typedef enum
{
    P2P_V1 = 1,
    P2P_V2 = 2,
    P2P_V3 = 3,
    P2P_V2_1 = 4,      //电池设备p2pv2.1版本
}P2P_VERSION;

/** @enum EN_SWITCH_OPERATE_TYPE
 *  @brief 设备操作开关
 */
typedef enum
{
    VOICE_PROMPTS = 1,		///< 语音提示
    AUTO_ADJUST_RATE,		///< 自动调节码流
    CAMERA_LIGHT,			///< 补光灯
    INTELLIGENT_ANALYSIS,	///< 智能分析
    LOG_UPLOAD,				///< 日志上传
    A_ALARM_PLAN,			///< A系列的报警计划
    CTRL_PRIVATE_PROTECT,	///< 隐私保护控制
    CTRL_POSITION_SOUNDSOURCE,	///< 声源定位控制
    CTRL_CRUISE,			///< 巡航控制
    AUTO_DEFENCE,			///< 自动布撤防开关
    WIFI,			        ///< wifi开关
    WIFI_MARKETING,		    ///< wifi营销开关
    WIFI_LIGHT,	            ///< wifi营销开关
    SMART_SOCKET,	        ///< 智能插座开关
    PASSENGER_FLOW,	        ///< 客流统计开关
    HEAT_REPORT,	        ///< 热度上报开关
    STUDY_MODE = 17,        //c2plus学习模式
    DELETE_MODE,            //c2plus删除模式
    BLUETOOTH,              //蓝牙外放开关（c2plus）
    IMAGE_WIDE_ANGLE_CORRECTION,//图像广角矫正开关(c2plus)
    TRACK = 25,             //智能跟踪(c6h)
    WECHAT = 100,			//微信
    ALIBABA,			//阿里
    TENCENT2,			//腾讯
    BROADLINK,		//博联
    BAIDU 				//百度
}EN_SWITCH_OPERATE_TYPE;

/**	@enum CASCLIENT_MSG_TYPE
 *  @brief 消息回调枚举类型
 */
typedef enum
{
    CASCLIENT_DIRECT_REVERSE_SERVER_STAT = 1,       ///< 反向直连服务启动消息
    CASCLIENT_DIRECT_REVERSE_CHECK_STAT  = 2        ///< 反向直连服务检查消息
}CASCLIENT_MSG_TYPE;

/**	@enum CASCLIENT_STREAM_METHOD
 *  @brief 取流方式 1 -tcp 2-udp(P2P) 5-upnp反向直连
 */
typedef enum
{
    CASCLIENT_SM_DIRECT         = 1,                ///< 直连(内外网)
    CASCLIENT_SM_P2P            = 2,                ///< p2p
    CASCLIENT_SM_DIRECT_REVERSE = 5                 ///< 反向直连
}CASCLIENT_STREAM_METHOD;

/**	@enum CASCLIENT_DEV_STREAMSTATUS
 *  @brief 设备状态枚举类型
 */
typedef enum
{
    DevStreamStatusDefault    = -2,                 ///< 默认类型
    DevStreamStatusUnkown     = -1,                 ///< 未检测过
    DevStreamStatusNotSupport = 0,                  ///< 设备无法反向直连
    DevStreamStatusSupport    = 1                   ///< 设备可以反向直连
}CASCLIENT_DEV_STREAMSTATUS;

/**	@enum CASCLIENT_STREAM_DEVICE_TYPE
 *  @brief 设备类型  0：普通设备，1：交织流设备
 */
typedef enum
{
    CASCLIENT_COMMON_DEVICE       = 0,                ///< 普通设备
    CASCLIENT_INTERLACE_DEVICE    = 1                 ///< 交织流设备
}CASCLIENT_STREAM_DEVICE_TYPE;

/**	@struct ST_SERVER_INFO [libCASClient.h]
 *  @brief  服务器（设备）信息。
 *
 *	保存服务器（设备）的IP和端口
 */
typedef struct 
{
    char				szServerIP[CASCLIENT_IP_LEN];	///< 服务器或设备IP 
    unsigned short int	nServerPort;	                ///< 服务器或设备端口 
}ST_SERVER_INFO, *pSERVER_INFO;

/**	@struct ST_VIDEO_INFO[libCASClient.h]
 *  @brief  录像片段信息
 * 
 *	保存录像取流所需要信息
 */
typedef struct  
{
    char				szStartTime[CASCLIENT_TIME_LEN];			///< 开始时间, 格式为20190801T102030Z
    char				szStopTime[CASCLIENT_TIME_LEN];				///< 结束时间, 格式为20190801T102030Z
}ST_VIDEO_INFO, *pVIDEO_INFO;

/**	@struct ST_DEV_INFO[libCASClient.h]
 *  @brief  设备信息。
 * 
 *	保存设备的序列号、操作码、信令密钥及密钥类型（暂只支持AES128）
 */
typedef struct  
{
    char		 szDevSerial[CASCLIENT_SERIAL_LEN];	    ///< 设备序列号 
    char		 szOperationCode[CASCLIENT_KEY_LEN];    ///< 设备操作码 
    char		 szKey[CASCLIENT_KEY_LEN];				///< 信令密钥 
    ENCRYPT_TYPE enEncryptType;				            ///< 密钥类型 
    int          iShared;                               ///< 是否是分享设备，0-自有设备，1-分享设备
}ST_DEV_INFO, *pDEV_INFO;

/**	@struct ST_DEV_INFO[libCASClient.h]
 *  @brief  设备信息。
 * 
 *	保存设备的序列号、操作码、信令密钥及密钥类型（暂只支持AES128）
 */
typedef struct  
{
    char szDevSerial[CASCLIENT_SERIAL_LEN];	///< 设备序列号 
}ST_DEV_OUT_INFO, *pDEV_OUT_INFO;

/**	@struct ST_P2PV2[libCASClient.h]
 *  @brief  P2PV2 打洞和取流所需信息
 */
typedef struct
{
    const char*  pszClientSession;                      ///< 客户端标识 
    unsigned int uiClientSessionLen;                    ///< clientSession的长度，支持变长
    char		 szServerIP[CASCLIENT_IP_LEN];          ///< CAS IP 
    int			 iServerPort;				            ///< CAS Port 
    char		 szStunIP[CASCLIENT_IP_LEN];		    ///< Stun IP 用于查询UDP套节字在路由上的NAT地址
    int			 iStunPort;					            ///< Stun port
    char		 szOperationCode[CASCLIENT_KEY_LEN];    ///< 设备操作码 
    char		 szPermanetkey[CASCLIENT_KEY_LEN];	    ///< 存储密钥、码流加密密钥,回放必填
    char		 szKey[CASCLIENT_KEY_LEN];				///< 信令密钥 
    ENCRYPT_TYPE enEncryptType;				            ///< 信令密钥类型 
    int          iShared;                               ///< 该设备是不是分享设备,0-自由设备，1-分享设备
}ST_P2PV2;

/**	@struct ST_P2P_KEYINFO[libCASClient.h]
 *  @brief  P2PV3 信令加密密钥信息
 */
typedef struct
{
    char key[CASCLIENT_KEY_LEN]; ///< key used to encrypt/decrypt message body while communicate with P2P Server, 
                                 ///<   which need to get from platform same as P2P Server
    unsigned char saltIndex;     ///< salt index, value [0, 7]
    unsigned char saltVer;       ///< salt version, only two value: 0 or 1
}ST_P2P_KEYINFO, *pST_P2P_KEYINFO;


/**	@struct ST_P2P_KEYINFO[libCASClient.h]
 *  @brief  客户端公私钥信息
 */
typedef struct
{
    const char*     pPublicKey;                           ///< 客户端公钥, 用于全链路加密
    unsigned char   pPublicKeyLen;                        ///< 客户端公钥长度, 用于全链路加密
    const char*     pPrivateKey;                          ///< 客户端私钥, 用于全链路加密
    unsigned char   pPrivateKeyLen;                       ///< 客户端私钥长度, 用于全链路加密
}ST_ECDH_ENCRYPT_INFO, *pST_ECDH_ENCRYPT_INFO;

/**	@struct ST_P2PSETUPV3[libCASClient.h]
 *  @brief  P2P V3打洞所需参数
 */
typedef struct
{
    char           szUserId[CASCLIENT_USERID_LEN];  ///< 客户端UserId
    char           szServerGroup[256];              ///< P2P server集群信息, 格式 "192.168.111.111:10032;192.168.111.111:10033"
    unsigned short usP2PKeyVer;                     ///< p2p key version, 如果不支持安全加固版本, 默认必现填写0
    char           szP2PLinkKey[32];                ///< p2p link key
    bool           useServerKey;                    ///< true:优先使用stServerKey, 用于多账号体系下
    ST_P2P_KEYINFO stServerKey;                     ///< p2p server key, 用于多账号体系下
}ST_P2PSETUPV3;

/**	@struct ST_LINKKEYINFO[libCASClient.h]
 *  @brief  P2P V3打洞所需参数
 */

/**	@struct ST_P2PSETUP_INFO[libCASClient.h]
 *  @brief  
 * 
 *	P2P打洞所需参数
 */
typedef struct
{
    char				szDevSerial[CASCLIENT_SERIAL_LEN];   ///< 设备序列号 
    int					iDevChannel;				         ///< 取流通道：1开始 or 对讲通道：0设备本身 其他标识接的IPC
    int					iStreamType;				         ///< 主子码流 1-主 2-子
    bool                bSupportNAT34;                       ///< 设备是否支持3，4类NAT打洞逻辑
    CAS_DEV_TYPE        iDevType;                            ///< 设备类型，是单通道还是多通道             
    CAS_PRECONN_TYPE    ePreconnType;                        ///< 此次打洞是针对通道还是针对设备
    E_INTERNET_TYPE     eMobileNetType;                      ///< 手机端所处的网络环境
    P2P_VERSION			ver;						         ///< 所使用的P2P版本
    ST_P2PV2			stV2;						         ///< 如果ver==P2P_V1或者ver==P2P_V2
    ST_P2PSETUPV3		stV3;						         ///< 如果ver==P2P_V3
}ST_P2PSETUP_INFO, *pST_P2PSETUP_INFO;

/**	@struct ST_DEVSHARE_CHECKINFO[libCASClient.h]
 *  @brief  共享设备二次验证所需信息
 */
typedef struct
{
    char    szTicket[CASCLIENT_TICKET_LEN];     ///< Ticket
    char	szBiz[32];			                ///< 设备对分享做二次验证用
    int		iCheckInterval;                     ///< 设备对分享做二次验证用
}ST_DEVSHARE_CHECKINFO, *pST_DEVSHARE_CHECKINFO;

/**	@struct ST_P2PPLAYV3[libCASClient.h]
 *  @brief  P2P取流所需参数
 */
typedef struct
{
    CAS_BUS_TYPE	iBusType;					                ///< 业务类型 1: 预览 2: 回放 3:对讲 4:下载
    char            szPlayBackSerial[CASCLIENT_SERIAL_LEN];     ///< 针对多通道设备，填通道关联的设备的序列号
    char            szSuperSerial[CASCLIENT_SERIAL_LEN];        ///< hub模式下子设备对应的主设备序列号
    pVIDEO_INFO     pVideoArrary;                               ///< 一组或者多组录像片段信息
    unsigned int    iVideoNum;                                  ///< 录像片段的个数
    char            szLid[128];                                 ///< 在业务发起时生成全局唯一ID
    long long       lTimeStamp;                                 ///< 业务发起的时间戳
    unsigned char   iLinkEncryptV2;                             ///< 设备能力级是否支持全链路加密V2, 0:不支持, 1:支持
    int             iRecordType;                                ///< 录像类型(可选项)  0：默认值，不处理，5：自动浓缩录像，6：定时浓缩录像，7：手动浓缩录像
    unsigned int    iFrameInterval;                             ///< 浓缩录像的帧间隔(可选项) 默认请填0，单位:秒。浓缩录像下载时使用
}ST_P2PPLAYV3;

/**	@struct ST_P2PPLAY_INFO[libCASClient.h]
 *  @brief  P2P取流所需参数
 */
typedef struct
{
    char				szDevSerial[CASCLIENT_SERIAL_LEN];    ///< 设备序列号 
    int					iDevChannel;      		              ///< 取流通道：1开始; 对讲通道：0设备本身 其他标识接的IPC
    int					iStreamType;				          ///< 主子码流 1-主 2-子
    ST_DEVSHARE_CHECKINFO stShareCheck;				          ///< 设备分享检测信息
    ST_P2PV2			stV2;						          ///< P2P V2取流信息
    ST_P2PPLAYV3		stPlayV3;				              ///< P2P V3取流信息
    ST_P2PSETUPV3       stSetupV3;                            ///< P2P V3基本信息
}ST_P2PPLAY_INFO, *pST_P2PPLAY_INFO;

/**	@struct ST_P2PPLAY_INFO[libCASClient.h]
 *  @brief  P2P V3取流所需参数
 */
typedef struct
{
    char				    szDevSerial[CASCLIENT_SERIAL_LEN];    ///< 设备序列号 
    int					    iDevChannel;      		              ///< 取流通道：1开始; 对讲通道：0设备本身 其他标识接的IPC
    ST_DEVSHARE_CHECKINFO   stShareCheck;				          ///< 设备分享检测信息-
    char                    szSuperSerial[CASCLIENT_SERIAL_LEN];  ///< hub模式下子设备对应的主设备序列号
    ST_P2PSETUPV3           stV3;                                 ///< P2P V3基本信息
    char                    szLid[128];                           ///< 在业务发起时生成全局唯一ID
    long long               lTimeStamp;                           ///< 业务发起的时间戳
}ST_P2PPLAY_INFOV3, *pST_P2PPLAY_INFOV3;

/**	@struct ST_P2PTRANS_INFO[libCASClient.h]
 *  @brief  通过P2P通道发送透传信令
 */
typedef struct
{
    char	        szDevSerial[CASCLIENT_SERIAL_LEN];	    ///< 设备序列号 
    char            szSuperSerial[CASCLIENT_SERIAL_LEN];    ///< hub模式下子设备对应的主设备序列号
    int		        iDevChannel;      		                ///< 取流通道：1开始 or 对讲通道：0设备本身 其他标识接的IPC
    char            szContent[1024];                        ///< 透传字段, 需要字符串
    int             iContentLen;                            ///< 透传信令长度, 最大不超过1024
    ST_P2PSETUPV3   stV3;                                   ///< 如果ver==P2P_V3, P2P V3基本信息
}ST_P2PTRANS_INFO, *pST_P2PTRANSREQ_INFO;

/**	@struct ST_P2PTRANSRSP_INFO[libCASClient.h]
 *  @brief  通过P2P通道发送透传信令
 */
typedef struct
{
    char                szContent[1024];            ///< 透传字段, 需要字符串
    unsigned int        iContentLen;                ///< 透传信令长度
}ST_P2PTRANSRSP_INFO, *pST_P2PTRANSRSP_INFO;


/**	@struct ST_STREAM_INFO[libCASClient.h]
 *  @brief  取流信息。
 * 
 *	保存取流所需要信息
 */
typedef struct  
{
    const char*         pszClientSession;                       ///< 客户端标识 
    unsigned int        uiClientSessionLen;                     ///< ClientSession的长度，支持变长
    char				szDevSerial[CASCLIENT_SERIAL_LEN];	    ///< 设备序列号 
    char				szDevIP[CASCLIENT_IP_LEN];			    ///< 设备IP 
    int					iDevCmdPort;				            ///< 信令端口 
    int					iDevStreamPort;				            ///< 取流端口 
    int					iChannel;					            ///< 取流通道：1开始 or 对讲通道：0设备本身 其他标识接的IPC
    int					iStreamType;				            ///< 预览时表明主子码流 1-主 2-子；回放时表明清晰度，1流畅，2标清，3高清
    char				szOperationCode[CASCLIENT_KEY_LEN];		///< 设备操作码 
    char				szPermanetkey[CASCLIENT_KEY_LEN];		///< 存储密钥、码流加密密钥,回放必填
    char				szKey[CASCLIENT_KEY_LEN];				///< 信令密钥 
    ENCRYPT_TYPE		enEncryptType;				            ///< 信令密钥类型 
    char				szServerIP[CASCLIENT_IP_LEN];			///< CAS IP 
    int					iServerPort;				            ///< CAS Port 
    char				szStunIP[CASCLIENT_IP_LEN];			    ///< Stun IP 用于查询UDP套节字在路由上的NAT地址
    int					iStunPort;					            ///< Stun port
    char				szHdSign[64];				            ///< 硬件特征码, 目前用于反向直连检测
    bool                bSupportNAT34;                          ///< 设备是否支持3，4类NAT打洞逻辑
    bool                bSupportPlayBackEndFlag;                ///< 设备是否支持带结束标记的直连回放
    CAS_DEV_TYPE        iDevType;                               ///< 设备类型，是单通道还是多通道             
    CAS_PRECONN_TYPE    ePreconnType;                           ///< 此次打洞是针对通道还是针对设备
    E_INTERNET_TYPE     eNetType;                               ///< 客户端当前所处网络环境
    ST_DEVSHARE_CHECKINFO chkInfo;                              ///< 取流二次校验参数结构体
    char                szLid[128];                             ///< 在业务发起时生成全局唯一ID
    long long           lTimeStamp;                             ///< 业务发起的时间戳
    char				szSuperSerial[CASCLIENT_SERIAL_LEN];    ///< hub模式下子设备对应的主设备序列号
    unsigned char       iLinkEncryptV2;                         ///< 设备能力级是否支持全链路加密V2, 0:不支持, 1:支持  (此功能依赖bSupportPlayBackEndFlag)
    int                 iRecordType;                            ///< 录像类型(可选项)  0：默认值，不处理，5：自动浓缩录像，6：定时浓缩录像，7：手动浓缩录像
    unsigned int        iFrameInterval;                         ///< 浓缩录像的帧间隔(可选项) 默认请填0，单位:秒。浓缩录像下载时使用
}ST_STREAM_INFO, *pSTREAM_INFO;

/**	@struct ST_SEARCH_RECORD_INFO [libCASClient.h]
 *  @brief 录像查询结构体
 *
 * 录像查询所需参数
 */
typedef struct
{
    int		iSearchType;			                ///< 搜索类型 1-按时间 2-按月 按月搜索和按时间搜索分成两个接口了，此参数暂不用，但建议按实情填写。
    int		iChannelNo;				                ///< 通道号 从1开始 
    int     iChannelType;			                ///< 通道类型 0-A 1-D 
    char	szDevSerial[CASCLIENT_SERIAL_LEN];	    ///< 设备序列号，N1、R1需要此参数，其它设备可置为空
    int		iRecordType;			                ///< 录像类型  0:所有录像 1:定时录像 2:事件录像 3:智能-车 4:智能-人形 5:自动浓缩录像 6:定时浓缩录像 7:手动浓缩录像
    char	szStartTime[CASCLIENT_TIME_LEN];		///< 查询开始时间  20130617T102030Z 
    char	szStopTime[CASCLIENT_TIME_LEN];		    ///< 查询结束时间  20130617T202030Z 
    int     iYear;					                ///< 用于按月查询  年份 
    int     iMonth;					                ///< 用于按月查询  月份 	
    char    szRes[32];				                ///< 预留 
}ST_SEARCH_RECORD_INFO, *pST_SEARCH_RECORD_INFO;

/**	@struct ST_FINDFILE_V17[libCASClient.h]
 *  @brief  录像文件信息。
 * 
 *	保存录像的文件信息，用于返回从设备查询的录像文件信息。
 *  文件名、文件大小暂不支持
 */
typedef struct 
{
    char		szDevSerial[CASCLIENT_SERIAL_LEN];	///< 设备序列号 
    int			nChannelType;		                ///< 通道类型 0 模拟 1数字 	
    int         nChannelIndex;		                ///< 通道号
    char		szFileName[128];	                ///< 文件名 
    char		szStartTime[CASCLIENT_TIME_LEN];	///< 文件的开始时间 
    char		szStopTime[CASCLIENT_TIME_LEN];		///< 文件的结束时间 
    int			iFileSize;			                ///< 文件的大小 
    int         iFileType;			                ///< 文件类型 0:ALARM 1:TIMING 2:IO 
    int			iIsCrypt;			                ///< 录像是否加密 0-不加密 1-加密
    char		szCheckSum[64];		                ///< 加密秘钥两次MD5值
}ST_FINDFILE_V17, *pFILEINFO_V17;

/**	@struct ST_STORAGE_STATUS[libCASClient.h]
 *  @brief  设备的存储状态信息。
 * 
 *	保存设备的存储状态信息，从设备返回。
 */
typedef struct 
{
    char		szStorageIndex[32];		///< 存储介质序号 
    char        szStorageType[32];		///< 类型：卡，盘 
    int			nCapacity;				///< 存储容量 
    char		szStatus[32];			///< 状态 
    
}ST_STORAGE_STATUS, *pST_STORAGE_STATUS;

/**	@struct ST_DEV_BASIC_INFO [libCASClient.h]
 *  @brief  设备能力集信息。
 * 
 *	保存设备的能力集信息，从设备返回。
 */
typedef struct
{
    char szDevName[128];                        ///<设备名称
    char szDevSerial[CASCLIENT_SERIAL_LEN];	    ///<设备序列号
    char szFirmwareVersion[64];	                ///<设备版本
    char szDevType[64];			                ///<设备类型
    int iChanSum;				                ///<模拟通道数
    int iIPChanSum;				                ///<IP通道数
    int iAlarmInSum;			                ///<报警输入通道数
    int iAlarmOutSum;			                ///<报警输出通道数
    char szAudioEncodeType[32];	                ///<语音编码类型
}ST_DEV_BASIC_INFO, *pST_DEV_BASIC_INFO;

/**	@struct ST_DEV_DEFENCE_INFO [libCASClient.h]
 *  @brief  设备布撤防状态信息。
 * 
 *	保存设备的布撤防状态信息，从设备返回。
 */
typedef struct
{
    char szDefenceType[16];	///<布撤防类型 Type：PIR:红外，AtHome：在家（A1设备），OutDoor：外出（A1设备）,Global：全部，BabyCry：婴儿哭（F1设备），MotionDetect：移动侦测（F1设备）
    int iDefenceStatus;		///<布撤防状态  0-撤防 1-布防 2-不支持 3-强制布防（A1设备）
    char szDefenceActor[4];	///<D:设备， V：视频通道， I：IO通道
    int iChannel;   		///<视频和IO通道从1开始
}ST_DEV_DEFENCE_INFO, *pST_DEV_DEFENCE_INFO;

/**	@struct ST_DEV_FTP_INFO [libCASClient.h]
 *  @brief 设备FTP信息。
 *
 * 设备FTP信息
 */
typedef struct
{
    char szFtpIP[32];		///<FTP地址
    int iFtpPort;			///<FTP端口
    char szUserName[64];	///<登录FTP用户名
    char szPassword[64];	///<登录FTP密码
}ST_DEV_FTP_INFO, *pST_DEV_FTP_INFO;


/**	@struct ST_CLOUDREPLAY_INFO[libCASClient.h]
 *  @brief  云存储取流信息。
 * 
 *	保存云存储取流所需要信息
 */
typedef struct  
{
    const char*         pszClientSession;                       ///< 客户端session 
    unsigned int        uiClientSessionLen;                     ///< ClientSession的长度，支持变长
    char				szTicketToken[CASCLIENT_TICKET_LEN];	///< 该请求对象的凭证
    int					iFrontType;				                ///< 前端类型，设备1，客户端2 
    char				szFileID[64];				            ///< 文件ID 用于按文件回放，按时间回放则置空字符
    int                 iStorageVersion;                        ///< 存储版本,1 单文件存储模式（默认值）；2 连续存储模式；3 待定
    char				szCamera[CASCLIENT_SERIAL_LEN];	        ///< 摄像机ID
    char				szBeginTime[CASCLIENT_TIME_LEN];	    ///< 开始时间格式为20130617T102030Z 用于按时间回放，按文件回放则置空字符, 正常播放切换快放、拖动时需要填写该字段
    char				szEndTime[CASCLIENT_TIME_LEN];	        ///< 结束时间格式为20130617T102030Z 用于按时间回放，按文件回放则置空字符, 正常播放切换快放、拖动时需要填写该字段
    int                 iVideoType;                             ///< 录像类型, -1 全部录像；1 连续录像；2 活动录像（默认值）
    int					iFileType;					            ///< -1-没有传值 0-普通文件 1-视频流 2-图片 3-音频 4-视频留言 5-音频留言
    int					iPlayType;					            ///< 播放类型：0-暂停；1-回放(或者恢复回放)；2-下载 ；3-I帧快放 ；4-跳转
    int					iChannelNumber;				            ///< 通道号
    int                 iPlaySpeed;                             ///< 播放速度：1-4倍速，2-8倍速，3-16倍速 4-32倍速
    int                             iBusType;                               ///< 业务类型，1：普通云录像，2：筛选录像，3：云空间，4：回收站
    CASCLIENT_STREAM_DEVICE_TYPE    iInterlaceFlag;                         ///< 交织流标识，0：普通设备，1：交织流设备，字段为空时默认为0
}ST_CLOUDREPLAY_INFO, *pCLOUDREPLAY_INFO;

/**	@struct ST_CLOUDVIDEO_INFO[libCASClient.h]
 *  @brief  云存储录像片段信息
 * 
 *	保存云存储取流所需要信息
 */
typedef struct  
{
    char                szSeqId[64];                ///< 标识片段，连续云存储1小时SeqId相同，非连续一个活动片段一个SeqId，0表示查询范围内录像
    ST_VIDEO_INFO		stVideoInfo;
}ST_CLOUDVIDEO_INFO, *pCLOUDVIDEO_INFO;

/**	@struct ST_CLOUDPLAY_INFO[libCASClient.h]
 *  @brief  云存储取流信息。
 * 
 *	保存云存储取流所需要信息
 */
typedef struct  
{
    char				szTicket[CASCLIENT_TICKET_LEN];         ///< 权限校验，resourceid为"序列号:通道号"，bizcode为"CLOUD-REPLAY-SHARE"
    int                 iBusType;                               ///< 业务类型，1：普通云录像，2：筛选录像，3：云空间，4：回收站
    int					iPlayType;					            ///< 播放类型：1-回放；2-下载
    int                 iStorageVersion;                        ///< 存储版本, 1：单文件存储，2：连续存储
    char				szDevSerial[CASCLIENT_SERIAL_LEN];	    ///< 设备序列号
    int					iChannelNo;				                ///< 通道号
    pCLOUDVIDEO_INFO    pVideoArrary;                           ///< 录像片段信息
    unsigned int                        iVideoNum;              ///< 录像片段的个数
    CASCLIENT_STREAM_DEVICE_TYPE        iInterlaceFlag;         ///< 交织流标识，0：普通设备，1：交织流设备，字段为空时默认为0    
    const char* pszExtInfo;                                     ///< 透传字段，变长，最大不超过1024
    unsigned int uiExtInfoLen;                                  ///< 透传字段长度
}ST_CLOUDPLAY_INFO, *pCLOUDPLAY_INFO;

/**	@struct ST_CLOUDCONTROL_INFO[libCASClient.h]
 *  @brief  云存储控制信息
 * 
 */
typedef struct  
{
    int					iPlayType;					        ///< 播放类型：0-暂停；1-回放(或者恢复回放)；2-下载 ；3-I帧快放 ；4-跳转
    char				szBeginTime[CASCLIENT_TIME_LEN];	///< 格式为20171101T102030Z，起始时间，拖动时需要填写该字段，结束时间固定，不用传
    int                 iPlaySpeed;                         ///< 播放速度：1-4倍速，2-8倍速，3-16倍速 4-32倍速
}ST_CLOUDCONTROL_INFO, *pCLOUDCONTROL_INFO;

/**	@struct ST_CLOUDCONTROL_INFO_EX[libCASClient.h]
 *  @brief  云存储控制信息
 * 
 */
typedef struct  
{
    CAS_PLAYBACK_CONTROL_TYPE   eType;                              ///< 控制类型: 1：暂停，2：暂停恢复，3：切换倍速，4：Seek，5：Continue
    unsigned int                iPlaySpeed;                         ///< 播放速度：0-1倍速,1-4倍速,2-8倍速,3-16倍速,4-32倍速（只在切换倍速时填写）
    char				        szCurTime[CASCLIENT_TIME_LEN];      ///< 切换倍速时的osd时间, 格式为20190801T102030Z（只在切换倍速时填写）
    pCLOUDVIDEO_INFO            pVideoArrary;                       ///< 录像片段信息（只在Seek或者Continue倍速时填写）
    unsigned int                iVideoNum;                          ///< 录像片段的个数（只在Seek或者Continue倍速时填写）
    int                         iFastplayMode;                      ///< 当eType=3必填。1：抽帧，2：全帧，未传该参数默认为0，即4倍速全帧，8倍速以上抽帧
    unsigned int                iNewPlaySpeed;                     ///< 播放速度：1-1倍速,2-2倍速,3-1/2倍速,4-4倍速,5-1/4倍速,6-8倍速,7-1/8倍速,8-16倍速,9-1/16倍速,10-32倍速（只在切换倍速时填写）
}ST_CLOUDCONTROL_INFO_EX, *pCLOUDCONTROL_INFO_EX;

/**	@struct ST_CLOUDFILE_INFO
 *  @brief  云储存文件信息
 */
typedef struct  
{
    const char*         pszClientSession;                       ///< 客户端session
    unsigned int        uiClientSessionLen;                     ///< ClientSession的长度，支持变长
    int					iFrontType;				                ///< 前端类型，1-Web客户端, 2-iPhone客户端,3-iPad客户端, 4-android客户端, 5-android Pad客户端
    char				szFileID[64];				            ///< 上传文件ID 暂由客户端生成
    char				szFileName[64];				            ///< 上传文件文件名
    int                 iFileType;					            ///< -1-没有传值 0-普通文件 1-视频流 2-图片 3-音频 4-视频留言 5-音频留言
    char				szTimestamp[CASCLIENT_TIME_LEN];	    ///< 上传文件时间戳
    char                szTicketToken[CASCLIENT_TICKET_LEN];    ///< 该请求对象的凭证
}ST_CLOUDFILE_INFO, *pCLOUDFILE_INFO;

/**	@struct ST_DEV_ALARM_SOUND_INFO [libCASClient.h]
 *  @brief  设备布撤防状态信息。
 * 
 *	配置报警声音的类型。
 */
typedef struct
{
    int		iEnable;			///< 设备报警声音开启或关闭 1-开 0-关 
    int		iSoundType;			///< 声音的类型 0-短叫 1-长叫 
    char    szRes[32];			///< 预留 
}ST_DEV_ALARM_SOUND_INFO, *pST_DEV_ALARM_SOUND_INFO;

/**	@struct ST_DEV_ALARM_SOUND_INFO [libCASClient.h]
 *  @brief  设备补光灯信息。
 * 
 *	设备补光灯信息
 */
typedef struct
{
    int		iChannelIndex;		///< 设备的通道号
    int		iLightValue;		///< 亮度[0-10]之间
    char    szRes[32];			///< 预留 
}ST_CHAN_GLINTLIGHT_INFO, *pST_CHAN_GLINTLIGHT_INFO;


/**	@struct ST_COLLECTLOG_INFO [libCASClient.h]
 *  @brief  日志收集服务器信息。
 * 
 *	日志收集服务器信息，下发给设备日志收集服务器的信息，设备上传日志到服务器
 */
typedef struct
{
    char	szCollectAddr[64];		///< 日志收集服务器的域名地址
    int		iCollectPort;			///< 日志收集服务器的端口
    char    szCollectPath[128];		///< 日志的上传路径
    int     iDays;					///< 收集日志的天数
    char    szAuthCode[64];			///< 上传日志的验证码
}ST_COLLECTLOG_INFO, *pST_COLLECTLOG_INFO;


/**	@struct ST_PTZ_INFO [libCASClient.h]
 *  @brief  云台控制信息。
 *	
 *	云台控制信息，包括云台及预置点的控制信息
 *  云台命令：UP、DOWN、LEFT、RIGHT、UPLEFT、DOWNLEFT、UPRIGHT、DOWNRIGHT、ZOOMIN、ZOOMOUT、FOCUSNEAR、FOCUSFAR、IRISSTARTUP、IRISSTOPDOWN、LIGHT、WIPER、AUTO.
 *  预置点控制命令：SET_PRESET-设置预置点，CLE_PRESET-清除预置点，GOTO_PRESET-转到预置点.
 */
typedef struct
{
    char	szCommand[16];		///< 云台命令、预置点控制命令
    int		iChannel;			///< 要控制的通道号，取值：1，2，3，……。
    char	szAction[16];		///< 云台动作；"START":开始 "STOP":结束。云台命令时生效
    int		iSpeed;				///< 云台速度，取值： 0-7。云台命令时生效
    int     iPresetIndex;		///< 预置点编号。预置点控制命令时生效
}ST_PTZ_INFO, *pST_PTZ_INFO;

/**	@struct ST_DISPLAY_INFO [libCASClient.h]
 *  @brief  图像显示设置。
 *	
 *	图像显示设置信息，包括镜像设置
 *  镜像命令：UP_DOWN、LEFT_RIGHT、CENTER、CLOSE	
 */
typedef struct
{
    char	szCommand[16];		///< 控制命令。现只支持镜像设置
    int		iChannel;			///< 要控制的通道号，取值：1，2，3，……。
    char	szRes[100];			///< 预留
}ST_DISPLAY_INFO, *pST_DISPLAY_INFO;


/**	@struct ST_CAPTURE_PIC_INFO [libCASClient.h]
 *  @brief  抓图信息。
 *	
 *	客户端到设备抓图
 */
typedef struct
{
    int		iChannel;			///< 抓图通道号，取值：1，2，3，…… ，设备填0
    char	szType[16];			///< 抓图类型 "JPEG"
    int		iResolution;				
    int     iQuality;				    
    bool    bEncrypted;			///<false不加密 true加密，密钥为设备验证码，格式和报警图片一样
    char	szPmsAddr[64];		///<图片服务器地址
    int		iPmsPort;			///<图片服务器端口
    char    szHttpsServer[64];  ///<Https服务器地址
    int     iHttpsPort;         ///<Https服务器端口
    char	*pPic;				///<直连时表示接收图片内存的地址，转发时表示图片的url
    int     iPicLen;			///<接收图片内存的长度,传入时为内存大小，传出时为图片的真实大小
}ST_CAPTURE_PIC_INFO, *pST_CAPTURE_PIC_INFO;

/**	@struct ST_POINT
 *  @brief  点位坐标
 */
typedef struct
{
    int		iPoint_X;
    int		iPoint_Y;
}ST_POINT, *pST_POINT;

/**	@struct ST_POSITIONP3D_INFO [libCASClient.h]
*  @brief 3D定位信息
*/
typedef struct
{
    int			iChannel;			///<设备通道，设备为0，视频通道从1开始
    ST_POINT	stStartPoint;		///<左上角坐标
    ST_POINT	stEndPoint;			///<右下角坐标
}ST_POSITION3D_INFO, *pST_POSITION3D_INFO;


/**	@struct ST_AUTODEFENCEBIND_INTO [libCASClient.h]
 *  @brief 为设备绑定主人MAC
 */
typedef struct
{
    int			iStatus;			                    ///<1:建立绑定	0:删除绑定
    char		szMac[24];			                    ///<手机的mac信息
    char		szSubSerial[CASCLIENT_SERIAL_LEN];	///<设备短序列号
    char		szChannel[256];		                    ///<下挂设备通道
}ST_AUTODEFENCEBIND_INTO, *pST_AUTODEFENCEBIND_INTO;

/**	@struct ST_SETCRUISEPOSITION_INFO
 *  @brief  预置点信息
 */
typedef struct
{
    int iCommond;  ///<Commond:SET--设置巡航路径，CLEAR--清除巡航路径
    int iChannel;  ///<要控制的通道号，通道：1、2、3，设置：0
    char szPreset[128];   ///<巡航路径上的预置点，通过逗号分割预置点 "1,2,3,4"
}ST_SETCRUISEPOSITION_INFO, *pST_SETCRUISEPOSITION_INFO;


/**	@struct ST_P2PSERVER_REDIRECT_INFO [libCASClient.h]
 *  @brief 重定向的P2P SERVER地址，格式类似7.7.7.7:7777,8.8.8.8:8888,9.9.9.9:9999,
*/
typedef struct
{
    char      szP2PServerAddress[512];			///< P2P Server重定向地址
}ST_P2PSERVER_REDIRECT_INFO, *pST_P2PSERVER_REDIRECT_INFO;

/**	@struct ST_PLAYINFO_V17
 *  @brief 取流步骤的结果及耗时。
 *	枚举的细节描述
 */
typedef struct  
{
    EN_STEP_TYPE	nMsgType;	//取流步骤类型
    int 		nRes;		    //否则返回信令结果   0:失败  1:成功    
    long		nMs;			//信令时间差，单位毫秒
    int         nErr;           //错误码
    int         bPreConn;       //用于区分是1-预链接，还是0-普通P2P，供NetStream区分使用
    void*       pRedirectInfo;  //当nMsgType是P2P_SERVER_REDIRECT，该值保存重定向对象ST_P2PSERVER_REDIRECT_INFO的地址
}ST_PLAYINFO_V17;

/**	@struct PRE_CONN_STAT_INFO[libCASClient.h]
 *  @brief  打洞上报字段。
 * 
 *	保存打洞上报相关内容信息
 */
typedef struct
{
    char        szTid[CASCLIENT_TID_LEN];	    ///< 预链接标识 
    char        szCASIP[CASCLIENT_IP_LEN];      ///< CAS地址 
    int         iCASPort;                       ///< CAS端口
    char        szStunIP[CASCLIENT_IP_LEN];     ///< Stun IP 用于查询UDP套节字在路由上的NAT地址
    int	        iStunPort;                      ///< Stun port
    char        szDevNATIP[CASCLIENT_IP_LEN];   ///< 设备NAT地址
    int         iDevNATPort;                    ///< 设备NAT映射端口
    char        szDevLocalIp[CASCLIENT_IP_LEN]; ///< 设备本地地址
    int         iDevLocalPort;                  ///< 设备本地端口
    char        szDevUpnpIP[CASCLIENT_IP_LEN];  ///< 设备UPNP地址
    int         iDevUpnpPort;                   ///< 设备UPNP端口
    int         iSuccessCandidate;              ///< 打洞成功的设备地址标识，0：打洞失败，1：局域网，2：UPNP，3：NAT
    char        szDesc[CASCLIENT_DESC_LEN];     ///< 错误具体描述
    int         iDnt;                           ///< 设备NAT类型，setup信令中返回
    int         iVer;                           ///< 设备版本信息, 0:不支持3-4类打洞, 1:支持3-4类打洞, 3:支持P2P V3版本
    int         iCTCount;                       ///< 新增CT检测次数 
}PRE_CONN_STAT_INFO;

/**	@struct PRE_CONN_STAT_INFO[libCASClient.h]
 *  @brief  打洞上报字段。
 * 
 *	保存打洞上报相关内容信息
 */
typedef struct
{
    int         iR;                         ///< 启动反向直连服务状态, 0 表示服务成功开启
    int         iCost;                      ///< 服务器启动耗时情况
    int	        iRetrycount;                ///< upnp重试次数
    int         iType;                      ///< 服务启动类型
    char        szMapIP[CASCLIENT_IP_LEN];  ///< 服务对外 ip
    int         iMapPort;                   ///< 服务对外 port
    char        szNatIP[CASCLIENT_IP_LEN];  ///< 外网IP地址
    int         iClntype;                   ///< 客户端类型
    char        szVer[32];                  ///< Libcasclient 的版本信息
    int         iUpnpstat;                  ///< 端口映射的状态, 下列是按照端口的映射操作顺序依次进行的
    int         iUpnpr;                     ///< 端口映射错误码
}ReverseDirect_STAT_INFO;

/**	@struct PRE_CONN_STAT_INFO[libCASClient.h]
 *  @brief  预链接取流上报字段。
 * 
 *	保存预链接取流上报相关内容信息
 */
typedef struct
{
    char        szTid[CASCLIENT_TID_LEN];	        ///< 预链接标识 
    char	    szDevSerial[CASCLIENT_SERIAL_LEN];	///< 设备序列号 
    int         iDevChannel;                        ///< 设备通道号
    char        szCASIP[CASCLIENT_IP_LEN];          ///< P2P V2为CAS地址, P2P V3为P2P Server集群首个地址
    int         iCASPort;                           ///< P2P V2为CAS端口, P2P V3为P2P Server集群首个地址端口
    char        szDesc[512];                        ///< 错误具体描述
    int         iTransmode;                         ///< 信令发送成功的传输渠道, 0: UDT; 1: Server
    int         iT1;                                ///< P2P_V2时, p2p-play信令耗时; P2P_V3时, 发送p2p-play信令到收到p2p-play rsp信令的耗时
    int         iR1;                                ///< p2p-play信令错误码
}ST_P2P_STREAM_STAT_INFO;

/**	@struct CASCLIENT_DEV_STATUS_INFO
 *  @brief  设备状态信息, 取流之前判断逻辑
 */
typedef struct 
{
    char        szTid[CASCLIENT_TID_LEN];	        ///< 设备状态判断标识 
    CASCLIENT_DEV_STREAMSTATUS eStreamStatus;       ///< 状态
}CASCLIENT_DEV_STATUS_INFO;

/** @struct CAS_P2P_PLAYBACK_CONTROL_INFO
 *  @brief  P2P回放控制数据结构体
 */
typedef struct _CAS_P2P_PLAYBACK_CONTROL_INFO
{
    CAS_PLAYBACK_CONTROL_TYPE   eType;                              ///< 控制类型: 1：暂停，2：暂停恢复，3：切换倍速，4：Seek，5：continue
    unsigned int                iPlaySpeed;                         ///< 速率控制: 速率 1(1倍速),2(2倍速),3(1/2倍速),4(4倍速),5(1/4倍速),6(8倍速),7(1/8倍速)（只在切换倍速时填写）
    char				        szCurTime[CASCLIENT_TIME_LEN];      ///< 切换倍速时的osd时间, 格式为20190801T102030Z（只在切换倍速时填写）
    pVIDEO_INFO                 pVideoArrary;                       ///< 录像片段信息（只在Seek或者continue倍速时填写）
    unsigned int                iVideoNum;                          ///< 录像片段的个数（只在Seek或者continue倍速时填写）
    char                        szSeekUuid[CASCLIENT_SEEKUUID_LEN]; ///< seekuuid, 回放seek操作的唯一ID（seek 2.0协议, 只在操作 具备support_seek_v2能力集的设备 时填写）
}CAS_P2P_PLAYBACK_CONTROL_INFO, *pCAS_P2P_PLAYBACK_CONTROL_INFO;

/** @struct CAS_SELECT_OPT
 *  @brief  优选传入参数
 */
typedef struct _CAS_SELECT_OPT
{
    unsigned int        iDevNum;     ///< 优选的设备数量
    E_INTERNET_TYPE     eNetType;    ///< 客户端当前所处网络环境
}CAS_SELECT_OPT, *pCAS_SELECT_OPT;

/**	
 *  @struct P2PCore_LinkInfo
 *  @brief  定义建立数据链路参数
 */
typedef struct
{
    char            szDevSerial[CASCLIENT_SERIAL_LEN];	    ///< 设备序列号 
    char            szTicketToken[CASCLIENT_TICKET_LEN];    ///< 该请求对象的凭证
    char            szRelayIP[CASCLIENT_IP_LEN];            ///< Relay Server IP
    int             iRelayPort;                             ///< Relay Server Port
    int             iChannel;                               ///< 通道号。NVR时多通道设备时，请填具体通道号。IPC时，请填1。内部默认1。用于ticket校验
    unsigned char   iAuthType;                              ///< Auth Type, 0:opensdk, 1:ezviz
    unsigned char   iRelayPublicKeyVer;                     ///< 对端Public key version
    unsigned int    iRelayPublicKeyLen;                     ///< 对端Public key length
    unsigned char*  pRelayPublicKey;                        ///< 对端Public key, 使用从平台获取的base64格式的密钥
    int             iTimeout;                               ///< 接口超时时间设置, 单位ms, 范围[500,10000], 默认10s
}CAS_TRANS_OPT, *pCAS_TRANS_OPT;

/**	
 *	@brief 消息回调，暂时可不使用
 *	@param[out] sessionhandle 取流句柄 
 *	@param[out] opt 消息类型 
 *	@param[out] userdata 用户数据 
 *	@param[out] param1 参数1 由用户自定义不同的结构体
 *	@param[out] param2 参数2 
 *	@param[out] param3 参数3
 *	@return	
 *	@note 调用CASClient_CreateSession时 传入回调函数地址
 *  1. opt 消息号 STREAM_STATISTICS 对应 param1 的结构体为 ST_PLAYINFO_V17
 *  2. opt 消息号 AUDIO_NOTIFY 与语音对讲相关；对应 param1 为CAS库定义的错误码，转换为int类型，可参考libCASClient_Error.h ，param2为int类型的底层依赖库错误码
 *  3. opt 消息号 STREAM_NOTIFY 与取流相关；对应 param1 为CAS库定义的错误码，转换为int类型, 可参考libCASClient_Error.h ，param2为int类型的底层依赖库错误码
 */
typedef int (CALLBACK *MsgFuncEx)(int sessionhandle, int opt, void* userdata, void* param1, void* param2, void* param3);

/**	
 *	@brief 数据回调，包括视频回调和音频回调
 *	@param[out] sessionhandle 取流句柄
 *	@param[out] userdata 用户数据
 *	@param[out] datatype 数据类型 1流头 2流数据 3音频数据 100异常结束，200正常结束，300为Relay建立链路异常时的int类型错误码,可参考libCASClient_Error.h
 *	@param[out] pdata 回调数据指针
 *	@param[out] ilen 回调数据长度
 *	@return	
 *	@note 调用CASClient_CreateSession时 传入回调函数地址
 */
typedef int (CALLBACK *DataFuncEx)(int sessionhandle, void* userdata, int datatype, char* pdata, int ilen);

/**	
 *	@brief P2P预链接状态回调
 *	@param[out] sessionhandle 取流句柄
 *	@param[out] p2pstatus 连接状态：1－连接正常，2－连接断开
 *	@return	
 */
typedef int (CALLBACK *P2PStatusEx)(int sessionhandle, int p2pstatus, void* userdata);

/**	
 *	@brief log日志回调函数指针
 *	@param[out] pszLogBuf Log日志
 *	@return	
 */
typedef void (CALLBACK *CASLogCB)(char* pszLogBuf);

/**	
 *	@brief 反向直连状态回调
 *	@param[out] szSerial 
 *	@param[out] iStatus 反向直连状态:0－不支持反向直连, 1－支持反向直连, 2-反向直连服务启动上报
 *	@return	
 */
typedef int (CALLBACK *DirectReverseStatusCBFunc)(const char* szSerial, int iStatus, void* pUserdata);


#ifdef __cplusplus
extern "C" {
#endif


/**
 * @defgroup Init 库初始化相关接口
 * @{
 */


/**	
 *	@brief 库的初始化 
 *	@return	0-成功 -1-失败
 *  @note 加载库后第一个调用
 */
LIBCASCLIENT_API int CALLBACK CASClient_InitLib();

/**	
 *	@brief 库的反初始化
 *	@return	0-成功 -1-失败
 *  @note 卸载库前最后一个调用
 */
LIBCASCLIENT_API int CALLBACK CASClient_FiniLib();

/** @} */ //Init end

/**
 * @defgroup Session 会话相关接口
 * @{
 */


/**	
 *	@brief 创建取流句柄(新)
 *	@param[in] pMsgFunc 消息回调
 *	@param[in] pDataFunc 数据回调
 *	@param[in] userdata 用户数据
 *	@param[in] ipv      网络类型,填写 AF_INET|AF_INET6
 *	@return	>=0-取流句柄 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_CreateSessionEx(MsgFuncEx pMsgFunc, DataFuncEx pDataFunc, void* userdata, int ipv);

/**	
 *	@brief 创建取流句柄
 *	@param[in] pMsgFunc 消息回调
 *	@param[in] pDataFunc 数据回调
 *	@param[in] userdata 用户数据
 *	@return	>=0-取流句柄 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_CreateSession(MsgFuncEx pMsgFunc, DataFuncEx pDataFunc, void* userdata);

/**	
 *	@brief 销毁取流句柄
 *	@param[in] sessionhandle 取流句柄
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_DestroySession(int sessionhandle);

/** @} */ //Session end

/**
 * @defgroup Stream 直连取流相关接口
 * @{
 */


/**	
 *	@brief 开始预览取流
 *	@param[in] sessionhandle 取流句柄
 *	@param[in] stStreamInfo 取流参数
 *	@param[in] iStreamMethod 取流方式 1 -tcp 2-udp(P2P) 5-upnp反向直连
    如果iStreamMethod = 5, stStreamInfo 必备参数：szClientSession,szDevSerial, iChannel, szOperationCode,szKey, szServerIP,iServerPort,iStreamType
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_Start(int sessionhandle, ST_STREAM_INFO stStreamInfo, int iStreamMethod );

/**	
 *	@brief 停止预览取流
 *	@param[in] sessionhandle 取流句柄
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_Stop(int sessionhandle);


/**	
 *	@brief  回放开始取流
 *	@param[in] sessionhandle 取流句柄
 *	@param[in] stStreamInfo 取流参数
 *	@param[in] sStartTime 开始时间  "20130617T102030Z"
 *	@param[in] sStopTime 结束时间	"20130617T202030Z"
 *	@return	0-成功 -1-失败
 *  @note 回放只有直连TCP回放
 */
LIBCASCLIENT_API int CALLBACK CASClient_PlaybackStart(int sessionhandle, ST_STREAM_INFO stStreamInfo, const char *sStartTime, const char *sStopTime);


/**	
 *	@brief  回放开始取流(新)
 *	@param[in] sessionhandle 取流句柄
 *	@param[in] stStreamInfo 取流参数
 *	@param[in] sStartTime 开始时间  "20130617T102030Z"
 *	@param[in] sStopTime 结束时间	"20130617T202030Z"
 *	@return	0-成功 -1-失败
 *  @note 回放只有直连TCP回放
 */
LIBCASCLIENT_API int CALLBACK CASClient_PlaybackStartEx(int sessionhandle, ST_STREAM_INFO stStreamInfo, pVIDEO_INFO pVideoArrary, unsigned int iVideoNum);

/**	
 *	@brief 回放停止
 *	@param[in] sessionhandle 取流句柄
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_PlaybackStop(int sessionhandle);

/**	
 *	@brief  回放暂停
 *	@param[in] sessionhandle 取流句柄
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_PlaybackPause(int sessionhandle);

/**
 *	@brief 回放恢复
 *	@param[in] sessionhandle 取流句柄
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_PlaybackResume(int sessionhandle);

/**	
 *	@brief 回放改变取流速率
 *	@param[in] sessionhandle  取流句柄
 *	@param[in] scale 速率 1(1倍速),2(2倍速),3(1/2倍速),4(4倍速),5(1/4倍速),6(8倍速),7(1/8倍速),8(16倍速),9(1/16倍速) 
 *  @param[in] mode 标记内网直连还是外网直连，以便设备实现不同的快放方式。 0-内网直连，1-外网直连
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_PlaybackChangeRate(int sessionhandle, int scale, int mode);

/**	
 *	@brief 回放改变取流速率(新)
 *	@param[in] sessionhandle  取流句柄
 *	@param[in] scale          速率 1(1倍速),2(2倍速),3(1/2倍速),4(4倍速),5(1/4倍速),6(8倍速),7(1/8倍速),8(16倍速),9(1/16倍速) 
 *  @param[in] mode           标记内网直连还是外网直连，以便设备实现不同的快放方式。 0-内网直连，1-外网直连
 *  @param[in] szCurTime      切换倍速时的osd时间, 格式为20190801T102030Z
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_PlaybackChangeRateEx(int sessionhandle, int scale, int mode,const char* szCurTime);

/**	
 *	@brief 回放改变取流速率(ECDH全链路加密下)
 *	@param[in] sessionhandle  取流句柄
 *	@param[in] scale          速率 1(1倍速),2(2倍速),3(1/2倍速),4(4倍速),5(1/4倍速),6(8倍速),7(1/8倍速),8(16倍速),9(1/16倍速) 
                              默认4倍速以上抽帧
 *  @param[in] szCurTime      切换倍速时的osd时间, 格式为20190801T102030Z
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_PlaybackChangeRateEcdhMode(int sessionhandle, int scale, const char* szCurTime);

/**	
 *  @brief SD卡回放Seek
 *  @param[in] sessionhandle    取流句柄
 *  @param[in] pVideoArrary     录像片段信息
 *  @param[in] iVideoNum        pVideoArrary中片段个数
 *  @param[in] szSeekUuid       seekuuid, 回放seek操作的唯一ID（seek 2.0协议, 只在操作 具备support_seek_v2能力集的设备 时填写）
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_PlaybackSeek(int sessionhandle, pVIDEO_INFO pVideoArrary, unsigned int iVideoNum, const char* szSeekUuid);

/**	
 *  @brief SD卡回放Continue
 *  @param[in] sessionhandle    取流句柄
 *  @param[in] pVideoArrary     录像片段信息
 *  @param[in] iVideoNum        pVideoArrary中片段个数
 *	@return	0-成功 -1-失败

 * 修改日期		修改人		修改原因
 * 20191203    pikongxuan   新增接口
 */
LIBCASCLIENT_API int CALLBACK CASClient_PlaybackContinue(int sessionhandle, pVIDEO_INFO pVideoArrary, unsigned int iVideoNum);

/**	
 *	@brief  直连下载开始
 *	@param[in] sessionhandle 取流句柄
 *	@param[in] stStreamInfo 取流参数
 *	@param[in] sStartTime 开始时间  "20130617T102030Z"
 *	@param[in] sStopTime 结束时间	"20130617T202030Z"
 *  @param[in] mode 标记内网直连还是外网直连，以便设备实现不同的下载速率。 0-内网直连，1-外网直连
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_DirectDownloadStart(int sessionhandle, ST_STREAM_INFO stStreamInfo, const char *sStartTime, const char *sStopTime, int mode);

/**	
 *	@brief 直连下载停止
 *	@param[in] sessionhandle 取流句柄
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_DirectDownloadStop(int sessionhandle);

/** @} */ //Stream end

/**
 * @defgroup Talk 对讲相关接口
 * @{
 */

/**	
 *	@brief 开始语音对讲
 *	@param[in] sessionhandle 对讲句柄
 *	@param[in] stStreamInfo 取流参数
 *	@param[in] iStreamMethod 1-tcp 、 2-udp(P2P)（暂不支持）
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_VoiceTalkStart(int sessionhandle, ST_STREAM_INFO stStreamInfo, int iStreamMethod);

/**	
 *	@brief 开始语音对讲
 *	@param[in] sessionhandle 对讲句柄
 *	@param[in] stStreamInfo 取流参数
 *	@param[in] iStreamMethod 1-tcp 、 2-udp(P2P)（暂不支持）
 *	@param[int/out] pEncodeType 设备音频编码类型 ,0:G722_1 1:G711_MU 2:G711_A 3:G723 4:MP1L2 5:MP2L2 6:G726 7:AAC 99:RAW
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_VoiceTalkStartEx( int sessionhandle, ST_STREAM_INFO stStreamInfo, int iStreamMethod, int *pEncodeType );
/**	
 *	@brief 停止对讲
 *	@param[in] sessionhandle 对讲句柄
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_VoiceTalkStop(int sessionhandle);

/**	
 *	@brief 发送语音数据
 *	@param[in] sessionhandle 取流句柄
 *	@param[in] pVoiceData 语音数据
 *	@param[in] iVoiceDataLen 语音数据长度
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_VoiceTalkInputData(int sessionhandle, const char *pVoiceData, int iVoiceDataLen);

/**	
 *	@brief 发送语音数据
 *	@param[in] sessionhandle 取流句柄
 *	@param[in] pVoiceData 语音数据
 *	@param[in] iVoiceDataLen 语音数据长度
 *	@param[in] iVoiceCmdType 语音类型 0x4100  
 *	#define VOICETALK_BUTTON_PRESS_CMD    0x4200     //  手机端 语音对讲按钮按下
 *  #define VOICETALK_BUTTON_UNPRESS_CMD  0x4201     //  手机端 语音对讲按钮松开
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_VoiceTalkInputDataEx(int sessionhandle, const char *pVoiceData, int iVoiceDataLen, int iVoiceCmdType);

/** @} */ //Talk end

/**
 * @defgroup Cloud 云存储回放相关接口
 * @{
 */

/** @fn LIBCASCLIENT_API int CALLBACK CASClient_CloudReplayStart(int sessionhandle, ST_SERVER_INFO stCloudServer,ST_CLOUDREPLAY_INFO stCloudReplayInfo)
 * @brief 开始云播放
 * @param[in] sessionhandle 取流句柄
 * @param[in] stCloudServer 云存储服务器信息
 * @param[in] stCloudReplayInfo 云存储播放信息
 * @return 0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_CloudReplayStart(int sessionhandle, ST_SERVER_INFO stCloudServer,ST_CLOUDREPLAY_INFO stCloudReplayInfo);


/** @fn LIBCASCLIENT_API int CALLBACK CASClient_CloudSeek(int sessionhandle,const char* szSeekTime)
 * @brief 回放定位，目前只有云回放支持
 * @param[in] sessionhandle 取流句柄
 * @param[in] szSeekTime 偏移时间格式为YYYY-MM-DDTHH:mm:SS
 * @return 0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_CloudSeek(int sessionhandle,const char* szSeekTime);


/** @fn LIBCASCLIENT_API int CALLBACK CASClient_CloudUploadStart(int sessionhandle,ST_SERVER_INFO stCloudServer,ST_CLOUDFILE_INFO stUploadFile)
 * @brief 云存储开始文件上传
 * @param[in] sessionhandle 上传句柄
 * @param[in] stCloudServer 云服务器信息
 * @param[in] stUploadFile 上传文件的信息
 * @return 0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_CloudUploadStart(int sessionhandle,ST_SERVER_INFO stCloudServer,ST_CLOUDFILE_INFO stUploadFile);

/** @fn LIBCASCLIENT_API int CALLBACK CASClient_CloudInputData(int sessionhandle,const char *pUploadData, int iUploadDataLen)
 * @brief 云存储上传写入数据
 * @param[in] sessionhandle 上传句柄
 * @param[in] pUploadData 长传数据
 * @param[in] iUploadDataLen 数据长度
 * @return 0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_CloudInputData(int sessionhandle,const char *pUploadData, int iUploadDataLen);

/** @fn LIBCASCLIENT_API int CALLBACK CASClient_CloudUploadStop(int sessionhandle)
 * @brief 云存储上传停止
 * @param[in] sessionhandle 上传句柄
 * @return 0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_CloudUploadStop(int sessionhandle);


/** @fn LIBCASCLIENT_API int CALLBACK CASClient_CloudDownloadStart(int sessionhandle, ST_SERVER_INFO stCloudServer,ST_CLOUDREPLAY_INFO stCloudReplayInfo)
 * @brief 云存储下载开始
 * @param[in] sessionhandle 下载句柄
 * @param[in] stCloudServer 云服务器信息
 * @param[in] stCloudReplayInfo 上传文件信息
 * @return 0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_CloudDownloadStart(int sessionhandle, ST_SERVER_INFO stCloudServer,ST_CLOUDREPLAY_INFO stCloudReplayInfo);

/** @fn LIBCASCLIENT_API int CALLBACK CASClient_CloudDownloadStop(int sessionhandle)
 * @brief 云存储下载停止
 * @param[in] sessionhandle 下载句柄
 * @return 0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_CloudDownloadStop(int sessionhandle);

/** @fn LIBCASCLIENT_API int CALLBACK CASClient_CloudControl(int sessionhandle, ST_CLOUDREPLAY_INFO stCloudControlInfo)
 * @brief 云存储控制, 信令10s超时, 支持响应快速退出.
 * @param[in] sessionhandle      取流句柄
 * @param[in] stCloudControlInfo 如果暂停功能, 则iPlayType=0, 其他字段无需填写;
                                 如果恢复回放, 则iPlayType=1, 其他字段无需填写;
                                 如果快放, 则iPlayType=3, 再填写iPlaySpeed字段
                                 如果跳转, 则iPlayType=4, 再填写szBeginTime字段
 * @return 0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_CloudControl(int sessionhandle, ST_CLOUDCONTROL_INFO stCloudControlInfo);

/** 
 * @brief 云存储开始取流接口, 涉及回放和下载业务(新)
 * @param[in] sessionhandle   下载句柄
 * @param[in] stCloudServer   云服务器信息
 * @param[in] stCloudPlayInfo 取流信息
 * @return 0-成功 -1-失败

 * 修改日期		修改人		修改原因
 * 20191203    pikongxuan   新增接口
 */
LIBCASCLIENT_API int CALLBACK CASClient_CloudPlayStart(int sessionhandle, ST_SERVER_INFO stCloudServer,ST_CLOUDPLAY_INFO stCloudPlayInfo);


/**
 * @brief 云存储停止取流(新)
 * @param[in] sessionhandle 下载句柄
 * @return 0-成功 -1-失败

 * 修改日期		修改人		修改原因
 * 20191203    pikongxuan   新增接口
 */
LIBCASCLIENT_API int CALLBACK CASClient_CloudPlayStop(int sessionhandle);


/**
 * @brief 云存储控制(新)
 * @param[in] sessionhandle    取流句柄
 * @param[in] stControlInfo    控制信息
 * @return 0-成功 -1-失败

 * 修改日期		修改人		修改原因
 * 20191203    pikongxuan   新增接口
 */
LIBCASCLIENT_API int CALLBACK CASClient_CloudControlEx(int sessionhandle, ST_CLOUDCONTROL_INFO_EX stControlInfo);


/** @} */ //Cloud end


/**
 * @defgroup Operation 设备操作接口
 * @{
 */


/**	
 *	@brief  获取设备的操作码和信令密钥,支持多个序列号一起获取 
 *	@param[in] stServerInfo CAS信息
 *	@param[in] szClientSession 客户端Session
 *	@param[in] szSerialArrary 设备序列号数组
 *	@param[in] iSerialNum 设备序列号数组个数
 *	@param[out] pDevInfoArrary 设备信息数组，回应的设备操作码和信令密钥
 *	@param[out] iDevInfoNum 设备信息数组个数
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_GetDevOperationCode(ST_SERVER_INFO stServerInfo, const char *szClientSession, char *szSerialArrary[], int iSerialNum, ST_DEV_INFO pDevInfoArrary[], int *iDevInfoNum);


/**	
 *	@brief  获取设备的操作码和信令密钥,支持多个序列号一起获取 ,增加客户端的特征码，CAS有验证特征码的过程
 *	@param[in] stServerInfo CAS信息
 *	@param[in] szClientSession 客户端Session
  *	@param[in] szClientHDSign 客户端的硬件特征码
 *	@param[in] szSerialArrary 设备序列号数组
 *	@param[in] iSerialNum 设备序列号数组个数
 *	@param[out] pDevInfoArrary 设备信息数组，回应的设备操作码和信令密钥
 *	@param[out] iDevInfoNum 设备信息数组个数
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_GetDevOperationCodeEx(ST_SERVER_INFO stServerInfo, const char *szClientSession, const char *szClientHDSign, char *szSerialArrary[], int iSerialNum, ST_DEV_INFO pDevInfoArrary[], int *iDevInfoNum);

/**	
 *	@brief  获取设备的操作码和信令密钥,支持多个序列号一起获取 ,增加客户端的特征码，CAS有验证特征码的过程. 增加Token认证逻辑.
 *	@param[in] stServerInfo CAS信息
 *	@param[in] szClientSession 客户端Session
  *	@param[in] szClientHDSign 客户端的硬件特征码
 *	@param[in] szSerialArrary 设备序列号数组
 *	@param[in] iSerialNum 设备序列号数组个数
 *	@param[in] iBusiness     业务类型，值守客户端需要传递
 *	@param[in] szToken       用于权限认证的标识，值守客户端需要传递
 *	@param[out] pDevInfoArrary 设备信息数组，回应的设备操作码和信令密钥
 *	@param[out] iDevInfoNum 设备信息数组个数
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_GetDevOperationCodeTokenCheck( ST_SERVER_INFO stServerInfo, const char *szClientSession, const char *szClientHDSign, char *szSerialArrary[], int iSerialNum, int iBusiness, const char* szToken, ST_DEV_INFO pDevInfoArrary[], int *iDevInfoNum);

/**	
 *	@brief  获取设备的存储密钥
 *	@param[in] stServerInfo CAS信息
 *	@param[in] szClientSession 客户端Session
 *	@param[in] pDevInfo 设备信息 ,操作码、信令密钥
 *	@param[out] iAlgorithm 密钥类型 默认为1：AES128
 *	@param[out] storeKey 存储密钥
 *	@return	0-成功 -1- 失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_GetDevPermanentKey(ST_SERVER_INFO stServerInfo,const char *szClientSession,pDEV_INFO pDevInfo,int* iAlgorithm,char* storeKey );


/**	
 *	@brief  格式化磁盘
 *	@param[in] stServerInfo CAS信息，如果直连则是设备的IP和端口信息
 *	@param[in] szDevSerial 设备序列号
 *	@param[in] szOperationCode 设备操作码
 *	@param[in] iDiskIndex 要格式化的磁盘索引 0代表全部格式化
 *	@param[in] bViaCAS 是否通过CAS透传 true为过CAS，false为直连，暂只支持CAS透传，传入true
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_FormatDisk(ST_SERVER_INFO stServerInfo, const char *szClientSession, ST_DEV_INFO stDevInfo, int iDiskIndex, bool bViaCAS);

/**	
 *	@brief 获取设备存储状态，用于获取格式化进度
 *	@param[in] szClientSession 客户端Session
 *	@param[in] stServerInfo CAS信息，如是直连则是设备IP和端口
 *	@param[in] stDevInfo 设备信息
 *	@param[out] storageStatus 存储状态数组，用于返回设备的存储状态信息
 *	@param[out] pStorageNumber 存储状态数组的个数指针
 *	@param[out] pFormatingRate 格式化进度指针
 *	@param[in] bViaCAS 是否通过CAS透传 true为过CAS，false为直连，暂只支持CAS透传，传入true
 *	@return 0成功 -1失败	
 */
LIBCASCLIENT_API int CALLBACK CASClient_GetDevStorageStatus(const char *szClientSession,ST_SERVER_INFO stServerInfo, ST_DEV_INFO stDevInfo, ST_STORAGE_STATUS storageStatus[],int *pStorageNumber,int *pFormatingRate, bool bViaCAS);


/**	
 *	@brief  搜索录像
 *	@param[in] stServerInfo CAS信息，如果直连则是设备的IP和端口信息
 *	@param[in] szClientSession 客户端Session
 *	@param[in] stDevInfo 设备信息 ,操作码、信令密钥
 *	@param[in] iSearchType 搜索类型，1-按时间 2-按月
 *	@param[in] iChannel 通道号 从1开始
 *	@param[in] iRecordType 录像类型 0xff-全部 0-定时录像 1-移动报警 2-报警触发 3-报警|动测 4-报警&动测 5-命令触发 6-手动录像 7-智能录像，10-PIR报警，11-无线报警，12-呼救报警，13-PIR|无线报警|
 *	@param[in] szStartTime 查询开始时间  20130617T102030Z
 *	@param[in] szStopTime  查询结束时间  20130617T202030Z
 *	@param[out] pFileInfoArray 回应的录像文件数组 
 *	@param[in/out] iFileNum in代码一次要查询的录像文件个数，out代表本次查询到的录像文件个数, 1次最多查询200个录像
 *	@param[out] iFinished 是否查询结束， 0-否 1-是 
 *	@param[in] bViaCAS 是否通过CAS透传 true为过CAS，false为直连
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_SearchRecordFile(ST_SERVER_INFO stServerInfo,  const char *szClientSession, ST_DEV_INFO stDevInfo, int iSearchType, int iChannel,\
                                                 int iRecordType, const char *szStartTime, const char *szStopTime, ST_FINDFILE_V17 pFileInfoArray[], int *iFileNum, int *iFinished, bool bViaCAS);


/**	
 *	@brief  搜索录像，扩展接口
 *	@param[in] stServerInfo CAS信息，如果直连则是设备的IP和端口信息
 *	@param[in] szClientSession 客户端Session
 *	@param[in] stDevInfo 设备信息 ,操作码、信令密钥
 *	@param[in] stSearchRecordInfo 搜索条件结构体
 *	@param[out] pFileInfoArray 回应的录像文件数组 
 *	@param[in/out] iFileNum in代码一次要查询的录像文件个数，out代表本次查询到的录像文件个数, 1次最多查询200个录像(设备SDK目前限制为50个)
 *	@param[out] iFinished 是否查询结束， 0-否 1-是 
 *	@param[in] bViaCAS 是否通过CAS透传 true为过CAS，false为直连
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_SearchRecordFileEx(ST_SERVER_INFO stServerInfo, const char *szClientSession, ST_DEV_INFO stDevInfo, ST_SEARCH_RECORD_INFO stSearchRecordInfo, \
                                                          ST_FINDFILE_V17 pFileInfoArray[], int *iFileNum, int *iFinished, bool bViaCAS);



/**	
 *	@brief 直连查询设备能力集，暂用于判断是否局域网
 *	@param[in] stServerInfo 设备IP和端口
 *	@param[in] stDevInfo 设备信息
 *	@param[in] iTimeout  查询超时时间，单位毫秒，一般内网直连0.5秒，外网1秒
 *	@param[out] pDevBasicInfo 返回的设备能力集
 *	@return	0成功 -1失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_QueryBasicInfo(ST_SERVER_INFO stServerInfo,  ST_DEV_INFO stDevInfo, unsigned int iTimeout, pST_DEV_BASIC_INFO pDevBasicInfo);

/**	
 *	@brief 直连查询设备ftp信息，用于手机获取设备的ftp地址
 *	@param[in] stServerInfo 设备IP和端口
 *	@param[in] stDevInfo 设备信息
 *	@param[out] pDevFtpInfo 返回的设备Ftp信息
 *	@return	0成功 -1失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_GetDevFtpInfo(ST_SERVER_INFO stServerInfo,  ST_DEV_INFO stDevInfo, pST_DEV_FTP_INFO pDevFtpInfo);



/**
 *	@brief 设备布撤防接口，暂只支持CAS透传
 *	@param[in] szClientSession 客户端Session
 *	@param[in] stServerInfo CAS信息，如果直连则是设备的IP和端口信息
 *	@param[in] stDevInfo 设备信息 ,操作码、信令密钥
 *	@param[in] stDevDefenceInfo 布防信息的数组
 *	@param[in] iDefenceInfoNum 数组中的个数
 *	@param[in] bViaCAS 是否通过CAS透传 true为过CAS，false为直连，暂只支持CAS透传，传入true
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_DevDefence(const char *szClientSession, ST_SERVER_INFO stServerInfo, ST_DEV_INFO stDevInfo, ST_DEV_DEFENCE_INFO stDevDefenceInfo[], int iDefenceInfoNum, bool bViaCAS);


/**	
 *	@brief 设备升级接口，暂只支持CAS透传
 *	@param[in] szClientSession 客户端Session
 *	@param[in] stServerInfo CAS信息，如果直连则是设备的IP和端口信息
 *	@param[in] stDevInfo 设备信息 ,操作码、信令密钥
 *	@param[in] bViaCAS 是否通过CAS透传 true为过CAS，false为直连，暂只支持CAS透传，传入true
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_DevUpgrade(const char *szClientSession, ST_SERVER_INFO stServerInfo, ST_DEV_INFO stDevInfo, bool bViaCAS, int nChannel);

/**	
 *	@brief 报警声音配置接口，暂只支持CAS透传
 *	@param[in] szClientSession 客户端Session
 *	@param[in] stServerInfo CAS信息，如果直连则是设备的IP和端口信息
 *	@param[in] stDevInfo 设备信息 ,操作码、信令密钥
 *	@param[in] bViaCAS 是否通过CAS透传 true为过CAS，false为直连，暂只支持CAS透传，传入true
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_SetAlarmSound(const char *szClientSession, ST_SERVER_INFO stServerInfo, ST_DEV_INFO stDevInfo, ST_DEV_ALARM_SOUND_INFO stDevAlarmSoundInfo, bool bViaCAS);

/** @fn LIBCASCLIENT_API int CALLBACK CASClient_SetGlintLight(const char *szClientSession,ST_SERVER_INFO stServerInfo, ST_DEV_INFO stDevInfo, ST_CHAN_GLINTLIGHT_INFO stGlintLightInfo[],int nDevNum, bool bViaCAS)
 * @brief 设置补光灯亮度
 * @param[in] szClientSession 客户端Session
 * @param[in] stServerInfo CAS信息，如果直连则是设备的IP和端口信息
 * @param[in] stDevInfo 设备信息 ,操作码、信令密钥
 * @param[in] stGlintLightInfo 补光相关参数数组
 * @param[in] nDevNum 设备数
 * @param[in] bViaCAS 是否通过CAS透传 true为过CAS，false为直连
 * @return 0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_SetGlintLight( const char *szClientSession,ST_SERVER_INFO stServerInfo, ST_DEV_INFO stDevInfo, ST_CHAN_GLINTLIGHT_INFO stGlintLightInfo[],int nDevNum, bool bViaCAS);


/** @fn LIBCASCLIENT_API int CALLBACK CASClient_QueryGlintLight(const char *szClientSession,ST_SERVER_INFO stServerInfo, ST_DEV_INFO stDevInfo, ST_CHAN_GLINTLIGHT_INFO stGlintLightInfo[],int *pDevNum, bool bViaCAS)
 * @brief 获取补光灯亮度
 * @param[in] szClientSession 客户端Session
 * @param[in] stServerInfo CAS信息，如果直连则是设备的IP和端口信息
 * @param[in] stDevInfo 设备信息 ,操作码、信令密钥
 * @param[out] stGlintLightInfo  补光相关参数数组
 * @param[out] pDevNum 设备数
 * @param[in] bViaCAS 是否通过CAS透传 true为过CAS，false为直连
 * @return  0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_QueryGlintLight( const char *szClientSession,ST_SERVER_INFO stServerInfo, ST_DEV_INFO stDevInfo, ST_CHAN_GLINTLIGHT_INFO stGlintLightInfo[],int *pDevNum, bool bViaCAS);



/** @fn LIBCASCLIENT_API int CALLBACK CASClient_SerchRecordByMounth(ST_SERVER_INFO stServerInfo, const char *szClientSession, ST_DEV_INFO stDevInfo, ST_SEARCH_RECORD_INFO stSearchRecordInfo,char *szDayList, bool bViaCAS)
 * @brief 按月搜索录像
 * @param[in] stServerInfo CAS信息，如果直连则是设备的IP和端口信息
 * @param[in] szClientSession 客户端Session
 * @param[in] stDevInfo 设备信息 ,操作码、信令密钥
 * @param[in] stSearchRecordInfo 搜索条件结构体
 * @param[in] szDayList 月列表，格式如1,2,3
 * @param[in] bViaCAS  是否通过CAS透传 true为过CAS，false为直连
 * @return 0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_SearchRecordByMounth( ST_SERVER_INFO stServerInfo, const char *szClientSession, ST_DEV_INFO stDevInfo, ST_SEARCH_RECORD_INFO stSearchRecordInfo,char *szDayList, bool bViaCAS );

/** @fn LIBCASCLIENT_API int CALLBACK CASClient_CollectDevLogInfo(const char *szClientSession,ST_SERVER_INFO stServerInfo, ST_DEV_INFO stDevInfo, ST_CHAN_GLINTLIGHT_INFO stGlintLightInfo[],int *pDevNum, bool bViaCAS)
 * @brief 获取补光灯亮度
 * @param[in] szClientSession 客户端Session
 * @param[in] stServerInfo CAS信息，如果直连则是设备的IP和端口信息
 * @param[in] stDevInfo 设备信息 ,操作码、信令密钥
 * @param[in] stCollectLogInfo  收集服务器的信息
 * @param[in] bViaCAS 是否通过CAS透传 true为过CAS，false为直连；现只支持CAS透传
 * @return  0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_CollectDevLogInfo( const char *szClientSession,ST_SERVER_INFO stServerInfo, ST_DEV_INFO stDevInfo, ST_COLLECTLOG_INFO stCollectLogInfo, bool bViaCAS);

/** @fn LIBCASCLIENT_API CASClient_PtzCtrl
 * @brief 云台控制
 * @param[in] szClientSession 客户端Session
 * @param[in] stServerInfo CAS信息，如果直连则是设备的IP和端口信息
 * @param[in] stDevInfo 设备信息 ,操作码、信令密钥
 * @param[in] stPtzInfo 云台控制信息
 * @param[in] bViaCAS 是否通过CAS透传 true为过CAS，false为直连；现只支持CAS透传
 * @return  0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_PtzCtrl( const char *szClientSession,ST_SERVER_INFO stServerInfo, ST_DEV_INFO stDevInfo, ST_PTZ_INFO stPtzInfo, bool bViaCAS);


/** @fn LIBCASCLIENT_API CASClient_PtzPresetCtrl
 * @brief 云台预置点控制
 * @param[in] szClientSession 客户端Session
 * @param[in] stServerInfo CAS信息，如果直连则是设备的IP和端口信息
 * @param[in] stDevInfo 设备信息 ,操作码、信令密钥
 * @param[in] stPtzPresetInfo  预置点控制信息
 * @param[in] bViaCAS 是否通过CAS透传 true为过CAS，false为直连；现只支持CAS透传
 * @return  0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_PtzPresetCtrl( const char *szClientSession,ST_SERVER_INFO stServerInfo, ST_DEV_INFO stDevInfo, ST_PTZ_INFO stPtzPresetInfo, bool bViaCAS);


/** @fn LIBCASCLIENT_API CASClient_DisplayCtrl
 * @brief 图像显示控制
 * @param[in] szClientSession 客户端Session
 * @param[in] stServerInfo CAS信息，如果直连则是设备的IP和端口信息
 * @param[in] stDevInfo 设备信息 ,操作码、信令密钥
 * @param[in] stDisplayInfo 显示设备信息
 * @param[in] bViaCAS 是否通过CAS透传 true为过CAS，false为直连；现只支持CAS透传
 * @return  0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_DisplayCtrl( const char *szClientSession,ST_SERVER_INFO stServerInfo, ST_DEV_INFO stDevInfo, ST_DISPLAY_INFO stDisplayInfo, bool bViaCAS);



/** @fn LIBCASCLIENT_API CASClient_CapturePicture
 * @brief 设备抓图接口
 * @param[in] szClientSession 客户端Session
 * @param[in] stServerInfo CAS信息，如果直连则是设备的IP和端口信息
 * @param[in] stDevInfo 设备信息 ,操作码、信令密钥
 * @param[in/out] pCapturePicInfo  抓图信息，图片也通过该参数传出
 * @param[in] bViaCAS 是否通过CAS透传 true为过CAS，false为直连；
 * @return  0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_CapturePicture( const char *szClientSession,ST_SERVER_INFO stServerInfo, ST_DEV_INFO stDevInfo, pST_CAPTURE_PIC_INFO pCapturePicInfo, bool bViaCAS);


/** @} */ //Messgae end

/**
 * @defgroup PreConnect P2P相关接口
 * @{
 */

/**
 *  @brief      [设置整形类型的全局配置信息]
 *	@param[in]	iType           [配置类型]
 *	@param[in]	iValue          [配置数值]
 *	@return	-1: iType or iValue is invalid, or return 0
 */
LIBCASCLIENT_API int CALLBACK CASClient_SetIntConfigInfo(CAS_CONFIG_TYPE iType, const int iValue);


 /**
 *  @brief      [设置字符类型的全局配置信息]
 *	@param[in]	iType           [配置类型]
 *	@param[in]	szValue         [配置数值]
 *	@return	-1: iType or iValue is invalid, or return 0
 */
LIBCASCLIENT_API int CALLBACK CASClient_SetStringConfigInfo(CAS_CONFIG_TYPE iType, const char* szValue);

/**
 *  @brief      [设置设备整形类型的P2P优选配置信息]
 *	@param[in]	iType           [配置类型]
 *	@param[in]	iValue          [配置数值]
 *	@return	-1: iType or iValue is invalid, or return 0
 */
LIBCASCLIENT_API int CALLBACK CASClient_SetIntP2PSelectInfo(const char* pszSerial , CAS_P2P_SELECTINFO_TYPE iType, const int iValue);


/**
 * \brief 设置P2P V3配置信息
 *
 * \param keyInfo [in] Enrypt/decrypt key information
 *
 * \return 
 *
 * \attention This fuction should be called before P2P_StartService().
              If parameter is changed outside, it need set again by this function.
 */
LIBCASCLIENT_API int CALLBACK CASClient_SetP2PV3ConfigInfo(const pST_P2P_KEYINFO keyInfo);


/**
 * \brief 设置客户端公私钥信息
 *
 * \param pEncryptInfo [in] public/private key information
 *
 * \return 
 *
 * \attention This fuction use for ecdh cryption module
 */
LIBCASCLIENT_API int CALLBACK CASClient_SetClientPublicAndPrivateKey(const pST_ECDH_ENCRYPT_INFO pEncryptInfo);


/** 
* @brief        [预建立P2P预链接]
* @author 	    pikongxuan
* @param[in]	sessionhandle       [客户端session]
* @param[in]	stSetupInfo         [外部根据能力级 选择P2P打洞的方式, 如果P2P_V2版本, stV2信息需填写, 如果P2P_V3版本, stV3信息需要填写.
* @return 	    [0 成功，非0 失败]
* @exceptions
* @see	
*/
LIBCASCLIENT_API int CALLBACK CASClient_SetupPreConnection(int iSession, const pST_P2PSETUP_INFO pstSetupInfo);

/** 
* @brief        [停止预链接。该接口不会立即生效，只是通过停止向设备发送心跳的方式来结束预链接。
                真正预链接断开是需要设备端在确认10秒内没有收到设备的心跳才会断开预链接。]
* @author 	    zhanglei
* @param[in]    iSession             [客户端session]
* @return 	    [0 成功，-1 失败]
* @exceptions
* @see	
*/ 
LIBCASCLIENT_API int CALLBACK CASClient_StopPreconnection(int iSession);

/** 
* @brief        [P2P打洞通道取流]
* @author 	    pikongxuan
* @param[in]	iSession            [客户端session]
* @param[in]    stPlayInfo          [取流所需参数, ver为P2P_V2时, stV2必填, ver为P2P_V3时, stV3必填]
* @return 	    [0 成功，非0 失败]   如果返回值非0, 理应调用StopP2PPlay保证设备停止发流.
* @exceptions   
* @see	
*/ 
LIBCASCLIENT_API int CALLBACK CASClient_StartP2PPlay(const int iSession, const pST_P2PPLAY_INFO pstPlayInfo);

/**	
 *	@brief 开始语音对讲,通过P2P通道
 *  @param[in]	iSession            [客户端session]
 *  @param[in]  stPlayInfo          [取流所需参数]
 *	@param[out] pEncodeType 设备音频编码类型 ,0:G722_1 1:G711_MU 2:G711_A 3:G723 4:MP1L2 5:MP2L2 6:G726 7:AAC 99:RAW
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_StartP2PVoiceTalk(const int iSession, const pST_P2PPLAY_INFOV3 pstPlayInfo, int *pEncodeType);

/** 
* @brief        [停止P2P打洞通道取流]
* @author 	    pikongxuan
* @param[in]	iSession            [客户端session]
* @return 	    [0 成功，非0 失败]
* @exceptions
* @see	
*/ 
LIBCASCLIENT_API int CALLBACK CASClient_StopP2PPlay(int iSession);

/** 
* @brief        [通过P2P发送语音数据]
* @author 	    pikongxuan
* @param[in]	iSession            [客户端session]
* @param[in]    pData               [数据]
* @param[out]   iDataLen            [数据长度]
* @param[in] iVoiceCmdType 语音类型 0x4100  
*  #define VOICETALK_BUTTON_PRESS_CMD    0x4200     //  手机端 语音对讲按钮按下
*  #define VOICETALK_BUTTON_UNPRESS_CMD  0x4201     //  手机端 语音对讲按钮松开
* @return 	    [0 成功，非0 失败]
* @exceptions
* @see	
*/ 
LIBCASCLIENT_API int CALLBACK CASClient_SendVoiceTalkByP2P(const int iSession, const char *pData, const int iDataLen, int iVoiceCmdType);

/**
 * @brief      [P2P回放控制接口]
 * @param[in]  iSession            [客户端session]
 * @param[in]  pControlInfo        [控制信令参数]
 * @return     [0成功，-1失败]
 
 * 修改日期		修改人		修改原因
 * 20191203    pikongxuan   支持Seek和Continue
 */
LIBCASCLIENT_API int CALLBACK CASClient_P2PPlaybackControl(int iSession, const pCAS_P2P_PLAYBACK_CONTROL_INFO pControlInfo);

/** 
* @brief        [通过P2P通道透传信令]
* @author 	    pikongxuan
* @param[in]	iSession            [客户端session]
* @param[in]    pstTransReq         [透传传入参数]
* @param[out]   pStTransRsp         [透传传出参数]
* @return 	    [0 成功，非0 失败]
* @exceptions
* @see	
*/ 
LIBCASCLIENT_API int CALLBACK CASClient_TransparentByP2P(const int iSession, const pST_P2PTRANSREQ_INFO pstTransReq, pST_P2PTRANSRSP_INFO pStTransRsp);


/** 
* @brief        [检测预链接是否建立成功]
* @author 	    zhanglei
* @param[in]	iSession            [客户端session]
* @return 	    [0 成功，非0 失败]
* @exceptions
* @see	
*/ 
LIBCASCLIENT_API bool CALLBACK CASClient_isPreConnectionSucceed(const char* pszDevSerial, int iChannel);

/** 
* @brief        [检测当前是否正在尝试打洞]
* @author 	    zhanglei
* @param[in]	int iSession        [客户端session]
* @return 	    [true 是，false 不是]
* @exceptions
* @see	
*/ 
LIBCASCLIENT_API bool CALLBACK CASClient_isPrePunching(const char* pszDevSerial, int iChannel);

/** 
* @brief        [设置P2P预链接状态变化回调函数
*               外层回调函数被调用时，如果需要重新做预链接，需要启用新的线程来执行预链接操作，否则会导致崩溃
*               该接口要放在打洞成功后设置，否则会设置失效。该回调函数现只通知状态码4即预链接断开，上层应用
*               收到该回调时需要立即停止和预链接相关的业务，比如预览，并立即重新建立预链接]
* @author 	    zhanglei
* @param[in]	int iSession        [客户端session]
* @param[in]    stcb                [回调函数地址]
* @return 	    [true 成功，false 失败]
* @exceptions
* @see	
*/ 
LIBCASCLIENT_API bool CALLBACK CASClient_SetP2PStatusChangeCallBack(int iSession, P2PStatusEx stcb, void* pUserData);


/**
 * @brief       [获取预链接数据上报信息]
 * @author      zhanglei
 * @param[in]   iSession   [客户端会话id]
 * @param[out]  info       [预链接统计信息]
 * @return      [0成功，-1失败]
 */
LIBCASCLIENT_API int CALLBACK CASClient_GetStatisticInformation(int iSession, PRE_CONN_STAT_INFO* info);

/**
 * @brief       [获取预链接取流数据上报信息，在调用P2P取流接口返回后调用该接口获取相关信息]
 * @author      pikongxuan
 * @param[in]   iSession   [客户端会话id]
 * @param[out]  info       [P2P取流统计信息]
 * @return      [0成功，-1失败]
 */
LIBCASCLIENT_API int CALLBACK CASClient_GetPreviewStatInformation(int iSession, ST_P2P_STREAM_STAT_INFO* info);

/**
 * @brief       [获取预数据上报信息，暂时留给工作室使用]
 * @author      zhanglei
 * @param[in]   pszDevSerial   [设备序列号]
 * @param[in]   iChannel       [通道号]
 * @param[out]  info           [预链接统计信息]
 * @return      [0成功，-1失败]
 */
LIBCASCLIENT_API int CALLBACK CASClient_GetStatisticInformationEx(const char* pszDevSerial,const int iChannel, PRE_CONN_STAT_INFO* info);

/**
 * @brief       [设置P2P优选信息, App登录时设置一次, 在灰度配置接口设置之后调用]
 * @author      pikongxuan
 * @param[in]   szInfo         [优选信息]
 * @param[in]   iLen           [szInfo长度]
 * @return      [0成功，-1失败]
 */
LIBCASCLIENT_API int CALLBACK CASClient_SetP2PSelectInfo(const char* szInfo, const int iLen);

/**
 * @brief       [设置P2P优选信息, App登出时设置一次]
 * @author      pikongxuan
 * @param[in]   pBuf           [优选信息]
 * @param[in]   iBufLen        [pBuf的长度]
 * @return      [0成功，-1失败]
 */
LIBCASCLIENT_API int CALLBACK CASClient_GetP2PSelectInfo(void** pBuf, int* iBufLen);

/**
 * @brief       [设备优选接口]
 * @author      pikongxuan
 * @param[in]   szDevInArrary    [输入一组设备]
 * @param[in]   stSelectOpt      [优选传入参数, iDevNum为szDevInArra]
 * @param[in]   szDevOutArrary   [输出排序后的设备列表, 数组大小为返回值]
 * @return      [-1失败，0未排序, >0排序设备个数]
 */
LIBCASCLIENT_API int CALLBACK CASClient_SelectP2PDevices(const char *szDevInArrary[], CAS_SELECT_OPT stSelectOpt, ST_DEV_OUT_INFO stDevOutArrary[]);

/** 
 * @brief       [销毁SDK分配的内存]
 * @author      pikongxuan
 * @param[in]   pBuf         [SDK分配的内存]
 * @return      [0成功，-1失败]
 */
LIBCASCLIENT_API int CALLBACK CASClient_FreeBuf(void* pBuf);


/** @} */ //PreConnect end

/**
 * @defgroup DirectReverse 反向直连相关接口
 * @{
 */

/**	
 *	@brief      [开启反向直连服务]
 *	@param[in]  szStunIp		[Stun服务器IP地址, 如果为空字符串, 默认为hzstun.ys7.com]
 *	@param[in]  iStunPort	    [Stun服务器端口, 如果为0, 默认为6002]
 *	@param[in]  iCheckPeriod    [检测UPnP映射是否有效周期，以及通知设备反向直连检测周期, 单位为s, 默认600s]
 *	@param[in]  cbStatus        [反向直连检测状态回调]
 *	@param[in]  pUserData       [cbStatus回调的userdata]
 *	@return	    [0-成功 -1-失败]
 *	@see	    [程序启动的时候调用(异步操作)]
 */
LIBCASCLIENT_API int CALLBACK CASClient_StartServerOfReverseDirect(const char* szStunDomain, const int iStunPort, const int iCheckPeriod, DirectReverseStatusCBFunc cbStatus, void* pUserData);
/**	
 *	@brief      [停止反向直连服务]
 *	@return	    [0-成功 -1-失败]
 *	@see	    [程序退出的时候调用(异步操作)]
 */
LIBCASCLIENT_API int CALLBACK CASClient_StopServerOfReverseDirect();
/**	
 *	@brief      [通知设备尝试反向直连客户端]
 *  @param[in]  stStreamInfo      [必填参数为szClientSession,szDevSerial,szOperationCode,szKey
                                        szServerIP,iServerPort, szHdSign; ServerIP暂不支持域名]
 *	@return	    [0-成功 -1-失败]
 *  @see	    [针对设备做检测，多通道设备只需要检测一次（由调用者保证）, 是否可以直连的状态有libcasclient保存；
                设备列表刷新的时候，需要重现调用一遍。]
 */
LIBCASCLIENT_API int CALLBACK CASClient_CheckDeviceDirectClient(ST_STREAM_INFO stStreamInfo);

/**	
 *	@brief      [判断设备是否支持反向直连]
 *	@param[in]  szSerial        [设备序列号]
 *	@return	    [true-支持 false-不支持]
 */
LIBCASCLIENT_API bool CALLBACK CASClient_CanDeviceDirectClient(const char* szSerial);

/**	
 *	@brief      [获取设备状态信息]
 *	@param[in]  eStreamMethod   [取流方式]
 *	@param[in]  szSerial        [设备序列号]
 *	@param[out] stDevStatInfo   [设备状态信息]
 *	@return	    [0-获取成功 -1-获取失败]
 */
LIBCASCLIENT_API int CALLBACK CASClient_GetDevStatusInfo(const CASCLIENT_STREAM_METHOD eStreamMethod, \
                                                      const char* szSerial, CASCLIENT_DEV_STATUS_INFO* stDevStatInfo);

/**	
 *	@brief      [清理反向直连的设备信息, 如果szSerial为NULL， 则清理整个设备列表信息]
 *	@param[in]  szSerial        [设备序列号]
 *	@return	    [0-成功 -1-失败]
 *	@see	    [一般是用户退出的时候调用, 或者设备下线]
 */
LIBCASCLIENT_API int CALLBACK CASClient_ClearDeviceListOfReverseDirect(const char* szSerial);

/**	
 *	@brief      [反向直连服务器启动上报信息]
 *	@param[out] szSerial        [设备序列号]
 *	@return	    [0-成功 -1-失败]
 *	@see	    [一般是用户退出的时候调用, 或者设备下线]
 */
LIBCASCLIENT_API int CALLBACK CASClient_GetStatInfoOfReverseDirect(ReverseDirect_STAT_INFO* info);

/** @} */ //DirectReverse end


/**
 * @defgroup Util 通用接口
 * @{
 */

/**	
 *	@brief  [获取SDK版本信息]
 *	@return	[版本信息]
 *	@see	
 */
LIBCASCLIENT_API char* CALLBACK CASClient_GetVersion();

/**	
 *	@brief  [返回错误码]
 *	@return	[错误码]
 *  @note   [错误码参见libCASClient_Error.h]
 */
LIBCASCLIENT_API int CALLBACK CASClient_GetLastError();

/** @fn
 * @brief 获取libCAS详细错误信息，目前只针对透传信令有效
 * @param[out] error_id 库中详细错误号
 * @param[out] ssl_error ssl错误号
 * @param[out] sys_error 系统错误号
 * @return  0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_GetLastDetailError( int *error_id,int *ssl_error,int *sys_error );

/**	
 *	@brief      [设置库使用的客户端类型]
 *	@param[in]  casLog          [cas日志是否开启]
 *	@param[in]  sslLog          [ssl日志是否开启]
 *	@return	    [0-成功 -1-失败]
 *  @note
 */
LIBCASCLIENT_API int CALLBACK CASClient_setLogPrint(bool casLog, bool sslLog);

/**	
 *	@brief      [消息接口定义]
 *	@param[out] iMsgType 消息类型 CASCLIENT_MSG_TYPE
 *	@param[out] pParam   数据上报内容
 *	@return	
 */
typedef void (CALLBACK *CASClient_MessageHandler)(unsigned int iMsgType, const char *pParam, void *pUser);

/** 
 *  @brief  设置P2P服务器的信息，同时把客户端的nat类型也设置进来
 *	@param	ST_P2PSERVER_INFO 参考定义
 *	@return	
 */
LIBCASCLIENT_API int CALLBACK CASClient_SetMessageHandler(CASClient_MessageHandler fMsgHandler, void *pUser);

/** 
* @brief    获取客户端外网地址和端口 
* @author 	zhanglei
* @param	const char* pszServerIP STUN服务器地址
* @param	int iServerPort STUN服务器端口 
* @param[out]	char* pszClientIP 客户端外网IP
* @param[out]	int* pClientPort 客户端外网端口
* @return 	LIBCASCLIENT_API int CALLBACK 0 成功，非0 失败
* @exceptions
* @see	
*/
LIBCASCLIENT_API int CALLBACK CASClient_QueryInternetAddress(const char* pszServerIP, int iServerPort, char* pszClientIP, int* pClientPort);

/**	
 *	@brief      [用于搜集线上端口映射的数据，为端口预测算法采集数据分析]
 *	@param[in]  pszServerIP        [用于查询外网服务器地址]
 *	@param[in]  iServerPort        [用于查询外网服务器端口]
 *	@param[out]  ilocalPort         [指定绑定的本地端口]
 *	@param[out]  pszClientIP        [查询到的本地外网IP]
 *	@param[out]  pClientPort        [查询到的本地外网端口]
 *	@return	    [0-成功 -1-失败]
 */
LIBCASCLIENT_API int CALLBACK CASClient_QueryInternetAddressEx(const char* pszServerIP, int iServerPort, int* plocalPort, char* pszClientIP, int* pClientPort);

/** 
* @brief    设置log回调函数接口，暂时针对IOS端无法输出libCASClient中的log而添加
*           该接口是设置库中的一个全局函数指针，跟取流对象无关，无需Session参数，最好在调用libCASClient库任意接口之前设置
* @author 	zhanglei
* @param	CASLogCB cb 回调函数指针
* @return 	N/A
* @exceptions
* @see	
*/ 
LIBCASCLIENT_API void CALLBACK CASClient_SetLogCallBack(CASLogCB cb);
    

/** 
* @brief    查询多出口网络环境下多个外网的出口地址
* @author 	zhanglei
* @param	vecOuts 查出的地址塞入vecOuts
* @return 	N/A
* @exceptions
* @see	
*/ 
LIBCASCLIENT_API void CALLBACK CASClient_QueryMultiOutAddresses(char* pszOuts, int iOutlen);

/** @} */ //Util end

/**
 * @defgroup tranfer 透传信令接口
 *	vtdu、tts专用，只用于透传信令，不作数据收发
 * @{
 */


/**	
 *	@brief VTDU调用，转发预览请求
 *	@param[in] szClientSession 客户端Session
 *	@param[in] stServerInfo CAS信息，如果直连则是设备的IP和端口信息
 *	@param[in] stDevInfo 设备信息，操作码、信令key、设备序列号
 *	@param[in] iChannel 通道号 1开始
 *	@param[in] iStreamType 主子码流 1-主 2-子
 *	@param[in] iTransProto 传输协议 TCP
 *	@param[in] szRecvIP 接收码流IP
 *	@param[in] iRecvPort 接收码流端口
 *	@param[in] bIsEncrypt 码流是否加密
 *	@param[out] szHead 回应流头
 *	@param[out] iHeadLen 流头长度
 *	@param[out] iSession 取流Session
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_InviteRealStreamStart(const char *szClientSession, ST_SERVER_INFO stServerInfo, ST_DEV_INFO stDevInfo, int iChannel, int iStreamType, int iTransProto,\
                                                               const char *szRecvIP, int iRecvPort, bool bIsEncrypt, char *szHead, int *iHeadLen, int *iSession);

/**	
 *	@brief VTDU调用，转发预览停止取流
 *	@param[in] szClientSession 客户端Session
 *	@param[in] stServerInfo CAS信息，如果直连则是设备的IP和端口信息
 *	@param[in] stDevInfo 设备信息，，操作码、信令key、设备序列号
 *	@param[in] iSeesion 取流Session
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_InviteRealStreamStop(const char *szClientSession, ST_SERVER_INFO stServerInfo,  ST_DEV_INFO stDevInfo, int iSession);

/**	
 *	@brief VTDU调用，回放时的改变码流倍速
 *	@param[in] szClientSession 客户端Session
 *	@param[in] stServerInfo CAS信息，如果直连则是设备的IP和端口信息
 *	@param[in] stDevInfo 设备信息，操作码、信令key、设备序列号
 *	@param[in] iSession 取流Session
 *	@param[in] iRate 1：正常倍速（默认） 2：2倍 3 : 1/2倍 4：4倍 5：1/4倍 6：8倍 7：1/8倍
 *	@return		0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_RecordStreamCtrl(const char *szClientSession, ST_SERVER_INFO stServerInfo, ST_DEV_INFO stDevInfo, int iSession, int iRate);


/**	
 *	@brief VTDU调用，转发预览请求
 *	@param[in] szClientSession 客户端Session
 *	@param[in] szTokenUrl 验证token的url Preview: valtoken2?token=%s&sn=%s&cno=%d        DemoPoint: valdemo?sn=%s&cno=%d
 *	@param[in] stServerInfo CAS信息，如果直连则是设备的IP和端口信息
 *	@param[in/out] stDevInfo 设备信息，输入序列号，输出操作码、信令key
 *	@param[in] iChannel 通道号 1开始
 *	@param[in] iStreamType 主子码流 1-主 2-子
 *	@param[in] iTransProto 传输协议 TCP
 *	@param[in] szRecvIP 接收码流IP
 *	@param[in] iRecvPort 接收码流端口
 *	@param[in] bIsEncrypt 码流是否加密
 *	@param[in] szInviteType "Preview","Playback","Talk","DemoPoint"
 *	@param[out] szHead 回应流头
 *	@param[out] iHeadLen 流头长度
 *	@param[out] iSession 取流Session
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_VerifyAndInviteStreamStart(const char *szClientSession, const char *szTokenUrl, pSERVER_INFO pServerInfo, pDEV_INFO pDevInfo, int iChannel, int iStreamType, int iTransProto,\
                                                               const char *szRecvIP, int iRecvPort, bool bIsEncrypt, const char *szInviteType, char *szHead, int *iHeadLen, int *iSession);


/**	
*	@brief VTDU调用，转发预览请求(增加参数)
*	@param[in] szClientSession 客户端Session
*	@param[in] iBusType  业务类型 
*	@param[in] szTokenUrl 验证token的url Preview: valtoken2?token=%s&sn=%s&cno=%d        DemoPoint: valdemo?sn=%s&cno=%d
*	@param[in] stServerInfo CAS信息，如果直连则是设备的IP和端口信息
*	@param[in/out] stDevInfo 设备信息，输入序列号，输出操作码、信令key
*	@param[in] iChannel 通道号 1开始
*	@param[in] iStreamType 主子码流 1-主 2-子
*	@param[in] iTransProto 传输协议 TCP
*	@param[in] szRecvIP 接收码流IP
*	@param[in] iRecvPort 接收码流端口
*	@param[in] bIsEncrypt 码流是否加密
*	@param[in] szInviteType "Preview","Playback","Talk","DemoPoint"
*	@param[out] szHead 回应流头
*	@param[out] iHeadLen 流头长度
*	@param[out] iSession 取流Session
*	@return	0-成功 -1-失败
*/
LIBCASCLIENT_API int CALLBACK CASClient_VerifyAndInviteStreamStartEx(const char *szClientSession, int iBusType, const char *szTokenUrl, pSERVER_INFO pServerInfo, pDEV_INFO pDevInfo, int iChannel, int iStreamType, int iTransProto,\
                                                                   const char *szRecvIP, int iRecvPort, bool bIsEncrypt, const char *szInviteType, char *szHead, int *iHeadLen, int *iSession);

/**	
 *	@brief VTDU调用，转发回放请求
 *	@param[in] szClientSession 客户端Session
 *	@param[in] szTokenUrl 验证token的url
 *	@param[in] stServerInfo CAS信息
 *	@param[in/out] stDevInfo 设备信息，输入序列号，输出操作码、信令key
 *	@param[in] iChannel 通道号 1开始
 *	@param[in] iTTransSwitch 是否转码 0-OFF，1-ON
 *	@param[in] iQuailty 码流质量
 *	@param[in] szRecvIP 接收码流IP
 *	@param[in] iRecvPort 接收码流端口
 *	@param[in] szPermanentCodeKey 码流加密Key，如不加密设为空""
 *	@param[in] szStartTime 回放开始时间 20130617T102030Z
 *	@param[in] szStopTime 回放结束时间 20130617T102030Z
 *	@param[out] iSession 取流Session
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_VerifyAndRecordStreamStart(const char *szClientSession, const char *szTokenUrl, pSERVER_INFO pServerInfo, pDEV_INFO pDevInfo, int iChannel, int iTTransSwitch, int iQuailty,\
                                                                   const char *szRecvIP, int iRecvPort,const char *szPermanentCodeKey, const char *szStartTime, const char *szStopTime, int *iSession);

/**	
*	@brief VTDU调用，转发回放请求(增加参数)
*	@param[in] szClientSession 客户端Session
*	@param[in] iBusType  业务类型 
*	@param[in] szTokenUrl 验证token的url
*	@param[in] stServerInfo CAS信息
*	@param[in/out] stDevInfo 设备信息，输入序列号，输出操作码、信令key
*	@param[in] iChannel 通道号 1开始
*	@param[in] iTTransSwitch 是否转码 0-OFF，1-ON
*	@param[in] iQuailty 码流质量
*	@param[in] szRecvIP 接收码流IP
*	@param[in] iRecvPort 接收码流端口
*	@param[in] szPermanentCodeKey 码流加密Key，如不加密设为空""
*	@param[in] szStartTime 回放开始时间 20130617T102030Z
*	@param[in] szStopTime 回放结束时间 20130617T102030Z
*	@param[out] iSession 取流Session
*	@return	0-成功 -1-失败
*/
LIBCASCLIENT_API int CALLBACK CASClient_VerifyAndRecordStreamStartEx(const char *szClientSession, int iBusType, const char *szTokenUrl, pSERVER_INFO pServerInfo, pDEV_INFO pDevInfo, int iChannel, int iTTransSwitch, int iQuailty,\
                                                                   const char *szRecvIP, int iRecvPort,const char *szPermanentCodeKey, const char *szStartTime, const char *szStopTime, int *iSession);

/**	
 *	@brief TTS调用，转发对讲请求
 *	@param[in] szClientSession 客户端Session
  *	@param[in] szTokenUrl 验证token的url
 *	@param[in] stServerInfo CAS信息
 *	@param[in/out] stDevInfo 设备信息，输入序列号，输出操作码、信令key
 *	@param[in] iChannel 对讲通道
 *	@param[in] iEncodeType 音频编码类型，0-G722,1-G711
 *	@param[in] szRecvIP 接收音码IP
 *	@param[in] iRecvPort 接收音频端口
 *	@param[out] iSession 对讲Session
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_VerifyAndTalkStart(const char *szClientSession, const char *szTokenUrl, pSERVER_INFO pServerInfo, pDEV_INFO pDevInfo, int iChannel, int iEncodeType, \
                                                           const char *szRecvIP, int iRecvPort,int *iSession);

/**	
 *	@brief TTS调用，转发对讲请求
 *	@param[in] szClientSession 客户端Session
  *	@param[in] szTokenUrl 验证token的url
 *	@param[in] stServerInfo CAS信息
 *	@param[in/out] stDevInfo 设备信息，输入序列号，输出操作码、信令key
 *	@param[in] iChannel 对讲通道
 *	@param[in] szRecvIP 接收音码IP
 *	@param[in] iRecvPort 接收音频端口
 *	@param[out] iSession 对讲Session
 *	@param[int/out] iEncodeType 音频编码类型，0-G722,1-G711 7-AAC
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_VerifyAndTalkStartEx( const char *szClientSession, const char *szTokenUrl, pSERVER_INFO pServerInfo, pDEV_INFO pDevInfo, int iChannel, \
                                                             const char *szRecvIP, int iRecvPort,int *iSession ,int *iEncodeType);



/**	
 *	@brief 强制I帧请求
 *	@param[in] szClientSession 客户端Session 暂不使用
 *	@param[in] stServerInfo CAS信息
 *	@param[in] stDevInfo 设备信息，输入序列号，输出操作码、信令key
 *	@param[in] iChannel 通道号
 *	@param[in] iStreamType 主子码流
 *  @param[in] bViaCAS 是否通过CAS透传 true为过CAS，false为直连；vtdu调用的话使用true
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_ForceIFrame(const char *szClientSession, pSERVER_INFO pServerInfo, pDEV_INFO pDevInfo, int iChannel, int iStreamType, bool bViaCAS);

/**
 * [CASClient_SetSwitchEnable 设置开关]
 * @param  szClientSession [客户端session]
 * @param  stServerInfo    [服务器信息]
 * @param  stDevInfo       [设备信息]
 * @param  iChannel        [通道号，0设备本身，通道从1开始]
 * @param  iEnable         [状态，0关闭，1打开]
 * @param  enType          [操作类型]
 * @param  bViaCAS         [是否透传]
 * @return                 [0成功，-1失败]

 * 修改日期		修改人		修改原因
 * 2014/09/29	peter.chou	新增接口
 */
LIBCASCLIENT_API int CALLBACK CASClient_SetSwitchEnable(const char* szClientSession, ST_SERVER_INFO stServerInfo, ST_DEV_INFO stDevInfo, int iChannel, int iEnable, EN_SWITCH_OPERATE_TYPE enType, bool bViaCAS);

/**	
 *	@brief  向设备添加探测器
 *	@param[in] szClientSession [客户端session]
 *	@param[in] stServerInfo [服务器信息]
 *	@param[in] stDevInfo [设备信息]
 *	@param[in] szDetSerial [探测器序列号]
 *	@param[in] iChannel [通道号，0设备本身，通道从1开始]
 *	@param[in] szType [类型 CS-T1-A/12M]
 *	@param[in] szSubType [子类型 T001]
  *	@param[in] szCode [验证码]
 *	@param[in] bViaCAS [是否通过CAS透传 true为过CAS，false为直连，暂只支持CAS透传，传入true]
 *	@return	0-成功 -1-失败
 *
 * 修改日期		修改人		修改原因
 * 2014/10/21	feichenxi	新增接口
 * 2014/10/23	feichenxi	新增参数szDetSerial
 */
LIBCASCLIENT_API int CALLBACK CASClient_AddDetector(const char *szClientSession, ST_SERVER_INFO stServerInfo, ST_DEV_INFO stDevInfo, const char *szDetSerial, int iChannel, \
                                                    const char *szType, const char *szSubType, const char *szCode, bool bViaCAS);

/**	
 *	@brief  向设备删除探测器
 *	@param[in] szClientSession [客户端session]
 *	@param[in] stServerInfo [服务器信息]
 *	@param[in] stDevInfo [设备信息]
 *	@param[in] szDetSerial [探测器序列号]
 *	@param[in] iChannel [通道号，0设备本身，通道从1开始]
 *	@param[in] szType [类型 CS-T1-A/12M]
 *	@param[in] szSubType [子类型 T001]
 *	@param[in] szCode [验证码]
 *	@param[in] bViaCAS [是否通过CAS透传 true为过CAS，false为直连，暂只支持CAS透传，传入true]
 *	@return	0-成功 -1-失败
 *
 * 修改日期		修改人		修改原因
 * 2014/10/21	feichenxi	新增接口
 * 2014/10/23	feichenxi	新增参数szDetSerial
 */
LIBCASCLIENT_API int CALLBACK CASClient_DelDetector(const char *szClientSession, ST_SERVER_INFO stServerInfo, ST_DEV_INFO stDevInfo, const char *szDetSerial, int iChannel, \
                                                    const char *szType, const char *szSubType, const char *szCode, bool bViaCAS);

/** 
* @brief	发送3D定位命令 
* @author 	panlong
* @param	const char * szClientSession 
* @param	ST_SERVER_INFO stServerInfo 
* @param	ST_DEV_INFO stDevInfo 
* @param	const char * szDetSerial 
* @param	int iChannel 
* @param	const char * szType 
* @param	const char * szSubType 
* @param	const char * szCode 
* @param	bool bViaCAS 
* @return 	LIBCASCLIENT_API int CALLBACK 0 成功，非0 失败
* @exceptions
* @see	 	
*/  
LIBCASCLIENT_API int CALLBACK CASClient_Position3D(const char *szClientSession, const pSERVER_INFO stServerInfo, const pDEV_INFO stDevInfo, const pST_POSITION3D_INFO pPosition3DInfo, bool bViaCAS);


/** 
* @brief    设置巡航路径 
* @author 	panlong
* @param	const char * szClientSession 
* @param	const pSERVER_INFO stServerInfo 
* @param	const pDEV_INFO stDevInfo 
* @param	const pST_SETCRUISEPOSITION_INFO pSetCruisePositionInfo 
* @param	bool bViaCAS 
* @return 	LIBCASCLIENT_API int CALLBACK 0 成功，非0 失败
* @exceptions
* @see	
*/  
LIBCASCLIENT_API int CALLBACK CASClient_SetCruisePosition(const char *szClientSession, const pSERVER_INFO stServerInfo, const pDEV_INFO stDevInfo, const pST_SETCRUISEPOSITION_INFO pSetCruisePositionInfo, bool bViaCAS);

/** 
* @brief    绑定主人MAC 
* @author 	zhangyi
* @param	const char * szClientSession 
* @param	const pSERVER_INFO stServerInfo 
* @param	const pDEV_INFO stDevInfo 
* @param	const pST_AUTODEFENCEBIND_INTO pAutoDefenceBindInfo 
* @param	bool bViaCAS 
* @return 	LIBCASCLIENT_API int CALLBACK 0 成功，非0 失败
* @exceptions
* @see	
*/  
LIBCASCLIENT_API int CALLBACK CASClient_BindBossMAC(const char *szClientSession, const pSERVER_INFO stServerInfo, const pDEV_INFO stDevInfo, \
                                                    const pST_AUTODEFENCEBIND_INTO pAutoDefenceBindInfo, bool bViaCAS);

/** 
* @brief    查询指定手机是否已绑定到指定设备 
* @author 	zhangyi
* @param	const char * szClientSession 
* @param	const pSERVER_INFO stServerInfo 
* @param	const pDEV_INFO stDevInfo 
* @param	const pST_AUTODEFENCEBIND_INTO pAutoDefenceBindInfo 
* @param	bool bViaCAS 
* @param[out]	int	*pStatus 1表示已经绑定　　0表示未绑定	
* @return 	LIBCASCLIENT_API int CALLBACK 0 成功，非0 失败
* @exceptions
* @see	
*/  
LIBCASCLIENT_API int CALLBACK CASClient_QueryBindBossMAC(const char *szClientSession, const pSERVER_INFO stServerInfo, \
                                                         const pDEV_INFO stDevInfo, const pST_AUTODEFENCEBIND_INTO pAutoDefenceBindInfo, bool bViaCAS, int *pStatus);

/**
 * @brief      [设置显微镜协议]
 * @param[in]  szClientSession      [客户端session]
 * @param[in]  stServerInfo         [服务器信息]
 * @param[in]  stDevInfo            [设备信息]
 * @param[in]  iMultiple            [放大倍数] 1为不放大，最高放大到2倍，可精确到1位小数
 * @param[in]  iCoordinateX         [指示放大画面的中心点坐标点（x,y）]
 * @param[in]  iCoordinateY         [指示放大画面的中心点坐标点（x,y）]
 * @param[in]  iIndex               [当前预览的视频质量索引值，1-高清、2-均衡、3-流畅]
 * @param[in]  bViaCAS              [是否透传]
 * @return     [0成功，-1失败]
 
 * 修改日期		修改人		修改原因
 * 2015/11/23	StarChen	新增接口
 */
LIBCASCLIENT_API int CALLBACK CASClient_SetMicroscopeConfig(const char* szClientSession, ST_SERVER_INFO stServerInfo, ST_DEV_INFO stDevInfo, int iMultiple, int iCoordinateX, int iCoordinateY, int iIndex, bool bViaCAS);

/**
 * @brief      [调整P2P链路MTU]
 * @param[in]  usMtu      [客户端session]
 
 * 修改日期		修改人		修改原因
 * 2018/05/11	zhanglei	新增接口
 */
LIBCASCLIENT_API void CALLBACK CASClient_SetP2PMTU(const char* pszSerial, unsigned int usMtu);

/** @} */ //tranfer end


/**
 * @defgroup P2PTrans 接口
 * @{
 */


/**	
 *	@brief 创建链路
 *  @param[in] pCAS_TRANS_OPT           [建链信息]
 *	@param[in] pMsgFunc                 [消息回调]
 *	@param[in] pDataFunc                [数据回调]
 *	@param[in] userdata                 [用户数据]
 *	@return	>=0-会话句柄 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_BuildDataLink(const pCAS_TRANS_OPT pTransOption, MsgFuncEx pMsgFunc, DataFuncEx pDataFunc, void* userdata);

/**	
 *	@brief 销毁链路
 *  @param[in]	iLinkID             [数据链路标识]
 *	@return	0-成功 -1-失败
 */
LIBCASCLIENT_API int CALLBACK CASClient_DestroyDataLink(const int iLinkID);

/** 
 *  @brief        [发送P2P-Relay通道 数据]
 *  @param[in]	  iLinkID             [数据链路标识]
 *  @param[in]    pData               [数据]
 *  @param[out]   iDataLen            [数据长度, 最大长度不予许超过65535]
 *  @return 	  [>=0 发送数据的大小, 非0 失败]
 *  @exceptions
 *  @see	
 */ 
LIBCASCLIENT_API int CALLBACK CASClient_WriteDataToLink(const int iLinkID, const char *pData, const int iDataLen);


/** @} */ //P2PTrans end

#ifdef __cplusplus
}
#endif


#endif // __LIBCASCLIENT_H__
