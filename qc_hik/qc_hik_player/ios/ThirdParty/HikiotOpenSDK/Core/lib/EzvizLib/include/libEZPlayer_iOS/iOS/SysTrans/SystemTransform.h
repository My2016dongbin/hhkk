/* @file       SystemTransform.h
 * @note       HANGZHOU Hikvison Software Co.,Ltd.All Right Reserved.
 * @brief      转封装库头文件
 * 
 * @version    V2.5.0
 * @author     heyuanqing
 * @date       2014/12/05
 * @note       增加详细信息输出回调
 * 
 * @version    V2.5.4
 * @author     zhanglong6
 * @date       2019/05/06
 * @note       增加封装格式类型
 *             增加加解密类型
 *             修改和完善注释描述
 *
 * @version    V2.5.5
 * @author     zouhan
 * @date       2020/10/27
 * @note       修改相关bug
 *             修改和完善注释描述
 *
 * @version    V3.1.1
 * @author     zouhan
 * @date       2021/05/31
 * @note       增加详细信息输出回调
 * 
 * @version    V3.2.1.4
 * @author     liyujie19
 * @date       2023/08/28
 * @note       支持mp4流式探测和解析、
 *             新增通用配置接口、ffmpeg能力
 *             支持新加密方案、
 *             回调增加私有帧参数、文件模式增加错误码回调等功能
 *
 */

#ifndef _SYSTEM_TRANSFORM_H_
#define _SYSTEM_TRANSFORM_H_

#ifdef WIN32
    #if defined(_WINDLL)
        #define SYSTRANS_API  __declspec(dllexport) 
    #else 
        #define SYSTRANS_API  __declspec(dllimport) 
    #endif
#else
    #ifndef __stdcall
        #define __stdcall
    #endif

    #ifndef SYSTRANS_API
        #define  SYSTRANS_API  __attribute__((visibility("default")))
    #endif
#endif

#define MAX_CFG_ITEM_NUM               (8)                  // 配置结构体数组个数上限
#define SWITCH_BY_FILESIZE             (1)                  // 通过文件大小切换（暂不支持）
#define SWITCH_BY_TIME                 (2)                  // 通过时间切换
#define SUBNAME_BY_INDEX               (1)                  // 文件名通过编号区分（暂不支持）
#define SUBNAME_BY_GLOBALTIME          (2)                  // 文件名通过全局时间区分
#define MAX_CFG_ITEM_NUM               (8)                  // 配置结构体数组个数上限
#define INSPECT_MAX_TRACK              (8)                  // 最大支持8路探测
#define ST_MIN_BUFFER_SIZE             (512 * 1024)         // 最小缓存（转封装缓存和探测缓存）大小，适用于对性能要求高、输入包大小不超过512K的小码流场景，常规场景不推荐设置该值，建议使用默认值（2M）
#define ST_MAX_BUFFER_SIZE             (8 * 1024 * 1024)    // 最大缓存（转封装缓存和探测缓存）大小
#define ST_DEFAULT_BUFFER_SIZE         (2 * 1024 * 1024)    // 默认缓存（转封装缓存和探测缓存）大小，不配置时默认采用该值

/************************************************************************
 * 状态码定义
 ************************************************************************/
#define SYSTRANS_OK                    0x00000000
#define SYSTRANS_E_HANDLE              0x80000000      // 转换句柄错误
#define SYSTRANS_E_SUPPORT             0x80000001      // 类型不支持
#define SYSTRANS_E_RESOURCE            0x80000002      // 资源申请或释放错误
#define SYSTRANS_E_PARA                0x80000003      // 参数错误
#define SYSTRANS_E_PRECONDITION        0x80000004      // 前置条件未满足，调用顺序错误
#define SYSTRANS_E_OVERFLOW            0x80000005      // 缓存溢出
#define SYSTRANS_E_STOP                0x80000006      // 停止状态
#define SYSTRANS_E_FILE                0x80000007      // 文件操作或文件数据错误
#define SYSTRANS_E_MAX_HANDLE          0x80000008      // 最大路数限制
#define SYSTRANS_E_MUXER               0x80000010      // 底层库处理错误
#define SYSTRANS_E_FAIL                0x80000011      // 探测失败
#define SYSTRANS_E_ENCAP               0x80000012      // 探测流程不支持
#define SYSTRANS_E_PSM_LENTH           0x80000013      // PSM长度错误
#define SYSTRANS_E_DESCRIPTOR          0x80000014      // 私有描述子解析错误
#define SYSTRANS_E_DECRYPT             0x80000015      // 解密错误
#define SYSTRANS_E_NEED_MORE_DATA      0x80000016      // 需要更多数据
#define SYSTRANS_E_INSPECT_NOT_FIN     0x80000017      // 根据返回参数继续执行探测
#define SYSTRANS_E_ENCRYPT             0x80000018      // 加密错误
#define SYSTRANS_E_OTHER               0x800000FF      // 其他错误


/************************************************************************
 * 输出数据类型定义
 ************************************************************************/
#define TRANS_SYSHEAD                  (1)             // 系统头数据
#define TRANS_STREAMDATA               (2)             // 视频流数据（包括复合流和音视频分开的视频流数据）
#define TRANS_AUDIOSTREAMDATA          (3)             // 音频流数据
#define TRANS_PRIVTSTREAMDATA          (4)             // 私有数据类型
#define TRANS_DECODEPARAM              (5)             // 视频解码参数类型
#define TRANS_AUDIODECPARAM            (6)             // 音频解码参数类型
#define TRANS_CUSTOM_VIDEO             (7)             // 自定义画面视频流
#define TRANS_CUSTOM_AUDIO             (8)             // 自定义画面音频流
#define TRANS_CUSTOM_VPARAM            (9)             // 自定义画面视频参数
#define TRANS_CUSTOM_APARAM            (10)            // 自定义画面音频参数
#define TRANS_ERRORFRAME               (11)            // 错误帧数据类型
#define TRANS_INDEXDATA                (12)            // 索引数据，暂MP4格式使用
#define TRANS_SEGINDEXDATA             (13)            // 分片索引数据，暂MP4格式使用
#define TRANS_TIME_DURATION            (14)            // 码流总时长

/************************************************************************
 * SYSTRANS_FileInspect探测音视频编码类型定义
 ************************************************************************/
#define ST_VIDEO_NULL                  0x0000          // 无编码视频
#define ST_VIDEO_HIK264                0x0001          // 海康编码视频
#define ST_VIDEO_MPEG2                 0x0002          // MPEG2编码视频
#define ST_VIDEO_MPEG4                 0x0003          // MPEG4编码视频 
#define ST_VIDEO_MJPEG                 0x0004          // MJPEG编码视频
#define ST_VIDEO_H265                  0x0005          // 标准H265
#define ST_VIDEO_SVAC                  0x0006          // 标准SVAC编码视频
#define ST_VIDEO_AVC264                0x0100          // 标准264编码视频
#define ST_VIDEO_SVC_RESEV             0x0110          // 预留字段：表示为H.264 中的SVC码流

#define ST_VIDEO_YUY2                  0x0301          // YUY2图片格式
#define ST_VIDEO_NV12                  0x0302          // NV12图片格式
#define ST_VIDEO_YV12                  0x0303          // YV12图片格式
#define ST_VIDEO_I420                  0x0802          // I420图片格式(暂不支持)

#define ST_AUDIO_NULL                  0x0000          // 无编码音频
#define ST_AUDIO_ADPCM                 0x1000          // ADPCM编码音频
#define ST_AUDIO_MPEG                  0x2000          // MPEG编码音频
#define ST_AUDIO_AMR                   0x3000          // AMR编码音频
#define ST_AUDIO_RAW_DATA8             0x7000          // RAW_UDATA8编码音频
#define ST_AUDIO_RAW_UDATA16           0x7001          // RAW_UDATA16编码音频
#define ST_AUDIO_G711_U                0x7110          // G711U编码音频
#define ST_AUDIO_G711_A                0x7111          // G711A编码音频
#define ST_AUDIO_G722_1                0x7221          // G722编码音频
#define ST_AUDIO_G726_U                0x7260          // G726编码音频(默认)
#define ST_AUDIO_G726_16               0x7262          // G726编码音频
#define ST_AUDIO_G726_A                0x7261          // G726编码音频
#define ST_AUDIO_AAC                   0x2001          // AAC编码音频
#define ST_AUDIO_AAC_LD                0x2002          // AAC_LD编码音频
#define ST_AUDIO_OPUS                  0x3002          // OPUS编码音频

/************************************************************************
* 枚举类型定义
************************************************************************/
/** @enum   SYSTEM_TYPE
 *  @brief  封装格式类型
 *  @note     
 */
