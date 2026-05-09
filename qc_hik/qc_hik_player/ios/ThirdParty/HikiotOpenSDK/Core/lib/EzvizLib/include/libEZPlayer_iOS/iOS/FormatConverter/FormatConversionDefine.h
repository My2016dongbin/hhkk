/** @file       FormatConversionDefine.h
 *  @note       HangZhou Hikvision Digital Technology Co., Ltd. All Right Reserved.
 *  @brief      Definitions of struct/enum/variables/constant/error-code of Media Format Conversion dynamic library
 *
 *  @author     Media Play SDK Team of Hikvision
 *
 *  @version    V4.1.6
 *  @date       2021/08/01
 *
 *  @warning
 */
// 看不到日志，上传一条看看能不能看到
#ifndef _FC_DEFINE_H_
#define _FC_DEFINE_H_

/* Definitions in Windows OS */
#ifdef WIN32
    #ifdef _WINDLL
    #define FC_API __declspec(dllexport)
    #else
    #define FC_API __declspec(dllimport)
    #endif
#endif/*_WINDOWS*/

/* Definitions in Linux OS */
#ifdef __linux__
    #define FC_API
    #define __stdcall
#endif/*__linux__*/

/* Definitions in MAX OS */
#ifdef __APPLE__
    #define FC_API
    #define __stdcall
#endif/*__APPLE__*/

/* 定义格式转换句柄类型 */
typedef void*   FCHANDLE;

/* 状态码定义 */
#define FC_OK               0           ///< 成功，无错误
#define FC_E_HANDLE         0x80000000  ///< 错误或无效的句柄
#define FC_E_SUPPORT        0x80000001  ///< 不支持的功能
#define FC_E_BUFOVER        0x80000002  ///< 缓存已满
#define FC_E_CALLORDER      0x80000003  ///< 函数调用顺序错误
#define FC_E_PARAMETER      0x80000004  ///< 错误的参数
#define FC_E_NEEDMOREDATA   0x80000005  ///< 需要更多的数据
#define FC_E_RESOURCE       0x80000006  ///< 资源申请失败
#define FC_E_STREAM         0x80000007  ///< 码流出错
#define FC_E_DEMUXER        0x80000008  ///< 解析异常
#define FC_E_MUXER          0x80000009  ///< 打包异常
#define FC_E_DECODER        0x8000000a  ///< 解码异常
#define FC_E_ENCODER        0x8000000b  ///< 编码异常
#define FC_E_POSTPROC       0x8000000c  ///< 后处理异常
#define FC_E_FILE           0x8000000d  ///< 文件操作异常
#define FC_E_KEY            0x8000000e  ///< 码流未设置或者密钥错误
#define FC_E_HWDECODER      0x8000000f  ///< 第三方（萤石）
#define FC_E_UNKNOW         0x800000ff  ///< 未知的错误

/* 码流封装格式 */
typedef enum FC_FormatType
{
    FC_FORMAT_NULL          = 0x0,      ///< 无封装

    /* 以下为海康基线支持的封装格式 */
    FC_FORMAT_HIK           = 0x0001,   ///< 海康私有封装
    FC_FORMAT_MPEG2_PS      = 0x0002,   ///< PS
    FC_FORMAT_MPEG2_TS      = 0x0003,   ///< TS
    FC_FORMAT_RTP           = 0x0004,   ///< RTP
    FC_FORMAT_MP4           = 0x0005,   ///< MP4
    FC_FORMAT_AVI           = 0x0007,   ///< AVI
    FC_FORMAT_RTPJT         = 0x0104,   ///< 1078协议
    FC_FORMAT_DHAV          = 0X8001,   ///< 大华码流封装格式

    /* 以下封装格式海康基线暂不支持 */
    FC_FORMAT_ASF           = 0x0006,   ///< ASF
    FC_FORMAT_FLV           = 0x000a,   ///< FLV
    FC_FORMAT_MOV           = 0x0021,   ///< MOV
    FC_FORMAT_3GP,                      ///< 3GP
    FC_FORMAT_MKV,                      ///< MKV
    FC_FORMAT_WEBM,                     ///< WEBM
    FC_FORMAT_SWF,                      ///< SWF
    FC_FORMAT_RM                        ///< RM
};

