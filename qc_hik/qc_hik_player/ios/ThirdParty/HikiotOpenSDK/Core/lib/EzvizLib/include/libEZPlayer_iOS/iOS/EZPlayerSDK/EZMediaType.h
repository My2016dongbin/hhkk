//
// Created by yudan on 2018/11/1.
//

#ifndef SDK_EZMEDIATYPE_H
#define SDK_EZMEDIATYPE_H


/**
 * 来自上层的业务回调定义集合
 */
typedef struct _EZ_ONEZVIZ_LISTENER{
    void *additionalCB;  // 云台回调
}EZ_ONEZVIZ_LISTENER;

/**
	* 播放器错误上报类型
	*/
typedef enum _MediaError {
    /**
    * 未知错误
    */
            MEDIA_ERROR_UNKNOWN,
    /**
    * 无效token,请更新token后重试
    */
            MEDIA_ERROR_INVALID_TOKEN,
    /**
    * 内存不足
    */
            MEDIA_ERROR_OUTOF_MEMORY,
    /**
     * 没传入设备密钥或密钥错误
     */
            MEDIA_ERROR_SECRET_KEY,
    /**
     * 播放超时
     */
            MEDIA_ERROR_TIMEOUT,
    /**
     * 未传入surface
     */
            MEDIA_ERROR_NO_SURFACE,

}MediaError;

/**
* 播放器消息上报类型
*/
typedef enum _MediaInfo {
    /**
    * 视频分辨率更新，请调整渲染窗口
    */
    MEDIA_INFO_VIDEO_SIZE_CHANGED,
    /**
    * token池中token不足,请尽快传入更多的token
    */
    MEDIA_INFO_NEED_TOKENS,

    /**
     * 取流方式切换到内网直连模式
     */
    MEDIA_INFO_SWITCH_TO_DIRECT_INNER,
    /**
     * 取流方式切换到外网直连模式
     */
    MEDIA_INFO_SWITCH_TO_DIRECT_OUTER,
    /**
     * 取流方式切换到P2P模式
     */
    MEDIA_INFO_SWITCH_TO_P2P,
    /**
     * 取流方式切换到私有流媒体转发模式
     */
    MEDIA_INFO_SWITCH_TO_PRIVATE_STREAM,
    /**
     * 取流方式切换到反向直连模式
     */
    MEDIA_INFO_SWITCH_TO_DIRECT_REVERSE,
    /**
     * 播放库已创建
     */
    MEDIA_INFO_PLAY_PREPARED,
    /**
     * 播放正在重试
     */
    MEDIA_INFO_RETRY_PLAYING,
    /**
     * 播放开始，用于通知上层首次播放成功或者内部重试成功
     */
    MEDIA_INFO_START_PLAYING,
    /**
     * 播放结束，用于若干种回放的回调
     */
    MEDIA_INFO_PLAYING_FINISH,
    /**
     * 云存储快放时，由全帧快放切换到抽帧快放的提示回调
     */
    MEDIA_INFO_CLOUD_IFRAME_CHANGE,
    /**
    * 快放时，服务器返回的降低快放倍速消息
    */
    MEDIA_INFO_CLOUD_LOWER_PLAY_SPEED,
    /**
    * 取流方式切换到蚁兵转发模式
    */
    MEDIA_INFO_SWITCH_TO_PROXY,

    /**
    * 播放过程中，因为流畅，可提升清晰度
    */
    MEDIA_INFO_AUTO_IMPROVE_DEFINITION,

    /**
    * 播放过程中，因为卡顿，需要降低清晰度
    */
    MEDIA_INFO_AUTO_REDUCE_DEFINITION,

    /**
    * 检测到啸叫存在
    */
    MEDIA_INFO_HOWLING_EXIST,

    /**
    * 多轨码流播放过程中，检测到轨数变化，通知到上层用于窗口控制, 回调二进制参数，按位表示轨道状态
    */
    MEDIA_INFO_STREAM_COUNT_CHANGED,

}MediaInfo;



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
}EZ_FRAME_INFO;

