/********************************************************************* 
 * Copyright (C), 2014-2015, Digital Technology Co., Ltd.
 * 文件名   : EZStreamSDK.h
 * 功能描述 : EZStreamSDK声明文件,该接口用于预览和回放取流，每一路camera对应一个客户端，并且客户端功能不要复用，例如不能既用于预览又用于回放
 * 作者     ：tanyongfeng
 * 创建日期 ：2016-5-7
 * 修改历史 ：初始版本(2016-5-7)
 *
 * 
**********************************************************************/
#include "EZStreamTypes.h"
#include <map>
#include <vector>
#ifndef _EZSTREAM_SDK_H_
#define _EZSTREAM_SDK_H_


//************************************
// 函数名称 :  ezstream_createClientWithUrl
// 访问属性 :  public 
// 返回值   :  void* ,成功返回客户端句柄，否则NULL
// 参数     :  [IN]	szStreamUrl ,stream url
// 功能描述 :  以URL形式创建取流客户端，目前只用于视频广场的直播，见EZ_STREAM_SOURCE
// 修改历史 :  初始版本(2016-5-9)
//************************************
void* ezstream_createClientWithUrl(int8_t *szStreamUrl);


//************************************
// 函数名称 :  ezstream_updateParam
// 访问属性 :  public
// 返回值   :  int32_t 成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]	void* hClient,客户端句柄
// 参数     :  [IN]	INIT_PARAM * pParam  客户端参数,只针对同一设备进行操作(设备序列号不能改变)
// 功能描述 :  更新pParam为信息,不会重新进行预操作
// 修改历史 :  初始版本(2016-5-9)
//************************************
int32_t  ezstream_updateParam(void* hClient, INIT_PARAM *pParam);
//************************************
// 函数名称 :  ezstream_startVoiceTalk
// 访问属性 :  public 
// 返回值   :  int32_t 成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]	void* hClient, 客户端句柄
// 参数     :  [OUT]	int32_t * pEncode ,返回语音编码类型
// 功能描述 :  开始语音对讲
// 修改历史 :  初始版本(2016-5-9)
//************************************
int32_t  ezstream_startVoiceTalk(void* hClient,int32_t *pEncode);
//************************************
// 函数名称 :  ezstream_startVoiceTalkV2
// 访问属性 :  public
// 返回值   :  int32_t 成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]	void* hClient, 客户端句柄
// 参数     :  [OUT]	EZ_VOICE_PARAM voiceParam ,编码参数
// 功能描述 :  开始语音对讲
// 修改历史 :  初始版本(2016-5-9)
//************************************
int32_t  ezstream_startVoiceTalkV2(void* hClient,EZ_VOICE_PARAM &voiceParam);
//************************************
// 函数名称 :  ezstream_stopVoiceTalk
// 访问属性 :  public 
// 返回值   :  int32_t 成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]	void* hClient ,客户端句柄
// 功能描述 :  停止语音对讲
// 修改历史 :  初始版本(2016-5-9)
//************************************
int32_t  ezstream_stopVoiceTalk(void* hClient);
//************************************
// 函数名称 :  ezstream_inputVoiceTalkData
// 访问属性 :  public 
// 返回值   :  int32_t 成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]	void* hClient ,客户端句柄 
// 参数     :  [IN]	int8_t * pVoiceData  ,语音数据buffer
// 参数     :  [IN]	int32_t iVoiceDataLen  ,语音数据buffer长度
// 参数     :  [IN]	int32_t iVoiceCmdType ,命令类型.0x4100 -- 正常数据,0x4200 -- 语音对讲按钮按下 ,0x4201 -- 语音对讲按钮松开 
// 功能描述 :  输入语音数据
// 修改历史 :  初始版本(2016-5-9)
//************************************
int32_t  ezstream_inputVoiceTalkData(void* hClient, int8_t *pVoiceData, int32_t iVoiceDataLen, int32_t iVoiceCmdType);
//************************************
// 函数名称 :  ezstream_switchMic
// 访问属性 :  public
// 返回值   :  int32_t 成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]	void* hClient ,客户端句柄
// 参数     :  [IN]	int32_t micType, 麦克风类型，0-默认，(目前仅针对3摄锁，0-门外对讲；1-门内对讲麦克)
// 功能描述 :  对讲过程中切换设备端的麦克风
// 修改历史 :  初始版本(2024-3-13)
//************************************
int32_t  ezstream_switchMic(void* hClient, int32_t micType);
//************************************
// 函数名称 :  ezstream_startPlayback
// 访问属性 :  public 
// 返回值   :  int32_t 成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]	void* hClient ,客户端句柄 
// 参数     :  [IN]	int8_t * szStartTime ,开始时间,格式如：20130617T102030Z 
// 参数     :  [IN]	int8_t * szStopTime ，结束时间 ,格式如：20130617T102030Z
// 参数     :  [IN]	int8_t * szCloudFileId ，云存储文件ID
// 功能描述 :  开始回放取流
// 修改历史 :  初始版本(2016-5-9)
//************************************
int32_t  ezstream_startPlayback(void* hClient, int8_t *szStartTime,int8_t *szStopTime,int8_t *szCloudFileId);