/* 音视频编码格式 */
typedef enum FC_CodecType
{
    FC_CODEC_NONE           = 0x0,      ///< 无编码

    /* 以下为海康基线支持的视频编码 */
    FC_CODEC_V_HIK264       = 0x0001,   ///< 海康私有编码
    FC_CODEC_V_MPEG2        = 0x0002,   ///< MPEG2
    FC_CODEC_V_MPEG4        = 0x0003,   ///< MPEG4
    FC_CODEC_V_MJPEG        = 0x0004,   ///< MJPEG
    FC_CODEC_V_H265         = 0x0005,   ///< H265
    FC_CODEC_V_SVAC         = 0x0006,   ///< SVAC
    FC_CODEC_V_H264         = 0x0100,   ///< H264

    /* 以下视频编码海康基线暂不支持 */
    FC_CODEC_V_YV12         = 0x0801,   ///< YV12
    FC_CODEC_V_I420,
    FC_CODEC_V_RV30,                    ///< RV30
    FC_CODEC_V_RV40,                    ///< RV40
    FC_CODEC_V_MSMPEG4V1,               ///< MSMPEG4V1
    FC_CODEC_V_MSMPEG4V2,               ///< MSMPEG4V2
    FC_CODEC_V_MSMPEG4V3,               ///< MSMPEG4V3
    FC_CODEC_V_WMV1,                    ///< WMV1
    FC_CODEC_V_WMV2,                    ///< WMV2
    FC_CODEC_V_WMV3,                    ///< WMV3
    FC_CODEC_V_FLV1,                    ///< FLV1
    FC_CODEC_V_FLASHSV,                 ///< FLASHSV
    FC_CODEC_V_H263,                    ///< H263
    FC_CODEC_V_MPEG1,                   ///< MPEG1
    FC_CODEC_V_MSV1,                    ///< MSV1
    FC_CODEC_V_VC1,                     ///< VC1
    FC_CODEC_V_VP8,                     ///< VP8
    FC_CODEC_V_VP9,                     ///< VP9
    FC_CODEC_V_MXPEG,                   ///< MXPEG
    FC_CODEC_V_RGB32,                   ///< RGB32
    FC_CODEC_V_RGB24,                   ///< RGB24

    /* 以下为海康基线支持的音频编码 */
    FC_CODEC_A_ADPCM        = 0x1000,   ///< ADPCM
    FC_CODEC_A_MP2          = 0x2000,   ///< MPEG AUDIO
    FC_CODEC_A_AAC          = 0x2001,   ///< AAC
    FC_CODEC_A_AACLD        = 0x2002,   ///< AAC_LD
    FC_CODEC_A_OPUS         = 0x3002,   ///< OPUS
    FC_CODEC_A_PCM          = 0x7001,   ///< PCM16
    FC_CODEC_A_PCMU         = 0x7110,   ///< G711U
    FC_CODEC_A_PCMA         = 0x7111,   ///< G711A
    FC_CODEC_A_G722         = 0x7221,   ///< G722
    FC_CODEC_A_G726         = 0x7262,   ///< G726

    /* 以下音频编码海康基线暂不支持 */
    FC_CODEC_A_G723_1       = 0x7231,   ///< G7231
    FC_CODEC_A_G729         = 0x7290,   ///< G729
    FC_CODEC_A_MP3          = 0x8001,   ///< MP3
    FC_CODEC_A_COOK,                    ///< COOK
    FC_CODEC_A_AMR_NB,                  ///< AMR_NB
    FC_CODEC_A_AMR_WB,                  ///< AMR_WB
    FC_CODEC_A_AC3,                     ///< AC3
    FC_CODEC_A_DTS,                     ///< DTS
    FC_CODEC_A_VORBIS,                  ///< VORBIS
    FC_CODEC_A_DVAUDIO,                 ///< DVAUDIO
    FC_CODEC_A_WMAV1,                   ///< WMAV1
    FC_CODEC_A_WMAV2,                   ///< WMAV2
    FC_CODEC_A_WMAVOICE,                ///< WMAVOICE
    FC_CODEC_A_WMAPRO,                  ///< WMAPRO
    FC_CODEC_A_WMALOSSLESS,             ///< WMALOSSLESS
    FC_CODEC_A_FLAC,                    ///< FLAC
};