typedef enum SYSTEM_TYPE
{
    TRANS_SYSTEM_NULL                  = 0x0,          // ES（用于设置输出目标封装格式，enTgtType）
    TRANS_SYSTEM_HIK                   = 0x1,          // HIK文件层，用于传输和存储
    TRANS_SYSTEM_MPEG2_PS              = 0x2,          // PS文件层，用于传输和存储
    TRANS_SYSTEM_MPEG2_TS              = 0x3,          // TS文件层，用于传输和存储
    TRANS_SYSTEM_RTP                   = 0x4,          // RTP文件层，用于传输
    TRANS_SYSTEM_RTP_JT                = 0x0104,       // 符合交通部1078协议的RTP码流，用于传输
    TRANS_SYSTEM_MPEG4                 = 0x5,          // MPEG4文件层（后置），用于存储
    TRANS_SYSTEM_ASF                   = 0x6,          // ASF文件层，用于存储
    TRANS_SYSTEM_AVI                   = 0x7,          // AVI文件层，用于存储
    TRANS_SYSTEM_GB_PS                 = 0x8,          // 国标PS文件层，用于国标协议的传输
    TRANS_SYSTEM_HLS_TS                = 0x9,          // 符合HLS协议的TS封装，用于HLS协议的传输
    TRANS_SYSTEM_FLV                   = 0x0A,         // FLV封装，用于传输和存储
    TRANS_SYSTEM_MPEG4_FRONT           = 0x0B,         // MPEG4文件层（前置），用于存储
    TRANS_SYSTEM_MPEG4_FRAG            = 0x0C,         // MPEG4文件层（碎片），用于传输
    TRANS_SYSTEM_RTMP                  = 0x0D,         // RTMP文件层，用于传输
    TRANS_SYSTEM_MPEG4_RESERVE         = 0x0E,         // MPEG4文件层（索引预写），用于存储
    TRANS_SYSTEM_WAV                   = 0x0F,         // WAVE文件层，用于存储
    TRANS_SYSTEM_RAW                   = 0x10,         // ES流前有参数信息的裸码流（用于裸帧打包时的码流头设置）
    TRANS_SYSTEM_RAW_SING_NALU         = 0x11,         // 按照NALU送入有参数信息裸数据。注意：外部一定要送入一个帧结束标志
	TRANS_SYSTEM_CFLV                  = 0x13,         // （暂不支持）cflv
    TRANS_SYSTEM_CFLV_RESERVE          = 0x14,         // （暂不支持）cflv（文件头预写），用于文件头刷新
    TRANS_SYSTEM_DHAV                  = 0x8001        // 大华封装
}SYSTEM_TYPE;

/** @enum   DATA_TYPE   
 *  @brief  输入数据类型
 *  @note   通常情况使用复合流数据类型；特殊情况下需要音视频裸帧分别打包，需要先配置打包参数
 */
typedef enum DATA_TYPE 
{
    MULTI_DATA                         = 0,            // 复合流数据
    VIDEO_DATA                         = 1,            // 视频流数据
    AUDIO_DATA                         = 2,            // 音频流数据
    PRIVATE_DATA                       = 3,            // 私有数据(不支持)
    VIDEO_PARA                         = 4,            // 视频裸帧打包参数，定义见HK_VIDEO_PACK_PARA
    AUDIO_PARA                         = 5,            // 音频裸帧打包参数，定义见HK_AUDIO_PACK_PARA
    PRIVATE_PARA                       = 6,            // 私有帧打包参数，定义见HK_PRIVATE_PACK_PARA   (不支持)
    VIDEO_PARA_EX                      = 7             // 视频流打包参数扩展，定义见HK_VIDEO_PACK_PARA_EX（包含原结构全部定义）
}DATA_TYPE;

/** @enum   ST_FRAME_TYPE
 *  @brief  帧类型
 *  @note
 */
typedef enum _ST_FRAME_TYPE_
{
    ST_VIDEO_BFRAME                    = 0,            // B帧（视频帧）
    ST_VIDEO_PFRAME                    = 1,            // P帧（视频帧）
    ST_VIDEO_EFRAME                    = 2,            // E帧（未使用）
    ST_VIDEO_IFRAME                    = 3,            // I帧（视频帧）
    ST_AUDIO_FRAME                     = 4,            // 音频帧
    ST_PRIVA_FRAME                     = 5             // 私有帧
}ST_FRAME_TYPE;

/** @enum   ST_PROTOCOL_TYPE
 *  @brief  会话协议类型
 *  @note     
 */
typedef enum _ST_PROTOCOL_TYPE_
{
    ST_PROTOCOL_RTSP                   = 1,            // RTSP协议
    ST_PROTOCOL_HIK                    = 2,            // 海康私有协议
    SYSTRANS_PROTOCOL_RTSP             = 1,            // 等同ST_PROTOCOL_RTSP，兼容定制版本的定义
    SYSTRANS_PROTOCOL_HIK              = 2             // 等同ST_PROTOCOL_HIK，兼容定制版本的定义
}ST_PROTOCOL_TYPE;

/** @enum   ST_SESSION_INFO_TYPE     
 *  @brief  会话信息类型
 *  @note     
 */
typedef enum _ST_SESSION_INFO_TYPE_
{
    ST_SESSION_INFO_SDP                = 1,            // SDP信息（对应 ST_PROTOCOL_RTSP）
    ST_HIK_HEAD                        = 2,            // 海康40字节头（对应 ST_PROTOCOL_HIK）
    SYSTRANS_SESSION_INFO_SDP          = 1,            // 等同ST_SESSION_INFO_SDP，兼容定制版本的定义
    SYSTRANS_HIK_HEAD                  = 2             // 等同ST_HIK_HEAD，兼容定制版本的定义
}ST_SESSION_INFO_TYPE;

/** @enum       ST_ENCRYPT_TYPE    
 *  @brief      加解密类型
 *  @note       注意 ！！！！老类型定义前4个枚举的命名意义错误，但考虑前向兼容而保留，请以注释为准！！！！
 *              后续不再扩展老定义，新引入加解密开发的项目，建议使用新定义           
 */
typedef enum _ST_ENCRYPT_TYPE_
{
    /* 老定义（已废弃）*/
    ST_ENCRYPT_NONE                    = 0,            // 不解密
    ST_ENCRYPT_AES                     = 1,            // AES-128解密
    ST_DECRYPT_NONE                    = 2,            // 不加密
    ST_DECRYPT_AES                     = 3,            // AES-128加密
    ST_DECRYPT_AES256                  = 4,            // AES-256解密
    ST_ENCRYPT_AES256                  = 5,            // AES-256加密
    ST_ENCRYPT_AES_HIK                 = 6,            // AES-128加密新方案
    ST_DECRYPT_AES_HIK                 = 7,            // AES-128解密新方案
	ST_DECRYPT_CFLV                    = 8,            // （暂不支持）CFLV解密

    /* 新定义 */
    ST_ENCR_TYPE_DECRYPT_NONE          = 0,            // 不解密
    ST_ENCR_TYPE_DECRYPT_AES           = 1,            // AES-128解密（方案V3）
    ST_ENCR_TYPE_ENCRYPT_NONE          = 2,            // 不加密
    ST_ENCR_TYPE_ENCRYPT_AES           = 3,            // AES-128加密（方案V3）
    ST_ENCR_TYPE_DECRYPT_AES256        = 4,            // AES-256解密（方案V3）
    ST_ENCR_TYPE_ENCRYPT_AES256        = 5,            // AES-256加密（方案V3）
    ST_ENCR_TYPE_ENCRYPT_AES_HIK       = 6,            // AES-128加密（方案V2，V3.3.1.1版本之后废弃使用，调用会默认转到加密方案V3）
    ST_ENCR_TYPE_DECRYPT_AES_HIK       = 7             // AES-128解密（方案V2，V3.3.1.1版本之后废弃使用，调用会默认转到加密方案V3）
}ST_ENCRYPT_TYPE;

/** @enum   ST_MARKBIT
 *  @brief  标记位类型
 *  @note
 */
typedef enum _ST_MARKBIT_TYPE_
{
    ST_UNMARK                          = 0,            // 没有标记
    ST_FRAME_END                       = 1,            // 帧结束标记(目标封装为PS、TS、RTP、ES时有效）
    ST_NEW_FILE                        = 2,            // 新文件标记(目标封装为MP4有效) / 刷新文件头标记（目标封装为CFLV_RESERVE有效，当前暂不支持）
    ST_MRK_SEEK                        = 3             // 定位后第一个包（目标封装为RTMP有效）
}ST_MARKBIT_TYPE;

/** @enum   ST_ERROR_TYPE
 *  @brief  错误信息
 *  @note
 */
typedef enum _ST_ERROR_TYPE_
{
    ST_ERR_UN                          = 0,            // 未知错误
    ST_ERR_RTP_SEQ                     = 1             // RTP序号不连续
}ST_ERROR_TYPE;

/** @enum   ST_MODIFY_TYPE
 *  @brief  媒体字段的修改类型
 *  @note
 */
typedef enum _ST_MODIFY_TYPE_
{
    ST_MODIFY_NONE                     = 0,            // 未知类型
    ST_MODIFY_FRAMENUM_START           = 1,            // 修改帧号的起始值
    ST_MODIFY_TIMESTAMP_START          = 2,            // 修改时间戳的起始值
    ST_MODIFY_TIMESTAMP_FIXED          = 3,            // 修改时间戳的固定间隔
    ST_MODIFY_TIMESTAMP_MULTI          = 4             // 修改时间戳的间隔倍数
} ST_MODIFY_TYPE;

/** @enum   ST_INTELLI_DATA_TYPE
 *  @brief  智能数据类型定义
 *  @note
 */
typedef enum
{
    ST_INTELLI_NONE                    = 0x00,         // none intelligent data
    ST_INTELLI_ITS_AID_INFO_V2         = 0x10,         // its aid information
    ST_INTELLI_ITS_TPS_INFO_V2         = 0x11,         // its tps information
    ST_INTELLI_ITS_TARGET_LIST         = 0x12,         // its target list
    ST_INTELLI_ITS_TPS_RULE_LIST       = 0x13,         // rule list
    ST_INTELLI_VCA_TARGET_LIST         = 0x20,         // vca target list
    ST_INTELLI_VCA_ALERT               = 0x21,         // vca alert
    ST_INTELLI_VCA_RULE_LIST           = 0x22,         // vca rule list
    ST_INTELLI_VCA_EVT_INFO_LIST       = 0x23,         // vca event information
    ST_INTELLI_FACE_IDENTIFICATION     = 0x30,         // face identification
    ST_INTELLI_FACE_DETECT_RULE        = 0x31,         // face detect rule
    ST_INTELLI_IVS_INDEX               = 0x40,         // ivs index data
    ST_INTELLI_UNKNOWN                 = 0x99          // 未知数据类型
}ST_INTELLI_DATA_TYPE;


/**    @enum     SYSTRANS_LOG_LEVEL 
 *    @brief   SYSTRANS日志控制输出等级
 *    @note     
 */