//************************************
// 函数名称 :  ezstream_createCASClient
// 访问属性 :  public
// 返回值   :  void* ,成功返回客户端句柄，否则NULL
// 功能描述 :  创建CAS取流客户端,用于上传或下载留言
// 修改历史 :  初始版本(2016-5-9)
//************************************
void* ezstream_createCASClient();

//************************************
// 函数名称 :  ezstream_startUpload2Cloud
// 访问属性 :  public
// 返回值   :  成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]	hClient ,客户端
// 参数     :  [IN]	pParam ,客户端参数
// 功能描述 :  开始上传留言
// 修改历史 :  初始版本(2016-5-9)
//************************************
int32_t ezstream_startUpload2Cloud(void* hClient,UPLOAD_VOICE_PARAM *param);

//************************************
// 函数名称 :  ezstream_inputData2Cloud
// 访问属性 :  public
// 返回值   :  成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]	hClient ,客户端
// 参数     :  [IN]	pData ,留言数据
// 参数     :  [IN]	iDataLen ,留言数据长度
// 功能描述 :  填充留言数据
// 修改历史 :  初始版本(2016-5-9)
//************************************
int32_t ezstream_inputData2Cloud(void* hClient,int8_t *pData, int32_t iDataLen);

//************************************
// 函数名称 :  ezstream_stopUpload2Cloud
// 访问属性 :  public
// 返回值   :  成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]	hClient ,客户端
// 功能描述 :  停止上传留言
// 修改历史 :  初始版本(2016-5-9)
//************************************
int32_t ezstream_stopUpload2Cloud(void* hClient);

//************************************
// 函数名称 :  ezstream_startDownloadFromCloud
// 访问属性 :  public
// 返回值   :  成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]	hClient ,客户端
// 参数     :  [IN]	pParam ,客户端参数
// 功能描述 :  开始下载留言,数据通过fnDataCallback返回
// 修改历史 :  初始版本(2016-5-9)
//************************************
int32_t ezstream_startDownloadFromCloud(void* hClient,DOWNLOAD_CLOUD_PARAM *param);

//************************************
// 函数名称 :  ezstream_stopDownloadFromcloud
// 访问属性 :  public
// 返回值   :  成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]	hClient ,客户端
// 功能描述 :  停止下载留言
// 修改历史 :  初始版本(2016-5-9)
//************************************
int32_t ezstream_stopDownloadFromCloud(void* hClient);


//************************************
// 函数名称 :  ezstream_setPlaybackRate
// 访问属性 :  public
// 返回值   :  成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]	hClient ,客户端
// 参数     :  [IN]    rate ,回放速度，1~9，9个值 1：正常速度 2：2倍 3：1/2倍 4：4倍 5：1/4倍 6：8倍 7：1/8倍 8：16倍 9：1/16倍）
// 功能描述 :  设置回放速度,只有某些视频回放才能支持
// 修改历史 :  初始版本(2016-6-20)
//************************************
int32_t  ezstream_setPlaybackRate(void* hClient,EZ_PLAY_BACK_RATE rate);

