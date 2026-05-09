/** @file    MobilePlaySDKInterface.h
 *  @note    HangZhou Hikvision Software Co., Ltd. All Right Reserved.
 *  @brief   declaration of Android/iOS Common-PlayM4-APIs
 *
 *  @author  HPC-MMT-MSDK
 *
 *  @version V7.4.2
 *  @date    2022/08/25
 *
 *  @note    Android/iOS播放库共有的接口声明
 */

#ifndef __MOBILE_PLAY_SDK_INTERFACE_H__
#define __MOBILE_PLAY_SDK_INTERFACE_H__

//*******************************************part1.define Android/iOS PlayCtrl Typedef/Macro/Enum/Struct***********************************************//

typedef void * PLAYM4_HWND;
typedef void * PLAYM4_HDC;

#define PLAYM4_API 
#define __stdcall

#ifndef CALLBACK
#define CALLBACK
#endif

//Timer type
#define TIMER_1 1 //Only 16 timers for every process.Default TIMER;
#define TIMER_2 2 //Not limit;But the precision less than TIMER_1;
    
// 播放库支持的最大port号
// Max channel numbers
#define PLAYM4_MAX_SUPPORTS                     32

#define PLAYM4_MAX_VIDEO_STREAM_SUPPORTS        3

// 针对PlayM4_AdjustWaveAudio接口，调节范围
// PlayM4_AdjustWaveAudio，Wave coefficient range;
#define MIN_WAVE_COEF                   -100
#define MAX_WAVE_COEF                   100

//BUFFER TYPE
#define BUF_VIDEO_SRC                1
#define BUF_AUDIO_SRC                2
#define BUF_VIDEO_RENDER             3
#define BUF_AUDIO_RENDER             4
#define BUF_VIDEO_DECODED           (5) //video decoded node count to render
#define BUF_AUDIO_DECODED           (6) //audio decoded node count to render

//Error code
#define  PLAYM4_NOERROR                 0   //no error
#define  PLAYM4_PARA_OVER               1   //input parameter is invalid;
#define  PLAYM4_ORDER_ERROR             2   //The order of the function to be called is error.
#define  PLAYM4_TIMER_ERROR             3   //Create multimedia clock failed;
#define  PLAYM4_DEC_VIDEO_ERROR         4   //Decode video data failed.
#define  PLAYM4_DEC_AUDIO_ERROR         5   //Decode audio data failed.
#define  PLAYM4_ALLOC_MEMORY_ERROR      6   //Allocate memory failed.
#define  PLAYM4_OPEN_FILE_ERROR         7   //Open the file failed.
#define  PLAYM4_CREATE_OBJ_ERROR        8   //Create thread or event failed
#define  PLAYM4_BUF_OVER               11   //buffer is overflow
#define  PLAYM4_CREATE_SOUND_ERROR     12   //failed when creating audio device.	
#define  PLAYM4_SET_VOLUME_ERROR       13   //Set volume failed
#define  PLAYM4_SUPPORT_FILE_ONLY      14   //The function only support play file.
#define  PLAYM4_SUPPORT_STREAM_ONLY    15   //The function only support play stream.
#define  PLAYM4_SYS_NOT_SUPPORT        16   //System not support.
#define  PLAYM4_FILEHEADER_UNKNOWN     17   //No file header.
#define  PLAYM4_VERSION_INCORRECT      18   //The version of decoder and encoder is not adapted.  
#define  PLAYM4_INIT_DECODER_ERROR     19   //Initialize decoder failed.
#define  PLAYM4_CHECK_FILE_ERROR       20   //The file data is unknown.
#define  PLAYM4_INIT_TIMER_ERROR       21   //Initialize multimedia clock failed.
#define  PLAYM4_BLT_ERROR              22   //Display failed.
#define  PLAYM4_OPEN_FILE_ERROR_MULTI  24   //openfile error, streamtype is multi
#define  PLAYM4_OPEN_FILE_ERROR_VIDEO  25   //openfile error, streamtype is video
#define  PLAYM4_JPEG_COMPRESS_ERROR    26   //JPEG compress error
#define  PLAYM4_EXTRACT_NOT_SUPPORT    27   //Don't support the version of this file.
#define  PLAYM4_EXTRACT_DATA_ERROR     28   //extract video data failed.
#define  PLAYM4_SECRET_KEY_ERROR       29   //Secret key is error //add 20071218
#define  PLAYM4_DECODE_KEYFRAME_ERROR  30   //add by hy 20090318
#define  PLAYM4_NEED_MORE_DATA         31   //add by hy 20100617
#define  PLAYM4_INVALID_PORT           32   //add by cj 20100913
#define  PLAYM4_NOT_FIND               33  //add by cj 20110428
#define  PLAYM4_NEED_LARGER_BUFFER     34  //add by pzj 20130528
#define  PLAYM4_DEMUX_ERROR            35  //demux err
#define  PLAYM4_FAIL_UNKNOWN           99   //Fail, but the reason is unknown;
    
//鱼眼功能错误码
#define PLAYM4_FEC_ERR_ENABLEFAIL               100 // 鱼眼模块加载失败
#define PLAYM4_FEC_ERR_NOTENABLE                101 // 鱼眼模块没有加载
#define PLAYM4_FEC_ERR_NOSUBPORT                102 // 子端口没有分配
#define PLAYM4_FEC_ERR_PARAMNOTINIT             103 // 没有初始化对应端口的参数
#define PLAYM4_FEC_ERR_SUBPORTOVER              104 // 子端口已经用完
#define PLAYM4_FEC_ERR_EFFECTNOTSUPPORT         105 // 该安装方式下这种效果不支持
#define PLAYM4_FEC_ERR_INVALIDWND               106 // 非法的窗口
#define PLAYM4_FEC_ERR_PTZOVERFLOW              107 // PTZ位置越界
#define PLAYM4_FEC_ERR_RADIUSINVALID            108 // 圆心参数非法
#define PLAYM4_FEC_ERR_UPDATENOTSUPPORT         109 // 指定的安装方式和矫正效果，该参数更新不支持
#define PLAYM4_FEC_ERR_NOPLAYPORT               110 // 播放库端口没有启用
#define PLAYM4_FEC_ERR_PARAMVALID               111 // 参数为空
#define PLAYM4_FEC_ERR_INVALIDPORT              112 // 非法子端口
#define PLAYM4_FEC_ERR_PTZZOOMOVER              113 // PTZ矫正范围越界
#define PLAYM4_FEC_ERR_OVERMAXPORT              114 // 矫正通道饱和，最大支持的矫正通道为四个
#define PLAYM4_FEC_ERR_ENABLED                  115 // 该端口已经启用了鱼眼模块
#define PLAYM4_FEC_ERR_D3DACCENOTENABLE         116 // D3D加速没有开启
#define PLAYM4_FEC_ERR_PLACE_TYPE               117 // 错误的矫正类型
#define PLAYM4_FEC_ERR_CORRECT_TYPE             118 // 矫正方式错误：如矫正方式已有
    
//Max display regions.
#define MAX_DISPLAY_WND                4

//Display buffers
#define MAX_DIS_FRAMES                 15
#define MIN_DIS_FRAMES                 1

//Locate by
#define BY_FRAMENUM                    1
#define BY_FRAMETIME                   2
    
//Source buffer
#define SOURCE_BUF_MAX               (1024*100000)
#define SOURCE_BUF_MIN               (1024*50)

//Stream type
#define STREAME_REALTIME              0
#define STREAME_FILE                  1

//frame type
#define T_AUDIO16                     101
#define T_AUDIO8                      100
#define T_UYVY                        1
#define T_YV12                        3
#define T_NV12                        5
#define T_RGB32                       7
#define T_CVPR                        10

#define DOUBLE_CAMERA_STREAM_FIRST_ID   0xE0
#define DOUBLE_CAMERA_STREAM_SECOND_ID  0xE1
#define DOUBLE_CAMERA_STREAM_THIRD_ID   0xE2
#define CAMERA_TYPE_EZVIZ_DEYE          0x85

// 以下宏定义用于HIK_MEDIAINFO结构
#define FOURCC_HKMI                   0x484B4D49     // "HKMI" HIK_MEDIAINFO结构标记
// 系统封装格式 
#define SYSTEM_NULL                   0x0            // 没有系统层，纯音频流或视频流	
#define SYSTEM_HIK                    0x1            // 海康文件层
#define SYSTEM_MPEG2_PS               0x2            // PS封装
#define SYSTEM_MPEG2_TS               0x3            // TS封装
#define SYSTEM_RTP                    0x4            // rtp封装
#define SYSTEM_RTPHIK                 0x401          // rtp封装
#define SYSTEM_MPEG4                  0x5            // MP4封装
#define SYSTEM_AVI                    0x7            // AVI封装
#define SYSTEM_RTMP                   0xD            // RTMP封装
#define SYSTEM_DAH                    0x8001         // 大华封装

// 视频编码类型
#define VIDEO_NULL                    0x0           // 没有视频
#define VIDEO_H264                    0x1           // 标准H.264和海康H.264都可以用这个定义
#define VIDEO_MPEG2                   0x2           // 标准MPEG2
#define VIDEO_MPEG4                   0x3           // 标准MPEG4
#define VIDEO_MJPEG                   0x4           
#define VIDEO_AVC264                  0x0100        // 标准H264/AVC
#define VIDEO_HEVC265                 0x5           // 标准H265/HEVC
#define VIDEO_SVAC                    0x6
#define VIDEO_SVAC2                   0x0007          // SVAC2.0
#define VIDEO_SVC264                  0x0110          // SVC保留
#define VIDEO_WMV9                    0x0200          // WMV9
#define VIDEO_VC1                     0x0201          // VC1
#define VIDEO_REAL                    0x0300          // REAL保留
#define VIDEO_YUY2                    0x0301          // YUY2图片格式
#define VIDEO_NV12                    0x0302          // NV12图片格式
#define VIDEO_YV12                    0x0303          // YV12图片格式
#define VIDEO_I420                    0x0802          // YV12裸数据
#define VIDEO_MSMPEG4V1               0x0811          // 微软定义的mpeg编码格式version1
#define VIDEO_MSMPEG4V2               0x0812          // 微软定义的mpeg编码格式version2
#define VIDEO_MSMPEG4V3               0x0813          // 微软定义的mpeg编码格式version3
#define VIDEO_WMV1                    0x0821          // 微软定义的WMV编码格式version1
#define VIDEO_WMV2                    0x0822          // 微软定义的WMV编码格式version2

// 音频编码类型
#define AUDIO_NULL                    0x0000        // 没有音频
#define AUDIO_ADPCM                   0x1000        // ADPCM 
#define AUDIO_MPEG                    0x2000        // MPEG 系列音频，解码器能自适应各种MPEG音频
#define AUDIO_AAC                     0x2001
#define AUDIO_AAC_LD                  0x2002
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
#define AUDIO_OPUS                    0x3002

#define MP_RTINFO_HARDDECODE_ERROR          0 // 硬解码错误
#define MP_RTINFO_SOFTDECODE_ERROR          1 // 软解码错误(不支持)
#define MP_RTINFO_MEDIAHEADER_ERROR         2 // 媒体头错误
#define MP_RTINFO_INIT_ERROR                3 // 初始化失败
#define MP_RTINFO_ALLOC_MEMORY_ERROR        4 // 内存分配失败
#define MP_RTINFO_ENCRYPT_ERROR             5 // 秘钥错误 [加密的码流在解析报错时也会回调该错误码]
#define MP_RTINFO_AUDIODECODE_ERROR         6 // 音频解码错误
#define MP_RTINFO_IDMX_DATA_ERROR           7 // 数据有误,解析失败
#define MP_RTINFO_RENDER_ERROR              8 // 渲染失败
#define MP_RTINFO_RENDER_VIDEO_RATE_CB      9 // 渲染模块 -实时渲染帧率回调
#define MP_RTINFO_DECODE_VIDEO_RATE_CB      10 //硬解码模块-实时渲染帧率回调(适用于Android硬解)
#define MP_RTINFO_HARDDECODE_TRY_CATCH_ERROR         11//try catch err

typedef struct tagPlayM4_THIRDSDKVERSION
{
    unsigned int    nIDMXVersion;                   ///<解析
    unsigned int    nSWDVersion;                    ///<Video-SWD
    char*           nSRVersion;                     ///<Video-Render
    unsigned int    nG711Version;                   ///<Audio-G711
    unsigned int    nG722Version;                   ///<Audio-G722
    unsigned int    nG726Version;                   ///<Audio-G726
    unsigned int    nMP2Version;                    ///<Audio-MP2
    unsigned int    nAACVersion;                    ///<Audio-AAC
    unsigned int    nAPVersion;                     ///<Audio-Process
    unsigned int    nHSVersion;                     ///<Audio-HS,啸叫
    unsigned int    nAGCVersion;                    ///<Audio-AGC
    unsigned int    nANRVersion;                    ///<Audio-ANR
    unsigned int    nALCVersion;                    ///<Audio-ALC
    unsigned int    nReSampleVersion;               ///<Audio-ReSample
    unsigned int    nPitchShifterVersion;           ///<Audio-PitchShifter
    unsigned int    reserved[4];                    // 保留
}PlayM4_THIRDSDKVERSION;

typedef struct tagPlayM4_BITMAPFILEHEADER {
    unsigned short  bfType;         //文件的类型
    unsigned int    bfSize;         //文件的大小，用字节为单位
    unsigned short  bfReserved1;    //保留，必须设置为0
    unsigned short  bfReserved2;    //保留，必须设置为0
    unsigned int    bfOffBits;      //从文件头开始到实际的图象数据之间的字节的偏移量
}PlayM4_BITMAPFILEHEADER;

/**   @struct     PlayM4_BITMAPINFOHEADER
 *    @brief       bmp文件信息头
 */