typedef struct //绝对时间
{
    unsigned int dwYear;   //年
    unsigned int dwMon;    //月
    unsigned int dwDay;    //日
    unsigned int dwHour;   //时
    unsigned int dwMin;    //分
    unsigned int dwSec;    //秒
    unsigned int dwMs;     //毫秒
}EZ_PLAYM4_SYSTEM_TIME;


typedef enum : unsigned int{
    EZ_STREAM_TRACK_NA = 0,
    EZ_STREAM_TRACK_0 = 1 << 0,
    EZ_STREAM_TRACK_1 = 1 << 1,
    EZ_STREAM_TRACK_2 = 1 << 2,
} EZ_STREAM_TRACK_ID;

/** 原始流回调 */
typedef void ( * onDataCallback)(int dataType, char* pData, int iLen, void *pUser);

/** ERROR消息回调 */
typedef void ( * onErrorCallback)(MediaError errorType, int64_t errorCode, void *pUser);

/** INFO消息回调 */
typedef void ( * onInfoCallback)(MediaInfo infoType, int param, void *pUser);

/** 卡顿消息回调 */
typedef void ( * onDelayCallback)(int delayTime, void *pUser);

/** 解码数据回调 */
typedef void ( *onDecodeCallback)(char *pBuf, int nSize, EZ_FRAME_INFO *pFrameInfo, EZ_PLAYM4_SYSTEM_TIME *pstSystemTime, void *pUser);

/** 显示数据回调，用于红外检测 */
typedef void ( * onDisplayCallback)(char* data, int nDataLen, int nWidth, int nHeight, void *pUser);

/** 私有数据回调，用户云台等 */
typedef void ( * onEZInfoCallback)(int nType, int nStrVersion, int nLength, char* data, EZ_STREAM_TRACK_ID streamIds, void *pUser);


typedef enum _EZ_PLAYER_STATE {
    EZ_NONE_STATE               = 0,
    EZ_READY_STATE              = 1,
    EZ_WAIT_HEADER_STATE        = 2,
    EZ_WAIT_DATA_STATE          = 3,
    EZ_WAIT_DECODE_STATE        = 4,
    EZ_PLAYING_STATE            = 5,
    EZ_PAUSE_STATE              = 6,
    EZ_WILL_STOP_STATE          = 7,
    EZ_STOPED_STATE             = 8,
}EZ_PLAYER_STATE;

/**
 * osd时间定义
 */
typedef struct _EZOSDTime {
    int year;   //年
    int month;    //月
    int day;    //日
    int hour;   //时
    int min;    //分
    int sec;    //秒
    int ms;     //毫秒
}EZOSDTime;

/**
 * 播放窗口region定义
 */
typedef struct _EZRegionRect {
    unsigned long nLeft;
    unsigned long nTop;
    unsigned long nRight;
    unsigned long nBottom;
}EZRegionRect;


/**
 * 卡顿比定义
 */
typedef struct _EZStreamDelayInfo {
    int64_t displayTimeStamp        = 0;       // 画面显示时的时间戳

    int64_t delaySlight             = 0;            // 轻微卡顿时长，定义：连续150ms~300ms卡顿
    int64_t delayMiddle             = 0;            // 中等卡顿时长，定义：连续300ms~1000ms卡顿
    int64_t delaySerious            = 0;           // 严重卡顿时长，定义：连续1s以上的卡顿

    int32_t delayCalculated         = 0;           //是否已经计算过卡顿比

    int64_t lastDisplayCBTime       = 0;      // 上次显示回调的时间点
    int64_t lastOnDelayTime         = 0;        // 用于计算严重卡顿时每隔1s向上层抛出一个事件

    int64_t delaySlightCount        = 0;        //轻度卡顿次数
    int64_t delayMiddleCount        = 0;        //中度卡顿次数
    int64_t delaySeriousCount       = 0;        //重度卡顿次数

}EZ_STREAMDELAY_INFO;

