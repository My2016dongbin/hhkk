/** @file       FormatConversionInterfaceEx.h 
 *  @note       HangZhou Hikvision Digital Technology Co., Ltd. All Right Reserved.
 *  @brief      Definitions of inner interfaces of Media Format Conversion dynamic library
 *
 *  @author     Media Play SDK Team of Hikvision
 *
 *  @version    V4.1.6
 *  @date       2021/08/01
 *
 *  @warning    内部接口，不对外发布
 */

#ifndef _FC_INTERFACE_EX_H_
#define _FC_INTERFACE_EX_H_

#include "FormatConversionDefine.h"

/* 能力类型 */
#define CAP_DECODE          (1 << 0)    ///< 解码
#define CAP_POSTPROC        (1 << 1)    ///< 后处理（暂不支持）
#define CAP_ENCODE          (1 << 2)    ///< 编码

/* 能力值 */
#define DECODE_CPU          (1 << 0)    ///< CPU解码
#define DECODE_GPU          (1 << 1)    ///< GPU解码（实际效果为GPU转码）
#define DECODE_THIRD        (1 << 2)    ///< 第三方解码（暂不支持）
#define ENCODE_CPU          (1 << 4)    ///< CPU编码
#define ENCODE_GPU          (1 << 5)    ///< GPU编码(使用INTEL引擎)
#define ENCODE_CPU_OPENH264 (1 << 6)    ///< OPENH264编码
#define ENCODE_GPU_NVIDIA   (1 << 7)    ///< 使用nvidia显卡进行编码

//因为暂不支持，所以可以修改
#define POSTPROC_CPU        (1 << 8)    ///< CPU后处理（暂不支持）
#define POSTPROC_GPU        (1 << 9)    ///< GPU后处理（暂不支持）
#define POSTPROC_THIRD      (1 << 10)   ///< 第三方后处理（暂不支持）

/* 消息回调类型 */
#define FC_MSG_DEMUX        (1 << 0)    ///< 解析回调
#define FC_MSG_DECODE       (1 << 1)    ///< 解码回调
#define FC_MSG_ENCODE       (1 << 2)    ///< 编码回调
#define FC_MSG_POSTPROC     (1 << 3)    ///< 后处理回调
#define FC_MSG_SWITCH       (1 << 6)    ///< 切文件消息回调
#define FC_MSG_STREAM_END   (1 << 7)    ///< 流结束回调
#define FC_MSG_RUNINFO      (1 << 8)    ///< 运行信息回调(暂未实现)
#define FC_MSG_ERRORINFO    (1 << 9)    ///< 运行过程中错误信息回调

/* 数据类型 */
#define FC_OTHER_TYPE       0           ///< 其他类型
#define FC_VIDEO_TYPE       1           ///< 视频数据
#define FC_AUDIO_TYPE       2           ///< 音频数据
#define FC_PRIVT_TYPE       3           ///< 私有数据

/* 视频帧类型 */
#define FC_VIDEO_IFRAME          1           ///< I帧
#define FC_VIDEO_PFRAME          2           ///< P帧
#define FC_VIDEO_BFRAME          3           ///< B帧
#define FC_VIDEO_BPGROUP         4           ///< BP组
#define FC_VIDEO_BBPGROUP        5           ///< BBP组
#define FC_VIDEO_IFRAME_NOSUFFIX 6           ///< I无前缀
#define FC_VIDEO_PFRAME_NOSUFFIX 7           ///< P无前缀
#define FC_VIDEO_BFRAME_NOSUFFIX 8           ///< B无前缀

/* 文件切换方式 */
#define  FC_SWITCH_BY_SIZE  1           ///< 根据文件大小切换
#define  FC_SWITCH_BY_TIME  2           ///< 根据文件时长切换

/* 回调错误信息的返回码 */
#define FC_ERRORCB_NOTSETKEY 1          ///< 加密码流没有设置秘钥
#define FC_ERRORCB_FILEWRITEERROR 2     ///< 写文件错误
#define FC_ERRORCB_MFIFRAME 3           ///< 解析的到合成流，暂不支持

/* 日志输出等级 */
#define FCLOG_LEVEL_OFF              7  ///< 关闭日志
#define FCLOG_LEVEL_FATAL            6  ///< 严重错误
#define FCLOG_LEVEL_ERROR            5  ///< 错误信息
#define FCLOG_LEVEL_WARN             4  ///< 警告
#define FCLOG_LEVEL_INFO             3  ///< 运行信息
#define FCLOG_LEVEL_DEBUG            2  ///< 调试信息
#define FCLOG_LEVEL_TRACE            1  ///< 跟踪信息
#define FCLOG_LEVEL_ALL              0  ///< 全部输出