typedef struct tagPlayM4_BITMAPINFOHEADER{
    unsigned int     biSize;             //BITMAPINFOHEADER结构所需要的字数
    int              biWidth;            //图象的宽度，以象素为单位
    int              biHeight;           //图象的高度，以象素为单位
    unsigned short   biPlanes;           //为目标设备说明位面数，其值将总是被设为1
    unsigned short   biBitCount;         //比特数/象素，其值为1、4、8、16、24、或32

    /*************************************************************************
    biCompression: 图象数据压缩的类型。其值可以是下述值之一：
    BI_RGB：没有压缩；
    BI_RLE8：每个象素8比特的RLE压缩编码，压缩格式由2字节组成（重复象素计数和颜色索引）；
    BI_RLE4：每个象素4比特的RLE压缩编码，压缩格式由2字节组成
    BI_BITFIELDS：每个象素的比特由指定的掩码决定。
    **************************************************************************/
    unsigned int    biCompression;

    unsigned int    biSizeImage;        //图象的大小，以字节为单位。当用BI_RGB格式时，可设置为0
    int             biXPelsPerMeter;    //水平分辨率，用象素/米表示
    int             biYPelsPerMeter;    //垂直分辨率，用象素/米表示
    unsigned int    biClrUsed;          //位图实际使用的彩色表中的颜色索引数（设为0的话，则说明使用所有调色板项）
    unsigned int    biClrImportant;     //对图象显示有重要影响的颜色索引的数目，如果是0，表示都重要。
}PlayM4_BITMAPINFOHEADER;


// 系统时间（码流中的全局时间）
typedef struct tagSystemTime
{
    short wYear;
    short wMonth;
    short wDayOfWeek;
    short wDay;
    short wHour;
    short wMinute;
    short wSecond;
    short wMilliseconds;
}SYSTEMTIME;

typedef struct tagHKRect
{
    unsigned long nLeft;
    unsigned long nTop;
    unsigned long nRight;
    unsigned long nBottom;
}HKRECT;

//Frame Info
typedef struct
{
    int nWidth;
    int nHeight;
    int nStamp;
    int nType;
    int nFrameRate;
    unsigned int dwFrameNum;
    int nStreamId;     // 流索引，分为0xE0或0xE1
}FRAME_INFO;
        
//Watermark Info  //add by gb 080119
typedef struct
{
    char *pDataBuf;
    int  nSize;
    int  nFrameNum;
    int  bRsaRight;
    int  nReserved;
}WATERMARK_INFO;
    
//ENCRYPT Info
typedef struct{
    long nVideoEncryptType;  //视频加密类型
    long nAudioEncryptType;  //音频加密类型
    long nSetSecretKey;      //是否设置，1表示设置密钥，0表示没有设置密钥
}ENCRYPT_INFO;