//--------------------安装类型，枚举值必须和播放库中定义一致--------------------

typedef enum {
    EZFECPlaceType_None         = 0x0,        // 不矫正
    EZFECPlaceType_Wall         = 0x1,        // 壁装方式  (法线水平)
    EZFECPlaceType_Floor        = 0x2,        // 地面安装  (法线向上)
    EZFECPlaceType_Ceiling      = 0x3,        // 顶装方式  (法线向下)
}EZFECPlaceType;
//--------------------安装类型，枚举值必须和播放库中定义一致--------------------

//--------------------矫正类型，枚举值必须和播放库中定义一致--------------------
typedef enum {
    EZFECCorrectType_None           = 0x000,        // None
    EZFECCorrectType_PTZ            = 0x100,        // PTZ
    EZFECCorrectType_PTZ_SECTOR     = 0x101,        // PTZ扇形形式
    EZFECCorrectType_180            = 0x200,        // 180度矫正  （对应2P）
    EZFECCorrectType_360            = 0x300,        // 360全景矫正 （对应1P）（1280*1280矫正后尺寸5024*706）
    EZFECCorrectType_LAT            = 0x400,         // 维度拉伸
    EZFECCorrectType_SEM            = 0x500,        // 半球显示
    EZFECCorrectType_CYC            = 0x600,        // 圆柱显示（桶形）
    EZFECCorrectType_PLA            = 0x700,        // 小行星
    EZFECCorrectType_CYC_SPL        = 0x800,        // 圆柱显示（剪开）
    EZFECCorrectType_ARC            = 0x900,        //壁装弧面，仅适用于壁装的180°相机
    EZFECCorrectType_ARC_VERTICAL   = 0xA00,  //垂直壁装弧面
    EZFECCorrectType_PANOSPHERE     = 0xB00,        // 全景球体
    EZFECCorrectType_Original       = 0xC00,  // 原图，原图上可以展示PTZ的框线

}EZFECCorrectType;
//--------------------矫正类型，枚举值必须和播放库中定义一致--------------------

typedef enum {
    EZFECPTZOUTLINENULL,   // 不显示
    EZFECPTZOUTLINERECT,   // 矩形显示
    EZFECPTZOUTLINERANGE,  // 真实区域显示
}EZFECSHOWMODE;

typedef struct
{
    float x;     // PTZ 显示的中心位置 X坐标
    float y;     // PTZ 显示的中心位置 Y坐标
}EZPTZParam;



typedef struct _tagEZFECTransformElement
{
    float fAxisX;
    float fAxisY;
    float fAxisZ;
    float fValue;
}EZFECTransformElement;

typedef struct _tagEZFECCYCLE_PARAM{
    float radiusLeft;
    float radiusRight;
    float radiusTop;
    float radiusBottom;
}EZFECCYCLE_PARAM;

typedef struct tagEZFECFISHEYE_PARAM
{
    int    updateType;            // 更新的类型
    int    placeAndCorrect;       // 安装方式和矫正方式，只能用于获取，SetParam的时候无效,该值表示安装方式和矫正方式的和
    EZPTZParam        ptzParam;             // PTZ 校正的参数
    EZFECCYCLE_PARAM      cycleParam;           // 鱼眼图像圆心参数
    float           zoom;                  // PTZ 显示的范围参数
    float           wideScanOffset;        // 180或者360度校正的偏移角度
}EZFECFISHEYE_PARAM;


//---------------------JNI用户回调参数 -----------------
typedef struct _EZMediaJNIUserData {
    void * pMediaUserData = nullptr;    // 普通取流jni回调
    void * pFecUserData = nullptr;      // 鱼眼播放jni回调
    void * pDataUserData = nullptr;     // 流数据jni回调
    void * pDisplayUserData = nullptr;  // 显示回调jni回调
    void * pEZInfoUserData = nullptr;// 私有回调jni回调
}EZMediaJNIUserData;


#endif //SDK_EZMEDIATYPE_H
