//
//  EZPlayerSDK.h
//  libezstreamclient
//
//  Created by kanhaiping on 2019/4/19.
//  Copyright © 2019年 linyong. All rights reserved.
//

#ifndef EZPlayerSDK_h
#define EZPlayerSDK_h

#include "EZStreamTypes.h"
#include "EZMediaType.h"

//************************************************************************************************************
//      以下是3.0.0 新增的播放接口
//************************************************************************************************************

//************************************************全局接口************************************************

//---------------------------ECDH 全链路加密相关接口---------------------------------------------------------------------
/*
 0.APP通过ezplayer_generateECDHKey生成客户端的public key  和 private key，并缓存到本地，并每隔三个月重新生成更新掉，
 1.APP启动时从缓存或者从通用库调用接口生成客户端的public key  和 private key 通过ezplayer_setClientECDHKey设置进通用库
 3.APP从平台拿到VTDU/VTM服务的public key以及keyVer版本号，然后向通用库的参数中，传入public key以及keyVer版本号，注意base64解密
 4.APP从平台拿到设备的回放的全链路加密能力集，向通用库的参数中，传入iPlayBackLinkEncrypt
 5.注意所有的key都不是字符串，不能当成字符串处理，需要当成一串二进制数据
 */


/**
 ECDH 公私钥生成接口 APP通过该接口生成公私钥，并缓存到本地，每次APP启动后，通过ezplayer_setClientECDHKey接口设置进通用库
 函数需要的内存需要外部分配，长度至少128个字节

 @param usPBKey 公钥
 @param pPBLen 实际的公钥长度
 @param usPRKey 私钥
 @param pPRLen 实际的私钥长度
 @return 成功返回0
 */
int ezplayer_generateECDHKey(unsigned char* usPBKey, unsigned int* pPBLen, unsigned char* usPRKey, unsigned int* pPRLen);

//设置客户端的公私秘钥，
void ezplayer_setClientECDHKey(unsigned char* selfPublicKey, unsigned int selfPublicKeyLen,
                               unsigned char* selfPrivateKey,unsigned int selfPrivateKeyLen);
//----------------------------ECDH 全链路加密相关接口--------------------------------------------------------------------


//************************************************全局接口************************************************
//主要接口
void* ezplayer_createPreviewMedia(INIT_PARAM * initParam);

void* ezplayer_createPreviewMedia(const string& szUrl);

void* ezplayer_createPlaybackMedia(INIT_PARAM * initParam);

void* ezplayer_createCloudMedia(INIT_PARAM * initParam);

void* ezplayer_createPlaybackMediaEx(INIT_PARAM * initParam);

void* ezplayer_createCloudMediaEx(const ez_stream_sdk::CloudStreamReqBasicInfo &info);

void* ezplayer_createRecordMedia(DOWNLOAD_CLOUD_PARAM * initParam);

void* ezplayer_createLocalPlayMedia(const string& szFile);

void* ezplayer_createNetProtocolMedia(const ez_stream_sdk::NPStreamParam& param);

void* ezplayer_createEzLinkMedia(INIT_PARAM * initParam);

void ezplayer_setStreamCount(void* hMedia, uint32_t streamCount);

//设置播放窗口接口，如果是iOS调用，传入非空窗口要在主线程；传入NULL可以在非主线程；iOS第三个参数不需要传入，7.4.0版本不再需要第三个参数
void ezplayer_setDisplayWindows(void* hMedia, void* displayView, unsigned int streamId = 0);

int ezplayer_setAssistantDisplayWindows(void* hMedia, void* displayView, unsigned int nRegionNum);

void ezplayer_setSecretKey(void* hMedia, string szSecretKey);

void ezplayer_setPlayCategoryMode(void *hMedia, bool enableVOIP);

void ezplayer_setDataCallback(void* hMedia, onDataCallback dataCallback, void* pUser);

void ezplayer_setMessageCallback(void* hMedia, onErrorCallback errorCallback, onInfoCallback infoCallback, onDelayCallback delayCallback, void* pUser);

void ezplayer_setDisplayCallback(void* hMedia, onDisplayCallback displayback, void* pUser);

void ezplayer_setEZInfoCallback(void *hMedia, onEZInfoCallback ezInfoCB, void *pUser);

void ezplayer_enableAutoDefinitionDetect(void *hMedia);

///自动清晰度参数设置 依次为 reduce_slight, reduce_middle, reduce_serious, improve_slight, improve_middle, improve_serious
void ezplayer_setAutoDefinitionDetectParam(void *hMedia, int* autoParam, int paramLen);

ez_stream_sdk::AutoDefReportParam* ezplayer_getAutoDefReportParam(void *hMedia);