/* 输入的数据类型 */
typedef enum FC_DataType 
{
    FC_MULTI_DATA              = 0x00,     ///< 混合流
    FC_VIDEO_DATA              = 0x01,     ///< 视频流
    FC_AUDIO_DATA              = 0x02,     ///< 音频流
    FC_PRIVATE_DATA            = 0x03,     ///< 私有流（暂不支持）
    FC_VIDEO_PARA              = 0x04,     ///< 视频参数（暂不支持）
    FC_AUDIO_PARA              = 0x05,     ///< 音频参数（暂不支持）
    FC_PRIVATE_PARA            = 0x06,     ///< 私有参数（暂不支持）
    FC_VIDEO_RAWDATA           = 0x07,     ///< 视频裸数据
    FC_AUDIO_RAWDATA           = 0x08,     ///< 音频裸数据
    FC_VIDEO_DECODEDDATA       = 0x09,     ///< 视频解码后数据
    FC_AUDIO_DECODEDDATA       = 0x0a,     ///< 音频解码后数据
};

/* 最大轨道数 */
#define FC_MAX_TRACK_COUNT      8       ///< 最大轨道数为8

/* 密钥类型 */
#define FC_KEYTYPE_NULL         0       ///< 不加密
#define FC_KEYTYPE_AES          1       ///< AES加密

/* 网络协议类型 */
#define FC_PROTOCOL_NULL        0       ///< 无网络协议
#define FC_PROTOCOL_HIK         1       ///< 海康私有协议
#define FC_PROTOCOL_RTSP        2       ///< RTSP协议

/* 交互信息类型 */
#define FC_SESSION_MEDIADATA    0       ///< 直接使用媒体数据进行交互，建议输入100k以上数据量
#define FC_SESSION_HIK          1       ///< 40字节海康头
#define FC_SESSION_SDP          2       ///< SDP信息
#define FC_SESSION_MEDIAINFO    3       ///< 媒体信息，即FC_MEDIA_INFO结构体

/* 输出包类型 */
#define FC_UNKNOW_PACKET        0       ///< 未知类型
#define FC_VIDEO_PACKET         1       ///< 视频包
#define FC_AUDIO_PACKET         2       ///< 音频包
#define FC_PRIVT_PACKET         3       ///< 私有包
#define FC_HIK_FILE_HEADER      4       ///< 海康媒体头，40字节
#define FC_FILE_HEADER          5       ///< 通用文件头，如AVI,MP4等的文件头
#define FC_INDEX_FRONT          6       ///< 前置的索引
#define FC_INDEX_BACK           7       ///< 后置的索引
#define FC_PROCESS_ENDDATA      8       ///< 指示数据已经处理结束
#define FC_VIDEO_PACKET_LAST    9       ///< 视频一帧的最后一包
#define FC_AUDIO_PACKET_LAST    10      ///< 音频一帧的最后一包
#define FC_SDP_PACKET           11      ///< SDP信息（RTP封装）

/* 转码策略 */
#define FC_STRATEGY_DEFAULT      0       ///< 默认转码策略
#define FC_STRATEGY_MAXRES       1       ///< 优先转码最大分辨率
#define FC_STRATEGY_MINRES       2       ///< 最小分辨率优先
#define FC_STRATEGY_FAST         3       ///< 速度优先
#define FC_STARTEGY_DETAILINFO   4       ///< 获取详细信息
#define FC_STARTEGY_DETECTBFRAME 5       ///< 获取是否有B帧

/* 后处理数据类型 对应接口FC_SetPostProcInfo nPostProcType */
#define  FC_POSTPROCTYPE_OVERLAY_TEXT   0x01      ///< 字符叠加
#define  FC_POSTPROCTYPE_OVERLAY_RECT   0x02      ///< 叠加矩形区域
#define  FC_POSTPROCTYPE_OVERLAY_PPOS   0x04       ///< 私有POS帧叠加

/* 字符叠加相关宏 */
#define FC_MAX_POS_LENGTH        128     ///< 最大字符串叠加长度
#define FC_MAX_POS_LINE          32      ///< 最大行数