#ifndef _HIK_MEDIAINFO_FLAG_
#define _HIK_MEDIAINFO_FLAG_
typedef struct _HIK_MEDIAINFO_              // modified by gb 080425
{
    unsigned int    media_fourcc;           // "HKMI": 0x484B4D49 Hikvision Media Information
    unsigned short  media_version;          // 版本号：指本信息结构版本号，目前为0x0101,即1.01版本，01：主版本号；01：子版本号。
    unsigned short  device_id;              // 设备ID，便于动态管理/分析

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
        
typedef struct
{
    int nPort;
    char * pBuf;
    int nBufLen;
    int nWidth;
    int nHeight;
    int nStamp;
    int nType;
    void* nUser;
    int nStreamId;   //用于萤石双目流-取值0/1  20221220
}DISPLAY_INFO;

#ifndef _PLAYM4_SYSTEM_TIME_
#define _PLAYM4_SYSTEM_TIME_
typedef struct PLAYM4_SYSTEM_TIME //绝对时间 
{
    unsigned int dwYear;   //年
    unsigned int dwMon;    //月
    unsigned int dwDay;    //日
    unsigned int dwHour;   //时
    unsigned int dwMin;    //分
    unsigned int dwSec;    //秒
    unsigned int dwMs;     //毫秒
} PLAYM4_SYSTEM_TIME;
#endif

typedef struct
{
    int nPort;
    unsigned char * pBuf;
    int nBufLen;
    int nWidth;
    int nHeight;
    int nStamp;
    int nCodecType;   // 编码类型 H264/H265
    int nFrameType;   // 帧类型 I帧/P帧
    void* nUser;
}PLAYM4_FRAME_INFO;

//Frame position
typedef struct
{
    int nFilePos;
    int nFrameNum;
    int nFrameTime;
    int nErrorFrameNum;
    SYSTEMTIME *pErrorTime;
    int nErrorLostFrameNum;
    int nErrorFrameSize;
}FRAME_POS, *PFRAME_POS;
    
///<矫正类型
#ifndef _TAG_VR_DISPLAY_EFFECT_
#define _TAG_VR_DISPLAY_EFFECT_
typedef enum tagVRDisplayEffect
{
    VR_ET_NULL                      = 0x100,        ///<不矫正
    VR_ET_FISH_PTZ_CEILING          = 0x101,        ///<应用于顶装鱼眼
    VR_ET_FISH_PTZ_FLOOR            = 0x102,        ///<应用于地面安装鱼眼
    VR_ET_FISH_PTZ_WALL             = 0x103,        ///<应用于壁装鱼眼
    VR_ET_FISH_PANORAMA_CEILING360  = 0x104,        ///<应用于顶装鱼眼1P
    VR_ET_FISH_PANORAMA_CEILING180  = 0x105,        ///<应用于顶装鱼眼2P
    VR_ET_FISH_PANORAMA_FLOOR360    = 0x106,        ///<应用于地面安装鱼眼1P
    VR_ET_FISH_PANORAMA_FLOOR180    = 0x107,        ///<应用于地面安装鱼眼2P
    VR_ET_FISH_LATITUDE_WALL        = 0x108,        ///<应用于壁装纬度展开(广角)
}VRDISPLAYEFFECT;
#endif
    
///<鱼眼参数结构
#ifndef _TAG_VR_FISH_PARAM_
#define _TAG_VR_FISH_PARAM_
typedef struct tagVRFishParam
{
    float fRXLeft;                                  ///<水平坐标(min)
    float fRXRight;                                 ///<水平坐标(max)
    float fRYTop;                                   ///<垂直坐标(min)
    float fRYBottom;                                ///<垂直坐标(max)
    float fAngle;                                   ///<180°矫正中心弧度
    float fZoom;                                    ///<PTZ矫正放大系数
    float fPTZX;                                    ///<PTZ矫正的中心坐标
    float fPTZY;                                    ///<PTZ矫正的中心坐标
}VRFISHPARAM;
#endif
#ifndef _PLAYM4_SESSION_INFO
#define _PLAYM4_SESSION_INFO
typedef struct _PLAYM4_SESSION_INFO_     //
{
    int            nSessionInfoType;   //
    int            nSessionInfoLen;    //
    unsigned char* pSessionInfoData;   //
        
}PLAYM4_SESSION_INFO;
#endif
typedef struct
{
    long            lDataType;          //私有数据类型
    long            lDataStrVersion;    //数据返回的结构体版本，主要是为了兼容性
    long            lDataTimeStamp;
    long            lDataLength;
    char*           pData;
    unsigned int    frame_track_belong_cnt; /* 私有帧通道归属计数 */
    unsigned int    frame_track_belong[PLAYM4_MAX_VIDEO_STREAM_SUPPORTS]; /* 私有帧通道归属，私有帧最多归属3个通道 */
}AdditionDataInfo;
    
typedef struct
{
    long nPort;
    char *pVideoBuf;
    long nVideoBufLen;
    char *pPriBuf;
    long nPriBufLen;
    long nWidth;
    long nHeight;
    long nStamp;
    long nType;
    void* nUser;
    int  nStreamId;    //用于萤石双目流-取值0/1,暂时没用到  20221220
}DISPLAY_INFOEX;
    
typedef struct SYNCDATA_INFO
{
    unsigned int  dwDataType;        //和码流数据同步的附属信息类型，目前有：智能信息，车载信息
    unsigned int  dwDataLen;        //附属信息数据长度
    unsigned int  *pData;           //指向附属信息数据结构的指针,比如IVS_INFO结构
} SYNCDATA_INFO;

typedef struct
{
    int            nRunTimeModule;     //当前运行模块
    int            nStrVersion;        //结构体版本
    int            nFrameTimeStamp;    //帧号
    int            nFrameNum;          //时间戳
    int            nErrorCode;         //错误码
    unsigned char  nChangeEncode;      //1表示视频编码改变，2表示音频编码改变
    unsigned char  reserved[11];       //保留字节
}RunTimeInfo;
    
//预录像数据信息
typedef struct
{
    int nType;                      // 数据类型，如文件头，视频，音频，私有数据等
    int nStamp;                     // 时间戳
    int nFrameNum;                  // 帧号
    int  nBufLen;                   // 数据长度
    char* pBuf;                     // 帧数据，以帧为单位回调
    PLAYM4_SYSTEM_TIME  stSysTime;  // 全局时间
    unsigned char nStreamState;     // 轨道状态
    int  nStreamId;                 // 轨道id
}RECORD_DATA_INFO;

typedef struct
{
    unsigned char  *pDataBuf;      //抓图数据buffer
    unsigned long dwPicSize;      //实际图片大小
    unsigned long dwBufSize;      //数据buffer大小
    unsigned long dwPicWidth;     //截图宽
    unsigned long dwPicHeight;    //截图高
    unsigned long dwReserve;      //多加一个reserve字段
    HKRECT       *pCropRect;     //选择区域NULL, 同老的抓图接口
}CROP_PIC_INFO;

///<私有信息模块类型
typedef enum _PLAYM4_PRIDATA_RENDER
{
    PLAYM4_RENDER_ANA_INTEL_DATA    = 0x00000001, //智能分析
    PLAYM4_RENDER_MD                = 0x00000002, //移动侦测
    PLAYM4_RENDER_ADD_POS           = 0x00000004, //POS信息后叠加
    PLAYM4_RENDER_ADD_PIC           = 0x00000008, //图片叠加信息
    PLAYM4_RENDER_FIRE_DETCET       = 0x00000010, //热成像信息
    PLAYM4_RENDER_TEM               = 0x00000020, //温度信息
    PLAYM4_RENDER_ADD_OSD           = 0x00000040, //写字
}PLAYM4_PRIDATA_RENDER;
    
typedef enum _PLAYM4_FIRE_ALARM
{
    PLAYM4_FIRE_FRAME_DIS           = 0x00000001, //火点框显示
    PLAYM4_FIRE_MAX_TEMP            = 0x00000002, //最高温度
    PLAYM4_FIRE_MAX_TEMP_POSITION   = 0x00000004, //最高温度位置显示
    PLAYM4_FIRE_DISTANCE            = 0x00000008, //最高温度距离
}PLAYM4_FIRE_ALARM;

typedef enum _PLAYM4_TEM_FLAG
{
    PLAYM4_TEM_REGION_BOX             = 0x00000001, //框测温
    PLAYM4_TEM_REGION_LINE            = 0x00000002, //线测温
    PLAYM4_TEM_REGION_POINT           = 0x00000004, //点测温
}PLAYM4_TEM_FLAG;

/*图像后处理类型*/
typedef enum _PLAYM4_IMAGE_POST_PROCESS_TYPE
{
    PLAYM4_IMAGE_POST_PROCESS_TYPE_NONE         = 0x0,       ///< 无效果
    PLAYM4_IMAGE_POST_PROCESS_TYPE_BRIGHTNESS   = 0x1,       ///< 亮度   [-1.0, 1.0]
    PLAYM4_IMAGE_POST_PROCESS_TYPE_HUE          = 0x2,       ///< 色度   [ 0.0, 1.0]
    PLAYM4_IMAGE_POST_PROCESS_TYPE_SATURATION   = 0x3,       ///< 饱和度 [-1.0, 1.0]
    PLAYM4_IMAGE_POST_PROCESS_TYPE_CONTRAST     = 0x4,       ///< 对比度 [-1.0, 1.0]
    PLAYM4_IMAGE_POST_PROCESS_TYPE_SHARPNESS    = 0x5,       ///< 锐度   [ 0.0, 1.0]
    PLAYM4_IMAGE_POST_PROCESS_TYPE_WHITEN       = 0x7,       ///< 美白   [ 0.0, 1.0]
    PLAYM4_IMAGE_POST_PROCESS_TYPE_RUDDY        = 0x8,       ///< 红润   [ 0.0, 1.0]
    PLAYM4_IMAGE_POST_PROCESS_TYPE_SMOOTH       = 0x9,       ///< 磨皮   [ 0.0, 1.0]
}PLAYM4_IMAGE_POST_PROCESS_TYPE;

#ifndef PLAYM4_HIKSR_TAG
#define PLAYM4_HIKSR_TAG
//旋转单元结构体
typedef struct tagPLAYM4SRTransformElement
{
    float fAxisX;
    float fAxisY;
    float fAxisZ;
    float fValue;
}PLAYM4SRTRANSFERELEMENT;
    
//旋转组合参数
typedef struct tagPLAYM4SRTransformParam
{
    PLAYM4SRTRANSFERELEMENT* pTransformElement;  // 旋转的坐标轴
    unsigned int		 nTransformCount;		 // 旋转组合次数
}PLAYM4SRTRANSFERPARAM;
#endif

//POS信息背景框参数（透明度和RGB颜色分量）
typedef struct _PLAYM4_POS_BGRECT_COLOR_
{
    unsigned char nA;        //Alpha分量，透明度（0-100归一化）
    unsigned char nR;        //R分量，0-255
    unsigned char nG;        //G分量，0-255
    unsigned char nB;        //B分量，0-255
}PLAYM4_POS_BGRECT_COLOR;

typedef struct _PLAYM4_REALTIME_RENDER_INFO_
{
    unsigned int nPort;						//端口号
    unsigned int nRealTimeFrameRate;        //实时帧率
    unsigned int nFrameRate;                //封装层帧率
    unsigned int nDecodeType;               //解码类型(软解/硬解)
    unsigned int nDataType;                 //数据类型（YV12/NV12/OES Texture）
    unsigned int nUsedTime;                 //使用的时间(以毫秒为单位)
    unsigned int nRes[2];                   //保留字节

}PLAYM4_REALTIME_RENDER_INFO;

//翻转参数
typedef enum _PLAYM4_RENDER_FLIP_EFFECT_
{
    PLAYM4_RENDER_FLIP_VERTICALFLIP = 0, //垂直翻转（上下）
    PLAYM4_RENDER_FLIP_HORIZONFLIP  = 1 //水平翻转（左右）
}PLAYM4_RENDER_FLIP_EFFECT;

//旋转参数
typedef enum _PLAYM4_RENDER_ROTATE_EFFECT_
{
    PLAYM4_RENDER_ROTATE_CLOCKWISE_ROTATE0    = 0,  //顺时针旋转0度
    PLAYM4_RENDER_ROTATE_CLOCKWISE_ROTATE90   = 1,   //顺时针旋转90度
    PLAYM4_RENDER_ROTATE_CLOCKWISE_ROTATE180  = 2,   //顺时针旋转180度
    PLAYM4_RENDER_ROTATE_CLOCKWISE_ROTATE270  = 3   //顺时针旋转270度
}PLAYM4_RENDER_ROTATE_EFFECT;

//types of video scaling for playctrl(playm4)
typedef enum _PLAYM4_ENUM_SCALE_TYPE_
{
    PLAYM4_ENUM_SCALE_FILL = 0,     //全窗口填充
    PLAYM4_ENUM_SCALE_FIT  = 1,     //窗口自适应
}PLAYM4_ENUM_SCALE_TYPE;

typedef struct //绝对时间
{
    unsigned int dwYear;   //年
    unsigned int dwMon;    //月
    unsigned int dwDay;    //日
    unsigned int dwHour;   //时
    unsigned int dwMin;    //分
    unsigned int dwSec;    //秒
    unsigned int dwMs;     //毫秒
} _ST_PLAYM4_SYSTEM_TIME_;

typedef struct
{
    int nPort;
    unsigned char * pBuf;
    int nBufLen;
    int nWidth;
    int nHeight;
    int nStamp;
    int nType;
    void* nUser;
}_ST_PLAYM4_FRAME_INFO_;

// 设置解析参数
#ifndef _DEMUX_PARAM_
#define _DEMUX_PARAM_
typedef struct tagDemuxParam
{
    int    nDemuxType;              //解析类型
    int    nRTMPChunkSize;          //RTMP大小类型
}DemuxParam;
#endif

// 以下实现鱼眼相关的接口
#ifndef _FISHEYE_DEF_
#define _FISHEYE_DEF_

#define R_ANGLE_0   -1  //不旋转
#define R_ANGLE_L90  0  //向左旋转90度
#define R_ANGLE_R90  1  //向右旋转90度
#define R_ANGLE_180  2  //旋转180度

#ifndef _FISH_STURCT_
#define _FISH_STURCT_

// 矫正类型
typedef enum tagFECPlaceType
{
    FEC_NULL          = 0x0,
    FEC_PLACE_WALL    = 0x1,        // 壁装方式  (法线水平)
    FEC_PLACE_FLOOR   = 0x2,        // 地面安装  (法线向上)
    FEC_PLACE_CEILING = 0x3,        // 顶装方式  (法线向下)
}FECPLACETYPE;

typedef enum tagFECCorrectType
{
    FEC_CORRECT_PTZ             = 0x100,        // PTZ
    FEC_CORRECT_PTZ_SECTOR      = 0x101,        // PTZ扇形形式
    FEC_CORRECT_180             = 0x200,        // 180度矫正（对应2P）
    FEC_CORRECT_360             = 0x300,        // 360全景矫正（对应1P）
    FEC_CORRECT_LAT             = 0x400,        // 纬度拉伸
    FEC_CORRECT_SEM             = 0x500,        // 半球显示
    FEC_CORRECT_CYC             = 0x600,        // 圆柱显示（桶形）
    FEC_CORRECT_PLA             = 0x700,        // 小行星
    FEC_CORRECT_CYC_SPL         = 0x800,        // 圆柱显示（剪开）
    FEC_CORRECT_ARC             = 0x900,        // 壁装弧面鱼眼（水平方向）
    FEC_CORRECT_ARC_VERTICAL    = 0xA00,        // 壁装弧面鱼眼（垂直方向）
    FEC_CORRECT_PANOSPHERE      = 0xB00,        // 全景球体
    FEC_CORRECT_ORIGINAL        = 0xC00,        // 原图
}FECCORRECTTYPE;
    
// PTZ在原始鱼眼图上轮廓的显示模式
typedef enum tagFECShowMode
{
    FEC_PTZ_OUTLINE_NULL,   // 不显示
    FEC_PTZ_OUTLINE_RECT,   // 矩形显示
    FEC_PTZ_OUTLINE_RANGE,  // 真实区域显示
}FECSHOWMODE;

typedef struct tagCycleParam
{
    float    fRadiusLeft;           // 圆的最左边X坐标
    float    fRadiusRight;          // 圆的最右边X坐标
    float   fRadiusTop;            // 圆的最上边Y坐标
    float   fRadiusBottom;         // 圆的最下边Y坐标
}CYCLEPARAM;

typedef struct tagPTZParam
{
    float fPTZPositionX;     // PTZ 显示的中心位置 X坐标
    float fPTZPositionY;     // PTZ 显示的中心位置 Y坐标
}PTZPARAM;

// 色彩结构体
typedef struct tagFECColor
{
    unsigned int nR;               // R分量,0-255
    unsigned int nG;               // G分量,0-255
    unsigned int nB;               // B分量,0-255
    unsigned int nAlpha;           // Alpha分量透明度（0-100归一化）
}FECCOLOR;

typedef struct tagFECParam
{
    unsigned int    nUpDateType;            // 更新的类型
    unsigned int    nPlaceAndCorrect;       // 安装方式和矫正方式，只能用于获取，SetParam的时候无效,该值表示安装方式和矫正方式的和
    PTZPARAM        stPTZParam;             // PTZ 校正的参数
    CYCLEPARAM      stCycleParam;           // 鱼眼图像圆心参数
    float           fZoom;                  // PTZ 显示的范围参数
    float           fWideScanOffset;        // 180或者360度校正的偏移角度
    FECCOLOR        stPTZColor;             // PTZ颜色
    int             nResver[16];            // 保留字段
}FISHEYEPARAM;
    
#endif
    
#ifndef _TAG_VR_ANIMATION_TYPE
#define _TAG_VR_ANIMATION_TYPE
typedef enum tagVRAnimationType
{
    VR_ANIMATION_NULL         =   0x0,
    VR_ANIMATION_ARCSPHERE    =   0x1,          ///<弧面鱼眼动画效果
    VR_ANIMATION_ARCSPHERE_TO_PANORAMA = 0x2    ///<弧面鱼眼到纬度展开的动画效果
}VRANIMATIONTYPE;
#endif

// 更新标记变量定义
#define    FEC_UPDATE_RADIUS          0x1       ///<鱼眼圆心参数
#define    FEC_UPDATE_PTZZOOM         0x2       ///<PTZ显示的范围参数
#define    FEC_UPDATE_WIDESCANOFFSET  0x4       ///<鱼眼中心角度参数
#define    FEC_UPDATE_PTZPARAM        0x8       ///<PTZ中心点参数
#define    FEC_UPDATT_PTZCOLOR        0x10      ///<PTZ线框颜色

#endif

#define PLAYM4_SOURCE_MODULE             0 // 数据源模块
#define PLAYM4_DEMUX_MODULE              1 // 解析模块
#define PLAYM4_DECODE_MODULE             2 // 解码模块
#define PLAYM4_RENDER_MODULE             3 // 渲染模块

//**********************************微影定制yuv转基线对外结构体定义 addby yao 20231025*********************************//
typedef enum TAG_REC_SOURCE_TYPE_
{
    REC_SOURCE_TYPE_NV12 = 1,  //输入NV12录制 默认
    REC_SOURCE_TYPE_I420 = 2,  //输入I420录制
}REC_SOURCE_TYPE;

//typedef enum TAG_REC_END_TYPE
//{
//    REC_YUV_RENDER_END  = 1,  //渲染后通过抓去RGBA->YUV进行编码 (默认方式)
//    REC_YUV_DIRECT_END  = 2,  //解析YUV后直接进行编码（当前不支持，方便后续扩展）
//}REC_END_TYPE;

typedef enum TAG_Enum_Record_Codec_Type
{
    Enum_Record_Codec_Type_H264   = 0,  //H264编码
    Enum_Record_Codec_Type_H265   = 1,  //H265编码
    Enum_Record_Codec_Type_MPEG4  = 2,  //MPEG4编码
}Enum_Record_Codec_Type;

typedef struct TAG_RecordEncodeData
{
    Enum_Record_Codec_Type   enumCodecType;     //视频编码类型
    unsigned char*           pEncodedData;      //视频编码帧数据，Android平台SPS/PPS跟IDR帧一块输出， iOS平台SPS、PSP单独输出
    unsigned int             nEncodeDataLen;    //视频编码帧数据长度
    unsigned int             width;             //视频编码宽
    unsigned int             height;            //视频编码高
    long                     nEncodeTimeStamp;  //视频编码时间戳
    unsigned int             reserved[4];       //保留字节
}RecordEncodeData;

typedef void(*RecordEncodeDataFunCB)(int nPort, RecordEncodeData *pEncodeData, void* pUser);

//**********************************HCP自适应颜色水印 结构体addby zhaoqichong*********************************//
//水印字体大小
typedef struct tagWatermarkFontSize
{
    unsigned int nFontWidth;         // 字体宽 限制：大于0（小于15的会默认为15）
    unsigned int nFontHeight;        // 字体高 限制：大于0（小于15的会默认为15）
}WATERMARK_FONTSIZE;

//水印叠加个数
typedef struct tagWatermarkNumber
{
   unsigned int nRowNumber;        // 行数，nFillFullScreen为true时，需要用到此参数 限制：大于0
   unsigned int nColNumber;        // 列数，限制：大于0
}WATERMARK_NUMBER;

//水印自适应信息
typedef struct tagWatermarkWindowAdapt
{
    unsigned int nWindowAdaptMode;  // 限制：0\1\2   0 – 固定字体大小和固定行列数（不进行自适应计算，按输入参数WATERMARK_FONTSIZE和WATERMARK_NUMBER的值进行显示）；1 – 字体行列数进行自适应改变（字体大小不变，WATERMARK_NUMBER的值失效）；  2 – 字体大小进行自适应改变 （行列数不变）
    unsigned int nRowSpace;         // 设置自适应行列数行间距 限制：大于0 nWindowAdaptMode == 1时用到。计算方式：如输入nRowSpace = 300，当前窗口大小 = 900，行数 = 900/300 = 3。当窗口大小增大到1200时，行数自适应调整 = 1200/300 = 4。（当不足一行或一列时，最小为2行2列）（小于30，效果为30）
    unsigned int nColSpace;         // 设置自适应行列数列间距 限制：大于0 nWindowAdaptMode == 1时用到（当不足一行或一列时，最小为2行2列）
    unsigned int nBaseWindowWidth;  // 设置字体比例的基准窗口宽 限制：大于0 nWindowAdaptMode == 2时用到。计算方式：输入stWatermarkFontSize. nFontWidth = 20，nBaseWindowWidth = 900，字体大小 =当前窗口宽 * 20 / 900 。如当前窗口宽为1200时，字体大小 = 1200 * 20 / 900 = 26
    unsigned int nBaseWindowHeight; // 设置字体比例的基准窗口宽 限制：大于0 nWindowAdaptMode == 2时用到
}WATERMARK_WINDOWADAPT;

//水印旋转信息
typedef struct tagWatermarkRotateInfo
{
   float fRotateAngle;               // 旋转角度 单位度 限制：无
   unsigned int nFillFullScreen;     // nFillFullScreen > 0 铺满屏幕  nFillFullScreen == 0 只显示一个
}WATERMARK_ROTATEINFO;

/*水印对齐方式*/
typedef enum tagWaterMarkAlignment
{
    CENTER_ALIGNMENT   = 0,       // 居中对齐
    LEFT_ALIGNMENT     = 1        // 左对齐
}WATERMARK_ALIGNMENT;

//水印信息结构体
typedef struct _WATERMARK_FONT_INFO_
{
   char**                WatermarkFontArray;       //水印信息数组地址，表示char*数组首地址，每个char*元素表示一行字 （最多每行200个字,最多9行）
   unsigned int*         WatermarkFontLengthArray; //每行字的字符串长度（单行小于200，最多9行）
   unsigned int          WatermarkFontNum;         //水印信息数组个数，表示有几行字（最多为9行）
   float                 fFontSpace;               //多行字间距 限制：无 建议取值范围[1~2]，表示字体高的倍数，1就是紧贴
   unsigned int          nColorAdapt;              //颜色自适应 1 - 开启颜色自适应 0 - 关闭颜色自适应
   WATERMARK_ALIGNMENT   emFontAlign;              //多行字的对齐方式
   PTZPARAM              stWatermarkStartPos;      //水印叠加坐标 限制：[0,1]
   FECCOLOR              stWatermarkColor;         //水印颜色 透明度：[0,100] 色度:[0,255]
   WATERMARK_FONTSIZE    stWatermarkFontSize;      //水印字体大小
   WATERMARK_ROTATEINFO  stWatermarkRotateInfo;    //水印旋转信息
   WATERMARK_NUMBER      stWatermarkNumber;        //水印叠加个数
   WATERMARK_WINDOWADAPT stWatermarkWindowAdapt;   //水印自适应信息
   char                  reserved[20];             //保留数组
}WATERMARK_FONT_INFO;

// 绘图回调结构体
typedef struct
{
    int nPort;
    int nSubPort;
    int nStreamId;
    PLAYM4_HDC hDc;
}PLAYM4_FLUTTER_DRAW_INFO;

typedef struct
{
    int nPort;
    int nSubPort;
    int nStreamId;
    void* pCVBuffer;
}PLAYM4_FLUTTER_CVBUFFER_INFO;

///<矩形结构体
typedef struct tagHKRectF
{
    float fTop;                                     ///<[0.0 , 1.0]
    float fBottom;                                  ///<[0.0 , 1.0]
    float fLeft;                                    ///<[0.0 , 1.0]
    float fRight;                                   ///<[0.0 , 1.0]
}HKRECTF;

/*自动刷新模式*/
typedef enum tagRefreshMode
{
    REFRESHMODE_3DROTATE   = 0,       // 3d鱼眼
}REFRESHMODE;


//*************************************************************part2.define Android/iOS PlayCtrl Interface***********************************************//
#ifdef __cplusplus
extern "C"
{
#endif

/*@fun   PlayM4_SetAndroidSDKVersion
* @brief 设置android SDK版本号
* return return ok
* */
PLAYM4_API unsigned int __stdcall PlayM4_SetAndroidSDKVersion(int sdkVersion);

/*@fun   PlayM4_GetSdkVersion
* @brief 获取播放库版本号
* return 播放库版本号
* */
PLAYM4_API unsigned int __stdcall PlayM4_GetSdkVersion();

/*@fun   PlayM4_GetSdkBuildInfo
* @brief 获取播放库build信息
* return 播放库build信息
* */
PLAYM4_API char* __stdcall PlayM4_GetSdkBuildInfo();

/*@fun   PlayM4_GetAllThirdSDKInfo
* @brief 获取播放库内部集成的第三方库信息
* return 播放库内部集成的第三方库信息
* */
PLAYM4_API int __stdcall PlayM4_GetAllThirdSDKInfo(PlayM4_THIRDSDKVERSION* pstVersion);

/*@fun   PlayM4_GetLastError
* @brief 获取当前错误码
* @para  nPort[IN]        播放端口号(0~31)
* return 错误码
* */
PLAYM4_API unsigned int __stdcall PlayM4_GetLastError(int nPort);

/*@fun   PlayM4_GetPort
* @brief 获取端口号
* @para  pnPort[OUT]        播放端口号(0~31)
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_GetPort(int* pnPort);


/*@fun   PlayM4_FreePort
* @brief 释放端口号
* @para  nPort[IN]         播放端口号(0~31)
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_FreePort(int nPort);


/*@fun   PlayM4_OpenFile
* @brief 打开文件
* @para  nPort[IN]         播放端口号(0~31)
* @para  psFileName[IN]    播放文件路径
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_OpenFile(int nPort, char *psFileName);


/*@fun   PlayM4_CloseFile
* @brief 关闭文件（释放资源）
* @para  nPort[IN]         播放端口号(0~31)
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_CloseFile(int nPort);


/*@fun   PlayM4_Play
* @brief 开启播放
* @para  nPort[IN]         播放端口号(0~31)
* @para  hWnd[IN]          窗口句柄
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_Play(int nPort, PLAYM4_HWND hWnd);


/*@fun   PlayM4_Stop
* @brief 停止播放
* @para  nPort[IN]         播放端口号(0~31)
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_Stop(int nPort);


/*@fun   PlayM4_Pause
* @brief 暂停/恢复播放
* @para  nPort[IN]         播放端口号(0~31)
* @para  nPause[IN]        1-暂停/0-恢复
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_Pause(int nPort, unsigned int nPause);


/*@fun   PlayM4_Fast
* @brief 倍速播放，每调一次速度*2
* @para  nPort[IN]         播放端口号(0~31)
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_Fast(int nPort);


/*@fun   PlayM4_Slow
* @brief 慢速播放，每调一次速度/2
* @para  nPort[IN]         播放端口号(0~31)
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_Slow(int nPort);


/*@fun   PlayM4_PlaySound
* @brief 开启声音播放（独占模式）
* @para  nPort[IN]         播放端口号(0~31)
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_PlaySound(int nPort);


/*@fun   PlayM4_StopSound
* @brief 关闭声音播放（独占模式）
* @para  nPort[IN]         播放端口号(0~31)
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_StopSound();


/*@fun   PlayM4_SetStreamOpenMode
* @brief 设置开启流播放模式
* @para  nPort[IN]         播放端口号(0~31)
* @para  nMode[IN]         见STREAME_REALTIME/STREAME_FILE
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetStreamOpenMode(int nPort, unsigned int nMode);


/*@fun   PlayM4_OpenStream
* @brief 1:实时流、回放流时40字节头开流；
*        2:回放流时可以无头开流（RTP不支持无头开流）
* @para  nPort[IN]          播放端口号(0~31)
* @para  pFileHeadBuf[IN]   传入HIK头或者设置NULL
* @para  nSize[IN]          HIK头大小（40字节）
* @para  nBufPoolSize[IN]   播放库内部CycleBuffer缓存大小（建议设置2*1024*1024，2M大小）
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_OpenStream(int  nPort, unsigned char* pFileHeadBuf, unsigned int nSize, unsigned int nBufPoolSize);

/*@fun   PlayM4_InputData
* @brief 实时流、回放流下外部送入码流数据
* @para  nPort[IN]          播放端口号(0~31)
* @para  pBuf[IN]           送入数据
* @para  nSize[IN]          送入数据大小
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_InputData(int nPort, unsigned char *pBuf, unsigned int nSize);


/*@fun   PlayM4_CloseStream
* @brief 关闭流操作
* @para  nPort[IN]          播放端口号(0~31)
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_CloseStream(int nPort);


/*@fun   PlayM4_GetFileTime
* @brief 获取文件时长（单位：秒）
* @para  nPort[IN]          播放端口号(0~31)
* return 文件时长（单位：秒）
* */
PLAYM4_API unsigned int __stdcall PlayM4_GetFileTime(int nPort);


/*@fun   PlayM4_GetPlayedTime
* @brief 获取当前播放时长（单位：秒）不推荐使用
* @para  nPort[IN]          播放端口号(0~31)
* return 当前播放时长（单位：秒）
* */
PLAYM4_API unsigned int __stdcall PlayM4_GetPlayedTime(int nPort);


/*@fun   PlayM4_GetPlayedTimeEx
* @brief 获取当前播放时长（单位：毫秒）推荐使用
* @para  nPort[IN]          播放端口号(0~31)
* return 当前播放时长（单位：毫秒）
* */
PLAYM4_API unsigned int __stdcall PlayM4_GetPlayedTimeEx(int nPort);

/*@fun   PlayM4_SetPlayedTimeEx
* @brief 设置按照当前时间去播放（单位：毫秒）推荐使用
* @para  nPort[IN]          播放端口号(0~31)
* @para  nTime[IN]          当前时间（单位：毫秒）
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetPlayedTimeEx(int nPort, unsigned int nTime);


/*@fun   PlayM4_SetDecCallBack @Deprecated
* @brief 设置解码回调 （不推荐使用，建议用PlayM4_RegisterDecCallBack代替）
* @para  nPort[IN]          播放端口号(0~31)
* @para  DecCBFun[IN]       解码回调函数指针
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetDecCallBack(int nPort,
                                     void (CALLBACK* DecCBFun)(int         nPort,
                                                               char*       pBuf,
                                                               int         nSize,
                                                               FRAME_INFO* pFrameInfo,
                                                               void*       nReserved1,
                                                               void*       nReserved2));


/*@fun   PlayM4_SetDisplayCallBack @Deprecated
* @brief 设置显示回调 （不推荐使用，建议用PlayM4_RegisterDisplayCallBackEx代替）
* @para  nPort[IN]          播放端口号(0~31)
* @para  DisplayCBFun[IN]   显示回调函数指针
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetDisplayCallBack(int nPort,
                                         void (CALLBACK* DisplayCBFun)(int nPort,
                                                                       char *pBuf,
                                                                       int nSize,
                                                                       int nWidth,
                                                                       int nHeight,
                                                                       int nStamp,
                                                                       int nType,
                                                                       void* nReserved));

/*@fun   PlayM4_SetDisplayCallBackEx
* @brief 设置显示回调，带用户指针 （不推荐使用，建议用PlayM4_RegisterDisplayCallBackEx代替）
* @para  nPort[IN]          播放端口号(0~31)
* @para  DisplayCBFun[IN]   显示回调函数指针
* @para  pUser[IN]          用户指针
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetDisplayCallBackEx(int nPort,
                                           void (CALLBACK* DisplayCBFun)(DISPLAY_INFO *pstDisplayInfo),
                                           void* pUser);


/*@fun   PlayM4_GetCurrentFrameRateEx
* @brief 获得当前码流帧率
* @para  nPort[IN]          播放端口号(0~31)
* @para  pfFrameRate[IN]    码流帧率
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_GetCurrentFrameRateEx(int nPort, float* pfFrameRate);


/*@fun   PlayM4_RefreshPlay
* @brief 刷新播放
* @para  nPort[IN]          播放端口号(0~31)
* @para  nStreamId[IN]      轨道号
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_RefreshPlay(int nPort, unsigned int nStreamId = 0);

/*@fun   PlayM4_RefreshPlayEx
* @brief 刷新当前窗口
* @para  nPort[IN]          播放端口号(0~31)
* @para  nStreamId[IN]      轨道号
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_RefreshPlayEx(int nPort, int nSubport, unsigned int nStreamId = 0);

/*@fun   PlayM4_SetAutoRefreshMode
* @brief 设置自动刷新模式
* @para  nPort[IN]          播放端口号(0~31)
* @para  emType[IN]         设置类型 见REFRESHMODE
* @para  bFlag[IN]          是否开启（默认开启）
* @para  nStreamId[IN]      轨道号
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_SetAutoRefreshMode(int nPort, REFRESHMODE emType, int nFlag, unsigned int nStreamId = 0);

/*@fun   PlayM4_GetPictureSize
* @brief 获得码流分辨率
* @para  nPort[IN]          播放端口号(0~31)
* @para  pWidth[OUT]        码流-宽
* @para  pHeight[OUT]       码流-高
* @para  nStreamId[IN]      轨道号
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_GetPictureSize(int nPort, int *pWidth, int *pHeight, unsigned int nStreamId = 0);


/*@fun   PlayM4_GetSourceBufferRemain
* @brief 获得解析缓存CycleBuffer中，剩余数据量大小
* @para  nPort[IN]          播放端口号(0~31)
* return 剩余数据量大小
* */
PLAYM4_API unsigned int __stdcall PlayM4_GetSourceBufferRemain(int nPort);


/*@fun   PlayM4_ResetSourceBuffer
* @brief 清空源缓存
* @para  nPort[IN]          播放端口号(0~31)
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_ResetSourceBuffer(int nPort);


/*@fun   PlayM4_ResetSourceBuffer
* @brief 设置显示节个数（设置1/6/15）（注：Android硬解码设置的为Latcy值）
* @para  nPort[IN]          播放端口号(0~31)
* @para  nNum[IN]           显示节点个数
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetDisplayBuf(int nPort,unsigned int nNum);


/*@fun   PlayM4_GetDisplayBuf
* @brief 获取显示节点个数（设置1/6/15）（注：Android硬解不适用）
* @para  nPort[IN]          播放端口号(0~31)
* return 获取显示节点个数
* */
PLAYM4_API unsigned int __stdcall PlayM4_GetDisplayBuf(int nPort);


/*@fun   PlayM4_SetFileRefCallBack
* @brief 设置文件索引回调
* @para  nPort[IN]          播放端口号(0~31)
* @para  pFileRefDone[IN]   索引回调函数指针
* @para  pUser[IN]          用户指针
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetFileRefCallBack(int nPort,void (CALLBACK* pFileRefDone)( int nPort,void*  nUser),void* pUser);

/*@fun   PlayM4_SetDisplayRegion
* @brief 设置电子放大区域
* @para  nPort[IN]          播放端口号(0~31)
* @para  nRegionNum[IN]     电子放大子端口
* @para  pSrcRect[IN]       电子放大目标区域
* @para  hDestWnd[IN]       窗口句柄
* @para  bEnable[IN]        开启和关闭电子放大（取值0/1）
* @para  nStreamId[IN]      轨道号
* return err code or succ
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetDisplayRegion(int nPort, unsigned int nRegionNum, HKRECT* pSrcRect, PLAYM4_HWND hDestWnd, int bEnable, unsigned int nStreamId = 0);

/*@fun   PlayM4_SetDisplayRegionEx
* @brief 设置电子放大区域(按窗口比例设置，不建议与PlayM4_SetDisplayRegion一起使用)
* @para  nPort[IN]          播放端口号(0~31)
* @para  nRegionNum[IN]     电子放大子端口
* @para  pSrcRect[IN]       电子放大目标区域
* @para  hDestWnd[IN]       窗口句柄
* @para  bEnable[IN]        开启和关闭电子放大（取值0/1）
* @para  nStreamId[IN]      轨道号
* return err code or succ
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetDisplayRegionEx(int nPort, unsigned int nRegionNum, HKRECTF* pSrcRect, PLAYM4_HWND hDestWnd, int bEnable, unsigned int nStreamId = 0);

/*@fun   PlayM4_SetDisplayRegionDST
* @brief 设置电子放大区域，用于窗口分割
* @para  nPort[IN]          播放端口号(0~31)
* @para  nRegionNum[IN]     电子放大子端口
* @para  pSrcRect[IN]       电子放大目标区域
* @para  hDestWnd[IN]       窗口句柄
* @para  bEnable[IN]        开启和关闭电子放大（取值0/1）
* @para  nStreamId[IN]      轨道号
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetDisplayRegionDST(int nPort, unsigned int nRegionNum, HKRECT* pSrcRect, PLAYM4_HWND hDestWnd, int bEnable, unsigned int nStreamId = 0);

/*@fun   PlayM4_SetDisplayRegionDSTEx
* @brief 设置电子放大区域，用于窗口分割(按窗口比例设置，不建议与PlayM4_SetDisplayRegionDST一起使用)
* @para  nPort[IN]          播放端口号(0~31)
* @para  nRegionNum[IN]     电子放大子端口
* @para  pSrcRect[IN]       电子放大目标区域
* @para  hDestWnd[IN]       窗口句柄
* @para  bEnable[IN]        开启和关闭电子放大（取值0/1）
* @para  nStreamId[IN]      轨道号
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetDisplayRegionDSTEx(int nPort, unsigned int nRegionNum, HKRECTF* pSrcRect, PLAYM4_HWND hDestWnd, int bEnable, unsigned int nStreamId = 0);

/*@fun   PlayM4_ResetBuffer
* @brief 重置清空解析、解码、渲染等缓存
* @para  nPort[IN]          播放端口号(0~31)
* @para  nBufType[IN]       缓存类型
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_ResetBuffer(int nPort, unsigned int nBufType);


/*@fun   PlayM4_ResetBuffer
* @brief 获取指定缓冲区的大小
* @para  nPort[IN]          播放端口号(0~31)
* @para  nBufType[IN]       缓存类型
* return 指定缓冲区的大小
* */
PLAYM4_API unsigned int __stdcall PlayM4_GetBufferValue(int nPort, unsigned int nBufType);


/*@fun   PlayM4_SetDecodeFrameType
* @brief 设置要解码的帧类型
* @para  nPort[IN]          播放端口号(0~31)
* @para  nFrameType[IN]     解码帧类型（默认正常解码，1表示只解码I帧，6表示无论多大分辨率都全解码；3,4,5分别表示svc码流只解码1/2,1/4,1/8）
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetDecodeFrameType(int nPort, unsigned int nFrameType);


/*@fun   PlayM4_ConvertToJpegFile
* @brief yuv数据转jpeg文件（只支持YV12）（此接口不依赖于播放端口号，不推荐使用）
* @para  pBuf[IN]          YV12数据
* @para  nSize[IN]         YV12数据大小
* @para  nWidth[IN]        YV12宽
* @para  nHeight[IN]       YV12高
* @para  nType[IN]         YUV类型
* @para  sFileName[IN/OUT]     JPEG文件路径
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall  PlayM4_ConvertToJpegFile(char* pBuf, int nSize, int nWidth, int nHeight, int nType, char* sFileName);


/*@fun   PlayM4_GetBMP
* @brief BMP抓图
* @para  nPort[IN]          播放端口号(0~31)
* @para  pBitmap[IN]        BMP缓存
* @para  nBufSize[IN]       BMP缓存大小
* @para  pBmpSize[OUT]      BMP数据大小
* @para  nStreamId[IN]      轨道号
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_GetBMP(int nPort, unsigned char* pBitmap, unsigned int nBufSize, unsigned int* pBmpSize, unsigned int nStreamId = 0);


/*@fun   PlayM4_GetJPEG
* @brief JPEG抓图
* @para  nPort[IN]          播放端口号(0~31)
* @para  pJpeg[IN]          JPEG缓存
* @para  nBufSize[IN]       JPEG缓存大小
* @para  pJpegSize[OUT]     JPEG数据大小
* @para  nStreamId[IN]      轨道号
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_GetJPEG(int nPort, unsigned char* pJpeg, unsigned int nBufSize, unsigned int* pJpegSize, unsigned int nStreamId = 0);


/*@fun   PlayM4_GetJPEG
* @brief 渲染抓图转化JPEG
* @para  nPort[IN]          播放端口号(0~31)
* @para  pJpeg[IN]          JPEG缓存
* @para  nBufSize[IN]       JPEG缓存大小
* @para  pJpegSize[OUT]     JPEG数据大小
* @para  nStreamId[IN]      轨道号
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_GetJPEGEx(int               nPort,
                                          unsigned char*    pJpeg,
                                          unsigned int      nBufSize,
                                          unsigned int*     pJpegSize,
                                          unsigned int      nStreamId = 0);

/*@fun   PlayM4_SetSecretKey
* @brief 设置解密秘钥
* @para  nPort[IN]          播放端口号(0~31)
* @para  lKeyType[IN]       密钥类型（1-AES128/2-AES256）
* @para  pSecretKey[IN]     密钥
* @para  lKeyLen[IN]        密钥大小
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetSecretKey(int nPort, int lKeyType, char *pSecretKey, int lKeyLen);


/*@fun   PlayM4_SetFileEndCallback
* @brief 设置文件播放结束回调
* @para  nPort[IN]             播放端口号(0~31)
* @para  FileEndCallback[IN]   文件结束回调指针
* @para  pUser[IN]             用户指针
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetFileEndCallback(int nPort, void(CALLBACK* FileEndCallback)(int nPort, void *pUser), void *pUser);


/*@fun   PlayM4_SetStreamEndCallback
* @brief 设置流式播放结束回调
* @para  nPort[IN]             播放端口号(0~31)
* @para  StreamEndCallback[IN]   文件结束回调指针
* @para  pUser[IN]             用户指针
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetStreamEndCallback(int nPort,void(CALLBACK*StreamEndCallback)(int nPort, void *pUser),void *pUser);


/*@fun   PlayM4_SkipErrorData
* @brief 设置是否跳过错误数据解析
* @para  nPort[IN]            播放端口号(0~31)
* @para  bSkip[IN]            0-不跳过错误数据 1-跳过错误数据，默认播放库内部跳过错误数据
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SkipErrorData(int nPort, int bSkip);


/*@fun   PlayM4_GetSystemTime
* @brief 获得当前显示帧系统时间
* @para  nPort[IN]            播放端口号(0~31)
* @para  pstSystemTime[OUT]   显示帧系统时间（全局时间如：2022.08.25.10.28.30.100）
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_GetSystemTime(int nPort, PLAYM4_SYSTEM_TIME *pstSystemTime);


/*@fun   PlayM4_GetSpecialData
* @brief 获得当前显示帧系统时间，需要应用层转化 @Deprecated
* @para  nPort[IN]            播放端口号(0~31)
* return 显示帧系统时间
* */
PLAYM4_API unsigned int __stdcall PlayM4_GetSpecialData(int nPort);


/*@fun   PlayM4_GetAudioPlayedTime 
* @brief 获得当前纯音频码流的播放时间
* @para  nPort[IN]            播放端口号(0~31)
* return 显示帧系统时间
* */
PLAYM4_API unsigned int __stdcall PlayM4_GetAudioPlayedTime(int nPort);



/*@fun   PlayM4_SetVideoWindow
* @brief 设置播放窗口
* @para  nPort[IN]            播放端口号(0~31)
* @para  nRegionNum[IN]       窗口索引（0～1）
* @para  hWnd[IN]             窗口句柄
* @para  nStreamId[IN]        轨道号
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetVideoWindow(int nPort, unsigned int nRegionNum, PLAYM4_HWND hWnd, unsigned int nStreamId = 0);


/*@fun   PlayM4_SetDecCallBackMend
* @brief 带用户参数解码回调，用PlayM4_RegisterDecCallBack代替
* @para  nPort[IN]             播放端口号(0~31)
* @para  DecCBFun[IN]          解码回调指针
* @para  pUser[IN]             用户指针
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetDecCallBackMend(int nPort,
                                         void (CALLBACK* DecCBFun)(int          nPort,
                                                                   char*        pBuf,
                                                                   int          nSize,
                                                                   FRAME_INFO*  pFrameInfo,
                                                                   void*        nUser,
                                                                   void*        nReserved2), void* pUser);
    

/*@fun   PlayM4_SetVerticalFlip
* @brief 设置垂直翻转 @Deprecated
* @para  nPort[IN]            播放端口号(0~31)
* @para  bFlag[IN]            0-开启/1-关闭
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetVerticalFlip(int nPort, int bFlag);


/*@fun   PlayM4_SetImageCorrection
* @brief 设置广角矫正 @Deprecated
* @para  nPort[IN]            播放端口号(0~31)
* @para  bEnable[IN]          0-开启/1-关闭
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetImageCorrection(int nPort, int bEnable);
    

/*@fun   PlayM4_SetFECDisplayEffect
* @brief 老版本鱼眼接口，设置鱼眼矫正效果 @Deprecated
* @para  nPort[IN]            播放端口号(0~31)
* @para  nRegionNum[IN]       窗口索引
* @para  enDisplayEffect[IN]  鱼眼矫正类型
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetFECDisplayEffect(int nPort, int nRegionNum, VRDISPLAYEFFECT enDisplayEffect);


/*@fun   PlayM4_SetFECDisplayParam
* @brief 老版本鱼眼接口，设置鱼眼矫正参数 @Deprecated
* @para  nPort[IN]            播放端口号(0~31)
* @para  nRegionNum[IN]       窗口索引
* @para  pstFishParam[IN]     鱼眼矫正参数
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetFECDisplayParam(int nPort, int nRegionNum, VRFISHPARAM *pstFishParam);


/*@fun   PlayM4_GetFECDisplayParam
* @brief 老版本鱼眼接口，获取鱼眼矫正参数 @Deprecated
* @para  nPort[IN]            播放端口号(0~31)
* @para  nRegionNum[IN]       窗口索引
* @para  pstFishParam[OUT]    鱼眼矫正参数
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_GetFECDisplayParam(int nPort, int nRegionNum, VRFISHPARAM *pstFishParam);


enum PlayM4_PreRecord_Flag_Id
{
    PlayM4_PreRecord_Flag_Multi_Track   =-1,
    PlayM4_PreRecord_Flag_Single_Track0  = 0,
    PlayM4_PreRecord_Flag_Single_Track1  = 1,
    PlayM4_PreRecord_Flag_Single_Track2  = 2,
};

/*@fun   PlayM4_SetPreRecordFlag
* @brief 设置预录像开关
* @para  nPort[IN]            播放端口号(0~31)
* @para  bFlag[IN]            false-关闭/true-开启
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetPreRecordFlag(int nPort, bool bFlag, PlayM4_PreRecord_Flag_Id nFlagId = PlayM4_PreRecord_Flag_Single_Track0);


/*@fun   PlayM4_SetPreRecordCallBack
* @brief 设置预录像回调
* @para  nPort[IN]             播放端口号(0~31)
* @para  PreRecordCBfun[IN]    预录像回调指针
* @para  pUser[IN]             用户指针
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetPreRecordCallBack(int nPort,
                                           void (CALLBACK* PreRecordCBfun)(int nPort,
                                                                           void* pData,
                                                                           unsigned int nDataLen,
                                                                           void *pUser),
                                           void *pUser);


/*@fun   PLAYM4_GetDecodeEngine
* @brief 获得当前解码引擎类型
* @para  nPort[IN]             播放端口号(0~31)
* return 引擎类型 （Andriod:0-软解/1-硬解 iOS:1-软解/2-硬解）
* */
PLAYM4_API int __stdcall PLAYM4_GetDecodeEngine(int nPort);


/*@fun   PlayM4_SetSycGroup
* @brief 设置同步回放组
* @para  nPort[IN]            播放端口号(0~31)
* @para  dwGroupIndex[IN]     同步组索引（0~3）
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetSycGroup(int nPort, unsigned int dwGroupIndex);

enum PlayM4_Multi_Flag_Id
{
    PlayM4_Flag_Multi_Track   =-1,
    PlayM4_Flag_Single_Track0  = 0,
    PlayM4_Flag_Single_Track1  = 1,
    PlayM4_Flag_Single_Track2  = 2,
};

/*@fun   PlayM4_RenderPrivateData
* @brief 开启和关闭私有数据显示（大开关）
* @para  nPort[IN]            播放端口号(0~31)
* @para  nIntelType[IN]       私有数据主类型，可组合使用
         0x01 - IVSEx
         0x02 - MDEx
         0x04 - POS
         0x08 - PICEx
         0x10 - FireEx
         0x20 - TEMEx
         0x40 - TemperOSD
* @para  bTrue[IN]            0-关闭/1-开启
* @para  nFlagId[IN]          作用域
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_RenderPrivateData(int nPort, int nIntelType, int bTrue, PlayM4_Multi_Flag_Id nFlagId = PlayM4_Flag_Single_Track0);


/*@fun   PlayM4_RenderPrivateDataEx
* @brief 开启和关闭私有数据显示（小开关）
* @para  nPort[IN]            播放端口号(0~31)
* @para  nIntelType[IN]       私有数据主类型，可组合使用
* @para  nSubType[IN]         私有数据子类型，可组合使用(0为控制所有子开关)
 主开关    子开关
 0x01(IVS) 0x01 - EZVIZ_VCA_TARGET_TYPE_UNKNOWN,  // 未知（子开关默认全开启）
           0x02 - EZVIZ_VCA_TARGET_TYPE_HUMAN,    // 人形
           0x04 - EZVIZ_VCA_TARGET_TYPE_FACE,     // 人脸
           0x08 - EZVIZ_VCA_TARGET_TYPE_PET,      // 宠物
           0x10 - EZVIZ_VCA_TARGET_TYPE_VEHICLE,  // 车形
           0x20 - EZVIZ_VCA_TARGET_TYPE_PLATE,    // 车牌
           0x40 - EZVIZ_VCA_TARGET_TYPE_ZOOM,     // 变焦框
           0x80 - EZVIZ_VCA_TARGET_TYPE_MTD,      // 画面变化
 0x10(Fire)0x01 - FireDis （子开关默认全开启）
           0x02 - FireMax,
           0x04 - FireMaxPos,
           0x08 - FireDistance,
 0x20(TEM) 0x01 - TEMBox, （子开关默认全关闭）
           0x02 - TEMLine,
           0x04 - TEMPoint,
* @para  bTrue[IN]            0-关闭/1-开启
* @para  nFlagId[IN]          作用域
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_RenderPrivateDataEx(int nPort, int nIntelType, int nSubType, int bTrue, PlayM4_Multi_Flag_Id nFlagId = PlayM4_Flag_Single_Track0);


/*@fun   PlayM4_SyncToAudio
* @brief 设置视音频同步，默认开启
* @para  nPort[IN]            播放端口号(0~31)
* @para  bSyncToAudio[IN]     0-关闭/1-开启
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SyncToAudio(int nPort, int bSyncToAudio);


/*@fun   PlayM4_SetAdditionDataCallBack
* @brief 设置私有数据回调
* @para  nPort[IN]              播放端口号(0~31)
* @para  nSyncType[IN]          私有数据类型
* @para  AdditionDataCBFun[IN]  私有数据回调指针
* @para  pUser[IN]              用户指针
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetAdditionDataCallBack(int nPort,
                                              unsigned int nSyncType, 
                                              void (CALLBACK* AdditionDataCBFun)(int nPort, 
                                              AdditionDataInfo* pstAddDataInfo, 
                                              void* pUser), 
                                              void* pUser);


/*@fun   PlayM4_RegisterIVSDrawFunCB
* @brief 私有数据回调，点、线、框相关 @Deprecated
* @para  nPort[IN]              播放端口号(0~31)
* @para  IVSDrawFun[IN]         IVS私有数据类型
* @para  pUser[IN]              用户指针
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_RegisterIVSDrawFunCB(int nPort,
                                           void (CALLBACK* IVSDrawFun)(int  nPort,
                                           PLAYM4_HDC hDC,
                                           FRAME_INFO* pFrameInfo,
                                           SYNCDATA_INFO* pSyncData,
                                           void*  dwUser,
                                           int bDettach),
                                           void* pUser);

/*@fun   PLAYM4_GetMpOffset
* @brief 获取MP4在线定位偏移值
* @para  nPort[IN]            播放端口号(0~31)
* @para  nTime[IN]            当前播放时间
* @para  nOffset[OUT]         偏移值
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PLAYM4_GetMpOffset(int nPort, int nTime, int* nOffset);
    

/*@fun   PlayM4_SetExpectedFrameRate
* @brief 设置期望帧率（设置的帧率，大于实际帧率时无效，小于1时无效；Android开启硬解码时不支持）
* @para  nPort[IN]                 播放端口号(0~31)
* @para  fExpectedFrameRate[IN]    期望帧率
* @para  nFlag[OUT]                0-关闭/1-开启
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetExpectedFrameRate(int nPort, float fExpectedFrameRate, int nFlag);
    

/*@fun   PlayM4_SetDecodeThreadNumber
* @brief 设置多线程解码线程数（范围1 ~ 8；仅支持H264和H265的码流；Android和iOS开启硬解码时不支持）
* @para  nPort[IN]                 播放端口号(0~31)
* @para  nThreadNumber[IN]         线程数（1～8）
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetDecodeThreadNumber(int nPort, int nThreadNumber);


/*@fun   PlayM4_SetImagePostProcessParameter
* @brief 设置图像后处理参数（nType和fValue的取值，详见PLAYM4_IMAGE_POST_PROCESS_TYPE）
* @para  nPort[IN]                 播放端口号(0~31)
* @para  nType[IN]                 后处理类型
* @para  fValue[IN]                参数值
* @para  nStreamId[IN]             轨道号
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetImagePostProcessParameter(int nPort, int nType, float fValue, unsigned int nStreamId = 0);


/*@fun   PlayM4_SetResetHardDecodeFlag
* @brief 设置使用硬解码时，硬解码报错后是否重启硬解码，不切换软解
* @para  nPort[IN]                 播放端口号(0~31)
* @para  bResetFlag[IN]            false-关闭/true-开启
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetResetHardDecodeFlag(int nPort, bool bResetFlag);


/*@fun   PlayM4_SetAntialiasFlag
* @brief 是否开启抗锯齿（默认开启）
* @para  nPort[IN]                 播放端口号(0~31)
* @para  bFlag[IN]                 false-关闭/true-开启
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetAntialiasFlag(int nPort, bool bFlag);


/*@fun   PlayM4_SetMaxHDSize
* @brief 设置硬解最大分辨率
* @para  nPort[IN]                 播放端口号(0~31)
* @para  nWidth[IN]                宽
* @para  nHeight[IN]               高
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetMaxHDSize(int nPort, int nWidth, int nHeight);


/*@fun   PlayM4_OpenAudioStretchPlay
* @brief 打开音频变速（需要配合fast和slow使用）
* @para  nPort[IN]                 播放端口号(0~31)
* @para  bFlag[IN]                 倍速时音频是否播放
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_OpenAudioStretchPlay(int nPort, bool bFlag);


/*@fun   PlayM4_FEC_Enable
* @brief 启用鱼眼
* @para  nPort[IN]                 播放端口号(0~31)
* return fec 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_FEC_Enable(int nPort);


/*@fun   PlayM4_FEC_Disable
* @brief 关闭鱼眼
* @para  nPort[IN]                 播放端口号(0~31)
* return fec 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_FEC_Disable(int nPort);


/*@fun   PlayM4_FEC_GetPort
* @brief 获取鱼眼矫正处理子端口 （2~9）
* @para  nPort[IN]                 播放端口号(0~31)
* @para  nSubPort[IN]              子端口号
* @para  emPlaceType[IN]           安装方式
* @para  emCorrectType[IN]         矫正方式
* return fec 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_FEC_GetPort(int nPort, int* nSubPort, FECPLACETYPE emPlaceType, FECCORRECTTYPE emCorrectType);


/*@fun   PlayM4_FEC_DelPort
* @brief 删除鱼眼矫正处理子端口 （2~5）
* @para  nPort[IN]                 播放端口号(0~31)
* @para  nSubPort[IN]              子端口号
* return fec 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_FEC_DelPort(int nPort, int nSubPort);


/*@fun   PlayM4_FEC_SetParam
* @brief 设置鱼眼矫正参数
* @para  nPort[IN]                 播放端口号(0~31)
* @para  nSubPort[IN]              子端口号
* @para  pPara[IN]                 鱼眼矫正参数
* return fec 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_FEC_SetParam(int nPort, int nSubPort, FISHEYEPARAM* pPara);


/*@fun   PlayM4_FEC_GetParam
* @brief 获取鱼眼矫正参数
* @para  nPort[IN]                 播放端口号(0~31)
* @para  nSubPort[IN]              子端口号
* @para  pPara[OUT]                鱼眼矫正参数
* return fec 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_FEC_GetParam(int nPort, int nSubPort, FISHEYEPARAM* pPara);


/*@fun   PlayM4_FEC_SetWnd
* @brief 设置鱼眼窗口
* @para  nPort[IN]                 播放端口号(0~31)
* @para  nSubPort[IN]              子端口号
* @para  hWnd[IN]                  窗口句柄
* return fec 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_FEC_SetWnd(int nPort, int nSubPort, void* hWnd);


/*@fun   PlayM4_FEC_GetCurrentPTZPort
* @brief 获取当前触发点对应的鱼眼矫正子port
* @para  nPort[IN]                 播放端口号(0~31)
* @para  bPanorama[IN]             是否触发
* @para  fPositionX[IN]            PTZ-X坐标
* @para  fPositionY[IN]            PTZ-Y坐标
* @para  pnPort[OUT]               子端口号
* return fec 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_FEC_GetCurrentPTZPort(int nPort, bool bPanorama, float fPositionX,float fPositionY, unsigned int *pnPort);


/*@fun   PlayM4_FEC_SetCurrentPTZPort
* @brief 设置鱼眼矫正子port，使线框高亮
* @para  nPort[IN]                播放端口号(0~31)
* @para  nSubPort[IN]             子端口号
* return fec 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_FEC_SetCurrentPTZPort(int nPort, unsigned int nSubPort);


/*@fun   PlayM4_FEC_SetPTZOutLineShowMode
* @brief 设置鱼眼矫正PTZ线框类型
* @para  nPort[IN]                播放端口号(0~31)
* @para  nPTZShowMode[IN]         见FECSHOWMODE定义
* return fec 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_FEC_SetPTZOutLineShowMode(int nPort, FECSHOWMODE nPTZShowMode);


/*@fun   PlayM4_FEC_PTZ2Window
* @brief 鱼眼播放库内部函数，用于实现一些界面PTZ的效果，实现PTZ窗口上点击的鼠标位置转换到原始图像上的点
* @para  nPort[IN]                播放端口号(0~31)
* @para  nSubPort[IN]             子端口号
* @para  stPTZRefOrigin[IN]       PTZ原始坐标
* @para  stPTZRefWindow[IN]       窗口原始坐标
* @para  stPTZWindow[IN]          PTZ窗口坐标
* @para  fXWindow[OUT]            窗口-X坐标
* @para  fYWindow[OUT]            窗口-Y坐标
* return fec 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_FEC_PTZ2Window(int nPort, int nSubPort,
                                     PTZPARAM stPTZRefOrigin,
                                     PTZPARAM stPTZRefWindow,
                                     PTZPARAM stPTZWindow,
                                     float* fXWindow,
                                     float* fYWindow);


/*@fun   PlayM4_SetOverlayPriInfoFlag
* @brief 设置字体库路径，需要显示字符，在Play前设置
* @para  nPort[IN]                播放端口号(0~31)
* @para  nIntelType[IN]           保留参数，暂无效，填1
* @para  bTrue[IN]                保留参数,填1
* @para  pFontPath[IN]            字体路径（设置NUL表示使用系统字体哭路径，由播放库内部指定）
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetOverlayPriInfoFlag(int nPort, int nIntelType, int bTrue, char* pFontPath);


/*@fun   PlayM4_AdjustWaveAudio
* @brief 调节音量大小
* @para  nPort[IN]                播放端口号(0~31)
* @para  nCoefficient[IN]         音量值（-100～100）
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_AdjustWaveAudio(int nPort, int nCoefficient);


/*@fun   PlayM4_SetIFrameDecInterval
* @brief 设置跳I帧解码，需要在设置只解码I帧后配置
* @para  nPort[IN]                播放端口号(0~31)
* @para  dwInterval[IN]           跳I帧间隔
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetIFrameDecInterval(int nPort, unsigned int dwInterval);


/*@fun   PlayM4_SetPreRecordCallBackEx
* @brief 设置预录像回调，带有帧信息
* @para  nPort[IN]             播放端口号(0~31)
* @para  PreRecordCBfun[IN]    预录像回调指针（带帧信息）
* @para  pUser[IN]             用户指针
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetPreRecordCallBackEx(int nPort,
                                            void (CALLBACK* PreRecordCBfun)(int nPort,
                                                                        RECORD_DATA_INFO* pRecordDataInfo,
                                                                        void *pUser),
                                            void *pUser);


/*@fun   PlayM4_ReversePlay
* @brief 倒放（Android硬解码不支持、iOS硬解码surface模式不支持）
* @para  nPort[IN]                播放端口号(0~31)
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_ReversePlay(int nPort);


/*@fun   PlayM4_RegisterDisplayCallBackEx
* @brief 设置显示回调，带全局时间
* @para  nPort[IN]             播放端口号(0~31)
* @para  DisplayCBFun[IN]      显示回调指针（带全局时间）
* @para  pUser[IN]             用户指针
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_RegisterDisplayCallBackEx(int nPort,
                                                void (CALLBACK* DisplayCBFun)
                                                (DISPLAY_INFO *pstDisplayInfo ,
                                                PLAYM4_SYSTEM_TIME *pstSystemTime,
                                                int bDettach),
                                                void* pUser);


/*@fun   PlayM4_RegisterDisplayCallBackEx
* @brief 设置解码回调，带全局时间
* @para  nPort[IN]             播放端口号(0~31)
* @para  DecCBFun[IN]          解码回调指针（带全局时间）
* @para  pUser[IN]             用户指针
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_RegisterDecCallBack(int nPort, void (CALLBACK* DecCBFun)(int nPort,
                                                                               char *pBuf,
                                                                               int nSize,
                                                                               FRAME_INFO *pFrameInfo,
                                                                               PLAYM4_SYSTEM_TIME *pstSystemTime,
                                                                               void* pUser),
                                          void* pUser);


/*@fun   PlayM4_PlaySoundShare
* @brief 共享模式播放音频
* @para  nPort[IN]                播放端口号(0~31)
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_PlaySoundShare(int nPort);


/*@fun   PlayM4_StopSoundShare
* @brief 共享模式停止音频
* @para  nPort[IN]                播放端口号(0~31)
* return fec 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_StopSoundShare(int nPort);


/*@fun   PlayM4_FEC_3DRotate
* @brief 设置3D鱼眼旋转（相对值参数）
* @para  nPort[IN]                播放端口号(0~31)
* @para  nSubPort[IN]             鱼眼子端口号(2～5)
* @para  pstRotateParam[IN]       旋转参数
* return fec 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_FEC_3DRotate(int nPort,  int nSubPort, PLAYM4SRTRANSFERPARAM *pstRotateParam);


/*@fun   PlayM4_FEC_Get3DRotate
* @brief 获取3D鱼眼旋转参数
* @para  nPort[IN]                播放端口号(0~31)
* @para  nSubPort[IN]             鱼眼子端口号(2～5)
* @para  pstRotateParam[OUT]      旋转参数
* return fec 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_FEC_Get3DRotate(int nPort, int nSubPort, PLAYM4SRTRANSFERPARAM *pstRotateParam);


/*@fun   PlayM4_FEC_3DRotateAbs
* @brief 设置3D鱼眼旋转（绝对值参数）
* @para  nPort[IN]                播放端口号(0~31)
* @para  nSubPort[IN]             鱼眼子端口号(2～5)
* @para  pstRotateParam[IN]       旋转参数
* return fec 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_FEC_3DRotateAbs(int nPort,  int nSubPort, PLAYM4SRTRANSFERPARAM *pstRotateParam);


/*@fun   PlayM4_FEC_3DRotateSpecialView
* @brief 设置3D鱼眼角度模式（用于弧面鱼眼动画效果）
* @para  nPort[IN]                播放端口号(0~31)
* @para  nSubPort[IN]             鱼眼子端口号(2～5)
* @para  nSpecialViewType[IN]     取值0～1
* @para  pstRotateParam[IN]       旋转参数
* return fec 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_FEC_3DRotateSpecialView(int nPort, int nSubPort, int nSpecialViewType, PLAYM4SRTRANSFERPARAM *pstRotateParam);


/*@fun   PlayM4_FEC_GetCapPicSize
* @brief 获取鱼眼抓图所需要的缓存大小
* @para  nPort[IN]                播放端口号(0~31)
* @para  nSubPort[IN]             鱼眼子端口号(2～5)
* @para  pnBufSize[OUT]           缓存大小
* return fec 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_FEC_GetCapPicSize(int nPort, int nSubPort, int* pnBufSize);
    

/*@fun   PlayM4_FEC_Capture
* @brief 鱼眼抓图
* @para  nPort[IN]                播放端口号(0~31)
* @para  nSubPort[IN]             鱼眼子端口号(2～5)
* @para  nType[IN]                抓图类型
* @para  pPicBuf[IN]              抓图缓存（通过PlayM4_FEC_GetCapPicSize获取申请得到）
* @para  nBufSize[IN]             抓图缓存大小
* return fec 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_FEC_Capture(int nPort, int nSubPort, unsigned int nType, char *pPicBuf, int nBufSize);


/*@fun   PlayM4_FEC_GetCapPicSizeFixPixel
* @brief 获取鱼眼抓图所需要的缓存大小（按照外部设置的指定分辨率大小）
* @para  nPort[IN]                播放端口号(0~31)
* @para  nSubPort[IN]             鱼眼子端口号(2～5)
* @para  pnBufSize[OUT]           缓存大小
* @para  nCapWidth[IN]            指定分辨率-宽
* @para  nCapHeight[IN]           指定分辨率-高
* return fec 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_FEC_GetCapPicSizeFixPixel(int nPort, int nSubPort, int* pnBufSize,int nCapWidth,int nCapHeight);


/*@fun   PlayM4_FEC_CaptureFixPixel
* @brief 鱼眼抓图（按照外部设置的指定分辨率大小）
* @para  nPort[IN]                播放端口号(0~31)
* @para  nSubPort[IN]             鱼眼子端口号(2～5)
* @para  nType[IN]                抓图类型
* @para  pPicBuf[IN]              抓图缓存（通过PlayM4_FEC_GetCapPicSize获取申请得到）
* @para  nBufSize[IN]             抓图缓存大小
* @para  nCapWidth[IN]            指定分辨率-宽
* @para  nCapWidth[IN]            指定分辨率-高
* return fec 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_FEC_CaptureFixPixel(int nPort, int nSubPort, unsigned int nType, char *pPicBuf, int nBufSize, int nCapWidth, int nCapHeight);


/*@fun   PlayM4_GetBMPEx
* @brief 带私有数据的BMP抓图
* @para  nPort[IN]                播放端口号(0~31)
* @para  pBitmap[IN]              抓图缓存
* @para  nBufSize[IN]             抓图缓存大小
* @para  pBmpSize[IN]             BMP实际大小
* @para  nStreamId[IN]            轨道号
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_GetBMPEx(int nPort, unsigned char* pBitmap,unsigned int nBufSize,unsigned int* pBmpSize, unsigned int nStreamId = 0);


/*@fun   PlayM4_GetBMPFixPixelEx
* @brief 带私有数据的BMP抓图（按照外部设置的指定分辨率大小）
* @para  nPort[IN]                播放端口号(0~31)
* @para  pBitmap[IN]              抓图缓存
* @para  nBufSize[IN]             抓图缓存大小
* @para  pBmpSize[IN]             BMP实际大小
* @para  nShotWidth[IN]           指定分辨率-宽
* @para  nShotHeight[IN]          指定分辨率-高
* @para  nStreamId[IN]            轨道号
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_GetBMPFixPixelEx(int nPort,
                                                 unsigned char* pBitmap,
                                                 unsigned int nBufSize,
                                                 unsigned int* pBmpSize,
                                                 int nShotWidth,
                                                 int nShotHeight,
                                                 unsigned int nStreamId = 0);


/*@fun   PlayM4_SetHSParam
* @brief 设置啸叫抑制开关和参数
* @para  nPort[IN]                播放端口号(0~31)
* @para  bOpen[IN]                是否开启
* @para  nNotch[IN]               设置滤波器深度（级别0～6），默认等级4
* @para  nTime[IN]                设置啸叫时间，默认500
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetHSParam(int nPort, bool bOpen, int nNotch, int nTime);


/*@fun   PlayM4_FEC_SetAnimation
* @brief 设置壁装弧形鱼眼动画参数
* @para  nPort[IN]                播放端口号(0~31)
* @para  nSubPort[IN]             子端口（2～5）
* @para  emType[IN]               见VRANIMATIONTYPE定义
* @para  nCurFrame[IN]            当前帧数
* @para  nTotalFrames[IN]         总帧数
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_FEC_SetAnimation(int nPort, int nSubPort, VRANIMATIONTYPE emType, int nCurFrame, int nTotalFrames);
    

/*@fun   PlayM4_SetDecodeERC
* @brief 设置解码差错隐藏等级（Android/iOS硬解码不支持）
* @para  nPort[IN]                播放端口号(0~31)
* @para  nLevel[IN]               隐藏等级（0～2）
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetDecodeERC(int nPort, int nLevel);


/*@fun   PlayM4_FEC_SetDisplayCallback
* @brief 设置鱼眼显示回调
* @para  nPort[IN]                播放端口号(0~31)
* @para  nSubPort[IN]             子端口（2～5）
* @para  FECDisplayCallback[IN]   鱼眼显示回调指针
* @para  pUser[IN]                用户指针
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_FEC_SetDisplayCallback(int nPort,int nSubPort,
                                             void(CALLBACK*FECDisplayCallback)(int nPort, int nSubport, void *pUser),
                                             void *pUser);


/*@fun   PlayM4_SetAbsTimeFlag
* @brief 设置采用绝对时间戳播放（播放库默认时采用相对时间戳进行播放）
* @para  nPort[IN]                播放端口号(0~31)
* @para  nFlag[IN]                0-关闭/1-开启
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetAbsTimeFlag(int nPort, int nFlag);


/*@fun   PlayM4_SetAGCParam
* @brief 设置AGC开关和参数（AGC：自动增益调节）
* @para  nPort[IN]                播放端口号(0~31)
* @para  nEnable[IN]              0-关闭/1-开启
* @para  nAGCLevel[IN]            取值0～30，0表示数据经AGC透传处理，等级1-30表示（-32～3）等级之间等间隔差-1db
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetAGCParam(int nPort, int nEnable, int nAGCLevel);


/*@fun   PlayM4_SetANRParam
* @brief 设置ANR开关和参数 （ANR：降噪处理）
* @para  nPort[IN]                播放端口号(0~31)
* @para  nEnable[IN]              0-关闭/1-开启
* @para  nANRLevel[IN]            降噪等级（0～5，默认值3）
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetANRParam(int nPort, int nEnable, int nANRLevel);


/*@fun   PlayM4_SetLDCFlag
* @brief 设置EZVIZ鱼眼畸形矫正 （此接口仅针对EZVIZ特定相机，为EZVIZ定制接口）
* @para  nPort[IN]                播放端口号(0~31)
* @para  nFlag[IN]                0-关闭/1-开启
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetLDCFlag(int nPort, int nFlag);


/*@fun   PlayM4_SetSupplementaryTimeZone
* @brief 设置时区 （时区的表示以秒为单位，东区为正，西区为负） only used for Android
* @para  nPort[IN]                播放端口号(0~31)
* @para  nTimeZone[IN]            时区值
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetSupplementaryTimeZone(int nPort, int nTimeZone);


/*@fun   PlayM4_SetSupplementaryTimeZone
* @brief 获取时区时若时区值超过最大范围，则返回的值表示错误码 only used for Android
* @para  nPort[IN]                播放端口号(0~31)
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_GetSupplementaryTimeZone(int nPort);


/*@fun   PlayM4_SetEncTypeChangeCallBack
* @brief 设置分辨率变化回调
* @para  nPort[IN]                播放端口号(0~31)
* @para  funEncChange[IN]         分辨率变化回调指针
* @para  pUser[IN]                用户指针
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetEncTypeChangeCallBack(int nPort, void(CALLBACK *funEncChange)(int nPort, void* nUser), void* pUser);


/*@fun   PlayM4_SetResChangeCallBack
* @brief 设置分辨率变化回调(带变化后的宽高)
* @para  nPort[IN]                播放端口号(0~31)
* @para  funEncChange[IN]         分辨率变化回调指针
* @para  pUser[IN]                用户指针
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetResChangeCallBack(int nPort, void(CALLBACK *funResChange)(int nPort,int nWidth,int nHeight,void* nUser), void* pUser);

/*@fun   PlayM4_SetEncryptTypeCallBack
* @brief 设置密钥检测回调
* @para  nPort[IN]                播放端口号(0~31)
* @para  nType[IN]                码流类型
* @para  EncryptTypeCBFun[IN]     密钥检测回调指针
* @para  pUser[IN]                用户指针
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetEncryptTypeCallBack(int nPort,
                                                       unsigned int nType,
                                                       void (CALLBACK* EncryptTypeCBFun)(int nPort,ENCRYPT_INFO* pEncryptInfo,void* nUser,int nReserved2),
                                                       void* pUser);




/*@fun   PlayM4_SetRunTimeInfoCallBackEx
* @brief 设置运行信息回调
* @para  nPort[IN]                播放端口号(0~31)
* @para  nModule[IN]              模块类型 （0～3） 见PLAYM4_SOURCE_MODULE/PLAYM4_DEMUX_MODULE/PLAYM4_DECODE_MODULE/PLAYM4_RENDER_MODULE
* @para  RunTimeInfoCBFun[IN]     实时信息回调指针
* @para  pUser[IN]                用户指针
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetRunTimeInfoCallBackEx(int nPort,
                                                          int nModule,
                                                          void (CALLBACK* RunTimeInfoCBFun)(int nPort, RunTimeInfo* pstRunTimeInfo, void* pUser),
                                                          void* pUser);


/*@fun   PlayM4_OpenStreamAdvanced
* @brief SDP开流
* @para  nPort[IN]                播放端口号(0~31)
* @para  nProtocolType[IN]        协议类型
* @para  pstSessionInfo[IN]       会话信息
* @para  nBufPoolSize[IN]         缓存大小
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_OpenStreamAdvanced(int nPort, int nProtocolType, PLAYM4_SESSION_INFO* pstSessionInfo, unsigned int nBufPoolSize);


/*@fun   PlayM4_RegisterAudioDataCallBack
* @brief 设置音频解码数据回调
* @para  nPort[IN]                播放端口号(0~31)
* @para  AudioDataCBFun[IN]       音频解码数据回调指针
* @para  pUser[IN]                用户指针
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_RegisterAudioDataCallBack(int nPort,
                                                          void (CALLBACK* AudioDataCBFun)( int nPort,
                                                                                           char* pBuf,
                                                                                           int   nSize,
                                                                                           int   nSampleRate,
                                                                                           void* nUser),
                                                          void* pUser);


/*@fun   PlayM4_GetStreamOpenMode
* @brief 获取流类型（实时流-0/文件流-1）
* @para  nPort[IN]                播放端口号(0~31)
* return 流类型
* */
PLAYM4_API int __stdcall PlayM4_GetStreamOpenMode(int nPort);


/*@fun   PlayM4_GetFileTotalFrames
* @brief 获取文件总帧数
* @para  nPort[IN]                播放端口号(0~31)
* return 文件总帧数
* */
PLAYM4_API unsigned int __stdcall PlayM4_GetFileTotalFrames(int nPort);


/*@fun   PlayM4_SetPlayPos
* @brief 设置定位播放（按照float，不推荐使用，建议使用PlayM4_SetPlayedTimeEx）
* @para  nPort[IN]                播放端口号(0~31)
* @para  fRelativePos[IN]         定位值
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetPlayPos(int nPort, float fRelativePos);


/*@fun   PlayM4_GetPlayPos
* @brief 获取当前文件播放位置 （按照float，不推荐使用，建议使用PlayM4_GetPlayedTimeEx）
* @para  nPort[IN]                播放端口号(0~31)
* return 当前文件播放位置
* */
PLAYM4_API float __stdcall PlayM4_GetPlayPos(int nPort);


/*@fun   PlayM4_GetPlayedFrames
* @brief 获取当前已播放的帧数
* @para  nPort[IN]                播放端口号(0~31)
* return 当前已播放的帧数
* */
PLAYM4_API unsigned int __stdcall PlayM4_GetPlayedFrames(int nPort);


/*@fun   PlayM4_GetCurrentFrameNum
* @brief 获取当前播放的帧号
* @para  nPort[IN]                播放端口号(0~31)
* return 当前播放的帧号
* */
PLAYM4_API unsigned int __stdcall PlayM4_GetCurrentFrameNum(int nPort);


/*@fun   PlayM4_SetCurrentFrameNum
* @brief 设置定位播放（按照帧号，不推荐使用，建议使用PlayM4_SetPlayedTimeEx）
* @para  nPort[IN]                播放端口号(0~31)
* @para  nFrameNum[IN]            帧号
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetCurrentFrameNum(int nPort, unsigned int nFrameNum);


/*@fun   PlayM4_GetCurrentFrameRate
* @brief 获取当前播放帧率
* @para  nPort[IN]                播放端口号(0~31)
* return 当前播放帧率
* */
PLAYM4_API unsigned int __stdcall PlayM4_GetCurrentFrameRate(int nPort);


/*@fun   PlayM4_ThrowBFrameNum
* @brief 丢B帧 @Deprecated
* @para  nPort[IN]                播放端口号(0~31)
* @para  nNum[IN]                 帧数
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_ThrowBFrameNum(int nPort, unsigned int nNum);


/*@fun   PlayM4_SetJpegQuality
* @brief 设置JPEG图片编码质量（0～100）
* @para  nQuality[IN]             JPEG图像质量（0～100，数值越大质量越好）
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetJpegQuality(int nQuality);


/*@fun   PlayM4_SetDisplayMode
* @brief 设置播放模式
* @para  nPort[IN]                播放端口号(0~31)
* @para  dwType[IN]               播放模式（按照帧率还是时间戳播放，默认按照时间戳播放）
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetDisplayMode(int nPort, unsigned int dwType);


/*@fun   PlayM4_SetDemuxParam
* @brief 设置RTMP封装ChunkSize值 （此接口仅针对RTMP封装码流）
* @para  nPort[IN]                播放端口号(0~31)
* @para  stParam[IN]              RTMP封装参数
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetDemuxParam(int nPort, DemuxParam* stParam);


/*@fun   PlayM4_SetVolume
* @brief 设置音量值 @Deprecated （建议使用PlayM4_AdjustWaveAudio）
* @para  nPort[IN]                播放端口号(0~31)
* @para  nVolume[IN]              音量值
* return fec 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetVolume(int nPort, unsigned short nVolume);

/*@fun   PlayM4_ConvertToBmpFile
* @brief YUV转BMP
* @para  pBuf[IN]                BMP缓存
* @para  nSize[IN]               BMP缓存大小
* @para  nWidth[IN]              宽
* @para  nHeight[IN]             高
* @para  nType[IN]               图片类型
* @para  sFileName[IN]           BMP文件名（包含路径）
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_ConvertToBmpFile(char* pBuf, long nSize, long nWidth, long nHeight, long nType, char *sFileName);


/*@fun   PlayM4_SetPlayIntervalTime
* @brief 设置播放间隔时间（EZVIZ定制接口）
* @para  nPort[IN]                播放端口号(0~31)
* @para  nIntervalTime[IN]        两帧最大间隔时间（ms）
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetPlayIntervalTime(int nPort, int nIntervalTime);


/*@fun   PlayM4_EnableSuperEyeEffect
* @brief 开启超眼追踪效果（EZVIZ定制）
* @para  nPort[IN]                播放端口号(0~31)
* @para  nRegionNum[IN]           窗口索引
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_EnableSuperEyeEffect(int nPort, int nRegionNum);

/*@fun   PlayM4_DisableSuperEyeEffect
* @brief 关闭超眼追踪效果（EZVIZ定制）
* @para  nPort[IN]                播放端口号(0~31)
* @para  nRegionNum[IN]           窗口索引
* @para  nKeepEffect[IN]          关闭前是否保存动态管理信息（0～不保存清零/1～保存）
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_DisableSuperEyeEffect(int nPort, int nRegionNum, int nKeepEffect);

/*@fun   PlayM4_FEC_SetEzvizSSLEffect
* @brief 设置声源定位功能开关（萤石定制）
* @para  nPort[IN]                播放端口号(0~31)
* @para  nSubport[IN]             鱼眼子port号
* @para  bOpen[IN]                开关
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_FEC_SetEzvizSSLEffect(int nPort, int nSubport, bool bOpen);


/*@fun   PlayM4_GetCurrentRegionRect
* @brief 获取当前窗口的显示区域参数
* @para  nPort[IN]                播放端口号(0~31)
* @para  nRegionNum[IN]           窗口索引
* @para  stRect[OUT]              当前窗口的显示区域参数
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_GetCurrentRegionRect(int nPort, int nRegionNum, HKRECT *stRect);


/*@fun   PlayM4_SwitchToWriteData
* @brief 播放库写码流开关（调试使用）
* @para  nPort[IN]          播放端口号(0~31)
* @para  bWrite[IN]         写码流开关 - 取值:0(关闭)/1(开启)
* @para  nDataType[IN]      写下的码流数据类型 - 取值: 0(外部送入播放库源数据) 、1(解析后裸数据) 、 2(解码后数据)、3(渲染前数据)
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SwitchToWriteData(int nPort, int bWrite, int nDataType);


/*@fun   PlayM4_ConfigureLogStatus
* @brief 播放库打印信息开关 （调试使用）
* @para  nPort[IN]             播放端口号(0~31)
* @para  bEnable[IN]           打印开关 - 取值:0(关闭)/1(开启)
* @para  nLogType[IN]          Log类型
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_ConfigureLogStatus(int nPort, int bEnable, int nLogType);


/*@fun   PlayM4_SetPosBGRectColor
* @brief 设置POS信息背景颜色
* @para  nPort[IN]             播放端口号(0~31)
* @para  stBGRectColor[IN]     背景颜色值，见PLAYM4_POS_BGRECT_COLOR定义
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetPosBGRectColor(int nPort, PLAYM4_POS_BGRECT_COLOR stBGRectColor);


/*@fun   PlayM4_SetPrivateFatio
* @brief 设置私有数据字体放大比例
* @para  nPort[IN]             播放端口号(0~31)
* @para  nRatio[IN]            字体放大比例
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetPrivateFatio(int nPort,float nRatio);


/*@fun   PlayM4_SetTargetStreamPID
* @brief 设置TS多路视频流目标流PID （汽车电子使用）
* @para  nPort[IN]             播放端口号(0~31)
* @para  nPID[IN]              目标流PID
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetTargetStreamPID(int nPort, int nPID);


/*@fun   PlayM4_SetRealTimeRenderFrameRateCB
* @brief 设置渲染实时帧率回调
* @para  nPort[IN]                   播放端口号(0~31)
* @para  RealTimeFrameRateCBFun[IN]  渲染实时帧率回调
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetRealTimeRenderFrameRateCB(int nPort,
                                                   void (CALLBACK* RealTimeFrameRateCBFun)(int nPort,PLAYM4_REALTIME_RENDER_INFO stRealTimeRenderInfo));


/*@fun   PlayM4_SetFlipEffect
* @brief 设置画面翻转
* @para  nPort[IN]             播放端口号(0~31)
* @para  nEffect[IN]           见PLAYM4_RENDER_FLIP_EFFECT定义
* @para  bFlag[IN]             0-关闭/1-开启
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetFlipEffect(int nPort, PLAYM4_RENDER_FLIP_EFFECT nEffect, bool bFlag);


/*@fun   PlayM4_SetFlipEffect
* @brief 设置画面旋转
* @para  nPort[IN]             播放端口号(0~31)
* @para  nEffect[IN]           见PLAYM4_RENDER_ROTATE_EFFECT定义
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetRotateEffect(int nPort, PLAYM4_RENDER_ROTATE_EFFECT nEffect);


/*@fun   PlayM4_SetAVCExtendSPSFlag
* @brief 设置H264扩张SPS id标记 —— 用于萤石RTP聚合包解析H264编码码流 (不支持Android/iOS硬解码)
* @para  nPort[IN]                播放端口号(0~31)
* @para  nAVCExtendSPSFlag[IN]    SPS id标记 (0:支持h264 sps id范围为0-15, 1:支持sps id范围为0-31,默认值需设为0)
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetAVCExtendSPSFlag(int nPort, int nAVCExtendSPSFlag);


/*@fun   PlayM4_SetScaleType
* @brief 设置显示Scale类型
* @para  nPort[IN]                播放端口号(0~31)
* @para  nScaleType[IN]           见PLAYM4_ENUM_SCALE_FILL和PLAYM4_ENUM_SCALE_FIT定义（播放库内部默认为PLAYM4_ENUM_SCALE_FILL模式）
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetScaleType(int nPort, int nScaleType);


/*@fun   PlayM4_RegisterVideoFrameCallBack
* @brief 注册视频帧回调(带全局时间) （微影使用）
* @para  nPort[IN]                播放端口号(0~31)
* @para  VideoFrameCBFun[IN]      视频帧回调指针
* @para  pUser                    用户指针
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_RegisterVideoFrameCallBack(int nPort,
                                                           void (CALLBACK* VideoFrameCBFun)(PLAYM4_FRAME_INFO *pstFrameInfo,
                                                                                            PLAYM4_SYSTEM_TIME *pstSystemTime,
                                                                                            int bDettach),
                                                           void* pUser);


/*@fun   PlayM4_SetAudioPriority
* @brief 设置音频优先级，多通道播放下，播放音频等级最高的通道
* @para  nPort[IN]                播放端口号(0~31)
* @para  nLevel[IN]               优先级等级，范围0-32
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetAudioPriority(int nPort, int nLevel);


/*@fun   PlayM4_StopSoundEx
* @brief 关闭指定端口号的声音 （结合PlayM4_SetAudioPriority使用）
* @para  nPort[IN]                播放端口号(0~31)
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_StopSoundEx(int nPort);


/*@fun   PlayM4_RegisterLogCallBack —— 不建议调用，可以使用PlayM4_RegisterLogCallBack接口
* @brief 注册日志回调
* @para  nPort[IN]         播放端口号(0~31)
* @para  LogCBFun[IN]      日志回调函数
* @para  pUser             用户指针
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_RegisterLogCallBack(void (CALLBACK* LogCBFun)(int nPort,int nLogLevel,int nModule,const char* sLog,int nErrCode),
                                                     void* pUser);


/*@fun   PlayM4_SkipAudioData(int nPort, int bSkip) 暂不支持
* @brief 跳过音频数据，未开启音频播放前，默认内部直接跳过音频数据(音频解析后直接跳过)
* @para  nPort[IN]     播放端口号(0~31)
* @para  bSkip[IN]     取值0和1 0表示不跳过，1表示跳过(默认内部直接跳过音频数据(音频解析后直接跳过))
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SkipAudioData(int nPort, int bSkip);

#define PLAYM4_LOGLEVEL_TRACE            0 // 问题追踪
#define PLAYM4_LOGLEVEL_DEBUG            1 // 调试级别
#define PLAYM4_LOGLEVEL_INFO             2 // 信息
#define PLAYM4_LOGLEVEL_WARN             3 // 警告
#define PLAYM4_LOGLEVEL_ERROR            4 // 错误

/*@fun   PlayM4_OpenDebugLogByCB
* @brief 开启回调的调试日志
* @para  nLevel[IN]         日志信息等级
* @para  LogCBFun[IN]       回调函数
* @para  pUser[IN]          用户指针
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_OpenDebugLogByCB(int nLevel,
                                                 void (CALLBACK* LogCBFun)(int nPort,int nLogLevel,int nModule,const char* sLog,int nErrCode),
                                                 void* pUser);


/*@fun   PlayM4_OpenDebugLogByFile
* @brief 开启文件模式的调试日志
* @para  bSwitch[IN]        开关
* @para  nLevel[IN]         日志信息等级
* @para  sFilePath[IN]      文件路径
* @para  nFileSize[IN]      文件大小单位KB，范围[500K - 50M]
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_OpenDebugLogByFile(int nFileSaveMode, bool bSwitch, int nLevel, const char* sFilePath,int nFileSize);

/*@fun   PlayM4_EnableCondVariable
* @brief 使能条件变量(播放库内部会自动关闭音视频同步，不关闭音视频同步开启音频播放会导致音视频画面卡住)
* @para  nPort[IN]       播放端口号(0~31)
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_EnableCondVariable(int nPort);

/*@fun   PlayM4_SetSmoothMode
* @brief 设置Android硬解码平滑模式_仅用于Android硬解码
* @para  nPort[IN]       播放端口号(0~31)
* return 0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetSmoothMode(int nPort, int nSmoothMode);

enum PlayM4_Multi_Track_Num
{
    PlayM4_Multi_Track_MaxNum   = -1,   // 未知流轨道总数，将按照播放库最大轨道数3创建线程资源，通过实时解析解码，控制线程运转
    PlayM4_Multi_Track_Num_2    = 0,
    PlayM4_Multi_Track_Num_3    = 1,
};

/*@fun   PlayM4_MultiTrack_PlayEx
* @brief 开启萤石多轨码流播放(代替PlayM4_Play接口)
* @para  nPort[IN]                       开关
* @para  playM4MultiTrackNum[IN]         取值0
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_MultiTrack_PlayEx(int nPort, PlayM4_Multi_Track_Num playM4MultiTrackNum);

/* @fn int PlayM4_CheckHDecodeCondition
 * @brief  是否检查播放库内部码流是否满足硬解条件
 * @param  nPort[IN]         端口号
 * @param  bFlag[In]         true - 检查码流是否满足硬解条件，如不满足，则直接切软解;  false - 不检查码流是否满足硬解条件，直接走硬解码，内部不切换软解
 * @return 0 - fail or 1 - succ
 */
PLAYM4_API int __stdcall PlayM4_CheckHDecodeCondition(int nPort, bool bFlag);

/* @fn     PlayM4_SetDemuxModel
*  @brief  设置解析输出模式
*  @param  nPort[IN]              端口号
*  @param  nIdemuxType[IN]        设置的模式, = 1 设置编码层断帧, = 2 设置I帧前输出, = 3 同时设置编码层断帧和I帧前输出
*  @param  bTrue[IN] 使能开关     1 - 开启,  0 - 关闭
*  @return  0 - fail or 1 - succ
*/
PLAYM4_API int __stdcall PlayM4_SetDemuxModel(int nPort, unsigned int nIdemuxType, int bTrue);

/* @fn    PlayM4_MultiTrack_OnOff1stIFrmSync
*  @brief  开启和关闭萤石双目首个I帧同步播放(默认开启),需要在PlayM4_MultiTrack_PlayEx前面调用
*  @param  nPort       [IN] 端口号
*  @param  bTrue       [IN] 开关  = true 开启, = false 关闭
*  @return  1-成功，0-失败
*/
PLAYM4_API int __stdcall PlayM4_MultiTrack_OnOff1stIFrmSync(int nPort, bool bTrue);

/* @fn      PlayM4_StartRecord  - 微影定制yuv转基线
*  @brief   开启录像
*  @param   nPort[IN]              端口号
*  @return  0 - fail or 1 - succ
*/
PLAYM4_API int __stdcall PlayM4_StartRecord(int nPort);

/* @fn      PlayM4_StopRecord - 微影定制yuv转基线
*  @brief   停止录像
*  @param   nPort[IN]              端口号
*  @return  0 - fail or 1 - succ
*/
PLAYM4_API int __stdcall PlayM4_StopRecord(int nPort);

/* @fn      PlayM4_SetVidRecordResolution - 微影定制yuv转基线
*  @brief   设置录像分辨率(如不设置，则按照码流实际分辨率进行录制)
*  @param   nPort[IN]              端口号
*  @param   nWidth[IN]             录制-宽[16,4096]
*  @param   nHeight[IN]            录制-高[16,4096]
*  @return  0 - fail or 1 - succ
*/
PLAYM4_API int __stdcall PlayM4_SetVidRecordResolution(int nPort, unsigned int nWidth, unsigned int nHeight);

/* @fn      PlayM4_SetVidRecordSourceType - 微影定制yuv转基线
*  @brief   设置录像编码YUV类型(如不设置，默认按照NV12格式进行编码)
*  @param   nPort[IN]              端口号
*  @param   nSourceType[IN]        编码YUV类型(Android支持NV12和I420,iOS只支持NV12)
*  @return  0 - fail or 1 - succ
*/
PLAYM4_API int __stdcall PlayM4_SetVidRecordSourceType(int nPort, REC_SOURCE_TYPE nSourceType);

/* @fn      PlayM4_RegisterVidRecordEncodeDataCallBack - 微影定制yuv转基线
*  @brief   注册录制编码后数据回调
*  @param   nPort[IN]              端口号
*  @param   encodeDataFunCB[IN]    录像编码回调函数指针(当前播放库内部默认输出H264编码数据)
*  @param   pUser[IN]              用户指针
*  @return  0 - fail or 1 - succ
*/
PLAYM4_API int __stdcall PlayM4_RegisterVidRecordEncodeDataCallBack(int nPort, RecordEncodeDataFunCB encodeDataFunCB, void* pUser);

///* @fn      PlayM4_SetVidRecordEndType - 微影定制yuv转基线(不需要关注)
//*  @brief   设置录像端类型（如不设置，则按渲染后通过抓取RGBA转YUV进行编码)
//*  @param   nPort[IN]              端口号
//*  @param   nEndType[IN]           录像端类型（当前只支持REC_YUV_RENDER_END类型,REC_YUV_DIRECT_END类型后续有需求再扩展）
//*  @return  0 - fail or 1 - succ
//*/
//PLAYM4_API int __stdcall PlayM4_SetVidRecordEndType(int nPort, REC_END_TYPE nEndType);


/* @fn      PlayM4_SetWatermarkFont
*  @brief   设置水印叠加
*  @param   nPort[IN]                  端口号
*  @param   stWatermarkFontInfo[IN]    水印信息
*  @param   nReserved[IN]              保留字段
*  @return  0 - fail or 1 - succ
*/
PLAYM4_API int __stdcall PlayM4_SetWatermarkFont(int nPort, WATERMARK_FONT_INFO* pWatermarkFontInfo, void* nReserved);


/** @fn    PlayM4_MultiTrack_RegisterStreamStateCallBack
*  @brief  萤石多轨流轨道数变化通知回调
* @para  nPort[IN]              播放端口号(0~31)
* @para  StreamStateCBfun[IN]   回调方法，nStreamState如0000 0101（E2：true，E1：false，E0：true）
* @para  pUser[IN]              用户指针
* @return  1-成功，0-失败
*/
PLAYM4_API int __stdcall PlayM4_MultiTrack_RegisterStreamStateCallBack(int nPort,
                                                                       void (CALLBACK* StreamStateCBfun)(int nPort,unsigned char nStreamState,void *pUser),
                                                                        void *pUser);

/** @fn    PlayM4_SetGlobalBaseTime
*  @brief  设置全局时间
* @para  nPort[IN]              播放端口号(0~31)
* @para  stGlobalBaseTime[IN]    时间结构体
* @return  1-成功，0-失败
*/
PLAYM4_API int __stdcall PlayM4_SetGlobalBaseTime(int nPort, PLAYM4_SYSTEM_TIME stGlobalBaseTime);


#ifdef __cplusplus
}
#endif

#endif //_PLAYM4_H_
