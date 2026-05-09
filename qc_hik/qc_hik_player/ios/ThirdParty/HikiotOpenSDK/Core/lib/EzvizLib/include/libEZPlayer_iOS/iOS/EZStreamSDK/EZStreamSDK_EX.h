/********************************************************************* 
 * Copyright (C), 2014-2020, Digital Technology Co., Ltd.
 * 文件名   : EZStreamSDK_EX.h
 * 功能描述 : EZStreamSDK声明文件,该接口用于预览和回放取流，每一路camera对应一个客户端，并且客户端功能不要复用，例如不能既用于预览又用于回放
 * 作者     ：tanyongfeng
 * 创建日期 ：2020-04-02
 * 修改历史 ：初始版本(2020-04-02)
 *
 * 
**********************************************************************/
#include <map>
#include <vector>
#include "EZStreamTypes.h"
#include <list>

#ifndef _EZSTREAM_SDK_EX_H_
#define _EZSTREAM_SDK_EX_H_

//************************************
// 函数名称 :  ezstream_getVersion
// 访问属性 :  public
// 返回值   :  int32_t
// 参数     :  [OUT]	int8_t * szVersion  ,输出当前版本号,如1.0.1.20160708 cas:110840 private_stream:100561
// 参数     :  [IN/OUT]	int32_t bufLen  传入szVersion buffer大小,传出实际实际版本号的大小.若buffer不够返回出错
// 功能描述 :  返回当前库的版本号
// 修改历史 :  初始版本(2016-5-11)
//************************************
int32_t  ezstream_getVersion(int8_t *szVersion,int32_t *bufLen);

//************************************
// 函数名称 :  ezstream_init
// 访问属性 :  public
// 参数     :  [IN]     string deviceID  ,设备ID，如传入，长度必须为25，iOS平台建议传入，切同一个设备传入的ID必须一致
// 返回值   :  int32_t，成功返回EZ_OK,否则返回错误码
// 功能描述 :  取流库初始化，程序运行时调用此方法
// 修改历史 :  初始版本(2016-5-9)
//************************************
int32_t ezstream_initSDK(string deviceID="");

//************************************
// 函数名称 :  ezstream_destoryClientManager
// 访问属性 :  public
// 返回值   :  int32_t
// 功能描述 :  取流库反初始化，程序退出时必须调用本方法
// 修改历史 :  初始版本(2016-5-9)
//************************************
int32_t  ezstream_uninitSDK();

//************************************
// 函数名称 :  ezstream_setLogPrintEnable
// 访问属性 :  public
// 参数     :  [IN]	enable ,true or false
// 参数     :  [in] supportXlog, 是否支持xlog，true or false
// 功能描述 :  开启/关闭打印日志功能
// 修改历史 :  初始版本(2016-7-2)
//************************************
void  ezstream_setLogPrintEnable(int32_t enable, int32_t supportXlog = false, int level = 4 /*INFO*/);

/// 设置日志回调接口
/// - Parameter callback: 回调函数
void ezstream_setLogCallback(ezLogCallback * callback, void* userData = nullptr);

void* ezstream_getLogCallbackUserData();

//************************************
// 函数名称 :  ezstream_setTokens
// 访问属性 :  public
// 返回值   :  int32_t
// 参数     :  [IN]	    int8_t * szTokens[]  ,token数组
// 参数     :  [IN]	    int32_t len ,token数组的个数，一次最多30个;当token池满时会返回EZ_ERROR_TOKEN_POOL_FULL错误
// 功能描述 :  用于批量传入token,内部会用token
// 修改历史 :  初始版本(2016-5-9)
//************************************
int32_t  ezstream_setTokens(int8_t *szTokens[],int32_t len);

//************************************
// 函数名称 :  ezstream_clearTokens
// 访问属性 :  public
// 返回值   :  int32_t 成功返回EZ_OK,否则返回错误码
// 功能描述 :  用于清除所有token,当token无效时建议调用该接口
// 修改历史 :  初始版本(2016-5-9)
//************************************
int32_t  ezstream_clearTokens();