/* 视频信息结构体 */
typedef struct FC_VIDEO_INFO_STRU
{
    FC_CodecType        enCodec;        ///< 视频编码
    unsigned int        nTrackId;       ///< 轨道号（暂不支持）
    unsigned int        nBitRate;       ///< 码率（单位Kbps）
    float               fFrameRate;     ///< 帧率
    unsigned short      nWidth;         ///< 图像宽度
    unsigned short      nHeight;        ///< 图像高度
} FC_VIDEO_INFO;

/* 音频信息结构体 */
typedef struct FC_AUDIO_INFO_STRU
{
    FC_CodecType        enCodec;        ///< 音频编码
    unsigned int        nTrackId;       ///< 轨道号（暂不支持）
    unsigned short      nChannels;      ///< 声道数
    unsigned short      nBitsPerSample; ///< 样位率
    unsigned int        nSamplesRate;   ///< 采样率
    unsigned int        nBitRate;       ///< 比特率
} FC_AUDIO_INFO;

/* 私有信息结构体 */
typedef struct FC_PRIVT_INFO_STRU
{
    unsigned int        nType;          ///< 私有数据类型
    unsigned int        nTrackId;       ///< 轨道号（暂不支持）
} FC_PRIVT_INFO;

/* 媒体信息结构体 */
typedef struct FC_MEDIA_INFO_STRU
{
    FC_FormatType       enSystemFormat;                     ///< 封装格式
    unsigned int        nVideoStreamCount;                  ///< 视频流数量
    unsigned int        nAudioStreamCount;                  ///< 音频流数量
    unsigned int        nPrivtStreamCount;                  ///< 私有流数量
    FC_VIDEO_INFO       stVideoInfo[FC_MAX_TRACK_COUNT];    ///< 视频信息
    FC_AUDIO_INFO       stAudioInfo[FC_MAX_TRACK_COUNT];    ///< 音频信息
    FC_PRIVT_INFO       stPrivtInfo[FC_MAX_TRACK_COUNT];    ///< 私有信息
    unsigned int        nStreamFlag;                        ///< 码流格式标记,外部暂时不用
    unsigned int        nReserved[3];                       ///< 保留字段,nReserved[0] 为1时，表示有B帧，否者没有B帧
} FC_MEDIA_INFO;

/* 交互信息结构体 */
typedef struct FC_SESSION_INFO_STRU
{
    unsigned int        nSessionInfoType;                   ///< 交互信息类型
    unsigned int        nSessionInfoLen;                    ///< 交互信息长度
    unsigned char*      pSessionInfoData;                   ///< 交互信息数据
    unsigned int        nReserved[4];                       ///< 保留字段
} FC_SESSION_INFO;

/* 全局时间结构体 */
typedef struct FC_GLOBAL_TIME_STRU
{
    unsigned short      sYear;                              ///< 年
    unsigned short      sMonth;                             ///< 月
    unsigned short      sDayOfWeek;                         ///< 周
    unsigned short      sDay;                               ///< 日
    unsigned short      sHour;                              ///< 时
    unsigned short      sMinute;                            ///< 分
    unsigned short      sSecond;                            ///< 秒
    unsigned short      sMilliseconds;                      ///< 毫秒
} FC_GLOBAL_TIME;

/* 解码后数据结构体 */
typedef struct FC_DECODED_DATA_STRU
{
    unsigned char*      pData;                              ///< 数据指针
    unsigned int        nFrameLen;                          ///< 数据长度
    unsigned int        nFrameNum;                          ///< 帧号
    unsigned int        nTimeStamp;                         ///< 时间戳
    FC_GLOBAL_TIME*     pGlobalTime;                        ///< 全局时间
} FC_DECODED_DATA;

/* 送入转码库的裸数据 */
typedef struct FC_RAWFRAME_DATA_STRU
{
    unsigned char*      pData;                              ///< 数据指针
    unsigned int        nFrameLen;                          ///< 数据长度

    unsigned int        nFrameNum;                          ///< 帧号
    unsigned int        nTimeStamp;                         ///< 时间戳
    FC_GLOBAL_TIME*     pGlobalTime;                        ///< 全局时间

    //以下为音视频共用信息
    unsigned int        nWidthOrChannels;                   ///< 视频宽或音频声道数
    unsigned int        nHeightOrSmpRate;                   ///< 视频高或音频采样率
    unsigned int        nFrameTypeOrBPS;                    ///< 视频帧类型或音频样位率
    void*               pFCUser;                            ///< 转码库指针，回调用

    //目前用不到
    unsigned int        nReserved[8];                       ///< 帧类型
} FC_RAWFRAME_DATA;

