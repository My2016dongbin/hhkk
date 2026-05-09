#ifndef _BAV_CLIENT_API_H_
#define _BAV_CLIENT_API_H_

#ifdef QOS_NPQ_BAV
#include "NPQosAudioDec.h"
#endif
#include<string.h>

#ifdef _WIN32
#ifdef GLOBAL_DECL_EXPORTS
#define GLOBAL_API	extern "C" __declspec(dllexport)
#else
#define GLOBAL_API  extern "C" __declspec(dllimport)
#endif
typedef  char				YS_INT8;
typedef  short				YS_INT16;
typedef  int				YS_INT32;
typedef __int64             YS_INT64;
typedef unsigned char		YS_UINT8;
typedef unsigned short      YS_UINT16;
typedef unsigned int		YS_UINT32;
typedef unsigned __int64    YS_UINT64;
typedef float               YS_FLOAT32;
#else
#define GLOBAL_API
#define GLOBAL_CALLBACK
#include <stdint.h>
typedef char				YS_INT8;
typedef int16_t				YS_INT16;
typedef int32_t				YS_INT32;
typedef int64_t				YS_INT64;
typedef unsigned char		YS_UINT8;
typedef uint16_t			YS_UINT16;
typedef uint32_t			YS_UINT32;
typedef uint64_t			YS_UINT64;
typedef float               YS_FLOAT32;
#endif