/* 定义日志回调函数 */
typedef void  (*fTLogCallBack)(unsigned int nLevel, char* pLogInfo, unsigned int nLogLen);


/* 消息回调信息结构体 */
typedef struct FC_MSGCB_INFO_STRU
{
    unsigned int    nTrack;             ///< 轨道号
    unsigned int    nMsgType;           ///< 消息类型
    unsigned char*  pMsgData;           ///< 消息数据
    unsigned int    nMsgDataLen;        ///< 数据长度
    unsigned int    nDataType;          ///< 数据类型

    /* 以下参数根据消息类型，选择性输出 */
    unsigned int    nFrameNum;          ///< 相对帧号
    unsigned int    nFrameTime;         ///< 单位时间，单位毫秒
    unsigned int    nTimePerFrame;      ///< 每帧持续时间，单位毫秒
    unsigned int    nWidthOrChannels;   ///< 视频宽或音频声道数
    unsigned int    nHeightOrSmpRate;   ///< 视频高或音频采样率
    unsigned int    nFrameRateOrBitRate;///< 视频帧率或音频比特率
    unsigned int    nFrameTypeOrBPS;    ///< 视频帧类型或音频样位率
    unsigned int    nReserved[2];       ///< 保留字段 reserve0用来作为错误信息的返回码
} FC_MSGCB_INFO;

/* 转码库详细回调信息*/
typedef struct FC_DETAILED_CB_INFO_STRU
{
    unsigned int    nTrackIndex;              ///< 轨道号，暂时没用起来，默认值应该都为0

    unsigned int    nFrameTypeOrBPS;          ///< 回调帧类型音频代表样位率
    unsigned int    nWidthOrChannels;         ///< 视频宽或音频声道数
    unsigned int    nHeightOrSampleRate;      ///< 视频高或音频采样率

    float           fFrameRate;               ///< 帧率
    unsigned int    nAudioBitrate;            ///< 音频比特率


    unsigned int    nFrameNum;                ///< 帧号
    unsigned int    nTimeStamp;               ///< 时间戳
    FC_GLOBAL_TIME  stGlobalTime;             ///< 全局时间

    unsigned char*  pData;                    ///< 回调数据
    unsigned int    nDataLen;                 ///< 回调数据长度


    bool            bLastPacket;              ///< 是否位当前报的最后一包
    bool            bFirstPacket;             ///< 是否为当前帧第一包
    unsigned int    nDataType;                ///< 输出类型
    FC_FormatType   enSystemFormat;           ///< 封装类型可能输出裸数据或者无封装数据
    FC_CodecType    enCodecType;              ///< 编码类型

    unsigned int    nReserved[8];             ///< 保留位

}FC_DETAILED_CB_INFO;

/* 用于设置扩展信息的结构体 */
/* 增加新功能定义 */
/* 0表示默认，其他值设置范围，或者设置1生效*/
/*
1.nReserved[0] 转封装标志位，设置1后只转封装,设置2后只转码，默认根据源和目标信息自适应
2.nReserved[1] 使用绝对帧号，音频时戳不根据采样率递增
3.nReserved[2] 设置缓冲区大小,最小1M最大32M,单位字节
4.nReserved[3] 流模式缓冲区处理完毕后输入处理完毕的回调
5.nReserved[4] 转码策略位，根据此位决定转码策略,AVI+I420特殊格式不支持策略转码
5.nReserved[5] 转码拼接时间域值，超过此时间执行拼接操作
6.nReserved[6] 编码码率控制方法位
7.nReserved[7] 解码使用线程数，取值范围（0-8），多线程解码仅支持H264和H265,取0时代表自适应
8.nReserved[8] 解析模式，0：默认， 1：使用编码层段帧功能，转码异常时可尝试开启此功能，增加兼容性
10.nReserved[9] MP4文件具体格式 ：第0-3位（0：前置索引 1：后置索引）第4位：私有数据开关（0：MP4私有数据关闭 1：MP4私有数据开启）
11.nReserved[10] 数据输出模式，0：默认 1：每一帧最后一个包以FC_VIDEO_PACKET_LAST类型和FC_AUDIO_PACKET_LAST类型输出
12.nReserved[11] 是否强制支持私有数据打包——0：不支持，1：支持；（目标格式为MP4时，需同时设置nReserved[9]）
                 由于转码后视频编码参数和数据发生改变，部分私有帧（如水印帧）无法显示，部分私有帧（图片叠加、POS等）叠加位置会发生改变，转码库不负责进行修复
*/
typedef struct FC_EXTEND_INFO_STRU
{
    unsigned int    nKeyFrameInterval;  ///< I帧间隔(帧数)
    unsigned int    nOutRtpSize;        ///< ASF格式为ASF包大小，有效范围为128-65536
                                        ///< RTP格式为RTP包大小，有效范围为512-8192
                                        ///< PS/TS格式为PES包大小，有效范围为1024-8192
                                        ///< MP4-前置格式为索引大小，有效范围为2048-16*1024*1024
                                        ///< 不再对参数范围进行额外检查，使用时请遵照合理范围进行设置
                                        ///< 其他格式不要设置，否则可能结果异常！
    unsigned int    nReserved[16]; 
}FC_EXTEND_INFO;


