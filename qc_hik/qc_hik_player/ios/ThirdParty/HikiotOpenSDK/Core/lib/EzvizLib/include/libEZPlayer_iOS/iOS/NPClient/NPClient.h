/** @file NPClient.h
 *  @note HangZhou Hikvision System Technology Co., Ltd. All Right Reserved.
 *  @brief NPClient
    
 *  @author     Media Play SDK Team
 *  @date       2014/4/21
 *
 *  @note       使用标准网络协议获取实时流
 *
 */
#ifndef _NPCLIENT_HH
#define _NPCLIENT_HH

#ifdef __cplusplus
extern "C"
{
#endif
#if defined(WIN32)
    #if defined(NPCLIENT_EXPORTS)
        #define NPC_API __declspec(dllexport)
    #else
        #define NPC_API __declspec(dllimport)
    #endif
#else
    #ifndef __stdcall
        #define __stdcall
    #endif

    #ifndef NPC_API
        #define NPC_API
    #endif
#endif

/************************************************************************
* 宏定义区 - 错误码定义
************************************************************************/
#define NPC_OK              0x00000000  //成功
#define NPCERR_ID           0x80000001  //会话id错误
#define NPCERR_SUPPORT      0x80000002  //协议类型不支持
#define NPCERR_PARA         0x80000003  //参数错误
#define NPCERR_TIMEOUT      0x80000004  //连接超时错误
#define NPCERR_CONNECT      0x80000005  //其他连接错误
#define NPCERR_AUTH         0x80000006  //认证信息错误
#define NPCERR_PROTOCOL     0x80000007  //协议交互其他错误
#define NPCERR_SYSTEM       0x80000008  //操作系统调用错误(包括资源申请失败或内部错误等）
#define NPCERR_OTHERLIB     0x80000009  //其他库调用错误
#define NPCERR_PLUGIN       0x80000010  //插件加载错误(包括配置文件没有配置或者加载失败）
#define NPCERR_INIT         0x80000011  //其他初始化错误
#define NPCERR_GENRAL       0x80000012  //内部通用错误
#define NPCERR_PORT         0x80000013  //内部 端口号申请失败
#define NPCERR_UNKNOW       0x80000100  //未知错误


/************************************************************************
* 结构体定义区
************************************************************************/
/** @enum   NPC_SIGNAL_PROTOCOL     
 *  @brief  协议类型定义
 *  @note    
 */
enum NPC_SIGNAL_PROTOCOL
{
    NPC_PRO_AUTO     = 0,                 //自动解析协议类型
    NPC_PRO_RTSP     = 1,                 //RTSP协议
    NPC_PRO_RTMP     = 2,                 //RTMP协议
    NPC_PRO_HLS      = 3,                 //HLS协议
    NPC_PRO_HTTP     = 4,                 //HTTP协议
    NPC_PRO_ONVIF    = 5,                 //ONVIF协议
	NPC_PRO_DASH     = 6,				  //DASH协议
	NPC_PRO_MMSH     = 7,				  //MMSH协议
    NPC_PRO_UNKONM   = 100                //未知协议类型
};

/** @enum   NPC_TRANSMIT     
 *  @brief  传输方式定义
 *  @note   不同协议类型支持的传输方式为此集合的子集
 */
enum NPC_TRANSMIT
{
    NPC_TRANSMIT_TCP    = 0,                  //TCP传输方式
    NPC_TRANSMIT_UDP    = 1,                  //UDP传输方式
    NPC_TRANSMIT_HTTP   = 2,                  //HTTP Tunneling传输方式
};

/** @enum   NPC_DATA_TYPE     
 *  @brief  数据类型定义
 *  @note   
 */
enum NPC_DATA_TYPE
{
    NPC_DATA_SDP          = 0,    //RTSP--SDP数据
    NPC_DATA_VIDEO        = 1,    //视频数据
    NPC_DATA_AUDIO        = 2,    //音频数据
    NPC_DATA_MULTI        = 3,    //复合流数据,对于HTTP可能为文本消息
    NPC_DATA_HEAD         = 4,    //HTTP--结构体NPC_HTTP_HEAD_T
    NPC_RTMP_INFO         = 5,    //RTMP信息，chunkSize
    NPC_DATA_VIDEOPARA    = 6,    //RTMP视频配置信息包
    NPC_DATA_AUDIOPARA    = 7,    //RTMP音频配置信息包
    NPC_DATA_AGGREGATE    = 8,    //RTMP聚合包
    NPC_DATA_HLSINFO      = 9,    //HLS信息---结构体HLSINFO_T
	NPC_DATA_DASHINFO     = 10,   //DASH协议信息---结构体DASHINFO_T
	NPC_DATA_MEDIAINFO    = 11,   //海康媒体信息头---结构体HIK_MEDIAINFO
};

/** @enum   NPC_PULL_STREAM_TYPE     
 *  @brief  拉流媒体轨道类型。只用于RTSP协议拉流，客户端指定希望拉取的媒体轨道
 *  @note   
 */
enum NPC_PULL_STREAM_TYPE
{
	NPC_PULL_STREAM_VIDEO = 0x01,	// 视频
	NPC_PULL_STREAM_AUDIO = 0x02,	// 音频
	NPC_PULL_STREAM_ALL   = 0xff	// 所有数据类型
};

/** @enum   NPC_MSG_TYPE
 *  @brief  消息类型定义
 *  @note    
 */
enum NPC_MSG_TYPE
{
    NPC_STREAM_RECONNECT = 0,    //重连消息，目前没有回调此消息
    NPC_STREAM_CLOSE     = 1,    /*重连失败消息，三次失败，回调此消息，应调用NPC_Close和NPC_Destroy关闭连接
                                   对于HTTP短连接此消息表示已经完成本次请求，可以调用关闭*/
    NPC_TRACK_CLOSE      = 2,    //Track关闭消息，Track代表媒体流体流，目前仅支持RTSP协议
    NPC_STREAM_ANNOUCE   = 3,    //传递ANNOUCE信令
    NPC_UDP_PORT_ASSIGN_OK = 4,     //成功分配的UDP端口号列表，"RtpPort:%u,RtcpPort:%u;"
    NPC_UDP_PORT_ASSIGN_ERR = 5,     //失败分配的UDP端口范围，"UdpPortStart:%u,UdpPortRange:%u;"
};

/** @enum   NPC_HTTP_METHOD_T     
 *  @brief  HTTP方法
 *  @note    
 */
enum NPC_HTTP_METHOD_T
{
    NPC_HTTP_UNKNOWN = 0,    // 未知方法
    NPC_HTTP_GET     = 1,    // GET方法                   
    NPC_HTTP_POST    = 2,    // POST方法                                     
    NPC_HTTP_HEAD    = 3,    // HEAD 方法                                     
    NPC_HTTP_OPTIONS = 4,    // OPTIONS方法                                   
    NPC_HTTP_PUT     = 5,    // PUT方法                                       
    NPC_HTTP_DELETE  = 6,    // DELETE方法                                    
    NPC_HTTP_TRACE   = 7,    // TRACE方法                                     
    NPC_HTTP_CONNECT = 8,    // CONNECT方法                  
};

/** @struct   NPC_HTTP_INFO_T  
 *  @brief    HTTP请求的额外信息
 *  @note     如果不调用设置接口，按照默认值处理
 */
typedef struct _NPC_HTTP_INFO_
{
    NPC_HTTP_METHOD_T eMethod;         //HTTP方法，默认为GET
    int               iContentLen;     //请求消息内容长度,默认为0
    void*             pContent;        //请求消息内容,默认为空
}NPC_HTTP_INFO_T;

/** @struct    NPC_HTTP_HEAD_T 
 *  @brief     HTTP响应的消息头部分
 *  @note   
 */
typedef struct _NPC_HTTP_HEAD_
{  
    int           nStatusCode;  //响应状态码
    unsigned int  nBodyLen;     //跟随消息体长度
    unsigned int  nHeadLen;     //消息头长度
    char*         pszHead;      //消息头内容
}NPC_HTTP_HEAD_T;

/** @struct NPC_RTSP_INFO_T 
 *  @brief  RTSP请求的额外信息 
 *  @note   设置的信息对NPC_Open生效
 *          fScale仅可取以下9种值{ 0.0625, 0.125, 0.25, 0.5, 1.0, 2.0, 4.0, 8.0, 16.0 }
 */ 
typedef struct _NPC_RTSP_INFO_ 
{
    float       fScale;      //服务器发送数据的速率,1为正常速度，大于1为加速，小数为减速（0.5）
    double      dNptStart;   //npt开始时间
    double      dNptEnd;     //npt结束时间
}NPC_RTSP_INFO_T;

/** @enum   RANGE_TYPE
 *  @brief  时间类型
 *  @note    
 */
enum RANGE_TYPE
{
	NPC_RANGE_CLOCK,
	NPC_RANGE_NPT,
};

/** @struct _NPC_RTSP_INFO_V1 
 *  @brief  RTSP请求的额外信息 
 *  @note   设置的信息对NPC_Open生效
 *          fScale仅可取以下9种值{ 0.0625, 0.125, 0.25, 0.5, 1.0, 2.0, 4.0, 8.0, 16.0 }
 */ 
typedef struct _NPC_RTSP_INFO_V1 
{
	int			iVersion;	 //版本号，用于参数兼容
    float       fScale;      //服务器发送数据的速率,1为正常速度，大于1为加速，小数为减速（0.5）
	RANGE_TYPE  enRangeType; //时间类型 
    double      dNptStart;   //开始时间  如果是clock类型 是从1970元年开始经过的时间，UTC/GMT 单位微秒
    double      dNptEnd;     //结束时间  同dNptStart
}NPC_RTSP_INFO_T_V1;

/** @struct NPC_ONVIF_INFO_T 
 *  @brief  ONVIF请求的额外信息 
 *  @note   设置的信息对NPC_Open生效
 */ 
typedef struct _NPC_ONVIF_INFO_ 
{
    int    iInputNo;
    int    iStreamNo;
}NPC_ONVIF_INFO_T;

/** @struct NPC_RTMP_TYPE
 *  @brief  RTMP协议类型 
 *  @note   设置的信息对NPC_Open生效
 */ 
enum NPC_RTMP_TYPE 
{
    NPC_RTMP_PULL,
    NPC_RTMP_PUSH
};

/** @struct _NPC_RTMP_INFO_ 
 *  @brief  RTMP协议额外信息 
 *  @note   设置的信息对NPC_Open生效
 */ 
typedef struct _NPC_RTMP_INFO_ 
{
    int    iRtmpType;       //RTMP类型，与enum NPC_RTMP_TYPE一致
    int    iChunkSize;      //RTMP数据chunk大小
    char   Reserved[20];    //预留位
}NPC_RTMP_INFO_T;


/** @struct NPC_INFO 
 *  @brief  请求设置的额外信息 
 *  @note   设置的信息对NPC_Open生效
 */ 
typedef struct _NPC_INFO_
{
    int    iProtocol;                   //协议类型，与enum NPC_SIGNAL_PROTOCOL一致
    union INFO_U
    {
        NPC_HTTP_INFO_T struHttpInfo;   //HTTP协议参数结构
        NPC_RTSP_INFO_T struRtspInfo;   //RTSP协议参数结构
        NPC_ONVIF_INFO_T struOnfifInfo; //Onvif协议参数结构
        NPC_RTMP_INFO_T  struRtmpInfo;    //RTMP协议参数结构
    }uninfo;
}NPC_INFO;

/** @struct _NPC_INFO_V1 
 *  @brief  请求设置的额外信息 
 *  @note   设置的信息对NPC_Open生效
 */ 
typedef struct _NPC_INFO_V1
{
    int    iProtocol;                   //协议类型，与enum NPC_SIGNAL_PROTOCOL一致
	int    iVersion;					//结构体版本号，从1开始，用于参数兼容
    union INFO_U
    {
        NPC_HTTP_INFO_T    struHttpInfo;	//HTTP协议参数结构
        NPC_RTSP_INFO_T_V1 struRtspInfo;	//RTSP协议参数结构
        NPC_ONVIF_INFO_T   struOnfifInfo;	//Onvif协议参数结构
        NPC_RTMP_INFO_T    struRtmpInfo;    //RTMP协议参数结构
    }uninfo;
}NPC_INFO_V1;


/** @struct   RTMP_INFO
 *  @brief   RTMP信息，用于回调到上层
 *  @note
 */
typedef struct RTMP_INFO 
{
    int     nChunkSize;                               //RTMP chunk 大小
    int     nAudioCodec;                              //音频编码信息
    int     nVideoCodec;                              //视频编码信息
    double  nFrameRate;                               //视频帧率
    double  nAudioSampleRate;                         //音频采样率
    double  nAudioChannel;                            //音频声道数
    double  nFrameWidth;                              //帧宽度
    double  nFrameHeight;                             //帧高度
    double  nDuration;                                //文件播放持续时间
}RTMPINFO;

/** @struct   HLSINFO_T
 *  @brief   HLS信息，用于回调到上层
 *  @note
 */
typedef struct _HLSINFO_T 
{
    unsigned short  system_format;          // 系统封装层
    unsigned short  video_format;           // 视频编码类型
    unsigned short  audio_format;           // 音频编码类型
}HLSINFO_T;

/** @struct   DASHINFO_T
 *  @brief   DASH信息，用于回调到上层
 *  @note
 */
typedef struct _DASHINFO_T
{
    unsigned short  system_format;          // 系统封装层
    unsigned short  video_format;           // 视频编码类型
    unsigned short  audio_format;           // 音频编码类型
}DASHINFO_T;

#ifndef _HIK_MEDIAINFO_FLAG_
#define _HIK_MEDIAINFO_FLAG_
typedef struct _HIK_MEDIAINFO_
{
	unsigned int    media_fourcc;           // "HKMI": 0x484B4D49 Hikvision Media Information
	unsigned short  media_version;          // 版本号：指本信息结构版本号，目前为0x0101,即1.01版本，01：主版本号；01：子版本号。
	unsigned short  device_id;              // 设备ID，便于跟踪/分析
	unsigned short  system_format;          // 系统封装层
	unsigned short  video_format;           // 视频编码类型
	unsigned short  audio_format;           // 音频编码类型
	unsigned char   audio_channels;         // 通道数  
	unsigned char   audio_bits_per_sample;  // 样位率
	unsigned int    audio_samplesrate;      // 采样率 
	unsigned int    audio_bitrate;          // 压缩音频码率,单位：bit
	unsigned int    reserved[4];            // 保留
}HIK_MEDIAINFO;
#endif

/** @enum   NPC_CODEC     
 *  @brief  取流音视频编码格式
 *  @note   定义的值与播放库头文件定义的一致
 */
enum NPC_CODEC
{
	NPC_AAC      = 0x2001,			//编码方式为AAC
	NPC_G711U    = 0x7110,			//编码方式为G711U
	NPC_G711A    = 0x7111,			//编码方式为G711A
	NPC_G722_1	 = 0x7221,			//编码方式为G722
	NPC_G726A    = 0x7261,			//编码方式为G726A
	NPC_G726U    = 0x7260,			//编码方式为G726U
	NPC_G726_16  = 0x7262,			//编码方式为G726_16
	NPC_VP6      = 0xf1,			//编码方式为vp6
	NPC_MP3      = 0xf5,			//编码方式为mp3
	NPC_MPEG     = 0x2000,			//编码方式为MPEG
	NPC_AVC      = 0x0100,			//编码方式为H264
	NPC_MPEG4    = 0x0003,			//编码方式为MPEG4
	NPC_MJPEG	 = 0x0004,			//编码方式为Mjpeg
	NPC_AVC265   = 0x0005,			//编码方式为H265	
	NPC_SVC264   = 0x0110,			//编码方式为SVC264	
	NPC_SVAC     = 0x0006,			//编码方式为SVAC
    NPC_RAW_UDATA16 = 0x7001,       //采样率为16k的原始数据，即L16
};

/** @enum   NPC_FORMAT     
 *  @brief  取流音视频封装格式
 *  @note   定义的值与转封装库头文件定义的一致
 */
enum NPC_FORMAT
{
    NPC_TS              = 0x3,        //封装格式为TS
    NPC_PS				= 0x2,        //封装格式为PS
    NPC_RTP				= 0x4,        //封装格式为RTP
    NPC_MPEG_DASH		= 0x12,        //封装格式为MPEG-DASH
	NPC_RTMP			= 0x11,        //封装格式为RTMP
	NPC_MP4_FRAG		= 0x13,        //封装格式为MP4-FRAG
	NPC_ASF     		= 0x6,        //封装格式为ASF
};

/** @enum   NPC_CTRL_TYPE     
 *  @brief  流控类型
 *  @note   
 */
typedef enum _NPC_CTRL_TYPE_
{
    NPC_CTRL_PAUSE,		//暂停控制
    NPC_CTRL_PLAY,		//恢复播放控制
    NPC_CTRL_SCALE,		//流速控制
    NPC_CTRL_RANGE,		//跳变控制
}NPC_CTRL_TYPE;

/** @struct _NPC_RANGE_INFO_ 
 *  @brief  NPC控制范围信息 
 *  @note 
 */ 
typedef struct _NPC_RANGE_INFO_
{
    RANGE_TYPE  enRangeType; //时间类型 
    double      dNptStart;   //开始时间  如果是clock类型 是从1970元年开始经过的时间，UTC/GMT 单位微秒
    double      dNptEnd;     //结束时间  同dNptStart
    char Reserved[32];
}NPC_RANGE_INFO;

/** @struct _NPC_CTRL_INFO_ 
 *  @brief  NPC流控信息 
 *  @note  
 */ 
typedef struct _NPC_CTRL_INFO_
{
    int iCrtlType;                      //协议类型，与enum NPC_CTRL_TYPE一致
    union INFO_U
    {
        float           fScale;         //协议为RTSP时，大于1为加速，小数为减速（0.5）
        NPC_RANGE_INFO  struRangeInfo;  //按时跳变播放的范围
        char Reserved[256];             //预留位，为填充枚举大小
    }uninfo;
    char Reserved[256];                 //预留位，为填充结构体大小
}NPC_CTRL_INFO;

/** @struct _NPC_PORT_INFO_
 *  @brief  NPC端口配置信息
 *  @note   目前仅rtsp可用
 */
typedef struct _NPC_PORT_INFO_
{    
    unsigned int uMode;                 //传输协议方式，详见NPC_TRANSMIT
    unsigned int uPort;                 //指定端口起始,至少为58000，必须偶数（rtp端口号必须偶数，对应rtcp端口号为rtcp端口+1）
    unsigned int uRange;                //UDP传输模式需要另外指定端口范围量，至少为2，至多为65535-uPort+1，否则内部会默认修改为1536。
    char Reserved[256];
}NPC_PORT_INFO;

/** @struct _NPC_THREAD_PROPERTY_
 *  @brief  NPC线程绑定信息
 *  @note   目前仅rtsp可用
 */
typedef struct _NPC_THREAD_PROPERTY_
{
	int nCpuIndex;
	char Reserved[256];
}NPC_THREAD_PROPERTY;

/** @enum   NPCLOG_LEVEL
 *  @brief  NPC日志等级
 *  @note
 */
typedef enum {
    NPCLOG_LEVEL_OFF    = 7,           //日志等级，崩溃关闭
    NPCLOG_LEVEL_FATAL  = 6,           //日志等级，致命缺陷
    NPCLOG_LEVEL_ERROR  = 5,           //日志等级，错误
    NPCLOG_LEVEL_WARN   = 4,           //日志等级，警告
    NPCLOG_LEVEL_INFO   = 3,           //日志等级，通知
    NPCLOG_LEVEL_DEBUG  = 2,           //日志等级，调试
    NPCLOG_LEVEL_TRACE  = 1,           //日志等级，追溯
    NPCLOG_LEVEL_ALL    = 0            //日志等级，全部
} NPCLOG_LEVEL;

/** @struct NPC_STREAM_TYPE
 *  @brief  流类型 推流或拉流
 *  @note   设置的信息对NPC_Open生效
 */ 
enum NPC_STREAM_TYPE 
{
    NPC_STREAM_PULL = 0,
    NPC_STREAM_PUSH
};

/** @enum   NPC_SRCINFO_TYPE 
 *  @brief  RTSP 推流时
 *  @note  
 */ 
enum NPC_SRCINFO_TYPE
{
    NPC_SRCINFO_CUSTOM = 0,               //用户自定义 SDP 
    NPC_SRCINFO_HIKHEADER                 //NPC 库采用海康媒体头创建 SDP
};

/** @struct NPC_RTSP_PUSH_INFO_T 
 *  @brief  RTSP推流信息定义 
 *  @note   固定size为96byte
 */ 
typedef struct _NPC_RTSP_PUSH_INFO_
{
    unsigned int    uSrcInfoType;                  // Src 数据类型，由NPC_SRCINFO_TYPE定义
    unsigned int    uSrcInfoLen;                   // SrcInfo 数据长度, 最大长度为5 * 1024
    char*           pSrcInfo;                      // SrcInfo 数据指针
    char            aReserve[84];                  // 保留数据位,扩展
}NPC_RTSP_PUSH_INFO_T;

/** @struct NPC_STREAM_INFO 
 *  @brief  请求设置的额外流信息 
 *  @note   设置的信息对NPC_Open生效.固定size为256byte
 */ 
typedef struct _NPC_STREAM_INFO_
{
    int             iProtocol;                   //协议类型，与enum NPC_SIGNAL_PROTOCOL一致
    unsigned int    uStreamType;                 //流类型，推流或拉流，与NPC_STREAM_TYPE一致
    union PUSH_INFO_U
    {
        NPC_RTSP_PUSH_INFO_T stRtspPushInfo;     //RTSP推流信息
    }unPushInfo;
    char            aReserve[152];               // 保留数据位,扩展
}NPC_STREAM_INFO_T;

/************************************************************************
* 函数定义区
************************************************************************/
/** @fn      NPCDataCb
 *  @brief   数据回调函数，上层需要保证不能阻塞此回调函数
 *  @param   iClientId  [IN]    -   会话id由NPC_Create返回，用于标识会话
 *  @param   iDataType  [IN]    -   数据类型, 由NPC_DATA_TYPE描述
 *  @param   pData      [IN]    -   数据指针
 *  @param   uDataLen   [IN]    -   数据长度
 *  @param   pUser      [IN]    -   用户数据
 *  @return void 
 */
typedef void  (__stdcall *NPCDataCb)( int iClientId, int iDataType, unsigned char* pData, unsigned int uDataLen, void* pUser );

/** @fn      NPCMsgCb
 *  @brief   消息回调函数，上层需要保证不能阻塞此回调函数
 *  @param   iClientId  [IN]    -    会话id由NPC_Create返回，用于标识会话
 *  @param   iMsgType   [IN]    -    消息类型, 由NPC_MSG_TYPE描述
 *  @param   szMsg      [IN]    -    消息内容
 *  @param   uMsgLen    [IN]    -    内容长度
 *  @param   pUser      [IN]    -    用户数据
 *  @return  void 
 */
typedef void  (__stdcall *NPCMsgCb)(int iClientId, int iMsgType, unsigned char* szMsg, unsigned int uMsgLen, void* pUser);

/** @fn      NPCLogCb
 *  @brief   日志回调函数，上层需要保证不能阻塞此回调函数
 *  @param   nLogLevel   [OUT]    -    Log等级，由NPCLOG_LEVEL描述
 *  @param   pModuleName [OUT]    -    模块名称
 *  @param   pcFormat    [OUT]    -    日志输出格式
 *  @param   pVarlist    [OUT]    -    日志输出参数，varlist指针，va_list*
 *  @param   pUser       [OUT]    -    用户数据
 *  @return  void 
 */
typedef void  (__stdcall *NPCLogCb)(int nLogLevel, const char* pModuleName, const char* pcFormat, void* pVarlist, void* pUser);

/** @fn      NPC_Create
 *  @brief   创建一个网络流会话
 *  @param   szUrl      [IN]    -   协议Url。注意：若url中存在中文，其中文部分编码方式应与服务端保持一致   
 *  @param   iProtocol  [IN]    -   协议类型码（默认自动识别）
 *  @return  int        成功返回Id(>=0),失败返回错误码 
 */
NPC_API int __stdcall NPC_Create( const char* szUrl, int iProtocol = NPC_PRO_AUTO);


/** @fn      NPC_Destroy
 *  @brief   销毁一个网络流会话
 *  @param   iClientId  [IN]    -   会话Id由NPC_Create返回
 *  @return  int        返回NPC_OK表示成功，其他为错误码 
 */
NPC_API int __stdcall NPC_Destroy(int iClientId);


/** @fn      NPC_SetTransmitMode
 *  @brief   设置传输模式（可选设置）
 *  @param   iClientId  [IN]    -   会话Id由NPC_Create返回 
 *  @param   uMode      [IN]    -   传输模式，由NPC_TRANSMIT描述，具体的协议会有不同的作用
 *  @param   uPort      [IN]    -   特定的传输模式需要另外指定端口（可选）
 *  @return  int        返回NPC_OK表示成功，其他为错误码
 */
NPC_API int __stdcall NPC_SetTransmitMode(int iClientId, unsigned int uMode, unsigned int uPort = 0);

/** @fn      NPC_SetTransmitMode_Ex
 *  @brief   设置UDP传输模式（可选设置）,仅rtsp协议有效。
 *  @param   iClientId  [IN]    -   会话Id由NPC_Create返回 
 *  @param   pPortInfo  [IN]    -   端口设置信息，详见NPC_PORT_INFO
 *  @return  int        返回NPC_OK并非表示UDP端口立即分配成功，需要根据NPCMsgCb回调的消息类型判断是否分片成功，
 *                      因为建立rtsp交互前无法预知需要建立几路rtp-rtcp通道；其他为错误码
 */
NPC_API int __stdcall NPC_SetTransmitMode_Ex(int iClientId, NPC_PORT_INFO* pPortInfo );

/** @fn      NPC_BindSessionToCPU
 *  @brief   设置会话内线程属性，仅
 *  @param   iClientId         [IN]    -   会话Id由NPC_Create返回 
 *  @param   stThreadProperty  [IN]    -   线程属性
 *  @return  int        返回NPC_OK表示成功，其他为错误码
 */
NPC_API int __stdcall NPC_SetSessionThreadProperty(int iClientId, NPC_THREAD_PROPERTY* stThreadProperty);

/** @fn      NPC_SetTimeout
 *  @brief   设置超时时间（可选设置）
 *  @param   iClientId  [IN]    -   会话Id由NPC_Create返回 
 *  @param   uTimeout   [IN]    -   超时时间ms为单位
 *  @return  int        返回NPC_OK表示成功，其他为错误码
 */
NPC_API int __stdcall NPC_SetTimeout(int iClientId, unsigned int uTimeout);


/** @fn      NPC_SetUserAgent
 *  @brief   设置用户代理名称（可选设置）
 *  @param   iClientId      [IN]    -   会话Id由NPC_Create返回 
 *  @param   szUserAgent    [IN]    -   代理名称
 *  @return  int            返回NPC_OK表示成功，其他为错误码
 */
NPC_API int __stdcall NPC_SetUserAgent(int iClientId, const char* szUserAgent);


/** @fn      NPC_SetMsgCallBack
 *  @brief   设置消息回调函数（可选设置）
 *  @param   iClientId  [IN]    -   会话Id由NPC_Create返回 
 *  @param   cbf        [IN]    -   消息回调处理函数
 *  @param   pUser      [IN]    -   用户数据
 *  @return  int        返回NPC_OK表示成功，其他为错误码
 */
NPC_API int __stdcall NPC_SetMsgCallBack(int iClientId, NPCMsgCb cbf, void* pUser);

/** @fn      NPC_SetInfo
 *  @brief   设置协议额外信息（可选设置）
 *  @param   iClientId  [IN]    -   会话Id由NPC_Create返回 
 *  @param   pInfo      [IN]    -   协议额外信息
 *  @return  int        返回NPC_OK表示成功，其他为错误码
 *  @note    
 */
NPC_API int __stdcall NPC_SetInfo(int iClientId, NPC_INFO* pInfo);

/** @fn      NPC_SetInfoV1
 *  @brief   设置协议额外信息（可选设置）
 *  @param   iClientId  [IN]    -   会话Id由NPC_Create返回 
 *  @param   pInfo      [IN]    -   协议额外信息
 *  @return  int        返回NPC_OK表示成功，其他为错误码
 *  @note    
 */
NPC_API int __stdcall NPC_SetInfoV1(int iClientId, NPC_INFO_V1* pInfo);

/** @fn      NPC_GetInfo
 *  @brief   获取协议额外信息
 *  @param   iClientId  [IN]    -   会话Id由NPC_Create返回 
 *  @param   pInfo      [OUT]   -   协议额外信息
 *  @return  int        返回NPC_OK表示成功，其他为错误码
 *  @note    目前只对RTSP ONVFI HTTP协议有效
 */
NPC_API int __stdcall NPC_GetInfo(int iClientId, NPC_INFO* pInfo);

/** @fn      NPC_SetPullStreamType
 *  @brief   设置RTSP协议拉取媒体数据类型。
 *  @param   iClientId       [IN]    -   会话Id由NPC_Create返回 
 *  @param   nPullStreamType [IN]    -   拉流媒体类型
 *  @return  int        返回NPC_OK表示成功，其他为错误码
 *  @note    注意，只有RTSP协议有效
 */
NPC_API int __stdcall NPC_SetPullStreamType(int iClientId, NPC_PULL_STREAM_TYPE nPullStreamType);

/** @fn      NPC_OpenEx
 *  @brief   打开一路网络流
 *  @param   iClientId  [IN]    -   会话Id由NPC_Create返回 
 *  @param   DataCbf    [IN]    -   数据回调函数
 *  @param   pUser      [IN]    -   用户数据
 *  @param   llOffset   [IN]    -   偏移，用于点播定位
 *  @return  int        成功返回NPC_OK，其他为错误码 
 */
NPC_API int __stdcall NPC_OpenEx( int iClientId, NPCDataCb DataCbf, void* pUser ,unsigned long long llOffset = 0);

/** @fn      NPC_Open
 *  @brief   打开一路网络流
 *  @param   iClientId  [IN]    -   会话Id由NPC_Create返回 
 *  @param   DataCbf    [IN]    -   数据回调函数
 *  @param   pUser      [IN]    -   用户数据
 *  @return  int        成功返回NPC_OK，其他为错误码 
 */
NPC_API int __stdcall NPC_Open( int iClientId, NPCDataCb DataCbf, void* pUser);

/** @fn      NPC_Close
 *  @brief   关闭一路网络流
 *  @param   iClientId  [IN]    -   会话Id由NPC_Create返回
 *  @return  int        返回0表示成功，其他为失败
 */
NPC_API int __stdcall NPC_Close(int iClientId);


/**********************************************************************
 * @fn        NPC_ChangeScale
 * @brief     改变流传输速率
 * @param     iClientId   [IN]   会话Id由NPC_Create返回
 * @param     fScale      [IN]   速率值，1为正常速度，大于1为加速，小数为减速（0.5）
 * @return    int                返回状态码
 * @brief     只对RTSP协议生效，NPC_Open之后需要改变传输速率时调用
***********************************************************************/
NPC_API int __stdcall NPC_ChangeScale(int iClientId, float fScale);

/**********************************************************************
 * @fn        NPC_ChangeStatus
 * @brief     改变码流状态
 * @param     iClientId   [IN]   会话Id由NPC_Create返回
 * @param     pCtrlInfo   [IN]   流控参数，见NPC_CTRL_INFO说明
 * @return    int                返回状态码
 * @brief     仅对RTSP/RTMP协议生效，NPC_Open之后需要改变码流状态时调用
***********************************************************************/
NPC_API int __stdcall NPC_ChangeStatus(int iClientId, NPC_CTRL_INFO* pCtrlInfo);

/**********************************************************************
 *  @fn         NPC_InputData
 *  @brief      输入多媒体数据（推流模式时有效）
 *  @param     iClientId   [IN]   -   会话Id由NPC_Create返回
 *  @param     eType       [IN]   -   输入数据类型
 *  @param     pData       [IN]   -   数据缓冲区
 *  @param     nDataLen    [IN]   -   数据缓冲区长度
 *  @return    int                -   成功返回NPC_OK，失败返回错误码
 *  @note       
***********************************************************************/
NPC_API int __stdcall NPC_InputData(int iClientId, NPC_DATA_TYPE eType, unsigned char* pData, unsigned int nDataLen);

/** @fn      NPC_SetLogCallBack
 *  @brief   设置日志回调函数（可选设置）
 *  @param   pCallback  [IN]    -   日志回调处理函数
 *  @param   pUser      [IN]    -   用户数据
 *  @return  int        返回NPC_OK表示成功，其他为错误码
 *  @note    该函数仅可调用一次，日志回调函数为空返回NPCERR_PARA，重复调用接口返回NPCERR_SYSTEM
 */
NPC_API int __stdcall NPC_SetLogCallBack(NPCLogCb pCallback, void* pUser);

/**********************************************************************
 *  @fn      NPC_GetVersion
 *  @brief   获取NPC版本号
 *  @param   pcVersion   [OUT]   -   版本号字符串
 *  @param   nBufferLen  [IN]    -   字符串缓存长度
 *  @return  int         返回NPC_OK表示成功，其他为错误码
 *  @note    版本号内存长度最小为8，小于该值会返回错误
***********************************************************************/
NPC_API int __stdcall NPC_GetVersion(char* pcVersion, int nBufferLen);

/** @fn      NPC_SetStreamInfo
 *  @brief   设置RTSP协议流信息（推/拉流、SDP信息等）。
 *  @param   iClientId        [IN]    -   会话Id由NPC_Create返回 
 *  @param   pStreamInfo      [OUT]   -   推流额外信息
 *  @return  int        返回NPC_OK表示成功，其他为错误码
 *  @note    注意，目前只有RTSP协议有效，别的协议会直接返回错误码NPCERR_SUPPORT
 */
NPC_API int __stdcall NPC_SetStreamInfo(int iClientId, NPC_STREAM_INFO_T* pStreamInfo);

#ifdef __cplusplus
}
#endif

#endif

