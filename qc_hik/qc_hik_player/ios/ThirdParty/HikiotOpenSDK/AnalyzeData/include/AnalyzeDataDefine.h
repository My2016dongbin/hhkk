/** @file    AnalyzeDataDefine.h
  * @note    Copyright (c) 2014, Hikvision Digital Technology Co., Ltd.
  * @brief   analyzeData library struct and macro define
  *
  * @author  PlaySDK Group
  * @date    06/02/2015
  *
  * @note    Version 5.1.1.5
  *
  * @warning
  */

#ifndef _ANALYZEDATA_DEFINE_H_
#define _ANALYZEDATA_DEFINE_H_


#ifdef  WIN32
#ifndef HK_WIN32
#define HK_WIN32 WIN32
#endif
#endif


#ifdef  __linux__
#ifndef HK_LINUX
#define HK_LINUX __linux__
#endif
#endif

#ifdef  __APPLE__
#ifndef HK_APPLE
#define HK_APPLE  __APPLE__
#endif
#endif

#ifdef  HK_WIN32
#ifdef  _WINDLL
#define ANALYZEDATA_API extern "C" _declspec(dllexport)
#else
#define ANALYZEDATA_API extern "C" _declspec(dllimport)
#endif
#endif

#ifdef  HK_LINUX 
#ifndef ANALYZEDATA_API
#define ANALYZEDATA_API
#endif
#ifndef __stdcall
#define __stdcall
#endif
#endif


#ifdef  HK_APPLE 
#ifndef ANALYZEDATA_API
#define ANALYZEDATA_API
#endif
#ifndef __stdcall
#define __stdcall
#endif
#endif


// packet type
#define FILE_HEAD                   0               // file head
#define VIDEO_I_FRAME               1               // video I frame
#define VIDEO_B_FRAME               2               // video B frame
#define VIDEO_P_FRAME               3               // video P frame
#define AUDIO_PACKET                10              // audio packet
#define PRIVT_PACKET                11              // private packet
#define ERRDATA_PACKET              20              // 错误数据

// E frame
#define HIK_H264_E_FRAME            (1 << 6)        // 以前E帧不用了,深P帧也没用到

// error code
#define ERROR_NOOBJECT              -1              // not valid handle
#define ERROR_NO                    0               // no error
#define ERROR_OVERBUF               1               // buf over flow
#define ERROR_PARAMETER             2               // parameter error
#define ERROR_CALL_ORDER            3               // call order error
#define ERROR_ALLOC_MEMORY          4               // memory not enough
#define ERROR_OPEN_FILE             5               // open file error
#define ERROR_MEMORY                6               // memory error
#define ERROR_SUPPORT               7               // not support
#define ERROR_NODATA                8               // no data in buf
#define ERROR_NEED_MOREDATA         9               // need more data
#define ERROR_ERROR_DATA            10              // 错误数据
#define ERROR_UNKNOWN               99              // unknown error


// 过滤svc NALU优先级，ntype可以区分如只解析出视频，视频I帧，音频，SVC优先级设定等，宏具体定义
#define ANALYZE_NORMAIL              0              // 全部解析,默认值
#define ANALYZE_KEY_FRAME            1              // 只解析I帧
#define ANALYZE_TEMPORAL_LAYER_0     2              // 丢1/2解1/2，非精确
#define ANALYZE_TEMPORAL_LAYER_1     3              // 丢3/4解1/4，非精确

// 分析结果输出类型
#define ANALYZE_ENCAPSULATED_DATA    0              // 带封装数据，默认值
#define ANALYZE_RAW_DATA             1              // 裸数据
#define ANALYZE_FAST_CHECK           2              // 快速检测（带封装输出）
#define ANALYZE_ERROR_DATA           3              // 错误数据接口输出(带封装输出)

// 打包类型
#define ANALYZE_SECRET_PACKET_RES   0x00            // 保留
#define ANALYZE_SECRET_PACKET_FUA   0x01            // FU_A打包方式
// 加密算法
#define ANALYZE_SECRET_ARITH_NONE   0x00            // 不加密
#define ANALYZE_SECRET_ARITH_AES    0x01            // AES加密
// 加密类型
#define ANALYZE_SECRET_TYPE_ZERO    0x00            // 保留
#define ANALYZE_SECRET_TYPE_16B     0x01            // 各帧前16byte加密
#define ANALYZE_SECRET_TYPE_4KB     0x02            // 各帧前4096byte加密
// 加密轮数
#define ANALYZE_SECRET_ROUND00      0x00            // 保留
#define ANALYZE_SECRET_ROUND03      0x01            // 3轮加密
#define ANALYZE_SECRET_ROUND10      0x02            // 10轮加密
#define ANALYZE_SECRET_ROUND14      0x03            // 14轮加密
// 密钥长度
#define ANALYZE_SECRET_KEYLEN000    0x00            // 保留
#define ANALYZE_SECRET_KEYLEN128    0x01            // 128bit
#define ANALYZE_SECRET_KEYLEN192    0x02            // 192bit
#define ANALYZE_SECRET_KEYLEN256    0x03            // 256bit