#ifdef __cplusplus
extern "C"
{
#endif

///< 版本号定义
static const int MAJOR_VERSION = 1;
static const int MINOR_VERSION = 1;
static const int PATCH_VERSION = 1;

#define STREAM_TOKEN_LEN              (512UL)
#define STREAM_DEV_SERIAL_LEN         (32UL)
#define CLIENT_STREAM_SVR_ADDR_LEN    (64UL)
#define CLIENT_STREAM_EXTENSION_LEN   (512UL)
#define STREAM_HEAD                   (40UL)
#define FLIEPATH					  (512UL)
#define CUSTOMID_LEN                  (256UL)
#define SELFID_LEN                    (256UL)
#define STREAM_SECRETKEY_LEN          (40UL)
#define CLIENT_VOLUME_NUM_MAX         (32UL)
#define BAV_CUSTOM_MESSAGE_LEN        (1024UL)
#define SIGNAL_SECRETKEY_LEN          (128UL)

typedef enum
{
	BAV_CLIENT_EVENT_NOTIFY,
	BAV_CLIENT_EVENT_ERROR,
	BAV_CLIENT_EVENT_INVALID,
}BAV_CLIENT_EVENT_TYPE;

typedef struct BavJoinInfo
{
	YS_UINT32	m_uRoomId;
	YS_UINT32	m_uClientId;
	YS_INT8 	m_sCustomId[CUSTOMID_LEN];
	YS_INT8		m_szUserName[64];
	YS_UINT16	m_sJoinType;
	YS_UINT32	m_uShareClientId;
	YS_INT8     m_strAvatarUrl[512];
    YS_UINT8	m_iCltType;
	struct BavJoinInfo *pNext;
}stBavJoinInfo;//BAV_CLIENT_EVENT_BAV_CLIENT_INFO|BAV_CLIENT_EVENT_CLIENT_JOIN_ROOM|BAV_CLIENT_EVENT_CLIENT_QUIT_ROOM

typedef struct BavClientVolume
{
	YS_UINT32	m_uClientId;
	YS_INT8		m_sVolume;    //音量强度0-10 10为最强 0为最弱
}stBavClientVolume;//BAV_CLIENT_EVENT_BAV_CLIENT_VOLUME

typedef struct BavClientVolumeList
{
    YS_UINT32	m_uClientId[CLIENT_VOLUME_NUM_MAX];
    YS_INT8		m_sVolume[CLIENT_VOLUME_NUM_MAX];
    YS_INT8     m_uClientNum;
    YS_UINT32   m_uTotal;
}stBavClientVolumeList;


typedef struct BavClientAudioAvailable
{
	YS_UINT32	m_uClientId;
	YS_INT8		m_sAvailable;    //声音启用状态 0-关闭 1-启用
}stBavClientAudioAvailable;//BAV_CLIENT_EVENT_BAV_AUDIO_STAT

typedef struct BavClientVideoAvailable
{
	YS_UINT32	m_uClientId;
	YS_INT8		m_sAvailable;    //视频启用状态 0-关闭 1-大流 5-大小流
}stBavClientVideoAvailable;//BAV_CLIENT_EVENT_CLIENT_VIDEO_AVAILABLE

typedef struct BavClientScreenShareAvailable
{
	YS_UINT32	m_uClientId;
	YS_INT8		m_sAvailable;    //视频启用状态 0-关闭 1-启用
}stBavClientScreenShareAvailable;//BAV_CLIENT_EVENT_CLIENT_SCREEN_SHARE_AVAILABLE

typedef struct BavClientScreenShare
{
	YS_UINT8	m_iType;		//共享消息类型, 1：开启(自己)，0：关闭（自己）, 3：强制关闭 #BAV_SHARE_TYPE
	YS_UINT32   m_sResult;		//成功或者失败, 0表示失败， 1表示成功
}stBavClientScreenShare;//BAV_CLIENT_EVENT_SCREEN_SHARE_INFO

typedef struct BavClientOpenMic
{
	YS_UINT32		            m_sResult;    //成功或者失败 已到达房间开启上限
}stBavClientOpenMic;//BAV_CLIENT_EVENT_OPEN_MIC_INFO

typedef enum
{
    BAV_NETWORK_QUALITY_UNKONNOWN = 0,             	//网络状态未知
    BAV_NETWORK_QUALITY_EXCELLENT = 1,				//当前网络非常好
    BAV_NETWORK_QUALITY_GOOD = 2,                  	//网络好
    BAV_NETWORK_QUALITY_POOR = 3,                  	//网络一般
    BAV_NETWORK_QUALITY_BAD  = 4,                   //网络差 
    BAV_NETWORK_QUALITY_VBAD = 5,	    			//网络非常差
    BAV_NETWORK_QUALITY_UNAVAILABLE = 6            	//网络不可用
}BAV_NETWORK_QUALITY_TYPE;

typedef struct BavClientNetQuality
{
	YS_UINT32	                    m_uClientId;  //客户端id
	BAV_NETWORK_QUALITY_TYPE		m_sUpType;    //上行网络情况
	BAV_NETWORK_QUALITY_TYPE		m_sDownType;  //下行网络情况
}stBavClientNetQuality;//BAV_CLIENT_EVENT_NETWORK_QUALITY

typedef enum
{
	BAV_NETWORK_UNKOWN			= 0,	//连接未知
	BAV_NETWORK_LOST			= 1,	//连接断开
	BAV_NETWORK_RECONNECTING	= 2,	//重新建立网络连接中
	BAV_NETWORK_RECONNECTED		= 3,	//重连成功
	BAV_NETWORK_FAILED			= 4,	//网络连接失败
}BAV_RECONNECT_STATE;

typedef enum
{
	BAV_NETWORK_BROKEN = 1,                 //网络断开
	BAV_NEATWORK_RECOVERY = 2,              //网络恢复
	BAV_NETWORK_SWITCH = 3,                 //网络切换
}BAV_NETWORK_CHANGE;

typedef enum
{
	BAV_MOVE_OUT_REPEAT_JOIN,      //已在其他地方加入房间
	BAV_MOVE_OUT_ADMIN,            //被管理员移出房间
	BAV_MOVE_OUT_ROOM_DISSOLVED,   //房间解散
}BAV_MOVE_OUT_TYPE;

typedef struct BavClientMoveOut
{
	BAV_MOVE_OUT_TYPE		m_sReason;    //移出原因
}stBavClientMoveOut;//BAV_CLIENT_EVENT_BAV_CLIENT_MOVE_OUT [接收到BAV_MOVE_OUT_ROOM_DISSOLVED,需要上层主动调用BavExitRoom]

typedef enum
{
	BAV_CLIENT_EVENT_IDLE							= 0,	//无效事件code
	BAV_CLIENT_EVENT_START_INPUT_DATA				= 1,   	//开始推流,建立成功
	BAV_CLIENT_EVENT_CMD							= 2,	//信令（强制I帧 降码率）
	BAV_CLIENT_EVENT_CREAET_ROOM_OK					= 3,    //客户端创建房间成功
	BAV_CLIENT_EVENT_CLIENT_JOIN_ROOM				= 4,	//客户端加入房间，对应结构体BavJoinInfo
	BAV_CLIENT_EVENT_CLIENT_QUIT_ROOM				= 5,	//客户端退出房间
	BAV_CLIENT_EVENT_CLIENT_TRANSFER				= 6,	//客户端透传信息
	BAV_CLIENT_EVENT_BAV_AUDIO_STAT					= 7,	//音频网络状态
	BAV_CLIENT_EVENT_BAV_VEDIO_STAT					= 8,	//视频网络状态
	BAV_CLIENT_EVENT_BAV_CLIENT_INFO				= 9,	//其他客户端信息变更
	BAV_CLIENT_EVENT_BAV_CLIENT_VOLUME				= 10,	//其他客户端音量
	BAV_CLIENT_EVENT_CLIENT_AUDIO_AVAILABLE			= 11,	//用户是否开启音频上行
	BAV_CLIENT_EVENT_CLIENT_VIDEO_AVAILABLE			= 12,	//用户是否开启视频上行
	BAV_CLIENT_EVENT_CLIENT_SCREEN_SHARE_AVAILABLE	= 13,	//用户是否开启屏幕共享上行
	BAV_CLIENT_EVENT_ROOM_MUTE_STATE_CHANGED		= 14,	//其他客户端信息
	BAV_CLIENT_EVENT_ROOM_REC_STATE_CHANGED			= 15,	//其他客户端信息
	BAV_CLIENT_EVENT_ROOM_SCREEN_SHARE_STATE_CHANGED= 16,	//其他客户端信息
	BAV_CLIENT_EVENT_SCREEN_SHARE_INFO				= 17,	//屏幕分享结果
	BAV_CLIENT_EVENT_OPEN_MIC_INFO					= 18,	//麦克风开启结果
	BAV_CLIENT_EVENT_NETWORK_QUALITY				= 19,	//网络质量的实时统计，对应结构体BavClientNetQuality
	BAV_CLIENT_EVENT_STATISTICS						= 20,	//音视频技术指标实时统计
	BAV_CLIENT_EVENT_JOIN_ROOM_OK					= 21,	//客户端加入房间成功
	BAV_CLIENT_EVENT_BAV_CLIENT_MOVE_OUT			= 22,	//客户端退出房间
    BAV_CLIENT_EVENT_CLIENT_VOICE_VOLUME			= 23,	//所有客户端音量（包括自己）
    BAV_CLIENT_EVENT_LOCAL_VIDEO_STATS				= 24,	//统计本地视频实时数据,对应结构体SBavLocalVideoStats
    BAV_CLIENT_EVENT_LOCAL_AUDIO_STATS				= 25,	//统计本地音频实时数据,对应结构体SBavLocalAudioStats
    BAV_CLIENT_EVENT_REMOTE_VIDEO_STATS				= 26,	//统计远端视频实时数据,对应结构体SBavRemoteVideoStats
    BAV_CLIENT_EVENT_REMOTE_AUDIO_STATS				= 27,	//统计远端音频实时数据,对应结构体SBavRemoteAudioStats
    BAV_CLIENT_EVENT_SPEED_TEST_RESULT				= 28,	//通话前测速结果，对应结构体SBavSpeedTestResult
    BAV_CLIENT_EVENT_CUSTOM_MSG						= 29,	//用户自定义透传消息,对应结构体SBavCustomMsg
    BAV_CLIENT_EVENT_ROTATE							= 30,	//自定义旋转,对应结构体SBavRotation
    BAV_CLIENT_EVENT_AUDIO_ABR						= 31,	//音频码率自适应,对应结构体SBavAudioAbr
	BAV_CLIENT_EVENT_VIDEO_FPS						= 32,	//视频降帧率,对应结构体SBavVideoFps
	BAV_CLIENT_EVENT_TRANSPARENT					= 33,	//透传消息，JSON格式定义,对应结构体stBavClientTransparent
	BAV_CLIENT_EVENT_LOCAL_SEND_STATS				= 34,	//本地发送网络信息,对应结构体SBavLocalSendStats
	BAV_CLIENT_EVENT_ADAPTE_STRATEGY				= 35,	//适配策略信息,对应结构体stBavClientTransparent
	BAV_CLIENT_EVENT_SERVER_MSG						= 36,	//服务自定义透传消息,对应结构体SBavCustomMsg
	BAV_CLIENT_EVENT_CLIENT_PERMISSION				= 37,	//客户端权限变更,对应结构体stBavClientPermission
	BAV_CLIENT_EVENT_CLIENT_SYSTEM_AUDIO_AVAILABLE	= 38,	//用户是否开启系统声音上行
} BAV_NOTIFY_CODE;

typedef enum
{
	//上面是通知事件的code，下面是错误事件错误码
	BAV_CLIENT_EVENT_CONNECT_FAIL					= 6,    //连接STS服务失败
	BAV_CLIENT_EVENT_CONNECTION_CLOSE				= 7,   	//STS连接断开
	BAV_CLIENT_EVENT_KEEPALIVE_TIMEOUT				= 8,  	//心跳连接超时
	BAV_CLIENT_EVENT_REFUSE_JOIN_ROOM   			= 9,	//拒接视频通话
	BAV_CLIENT_EVENT_OTHER_DISCONNECT				= 10,   //
	BAV_CLIENT_EVENT_ROOM_INVALID					= 11,	//房间号无效
	BAV_CLIENT_EVENT_CMD_TIMEOUT					= 12,	//STS服务信令回复超时
	BAV_CLIENT_EVENT_UDP_FAIL						= 13,	//UDP心跳超时
	BAV_CLIENT_EVENT_CONNECT_VTM_FAIL				= 14,	//连接VTM服务失败
	BAV_CLIENT_EVENT_VTM_TIMEOUT					= 15,	//VTM回复超时
	BAV_CLIENT_EVENT_DEV_RSP_TIMEOUT				= 16,	//设备回复超时
	BAV_CLIENT_EVENT_ROOMID_FULL					= 17,	//房间号已满
	BAV_CLIENT_EVENT_AUTH_FAIL						= 18,	//认证失败
	BAV_CLIENT_EVENT_ROOM_IS_EXIST					= 19,	//房间号存在
	BAV_CLIENT_EVENT_DEV_OFFLINE					= 20,	//设备不在线
	BAV_CLIENT_EVENT_USER_STOPS						= 21,	//用户关闭
	BAV_CLIENT_EVENT_BAV_STOPS						= 22,	//异常关闭
	BAV_CLIENT_EVENT_NO_ONE_ANSWERED				= 23,   //
	BAV_CLIENT_EVENT_SRTP_INIT_FAIL					= 24,   //srtp init fail
	BAV_CLIENT_EVENT_STS_CHECK_CLIENT_KEEP_TIMEOUT	= 25,	//服务端检测客户端心跳超时
	BAV_CLIENT_EVENT_CLIENT_DISCONNECT_SERVER		= 26,	//客户端断开网络
	BAV_CLIENT_EVENT_CLIENT_AUDIO_INFO_ERROR		= 27,	//音频信息异常
	BAV_CLIENT_EVENT_CLIENT_SYS_ERROR				= 28,	//转Rtp模块没有初始化
	BAV_CLIENT_EVENT_CAS_RPC_ERROR					= 29,	//Cas没有可用服务
	BAV_CLIENT_EVENT_AUTH_TIME_OUT					= 30,	//Auth 超时
	BAV_CLIENT_EVENT_STSADDER_EMPTY					= 31,	//sts 服务地址为空
	BAV_CLIENT_EVENT_VTMADDER_EMPTY					= 32,	//vtm 服务地址为空
	BAV_CLIENT_EVENT_OTHER_UDP_TIMEOUT				= 33,	//对端UDP超时断开
	BAV_CLIENT_EVENT_OTHER_TCP_TIMEOUT				= 34,	//对端TCP超时断开
	BAV_CLIENT_EVENT_ROOM_IS_NOT_EXIST				= 35,	//房间号不存在
	BAV_CLIENT_EVENT_ROOM_TIME_OUT					= 36,	//房间超时
	BAV_CLIENT_EVENT_NOT_SUPPORT_TCP				= 37,	//不支持TCP
	BAV_CLIENT_EVENT_WINDOW_OVERFLOW				= 38,	//send or recv window overflow
	BAV_CLIENT_EVENT_CODE_INVALID					= 39,	//服务端通用错误码
	BAV_CLIENT_EVENT_STS_USERID_EXIST				= 40,	//STS服务返回房间内用户已存在（目前SP4和TV项目有此错误码）
	BAV_CLIENT_EVENT_STS_GET_SECRETKEY_FAILED		= 41,	//STS服务返回获取加密密钥失败（VC不响应信令）
	BAV_CLIENT_EVENT_STS_CUSTOM_ROOM_INVALID		= 42,	//STS服务报无效的CustomRoomId
	BAV_CLIENT_EVENT_USER_BLACKLIST					= 43,	//服务报用户被加入黑名单
	//BavStart 未启动，调用BavStart，m_iCltRole填写EN_CLIENTYPT_STOP，m_iReason填写下面几个类型
	BAV_CLIENT_EVENT_STOP_REFUSE					= 101,  //对方拒接
	BAV_CLIENT_EVENT_STOP_NOANSWER					= 102,  //无人接听
	BAV_CLIENT_EVENT_STOP_CALLING					= 103,  //正在电话通话中，收到视频通话，则挂断视频通话
	BAV_CLIENT_EVENT_STOP_TEMPERATURE_HIGH			= 104,  //手表温度过高，若手表发起通话，则发起失败(仅手表端自己给出UI提示)。若手表收到来电，则挂断。
	BAV_CLIENT_EVENT_STOP_OPEN_CAMERA_FAIL			= 105,  //手表正在被远程监控中，收到视频通话来电时，手表相机打开失败，挂断通话
	BAV_CLIENT_EVENT_STOP_BVING						= 106,  //正在视频通话中，收到第三方的视频通话，终止第三方的视频通话
	//BavStart 已启动 stop iReason填写下面几个类型
	BAV_CLIENT_EVENT_STOP_DISCONNECT				= 201,  //成功建立通话后，任意一方挂断
	BAV_CLIENT_EVENT_STOP_DISCONNECTINTG			= 202,  //主叫发起通话，在被叫未做任何操作前， 主叫挂断
	BAV_CLIENT_EVENT_STOP_TEMPERATURE_HIGHING		= 203,  //手表温度过高 -- 若通话中，则手表主动挂断。
	BAV_CLIENT_EVENT_STOP_ALARM_CLOCK_BREAK			= 204,  //闹铃打断
	BAV_CLIENT_EVENT_STOP_CALL_BREAK				= 205,  //正在视频通话中被电话打断

	BAV_CLIENT_EVENT_TALK_TALKING					= 301,  //该通道已在对讲
	BAV_CLIENT_EVENT_TALK_OPR_OR_CRYT_NO_MATCH		= 302,  //设备加密算法不匹配
	BAV_CLIENT_EVENT_TALK_AUDIO_LOCATING			= 303,  //当前正在声源定位
	BAV_CLIENT_EVENT_TALK_PRIVACY_COVER				= 304,  //设备处于隐私遮蔽状态
	BAV_CLIENT_EVENT_TALK_DEV_CONN_ERR				= 305,  //对接服务器失败

	BAV_CLIENT_EVENT_SUBSCRIBE_UNAUTHORIZED			= 403,  //订阅无权限（vc服务返回）
	BAV_CLIENT_EVENT_SUBSCRIBE_UNAVAILABLE			= 404,  //订阅的能力不存在（vc服务返回）

	BAV_CLIENT_EVENT_SDGW_DEVSERIAL_CALLING			= 501,	//设备正在请求中
	BAV_CLIENT_EVENT_SDGW_NET_ERROR					= 502,	//设备网络异常
	BAV_CLIENT_EVENT_SDGW_AUTH_FAIL					= 503,	//认证失败
	
	BAV_CLIENT_EVENT_VC_CONNECT_FAIL				= 601,	//连接会控服务失败
	BAV_CLIENT_EVENT_VC_TIMEOUT      				= 602,	//会控回复超时
	BAV_CLIENT_EVENT_VC_ADDER_EMPTY					= 603,	//会控 服务地址为空
	BAV_CLIENT_EVENT_ROOM_CLIENT_IS_EXIST			= 604,	//客户端存在
	BAV_CLIENT_EVENT_VC_AUTH_ERROR					= 605,	//会控认证失败
	BAV_CLIENT_EVENT_VC_DISROOM_ERROR				= 606,	//解散房间失败

	BAV_CLIENT_EVENT_P2P_CONNECT_FAIL				= 701,	//P2P连接失败
	BAV_CLIENT_EVENT_P2P_TIMEOUT      				= 702,	//P2P连接超时
	BAV_CLIENT_EVENT_P2P_ADDER_EMPTY				= 703,	//P2P对端地址为空
	BAV_CLIENT_EVENT_P2P_DECODE_FAIL				= 704,	//P2P解密失败

	BAV_CLIENT_EVENT_PARAMS_INVALID					= 801,	//传入参数异常
}BAV_ERROR_CODE;

typedef enum
{
	BAV_CLIENT_SUC,
	BAV_CLIENT_ERROR = -1
}BAV_CLIENT_ERROR_CODE;

typedef enum
{
	BAV_CLIENT_DATA_IDLE,                   //无效数据             
	BAV_CLIENT_DATA_STREAM_HEADER,          //流头
	BAV_CLIENT_DATA_VEDIO_STREAM,           //视频数据
	BAV_CLIENT_DATA_AUDIO_STREAM,           //音频数据
	BAV_CLIENT_STREAM_PASSWORD,				//秘钥
}BAV_CLIENT_DATA_TYPE;

typedef enum
{
	BAV_CLIENT_STREAM_IDLE,
	BAV_CLIENT_STREAM_VEDIO,
	BAV_CLIENT_STREAM_AUDIO,
	BAV_CLIENT_STREAM_MULITIPLEX,
	BAV_CLIENT_STREAM_PRIVATE,
	BAV_CLIENT_STREAM_RTP_VEDIO,
	BAV_CLIENT_STREAM_RTP_AUDIO,
	BAV_CLIENT_STREAM_SHARE_VEDIO,
	BAV_CLIENT_STREAM_SHARE_AUDIO,
	BAV_CLIENT_STREAM_RTP_SHARE_VEDIO,
	BAV_CLIENT_STREAM_RTP_SHARE_AUDIO,
	BAV_CLIENT_STREAM_SMALL_VEDIO,
	BAV_CLIENT_STREAM_RTP_SMALL_VEDIO,
	BAV_CLIENT_STREAM_HEAD
}BAV_CLIENT_STREAM_TYPE;

typedef enum
{
	EN_CLIENTTYPE_CREATE,					//创建房间
	EN_CLIENTTYPE_JOIN,						//加入房间
	EN_CLIENTYPT_STOP,						//无人接听、拒接接听等
	EN_CLIENTTYPE_NOTIFY_CREATE,			//创建并通知设备加入
	EN_CLIENTTYPE_BRANCH,					//旁路推流
    EN_CLIENTTYPE_SPEED_TEST,               //通话前检测
}BAV_CLIENT_ROLE;

typedef enum
{
	BAV_CMD_ENCODE,							//音视频编码参数
	BAV_CMD_FORCE_I_FRAME,					//强制I帧
}BAV_CMD_TYPE;

typedef enum
{
    BAV_AUTH_ROOM_PWD = 22,				    //房间密钥,用于电子班牌
    BAV_AUTH_ERTC_TOKEN = 23,				//ERTC Token认证,用于多方音视频业务
	BAV_AUTH_RES_TOKEN = 26,				//ERTC 资源Token认证,用于多方音视频业务
	BAV_AUTH_TICKET = 100,					//ticket认证,录制业务
}BAV_AUTH_TYPE;

typedef enum
{
	BAV_DATA_RTP_VIDEO,			//视频RTP数据
	BAV_DATA_RTP_AUDIO,			//音频RTP数据
	BAV_DATA_RTP_PRIVATE
}BAV_DATA_TYPE;

typedef enum
{
	BAV_AUDIO_ENCODE_AAC = 1,			//音频AAC编码
	BAV_AUDIO_ENCODE_OPUS = 2,			//音频OPUS编码
}BAV_AUDIO_ENCODE_TYPE;

typedef enum
{
	BAV_SHARE_CLOSE = 0,			//请求关闭（自己）
	BAV_SHARE_OPEN	= 1,			//请求开启（自己）
	BAV_SHARE_GRAB	= 2,			//强制开启（抢占他人）【未实现】
	BAV_SHARE_STOP	= 3,			//强制关闭（他人）
}BAV_SHARE_TYPE;

typedef enum
{
	BAV_TRANSPARENT_RECONNECT_STATE,     //重连类型
	BAV_TRANSPARENT_RECONNECT_STATICS,   //重连统计
	BAV_TRANSPARENT_REMOTE_REJOIN,		 //他人重新重连上线
	BAV_TRANSPARENT_SUBSCRIBE_PERMISSION,//订阅权限通知
	BAV_TRANSPARENT_SUBSCRIBE_RES,		 //订阅结果通知
}BAV_TRANSPARENT_TYPE;

typedef enum
{
	BAV_SERVER_LINE_NET = 1,	//线路走外网, 比方VPN，移动网络
	BAV_SERVER_LINE_LAN = 2,	//线路走内网，比方蓝网、红网
}BAV_SERVER_LINE_ID;

typedef struct BavClientTransparent
{
	YS_UINT32               iLength;              //透传信息长度
	YS_INT8                 *m_strContent;        //透传信息（JSON格式）
}stBavClientTransparent;//BAV_CLIENT_EVENT_TRANSPARENT

typedef struct SBavStat
{
	YS_INT32 nType;				//1:NPQ 2:YS QOS(EzRtc)
	YS_INT32 nRttUs;			//rtt，单位ms
	YS_INT32 nRealRttUs;		//实时rtt，单位ms
	YS_INT32 nBitRate;			//当前所有数据实际码率,单位 kbps
	YS_INT32 cLossFraction;		//丢包率，单位(%)
	YS_INT32 cLossFraction2;	//经过恢复之后的丢包率，只能在接收端获取，单位(%)
	YS_INT32 frozenRate;		//音频播放卡顿率，单位 (%)
}SBavStat;

typedef struct SBavEzReport
{
	int duration;       /*seconds*/

	float lost_rate;
	float rtt;          /*average*/
	int rtt_10;
	int rtt_20;
	int rtt_50;
	int rtt_100;
	int rtt_250;
	int rtt_500;
	int rtt_1000;
	float rtt_max;

	float jitter;
	float bandwidth;

	float bitrate;     /*kbps*/
	float framerate;   /*fps*/

	float delay;       /*average*/

	float lag_slight_rate;
	float lag_middle_rate;
	float lag_serious_rate;
}SBavEzReport;

typedef YS_INT32  BAV_CLIENT_HANDLE;

typedef YS_INT32(*BavLogCallback)(YS_INT8* pData, YS_UINT32 nDataLen, void* pUser);

typedef YS_INT32(*BavDataCallback)(BAV_CLIENT_DATA_TYPE iDataType, YS_UINT8* pData, YS_UINT32 nDataLen, YS_UINT32 iClientId, void* pUser);

typedef YS_INT32(*BavMsgCallback)(BAV_CLIENT_EVENT_TYPE eventType, YS_INT32 eventCode, YS_UINT8* pData, YS_UINT32 nDataLen, void* pUser);

typedef struct SBavRoomInfo
{
	YS_UINT16	m_iStsPort;												//转发服务端口
	YS_UINT32	m_iRoomId;												//房间号
	char		m_szStsAddr[CLIENT_STREAM_SVR_ADDR_LEN + 1];			//转发服务地址
}SBavRoomInfo;

typedef enum
{
    BAV_STREAM_INVALID,
    BAV_SUB_STREAM_BIG_VEDIO = 1,
    BAV_SUB_STREAM_AUDIO = BAV_SUB_STREAM_BIG_VEDIO << 1,
    BAV_SUB_STREAM_MIN_VEDIO = BAV_SUB_STREAM_AUDIO << 1,
    BAV_SUB_STREAM_SHARE_VEDIO = BAV_SUB_STREAM_MIN_VEDIO << 1,
}BAV_SUB_STREAM_TYPE;

typedef struct SBavEcodeParam
{
	YS_INT32		m_iVersion;						//结构体版本，用于以后兼容
	YS_INT32		m_iMaxBitRate;					//最大码率   单位 bps
	YS_INT32		m_iResolution;					//分辨率  按照网络SDK协议定义的索引值
	YS_INT8			m_szRes[244];
}SBavEcodeParam;

///自定义透传消息
typedef struct SBavCustomMsg
{
    YS_UINT32	    uClientId;                    //发送数据的clientId
    YS_INT8         szMsg[BAV_CUSTOM_MESSAGE_LEN];//用户自定义消息
    YS_UINT32       uMsgSize;                     //用户自定义消息长度
}SBavCustomMsg;

///旋转角度
typedef struct SBavRotation
{
    YS_UINT32	    uClientId;                    //发送数据的clientId
    YS_UINT32       uRotation;                    //标准的旋转的角度只有四挡：0°、90°、180°和270°
}SBavRotation;

///音频自适应
typedef struct SBavAudioAbr {
    YS_UINT32	    uBitratePercent;              //目标码率的百分比,80表示码率变成目标码率的80%
    YS_UINT32       uPacketlost;                  //丢包率,50表示丢包率设置成50%
}SBavAudioAbr;

///降帧率
typedef struct SBavVideoFps {
	BAV_SUB_STREAM_TYPE eStreamType;				//码流类型
	YS_UINT32			uPercent;					//目标帧率的百分比,80表示码率变成目标帧率的80%
}SBavVideoFps;

/** 
* Statistics of the local video stream.
*/
typedef struct SBavLocalVideoStats {
    ///本地视频的码率，即每秒钟新产生视频数据的多少，单位 Kbps
    YS_INT32 sentBitrate;
    ///本地视频的帧率，即每秒钟会有多少视频帧，单位：FPS
    YS_INT32 sentFrameRate;
    ///丢包率,单位%
    YS_INT32 packetLossRate;
    ///补偿后丢包率,单位%
    YS_INT32 compensateLossRate;
    /// stream type #BAV_SUB_STREAM_TYPE
    YS_INT32 streamType;
    /// 发送视频总包数
    YS_INT32 packetCount;
}SBavLocalVideoStats;

/**
* Audio statistics of the local user 
*/
typedef struct SBavLocalAudioStats {
    ///本地音频的码率，即每秒钟新产生音频数据的多少，单位 Kbps
    YS_INT32 sentBitrate;
    ///丢包率,单位%
    YS_INT32 packetLossRate;
    /// 发送音频总包数
    YS_INT32 packetCount;
}SBavLocalAudioStats;

/** 
* Statistics of the remote video stream.
*/
typedef struct SBavRemoteVideoStats {
    ///< clientId
    YS_INT32 clientId;                    
    ///远端视频的码率，单位 Kbps
    YS_INT32 receivedBitrate;
    ///远端视频的帧率，单位：FPS
    YS_INT32 receivedFrameRate;
    ///该路视频流的总丢包率（％）
    YS_INT32 packetLossRate;
    ///视频补偿前丢包率（％）
    YS_INT32 uncompensateLoss;
    ///视频播放的累计卡顿时长，单位 ms
    YS_INT32 totalFrozenTime;
	///视频播放平均延时
	YS_INT32 delayMs;
    ///视频播放卡顿率，单位 (%)
    YS_INT32 frozenRate;
    ///< stream type #BAV_SUB_STREAM_TYPE
    YS_INT32 streamType;
    /// 接收视频总包数
    YS_INT32 packetCount;
}SBavRemoteVideoStats;

/** Audio statistics of a remote user */
typedef struct SBavRemoteAudioStats {
    ///< User ID of the remote user sending the audio streams.
    YS_INT32 clientId;
    ///本地音频的码率，单位 Kbps
    YS_INT32 receivedBitrate;
    ///该路音频流的总丢包率（％）
    YS_INT32 packetLossRate;
    ///音频补偿前丢包率（％）
    YS_INT32 uncompensateLoss;
    ///音频播放的累计卡顿时长，单位 ms
    YS_INT32 totalFrozenTime;
    ///音频播放卡顿率，单位 (%)
    YS_INT32 frozenRate;
    /// 接收音频总包数
    YS_INT32 packetCount;
    ///< 音频帧补偿数量
    YS_INT32 plcPacketCount;
    /// 播放音频总时间
    YS_INT32 totalTime;
}SBavRemoteAudioStats;

/**
* Statistics of the local send.
*/
typedef struct SBavLocalSendStats {
	///本地发送的码率，即每秒钟新产生视频数据的多少，单位 Kbps
	YS_INT32 sentBitrate;
	///丢包率,单位%
	YS_INT32 packetLossRate;
	///补偿后丢包率,单位%
	YS_INT32 compensateLossRate;
	/// 网络延迟
	YS_INT32 rtt;
	/// 网络质量
	BAV_NETWORK_QUALITY_TYPE quality;
}SBavLocalSendStats;

typedef struct SBavCmd
{
	YS_INT32			m_iVersion;			//结构体版本，用于以后兼容
	BAV_CMD_TYPE		m_enInfoType;		//命令类型
	SBavEcodeParam		m_struEncode;		//编码参数 
	BAV_SUB_STREAM_TYPE m_eStreamType;      //码流类型
}SBavCmd;//BAV_CLIENT_EVENT_CMD

/**	@enum	 BAV_QOS_TYPE
 *	@brief   Qos策略类型
 *	@note
 */
typedef enum
{
	BAV_TYPE_NACK = (1 << 0),							//Nack		
	BAV_TYPE_FEC = (1 << 1),							//FEC
	BAV_TYPE_DEJITTER = (1 << 2),						//去抖动
	BAV_TYPE_BW = (1 << 3),								//拥塞控制
	BAV_TYPE_PLI = (1 << 4),							//PLI
	BAV_TYPE_SYNCHRONOUS = (1 << 5),					//音视频同步
	BAV_TYPE_ALL = (BAV_TYPE_SYNCHRONOUS << 1) - 1,		//所有都开启
}BAV_QOS_TYPE;

typedef enum
{
	BAV_STREAM_VEDIO_AUDIO,
	BAV_STREAM_AUDIO,
	BAV_STREAM_VEDIO_CONFERENCE,
	BAV_STREAM_P2P,
}BAV_STREAM_TYPE;

typedef enum 
{
    BAV_LOG_LEVEL_OFF    ,
    BAV_LOG_LEVEL_ERROR  ,
    BAV_LOG_LEVEL_WARN   ,
    BAV_LOG_LEVEL_INFO   ,
    BAV_LOG_LEVEL_DEBUG  ,
    BAV_LOG_LEVEL_TRACE 
}BAV_LOG_LEVEL;

/**	@enum	 BAV_CONFIG_TYPE
 *	@brief   配置类型定义
 *	@note
 */
typedef enum
{
	BAV_CONFIG_QOS_CC = 0,					//QOS拥塞控制开关，默认开启
	BAV_CONFIG_AUDIO_MIX = 1,				//音频混音控制开关，默认开启
	BAV_CONFIG_NETEQ = 2,					//NETEQ开关，默认开启
	BAV_CONFIG_ETP_MTU = 3,					//设置etp mtu，默认1200,范围[500,1400]
    BAV_CONFIG_SEND_CUSTOM_NET_QUALITY = 4, //允许发送自定义上传下载网络质量数据
	BAV_CONFIG_RECONNECT = 5,				//会议模式中，重连开关，默认开启
	BAV_CONFIG_JOIN_STREAM_HEADER = 6,		//会议模式中，加入房间时上抛流头
	BAV_CONFIG_CLOSE_SUBAUDIO = 7,			//会议模式中，关闭自动订阅音频
	BAV_CONFIG_OUTPUT_H264 = 8,				//数据回调是否返回H264数据，默认返回RTP视频包
	BAV_CONFIG_SUBSCRIBE_TIMEOUT = 9,		//订阅响应超时时间配置(ms)，默认8000ms
	BAV_CONFIG_CLOSE_SUBVIDEO_SWITCH = 10,	//会议模式中，关闭自动切换订阅视频
	BAV_CONFIG_EZRTC_SET_THREAD_NUMBER = 11,//设置ezrtc线程个数，条件：只能设置一次， 最大25. 进入房间前设置
	BAV_CONFIG_CLIENT_ROLE = 12				//enterroom之前调用BavSetSessionConfig进行设置角色类型
}BAV_CONFIG_TYPE;

typedef struct Audio_Info							//音频信息
{
	YS_UINT16			m_sAudioFormat;				// 音频编码类型
	YS_UINT32			m_uAudioSamplesrate;		// 采样率 
	YS_UINT32			m_uAFrameInterval;			// 音频的帧间间隔
	YS_UINT64			m_lTimeStamp;				// 时间戳
	YS_UINT8			m_szUuid[128];				// uuid
#ifdef QOS_NPQ_BAV
	NPQ_AUDIO_DECODE_FUN m_oRegisterFun;			// 解码回调函数
#endif
} Bav_Audio_Info;

typedef struct SBavClientInfo
{
	BAV_CLIENT_ROLE	m_iCltRole;												//必填	0 发起 1 接收 发起端填写0 接收端填写1
	BAV_STREAM_TYPE	m_enStreamType;											//必选	0 音视频 1 对讲  #BAV_STREAM_VEDIO_CONFERENCE
	YS_UINT8		m_szIsNpq;												//选择  0 不走NPQ，走TCP; 1 是NPQ，走UDP; 2 是YS QOS
	YS_UINT8		m_iCltType;												//必填	客户端类型
	YS_UINT8		m_iOtherCltType;										//选择	对端是手表端需填写1,设备是27
	YS_UINT8		m_iAuthType;											//必填	认证方式，#BAV_AUTH_TYPE
	YS_INT16		m_sDevStreamType;										//选择	设备主子码类型
	YS_UINT16		m_iStsPort;												//必填	转发服务端口
	YS_UINT32		m_iNetTimeOut;											//必填  连接服务超时时间 单位s
	YS_UINT32		m_iTryCount;											//必填  连接服务失败重试次数
	YS_UINT32		m_sChannel;												//选择	通道号
	YS_UINT32		m_iReason;												//选择	原因
	YS_UINT32		m_iRoomId;												//选择	需要加入房间号，只有接受端需要填写
	YS_UINT32		m_iMinBitrate;											//必填	最小码率 单位bps
	YS_UINT32		m_iMaxBitrate;											//必填	最大码率 单位bps
	YS_UINT32		m_iType;												//选择  参考BAV_QOS_TYPE
	YS_UINT32		m_iVideo;												//选择  是否开启视频Qos  1 开启 0 不开启
	YS_UINT32		m_iAudio;                                               //选择  是否开启音频Qos	 1 开启 0 不开启
	YS_INT8			m_szOterId[STREAM_DEV_SERIAL_LEN + 1];					//选择	只有对端是手表端需填写
	YS_INT8			m_szSelfId[SELFID_LEN + 1];					            //必填	标识Id
	YS_INT8			m_szAuthToken[STREAM_TOKEN_LEN + 1];					//必填	认证token
	YS_INT8			m_szStsAddr[CLIENT_STREAM_SVR_ADDR_LEN + 1];			//必填	转发服务地址
	YS_INT8			m_szStreamHead[STREAM_HEAD + 1];						//必填	海康协议头
	YS_INT8			m_szFilePath[FLIEPATH + 1];								//选择  写文件的路径
	YS_INT8			m_szPublicKey[SIGNAL_SECRETKEY_LEN + 1];			    //选择  信令公钥base64
	YS_UINT32       m_iPublicKeyVersion;                                    //选择  信令版本与信令公钥一起填写
	void*			m_pUser;												//必填  用户数据
	BavMsgCallback	m_pMsgCb;												//必填	消息回调函数
	BavDataCallback	m_pDataCb;												//必填	数据回调函数
	YS_UINT32		m_uClientId;											//必填	视频会议必填
	YS_UINT32		m_uConferenceMaxCount;									//必填	视频会议必填
	YS_UINT16		m_iVcPort;												//必填	视频会议必填 会控服务端口
	YS_INT8			m_szVcAddr[CLIENT_STREAM_SVR_ADDR_LEN + 1];			    //必填	视频会议必填 会控服务地址
	YS_INT8			m_szExtensionParas[CLIENT_STREAM_EXTENSION_LEN + 1];	//选择	扩展字段信息
}SBavClientInfo;

typedef struct SBavClientInfo_VC
{
    YS_INT8		    m_szAppId[CUSTOMID_LEN + 1];							//必填	项目ID
    YS_INT8		    m_szUserRoomId[CUSTOMID_LEN + 1];						//必填	用户定义的房间号
	YS_UINT32		m_iRoomId;												//必填	需要加入房间号
	YS_UINT32		m_uClientId;										    //必填	加入方clientId
	YS_INT8		    m_szCustomId[CUSTOMID_LEN + 1];							//选择	加入方自定义Id
	YS_INT8			m_szPassword[STREAM_TOKEN_LEN + 1];					    //必填	房间密码
    YS_UINT8		m_iAuthType;											//必填	认证方式，#BAV_AUTH_TYPE
	YS_UINT8		m_iCltType;												//必填	客户端类型
	YS_UINT16		m_iStsPort;												//必填	转发服务端口
	YS_INT8			m_szStsAddr[CLIENT_STREAM_SVR_ADDR_LEN + 1];			//必填	转发服务地址
	YS_UINT16		m_iVcPort;												//必填	会控服务端口
	YS_INT8			m_szVcAddr[CLIENT_STREAM_SVR_ADDR_LEN + 1];			    //必填	会控服务地址
	YS_INT8			m_szFilePath[FLIEPATH + 1];								//选择  写文件的路径
	YS_INT8			m_iAudioType;											//选择  音频编码类型,1:AAC,2:OPUS #BAV_AUDIO_ENCODE_TYPE
	YS_INT8			m_szPublicKey[SIGNAL_SECRETKEY_LEN + 1];			    //选择  信令公钥base64
	YS_UINT32       m_iPublicKeyVersion;                                    //选择  信令版本与信令公钥一起填写
	void*			m_pUser;												//必填  用户数据
	BavMsgCallback	m_pMsgCb;												//必填	消息回调函数
	BavDataCallback	m_pDataCb;												//必填	数据回调函数
	YS_INT8			m_szExtensionParas[CLIENT_STREAM_EXTENSION_LEN + 1];	//选择	扩展字段信息
	YS_INT8			m_szAdapteParas[CLIENT_STREAM_EXTENSION_LEN + 1];		//选择   适配信息
}SBavClientInfo_VC;

/**
*  测速参数
*/
typedef struct SBavSpeedTestParams {
    YS_UINT16		m_iStsPort;												//必填  转发服务端口
    YS_INT8			m_szStsAddr[CLIENT_STREAM_SVR_ADDR_LEN + 1];			//必填  转发服务地址
    YS_INT8			m_szPassword[STREAM_TOKEN_LEN + 1];					    //必填  房间密码
	YS_INT8			m_szPublicKey[SIGNAL_SECRETKEY_LEN + 1];			    //选择  信令公钥base64
	YS_UINT32       m_iPublicKeyVersion;                                    //选择  信令版本与信令公钥一起填写
    YS_UINT32       m_expectedUpBandwidth;                                  //必填  预期的上行带宽（kbps，取值范围： 10 ～ 12288，为 0 时不测试）。
    YS_UINT32       m_expectedDownBandwidth;                                //必填  预期的下行带宽（kbps，取值范围： 10 ～ 12288，为 0 时不测试）。
    YS_UINT32       m_testInterval;                                         //必填  统计间隔（毫秒）,取值范围1000ms~60000ms

    void*			m_pUser;												//必填  用户数据
	BavMsgCallback	m_pMsgCb;												//必填  消息回调函数
	YS_INT8			m_szExtensionParas[CLIENT_STREAM_EXTENSION_LEN + 1];	//选择	扩展字段信息
}SBavSpeedTestParams;

typedef struct SBavDevInfo
{
	YS_INT8			m_szDevSerial[STREAM_DEV_SERIAL_LEN + 1];			    //必填	设备序列号
	YS_UINT32		m_sChannel;												//必填	通道号
	YS_INT16		m_sDevStreamType;										//必填	设备主子码类型
	YS_INT8			m_szAuthToken[STREAM_TOKEN_LEN + 1];					//必填	认证token
	YS_UINT16		m_iStsPort;												//必填	转发服务端口
	YS_INT8			m_szStsAddr[CLIENT_STREAM_SVR_ADDR_LEN + 1];			//必填	转发服务地址
}SBavDevInfo;

typedef struct SBavP2PIp
{
    YS_INT8         m_P2PAddress[CLIENT_STREAM_SVR_ADDR_LEN + 1];           //必填 ipv4 地址 
    YS_UINT32       m_iP2Pport;                                             //必填 port 断开
}SBavP2PIp;

typedef struct SBavClientInfo_P2P
{
	YS_UINT32		m_iRoomId;												//选填	需要加入房间号
	YS_UINT32		m_uClientId;										    //选填	加入方clientId
	YS_INT8		    m_szCustomId[CUSTOMID_LEN + 1];							//必填	加入方自定义Id
	YS_INT8			m_szPassword[STREAM_TOKEN_LEN + 1];					    //选填	房间密码
	YS_INT8			m_szSecretKey[STREAM_SECRETKEY_LEN + 1];			    //必填	加密密钥
	YS_UINT8		m_iCltType;												//必填	客户端类型
	YS_INT8			m_szFilePath[FLIEPATH + 1];								//选填  写文件的路径
	void*			m_pUser;												//必填  用户数据
	BavMsgCallback	m_pMsgCb;												//必填	消息回调函数
	BavDataCallback	m_pDataCb;												//必填	数据回调函数
	YS_INT8			m_szExtensionParas[CLIENT_STREAM_EXTENSION_LEN + 1];	//选填	扩展字段信息
}SBavClientInfo_P2P;

typedef enum P2P_ROLE
{
    BAV_P2P_ROLE_ANSWER,
    BAV_P2P_ROLE_CALLER,
}BAV_P2P_ROLE;

typedef struct SBavInputAudioData
{
    BAV_CLIENT_STREAM_TYPE eStreamType;                                     //必填	数据类型
    YS_UINT8* pData;                                                        //必填	数据指针
    YS_UINT32 nDataLen;                                                     //必填	数据长度
    YS_UINT32 lTimestamp;                                                   //选填	时间戳，用于rtp打包
    YS_UINT32 nAudioLevel;                                                  //选填	如果音频时，音量大小
}SBavInputAudioData;

typedef struct SBavInputVideoData
{
    BAV_CLIENT_STREAM_TYPE eStreamType;                                     //必填	数据类型
    YS_UINT8* pData;                                                        //必填	数据指针
    YS_UINT32 nDataLen;                                                     //必填	数据长度
    YS_UINT32 lTimestamp;                                                   //选填	时间戳，用于rtp打包
    YS_UINT32 nRotation;                                                    //选填	传入旋转角度,标准的旋转的角度只有四挡：0°、90°、180°和270°
}SBavInputVideoData;

/**
* 网络测速结果
*
* 您可以在用户进入房间前通过 {@link startSpeedTest:} 接口进行测速（注意：请不要在通话中调用）。
*/
typedef struct SBavSpeedTestResult {
    ///测试是否成功。
    bool success;

    ///内部通过评估算法测算出的网络质量，更多信息请参见 {@link BAV_NETWORK_QUALITY_TYPE}。
    BAV_NETWORK_QUALITY_TYPE quality;

    ///上行丢包率，取值范围是 [0 - 100]，例如 30% 表示每向服务器发送 10 个数据包可能会在中途丢失 3 个。
    YS_UINT32 upLostRate;

    ///下行丢包率，取值范围是 [0 - 100]，例如 20% 表示每从服务器收取 10 个数据包可能会在中途丢失 2 个。
    YS_UINT32 downLostRate;

    ///延迟（毫秒），指当前设备到 服务器的一次网络往返时间，该值越小越好，正常数值范围是10ms - 100ms。
    YS_UINT32 rtt;

    ///上行带宽（kbps，-1：无效值）。
    YS_UINT32 availableUpBandwidth;

    ///下行带宽（kbps，-1：无效值）。
    YS_UINT32 availableDownBandwidth;

    ///流媒体服务器连接情况,0:连接失败，1：连接成功
    YS_UINT32 stsConnect;
}SBavSpeedTestResult;

/**	@struct SBavEncryptInfo
 *  @brief  客户端公私钥信息
 */
typedef struct
{
	YS_UINT8*     pPublicKey;                       ///< 客户端公钥, 用于全链路加密
	YS_UINT32     pPublicKeyLen;                    ///< 客户端公钥长度, 用于全链路加密
	YS_UINT8*     pPrivateKey;                      ///< 客户端私钥, 用于全链路加密
	YS_UINT32     pPrivateKeyLen;                   ///< 客户端私钥长度, 用于全链路加密
}SBavEncryptInfo;


/* @note decode输入帧的格式说明如下
 *
 * AAC: 起始为adts头(7字节)，后面是完整的AAC编码帧，目前规格都是 16K/mono, LC profile
 * OPUS: 完整的AAC编码帧，目前规格都是 48K/mono
 * G711U/A: 完整的G711编码帧，目前规格都是 8K/mono
 */

enum BavExternalAudioDecodeType
{
    BAV_AUDIO_CODEC_TYPE_AAC = 1,
    BAV_AUDIO_CODEC_TYPE_OPUS = 2,
    BAV_AUDIO_CODEC_TYPE_G711U = 3,
    BAV_AUDIO_CODEC_TYPE_G711A = 4,
};

typedef struct
{
    enum BavExternalAudioDecodeType type;
    int sample_rate;
    int channel_num;
} BavExternalAudioDecodeParam;

/** @brief 萤石设备音频解码回调接口定义
 *
 * @param[in] type 编码类型 1:aac 2:opus 3:G711U 4:G711A
 * @param[in] sample_rate 音频采样率
 * @param[in] channel_num 音频频道数
 * @param[in] encoded 音频编码帧数据
 * @param[in] encoded_len 音频编码帧数据长度
 * @param[out] decoded 解码输出PCM数据buffer, PCM采样固定为 S16LE
 * @param[in] decoded_len 输入时为PCM数据buffer长度
 * @param[out] decoded_len 输出时为解码数据的有效长度
 *
 * @retval: 0 表示解码成功
 * @retval: <0 表示失败
 */
typedef int (*BavExternalAudioDecodeCallBack)(int type, int sample_rate, int channel_num, const YS_UINT8* encoded, size_t encoded_len, YS_UINT8 *decoded, int *decoded_len);


/******************************************************************************/
/*  房间管理相关接口                                                          */
/******************************************************************************/

/** @fn GLOBAL_API BAV_CLIENT_HANDLE  BavStart(
 * 					const SBavClientInfo* pBavClientInfo, 
 * 					Bav_Audio_Info* pBavAudioInfo)
 *
 *  @brief      开启双向对讲、双向音视频、多人音视频接口-[老接口]
 *  @param[in]  pBavClientInfo        创建参数，参考SBavClientInfo
 *  @param[in]  pBavAudioInfo         双向对讲参数，参考Bav_Audio_Info
 *  @return     Bav会话句柄, 成功; 0, 失败
 *  @sa         BavStop
 */
GLOBAL_API BAV_CLIENT_HANDLE		BavStart(const SBavClientInfo* pBavClientInfo, Bav_Audio_Info* pBavAudioInfo);

/**
 *  @brief      开启双向对讲、双向音视频
 *  @param[in]  iHandle        		  Bav会话句柄
 *  @param[in]  pBavClientInfo        创建参数，参考SBavClientInfo
 *  @param[in]  pBavAudioInfo         双向对讲参数，参考Bav_Audio_Info
 *  @return     Bav会话句柄, 成功; 0, 失败
 *  @sa         BavStop
 */
GLOBAL_API YS_INT32		            BavStart1V1(BAV_CLIENT_HANDLE iHandle, const SBavClientInfo* pBavClientInfo, Bav_Audio_Info* pBavAudioInfo);

/** @fn GLOBAL_API YS_INT32  BavStop(
 * 					BAV_CLIENT_HANDLE iHandle, 
 * 					YS_UINT32	iReason)
 *
 *  @brief      停止双向对讲、双向音视频、多人音视频接口-[老接口]
 *  @param[in]  iHandle        Bav会话句柄
 *  @param[in]  iReason        停止会话的原因，主动停止参数需填写 BAV_CLIENT_EVENT_USER_STOPS
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 *  @sa         BavStart
 */
GLOBAL_API YS_INT32					BavStop(BAV_CLIENT_HANDLE iHandle, YS_UINT32 iReason);

/** @fn GLOBAL_API BAV_CLIENT_HANDLE  BavCreate()
 *
 *  @brief      创建Bav会话句柄,用于[多方音视频通话]
 *  @return     Bav会话句柄, 成功; 0, 失败
 *  @sa         BavEnterRoom，BavRelease
 */
GLOBAL_API BAV_CLIENT_HANDLE        BavCreate();

/** @fn GLOBAL_API YS_INT32  BavRelease(BAV_CLIENT_HANDLE iHandle)
 *
 *  @brief      释放Bav会话句柄,用于[多方音视频通话]
 *  @param[in]  iHandle        Bav会话句柄
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 *  @sa         BavExitRoom，BavCreate
 */
GLOBAL_API YS_INT32                 BavRelease(BAV_CLIENT_HANDLE iHandle);

/** @fn GLOBAL_API YS_INT32  BavEnterRoom(
 * 					const SBavClientInfo_VC* pBavClientInfo)
 *
 *  @brief      开启多人音视频通话-异步接口,用于[多方音视频通话]
 *  @param[in]  pBavClientInfo        创建参数，参考SBavClientInfo_VC
 *  @return     Bav会话句柄, 成功; 0, 失败
 *  @sa         BavExitRoom
 *  @note       加入成功会产生BavMsgCallback---BAV_CLIENT_EVENT_JOIN_ROOM_OK消息
 */
GLOBAL_API YS_INT32		            BavEnterRoom(BAV_CLIENT_HANDLE iHandle, const SBavClientInfo_VC* pBavClientInfo);

/** @fn GLOBAL_API YS_INT32  BavExitRoom(
 * 					BAV_CLIENT_HANDLE iHandle, 
 * 					YS_UINT32	iReason)
 *
 *  @brief      停止多人音视频通话-同步接口,用于[多方音视频通话]
 *  @param[in]  iHandle        Bav会话句柄
 *  @param[in]  iReason        停止会话的原因，主动停止参数需填写 BAV_CLIENT_EVENT_USER_STOPS
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 *  @sa         BavEnterRoom
 */
GLOBAL_API YS_INT32					BavExitRoom(BAV_CLIENT_HANDLE iHandle, YS_UINT32 iReason);

/** @fn GLOBAL_API YS_INT32  BavInviteDev(
 * 					BAV_CLIENT_HANDLE iHandle, 
 * 					, SBavDevInfo *pBavDevInfo)
 *
 *  @brief      邀请设备加入多人音视频通话-异步接口,用于[多方音视频通话]
 *  @param[in]  iHandle        Bav会话句柄
 *  @param[in]  pBavDevInfo    邀请加入的设备信息，参考SBavDevInfo
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 *  @sa         BavEnterRoom
 *  @note       加入成功会产生BavMsgCallback---BAV_CLIENT_EVENT_CLIENT_JOIN_ROOM消息
 */
GLOBAL_API YS_INT32					BavInviteDev(BAV_CLIENT_HANDLE iHandle, SBavDevInfo *pBavDevInfo);

/** @fn GLOBAL_API YS_INT32  BavDissolveRoom(
 * 					BAV_CLIENT_HANDLE iHandle)
 *
 *  @brief      解散房间，房间内所有人需要退出房间,用于[多方音视频通话]
 *  @param[in]  iHandle        Bav会话句柄
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 *  @sa         BavEnterRoom
 *  @note       解散成功会产生BavMsgCallback---BAV_CLIENT_EVENT_BAV_CLIENT_MOVE_OUT---BAV_MOVE_OUT_ROOM_DISSOLVED消息
 *  @note       [接收到BAV_MOVE_OUT_ROOM_DISSOLVED,需要上层主动调用BavExitRoom]
 */
GLOBAL_API YS_INT32					BavDissolveRoom(BAV_CLIENT_HANDLE iHandle);

#if defined(ANDROID)

/** @fn GLOBAL_API YS_INT32  BavP2PStart(
 * 					BAV_CLIENT_HANDLE iHandle, 
 * 					const SBavClientInfo_P2P *pBavClientInfo)
 *
 *  @brief      开启P2P通话,用于[P2P通话]
 *  @param[in]  pBavClientInfo        创建参数，参考SBavClientInfo_P2P
 *  @return     Bav会话句柄, 成功; 0, 失败
 *  @sa         BavP2PStop
 *  @note       加入成功会产生BavMsgCallback---BAV_CLIENT_EVENT_JOIN_ROOM_OK消息
 */
GLOBAL_API YS_INT32                 BavP2PStart(BAV_CLIENT_HANDLE iHandle, const SBavClientInfo_P2P *pBavClientInfo);

/** @fn GLOBAL_API YS_INT32  BavP2PStop(
 * 					BAV_CLIENT_HANDLE iHandle, 
 * 					YS_UINT32	iReason)
 *
 * 
 *  @brief      停止P2P通话-同步接口,用于[P2P通话]
 *  @param[in]  iHandle        Bav会话句柄
 *  @param[in]  iReason        停止会话的原因，主动停止参数需填写 1
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 *  @sa         BavP2PStart
 */
GLOBAL_API YS_INT32                 BavP2PStop(BAV_CLIENT_HANDLE iHandle, YS_UINT32 iReason);

#endif

/******************************************************************************/
/*  公共接口                                                          */
/******************************************************************************/
/** @fn GLOBAL_API YS_INT32  BavTransferInfo(
 * 					BAV_CLIENT_HANDLE iHandle, 
 *                  YS_UINT8* pData, 
 *                  YS_INT32 nDataLen)
 *
 *  @brief      透传信息接口
 *  @param[in]  iHandle         Bav会话句柄
 *  @param[in]  pData           透传数据指针
 *  @param[in]  nDataLen        透传数据长度
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 */
GLOBAL_API YS_INT32					BavTransferInfo(BAV_CLIENT_HANDLE iHandle, YS_UINT8* pData, YS_INT32 nDataLen);

/** @fn GLOBAL_API YS_INT32  BavInputData(
 * 					BAV_CLIENT_HANDLE iHandle, 
 *                  YS_UINT8* pData, 
 *                  YS_UINT32 nDataLen, 
 *                  YS_UINT32 lTimestamp, 
 *                  BAV_CLIENT_STREAM_TYPE eStreamType)
 *
 *  @brief      音视频流数据推送接口
 *  @param[in]  iHandle         Bav会话句柄
 *  @param[in]  pData           流数据指针
 *  @param[in]  nDataLen        流数据长度
 *  @param[in]  lTimestamp      流数据时间戳，用于rtp打包
 *  @param[in]  eStreamType     流数据类型参考BAV_CLIENT_STREAM_TYPE
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 */
GLOBAL_API YS_INT32					BavInputData(BAV_CLIENT_HANDLE iHandle, YS_UINT8* pData, YS_UINT32 nDataLen, YS_UINT32 lTimestamp, BAV_CLIENT_STREAM_TYPE eStreamType);

/**
*  @brief      音频流数据推送接口
*  @param[in]  iHandle         Bav会话句柄
*  @param[in]  inputData       传入信息
*  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
*/
GLOBAL_API YS_INT32					BavInputAudioData(BAV_CLIENT_HANDLE iHandle, SBavInputAudioData inputData);

/**
*  @brief      视频流数据推送接口
*  @param[in]  iHandle         Bav会话句柄
*  @param[in]  inputData       传入信息
*  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
*/
GLOBAL_API YS_INT32					BavInputVideoData(BAV_CLIENT_HANDLE iHandle, SBavInputVideoData inputData);

/**
*  @brief      计算音频音量
*  @param[in]  pData           流数据指针(PCM数据)
*  @param[in]  nDataLen        流数据长度
*  @return     音量
*/
GLOBAL_API YS_INT32					BavCalcAudioLevel(YS_UINT8* pData, YS_UINT32 nDataLen);


/**
*  @brief      启用音量大小回调
*  @param[in]  interval         设置音量回调的触发间隔，单位为ms，最小间隔为100ms
*  @return     
*/
GLOBAL_API void 					BavEnableAudioVolumeEvaluation(YS_UINT32 interval);

/**
*  @brief      设置通话质量回调间隔（>=1000ms）
*  @param[in]  interval         通话质量回调的触发间隔，单位为ms，最小间隔为1000ms
*  @return
*/
GLOBAL_API void 					BavSetQualityInterval(YS_UINT32 interval);

/** @fn GLOBAL_API YS_INT32  BavSetBavLogFile(
 * 					YS_INT8* pBavLogPath)
 *
 *  @brief      日志存储路径设置接口（未启用，默认使用开启接口中的日志回调）
 *  @param[in]  pBavLogPath     存储路径
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 */
GLOBAL_API YS_INT32					BavSetBavLogFile(YS_INT8* pBavLogPath);

/** @fn GLOBAL_API YS_INT32  BavSetDefaultRecvMode(
 * 					BAV_CLIENT_HANDLE iHandle, 
 * 					bool autoRecvAudio, 
 * 					bool autoRecvVideo)
 *
 *  @brief      关闭\开启订阅远端视频，用于关闭或开启订阅远端视频，视频数据由数据回调返回,用于[多方音视频通话]
 *  @param[in]  iHandle             Bav会话句柄
 *  @param[in]  autoRecvAudio       是否默认订阅音频数据
 *  @param[in]  autoRecvVideo       是否默认订阅视频数据
 *  @note       默认autoRecvAudio为true，autoRecvVideo为false
 *  @note       [此接口需要在EnterRoom前调用]
 *  @sa         BavEnterRoom
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 */
GLOBAL_API YS_INT32					BavSetDefaultRecvMode(BAV_CLIENT_HANDLE iHandle, bool autoRecvAudio, bool autoRecvVideo);

/** @fn GLOBAL_API YS_INT32  BavSetBavLogLevel(
 * 					BAV_LOG_LEVEL level)
 *
 *  @brief      设置日志等级，全局接口
 *  @param[in]  level        输出日志等级，参考BAV_LOG_LEVEL
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 */
GLOBAL_API YS_INT32					BavSetBavLogLevel(BAV_LOG_LEVEL level);

/**
* @brief    设置log回调函数接口
* @param	BavLogCallback cb 回调函数指针
* @return 	N/A
*/
GLOBAL_API void						BavSetLogCallBack(BavLogCallback cb);



/**
 *  @brief      设置日志等级，全局接口
 *  @param[in]  type   配置类型#BAV_CONFIG_TYPE
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 */
GLOBAL_API YS_INT32					BavSetConfig(BAV_CONFIG_TYPE type, int value);


/** @fn GLOBAL_API YS_INT32	BavGetCallStatistics(
 * 					BAV_CLIENT_HANDLE iHandle,
 * 					YS_UINT8 *pStatistics,
 * 					YS_UINT32 uLength)
 *
 *  @brief      手动获取通话统计数据接口,调用该接口后会停止数据上报
 *  @param[in]      iHandle         Bav会话句柄
 *  @param[out]     pStatistics     统计数据，需要调用方创建释放
 *  @param[in out]  uLength         数据长度，传入为创建的长度 传出为实际使用长度
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 */
GLOBAL_API YS_INT32					BavGetCallEndStatistics(BAV_CLIENT_HANDLE iHandle, YS_UINT8* pStatistics, YS_UINT32 uLength);

/******************************************************************************/
/*  音频管理相关接口                                                          */
/******************************************************************************/

/** @fn GLOBAL_API YS_INT32  BavRemoteAudio(
 * 					BAV_CLIENT_HANDLE iHandle, 
 * 					YS_UINT32 uClient,
 * 					bool bMute)
 *
 *  @brief      关闭\开启远端音频，用于关闭或开启远端声音,用于[多方音视频通话]
 *  @param[in]  iHandle        Bav会话句柄
 *  @param[in]  uClient        需要关闭\开启的远端用户clientID
 *  @param[in]  bMute          true：静音，false：取消静音。
 */
GLOBAL_API void						BavRemoteAudio(BAV_CLIENT_HANDLE iHandle, YS_UINT32 uClient,bool bMute);

/** @fn GLOBAL_API YS_INT32  BavSetAudioFrameInterval(
 * 					BAV_CLIENT_HANDLE iHandle, 
 *                  YS_UINT32 uAFrameInterval)
 *
 *  @brief      音频帧rtp打包时间戳间隔设置接口，用于[双向对讲]
 *  @param[in]  iHandle         Bav会话句柄
 *  @param[in]  uAFrameInterval 音频帧打包时间戳间隔
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 */
GLOBAL_API YS_INT32					BavSetAudioFrameInterval(BAV_CLIENT_HANDLE iHandle, YS_UINT32 uAFrameInterval);

/** @fn GLOBAL_API void  BavLocalAudio(
 * 					BAV_CLIENT_HANDLE iHandle, 
 *                  bool bMute)
 *
 *  @brief      关闭\开启本地音频，用于通知其他与会方本地音频状态,用于[多方音视频通话]
 *  @param[in]  iHandle         Bav会话句柄
 *  @param[in]  bMute           false：开启，true：关闭
 */
GLOBAL_API void						BavLocalAudio(BAV_CLIENT_HANDLE iHandle, bool bMute);

/******************************************************************************/
/*  视频管理相关接口                                                          */
/******************************************************************************/

/** @fn GLOBAL_API YS_INT32  BavFarEndForceIFrame(
 * 					BAV_CLIENT_HANDLE iHandle)
 *
 *  @brief      强制远端I帧，用于双向音视频通话-[老接口]
 *  @param[in]  iHandle        Bav会话句柄
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 */
GLOBAL_API YS_INT32					BavFarEndForceIFrame(BAV_CLIENT_HANDLE iHandle);

/** @fn GLOBAL_API void  BavShareScreen(
 * 					BAV_CLIENT_HANDLE iHandle, 
 * 					YS_INT8*  pShareScreenName,
 * 					YS_INT16 iType)
 *
 *  @brief      关闭\开启屏幕共享，用于关闭或开启本地屏幕共享，是否可以开启屏幕共享结果由消息回调确认,用于[多方音视频通话]
 *  @param[in]  iHandle             Bav会话句柄
 *  @param[in]  pShareScreenName    需要屏幕共享的名称
 *  @param[in]  iType               1：开启，0：关闭（自己）, 3：强制关闭（他人） #BAV_SHARE_TYPE
 *  @note       1-开启：自己会产生BAV_CLIENT_EVENT_SCREEN_SHARE_INFO消息（m_iType=BAV_SHARE_OPEN）
 *				3-强制关闭：他人会收到BAV_CLIENT_EVENT_SCREEN_SHARE_INFO消息（m_iType=BAV_SHARE_STOP）
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 */
GLOBAL_API void						BavShareScreen(BAV_CLIENT_HANDLE iHandle,YS_INT8* pShareScreenName,YS_INT16 iType);

/** @fn GLOBAL_API void  BavSubRemoteStreams(
 * 					BAV_CLIENT_HANDLE iHandle, 
 * 					YS_UINT32* pClientId, 
 * 					YS_UINT32 uCount, 
 * 					BAV_SUB_STREAM_TYPE eSubStreamType,
 * 					bool bSub)
 *
 *  @brief      关闭\开启订阅远端视频，用于关闭或开启订阅远端视频，视频数据由数据回调返回,用于[多方音视频通话]
 *  @param[in]  iHandle             Bav会话句柄
 *  @param[in]  pClientId           需要关闭\开启订阅的用户clientId数据
 *  @param[in]  uCount              需要关闭\开启订阅的用户个数
 *  @param[in]  eSubStreamType      需要关闭\开启订阅的视频类型，参考BAV_SUB_STREAM_TYPE，同时只支持订阅一种视频流
 *  @param[in]  bSub                false：关闭，true：开启
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 */
GLOBAL_API void						BavSubRemoteStreams(BAV_CLIENT_HANDLE iHandle,YS_UINT32* pClientId, YS_UINT32 uCount, BAV_SUB_STREAM_TYPE eSubStreamType,bool bSub);

/** @fn GLOBAL_API void  BavSubAllRemoteStreams(
 * 					BAV_CLIENT_HANDLE iHandle, 
 * 					BAV_SUB_STREAM_TYPE eSubStreamType,
 * 					bool bSub)
 *
 *  @brief      关闭\开启订阅远端视频，用于关闭或开启订阅远端视频，视频数据由数据回调返回,用于[多方音视频通话](暂不支持)
 *  @param[in]  iHandle             Bav会话句柄
 *  @param[in]  eSubStreamType      需要关闭\开启订阅的视频类型，参考BAV_SUB_STREAM_TYPE，同时只支持订阅一种视频流
 *  @param[in]  bSub                false：关闭，true：开启
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 */
GLOBAL_API void						BavSubAllRemoteStreams(BAV_CLIENT_HANDLE iHandle, BAV_SUB_STREAM_TYPE eSubStreamType,bool bSub); //新版本取消掉

/** @fn GLOBAL_API YS_INT32  BavLocalVideo(
 * 					BAV_CLIENT_HANDLE iHandle, 
 *                  BAV_SUB_STREAM_TYPE ability)
 *
 *  @brief      关闭\开启本地视频，用于通知其他与会方本地视频状态,用于[多方音视频通话]
 *  @param[in]  iHandle         Bav会话句柄
 *  @param[in]  ability         支持BAV_LOCAL_STREAM_INVALID、BAV_LOCAL_STREAM_BIG_VEDIO、BAV_LOCAL_STREAM_BIG_VEDIO|BAV_LOCAL_STREAM_MIN_VEDIO
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 */
GLOBAL_API YS_INT32					BavLocalVideo(BAV_CLIENT_HANDLE iHandle, BAV_SUB_STREAM_TYPE ability);


/** 
*  @brief      设置发送端传输通道的码率
*  @param[in]  iHandle         Bav会话句柄
*  @param[in]  ability         #BAV_SUB_STREAM_TYPE
*  @param[in]  bitrate         发送最大码率，单位为bps
*  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
*/
GLOBAL_API YS_INT32					BavSetSendTransportBitrate(BAV_CLIENT_HANDLE iHandle, BAV_SUB_STREAM_TYPE ability, YS_UINT32 bitrate);


/**
*  @brief      发送自定义消息给房间内所有用户
*  @param[in]  iHandle         Bav会话句柄
*  @param[in]  data 待发送的消息，单个消息的最大长度被限制为 1KB。
*  @param[in]  dataSize 数据长度
*  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
*/
GLOBAL_API YS_INT32                 BavSendCustomMsg(BAV_CLIENT_HANDLE iHandle, YS_UINT8* data, YS_UINT32 dataSize);

/**
*  @brief      发送自定义消息给房间内指定用户
*  @param[in]  iHandle         Bav会话句柄
*  @param[in]  data 待发送的消息，单个消息的最大长度被限制为 1KB。
*  @param[in]  dataSize 数据长度
*  @param[in]  pClientIds 需要接受消息的clientId数组
*  @param[in]  uCount clientId 数量
*  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
*/
GLOBAL_API YS_INT32                 BavSendCustomMsgToClients(BAV_CLIENT_HANDLE iHandle, YS_UINT8* data, YS_UINT32 dataSize, YS_UINT32* pClientIds, YS_UINT32 uCount);


/**
*  @brief      发送服务自定义消息给房间内指定用户
*  @param[in]  iHandle         Bav会话句柄
*  @param[in]  data 待发送的消息，单个消息的最大长度被限制为 1KB。
*  @param[in]  dataSize 数据长度
*  @param[in]  pClientIds 需要接受消息的clientId数组
*  @param[in]  uCount clientId 数量
*  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
*/
GLOBAL_API YS_INT32                 BavSendServerMsgToClients(BAV_CLIENT_HANDLE iHandle, YS_UINT8* data, YS_UINT32 dataSize, YS_UINT32* pClientIds, YS_UINT32 uCount);


/**
*  @brief      开始通话前检测
*  @param[in]  params 测速选项
*  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
*/
GLOBAL_API YS_INT32                 BavStartSpeedTest(SBavSpeedTestParams* params);

/**
*  @brief      结束通话前检测
*  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
*/
GLOBAL_API YS_INT32                 BavStopSpeedTest();

/**
*  @brief      设置客户端的加密公私钥
*  @param[in]  pEncryptInfo         密钥结构体参考SBavEncryptInfo
*  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
*/
GLOBAL_API YS_INT32                 BavSetClientPublicAndPrivateKey(SBavEncryptInfo *pEncryptInfo);

/**
*  @brief      设置网络改变通知
*  @param[in]  type  网络改变类型#BAV_NETWORK_CHANGE
*/
GLOBAL_API void						BavSetNetworkChange(BAV_NETWORK_CHANGE type);


/**
 *  @brief      设置回话基本信息
 *  @param[in]  type   配置类型#BAV_CONFIG_TYPE
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 */
GLOBAL_API YS_INT32					BavSetSessionConfig(BAV_CLIENT_HANDLE iHandle, BAV_CONFIG_TYPE type, int value);

/**
 * @brief 设置音频外部解码回调接口
 * @param callBack 回调接口地址
 */
GLOBAL_API void						BavSetExternalAudioDecodeCallBack(BavExternalAudioDecodeCallBack callBack);

#if defined(ANDROID)

/******************************************************************************/
/*  P2P相关接口                                                          */
/******************************************************************************/

/** @fn GLOBAL_API YS_INT32  BavP2PSetStunAddress(
 * 					SBavP2PIp *pStun1, 
 * 					SBavP2PIp *pStun2)
 *
 *  @brief      设置STUN服务地址, 用于[P2P通话],需要在p2pstart前设置，可选
 *  @param[in]  pStun1         stun地址1
 *  @param[in]  pStun2         stun地址2
 *  @sa         BavP2PStart
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 */
GLOBAL_API YS_INT32                 BavP2PSetStunAddress(SBavP2PIp *pStun1, SBavP2PIp *pStun2);

/** @fn GLOBAL_API YS_INT32  BavP2PSetLocalIp(
 * 					YS_UINT8 *pLocalIp)
 *
 *  @brief      设置本地IP地址, 用于[P2P通话],需要在p2pstart前设置，必选
 *  @param[in]  pLocalIp        本地IP地址
 *  @sa         BavP2PStart
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 */
GLOBAL_API YS_INT32                 BavP2PSetLocalIp(YS_UINT8 *pLocalIp);

/** @fn GLOBAL_API YS_INT32  BavP2PGetPunchInfo(
 * 					BAV_CLIENT_HANDLE iHandle, 
 *                  YS_UINT8 *pSelfPunchInfo, 
 * 					YS_INT32 *pDataLen)
 *
 *  @brief      获取会话创建端的会话数据，用于通知接收端,用于[P2P通话]，必选
 *  @param[in]  iHandle              Bav会话句柄
 *  @param[in]  role                 P2P角色
 *  @param[out] pSelfPunchInfo       获取发起会话端的透传数据
 *  @param[out] pDataLen             获取发起会话端的透传数据长度,64字节以上，建议128
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 *  @sa         BavP2PSetPeerConnPection
 *  @note       获取到该数据后需要将该数据传递到对端，对端需要通过BavP2pnetSetPeerConnectionReceiver设置该数据

 */
GLOBAL_API YS_INT32                 BavP2PGetPunchInfo(BAV_CLIENT_HANDLE iHandle, BAV_P2P_ROLE role, YS_UINT8 *pSelfPunchInfo, YS_INT32 *pDataLen);

/** @fn GLOBAL_API YS_INT32  BavP2PSetPeerConnPection(
 * 					BAV_CLIENT_HANDLE iHandle, 
 *                  YS_UINT8 *pPeerPunchInfo, 
 * 					YS_INT32 nDataLen)
 *
 *  @brief      设置会话创建端接收到的接收端会话数据，用于发起会话,用于[P2P通话]，必选
 *  @param[in]  iHandle              Bav会话句柄
 *  @param[in]  role                 P2P角色
 *  @param[in]  pPeerPunchInfo       设置发起会话后接收到的对端透传数据
 *  @param[in]  nDataLen             设置发起会话后接收到的对端透传数据长度
 *  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
 *  @sa         BavP2PGetPunchInfo
 */
GLOBAL_API YS_INT32                 BavP2PSetPeerConnPection(BAV_CLIENT_HANDLE iHandle, YS_UINT8 *pPeerPunchInfo, YS_INT32 nDataLen);
#endif

/**
*  @brief      发送自定义质量数据，主要网关服务端发送端到网关的质量数据
*  @param[in]  iHandle         Bav会话句柄
*  @param[in]  upQuality 上行网络质量 #BAV_NETWORK_QUALITY_TYPE
*  @param[in]  downQuality 下行网络质量 #BAV_NETWORK_QUALITY_TYPE
*  @return     BAV_CLIENT_SUC, 成功; BAV_CLIENT_ERROR, 失败
*/
GLOBAL_API YS_INT32                 BavSendCustomNetQuality(BAV_CLIENT_HANDLE iHandle, YS_UINT32 upQuality, YS_UINT32 downQuality);

#ifdef __cplusplus
}
#endif

#endif