void ezplayer_start(void* hMedia);

void ezplayer_stop(void* hMedia);

void ezplayer_destroyMedia(void* hMedia);


/// 停止内部的播放器，但不停止内部的取流，调用该接口后，本次取流播放将无法正常播放，后续只能调用stop释放资源。
/// - Parameter hMedia: 参数
void ezplayer_stopOnlyPlayer(void* hMedia);

/// 打开播放的声音接口，当前内部默认由播放库控制category
/// 播放库默认为playback，如果外部调用了ezplayer_setPlayCategoryMode接口并置为true，则模式修改为playadnrecord
/// 当前 ezplayer_setPlayCategoryMode 接口提供给开放平台国标设备使用（对讲是采用播放库进行播放、对讲库进行采集）
/// 萤石云当前采用默认模式，后续可考虑采用禁止播放库配置音频路由并由外部控制音频路由的模式（参考视频通话SDK）以解决预览和对讲切换模式的问题
/// - Parameters:
///   - hMedia: handle
///   - openFlag: 是否打开声音
int ezplayer_soundCtrl(void* hMedia, int openFlag);

int ezplayer_capture(void* hMedia, string strFilePath, unsigned int streamId = 0);

int ezplayer_capture(void* hMedia, void **ppOutData, unsigned int *pOutDatalength, unsigned int streamId = 0);

/**
 * 开始录制（通过播放库）录制中再开启则会失败
 * @param hMedia
 * @param filePath
 * @param recordFlag 针对双目流，0-streamId0， 1-streamId1，若想同时录制，直接传-1
 * @return
 */
int ezplayer_startRecord(void* hMedia, string filePath, int recordFlag = 0);

void ezplayer_stopRecord(void* hMedia, int recordFlag = 0);

void ezplayer_setHard(void* hMedia, bool isHard, bool forceHard = false);


//播放信息获取
int ezplayer_getOsdTime(void* hMedia, EZOSDTime& osdTime);

//设置基准时间，用于无全局时间戳的码流getOsdTime，针对文件回放，建议在start之前调用，否则前几帧可能无法获取
//针对流式播放，可在prepared之后调用，可以统一在start前调用
int ezplayer_setGlobalBaseTime(void* hMedia, EZOSDTime osdTime);

int ezplayer_getVideoWidth(void* hMedia, unsigned int streamId = 0);

int ezplayer_getVideoHeight(void* hMedia, unsigned int streamId = 0);

CLIENT_TYPES ezplayer_getMediaClientType(void* hMedia);

int64_t ezplayer_getStreamFlow(void* hMedia);

int ezplayer_getStatisticsObject(void* hMedia, void **object);

string ezplayer_getRootStatisticsJson(void* hMedia);

std::vector<string> ezplayer_getSubStatisticsJson(void* hMedia);

string ezplayer_getUUID(void* hMedia);

int ezplayer_getInnerPort(void* hMedia);

//回放、云存储回放相关接口

void ezplayer_startPlayback(void *hMedia, const ez_stream_sdk::VideoStreamInfoList &videos);

int ezplayer_pause(void* hMedia);

int ezplayer_resume(void* hMedia);

bool ezplayer_isPlaybackPaused(void* hMedia);


/// 设置倍速接口
/// - Parameters:
///   - hMedia: handle
///   - rate: 目标倍速
///   - fastPlayMode: 云存储的倍速模式设置参数
///   - is_record_high_speed_frame_extraction: 高倍速回放是否抽帧参数，默认为true，云存储录像和SD卡普通录像均为高倍速抽帧模式
int ezplayer_setRate(void* hMedia, EZ_PLAY_BACK_RATE rate, EZ_FAST_PLAY_MODE fastPlayMode, bool is_record_high_speed_frame_extraction = true);

int ezplayer_seekCloud(void* hMedia, const string& seekTime);


/// 云存储和SD卡seek接口
/// - Parameters:
///   - hMedia: handle
///   - videos: 录像组
///   - is_new_seek_mode: 是否采用新模式的seek，默认为0，1表示采用新协议的seek
int ezplayer_seek(void *hMedia, const ez_stream_sdk::VideoStreamInfoList &videos, int is_new_seek_mode = 0);

int ezplayer_continue(void *hMedia, const ez_stream_sdk::VideoStreamInfoList &videos);

void ezplayer_setMediaPlaybackConvert(void* hMedia, int videoBitrate, int resolution, int videoFrameRate);

//获取HCNetSDK取流时的内部句柄的接口，仅HCNetSDK回放可获取
int ezplayer_getHCNetSDKPlaybackHandle(void* hMedia);