enum SYSTRANS_LOG_LEVEL
{
    SYSTRANS_LOG_LEVEL_TRACE            = 1,
    SYSTRANS_LOG_LEVEL_DEBUG            = 2,
    SYSTRANS_LOG_LEVEL_INFO             = 3,
    SYSTRANS_LOG_LEVEL_WARN             = 4,
    SYSTRANS_LOG_LEVEL_ERROR            = 5,
    SYSTRANS_LOG_LEVEL_FATAL            = 6
};


/** @enum   ST_CAPACITY_TYPE
 *  @brief  能力开关
 *  @note   注意：为了兼容性，保留 SYSTRANS_EnableCapacity 接口，不再维护更新
 *          后续统一使用 SYSTRANS_Config 进行能力开关配置
 */
typedef enum _ST_CAPACITY_TYPE_
{
    /* 用于接口 SYSTRANS_EnableCapacity（不建议使用） */
    ST_RTP_CONTAIN_FRAME_NUM           = 1,            // RTP携带帧号(该功能不支持)
    ST_AUDIO_CUT_OFF                   = 2,            // 剔除音频
    ST_FLV_CONTAIN_GLOBAL_TIME         = 3,            // FLV携带全局时间
    ST_DB_RTPJT_MODE                   = 4,            // 开启RTPJT广东地标模式
    ST_MP4_STOP_NO_INDEX               = 5,            // mp4打包的时候不生成索引
    ST_PS_CODEC_FRAME                  = 6,            // ps编码层断帧
    ST_MP4_WITH_PRIVT                  = 7,            // mp4打包输出私有数据
    ST_BEFORE_I_OUTPUT                 = 8,            // 允许I帧前数据输出

    /* 用于接口 SYSTRANS_Config */
    ST_CAPA_AUDIO_CUT_OFF              = 0x00000001,   // 剔除音频
    ST_CAPA_BEFORE_I_OUTPUT            = 0x00000002,   // 允许I帧前数据输出（目前仅纯音频码流使用）
    ST_CAPA_AUDIO_ERR_CORRECT          = 0x00000004,   // 开启音频纠错(默认以海康头为准，开启后支持音频编码层和封装层的纠错功能，目前支持ps和大华封装)
    ST_CAPA_PS_CODEC_FRAME             = 0x00000008,   // PS编码层断帧,需调用时间戳重排，否则某些码流可能会出现花屏
    ST_CAPA_RTP_CONTAIN_FRAME_NUM      = 0x00000010,   // RTP携带帧号(该功能不支持)
    ST_CAPA_MP4_OUTPUT_DURATION        = 0x00000020,   // 开启输出MP4总时长(仅支持Output回调，第一次回调输出) pData转型成所需的数据方法如：unsigned int unDurationS = 0;  memcpy(&unDurationS, pstDataInfo->pData, sizeof(int));
                                                       // 总时长目前只支持mp4无头流式探测，且注册回调函数需要使用SYSTRANS_RegisterOutputDataCallBack
    ST_CAPA_MP4_STOP_NO_INDEX          = 0x00000040,   // MP4打包的时候不生成索引
    ST_CAPA_MP4_WITH_PRIVT             = 0x00000080,   // MP4打包输出私有数据
    ST_CAPA_FLV_TAG_FRAMEBREAK         = 0x00000100,   // FLV按一个tag一帧断帧
    ST_CAPA_FLV_CONTAIN_GLOBAL_TIME    = 0x00000200,   // FLV携带全局时间
    ST_CAPA_RTPJT_MODE                 = 0x00000400,   // 开启RTPJT广东地标模式
    ST_CAPA_MP4_RESERVE                = 0x00000800,   // MP4预制索引只输出一次
    ST_CAPA_PRIVATE_APPEND             = 0x00001000,   // 在视频帧前打私有帧
    ST_CAPA_FRAME_BY_OUTPUT            = 0x00010000    // 以帧为单位输出，默认情况是每次输出一个包，配置该选项，会一次输出一帧(仅支持TS)
} ST_CAPACITY_TYPE;

/** @enum ST_SEEK_TYPE
 *  @brief  定位模式
 *  @note
 */
typedef enum _SYSTRANS_SEEK_TYPE_
{
    SYSTRANS_SEEK_NONE                 = 0,            // 不定位
    SYSTRANS_SEEK_BY_NUM               = 1,            // 按帧号定位
    SYSTRANS_SEEK_BY_TIME              = 2             // 按相对时间定位
} ST_SEEK_TYPE;

/** @enum   SYSTRANS_TS_RESET_MODE 
 *  @brief  SYSTRANS时间戳重排模式
 *  @note     
 */
typedef enum _SYSTRANS_TS_RESET_MODE_
{
	SYSTRANS_TS_RESET_ORIGIN           = 0,            // 异常修正模式（仅时间戳出现异常时，按配置值来修正）
	SYSTRANS_TS_RESET_INCREASE         = 1,            // 单调递增模式（视频时间戳异常时，按配置值来修正；音频时间戳默认使用采样率来生成）
	SYSTRANS_TS_RESET_SYN_AV           = 2             // 音视频同步（覆盖单调递增能力）
}SYSTRANS_TS_RESET_MODE;

/** @enum   ST_PARSE_PRI 
 *  @brief  解析（探测）优先级
 *  @note     
 */
typedef enum _ST_PARSE_PRIORITY_
{
	ST_PARSE_PRI_AUTO                  = 0,            // 自适应（海康 + ffmpeg，海康优先）
	ST_PARSE_PRI_HIK                   = 1,            // 仅使用海康算法
	ST_PARSE_PRI_FFMPEG                = 2             // 仅使用ffmpeg算法
}ST_PARSE_PRI;

/** @enum   ST_CONFIG_TYPE
 *  @brief  配置类型（ST_CONFIG_ITEM）
 *  @note
 */
typedef enum _ST_CONFIG_TYPE_
{
    ST_CFG_TYPE_UNKNOWN                = 0,
    ST_CFG_TYPE_INIT_PARAM             = 1,            // 初始化配置（对应结构体 ST_CONFIG_INIT）
    ST_CFG_TYPE_FFMPEG                 = 2,            // ffmpeg配置（对应结构体 ST_CONFIG_FFMPEG）
    ST_CONFIG_TARGET_HEADER_MODIFY     = 3             // 用于修改输出目标的海康头配置，内部包含视频参数、音频参数（对应结构体 ST_CONFIG_TGT_HEADER_MOD）
} ST_CONFIG_TYPE;


/************************************************************************
* 数据结构定义
************************************************************************/
/** @struct ST_CONFIG_INIT
 *  @brief  初始化配置结构体
 *  @note   用于 ST_CONFIG_ITEM
 */
typedef struct _ST_CONFIG_INIT_
{
    unsigned int dwBufferSize;                      // 缓存大小（单位：字节，取值范围 2（MB） ~ 8（MB），默认 2（MB））
    unsigned int dwPriority;                        // 解析优先级：0 = 自适应（海康解析 + FFmpeg解析，海康优先）；1 = 海康解析；2 = FFmpeg解析
    unsigned int dwReserved[30];                    // 保留字段
} ST_CONFIG_INIT;

/** @struct ST_CONFIG_FFMPEG
 *  @brief  FFMPEG功能配置结构体
 *  @note   用于 ST_CONFIG_ITEM
 */
typedef struct _ST_CONFIG_FFMPEG_
{
    char*           pFFmpegLibPath;                 // FFmpeg动态链接库路径（不填默认在程序当前目录查找）
    unsigned int    dwReserved[15];                 // 保留字段
} ST_CONFIG_FFMPEG;

/** @struct ST_CONFIG_TARGET_HEADER_MODIFY
 *  @brief  修改输出目标的海康头配置
 *  @note   适用场景：原始码流中剔除音/视频，再合入其它音/视频格式，编码参数发生改变的情况
 */
typedef struct _ST_CONFIG_TARGET_HEADER_MODIFY_
{
    /* 修改的音频参数 */
    unsigned int    dwAudioEnable;                  // 音频参数修改使能开关，0=不启用，1=启用
    unsigned int    dwAudioFormat;                  // 音频编码类型
    unsigned int    dwAudioChannels;                // 音频通道数
    unsigned int    dwAudioBitsPerSample;           // 音频样位率
    unsigned int    dwAudioSamplesrate;             // 音频采样率
    unsigned int    dwAudioBitrate;                 // 音频比特率

    /* 修改的视频参数 */
    unsigned int    dwVideoEnable;                  // 视频参数修改使能开关，0=不启用，1=启用
    unsigned int    dwVideoFormat;                  // 视频编码类型

    unsigned int    dwReserved[6];                  // 保留
} ST_CONFIG_TGT_HEADER_MOD;

/** @struct ST_CONFIG_ITEM
 *  @brief  单个结构体配置项
 */
typedef struct _ST_CONFIG_ITEM_
{
    unsigned int nType;                             // 配置类型（参考 ST_CONFIG_TYPE）
    void*        pConfig;                           // 配置结构体指针（根据nType确定）
}ST_CONFIG_ITEM;

/** @struct ST_CONFIG
 *  @brief  转封装配置
 *  @note   支持能力开关的组合配置（capacity）、复杂配置的批量下发（stConfigItem）
 */
typedef struct _ST_CONFIG_
{
    unsigned int	nCapacity;                      // 能力开关（支持 "|" 操作符组合下发）
    ST_CONFIG_ITEM  stConfigItem[MAX_CFG_ITEM_NUM]; // 配置结构体数组
    unsigned int    resv[16];                       // 保留字段
}ST_CONFIG;

/** @struct ST_CAPACITY_INFO
 *  @brief  能力开关配置
 *  @note   注意：不再维护更新，统一使用 ST_CONFIG
 */
typedef struct _ST_CAPACITY_INFO_ 
{
    unsigned int    nCapacityType;                  // 开启的功能类型
    unsigned char   reserved[4];                    // 保留字段
} ST_CAPACITY_INFO;

/** @struct ST_SEEK_INFO
 *  @brief  定位参数
 *  @note
 */
