//
// Created by lihaitao10 on 2020/2/12.
//

#ifndef EZPLAYERANDROID_EZTRANSSDK_H
#define EZPLAYERANDROID_EZTRANSSDK_H

#include "EZStreamTypes.h"

typedef struct
{
    void* hObj;
    int type; //1-Android 2-iOS
}HardTransCodeHandleInfo;

//外部硬转码完成后输出
typedef void  (*fnReEncodedFrame)(unsigned int nCBType, unsigned int nErrorCode, unsigned char* pData, unsigned int nDataLen, unsigned int nTimeStamp, void* pFCUser);

typedef struct EZ_FC_MOBILE_TRANS_PARAM_INIT_STRU
{
    unsigned int nSrcCodecType;                 ///< ‘¥±‡¬Î
    unsigned int nSrcWidth;                     ///< ‘¥¬Î¡˜øÌ
    unsigned int nSrcHeight;                    ///< ‘¥¬Î¡˜∏ﬂ

    unsigned int nDestCodecType;                ///< ƒø±Í±‡¬Î¿‡–Õ
    unsigned int nDestWidth;                    ///< ƒø±ÍøÌ
    unsigned int nDestHeight;                   ///< ƒø±Í∏ﬂ
    unsigned int nDestGopLen;                   ///< ƒø±ÍGOP≥§∂»
    unsigned int nDestBitRate;                  ///< ƒø±Í¬Î¬
    float        fFrameRate;                    ///< ƒø±Í÷°¬
    void*        pFCUser;                       ///< ◊™¬Îø‚÷∏’Î£¨ªÿµ˜”√

    fnReEncodedFrame pHWDecodeCB;               ///< ¥¶¿Ì”≤◊™¬Î ˝æ›µƒ∫Ø ˝÷∏’Î
    unsigned char    nReserved[64];             ///< ±£¡ÙŒª
}EZ_FC_MOBILE_TRANS_PARAM_INIT;


/* 视频信息结构体 */
typedef struct EZ_FC_VIDEO_INFO_STRU
{
//    FC_CodecType        enCodec;        ///< 视频编码
    unsigned int        nTrackId;       ///< 轨道号（对于PS封装，输出stream_id）
    unsigned int        nBitRate;       ///< 码率（单位Kbps）
    float               fFrameRate;     ///< 帧率
    unsigned short      nWidth;         ///< 图像宽度
    unsigned short      nHeight;        ///< 图像高度
    unsigned char       cDevChanID[16]; ///< 设备和通道信息
} EZ_FC_VIDEO_INFO;


/* 媒体信息结构体 */
typedef struct EZ_FC_MEDIA_INFO_STRU
{
    unsigned int        nVideoStreamCount;                  ///< 视频流数量
    unsigned int        nPrivtStreamCount;                  ///< 私有流数量
    EZ_FC_VIDEO_INFO       stVideoInfo[8];    ///< 视频信息
} EZ_FC_MEDIA_INFO;


///* 用于设置扩展信息的结构体 */
///* 增加新功能定义 */
///* 0表示默认，其他值设置范围，或者设置1生效*/
///*
//1.nReserved[0] 转封装标志位，设置1后只转封装,设置2后只转码，默认根据源和目标信息自适应
//2.nReserved[1] 使用绝对帧号，音频时戳不根据采样率递增
//3.nReserved[2] 设置缓冲区大小,最小1M最大32M,单位字节
//4.nReserved[3] 流模式缓冲区处理完毕后输入处理完毕的回调
//5.nReserved[4] 转码策略位，根据此位决定转码策略,AVI+I420特殊格式不支持策略转码
//5.nReserved[5] 转码拼接时间域值，超过此时间执行拼接操作
//6.nReserved[6] 编码码率控制方法位
//7.nReserved[7] 解码使用线程数，取值范围（0-8），多线程解码仅支持H264和H265,取0时代表自适应
//8.nReserved[8] 解析模式，0：默认， 1：使用编码层段帧功能，转码异常时可尝试开启此功能，增加兼容性
//10.nReserved[9] MP4文件具体格式 ：第0-3位（0：前置索引 1：后置索引）第4位：私有数据开关（0：MP4私有数据关闭 1：MP4私有数据开启）
//11.nReserved[10] 数据输出模式，0：默认 1：每一帧最后一个包以FC_VIDEO_PACKET_LAST类型和FC_AUDIO_PACKET_LAST类型输出
//12.nReserved[11] 是否强制支持私有数据打包——0：不支持，1：支持；（目标格式为MP4时，需同时设置nReserved[9]）
//                 由于转码后视频编码参数和数据发生改变，部分私有帧（如水印帧）无法显示，部分私有帧（图片叠加、POS等）叠加位置会发生改变，转码库不负责进行修复
//*/
//typedef struct EZ_FC_EXTEND_INFO_STRU
//{
//    unsigned int    nKeyFrameInterval;  ///< I帧间隔(帧数)
//    unsigned int    nOutRtpSize;        ///< ASF格式为ASF包大小，有效范围为128-65536
//                                        ///< RTP格式为RTP包大小，有效范围为512-8192
//                                        ///< PS/TS格式为PES包大小，有效范围为1024-8192
//                                        ///< MP4-前置格式为索引大小，有效范围为2048-16*1024*1024
//                                        ///< 不再对参数范围进行额外检查，使用时请遵照合理范围进行设置
//                                        ///< 其他格式不要设置，否则可能结果异常！
//    unsigned int    nReserved[16];
//} EZ_FC_EXTEND_INFO;