//************************************
// 函数名称 :  ezstream_startPreconnect
// 访问属性 :  public
// 返回值   :  void
// 参数     :  [IN] 预链接参数
// 功能描述 :  开启指定设备的预链接
// 修改历史 :  初始版本(2018-12-03)
//************************************
void ezstream_startPreconnect(INIT_PARAM *initParam);

//************************************
// 函数名称 :  ezstream_clearPreconnectInfo
// 访问属性 :  public
// 参数     :  [IN]	szDevSerial ,设备序列号
// 返回值   :  成功返回EZ_OK,否则返回错误码数
// 功能描述 :  清除指定设备的预操作信息
// 修改历史 :  初始版本(2016-6-27)
//************************************
int32_t  ezstream_clearPreconnectInfo(string szPreSerial);


/// 获取所有的SDK中进行预操作的设备序列号（包括正在进行预操作的以及预操作完成的）
list<string> ezstream_getAllProcessedPreconnectSerials();


/// 获取所有的SDK中正在排队的预操作的设备序列号（指还没有进行预操作的）
list<string> ezstream_getAllToDoPreconnectSerials();

//************************************
// 函数名称 :  ezstream_isPreConnectionSucceed
// 访问属性 :  public
// 返回值   :  int32_t 成功返回1,否则0
// 参数     :  [IN]	szDevSerial ,设备序列号
// 功能描述 :  当前设备是否打洞成功
// 修改历史 :  初始版本(2016-8-16)
//************************************
int32_t ezstream_isPreConnectionSucceed(string szDevSerial);

//************************************
// 函数名称 :  ezstream_setP2PV3ConfigInfo
// 访问属性 :  public
// 返回值   :  int32_t 成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]	stP2PKeyInfo ,p2p服务连接需要的秘钥信息
// 功能描述 :  设置客户端的NAT类型和stun服务器信息
// 修改历史 :  初始版本(2017-05-04)
//************************************
int ezstream_setP2PV3ConfigInfo(EZ_P2P_KEYINFO *pStP2PKeyInfo);

//************************************
// 函数名称 :  ezstream_createClient
// 访问属性 :  public 
// 返回值   :  void* ,成功返回客户端句柄，否则NULL
// 参数     :  [IN]	INIT_PARAM * pParam ,客户端参数
// 功能描述 :  创建取流客户端
// 修改历史 :  初始版本(2016-5-9)
//************************************
void* ezstream_createClient(INIT_PARAM *pParam);

//************************************
// 函数名称 :  ezstream_destroyClient
// 访问属性 :  public 
// 返回值   :  int32_t
// 参数     :  [IN]	void* hClient, 客户端句柄 
// 功能描述 :  销毁取流客户端
// 修改历史 :  初始版本(2016-5-9)
//************************************
int32_t  ezstream_destroyClient(void* hClient);

//************************************
// 函数名称 :  ezstream_startPreview
// 访问属性 :  public  成功返回EZ_OK,否则返回错误码
// 返回值   :  int32_t
// 参数     :  [IN]	void* hClient, 客户端句柄
// 功能描述 :  开始预览取流
// 修改历史 :  初始版本(2016-5-9)
//************************************
int32_t  ezstream_startPreview(void* hClient);

//************************************
// 函数名称 :  ezstream_stopPreview
// 访问属性 :  public 
// 返回值   :  int32_t 成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]	void* hClient, 客户端句柄  
// 功能描述 :  停止预览取流
// 修改历史 :  初始版本(2016-5-9)
//************************************
int32_t  ezstream_stopPreview(void* hClient);

//************************************
// 函数名称 :  ezstream_setCallback
// 访问属性 :  public 成功返回EZ_OK,否则返回错误码
// 返回值   :  int32_t 成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]	void* hClient ,客户端句柄 
// 参数     :  [IN]	void * pUserData  ,用户自定义回调数据
// 参数     :  [IN]	fnDataCallback dataCallback  数据回调函数
// 参数     :  [IN]	fnMsgCallback msgCallback  ，消息回调函数
// 功能描述 :  设置取流客户端回调函数，用于消息及数据通知
// 修改历史 :  初始版本(2016-5-9)
//************************************
int32_t  ezstream_setCallback(void* hClient, void *pUserData,fnDataCallback dataCallback,fnMsgCallback msgCallback,fnStatisticsCallback statisticsCallback);