/* 用于设置帧信息的结构体 */
typedef struct FC_RAW_INFO_STRU
{
    unsigned int nWidthOrChannels;
    unsigned int nHeightOrSampleRate;
    unsigned int nReserved[16];
}FC_RAW_INFO;

/* 日志文件信息 */
typedef struct FC_LOG_CONFIG_STRU
{
    bool            bWriteLog;           ///< 是否写日志
    bool            bOutPutConsole;      ///< 输出到控制台
    unsigned int    nLogFileSize;        ///< 日志文件大小
    bool            bAppend;             ///< 累加输出，对文件有用
    unsigned int    nOutLogLevel;        ///< 输出日志等级
    fTLogCallBack   pfnLogCallBack;      ///< 日志回调函数，如果有则回调日志信息

    bool            bSaveInput;          ///< 保存输入流
    bool            bSaveDemux;          ///< 保存解析后数据
    bool            bSaveDecodeVideo;    ///< 保存解码后视频数据
    bool            bSaveDecodeAudio;    ///< 保存解码后音频数据
    bool            bSaveOutPut;         ///< 保存输出码流数据
    bool            bSaveInMux;          ///< 保存送入打包前的数据
}FC_LOG_CONFIG;

// H265 CBR码率控制参数
typedef struct _FC_H265_RC_CBR_CFG_
{
    int nBitRate;                           ///< 用户配置目标平均码率
}FC_H265_RC_CBR_CFG;

// H265 VBR码率控制参数
typedef struct _FC_H265_RC_VBR_CFG_
{
    int nMaxBitRate;                       ///< 用户配置最大码率
    int nChangePos;                        ///< 开始调整QP时码率相对最大码率的比例。取值范围[50, 100].默认值：90。
} FC_H265_RC_VBR_CFG;

//FIX_QP参数
typedef struct _FC_H265_RC_FIXQP_CFG
{
    unsigned int nQp;                      ///< 设置每一帧QP
} FC_H265_RC_FIXQP_CFG;

typedef struct _FC_H265_ENC_PARAM_
{
    unsigned int                       nThreadsNum;     // 编码器线程数
    unsigned int                       bIBCEnabled;	   // SCC编码IBC开关
    int                                nTemporalLayers; // SVC-T时域层数
    int                                nLtrPeriod;      // LTR周期
    struct
    {
        unsigned int                   nRateControlMode;  // 码控方式
        unsigned int                   nFpsNum;           // 帧率的分子
        unsigned int                   nFpsDenom;         // 帧率的分母,一般为1
        unsigned int                   nStatTime;         // 码控统计时间（滑动窗口大小）,[1,60]，单位（S）
        unsigned int                   nInitQp;           // 第一帧的起始QP值，取值范围[-1, 51]，-1:编码器自适应计算
        unsigned int                   nIpQpDelta;        // I帧和P帧QP差值,[-51,51]
        unsigned int                   nPicQpdeltaMin;    // 相同类型帧之间QP差值范围最小值[-1,-10]
        unsigned int                   nPicQpDeltaMax;    // 相同类型帧之间QP差值范围最大值[1,10]
        unsigned int                   nFrameSizeMax;     // 编码一帧最大字节数,QOS使用,默认-1表示关闭此功能
        union
        {
            FC_H265_RC_CBR_CFG         stH265CBRCFG; // CBR码率控制参数
            FC_H265_RC_VBR_CFG         stH265VBRCFG; // VBR码率控制参数
            FC_H265_RC_FIXQP_CFG       stFixQPCFG;   // CQP码率控制参数
        };
    } rc;

    unsigned int                       nEncAbility;         // 编码能力集,用于判断参数是否合理
}FC_H265_ENC_PARAM;