//************************************
// 函数名称 :  ezstream_getLeftTokenCount
// 访问属性 :  public
// 返回值   :  返回token池中剩余token个数
// 功能描述 :  获取token池中剩余token个数
// 修改历史 :  初始版本(2016-6-27)
//************************************
int32_t  ezstream_getLeftTokenCount();

//************************************
// 函数名称 :  ezstream_isP2PPreviewing
// 访问属性 :  public
// 参数     :  [IN]	szDevSerial ,设备序列号
// 参数     :  [IN]	iChannel ,camera通道号
// 返回值   :  ture or false
// 功能描述 :  判断当前设备是否正在P2P预览中
// 修改历史 :  初始版本(2016-7-2)
//************************************
int32_t  ezstream_isP2PPreviewing(string szDevSerial,int32_t iChannel);

//************************************
// 函数名称 :  ezstream_isPlayingWithPreconnect
// 访问属性 :  public
// 参数     :  [IN]	szDevSerial ,设备序列号
// 返回值   :  ture or false
// 功能描述 :  判断当前设备是否正在用P2P或直连方式进行取流
// 修改历史 :  初始版本(2017-2-9)
//************************************
int32_t  ezstream_isPlayingWithPreconnect(string szDevSerial);
// 函数名称 :  ezstream_setP2PCallback
// 访问属性 :  public
// 参数     :  [IN]	fnP2PPreconnectStatisticsCallback ,统计上报callback
// 参数     :  [IN]	eventCB ,全局事件回调，包括P2P预感知callback
// 参数     :  [IN]	userData ,用户数据
// 返回值   :  int32_t 成功返回EZ_OK,否则返回错误码
// 功能描述 :  设置全局回调,,不依赖具体的client
// 修改历史 :  初始版本(2016-7-28)
//************************************
int32_t  ezstream_setGlobalCallback(fnPreconnectStatisticsCallback statisticsCB,fnOnEventCallback statusCB,fnOnDataCallback dataCB,fnPreconnectResultCallback resultCB,void *userData);



/// 设置token获取的回调，在初始化SDK后调用
/// @param tokenCB token回调 如果设置了全局的token回调，库内部在需要token的时候，会调用该回调，向外部请求token
int32_t ezstream_setTokenCallback(fnTokenCallback tokenCB);

//************************************
// 函数名称 :  ezstream_getGlobalCallbackUserData
// 访问属性 :  public
// 返回值   :  void* 返回用户自定义回调数据
// 功能描述 :  获取用户传入的自定义回调数据
// 修改历史 :  初始版本(2016-10-12)
//************************************
void*   ezstream_getGlobalCallbackUserData();


//************************************
// 函数名称 :  ezstream_startServerOfReverseDirect
// 访问属性 :  public
// 返回值   :  int32_t 成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]	szStunDomain ,Stun服务器IP地址, 如果为空字符串, 默认为hzstun.ys7.com
// 参数     :  [IN]	iStunPort ,Stun服务器端口, 如果为0, 默认为6002
// 参数     :  [IN]	iCheckPeriod ,检测UPnP映射是否有效周期，以及通知设备反向直连检测周期, 单位为s, 如果为0，默认600s
// 功能描述 :  开启反向直连服务,当手机连接到wifi时才能调用
// 修改历史 :  初始版本(2016-8-4)
//************************************
int32_t  ezstream_startServerOfReverseDirect(int8_t *szStunDomain, int32_t iStunPort, int32_t iCheckPeriod);

//************************************
// 函数名称 :  ezstream_stopServerOfReverseDirect
// 访问属性 :  public
// 返回值   :  int32_t 成功返回EZ_OK,否则返回错误码
// 功能描述 :  停止反向直连服务,当手机wifi断开或退出应用时调用
// 修改历史 :  初始版本(2016-8-4)
//************************************
int32_t  ezstream_stopServerOfReverseDirect();