typedef struct _ST_SEEK_INFO_
{
    ST_SEEK_TYPE        enSeekType;                 // 定位方式（时间戳定位 or 帧号定位）
    unsigned int        dwSeekTimeStamp;            // 定位时间(ms)
    unsigned int        dwSeekFrameNum;             // 定位帧号
    unsigned long long  llSeekPos;                  // 定位偏移量
    unsigned int        resv[8];                    // 保留字段
}ST_SEEK_INFO;


/** @struct     SYS_TRANS_PARA 
 *  @brief      创建转封装句柄参数结构
 *  @note       用于SYSTRANS_Create接口
 */
typedef struct _SYS_TRANS_PARA_
{
    unsigned char*  pSrcInfo;                       // 海康设备出的媒体信息头（源码流信息）；配置为NULL时内部探测开流
    unsigned int    dwSrcInfoLen;                   // pSrcInfo输入海康头时，固定填40；不为40时内部探测开流
    SYSTEM_TYPE     enTgtType;                      // 目标封装格式
    unsigned int    dwTgtPackSize;                  // 设置为0时，使用库内默认值。
                                                    // 目标格式为RTP/PS/TS时为设定包大小；
                                                    // 目标格式为MPEG4（索引预写）时为设定最大索引长度。
    unsigned int    dwSrcDemuxSize;                 // 暂用于RTMP格式：设置无效时，使用库内默认值。
    unsigned int    dwAggregate;                    // 暂用于RTMP格式：设置为0时，表示不使用聚合包，大于0时表示聚合包中视频Tag的数量（目前仅支持 <= 5）。
    unsigned int    dwMessageStreamID;              // 仅RTMP打包使用：服务器返回的MessageStreamID
    unsigned int    dwChunkStreamID;                // 仅RTMP打包使用：预览设置为4，回放设置为5
} SYS_TRANS_PARA;

/** @struct ST_SESSION_PARA 
 *  @brief  转封装会话信息参数
 *  @note   用于SYSTRANS_CreateEx，增加支持RTSP协议的SDP信息
 */
typedef struct _ST_SESSION_PARA_ 
{
    ST_SESSION_INFO_TYPE nSessionInfoType;          // 会话信息类型，支持海康媒体头、SDP信息
    unsigned int         nSessionInfoLen;           // 会话信息长度
    unsigned char*       pSessionInfoData;          // 会话信息数据
    SYSTEM_TYPE          eTgtType;                  // 目标封装格式
    unsigned int         nTgtPackSize;              // 设置为0时，使用库内默认值。
                                                    // 目标格式为RTP/PS/TS时为设定包大小；
                                                    // 目标格式为AVI时为设定最大帧长；
                                                    // 目标格式为MPEG4（索引预写）时为设定最大索引长度。
} ST_SESSION_PARA,SYS_TRANS_SESSION_PARA;

/** @struct AUTO_SWITCH_PARA 
 *  @brief  自动切换参数
 *  @note     
 */
typedef struct AUTO_SWITCH_PARA
{
    unsigned int    dwSwitchFlag;                   // SWITCH_BY_TIME：通过时间来切换
    unsigned int    dwSwitchValue;                  // 时间以分钟为单位(设定的固定时间值)
    unsigned int    dwSubNameFlag;                  // SUBNAME_BY_GLOBALTIME：文件名以全局时间区分
    char            szMajorName[128];               // 如szMajorName = c:\test,切换文件后的名称 = c:\test_年月日时分秒.mp4
} AUTO_SWITCH_PARA;

/** @struct OUTPUTDATA_INFO   
 *  @brief  输出数据定义
 *  @note     
 */
typedef struct OUTPUTDATA_INFO 
{
    unsigned char*  pData;                          // 回调数据缓存，该指针请勿用于异步的传递
    unsigned int    dwDataLen;                      // 回掉数据长度
    unsigned int    dwDataType;                     // 数据类型，参考输出数据类型定义：如 TRANS_SYSHEAD,TRANS_STREAMDATA
    unsigned int    dwFlag;                         // 是否为MPEG4索引；是否为wav头
} OUTPUTDATA_INFO;

/** @struct DETAIL_DATA_INFO
 *  @brief  详细数据信息
 *  @note   帧号、全局时间、分辨率信息，只支持目标为ES、PS的码流
 */
typedef struct _DETAIL_DATA_INFO_
{
    unsigned char*  pData;                          // 回调数据缓存，该指针请勿用于异步的传递
    unsigned int    nDataLen;                       // 回掉数据长度
    unsigned short  nDataType;                      // 输出数据类型，见宏定义
    unsigned short  nFrameType;                     // 帧类型，见枚举类型
    unsigned int    nTimeStamp;                     // 时间戳
    unsigned int    nTimeStampHigh;                 // 时间戳高位,用于时间戳超过四字节的格式
    unsigned short  nMarkbit;                       // 标记(目前支持帧结束、新建文件两种标记，参见ST_MARKBIT_TYPE，帧结束标记仅在输出ps、ts、rtp封装时有效）；[暂不支持]针对目标格式为 TRANS_SYSTEM_CFLV_RESERVE（cflv文件头预写），该标记手动置为 ST_NEW_FILE，表示当前文件头已被使用，需要立刻刷新文件头缓存（如：start_time等信息）
    unsigned short  nVersion;                       // 结构体版本号
    unsigned int    reserved[26];                   // 保留字段，用于扩展
                                                    // reserved[0]表示回调数据是否为MPEG4索引
                                                    // reserved[1]表示视频帧号
                                                    // reserved[2]表示年
                                                    // reserved[3]表示月
                                                    // reserved[4]表示日
                                                    // reserved[5]表示时
                                                    // reserved[6]表示分
                                                    // reserved[7]表示秒
                                                    // reserved[8]表示毫秒
                                                    // reserved[9]表示视频宽
                                                    // reserved[10]表示视频高
                                                    // reserved[11]表示视频帧率
                                                    // reserved[12]表示转前码流携带的加密标记（0=无, 其他=加密类型: 1=AES128+3轮, 2=AES128+10轮, 3=AES192, 4=AES256, 17=AES128+3轮+新方案, 18=AES128+10轮+新方案, 19=AES256+14轮+新方案）。注意，加密码流不一定每帧都有加密标记，请注意使用逻辑。
                                                    // reserved[13]当为视频帧时，表示合成流标记（0=非合成流, 1=2字节合成流版本, 2=3字节合成流版本, 输出的buf需要自行根据 IDMX_MFI_HEADER 帧头遍历解析得到每一个小帧buf）
													//             当为私有帧时，表示私有数据类型，对应ST_INTELLI_DATA_TYPE枚举；
                                                    // reserved[14]当为私有帧时，表示私有裸数据地址高位。
                                                    //             当为视频帧时，表示视频编码类型。
                                                    //             当为音频帧时，表示音频编码类型。
                                                    // reserved[15]当为私有帧时，表示私有裸数据地址低位。
                                                    //             当为音频帧时，低16位表示音频样位率；
                                                    // reserved[16]当为私有帧时，表示私有裸数据长度。
                                                    //             当为音频帧时，表示音频采样率
                                                    // reserved[17]当为视频帧时，如果是I帧，    Reserved[17] |= 0x00000001，标记为svc码流，              Reserved[17] &= 0xFFFFFFFE，标记非svc码流；
                                                    //             当为音频帧时，表示音频压缩码率（bitrate）
                                                    // reserved[18] 当为视频帧时，如果是I帧，    Reserved[18] |= 0x00000001，标记为smart264/smart265码流，Reserved[18] &= 0xFFFFFFFE，标记非smart264/smart265码流；
                                                    //                            如果是P帧，    Reserved[18] |= 0x00000001，标记为深P帧，                Reserved[18] &= 0xFFFFFFFE，标记非深P帧; 
                                                    //                            如果是I/P/B帧，Reserved[18] |= 0x00000002，标记为小鹰眼码流，           Reserved[18] &= 0xFFFFFFFD，标记非小鹰眼码流;              
                                                    //                            如果是I/P/B帧，Reserved[18] |= 0x00000004，标记为2400W码流，            Reserved[18] &= 0xFFFFFFFB，标记非2400W码流; 
                                                    //                            如果是I/P/B帧，Reserved[18] |= 0x00000008，标记为intra码流，            Reserved[18] &= 0xFFFFFFF7，标记非intra码流;
                                                    //                            如果是I/P/B帧，Reserved[18] |= 0x00000010，标记为Infinit GOP码流，      Reserved[18] &= 0xFFFFFFEF，标记非Infinit GOP码流;
                                                    //                            如果是I/P/B帧，Reserved[18] |= 0x00000020，标记为多场码流，             Reserved[18] &= 0xFFFFFFDF，标记非多场码流;
                                                    // reserved[19]表示原码流是否携带全局时间, 0=未携带, 1=携带
}DETAIL_DATA_INFO;

/** @struct HK_SYSTEM_TIME  
 *  @brief  系统时间
 *  @note     
 */
typedef struct _HK_SYSTEM_TIME_
{
    unsigned int  dwYear;                           // 年
    unsigned int  dwMonth;                          // 月
    unsigned int  dwDay;                            // 日
    unsigned int  dwHour;                           // 时
    unsigned int  dwMinute;                         // 分
    unsigned int  dwSecond;                         // 秒
    unsigned int  dwMilliSecond;                    // 毫秒
    unsigned int  dwReserved;                       // 模式，0为历史流模式，需要初始化全局时间
                                                    //       1为实时流模式，根据系统时间自动设置全局时间
} HK_SYSTEM_TIME;

/** @struct HK_VIDEO_PACK_PARA  
 *  @brief  视频打包参数 
 *  @note     
 */
