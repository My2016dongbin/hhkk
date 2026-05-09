/********************************************************************* 
 * Copyright (C), 2014-2015, Digital Technology Co., Ltd.
 * 文件名   : ezclient_error.h
 * 功能描述 : 错误码声明文件
 * 作者     ：tanyongfeng
 * 创建日期 ：2016-3-17
 * 修改历史 ：初始版本(2016-3-17)
 *
 * 
**********************************************************************/ 
 
#ifndef _EZCLIENT_ERROR_H
#define _EZCLIENT_ERROR_H

typedef enum _tagEZ_CLIENT_ERROR_E {

	EZ_OK = 0,
	EZ_ERROR_UNKOWN	= 1,
	EZ_ERROR_INVAILD_PARAM = 2,
	EZ_ERROR_UNSUPPORT = 3,
	EZ_ERROR_NO_MEMORY = 4,
	EZ_ERROR_CREATE_CAS_SESSION = 5,
	EZ_ERROR_CREATE_PRIVATE_STREAM_SESSION = 6,
	EZ_ERROR_INVAILD_TOKEN = 7,//重新设置token后再重试
	EZ_ERROR_NO_TOKENS = 8,//token池里面没有token,请传入token
	EZ_ERROR_NEED_RESET_CLIENT = 9,//传入新的INIT_PARAM并reset((保留，目前未用))
	EZ_ERROR_NEED_RETRY = 10,//请重试，云存储以及SD卡筛选回放，在某些场景下，比如暂停超时后seek，因为底层链路已断开，必须重新发起请求
                            //该错误会立即返回，以方便上层重试
	EZ_ERROR_NEED_RETRY_AFTER_500MS = 11,//500毫秒后请重试
	EZ_ERROR_TOKEN_POOL_FULL = 12,//token池已满
	EZ_ERROR_OVER_P2P_COUNT = 13,//P2P client超过限制(保留)
	EZ_ERROR_LIB_UNINITIALIZED = 14,//SDK未初始化
	EZ_ERROR_STREAM_TIMEOUT = 15,//超时
	EZ_ERROR_PREPUNCHING = 16,//正在打洞中
	EZ_ERROR_NO_VIDEO_HEADER = 17,//没有视频文件头(播放器层面产生和处理此错误)
	EZ_ERROR_DECODE = 18,//解码错误/超时(播放器层面产生和处理此错误)
	EZ_ERROR_CANCED = 19,//取消(保留，用户不用处理)
	EZ_ERROR_PRECONNECT_CLEARED = 20,//播放过程中预连接被用户清除预操作信息
    EZ_ERROR_SECRET_KEY = 21,//流加密码不对
    EZ_ERROR_NO_SURFACE = 22,//未传入播放窗口
    EZ_ERROR_STREAM_HEADER_TIMEOUT = 23,//新定义的流头超时
    EZ_ERROR_STREAM_DATA_TIMEOUT = 24,//新定义的流数据超时
    EZ_ERROR_STREAM_DECODE_TIMEOUT = 25,//新定义的解码超时
    EZ_ERROR_INNER_PLAYER_PORT_ERROR = 26, /**< 内部播放库port错误， */
	EZ_ERROR_PROXYKEY_FAILED = 27,// 获取未加密视频走蚁兵时，获取软加密秘钥错误
    EZ_ERROR_NOT_FOUND = 28,

	/*
	* 启用蚁兵后,仅用于统计蚁兵代理的错误码,只用用统计,应用层不用处理此类错误码
	*/
	EZ_ERROR_PROXY_INFO_EMPTY_TOKEN 			= 81, // 获取token为空
	EZ_ERROR_PROXY_INFO_NOT_ENCRYPT  			= 82, // 设备未开启视频加密
	EZ_ERROR_PROXY_INFO_FORCE_STREAM_TYPE 		= 83, // 强制走流媒体类型
	EZ_ERROR_PROXY_INFO_EMPTY_PROXY 			= 84, // VTM向PDS获取proxy时，PDS返回空或者失败
	EZ_ERROR_PROXY_INFO_CONNECT_TIMEOUT 		= 85, // Client向Proxy建链超时
	EZ_ERROR_PROXY_INFO_CONNECT_REJECT 			= 86, // Proxy 拒接本次链接
	EZ_ERROR_PROXY_INFO_RSP_REDIRECT 			= 87, // Proxy返回CLIENT_RET_VTDU_STATUS_405或者CLIENT_RET_VTDU_STATUS_452错误，Client尝试VTDU
	EZ_ERROR_PROXY_INFO_PREVIEW_CONNECT_ERR 	= 88, // Client和Proxy的链路异常，recv()返回-1
	EZ_ERROR_PROXY_INFO_PREVIEW_TIMEOUT 		= 89, // Client和Proxy间心跳超时
	EZ_ERROR_PROXY_INFO_PROCESS_TIMEOUT 		= 90, // Proxy 取流请求信令处理超时
    
    /*
	* 播放库相关错误码偏移/打开端口错误码
	*/
    EZ_ERROR_PLAYER_BASE = 1000,
    /*
	* 对讲库错误
	*/
    EZ_ERROR_AUDIOENGINE_E_CREATE = 2000,
    EZ_ERROR_AUDIOENGINE_E_SUPPORT = 2001,
    EZ_ERROR_AUDIOENGINE_E_RESOURCE = 2002,
    EZ_ERROR_AUDIOENGINE_E_PARA = 2003,
    EZ_ERROR_AUDIOENGINE_E_PRECONDITION = 2004,
    EZ_ERROR_AUDIOENGINE_E_NOCONTEXT = 2005,
    EZ_ERROR_AUDIOENGINE_E_INVALIDTYPE = 2006,
    EZ_ERROR_AUDIOENGINE_E_ENCODEFAIL = 2007,
    EZ_ERROR_AUDIOENGINE_E_DECODEFAIL = 2008,
    EZ_ERROR_AUDIOENGINE_E_WAVEPLAY = 2009,
    EZ_ERROR_AUDIOENGINE_E_CAPTURE = 2016,
    EZ_ERROR_AUDIOENGINE_E_OVERFLOW = 2017,
    EZ_ERROR_AUDIOENGINE_E_ERRORDATA = 2018,
    EZ_ERROR_AUDIOENGINE_E_DENOISEFAIL = 2019,
    EZ_ERROR_AUDIOENGINE_E_CALLORDER = 2020,
    EZ_ERROR_AUDIOENGINE_E_NEEDDATA = 2021,

	EZ_ERROR_TRANS_BASE = 3000,//转封装库库错误码偏移
	EZ_ERROR_CONVERTER_BASE = 4000,//转码库错误码偏移

	/*
    * 依赖库错误码偏移
     */
	EZ_ERROR_CAS_BASE					= 10000, //cas库错误起始码从10000-20000
	EZ_ERROR_CAS_P2P_STATUS_BASE		= 19000, //转换CAS库的P2PStatusEx p2pstatus错误起始码

	EZ_ERROR_PRIVATE_STREAM_BASE		= 20000,//stream库错误码从20000-30000
	EZ_ERROR_TTS_BASE					= 30000, //tts库错误起始码

	EZ_ERROR_NEW_TTS_BASE					= 40000, //new tts库错误起始码
    EZ_ERROR_NPCLINET_BASE                  = 41000,    //NPClient错误起始码
	EZ_ERROR_EZLINK_BASE                    = 45000,    //EZlink取流错误起始码
	EZ_ERROR_HCNETSDK_BASE                  = 50000,//hcnetsdk库错误起始码
	EZ_ERROR_QOS_TALK_BASE                  = 60000,//QOS_TALK库错误起始码 范围是60000~ 62000
}EZ_CLIENT_ERROR_E;