//************************************
// 函数名称 :  ezstream_getCallbackUserData
// 访问属性 :  public  用户传入的自定义回调数据
// 返回值   :  void* 返回用户自定义回调数据
// 参数     :  [IN]	void* hClient  ,客户端句柄
// 功能描述 :  获取用户传入的自定义回调数据
// 修改历史 :  初始版本(2016-5-9)
//************************************
void*  ezstream_getCallbackUserData(void* hClient);

//************************************
// 函数名称 :  ezstream_startPlayback_ex
// 访问属性 :  public 
// 返回值   :  int32_t 成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]	void* hClient ,客户端句柄 
// 参数     :  [IN]	VideoStreamInfoList& videos 待回放视频，包含录像与源文件
// 功能描述 :  开始回放取流
// 修改历史 :  初始版本(2016-5-9)
//************************************
int32_t  ezstream_startPlayback(void* hClient, const ez_stream_sdk::VideoStreamInfoList &videos);

//************************************
// 函数名称 :  ezstream_stopPlayback
// 访问属性 :  public 
// 返回值   :  int32_t 成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]	void* hClient   ,客户端句柄
// 功能描述 :  停止回放取流
// 修改历史 :  初始版本(2016-5-9)
//************************************
int32_t  ezstream_stopPlayback(void* hClient);

//************************************
// 函数名称 :  ezstream_setPlaybackRate
// 访问属性 :  public
// 返回值   :  成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]	hClient ,客户端
// 参数     :  [IN]    rate ,回放速度，1~9，9个值 1：正常速度 2：2倍 3：1/2倍 4：4倍 5：1/4倍 6：8倍 7：1/8倍 8：16倍 9：1/16倍）
// 参数     :  [IN]    fastPlayMode , 1：抽帧，2：全帧，未传该参数默认为0，即4倍速全帧，8倍速以上抽帧
// 参数     :  [IN]    currentTime, 当前播放的OSD时间
// 功能描述 :  设置回放速度,只有某些视频回放才能支持
// 修改历史 :  初始版本(2016-6-20)
//************************************
int32_t  ezstream_setPlaybackRate(void* hClient, EZ_PLAY_BACK_RATE rate, string currentTime, EZ_FAST_PLAY_MODE fastPlayMode = EZ_FAST_PLAY_MODE_DEFAULT);

//************************************
// 函数名称 :  ezstream_seek_ex
// 访问属性 :  public
// 返回值   :  成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]	hClient ,客户端
// 参数     :  [IN]	VideoStreamInfoList& videos 待回放视频，包含录像与源文件
// 功能描述 :  回放偏移
// 修改历史 :  初始版本(2016-6-20)
int32_t ezstream_seek(void *hClient, const ez_stream_sdk::VideoStreamInfoList &videos);

//************************************
// 函数名称 :  ezstream_continue_ex
// 访问属性 :  public
// 返回值   :  成功返回EZ_OK,否则返回错误码
// 参数     :  [IN]	hClient ,客户端
// 参数     :  [IN]	VideoStreamInfoList& videos 待回放视频，包含录像与源文件
// 功能描述 :  持续回放，用于分页式列表播放
// 修改历史 :  初始版本(2016-6-20)
int32_t ezstream_continue(void *hClient, const ez_stream_sdk::VideoStreamInfoList &videos);

//************************************
// 函数名称 :  ezstream_getClientType
// 访问属性 :  public
// 返回值   :  int32_t 返回取流客户端类型
// 参数     :  [IN]	void* hClient   ,客户端句柄
// 功能描述 :  返回E取流客户端类型,只有在正在取流时调用才有效,即在start之后,stop之前调用有效
// 修改历史 :  初始版本(2016-5-9)
//************************************
int32_t  ezstream_getClientType(void* hClient);


#endif //_EZSTREAM_SDK_EX_H_