typedef struct _HK_VIDEO_PACK_PARA_ 
{
    unsigned int   dwFrameNum;                      // 帧号
    unsigned int   dwTimeStamp;                     // 时间戳
    float          fFrameRate;                      // 帧率
    unsigned int   dwNaluEnd;                       // 单NALU结束置1
    HK_SYSTEM_TIME stSysTime;                       // 全局时间
    unsigned int   dwWidth;                         // 宽
    unsigned int   dwHeight;                        // 高
} HK_VIDEO_PACK_PARA;

/** @struct HK_AUDIO_PACK_PARA 
 *  @brief  音频打包参数
 *  @note     
 */
typedef struct _HK_AUDIO_PACK_PARA_ 
{
    unsigned int  dwChannels;                       // 声道数
    unsigned int  dwBitsPerSample;                  // 位样率
    unsigned int  dwSampleRate;                     // 采样率
    unsigned int  dwBitRate;                        // 比特率
    unsigned int  dwTimeStamp;                      // 时间戳
    unsigned int  dwReserved[3];                    // 保留
} HK_AUDIO_PACK_PARA;

/** @struct HK_PRIVATE_PACK_PARA 
 *  @brief  私有数据打包参数
 *  @note     
 */
typedef struct _HK_PRIVATE_PACK_PARA_ 
{
    unsigned int  dwPrivateType;                    // 私有类型
    unsigned int  dwDataType;                       // 数据类型
    unsigned int  dwSycVideoFrame;                  // 同步视频帧
    unsigned int  dwReserved;                       // 保留
    unsigned int  dwTimeStamp;                      // 时间戳
    unsigned int  dwReserved1[2];                   // 保留
} HK_PRIVATE_PACK_PARA;

/** @struct ST_CUSTOM_DATA_INFO 
 *  @brief  自定义数据打包参数
 *  @note     
 */
typedef struct _ST_CUSTOM_DATA_INFO_
{
    unsigned char*  pData;                          // 数据指针
    unsigned int    nDataLen;                       // 数据长度
    unsigned int    nDataType;                      // 数据类型
    unsigned short  nWidth;                         // 宽
    unsigned short  nHeight;                        // 高
    unsigned int    nTimeStamp;                     // 时间戳低位
    unsigned int    nTimeStampHigh;                 // 时间戳高位
} ST_CUSTOM_DATA_INFO;

/** @struct ST_ERROR_INFO
 *  @brief  错误数据回调信息
 *  @note     
 */
typedef struct _ST_ERROR_INFO_
{
    ST_ERROR_TYPE   nErrorType;                     // 错误类型
    unsigned char*  pHeaderData;                    // 若头有误，送出实际码流头，默认40字节
    unsigned char*  pData;                          // 错误数据指针
    unsigned int    dwDatalen;                      // 错误数据长度
    unsigned int    Reserved[4];                    // 保留
}ST_ERROR_INFO;

/** @enum       ST_CAMERA_MARK
 *  @brief      相机标识
 *  @note       与底层解析、打包组件保持统一
 */
typedef enum _ST_CAMERA_MARK_
{
    ST_CAMERA_MARK_UNDEF                = 0x00,     // 无
    ST_CAMERA_MARK_HIK_FISHEYE          = 0x80,     // 海康鱼眼相机
    ST_CAMERA_MARK_BINOCULAR_CAMERA     = 0x81,     // 双目相机（上下）
    ST_CAMERA_MARK_EAGLE_EYE            = 0x82,     // 小鹰眼（多路流，固定两路分辨率相同）
    ST_CAMERA_MARK_IPC2400W             = 0x84,     // 2400W IPC(合成流，固定四路分辨率相同)
    ST_CAMERA_MARK_EZVIZ_DOUBLEEYE      = 0x85      // 萤石双目智能锁（多路流，固定两路分辨率不同）
} ST_CAMERA_MARK;

/** @enum       ST_MULTI_PACK_MODE
 *  @brief      多源数据打包模式
 *  @note       具体参见 ST_MULTI_DATA_PARA 结构说明
 */
typedef enum _ST_MULTI_PACK_MODE_
{
    ST_MUL_PACK_MODE_NONE    = 0,    // 无 
    ST_MUL_PACK_MODE_MULTI   = 1,    // 多路流，多路，每一路对应一帧
    ST_MUL_PACK_MODE_COMB    = 2     // 合成流，单路，多帧合并为一帧（基于MFI协议）
} ST_MULTI_PACK_MODE;

/** @enum       ST_MULTI_PACK_CUS_INFO_TYPE
 *  @brief      多路流打包自定义信息类型
 *  @note       
 */
typedef enum _ST_MULTI_PACK_CUS_INFO_TYPE_
{
    ST_MULTI_PACK_CUS_INFO_TYPE_NONE            = 0,    // 无 
    ST_MULTI_PACK_CUS_INFO_TYPE_CAMERA_POS      = 1,    // 摄像头方位信息
} ST_MULTI_PACK_CUS_INFO_TYPE;

/** @enum       ST_COMB_PACK_CUS_INFO_TYPE
 *  @brief      合成流打包自定义信息类型
 *  @note       
 */
typedef enum _ST_COMB_PACK_CUS_INFO_TYPE_
{
    ST_COMB_PACK_CUS_INFO_TYPE_NONE             = 0,    // 无 
    ST_COMB_PACK_CUS_INFO_TYPE_MFI_VERSION_1    = 1,    // 合成帧版本1（2字节mfi，支持16路合成，目前暂无额外自定义信息）
    ST_COMB_PACK_CUS_INFO_TYPE_MFI_VERSION_2    = 2     // 合成帧版本2（3字节mfi，支持64路合成，支持配置布局位置信息）
} ST_COMB_PACK_CUS_INFO_TYPE;

/** @struct     ST_MULTI_PACK_PARA
 *  @brief      多路流打包参数
 *  @note       针对多路码流合并成一路的场景（如小鹰眼、萤石双目等多摄类产品）
 */
typedef struct _ST_MULTI_PACK_PARA_
{
    unsigned char byCustomType;                 // 自定义信息类型（参考 ST_MULTI_PACK_CUS_INFO_TYPE）
    unsigned char resv[15];                     // 预留字段

    /* 自定义信息 */
    union
    {
        /* 摄像头方位信息（ST_MULTI_PACK_CUS_INFO_TYPE_CAMERA_POS） */
        struct
        {
            unsigned char byCameraPos;          // 摄像头方位：0-上，1-下，2-左，3-右
            unsigned char aucData[15];          // 剩余15个字节自定义信息待定
            unsigned char resv[48];             // 保留字段
        } stCamPosPara;

        /* 固定联合体大小64字节 */
        unsigned int size[16];
    } unCustom;

}ST_MULTI_PACK_PARA;

/** @struct     ST_COMB_PACK_PARA
 *  @brief      合成流打包参数
 *  @note       针对多帧数据合并成一帧的场景（如2400W、大屏拼接等切割合并类产品）
 */
typedef struct _ST_COMB_PACK_PARA_
{
    unsigned char byCustomType;                 // 自定义信息类型（参考 ST_COMB_PACK_CUS_INFO_TYPE）
    unsigned char resv[15];                     // 预留字段

    /* 自定义信息 */
    union
    {
        /* 合成帧布局配置（ST_COMB_PACK_CUS_INFO_TYPE_MFI_VERSION_2） */
        struct
        {
            unsigned int dwLeftTopX;			// 当前源左上顶点在总分辨率中的x坐标位置（单位：像素）
            unsigned int dwLeftTopY;			// 当前源左上顶点在总分辨率中的y坐标位置（单位：像素）
            unsigned int dwWidth;				// 当前源展示宽（可能与解码宽不同，取值范围0~65535），用于渲染缩放处理
            unsigned int dwHeight;			    // 当前源展示高（可能与解码高不同，取值范围0~65535），用于渲染缩放处理
            unsigned int dwWidthAll;			// 合成流展示总分辨率宽（水平方向分辨率之和最大值），用于渲染创建矩形纹理
            unsigned int dwHeightAll;		    // 合成流展示总分辨率高（垂直方向分辨率之和最大值），用于渲染创建矩形纹理
            unsigned int resv[4];               // 保留字段
        } stMfiLayoutPara;

        /* 固定联合体大小64字节 */
        unsigned int size[16];
    } unCustom;
}ST_COMB_PACK_PARA;

/** @struct     ST_MULTI_ELEMT_STREAM_PARA
 *  @brief      多源数据打包参数
 *  @note       场景：
 *              1）多个码流源以多路的形式合入一份码流（多路流：每路一个stream id，一路对应一个数据源）
 *              2）多个码流源以多帧合并的形式合入一份码流（合成流：单路，多个源数据在调用者做好帧同步的前提下，从各数据源获取一帧，基于MFI协议合成一个大帧后封装打包）
 */
typedef struct _ST_MULTI_ELEMT_STREAM_PARA_
{
    unsigned char byMode;       // 打包模式，参考 ST_MULTI_PACK_MODE
    unsigned char byDataSeq;    // 当前数据源在总数中的编号（从0开始顺序编制，外部需严格按顺序送入，合成流需确保各轨间帧类型、时间等信息的同步）
    unsigned char byDataSum;    // 数据源总数（多路流的总路数，上限16路；合成流的总轨数，上限64路）
    unsigned char resv[45];     // 预留字段
    
    /* 配置参数 */
    union
    {
        /* 多路流参数 */
        ST_MULTI_PACK_PARA stMulPack;
        /* 合成流参数 */
        ST_COMB_PACK_PARA stCombPack;
        /* 固定联合体大小80字节 */
        unsigned int size[20];
    } unPara;
}ST_MULTI_ELEMT_STREAM_PARA;

/** @struct     ST_COLORSPACE_PARA
 *  @brief      色彩空间参数配置信息
 *  @note       
 */