typedef struct _FC_OPENH264_ENC_PARAM_
{
    //OPENH264特有属性
    bool              bEnableAaptiveQuant;         ///< AQ暂时只支持OPENH264
    bool              bEnableSceneChangeDetect;    ///< 场景切换检测，OPENH264用
    bool              bEnableBackgroundDetection;  ///< 背景检测，OPENH264用
    unsigned int      nEncodeUsage;                ///< 编码用途(0:camera video, 1:screen content)

    int               nThreadNum;           ///< 编码器线程数
    int               nSrcImgSliceNum;      ///< 一帧图像的slice的数目[1,4]

    struct
    {
        int           nBitRate;              ///< 比特率(单位：kbps)(范围128k-16M)（被转码库目标参数覆盖）
        int           nQualityMax;           ///< CBR,VBR对应的最大图像质量
        int           nQualityMin;           ///< CBR,VBR对应的最小图像质量
    }rc;
}FC_OPENH264_ENC_PARAM;


typedef struct _FC_H264_ENC_PARAM_
{
    struct
    {
        int           nBitRate;          // 编码器线程数
        unsigned int  nRateControlMode;  // 码率控制算法
    }rc;

}FC_H264_ENC_PARAM;

typedef struct _FC_HWENC_PARAM_
{
    unsigned int nEncEngine;
    int          nBitRate;
}FC_HWENC_PARAM;

/* 编码初始化参数，内部接口，无需使用reserved位 */
/* 参数非全部有效，不同编码器支持的能力集不同  */
typedef struct FC_VENC_INIT_PARAM_STRU
{
    //通用编码参数
    unsigned int      nPicWidth;            ///< 输入图片宽度(暂不支持)
    unsigned int      nPicHeight;           ///< 输入图片高度(暂不支持)
    unsigned int      nGopSize;             ///< GOP长度,两I帧间间隔(参数为0时，其他引擎无效，OPENH264会编出无限GOP码流)
    float             fFrameRate;           ///< 帧率        （被转码库目标参数覆盖）

    union
    {
       FC_OPENH264_ENC_PARAM    stOpenH264Param;
       FC_H265_ENC_PARAM        stH265EncParam;
       FC_HWENC_PARAM           stHWEncEnParam;
       FC_H264_ENC_PARAM        stH264EncParam;
    }unEncSpecific;

    FC_CodecType      enCodecType;         ///< 编码类型（无需赋值）
    unsigned int      nYUVFormat;          ///< YUV数据类型（无需赋值）

}FC_VENC_INIT_PARAM;

/* 重设参数能力集  */
/* 针对不同实现方式，能力集不同  */
typedef struct FC_VENC_RESET_PARAM_STRU
{
    unsigned int     nPicWidth;       ///< 输入图片宽度（暂不支持）
    unsigned int     nPicHeight;      ///< 输入图片高度（暂不支持）
    unsigned int     nGopSize;        ///< GOP长度取值范围 nGopSize 大于 0,不可以为0

    unsigned int     nRCMode;         ///< 码率控制方法（暂不支持）
    unsigned int     nBitRate;        ///< 码率

    unsigned int     nReserved[16];   ///< 保留位
}FC_VENC_RESET_PARAM;

/* YUV数据 */
typedef struct FC_YUV_DATA_STRU
{
    FC_CodecType     nDataType;       ///< YUV类型(只支持FC_CODEC_V_YV12)
    unsigned char*   pDataBuffer;     ///< 数据缓冲
    unsigned int     nDataLen;        ///< 数据长度
    unsigned int     nWidth;          ///< 宽
    unsigned int     nHeight;         ///< 高
} FC_YUV_DATA;

/* 子图信息 */
typedef struct FC_SUBGRAPH_INFO_STRU
{
    float            fStartPosXRatio;  ///< 初始位置X比例（0-1之间）
    float            fStartPosYRatio;  ///< 初始位置Y比例（0-1之间）
    float            fWdithRatio;      ///< 宽度比例（0-1之间）
    float            fHeightRatio;     ///< 高度比例（0-1之间）
}FC_SUBGRAPH_INFO;