/* 转码库字符叠加行信息 */
typedef struct FC_POS_PARAM_STRU
{
    unsigned char chR;                                      ///< 颜色红色通道
    unsigned char chG;                                      ///< 颜色绿色通道
    unsigned char chB;                                      ///< 颜色蓝色通道

    float         fAlpha;                                   ///< 叠加透明度（取值范围0-1）
    unsigned int  nTextSize;                                ///< 字符大小 1-64
    char          strFontPath[256];                         ///< 字符路径

    float         fRotateAngle;                             ///< 旋转角度，暂未实现

    unsigned char nReserverd[32];                           ///< 保留字段

}FC_POS_PARAM;

/* 转码库字符叠加参数 */
typedef struct FC_POS_LINE_STRU
{
    unsigned int nPosX;                                    ///< 当前字符串起始坐标X
    unsigned int nPosY;                                    ///< 当前字符串起始坐标Y
    wchar_t      strPOS[FC_MAX_POS_LENGTH];                ///< 待叠加字符串内容

    FC_POS_PARAM stPOSParam;                               ///< 叠加信息
}FC_POS_LINE;

/* 转码库字符叠加信息 */
typedef struct FC_POS_INFO_STRU
{
    FC_POS_LINE  *pstFCPosLine;                            ///< 字符叠加数组
    unsigned int nLineNum;                                 ///< 叠加字符行数

    unsigned char nReserved[32];                           ///< 保留字段
                                                           ///< 当nReserved[0]为1时，表示坐标为相对坐标（取值范围0-1000）
}FC_POS_INFO;

/* 叠加矩形区域参数 */
typedef struct FC_OVERLAY_RECT_PARAM_STRU
{
    unsigned int nStartPointX;   //起始坐标X(相对坐标，范围0-1000)
    unsigned int nStartPointY;   //起始坐标Y(相对坐标，范围0-1000)
    unsigned int nEndPointX;     //终点坐标X(相对坐标，范围0-1000)
    unsigned int nEndPointY;     //终点坐标Y(相对坐标，范围0-1000)

    unsigned char nR;            //颜色R分量
    unsigned char nG;            //颜色G分量
    unsigned char nB;            //颜色B分量

    unsigned int nFalphaNum;     //透明度分子
    unsigned int nFalphaDenom;   //透明度分母
}FC_OVERLAY_RECT_PARAM;


typedef enum _FC_INSPECT_MODE
{
    FC_INSPECT_NOMAL = 0,

}FC_INSPECT_MODE;


/* 视频信息结构体 */
typedef struct 
{
    FC_CodecType        enCodec;        ///< 视频编码
    unsigned int        nTrackId;       ///< 轨道号（暂不支持）
    unsigned int        nBitRate;       ///< 码率（单位Kbps）
    float               fFrameRate;     ///< 帧率
    unsigned short      nWidth;         ///< 图像宽度
    unsigned short      nHeight;        ///< 图像高度
    unsigned int        nTotalTime;     ///< 总时长
    unsigned int        nTotalNum;      ///< 总帧数

    unsigned char       cDevChanID[16]; ///< 设备和通道信息
    unsigned char       nResevesd[16];
} FC_VIDEO_INFO_V2;


/* 媒体探测结构体 */
typedef struct 
{
    FC_FormatType       enSystemFormat;                     ///< 封装格式
    unsigned int        nVideoStreamCount;                  ///< 视频流数量
    unsigned int        nAudioStreamCount;                  ///< 音频流数量
    unsigned int        nPrivtStreamCount;                  ///< 私有流数量
    FC_VIDEO_INFO_V2    stVideoInfo[FC_MAX_TRACK_COUNT];    ///< 视频信息
    FC_AUDIO_INFO       stAudioInfo[FC_MAX_TRACK_COUNT];    ///< 音频信息
    unsigned int        nReserved[3];                       ///< 保留字段
} FC_INSPCT_INFO;


#endif //_FC_DEFINE_H_