typedef struct _ST_COLORSPACE_PARA_
{
    unsigned char byFlag;                     // 0不启动，1启用(置为1，则强制将该帧打成I帧，配上PSM)
    unsigned char csp_ver;                    // 协议版本号，当前有效值1（包含色彩范围，色域，转换曲线及色彩转换矩阵这四个信息）
    unsigned char byVideoFullRangeFlag;       // 色彩范围
    unsigned char byColourPrimaries;          // 色域
    unsigned char byTransferCharacteristics;  // 转换曲线
    unsigned char byMatrixCoefficients;       // 色彩转换曲线
    unsigned char resv[10];                   // 预留
}ST_COLORSPACE_PARA;


/** @struct     HK_VIDEO_PACK_PARA_EX
 *  @brief      视频打包参数扩展
 *  @note       该结构体继承 HK_VIDEO_PACK_PARA 中所有参数，对应枚举VIDEO_PARA_EX
 *              注意① | 关于多源数据打包配置，当某个数据源存在缺损无法正常输入时，为保证协议完整性，
 *              需依次输入正确的 HK_VIDEO_PACK_PARA_EX 参数（编号信息），
 *              以及一个空包结构： pData = NULL, dwDataLen = 0xFFFFFFFF
 */
typedef struct _HK_VIDEO_PACK_PARA_EX_ 
{
    unsigned int dwFrameNum;                // 帧号
    unsigned int dwTimeStamp;               // 时间戳
    float fFrameRate;                       // 帧率
    unsigned int dwReserved;                // 保留
    HK_SYSTEM_TIME stSysTime;               // 全局时间
    unsigned int dwWidth;                   // 宽
    unsigned int dwHeight;                  // 高

    /*----------------------------------------------*/
    /*↑↑↑↑ 与HK_VIDEO_PACK_PARA保持一致 ↑↑↑↑*/
    /*==============================================*/
    /*↓↓↓↓           扩展内容           ↓↓↓↓*/
    /*----------------------------------------------*/
    ST_MULTI_ELEMT_STREAM_PARA stMultiPara; // 多源数据打包配置
    unsigned char byCameraMark;             // 相机标识（非特定产品可填0），参考 ST_CAMERA_MARK
    ST_COLORSPACE_PARA stColorSpacePara;
    unsigned char bySmart;                  // 是否smart码流，0表示否，1表示是。对于多路合成，要么全是smart，要么全不是
    unsigned char resv[54];                 // 预留字段
} HK_VIDEO_PACK_PARA_EX;

/** @struct ST_PACK_INFO 
 *  @brief  SYSTRANS打包信息
 *  @note     
 */
typedef struct _ST_PACK_INFO_
{
    unsigned int    nFrameType;                     // 帧类型
    unsigned int    nTimeStamp;                     // 时间戳 单位ms
    HK_SYSTEM_TIME* pstGlobalTime;                  // 全局时间
    float           fTimePerFrame;                  // 视频帧间隔
    unsigned int    nAudioSampleRate;               // 音频帧率
	unsigned int    nFrameLen;                      // 帧长
	unsigned int    Reserved[8];                    // 保留
} ST_PACK_INFO;

/** @struct ST_PACK_INIT_INFO 
 *  @brief  打包初始信息
 *  @note     
 */
typedef struct _ST_PACK_INIT_INFO_
{
    unsigned int    nValue;                         // 时间戳回调后调的阈值，单位ms，建议填写大于100ms
    unsigned int    bTimestampSync;                 // 是否进行音视频时间戳同步，时间戳归0处理
    unsigned int    nTimePerFrame;                  // 异常处理时步进的视频帧间隔（配置为0时，默认使用帧率计算帧间隔）
    unsigned int    bResetGlobeTime;                // 是否重置全局时间
    HK_SYSTEM_TIME* pstGlobalTime;                  // 选择重置全局时间生效，置为NULL时，默认使用原码流首帧全局时间为初始值。
    unsigned int    nTimePerAudioFrame;             // 异常处理时步进的音频帧间隔（配置为0时，默认使用采样率计算间隔）
	unsigned int    nTSResetMode;                   // 见SYSTRANS_TS_RESET_MODE
    unsigned int    Reserved[8];                    // 保留
} ST_PACK_INIT_INFO;

/** @struct ST_ERR_DETAIL
 *  @brief  错误码详情回调信息
 *  @note     
 */
typedef struct _ST_ERR_DETAIL_
{
    unsigned int    nErrCode;                       // 错误码
    unsigned char   *pData;                         // 源数据（只读，请勿修改！）
    unsigned int    nDataLen;                       // 数据长度
    unsigned int    nProgressPctg;                  // 处理进度（仅文件模式有效）
    unsigned int    resv[8];                        // 保留字段

    /* 码流信息 */
    unsigned short  usSysFmtIn;                     // 源封装格式（参考海康头协议）
    unsigned short  usVideoCodecType;               // 视频编码格式（参考海康头协议）
    unsigned short  usAudioCodecType;               // 音频编码格式（参考海康头协议）
    unsigned char   ucEncryptFlag;                  // 加密标记（0=无, 其他=加密类型: 1=AES128+3轮, 2=AES128+10轮, 3=AES192, 4=AES256, 17=AES128+3轮+新方案, 18=AES128+10轮+新方案, 19=AES256+14轮+新方案）
    unsigned char   ucMfiFlag;                      // 多轨标记（0=非多轨流, 其他=小轨路数）
    unsigned int    resv1[8];                       // 保留字段1

    /* 处理信息 */
    unsigned short  usSysFmtOut;                    // 目标封装格式（参考海康头协议）
    unsigned char   ucFileModeFlag;                 // 文件模式标记（0=流式, 1=文件模式）
    unsigned char   resv2;                          // 保留字段2
    unsigned int    resv3[8];                       // 保留字段3
}ST_ERR_DETAIL;

/** @struct ST_MP4_INFO
 *  @brief  MP4文件信息结构
 *  @note 
 */
typedef struct _ST_MP4_INFO_
{
    unsigned int         nMP4;                      // 是否是MP4封装,0表示不是，1表示是
    unsigned int         unFrontOrEndIndex;         // mp4索引类型：1 = 前置索引；2 = 后置索引
    unsigned long long   llOffPosSize;              // 索引的偏移位置,针对整个文件的偏移
    unsigned int         unndexSize;                // 索引大小
    unsigned int         Reserved[9];               // 保留
} ST_MP4_INFO;

/** @struct ST_SYSTEM_INFO
 *  @brief  封装信息结构
 *  @note   暂用于预探测返回
 */
typedef union
{
    ST_MP4_INFO stMp4Info;                          // MP4信息
}ST_SYSTEM_INFO;

/** @struct ST_FMT_PARAM
 *  @brief  探测输出参数结构
 *  @note   
 */
typedef struct _ST_FMT_PARAM_
{
    unsigned int    dwSystemFormat;                 // 封装类型
    ST_SYSTEM_INFO  stSysInfo;                      // 封装格式信息（根据 dwSystemFormat 决定结构体）
    unsigned int    Reserved[8];                    // 保留
}ST_FMT_PARAM;

/** @struct ST_MEDIA_VIDEO_INFO
 *  @brief  视频信息结构体
 */
typedef struct _ST_MEDIA_VIDEO_INFO_ 
{
    unsigned int video_format;                      // 视频编码格式
    unsigned int total_time;                        // 视频总时长
    unsigned int total_num;                         // 总帧数
    unsigned int width;                             // 宽
    unsigned int height;                            // 高
    unsigned int frame_rate;                        // 帧率
    unsigned int reserved;                          // 保留字段
} ST_MEDIA_VIDEO_INFO;


/** @struct ST_MEDIA_AUDIO_INFO
 *  @brief  音频信息结构体
 */
typedef struct _ST_MEDIA_AUDIO_INFO_ 
{
    unsigned short  audio_format;                   // 音频编码格式
    unsigned char   audio_channels;                 // 声道数
    unsigned char   audio_bits_per_sample;          // 样位
    unsigned int    audio_samplesrate;              // 采样率
    unsigned int    audio_bitrate;                  // 比特率
    unsigned int    total_time;                     // 总的时间
    unsigned char*  assist_info;                    // 其他信息
} ST_MEDIA_AUDIO_INFO;

/** @struct ST_MEDIA_PRIVATE_INFO
 *  @brief  私有信息结构体
 */
typedef struct _ST_MEDIA_PRIVATE_INFO_ 
{
    unsigned short private_type;                    // 私有类型
    unsigned short reserved;                        // 保留字段  
} ST_MEDIA_PRIVATE_INFO;

/** @struct ST_MEDIA_INNER_INFO
 *  @brief  媒体探测信息结构体
 */
typedef struct _ST_MEDIA_INSPEC_INFO_ 
{
    unsigned char           version;                        // 版本
    unsigned char           flags;                          // 标识
    unsigned short          system_format;                  // 系统层格式
    unsigned int            company_mark;                   // 公司标示
    unsigned int            video_stream_count;             // 视频流数量
    unsigned int            audio_stream_count;             // 音频流数量
    unsigned int            privt_stream_count;             // 私有流数量
    ST_MEDIA_VIDEO_INFO     video_info[INSPECT_MAX_TRACK];  // 视频
    ST_MEDIA_AUDIO_INFO     audio_info[INSPECT_MAX_TRACK];  // 音频
    ST_MEDIA_PRIVATE_INFO   privt_info[INSPECT_MAX_TRACK];  // 私有相关
    unsigned int            reserved[4];                    // 保留字段
} ST_MEDIA_INSPEC_INFO;


/************************************************************************
* 回调函数定义
************************************************************************/

/**  @fn        SYSTRANSLogCb
*    @brief     SYSTRANS日志输出回调函数
*    @param     iLogLevel           SYSTRANS日志输出等级,见SYSTRANS_LOG_LEVEL
*    @param     const char* format  SYSTRANS日志输出格式
*    @param     void* varlist       SYSTRANS日志输出参数，varlist指针为va_list*，用户不用再调用va_start和va_end
*    @param     void* pUser 回调用户参数
*    @return    void
*/
typedef void (__stdcall *SYSTRANSLogCb)( int iLogLevel, const char* format, void* varlist, void* pUser);