typedef enum {
    EZ_TRANSFORM_ERROR_UNKNOWN                  = EZ_ERROR_CONVERTER_BASE + 100,
    EZ_TRANSFORM_ERROR_PARAM                    = EZ_TRANSFORM_ERROR_UNKNOWN - 1,
    EZ_TRANSFORM_ERROR_HEADER                   = EZ_TRANSFORM_ERROR_UNKNOWN - 2,
    EZ_TRANSFORM_ERROR_UNSUPPORT_VIDEO          = EZ_TRANSFORM_ERROR_UNKNOWN - 3,
    EZ_TRANSFORM_ERROR_RES_CHANGED              = EZ_TRANSFORM_ERROR_UNKNOWN - 4,
    
}EZ_TRANSFORM_ERROR;

typedef enum {
    EZ_ERROR_NPCLINET_CLOSE = EZ_ERROR_NPCLINET_BASE + 101,
};

/*
 对讲库错误码只做记录
 public static final int AUDIOENGINE_OK          = 0x0;       //函数调用及内部逻辑流程执行成功
 public static final int AUDIOENGINE_E_CREATE      = 0x80000000;  //资源不够用，创建异常
 public static final int AUDIOENGINE_E_SUPPORT     = 0x80000001;  //编解码类型不支持
 public static final int AUDIOENGINE_E_RESOURCE    = 0x80000002;  //资源申请或释放错误
 public static final int AUDIOENGINE_E_PARA       = 0x80000003;  //参数错误
 public static final int AUDIOENGINE_E_PRECONDITION = 0x80000004;  //缺少条件
 public static final int AUDIOENGINE_E_NOCONTEXT       = 0x80000005;  //无设备环境
 public static final int AUDIOENGINE_E_INVALIDTYPE  = 0x80000006;  //无效类型
 public static final int AUDIOENGINE_E_ENCODEFAIL   = 0x80000007;  //编码失败
 public static final int AUDIOENGINE_E_DECODEFAIL   = 0x80000008;  //解码失败
 public static final int AUDIOENGINE_E_WAVEPLAY    = 0x80000009;  //播放失败
 public static final int AUDIOENGINE_E_CAPTURE     = 0x80000010;  //采集失败
 public static final int AUDIOENGINE_E_OVERFLOW    = 0x80000011;  //数据溢出
 public static final int AUDIOENGINE_E_ERRORDATA       = 0x80000012;  //数据错误
 public static final int AUDIOENGINE_E_DENOISEFAIL  = 0x80000013;  //降噪失败
 public static final int AUDIOENGINE_E_CALLORDER       = 0x80000014;  //调用顺序错误
 public static final int AUDIOENGINE_E_NEEDDATA    = 0x80000015;  //数据不足
 */



#endif //_EZCLIENT_ERROR_H