//************************************
// 函数名称 :  ezstream_clearDeviceListOfReverseDirect
// 访问属性 :  public
// 返回值   :  int32_t 成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]	szDevSerial ,设备序列号,如果szDevSerial为NULL， 则清理整个设备列表信息
// 功能描述 :  清理反向直连的设备信息
// 修改历史 :  初始版本(2016-8-4)
//************************************
int32_t  ezstream_clearDeviceListOfReverseDirect(int8_t *szDevSerial);

//************************************
// 函数名称 :  ezstream_setP2PPublicParam
// 访问属性 :  public
// 返回值   :  NULL
// 参数     :  [IN]	pP2pPublicParam p2p打洞所需的公共参数，目前为nattype
// 功能描述 :  设置p2p打洞的公共参数,app层在nat类型变化后，需要调用此接口
// 修改历史 :  初始版本(2017-05-04)
//************************************
void ezstream_setP2PPublicParam(EZ_P2P_PUBLICPARAM *pP2pPublicParam);

////************************************
//// 函数名称 :  ezstream_setPlaybackConvert
//// 访问属性 :  public
//// 返回值   :
//// 参数     :  [IN]    hClient ,客户端
//// 参数     :  [IN]    videoBitrate ,参考NET_DVR_COMPRESSION_INFO_V30
//// 参数     :  [IN]    resolution ,参考NET_DVR_COMPRESSION_INFO_V30
//// 参数     :  [IN]    videoFrameRate ,参考NET_DVR_COMPRESSION_INFO_V30
//// 功能描述 :  设置p2p打洞的公共参数,app层在nat类型变化后，需要调用此接口
//// 修改历史 :  初始版本(2017-05-04)
////************************************
void ezstream_setPlaybackConvert(void* hClient,int32_t videoBitrate,int32_t resolution,int32_t videoFrameRate);

//************************************
// 函数名称 :  ezstream_setP2PDeviceCount
// 访问属性 :  public
// 返回值   :  NONE
// 参数     :  [IN]	count , 当前帐号下支持P2P的设备数量，用于打洞优化
// 功能描述 :  当前帐号下支持P2P的设备数量，用于打洞优化
// 修改历史 :  初始版本(2017-09-13)
//************************************
void ezstream_setP2PDeviceCount(int32_t count);



//************************************
// 函数名称 :  ezstream_getDevInfo
// 访问属性 :  public
// 返回值   :  int32_t 返回设备信息
// 参数     :  [IN]	void* hClient ,客户端句柄
// 参数     :  [IN]	isForce ,是否强制重新获取
// 参数     :  [OUT]	EZ_DEV_INFO pDev ,设备信息
// 功能描述 :  返回设备信息
// 修改历史 :  初始版本(2016-5-9)
//************************************
extern "C" int32_t  ezstream_getDevInfo(int64_t hClient, bool isForce,EZ_DEV_INFO *pDev);

//************************************
// 函数名称 :  ezstream_setPlaybackConvertEx
// 访问属性 :  public
// 返回值   :  NONE
// 参数     :  [IN]	hClient ,客户端
// 参数     :  [IN]	compressionParam ,NET_DVR_COMPRESSION_INFO_V30指针
// 功能描述 :  设置p2p打洞的公共参数,app层在nat类型变化后，需要调用此接口
// 修改历史 :  初始版本(2017-05-04)
//************************************
extern "C" void ezstream_setPlaybackConvertEx(int64_t hClient,void *compressionParam);

//************************************
// 函数名称 :  ezstream_updateDevInfoToCache
// 访问属性 :  public
// 返回值   :  NONE
// 参数     :  [IN]	szDevSerial ,设备序列号
// 参数     :  [IN]	devInfo ,设备操作码信息
// 功能描述 :  由上层应用主动更新缓存中的设备操作码信息
// 修改历史 :  初始版本(2017-09-26)
extern "C" void ezstream_updateDevInfoToCache(const char *szDevSerial,const EZ_DEV_INFO *devInfo);

//************************************
// 函数名称 :  ezstream_getDevInfoFromCache
// 访问属性 :  public
// 返回值   :  成功返回true,失败false
// 参数     :  [IN]	szDevSerial ,设备序列号
// 参数     :  [OUT]	devInfo ,设备操作码信息
// 功能描述 :  获取缓存中的设备操作码信息
// 修改历史 :  初始版本(2017-09-26)
extern "C" bool ezstream_getDevInfoFromCache(const char *szDevSerial,EZ_DEV_INFO *devInfo);