typedef enum
{
    ANALYZE_NONE                    = 0x00,         // none intelligent data
    ANALYZE_ITS_AID_INFO_V2         = 0x10,         // its aid information
    ANALYZE_ITS_TPS_INFO_V2         = 0x11,         // its tps information
    ANALYZE_ITS_TARGET_LIST         = 0x12,         // its target list
    ANALYZE_ITS_TPS_RULE_LIST       = 0x13,         // rule list
    ANALYZE_VCA_TARGET_LIST         = 0x20,         // vca target list
    ANALYZE_VCA_ALERT               = 0x21,         // vca alert
    ANALYZE_VCA_RULE_LIST           = 0x22,         // vca rule list
    ANALYZE_VCA_EVT_INFO_LIST       = 0x23,         // vca event information
    ANALYZE_FACE_IDENTIFICATION     = 0x30,         // face identification
    ANALYZE_FACE_DETECT_RULE        = 0x31,         // face detect rule
    INTELLIGENT_IVS_INDEX           = 0x40,         // ivs index data
    ANALYZE_INTEL_UNKNOWN           = 0x99          // 未知数据类型
}INTELLIGENT_DATA_TYPE;

typedef enum
{
    ANALYZE_RTP_PACKET_NUM          = 0x10,         // RTP视频包序不连续
    ANALYZE_RTP_HEADER              = 0x11,         // RTP头有误，包括扩展头
    ANALYZE_MPEG_PACKET_PSH         = 0x20,         // PSH有误
    ANALYZE_MPEG_PACKET_PSM         = 0x21,         // PSM有误
    ANALYZE_MPEG_PACKET_PES         = 0x22,         // PES有误
    ANALYZE_TS_HEADER               = 0x30,         // TS头有误
    ANALYZE_MPEG_PACKET_PAT         = 0x31,         // PAT有误
    ANALYZE_MPEG_PACKET_PMT         = 0x32,         // PMT有误
    ANALYZE_REDUNDANT               = 0x40,         // 码流里有冗余数据，或者包长度不对
    ANALYZE_STREAM_HEADER           = 0x50,         // 创建句柄时的码流头有误
    ANALYZE_STREAM_RATE             = 0x60,         // 封装层帧率与编码层帧率不一致
    ANALYZE_STREAM_RESOLUT          = 0x61,         // 封装层分辨率与编码层分辨率不一致
    ANALYZE_STREAM_ERROR_DATA       = 0x90,         // 错误数据
    ANALYZE_ERROR_UNKNOWN           = 0x99,         // 码流有未知错误
}STREAM_ERROR_TYPE;

typedef struct _ANA_ERROR_INFOR_
{
    unsigned int            nErrorType;             // 错误类型
    unsigned char*          pHeaderData;            // 若头有误，送出实际码流头，默认40字节
    unsigned char*          pErrorData;             // 当错误类型为ANALYZE_STREAM_ERROR_DATA，输出错误数据
    unsigned int            nErrorLen;              // 输出数据长度
    unsigned int            Reserved[4];            // reserved
}ANA_ERROR_INFOR;

/** @struct ANA_VIDEO_INFO
 *  @brief  视频流信息结构体
 */
typedef struct
{
    unsigned int            nVideoFormat;           // 视频编码格式
    unsigned int            nTotalTtime;            // 视频总时长
    unsigned int            nWidth;                 // 视频宽
    unsigned int            nHeight;                // 视频高
    unsigned int            nFrameRate;             // 帧率
    unsigned int            Reserved[3];            // 保留字段
} ANA_VIDEO_INFO;

/** @struct ANA_AUDIO_INFO
 *  @brief  音频信息结构体
 */
typedef struct
{
    unsigned short          nAudioFormat;           // 音频编码格式
    unsigned char           nAudioChannels;         // 声道数
    unsigned char           nAudioBitsPerSample;    // 样位
    unsigned int            nAudioSamplesRate;      // 采样率
    unsigned int            nAudioBitRate;          // 比特率
    unsigned int            nTotalTime;             // 总的时间
    unsigned int            Reserved[4];            // 保留字段
} ANA_AUDIO_INFO;

typedef struct _PACKET_INFO
{
    unsigned int            dwTimeStamp;            // time stamp
    unsigned int            nYear;                  // year
    unsigned int            nMonth;                 // month
    unsigned int            nDay;                   // day
    unsigned int            nHour;                  // hour
    unsigned int            nMinute;                // minute
    unsigned int            nSecond;                // second
    unsigned int            nPacketType;            // packet type
    unsigned int            dwPacketSize;           // packet size 
    unsigned char*          pPacketBuffer;          // packet buffer
} PACKET_INFO;

typedef struct _ANA_MFI_HEADER_
{
    unsigned char           stream_type;            // 元素流类型，byte
    unsigned char           frame_type;             // 帧类型，byte
    unsigned char           frame_sequence;         // 小帧号，byte
    unsigned char           frame_sum;              // 小帧总数，byte
    unsigned int            frame_len;              // 小帧数据长度，byte
    unsigned char           reserved[4];            // 保留字节
}ANA_MFI_HEADER;                                    // 2400W复合流结构体；输出为裸流时，2400W码流分析库输出结构为：MFI_HEADER+子码流(裸流)+MFI_HEADER+子码流(裸流)+...