//外部硬转码初始化
typedef void (*fnOnInitTransCode)(EZ_FC_MOBILE_TRANS_PARAM_INIT* pInitParam, void* pUser, HardTransCodeHandleInfo& handleInfo);

//外部硬转码转码一帧
typedef int (*fnTranscodeOneFrame)(HardTransCodeHandleInfo* handle, unsigned char* pInputData, unsigned int nInputDataLen, unsigned int nTimeStamp, unsigned int nFrameType, void* pUser);

//外部硬解码结束初始化
typedef int (*fnDeInitTransCode)(HardTransCodeHandleInfo* handle);


int32_t eztrans_setHardwareCallback(void *trans, fnOnInitTransCode initCB, fnTranscodeOneFrame transFrameCB,
                                    fnDeInitTransCode deInitCB, void *userData);

//转封装相关接口

int eztrans_create(unsigned char *header, unsigned int headerLength,
#ifdef __APPLE__
        double systemVersion,
#endif
                   const char* szSourcePath,
                   EZ_TRANSFORM_TYPE type, void **handleOut, void (* outPutDataProcess)(unsigned int   nDataType,
                                                                                        unsigned char* pData,
                                                                                        unsigned int   nDataLen,
                                                                                        unsigned int   nFlag,
                                                                                        void*          pUser) = nullptr, void *pUser = nullptr);
int eztrans_destroy(void *handle);

int eztrans_setKey(void *handle, std::string key);

int eztrans_start(void *handle, const char* sourceFile, const char* targetPath);

int eztrans_input(void *handle, int dataType, unsigned char* data, unsigned int len);

int eztrans_getPercent(void *handle, int *percentage);

int eztrans_stop(void *handle);


/// 新的创建转码和转封装接口，用于文件PS转PS或者MP4，用于【单个PS文件包含多路视频流】的场景，也可以用于【单个PS文件包含单路视频流】
/// 该接口可以用于 双路PS解密为双路PS，以及双路PS解密加转码为单路MP4，不支持双目PS转为双路MP4
/// 接口调用顺序是 eztrans_create_ex --> eztrans_setKey(可选） -->  eztrans_get_src_file_info  --> eztrans_set_target_file_info --> eztrans_set_segment_interval (可选） --> eztrans_start_ex   -->  eztrans_getPercent -->  eztrans_stop --> eztrans_destroy
/// @param srcFilePath 源文件路径
/// @param systemVersion iOS 系统版本号 [UIDevice currentDevice].systemVersion.doubleValue 获取
/// @param type PS 还是MP4
/// @param handleOut 创建的handle
int eztrans_create_ex(const char* srcFilePath,
#ifdef __APPLE__
                      double systemVersion,
#endif
                      EZ_TRANSFORM_TYPE type,
                      void **handleOut);


/// 获取源文件的格式信息，必须是eztrans_create_ex 创建的handle，才可以单独设置
/// 获取源文件的格式信息，主要是包含几个视频轨道，以及每个轨道的trackID（当前支持最多单PS文件包含2路视频的获取）
/// 如果文件是加密的，调用该接口前，必须调用eztrans_setKey
/// @param handle_ex handle_ex
/// @param src_media_info 输出参数，文件的格式信息
/// @param enable_traversal 是否遍历文件检查存在轨道变化的情况，对于常规的单目流等设置，设置为false，对于可能存在变化的多轨码流设置为true。
int eztrans_get_src_file_info(void *handle_ex, EZ_FC_MEDIA_INFO *src_media_info, bool enable_traversal=false);


/// 设置转换的目标格式，必须是eztrans_create_ex 创建的handle，才可以单独设置
/// 该接口可以用于 双路PS解密为双路PS，以及双路PS解密加转码为单路MP4，
/// 通过eztrans_get_src_file_info接口可以拿到原始PS的信息，是单路流还是双路流，以及视频流的trackID
/// 比如 单路PS解密加转码为单路MP4，nVideoStreamCount=1，stVideoInfo[0].nTrackId=eztrans_get_src_file_info获取的trackid
/// 双路PS解密为双路PS，nVideoStreamCount=2，stVideoInfo[0]和stVideoInfo[1] 设置为相应的eztrans_get_src_file_info获取的视频信息
/// @param handle_ex handle_ex
/// @param target_media_info 目标格式
int eztrans_set_target_file_info(void *handle_ex, const EZ_FC_MEDIA_INFO *target_media_info, const char* targetPath);


/// 设置转码库内部识别不同片段的帧间隔时长，单位毫秒，默认1000。必须在eztrans_start_ex前调用
/// @param handle_ex 必须是eztrans_create_ex 创建的handle
/// @param interval 识别跨片段的最小帧间隔
int eztrans_set_segment_interval(void *handle_ex, int interval);


/// 开始转码/转封装，必须是eztrans_create_ex 创建的handle
/// 调用该接口前，必须先调用 eztrans_get_src_file_info  + eztrans_set_target_file_info
/// @param handle_ex handle
int eztrans_start_ex(void *handle_ex);


#endif //EZPLAYERANDROID_EZTRANSSDK_H