//************************************
// 函数名称 :  ezstream_cloudPlaybackControl
// 访问属性 :  public
// 返回值   :  成功返回0,失败错误码
// 参数     :  [IN]	hClient  ,客户端
// 参数     :  [IN]	op ,控制类型,见EZ_PLAYBACK_OP
// 参数     :  [in]	szBeginTime ,seek定位时间,当op=EZ_EZ_PLAYBACK_OP_SEEK时用
// 参数     :  [in]	iPlaySpeed ,播放速度,当op=EZ_EZ_PLAYBACK_OP_SPEED时用
// 功能描述 :  云存储回放控制
// 修改历史 :  初始版本(2017-11-08)
extern "C" int ezstream_cloudPlaybackControl(void* hClient,EZ_PLAYBACK_OP op,const char *szBeginTime,EZ_PLAY_BACK_RATE iPlaySpeed);

//************************************
// 函数名称 :  ezstream_isP2PStuning
// 访问属性 :  public
// 返回值   :  TRUE or FALSE
// 参数     :  [IN]	szDevSerial  ,设备序列号
// 功能描述 :  设备是否正在进行预操作
// 修改历史 :  初始版本(2017-11-08)
int32_t ezstream_isPreconnecting(const string szDevSerial);


//************************************
// 函数名称 :  ezstream_createEZCASClient
// 访问属性 :  public
// 返回值   :  void * ,成功返回客户端句柄，否则NULL
// 参数     :  [IN]    isIPV6 true or false
// 功能描述 :  创建CAS handle,用于透传CAS相关接口
// 修改历史 :  初始版本(2016-5-9)
//************************************
extern "C" int64_t ezstream_createEZCASClient(bool isIPV6);


//************************************
// 函数名称 :  ezstream_destroyEZCASClient
// 访问属性 :  public
// 返回值   :  int32_t
// 参数     :  [IN]    void * hClient, ezstream_createEZCASClient创建的客户端句柄
// 功能描述 :  销毁客户端
// 修改历史 :  初始版本(2016-5-9)
//************************************
extern "C" int32_t ezstream_destroyEZCASClient(int64_t hClient);

//************************************
// 函数名称 :  ezstream_transferViaP2P
// 访问属性 :  public
// 返回值   :  成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]    hClient ,通过ezstream_createEZCASClient创建的客户端
// 参数     :  [IN]    pstTransReq ,发送的请求信息
// 参数     :  [OUT]    pStTransRsp ,发送收到的响应信息
// 功能描述 :  尝试通过P2P通道透传数据（仅支持[支持P2Pv3的设备])
// 修改历史 :  初始版本(2016-5-9)
//************************************
extern "C" int32_t ezstream_transferViaP2P(int64_t hClient, const pEZ_P2PTRANSREQ_INFO pstTransReq, pEZ_P2PTRANSRSP_INFO pStTransRsp);



//************************************
// 函数名称 :  ezstream_startDownloadFromDevice
// 访问属性 :  public
// 返回值   :  成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]    hClient ,通过ezstream_createClient创建的客户端
// 功能描述 :  下载设备SD卡中的录像
//  a.如果设备不支持v3P2P下载，需要禁止P2P的取流方式（如果不禁止，且设备支持v3P2P，则库内部会尝试P2P下载，最终报错）
//  b.内外网直连仅在 iSupportPlayBackEndFlag 为 1 的情况下 才会尝试，并且尝试的时候会以8倍速推流
//  c.以上两种情况都不支持的情况下，尝试流媒体回放速率下载
// 修改历史 :  初始版本(2018-5-17)
//************************************
int32_t ezstream_startDownloadFromDevice(void* hClient,int8_t *szStartTime,int8_t *szStopTime);

//************************************
// 函数名称 :  ezstream_stopP2PDownloadFromDevice
// 访问属性 :  public
// 返回值   :  成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]    hClient ,通过ezstream_createClient创建的客户端
// 功能描述 :  停止下载
// 修改历史 :  初始版本(2018-5-17)
//************************************
int32_t ezstream_stopDownloadFromDevice(void* hClient);