typedef struct _PACKET_INFO_EX
{
    unsigned short          uWidth;                 // width
    unsigned short          uHeight;                // height
    unsigned int            dwTimeStamp;            // lower time stamp
    unsigned int            dwTimeStampHigh;        // higher time stamp 
    unsigned int            nYear;                  // year
    unsigned int            nMonth;                 // month
    unsigned int            nDay;                   // day
    unsigned int            nHour;                  // hour
    unsigned int            nMinute;                // minute
    unsigned int            nSecond;                // second
    unsigned int            nMillisecond;           // millisecond
    unsigned int            dwFrameNum;             // frame num
    unsigned int            dwFrameRate;            // frame rate,当帧率小于1时，0x80000002:表示1/2帧率，同理可推0x80000010为1/16帧率
    unsigned int            dwFlag;                 // flag E帧标记
    unsigned int            dwFilePos;              // file pos//////////////// 1：表示3gp文件解析完成标记
    unsigned int            nPacketType;            // packet type
    unsigned int            dwPacketSize;           // packet size
    unsigned char*          pPacketBuffer;          // packet buffer
    unsigned int            dwEncrypted;            // if Encrypted. !0 for yes, 0 for no
    unsigned int            dwPacketType;           // 打包方式
    unsigned int            dwEncryptArith;         // 加密算法
    unsigned int            dwEncryptRound;         // 加密轮数
    unsigned int            dwKeyLen;               // 密钥长度
    unsigned int            dwEncryptType;          // 加密类型
    unsigned int            Reserved[6];            // reserved[0] 当为私有帧时，表示私有数据类型；
                                                    //             当为音频帧时，表示音频的通道号；
                                                    //             当为视频帧时，对于PS码流，表示Stream ID;对于RTP码流，表示对应SSRC值;对于TS流，表示PID值。
                                                    // reserved[1] 当为私有帧时，表示私有裸数据地址高位。
                                                    //             当为视频帧时，表示视频编码类型。
                                                    //             当为音频帧时，表示音频编码类型。
                                                    // reserved[2] 当为私有帧时，表示私有裸数据地址低位。
                                                    //             当为音频帧时，高16位表示音频通道号，低16位表示音频样位率；
                                                    // reserved[3] 当为私有帧时，表示私有裸数据长度。
                                                    //             当为音频帧时，表示音频采样率
                                                    // reserved[4] 当为私有帧时，表示私有帧的时间间隔/时间戳；
                                                    //             当为视频帧时，如果是I帧，    Reserved[4] |= 0x00000001，标记为svc码流，              Reserved[4] &= 0xFFFFFFFE，标记非svc码流；
                                                    //             当为音频帧时，表示音频压缩码率（bitrate）
                                                    // reserved[5] 当为视频帧时，如果是I帧，    Reserved[5] |= 0x00000001，标记为smart264/smart265码流，Reserved[5] &= 0xFFFFFFFE，标记非smart264/smart265码流；
                                                    //                           如果是P帧，    Reserved[5] |= 0x00000001，标记为深P帧，                Reserved[5] &= 0xFFFFFFFE，标记非深P帧; 
                                                    //                           如果是I/P/B帧，Reserved[5] |= 0x00000002，标记为小鹰眼码流，           Reserved[5] &= 0xFFFFFFFD，标记非小鹰眼码流;              
                                                    //                           如果是I/P/B帧，Reserved[5] |= 0x00000004，标记为2400W码流，            Reserved[5] &= 0xFFFFFFFB，标记非2400W码流; 
                                                    //                           如果是I/P/B帧，Reserved[5] |= 0x00000008，标记为intra码流，            Reserved[5] &= 0xFFFFFFF7，标记非intra码流;
                                                    //                           如果是I/P/B帧，Reserved[5] |= 0x00000010，标记为Infinit GOP码流，      Reserved[5] &= 0xFFFFFFEF，标记非Infinit GOP码流;
                                                    //                           如果是I/P/B帧，Reserved[5] |= 0x00000020，标记为多场码流，             Reserved[5] &= 0xFFFFFFDF，标记非多场码流;
                                                    //             当为私有帧时，表示当前私有帧所属视频的通道号，比如E0到EF
} PACKET_INFO_EX;

// 文件信息结构体
typedef struct _ANA_FILE_INFO_
{
    unsigned int            system_format;          // 系统层格式
    ANA_VIDEO_INFO          stVideoInfo;            // 视频信息
    ANA_AUDIO_INFO          stAudioInfo;            // 音频信息
    unsigned int            Reserved[7];            // 保留字段
}ANA_FILE_INFO;

typedef struct _ANA_SEEK_INFO_
{
    unsigned int      enSeekType;             // 定位方式（时间戳定位or帧号定位,1是帧号，2是时间戳）
    unsigned int      dwSeekTimeStamp;        // 定位时间(ms)
    unsigned int      dwSeekFrameNum;         // 定位帧号
}ANA_SEEK_INFO;

#endif