//单流多track相关接口
/// 打开单流多track 播放功能（萤石、海康的自研的单流多track格式的PS）
/// 此功能需要外部明确知晓码流是 【单流多画面/track】的码流，然后打开支持；如果实际码流是单流单画面，则可能报错
/// 同时，SDK内部会check接收的码流的流头，是否满足((media_version>=0x0104 && flag == 0x86) || (media_version>=0x0104 && flag == 0x87))，如果不满足，则内部依然以单流形式处理
/// @param hMedia handle
void ezplayer_enableMultiTrack(void *hMedia);


//其他相关接口
int ezplayer_setDisplayRegion(void* hMedia, const EZRegionRect *regionRect, unsigned int nRegionNum, void *displayView, unsigned int nStreamId = 0);

bool ezplayer_isRecording(void* hMedia);

bool ezplayer_isPlaying(void* hMedia);

bool ezplayer_isHard(void* hMedia);

int ezplayer_getSourceBufferRemain(void* hMedia);

int ezplayer_setHSParam(void* hMedia, bool enable, int iNotch, int iTime);


/// 设置算法模型路径
/// @param model 模型路径
int ezplayer_set3AModelPath(void* hMedia, const string &model, const string &debugDir="");
/**
 * 设置预览啸叫抑制策略-萤石算法，(需要编译宏EZ_HOWLING_DETECT打开才生效）
 * 使用时必须同时调用ezplayer_set3AModelPath
 * 仅支持16K采样率的音频处理，如果实际码流是其他采样率则不生效，
 * 在start前调用生效
 * @param hMedia
 * @param enable false-不使能（默认） true-使能
 * @return
 */
int ezplayer_enableNoiseSupress(void* hMedia, int enable);



/// 设置啸叫检测使能，内部使用萤石自研算法，(需要编译宏EZ_HOWLING_DETECT打开才生效）
/// 仅支持对16K采样率的音频进行检测，如果实际码流是其他采样率则不生效，
/// 仅在start前调用生效
/// @param hMedia handle
/// @param enable 是否打开
int ezplayer_enableHowlingDetect(void *hMedia, int enable);

//智能分析数据开关，包括人形检测、温感相机的框框，在播放过程中随时开关
int ezplayer_setIntelData(void* hMedia, int enable);

//设置广角鱼眼矫正，必须在播放发起前修改
int ezplayer_setWideAngleCorrection(void* hMedia, int enable);

//设置写字的字体路径，必须在播放前设置
int ezplayer_setOverlayFontPath(void* hMedia, const string &path);

//设置子窗口显示，比如红外子窗口，在播放过程中随时开关
int ezplayer_setSubWindow(void* hMedia, int enable);

//设置播放中显示文字，在播放过程中随时开关
int ezplayer_setSubText(void* hMedia, int enable);

//设置播放中显示POS信息，在播放过程中随时开关
int ezplayer_setPrivatePosInfo(void* hMedia, int enable);

//设置POS叠加背景区域块颜色值 uA 0-100透明度 uR uG uB 0-255 颜色分量
int ezplayer_setPosBGRectColor(void*hMedia, uint8_t uA, uint8_t uR, uint8_t uG, uint8_t uB);

//设置视频后处理效果，包括图像参数、美白、磨皮、红润等效果
int ezplayer_setImagePostProcessParameter(void * hMedia, int type, float value);

//获取当前的软硬解情况 1：软解 2：硬解 0：出错
int ezplayer_getDecodeEngine(void* hMedia);


//设置重试次数 0-不重试
int ezplayer_setRetryCount(void *hMedia, int count);

//获取播放时的视频编码信息
int ezplayer_getVideoEncodeType(void *hMedia);

//设置解码回调
int ezplayer_setPLAYM4DecodeCallback(void* hMedia, onDecodeCallback playm4_dec_callback,void* nUser);


//设置打开播放库的超眼追踪功能，该功能需要在含有特定私有数据的码流上才会有效果 enable 1：打开 0关闭, 在播放过程中随时开关. keepEffect关闭时显示区域是否保持，1:保持，0-恢复到默认
int ezplayer_setEnableSuperEyeEffect(void* hMedia, int enable, int nRegionNum, int keepEffect);

//获取电子放大的显示区域，像素级
int ezplayer_getRegionRect(void* hMedia, EZRegionRect *regionRect, unsigned int nRegionNum);

int ezplayer_refreshPlayer(void* hMedia, unsigned int streamId = 0, bool checkRender = true);

void ezplayer_setDisplayNumber(void* hMedia, unsigned int number);

void ezplayer_closeAudioDevice();