//************************************
// 函数名称 :  ezstream_setLocalNetIp
// 访问属性 :  public
// 返回值   :  无
// 参数     :  [IN]    szNetIp 本地外网ip
// 功能描述 :  设置本地外网ip
// 修改历史 :  v2.4.2(2018-09-03)
//************************************
void ezstream_setLocalNetIp(const string& szNetIp);


//************************************
// 函数名称 :  ezstream_setTimeoutOptimize
// 访问属性 :  public
// 返回值   :  无
// 参数     :  [IN]    openOptimize 是否打开超时优化，如打开，可通过ezstream_setTimeoutParam传入优化参数
// 功能描述 :  设置超时参数
// 修改历史 :  v2.4.2(2018-09-04)
//************************************
void ezstream_setTimeoutOptimize(bool openOptimize);


//************************************
// 函数名称 :  ezstream_setTimeoutParam
// 访问属性 :  public
// 返回值   :  无
// 参数     :  [IN]    timeParam 超时配置信息
// 功能描述 :  设置超时参数
// 修改历史 :  v2.4.2(2018-09-04)
//************************************
void ezstream_setTimeoutParam(const EZ_TIMEOUT_PARAM &timeParam);

/// 按用户维度配置的信息的灰度配置
/// - Parameter configParam: 灰度配置信息
void ezstream_setStreamConfigByUser(const EZ_TIMEOUT_PARAM &configParam);


//************************************
// 函数名称 :  ezstream_setMtuConfig
// 访问属性 :  public
// 返回值   :  无
// 参数     :  [IN]    mtuValue MTU配置信息
// 功能描述 :  设置超时参数
// 修改历史 :  v2.4.2(2018-09-06)
//************************************
void ezstream_setMtuConfig(int mtuValue);

//************************************
// 函数名称 :  ezstream_setMax43PunchDevices
// 访问属性 :  public
// 返回值   :  无
// 参数     :  [IN]    maxcount 最大43穿透尝试设备数
// 功能描述 :  客户端依据灰度配置项设置4G网络下43组合打洞次数上限，修复用户反馈的萤石云App断网问题, 0表示不限制
// 修改历史 :  v2.5.0(2018-11-20)
//************************************
void ezstream_setMax43PunchDevices(unsigned int maxcount);

//************************************
// 函数名称 :  ezstream_setSSLTryCount
// 访问属性 :  public
// 返回值   :  无
// 参数     :  [IN]    count ssl连接最大链接次数
// 功能描述 :  cas库需求-设置直连时，ssl连接复合链接次数
// 修改历史 :  v2.4.2(2018-09-04)
//************************************
void ezstream_setSSLTryCount(int count);

/**
 * 获取P2P优选信息，在APP即将被杀掉时调用，拿到信息后保存到本地
 * @return
 */
string ezstream_getPreconnectSelectInfo();

/**
 * 设置P2P优选信息，在APP启动后，在进行缓存预操作前，从本地拿到优选信息，设置
 * @param strSelectInfo
 * @return
 */
int ezstream_setPreconnectSelectInfo(const string& strSelectInfo);

/**
 * 进行P2P优选，APP拿到缓存的设备列表后，通过该接口传入一组设备序列号，库里面会返回排序好的一组设备序列号，然后APP再依照新的顺序，调用预操作接口
 * @param szDeviceArray
 * @param netType 网络类型
 * @param resultList
 * @return 0不需要优选； -1 操作错误；>0 预操作设备数量
 */
int ezstream_selectPreconnectDevice(const vector<string> &srcDevList, int netType, vector<string>& resultList);


/**
 设备客户端的类型，比如国内萤石云是iOS是1，Android是3

 @param type 类型
 @return 是否成功 成功返回0
 */
int ezstream_setClientType(int type);


/**
 设置客户端的版本

 @param version 版本号
 @return 成功返回0
 */
int ezstream_setClientVersion(const string &version);

#endif //_EZSTREAM_SDK_H_