/* 硬解码异步回调函数，转码库内部处理硬解回调上来的数据 */
typedef void  (*fTMobileHWDecode)(unsigned int nCBType, unsigned int nErrorCode, unsigned char* pData, unsigned int nDataLen, unsigned int nTimeStamp, void* pFCUser);

/* 外部硬解码初始化参数 */
typedef struct FC_MOBILE_TRANS_PARAM_INIT_STRU
{
	unsigned int nSrcCodecType;                 ///< 源编码
	unsigned int nSrcWidth;                     ///< 源码流宽
	unsigned int nSrcHeight;                    ///< 源码流高

	unsigned int nDestCodecType;                ///< 目标编码类型
	unsigned int nDestWidth;                    ///< 目标宽
	unsigned int nDestHeight;                   ///< 目标高
	unsigned int nDestGopLen;                   ///< 目标GOP长度
	unsigned int nDestBitRate;                  ///< 目标码率
	float        fFrameRate;                    ///< 目标帧率
	void*        pFCUser;                       ///< 转码库指针，回调用

	fTMobileHWDecode pHWDecodeCB;               ///< 处理硬转码数据的函数指针
	unsigned char    nReserved[64];             ///< 保留位
}FC_MOBILE_TRANS_PARAM_INIT;

/* 外部硬转码初始化 */
typedef void* (*fTInitTransCode)(FC_MOBILE_TRANS_PARAM_INIT* pInitParam, void* pUser);

/* 外部硬转码转码一帧 */
typedef int (*fTranscodeOneFrame)(void* handle, unsigned char* pInputData, unsigned int nInputDataLen, unsigned int nTimeStamp, unsigned int nFrameType, void* pUser);

/* 外部硬解码结束初始化 */
typedef int (*fTDeInitTransCode)(void* handle);