/**  @fn        SYSTRANSGlobalTimeCb
*    @brief     SYSTRANS全局时间回调函数
*    @param     pGlobalTime 回调当前帧的全局时间，用户可外部修改其值
*    @param     void* pUser 回调用户参数
*    @return    void
*/
typedef void (__stdcall *SYSTRANSGlobalTimeCb)( HK_SYSTEM_TIME* pGlobalTime, void* pUser);

/**  @fn        SYSTRANSPackInfoCb
*    @brief     SYSTRANS打包信息回调函数
*    @param     pPackInfo 回调当前帧的打包信息，用户可外部修改其值
*    @param     void* pUser 回调用户参数
*    @return    void
*/
typedef void (__stdcall *SYSTRANSPackInfoCb)( ST_PACK_INFO* pPackInfo, void* pUser);

/**  @fn        SYSTRANSErrorInfoCb
*    @brief     SYSTRANS错误信息回调函数
*    @param     pErrorInfo  回调错误信息
*    @param     void* pUser 回调用户参数
*    @return    void
*/
typedef void (__stdcall *SYSTRANSErrorInfoCb)(ST_ERROR_INFO* pErrorInfo, void* pUser);

/**  @fn        SYSTRANSErrDetailCb
*    @brief     SYSTRANS错误码详情回调函数
*    @param     pErrInfo    回调错误码信息
*    @param     void* pUser 回调用户参数
*    @return    void
*/
typedef void (__stdcall *SYSTRANSErrDetailCb)(ST_ERR_DETAIL* pErrInfo, void* pUser);

/**  @fn        SYSTRANSOutputDataCb
*    @brief     SYSTRANS转换后数据回调函数
*    @param     pDataInfo   目标数据
*    @param     void* pUser 回调用户参数
*    @return    void
*/
typedef void (__stdcall *SYSTRANSOutputDataCb)(OUTPUTDATA_INFO* pDataInfo, void* pUser);

/**  @fn        SYSTRANSDetailDataCb
*    @brief     SYSTRANS转换后详细数据回调函数
*    @param     pDataInfo   目标数据详情
*    @param     void* pUser 回调用户参数
*    @return    void
*/
typedef void (__stdcall *SYSTRANSDetailDataCb)(DETAIL_DATA_INFO* pDataInfo, void* pUser);