//在预览的时候暂停播放库，只暂停播放库，临时接口，给萤石云用以在停止前先调用播放库暂停接口，再调用抓图接口
int ezplayer_pausePlayerWhenPreview(void* hMedia);

///播放库开启ANR降噪开关（HC需求）
int ezplayer_SetANRParam(void* hMedia, int nEnable, int nANRLevel);

///国标播放时，用于播放库音频模式播放及回声消除（仅Android需要）
int ezplayer_setSoundMode(void* hMedia, int soundMode, int sessionId);

///在stop之前在主线程调用，用以提前清理播放库的OpenGL资源，必须在主线程调用。
///如果底层启用的metal而不是OpenGL，则该接口没有任何影响
///调用该接口后，底层播放资源已提前释放，本次播放后续只能调用stop
int ezplayer_clearGLRenderResource(void* hMedia);

//取流策略，在start前调用，仅预览取流有效
int ezplayer_setStreamStrategy(void* hMedia, const string &strategy);

//取流超时配置，在start前调用
int ezplayer_setEZPlayerTimeoutConfig(void* hMedia, const string &config);

//本地文件播放
int ezplayer_getFileTime(void* hMedia);

int ezplayer_getPlayedTime(void* hMedia);

int ezplayer_setPlayedTime(void* hMedia, float percentage);

bool ezplayer_setPlayProgress(void* hMedia, int progess);

int ezplayer_getPlayProgress(void* hMedia);

//鱼眼相关接口
int ezplayer_enableFEC(void* hMedia);

int ezplayer_disableFEC(void* hMedia);

int ezplayer_getFECPort(void* hMedia, EZFECPlaceType inPlaceType, EZFECCorrectType inCorrectType, int *outFECPort);

int ezplayer_setFECWindow(void* hMedia, int fecSubPort, void *window);

int ezplayer_setFECParam(void* hMedia, int nSubPort , EZFECFISHEYE_PARAM * pPara);

int ezplayer_getFECParam(void* hMedia, int nSubPort , EZFECFISHEYE_PARAM * pPara);

int ezplayer_getFECCurrentPTZPort(void* hMedia, bool bPanorama, float fPositionX,float fPositionY, unsigned int *pnPort);

int ezplayer_setFECCurrentPTZPort(void* hMedia, int fecSubPort);

/// 设置PTZ展示时，在原图模式下展示的线框
int ezplayer_setFECPTZOutLineShowMode(void* hMedia, EZFECSHOWMODE nPTZShowMode);

int ezplayer_setFECDisplayCallback(void* hMedia, int fecSubPort, void(*subPortDisplayCallback)(int nPort, int nSubport, void *pUser), void *pUser);

int ezplayer_refreshFECPlay(void* hMedia, int fecSubPort, int streamId, bool checkRender = true);

int ezplayer_deleteFECPort(void* hMedia, int fecSubPort);

//听声辨位/声源定位
int ezplayer_enableEzvizSSLEffect(void* hMedia, int fecSubPort, bool enable);


//PTZ
int ezplayer_setFECPTZParam(void* hMedia, int fecSubPort, EZPTZParam point);

int ezplayer_getFECPTZParam(void* hMedia, int fecSubPort, EZPTZParam *point);

int ezplayer_setFECPTZZoom(void* hMedia, int fecSubPort, float scale);

int ezplayer_getFECPTZZoom(void* hMedia, int fecSubPort, float *scale);

///设置PTZ 线框的颜色
int ezplayer_setFECPTZColor(void* hMedia, int fecSubPort, unsigned char r,
                            unsigned char g, unsigned char b, unsigned char a);

int ezplayer_ptzToWindow(void* hMedia, int fecSubPort, EZPTZParam ptzOriginal, EZPTZParam ptzRefWnd, EZPTZParam ptzWnd, EZPTZParam *outPtz);

//180°或者360°矫正
int ezplayer_setFECWidthOffset(void* hMedia, int fecSubPort, float offset);

int ezplayer_getFECWidthOffset(void* hMedia, int fecSubPort, float *offset);

// 3D矫正
int ezplayer_setFEC3DRotate(void* hMedia, int fecSubPort, EZFECTransformElement element);

int ezplayer_setFEC3DRotateABS(void* hMedia, int fecSubPort, EZFECTransformElement element);

int ezplayer_getFEC3DRotate(void* hMedia, int fecSubPort, EZFECTransformElement *element);

int ezplayer_getFEC3DRotateSpecialViewInfo(void* hMedia, int fecSubPort, int viewType, EZFECTransformElement *element);

int ezplayer_setFECAnimation(void* hMedia, int fecSubPort, int type, int currentFrame, int totalFrame);


#endif /* EZPlayerSDK_h */