#ifdef __cplusplus
extern "C" {
#endif

/** @fn     FC_RegisterMsgCallBack(const FCHANDLE  hFC, 
                                   int             nMsgType, 
                                   void(__stdcall* MsgCB)(FC_MSGCB_INFO* pMsgCbInfo, 
                                                                   void*          pUser), 
                                   void*           pUser)
 *  @brief  注册消息回调
 *  @param  hFC         [I]             - 库句柄
 *          nMsgType    [I]             - 消息类型
 *          MsgCB       [I]             - 回调函数
 *          pUser       [I]             - 用户指针
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [可选调用]
 */
FC_API int __stdcall FC_RegisterMsgCallBack(const FCHANDLE  hFC, 
                                            int             nMsgType, 
                                            void(__stdcall* MsgCB)(FC_MSGCB_INFO* pMsgCbInfo, 
                                                                   void*          pUser), 
                                            void*           pUser);


/** @fn     FC_SetCap(const FCHANDLE hFC, int nCapType, int nCapValue)
 *  @brief  设置转码能力
 *  @param  hFC         [I]             - 库句柄
 *          nCapType    [I]             - 能力类型
 *          nCapValue   [I]             - 能力值
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [可选调用] 在设置目标参数成功后才
 */
FC_API int __stdcall FC_SetCap(const FCHANDLE hFC, int nCapType, int nCapValue);


/** @fn     FC_SetFileSwitch(const FCHANDLE hFC, unsigned int nType, unsigned int nValue)
 *  @brief  设置自动切换文件
 *  @param  hFC         [I]             - 库句柄
            nType       [I]             - 切换方式
            nValue      [I]             - 切换阈值（按文件时长切换时以秒为单位，按文件大小切换时以MB为单位）
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [可选调用] 只允许设置一种，内部默认阈值为7200秒或2048MB
 */
FC_API int __stdcall FC_SetFileSwitch(const FCHANDLE hFC, unsigned int nType, unsigned int nValue);


/** @fn     FC_SetGlobalTime(const FCHANDLE hFC, const FC_GLOBAL_TIME* pstBaseGlobalTime, unsigned int nForceFlag)
 *  @brief  设置全局时间
 *  @param  hFC                 [I]     - 库句柄
 *          pstBaseGlobalTime   [I]     - 全局时间起始值
 *          nForceFlag          [I]     - 强制标记（1：忽略源码流全局时间强制重置，0：若源码流有全局时间则仍使用源码流全局时间）
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [可选调用]
 */
FC_API int __stdcall FC_SetGlobalTime(const FCHANDLE hFC, const FC_GLOBAL_TIME* pstBaseGlobalTime, unsigned int nForceFlag);


/** @fn     FC_ReSetTimeStamp(const FCHANDLE hFC)
 *  @brief  重置时间戳
 *  @param  hFC         [I]             - 库句柄
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [可选调用] 如果不设置，则时间戳以源数据为准
 */
FC_API int __stdcall FC_ReSetTimeStamp(const FCHANDLE hFC);


/** @fn     FC_SetDecodeERC(const FCHANDLE hFC, unsigned int nLevel)
 *  @brief  设置差错隐藏级别
 *  @param  hFC                 [I]             - 库句柄
 *          nHSections          [I]             - 差错隐藏级别

 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [可选调用]
 */
FC_API int __stdcall FC_SetDecodeERC(const FCHANDLE hFC, unsigned int nLevel);


/** @fn     FC_SetExtendInfo(const FCHANDLE hFC, FC_EXTEND_INFO* pExtInfo)
 *  @brief  设置扩展信息
 *  @param  hFC                 [I]             - 库句柄
 *          pExtInfo            [I]             - 扩展信息句柄

 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [可选调用]
 */
FC_API int __stdcall FC_SetExtendInfo(const FCHANDLE hFC, FC_EXTEND_INFO* pExtInfo);


/** @fn     FC_EncOneKeyFrame(const FCHANDLE hFC)
 *  @brief  设置扩展信息
 *  @param  hFC                 [I]             - 库句柄

 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [可选调用]
 */
FC_API int __stdcall FC_EncOneKeyFrame(const FCHANDLE hFC);


/** @fn     FC_InputSourceDataAndInfo(const FCHANDLE hFC, FC_DataType enType, FC_RAW_INFO* pSourceInfo, const unsigned char* pData, unsigned int nDataLen)
 *  @brief  输入数据
 *  @param  hFC             [I]             - 库句柄
 *          enType          [I]             - 流数据类型；
 *          pSourcInfo      [I]             - 送入帧的帧信息；
 *          pData           [I]             - 流数据指针；
 *          nDataLen        [I]             - 流数据长度；
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [流模式的可选调用]
 */
FC_API int __stdcall FC_InputSourceDataAndInfo(const FCHANDLE hFC, FC_DataType enType, FC_RAW_INFO* pSourceInfo, const unsigned char* pData, unsigned int nDataLen);


/** @fn     FC_ConfigLogInfo(FC_LOG_CONFIG* pConfigInfo)
 *  @brief  配置日志信息
 *  @param  FC_LOG_CONFIG   [I]             - 配置日志信息；
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [流模式的可选调用]
 */
FC_API int __stdcall FC_ConfigLogInfo(FC_LOG_CONFIG* pConfigInfo);


/** @fn     FC_RegisterHWImpCallBack(const FCHANDLE hFC, fTInitTransCode pInitTransCode, fTranscodeOneFrame pTranscodeOneFrame, fTDeInitTransCode pTDeInitTransCode, void* pUser);
 *  @brief  设置外部硬解码
 *  @param  hFC                    [I]             - 库句柄
 *          pTInitTransCode        [I]             - 初始化回调函数
 *          pTranscodeOneFrame     [I]             - 转换一帧函数
 *          pTDeInitTransCode      [I]             - 结束初始化函数
            pUser                  [I]             - 用户指针
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [可选调用]
 */
FC_API int __stdcall FC_RegisterHWImpCallBack(const FCHANDLE hFC, fTInitTransCode pInitTransCode, fTranscodeOneFrame pTranscodeOneFrame, fTDeInitTransCode pTDeInitTransCode, void* pUser);


/** @fn     FC_InputSourceDataEx(const FCHANDLE hFC, FC_DataType enType, const unsigned char* pData, unsigned int nDataLen)
 *  @brief  输入数据
 *  @param  hFC             [I]             - 库句柄
 *          enType          [I]             - 流数据类型；
 *          pData           [I]             - 流数据指针；
 *          nDataLen        [I]             - 流数据长度
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [流模式输入必须调用]
 */
FC_API int __stdcall FC_InputSourceDataEx(const FCHANDLE hFC, FC_DataType enType, const unsigned char* pData, unsigned int nDataLen);


/** @fn    FC_SetVideoEncParam(const FCHANDLE hFC, FC_VENC_INIT_PARAM* pVENCParam)
 *  @brief  设置编码器的特别信息（转码前调用）
 *  @param  hFC              [I]            - 库句柄
 *          pVENCParam       [I]            - 编码初始化参数
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [可选调用]
 */
FC_API int __stdcall FC_SetVideoEncParam(const FCHANDLE hFC, FC_VENC_INIT_PARAM* pVENCParam);


/** @fn    FC_ReSetVideoEncParam(const FCHANDLE hFC, FC_VENC_RESET_PARAM* pVENCParam)
 *  @brief  重设编码器参数信息(转码过程中调用)（仅适用于InputSourceDataEx）
 *          对硬转码无效，调用该接口会立即生成一个I帧。
 *  @param  hFC              [I]            - 库句柄
 *          pVENCParam       [I]            - 重设的编码参数
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [可选调用]
 */
FC_API int __stdcall FC_ReSetVideoEncParam(const FCHANDLE hFC, FC_VENC_RESET_PARAM* pVENCParam);


/** @fn    FC_SetPostProcInfoEx(const FCHANDLE hFC, int nPostProcType, void* pstPostProcData, unsigned int nPostProcDataLen)
*  @brief  设置后处理叠加信息，和InputSourceDataEx配合使用，支持参数重设
*          对硬转码无效
*  @param  hFC              [I]            - 库句柄
*          nKeyType         [I]            - 后处理类型，支持FC_POSTPROCTYPE_OVERLAY_TEXT和FC_POSTPROCTYPE_OVERLAY_RECT
*          pstPostProcData  [I]            - 后处理数据信息，对于nPostProcType为FC_POSTPROCTYPE_OVERLAY_TEXT，对应于FC_POS_INFO
                                                               对于nPostProcType为FC_POSTPROCTYPE_OVERLAY_RECT，对应于FC_OVERLAY_RECT_PARAM
*          nPostProcDataLen [I]            - 后处理信息长度，pstPostProcData的长度
*  @return 成功返回FC_OK，失败返回错误码
*
*  @note   [可选调用]
*/
FC_API int __stdcall FC_SetPostProcInfoEx(const FCHANDLE hFC, int nPostProcType, void* pstPostProcData, unsigned int nPostProcDataLen);


/** @fn     FC_API int __stdcall FC_GetSubGraphYUV(const FCHANDLE hFC, FC_YUV_DATA* pstSrcYUV, FC_SUBGRAPH_INFO* pSubGraphInfo, FC_YUV_DATA* pstSubYUV)
  * @brief  获取子图YUV
  * @param  hFC             [I]            - 解码句柄
  * @param  pstSrcYUV       [I]            - 输入原始YUV数据
  * @param  pSubGraphInfo   [I]            - 输入子图信息
  * @param  pstSubYUV       [O]            - 输出子图YUV数据
  * 
  * @return 成功返回FC_OK，失败返回错误码
  */
FC_API int __stdcall FC_GetSubGraphYUV(const FCHANDLE hFC, FC_YUV_DATA* pstSrcYUV, FC_SUBGRAPH_INFO* pSubGraphInfo, FC_YUV_DATA* pstSubYUV);

/** @fn     FC_API int __stdcall FC_SetThreadCoreBind(const FCHANDLE hFC, unsigned int nDecCoreNum, unsigned int nEncCoreNum)
  * @brief  Linux环境下，设置和CPU绑核操作，仅在单线程编码和解码时适用
  * @param  hFC             [I]            - 解码句柄
  * @param  nDecCoreID      [I]            - 解码线程绑定的核心号
  * @param  nEncCoreID      [I]            - 编码线程绑定的核心号
  * 
  * @return 成功返回FC_OK，失败返回错误码
  */
FC_API int __stdcall FC_SetThreadCoreBind(const FCHANDLE hFC, unsigned int nDecCoreID, unsigned int nEncCoreID);

/** @fn     FC_API int __stdcall FC_SetDetailedCB(const FCHANDLE hFC,
                                                  void* (__stdcall  pCB)(FC_DETAILED_CB_INFO* pDataInfo,
                                                                         HK_VOID* pUser),
                                                  void*  pUser);
  * @brief  设置详细回调函数，可以回调出转码库处理的详细信息
  * @param  hFC             [I]            - 解码句柄
  * @param  pCB             [I]            - 解码回调函数
  * @param  pUser           [I]            - 用户私有指针
  * 
  * @return 成功返回FC_OK，失败返回错误码
  */
FC_API int __stdcall FC_RegisterDetailedCB(const FCHANDLE hFC, 
                                           void (__stdcall  *pCB)(FC_DETAILED_CB_INFO* pDataInfo, 
                                                                  void* pUser),
                                           void*  pUser);


/** @fn     FC_GetFileInfo_V2(const FCHANDLE hFC, const char* szFilePath, FC_MEDIA_INFO* pstSourceInfo)
*  @brief   探测文件信息
*  @param   hFC             [I]             - 库句柄
            szFilePath      [I]             - 文件路径
            pstInspectInfo  [I|O]           - 探测得到的文件信息
            enMode          [I]             - 分析模式(萤石版本默认)
*  @return 成功，返回FC_OK；失败，返回错误码
*
*  @note   可获取PS、TS、HIK、MP4、AVI格式的总时长和总帧数
*  @note   支持获取裸数据的分辨率信息
*/
FC_API int __stdcall FC_GetFileInfo_V2(const FCHANDLE hFC, const char* szFilePath, FC_INSPCT_INFO* pstInspectInfo, FC_INSPECT_MODE enMode);




/*******************************

以下为单独调用接口，无需创建转码库句柄

********************************/



/* 叠加信息 */
typedef struct FC_COMPOSE_INFO_
{
    // 源图片区域（源图片中需要叠加到底图的区域范围）
    float            fSrcX;             ///< 初始位置X比例（0-1之间）
    float            fSrcY;             ///< 初始位置Y比例（0-1之间）
    float            fSrcWdith;         ///< 宽度比例（0-1之间）
    float            fSrcHeight;        ///< 高度比例（0-1之间）

    // 底图叠加区域(底图中叠加图片的区域范围)
    float            fBaseX;             ///< 初始位置X比例（0-1之间）
    float            fBaseY;             ///< 初始位置Y比例（0-1之间）
    float            fBaseWdith;         ///< 宽度比例（0-1之间）
    float            fBaseHeight;        ///< 高度比例（0-1之间）

}FC_COMPOSE_INFO;



/** @fn     FC_API int __stdcall   FC_PicCompose(FC_YUV_DATA* pstCompYUV, FC_COMPOSE_INFO* pComposeInfo, FC_YUV_DATA* pstBaseYUV)
  * @brief  在YUV底图上叠加YUV图片
  * @param  pstCompYUV           [I]            - 叠加源图片信息
  * @param  pComposeInfo         [I]            - 叠加区域信息
  * @param  pstBaseYUV           [I]            - 底图信息
  * 
  * @return 成功返回FC_OK，失败返回错误码
  */
FC_API int __stdcall   FC_PicCompose(FC_YUV_DATA* pstSrcYUV, FC_COMPOSE_INFO* pComposeInfo, FC_YUV_DATA* pstBaseYUV);


typedef enum _FC_ROTATE_ANGLE_
{
    FC_RL_ANGLE_90 = 1,     // 向左旋转90°
    FC_RR_ANGLE_90 = 2,     // 向右旋转90°
    FC_R_ANGLE_180 = 3,     // 旋转180°
}FC_ROTATE_ANGLE;


typedef struct _FC_YUV_ROTATE_IN
{
    FC_CodecType     nDataType;       ///< YUV类型(只支持FC_CODEC_V_YV12)
    unsigned char*   pDataBuffer;     ///< 数据缓冲
    unsigned int     nDataLen;        ///< 数据长度
    unsigned int     nWidth;          ///< 宽
    unsigned int     nHeight;         ///< 高
    FC_ROTATE_ANGLE  enAngle;         ///< 旋转角度
}FC_YUV_ROTATE_IN;


typedef struct _FC_YUV_ROTATE_OUT
{
    unsigned char*   pDataBuffer;     ///< 数据缓冲
    unsigned int     nBufferSize;     ///< 缓冲大小
    unsigned int     nDataLen;        ///< 输出数据长度
    unsigned int     nWidth;          ///< 宽
    unsigned int     nHeight;         ///< 高
}FC_YUV_ROTATE_OUT;


/** @fn     FC_PicRotate(FC_YUV_ROTATE_IN* pstInYUV, FC_YUV_ROTATE_OUT* pstOutYUV)
  * @brief  YUV图片旋转
  * @param  pstInYUV          [I]            - 源图片
  * @param  pstOutYUV         [IO]           - 输出图片（输出缓存需外部申请）
  * 
  * @return 成功返回FC_OK，失败返回错误码
  */
FC_API int __stdcall  FC_PicRotate(FC_YUV_ROTATE_IN* pstInYUV, FC_YUV_ROTATE_OUT* pstOutYUV);


#ifdef __cplusplus
}
#endif

#endif //_FC_INTERFACE_EX_H_