/************************************************************************
* 接口定义
************************************************************************/
#ifdef __cplusplus
extern "C" {
#endif

/************************************************************************
* 函数名：SYSTRANS_Create                                                  
* 功能：  通过源和目标的封装类型来创建封装格式转换句柄
* 参数：  phTrans            返回的句柄
*         pstTransInfo       转换信息数据指针
* 返回值：状态码
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_Create(void** phTrans, SYS_TRANS_PARA* pstTransInfo);

/************************************************************************
* 函数名：SYSTRANS_Start                                                 
* 功能：  开始封装格式转换
* 参数：  hTrans             转换句柄
*         szSrcPath          源文件路径，如果置NULL，表明为流
*         szTgtPath          目标文件路径，如果置NULL，表明为流
* 返回值：状态码
* 说明：  源文件为TS不支持文件模式，可由外部读文件以流的模式输入
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_Start(void* hTrans, const char* szSrcPath, const char* szTgtPath);

/************************************************************************
* 函数名：SYSTRANS_AutoSwitch                                                 
* 功能：  目标为文件时，自动切换存储文件
* 参数：  hTrans             转换句柄
*         pstPara            自动切换文件的参数结构指针
* 返回值：状态码 
* 说明：  仅支持设置一次，设置多次返回不支持
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_AutoSwitch(void* hTrans, AUTO_SWITCH_PARA* pstPara);

/************************************************************************
* 函数名：SYSTRANS_ManualSwitch                                                 
* 功能：  目标为文件时，手动切换存储文件
* 参数：  hTrans             转换句柄
*         szTgtPath          下一存储文件的路径
* 返回值：状态码 
* 说明：  只支持目标格式为PS、TS、AVI，其余封装格式暂不支持
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_ManualSwitch(void* hTrans, const char* szTgtPath);

/************************************************************************
* 函数名：SYSTRANS_InputData                                                 
* 功能：  源为流模式，输入数据
* 参数：  hTrans             转换句柄
*         enType             码流类型，参考DATA_TYPE枚举
*         pData              源数据指针
*         dwDataLen          流数据大小
* 返回值：状态码
* 说明：  配置原则：
          1. 码流转换场景：enType设为MULTI_DATA，pData赋值为码流数据指针，dwDataLen设置为数据长度
          2. 裸数据打包场景：
          a）打包视频帧
            [1] 设置参数：enType设为VIDEO_PARA（或VIDEO_PARA_EX），pData赋值为HK_VIDEO_PACK_PARA（或HK_VIDEO_PACK_PARA_EX）结构体地址，dwDataLen设置为结构体大小
            [2] 输入帧数据：enType设为VIDEO_DATA，pData赋值为帧数据指针，dwDataLen设置为帧数据长度
          b）打包音频帧
            [1] 设置参数：enType设为AUDIO_PARA，pData赋值为 HK_AUDIO_PACK_PARA结构体地址，dwDataLen设置为结构体大小
            [2] 输入帧数据：enType设为AUDIO_DATA，pData赋值为帧数据指针，dwDataLen设置为帧数据长度
          c）打包私有帧：接口暂不支持
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_InputData(void* hTrans, DATA_TYPE enType, unsigned char* pData, unsigned int dwDataLen);

/************************************************************************
* 函数名：SYSTRANS_GetTransPercent                                                 
* 功能：  转文件模式时，获得转换百分比
* 参数：  hTrans             转换句柄
*         pdwPercent         转换百分比
* 返回值：状态码
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_GetTransPercent(void* hTrans, unsigned int* pdwPercent);

/************************************************************************
* 函数名：SYSTRANS_RegisterOutputDataCallBack                                                 
* 功能：  目标为流模式，注册转换后数据回调.暂不支持fMP4分片
* 参数：  hTrans                 转换句柄
*         OutputDataCallBack     函数指针
*         dwUser                 用户数据
* 返回值：状态码
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_RegisterOutputDataCallBack(void* hTrans, SYSTRANSOutputDataCb pfnOutputDataCallBack, void* pUser);

/************************************************************************
* 函数名：SYSTRANS_RegisterOutputDataCallBackEx                                                 
* 功能：  目标为流模式，注册转换后数据回调
* 参数：  hTrans                 转换句柄
*         OutputDataCallBack     函数指针
*         dwUser                 用户数据
* 返回值：状态码
* 说明：  该接口只为兼容老版本2.1.x（svn：5063，实际上与SYSTRANS_RegisterOutputDataCallBack没区别）
*         非特殊情况，调用请以SYSTRANS_RegisterOutputDataCallBack接口为准
*         后续考虑从接口头文件转移到内部头文件，不再以明接口的形式对外提供
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_RegisterOutputDataCallBackEx(void* hTrans, SYSTRANSOutputDataCb pfnOutputDataCallBack, void* pUser);

/************************************************************************
* 函数名：SYSTRANS_RegisterDetailDataCallBack
* 功能：  目标为流模式，注册转换后数据回调
* 参数：  hTrans             转换句柄
*         pfnDetailCbf       函数指针
*         dwUser             用户数据
* 返回值：状态码
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_RegisterDetailDataCallBack(void* hTrans, SYSTRANSDetailDataCb pfnDetailCbf, void* pUser);

/************************************************************************
* 函数名：SYSTRANS_Stop
* 功能：  停止转换
* 参数：  hTrans             转换句柄
* 返回值：状态码
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_Stop(void* hTrans);

/************************************************************************
* 函数名：SYSTRANS_Release                                                 
* 功能：  释放转换句柄
* 参数：  hTrans             转换句柄
* 返回值：状态码
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_Release(void* hTrans);

/************************************************************************
* 函数名：SYSTRANS_CreateEx                                              
* 功能：  SDP信息创建转封装库句柄
* 参数：  hTrans             转换句柄
*         eType              协议类型
*         pstInfo            转封装会话参数
* 返回值：状态码
* 说明：  该接口是SYSTRANS_Create的扩展，增加对使用SDP信息创建句柄的支持，该sdp开流模式只支持源为RTP封装的码流
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_CreateEx(void** phTrans, ST_PROTOCOL_TYPE eType, ST_SESSION_PARA* pstInfo);

/************************************************************************
* 函数名：SYSTRANS_SetGlobalTime                                              
* 功能：  设置全局时间 
* 参数：  hTrans             转换句柄
*         pstGlobalTime      全局时间 
* 返回值：状态码
* 说明：  源码流中有海康私有描述子，且携带全局时间，则以源码流中全局时间为准，设置会无效
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_SetGlobalTime(void* hTrans, HK_SYSTEM_TIME* pstGlobalTime);

/************************************************************************
* 函数名：SYSTRANS_SetEncryptKey                                              
* 功能：  设置密钥
* 参数：  hTrans             转换句柄
*         eType              加密类型
*         pKey               密钥缓冲区
*         nKeyLen            密钥长度，单位为Bit
* 返回值：状态码
* 说明：  1、加解密目前支持的封装为RTP、PS，新加密方案仅支持H264和H265，老加密方案支持MPEG2、MJPEG、H264、H265
          2、支持只解密、只加密 和 先解密后加密的组合功能，不支持先解密后加密
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_SetEncryptKey(void* hTrans, ST_ENCRYPT_TYPE eType, char* pKey,  unsigned int nKeyLen);

/************************************************************************
* 函数名：SYSTRANS_GetVersion                                                 
* 功能：  获取版本号
* 参数：  无
* 返回值：版本号
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_GetVersion();

/************************************************************************
* 函数名：SYSTRANS_OpenStreamAdvanced                                              
* 功能：  SDP信息创建转封装库句柄,用于兼容之前定制版本
* 参数：  hTrans             转换句柄
*         nProtocolType      协议类型
*         pstSessionInfo     SDP信息
*         pstTransInfo       转换信息数据指针
* 返回值：状态码
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_OpenStreamAdvanced(void** phTrans, int nProtocolType, SYS_TRANS_SESSION_PARA* pstTransSessionInfo);

/************************************************************************
* 函数名：SYSTRANS_RegisterStreamInforCB
* 功能：  码流错误信息回调
* 参数：  hTrans             转换句柄
*         pfnErrorInfoCB     回调函数
*         pErrorInfo         回调错误信息
*         pUser              用户指针
* 返回值：状态码
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_RegisterStreamInforCB(void* hTrans, SYSTRANSErrorInfoCb pfnErrorInfoCB, void* pUser);

/************************************************************************
* 函数名：SYSTRANS_SkipErrorData
* 功能：  是否解析错误数据
* 参数：  hTrans             转换句柄
*         nSkipFlag          跳过标记：1表示内部错误数据不解析，0表示错误数据不跳过
* 返回值：状态码
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_SkipErrorData(void* hTrans, int nSkipFlag);

/************************************************************************
* 函数名：SYSTRANS_ModifyMediaField
* 功能：  修改媒体字段
* 参数：  hTrans             转换句柄
*         nType              媒体字段的修改类型
*         fValue             修改数值
* 返回值：状态码
* 说明：  1、目前起始帧号修改，时间戳间隔倍速修改，只支持其他格式转ps时实现。
          2、时间戳起始值修改，只支持RTP转ps时，该修改可用于音视频时间戳对齐。
          3、fValue只在修改时间戳间隔倍速时使用小数,其余类型应使用整数。时间戳间隔倍速修改范围在(0.0625~16)
          4、时间戳固定间隔修改暂不支持。
          5、帧号为海康私有定义，为无符号整型内部占4字节大小，最大值占满4字节，溢出自动翻转为0。
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_ModifyMediaField(void* hTrans, ST_MODIFY_TYPE nType, float fValue);

/************************************************************************
* 函数名：SYSTRANS_RegisterLogCallBack                                             
* 功能：  注册日志输出回调
* 参数：  pfnCallback   回调函数指针
*         pUser         用户参数
* 返回值：状态码
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_RegisterLogCallBack(SYSTRANSLogCb pfnCallback, void* pUser);

/************************************************************************
* 函数名：SYSTRANS_RegisterModifyGlobalTimeCallBack                                             
* 功能：  注册码流全局时间修改回调
* 参数：  hTrans            转换句柄
*         pfnCallback       回调函数指针
*         pUser             用户指针
* 返回值：状态码
* 说明：  仅适用于输出ps封装时
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_RegisterModifyGlobalTimeCallBack(void* hTrans, SYSTRANSGlobalTimeCb pfnCallback, void* pUser);

/************************************************************************
* 函数名：SYSTRANS_NoPack
* 功能：  转封装不重打包功能
* 参数：  hTrans         转换句柄
*         nFlag          标记：1表示不重打，0表示重打，默认重打
* 返回值：状态码
* 说明：  需在SYSTRANS_Start之前调用,目前只支持ps转ps和流式输出
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_NoPack(void* hTrans, int nFlag);

/************************************************************************
* 函数名：SYSTRANS_RegisterPackInfoCallBack                                             
* 功能：  打包信息修改回调
* 参数：  hTrans        转换句柄
*         pfnCallback   回调函数指针
*         pUser         用户指针
* 返回值：状态码
* 说明：  
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_RegisterPackInfoCallBack(void* hTrans, SYSTRANSPackInfoCb pfnCallback, void* pUser);

/************************************************************************
* 函数名：SYSTRANS_ResetPackInfo
* 功能：  打包信息重置修改
* 参数：  hTrans             转换句柄
*         pPackInitInfo      打包初始信息
* 返回值：状态码
* 说明：  支持 时间戳 和 全局时间戳的重置。多轨流暂不支持。
          该时间戳调整的策略是，前跳都会调整后一帧时间戳，后跳一超过一定阀值时可调整。
          阈值可设置，内部后跳调整阈值=时间戳间隔 + 外部设置阈值nValue
          例如，前一帧时间戳为 200 后一帧时间戳为 400，外部设置阈值nValue为100，时间戳间隔为40，此时满足（400-200）大于（100+40），表示出现异常后跳，后一帧时间戳会调整为200 + 40 = 240。
          后续帧时间戳依次前移400 - 240 = 160。该内部时间戳调整不影响原有时间戳正常间隔。
          全局时间间隔依赖于调整后的时间戳间隔。
          不支持B帧设置时间戳重排；不支持同时调用多个接口设置全局时间。
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_ResetPackInfo(void* hTrans, ST_PACK_INIT_INFO* pPackInitInfo);

/************************************************************************
* 函数名：SYSTRANS_SreamEnd                                                 
* 功能：  源为PS流模式，推出可能的最后一帧数据，清空缓存
* 参数：  hTrans        转换句柄
*	      nEndFlag      流结束标记
* 返回值：状态码
************************************************************************/ 
SYSTRANS_API int __stdcall SYSTRANS_StreamEnd(void* hTrans, unsigned int nEndFlag);

/************************************************************************
* 函数名：SYSTRANS_EnableCapacity                                                 
* 功能：  开启指定的功能
* 参数：  hTrans            转换句柄
*	      pstCapacityInfo   存储开启功能信息的结构体
* 返回值：状态码
************************************************************************/ 
SYSTRANS_API int __stdcall SYSTRANS_EnableCapacity(void* hTrans, ST_CAPACITY_INFO * pstCapacityInfo);

/************************************************************************
* 函数名：SYSTRANS_RegisterErrDetailCallBack                                                 
* 功能：  注册错误码详情回调
* 参数：  hTrans        转换句柄
*         pfnCallback   回调指针
*	      pUser         用户指针
* 返回值：状态码
* 说明：  1.暂只支持文件模式下透传内部错误码（与流模式SYSTRANS_InputData接口返回的错误码保持一致）
          2.请在SYSTRANS_Create之后、SYSTRANS_Start之前调用
************************************************************************/ 
SYSTRANS_API int __stdcall SYSTRANS_RegisterErrDetailCallBack(void* hTrans, SYSTRANSErrDetailCb pfnCallback, void *pUser);

/************************************************************************
* 函数名：SYSTRANS_Config                                                 
* 功能：  开启指定的功能
* 备注    ffmpeg只支持无头探测开流
* 参数：  hTrans        转换句柄
*	      pstConfig     配置结构
* 返回值：状态码
* 说明：  MP4流式解析只能使用海康模式
************************************************************************/ 
SYSTRANS_API int __stdcall SYSTRANS_Config(void* hTrans, ST_CONFIG* pstConfig);

/************************************************************************
* 函数名：SYSTRANS_ClearBuffer   
* 功能：  清空缓存接口
* 参数：  hTrans        转换句柄
* 返回值：状态码
* 说明：  一般定位时调用此接口，清除内部缓存。流式支持
************************************************************************/ 
SYSTRANS_API int __stdcall SYSTRANS_ClearBuffer(void* hTrans);

/************************************************************************
* 函数名：SYSTRANS_SeekEx                                                 
* 功能：  定位接口
* 参数：  hTrans        转换句柄
*         pstSeekInfo   定位参数
* 返回值：状态码
* 说明：  注意，该接口目前仅支持流式解析过程中调用，且必须在数据回调触发后方可调用，否则调用无效；
*         仅支持MP4按照帧号或者时间戳定位，其他封装格式定位会报不支持错误；
*         MP4码流，n帧定位范围应该是0—(n-1)
*         该接口的调用前提是提前知道总帧数或总时长，可以通过例如SYSTRANS_FileInspect或帧分析、文件操作库等获得
************************************************************************/ 
SYSTRANS_API int __stdcall SYSTRANS_SeekEx(void* hTrans, ST_SEEK_INFO* pstSeekInfo);

/************************************************************************
* 函数名：SYSTRANS_SysFmtInspect      
* 功能：  预探测接口
* 参数：  hTrans        转换句柄
*         pData         源数据指针
*         dwDataLen     流数据大小
*         pstFmtInfo    探测格式信息
* 返回值：状态码
* 说明：  目前仅使用于MP4的流式探测，用于探测是否是MP4，MP4前置后置索引以及索引的偏移位置
************************************************************************/ 
SYSTRANS_API int __stdcall SYSTRANS_SysFmtInspect (void* hTrans, unsigned char* pData, unsigned int dwDataLen, ST_FMT_PARAM* pstFmtInfo);

/***********************************************************************
* 函数名：SYSTRANS_FileInspect
* 参数：  szSrcPath     待探测的文件路径
*         pMediaInfo    媒体信息
*         pBuf          供内部使用的缓存
*         dwLen         缓存地址长度，至少设置1M
* 返回值：状态码
* 说明：  对于视频总时长和总帧数的探测，目前只有AVI和MP4才支持，其他封装不支持;目前对于FLV探测只支持探测编码
          目前AVI音频总时长探测可能出现不准的情况
************************************************************************/
SYSTRANS_API long __stdcall SYSTRANS_FileInspect(const char* szSrcPath, ST_MEDIA_INSPEC_INFO* pMediaInfo, unsigned char* pBuf, unsigned int dwLen);

/***********************************************************************
* 函数名：SYSTRANS_InputPrivateData
* 功能：  输入私有数据进行打包
* 参数：  hTrans        转换句柄
*         nPrivateType  私有数据类型
*         nTimeStamp    私有数据时间戳
*         pData         私有数据指针
*         nDataLen      私有数据长度
* 返回值：状态码
************************************************************************/
SYSTRANS_API int __stdcall SYSTRANS_InputPrivateData(void* hTrans, unsigned int nPrivateType, unsigned int nTimeStamp, unsigned char* pData, unsigned int nDataLen);

#ifdef __cplusplus
    }
#endif

#endif //_SYSTEM_TRANSFORM_H_
