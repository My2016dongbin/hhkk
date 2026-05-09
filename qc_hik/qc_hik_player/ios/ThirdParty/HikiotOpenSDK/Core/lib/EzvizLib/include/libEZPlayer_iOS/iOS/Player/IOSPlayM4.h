/** @file       IOSPlayM4.h
 *  @note       HangZhou Hikvision Software Co., Ltd. All Right Reserved.
 *  @brief      declaration of iOS-PlayM4-Special APIs
 *
 *  @author     HPC-MMT-MSDK
 *
 *  @version    V7.4.2
 *  @date       2022/8/24
 *
 *  @note       iOS播放库特有接口声明，跟Android播放库共享的接口声明请参考MobilePlaySDKInterface.h
 */

#ifndef __IOS_PLAYM4_H__
#define __IOS_PLAYM4_H__

#include "MobilePlaySDKInterface.h"

#define PLAYM4_IOS_RENDER_ENGINE_OPENGL          (3)
#define PLAYM4_IOS_RENDER_ENGINE_METAL           (8)
#define PLAYM4_IOS_RENDER_ENGINE_OPENGL_FLUTTER  (9)

//iOS AVAudioSession设置类型
typedef enum  _PLAYM4_ENUM_AU_CATEGORY_
{
    PLAYM4_AU_SESSION_CATEGORY_MediaPlayback = 0,  //音频播放模式
    PLAYM4_AU_SESSION_CATEGORY_PlayAndRecord = 1,  //音频对讲模式
}PLAYM4_ENUM_AU_CATEGORY;

//iOS硬解码输出数据类型
typedef enum _PLAYM4_IOS_HD_OUTDATATYPE_
{
    PLAYM4_IOS_HD_OUT_CVPR = 0,    //CVPixelBuffer输出
    PLAYM4_IOS_HD_OUT_YUV  = 1,    //NV12输出
}PLAYM4_IOS_HD_OUTDATATYPE;

//only used for iOS platform ,Android return not support.
typedef enum _PLAYM4_ENUM_IOS_HD_DEC_CB_OUT_TYPE
{
    PLAYM4_IOS_HD_DEC_CB_OUT_YV12   = 0,
    PLAYM4_IOS_HD_DEC_CB_OUT_NV12   = 1,
}PLAYM4_ENUM_IOS_HD_DEC_CB_OUT_TYPE;

#ifdef __cplusplus
extern "C"
{
#endif

/*@fun   PlayM4_KeepLastFrame
* @brief 关闭播放库后是否保留最后一帧显示
* @para  nPort[IN]         播放端口号(0~31)
* @para  bFlag[IN]         false ～ 不保留 true ～ 保留
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_KeepLastFrame(int nPort, bool bFlag);


/*@fun   PLayM4_SetIOSHDOutPutDataType
* @brief 设置iOS硬解码输出数据类型
* @para  nPort[IN]         播放端口号(0~31)
* @para  nDataType[IN]     见PLAYM4_IOS_HD_OUTDATATYPE定义
* return err code or succ
* */
PLAYM4_API int __stdcall PLayM4_SetIOSHDOutPutDataType(int nPort, PLAYM4_IOS_HD_OUTDATATYPE nDataType);


/*@fun   PlayM4_SetHDPriority
* @brief 设置iOS硬解码（必须要在PlayM4_OpenFile/PlayM4_OpenStream之后，PlayM4_Play之前调用）
* @para  nPort[IN]         播放端口号(0~31)
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_SetHDPriority(int nPort);


/*@fun    PlayM4_SetDisplayEngine
* @brief  设置iOS视频渲染引擎（必须要在PlayM4_GetPort之后，PlayM4_OpenFile/PlatM4_OpenStream之前调用）
* @para   nPort[IN]            播放端口号(0~31)
* @param  nDisplayEngine[IN]   见PLAYM4_IOS_RENDER_ENGINE_XX宏定义，默认值nDisplayEngine默认为PLAYM4_IOS_RENDER_ENGINE_METAL
* return  err code or succ
* */
PLAYM4_API int __stdcall PlayM4_SetDisplayEngine(int nPort,  unsigned int nDisplayEngine);


/*@fun    PlayM4_SetCheckMultiSliceFlag
* @brief  是否做多Slice码流检测(仅仅针对iOS硬解码)
* @para   nPort[IN]            播放端口号(0~31)
* @param  bCheckFlag[IN]       false/true
* return  err code or succ
* */
PLAYM4_API int __stdcall PlayM4_SetCheckMultiSliceFlag(int nPort, bool bCheckFlag);


/*@fun    PlayM4_CloseAudioDevice
* @brief  停止音频播放，并且设置iOS AudioSessionActive(false)
* @para   nPort[IN]            播放端口号(0~31)
* @param  bCloseFlag[IN]       不涉及
* return  err code or succ
* */
PLAYM4_API int __stdcall PlayM4_CloseAudioDevice(int nPort, bool bCloseFlag);


/*@fun    PlayM4_SetAudioSessionInit
* @brief  设置iOS AudioSession由外部还是播放库内部初始化
* @para   nPort[IN]            播放端口号(0~31)
* @param  init[IN]             0 ～ 内部不初始化 / 1 ～ 内部初始化 （如果不调用，默认内部初始化）
* return  err code or succ
* */
PLAYM4_API int __stdcall PlayM4_SetAudioSessionInit(int nPort , const int init);


/*@fun    PlayM4_SetAudioUnitMode
* @brief  设置iOS AudioUnit模式
* @para   nPort[IN]            播放端口号(0~31)
* @param  nAUMode[IN]          0 ～ RemoteIO模式（如果不调用，默认内部采用此模式） / 1 ～ VOIP模式
* return  err code or succ
* */
PLAYM4_API int __stdcall PlayM4_SetAudioUnitMode(int nPort , const int nAUMode);


/*@fun    PlayM4_ClearGLRenderResource
* @brief  1: 释放OpenGLES的渲染资源，需在主线程调用，由上层控制调用时机
*         2:（规避iOS老旧设备退后台时因性能不够，释放播放库资源不及时，在后台调用了OpenGLES的API，最终导致崩溃的问题）
* @para   nPort[IN]            播放端口号(0~31)
* return  err code or succ
* */
PLAYM4_API int __stdcall PlayM4_ClearGLRenderResource(int nPort);


/*@fun   PlayM4_SetAudioSessionCategory
* @brief 由外部设置会话模式
* @para  nPort[IN]            播放端口号
* @para  enAUCategory[IN]     会话模式见PLAYM4_ENUM_AU_CATEGORY定义
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_SetAudioSessionCategory(int nPort, PLAYM4_ENUM_AU_CATEGORY nAUCategory);


/*@fun   PlayM4_RegisterDrawFun
* @brief 注册绘图回调(用于iOS Flutter视频播放)
* @para  nPort[IN]        播放端口号(0~31)
* @para  nSubPort[IN]     子端口号 (0~5,其中0为原始画面子端口 1为电子放大Or画中画子端口 2～5为鱼眼子端口)
* @para  DrawFun[IN]      绘图回调函数指针
* @para  pUser[IN]        用户指针
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_RegisterDrawFun(int nPort,
                                                int nSubPort,
                                                void (CALLBACK* DrawFun)(int nSubPort,PLAYM4_HDC hDc,void* pUser),
                                                void* pUser);

/*@fun   PlayM4_RegisterDrawFunEx
* @brief 注册绘图回调(用于iOS Flutter视频播放)
* @para  nPort[IN]        播放端口号(0~31)
* @para  nSubPort[IN]     子端口号 (0~5,其中0为原始画面子端口 1为电子放大Or画中画子端口 2～5为鱼眼子端口)
* @para  DrawFunEx[IN]     绘图回调函数指针
* @para  pUser[IN]        用户指针
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_RegisterDrawFunEx(int nPort,
                                                  int nSubPort,
                                                  void (CALLBACK* DrawFunEx)(PLAYM4_FLUTTER_DRAW_INFO* pstDrawInfo,void* pUser),
                                                  void* pUser);


/*@fun   PlayM4_RegisterCVBufferCB
* @brief 注册CVPixelBuffer回调(用于iOS Flutter视频播放)
* @para  nPort[IN]        播放端口号(0~31)
* @para  nSubPort[IN]     子端口号 (0~5,其中0为原始画面子端口 1为电子放大Or画中画子端口 2～5为鱼眼子端口)
* @para  CVBufferFun[IN]  CVPixelBuffer-CallBack-Fun Pointer
* @para  pUser[IN]        用户指针
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_RegisterCVBufferCB(int nPort,
                               int nSubPort,
                               void (CALLBACK* CVBufferFun)(int nPort, int SubPort, void* pCVBuffer,void* pUser),
                               void* pUser);

/*@fun   PlayM4_RegisterCVBufferCBEx
* @brief 注册CVPixelBuffer回调(用于iOS Flutter视频播放)
* @para  nPort[IN]        播放端口号(0~31)
* @para  nSubPort[IN]     子端口号 (0~5,其中0为原始画面子端口 1为电子放大Or画中画子端口 2～5为鱼眼子端口)
* @para  CVBufferFun[IN]  CVPixelBuffer-CallBack-Fun Pointer
* @para  pUser[IN]        用户指针
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_RegisterCVBufferCBEx(int nPort,
                                                     int nSubPort,
                                                     void (CALLBACK* CVBufferFunEx)(PLAYM4_FLUTTER_CVBUFFER_INFO* pstCVBufferInfo, void* pUser),
                                                     void* pUser);

/*@fun   PlayM4_PlayOnIOSFlutter
* @brief 开启播放(用于iOS Flutter视频播放)
* @para  nPort[IN]          播放端口号(0~31)
* @para  nWidth[IN]         宽/iOS Flutter没有窗口，需要外部传入宽高
* @para  nHeight[IN]        高/iOS Flutter没有窗口，需要外部传入宽高
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_PlayOnIOSFlutter(int nPort,
                                                 unsigned int nWidth,
                                                 unsigned int nHeight);

/*@fun   PlayM4_MultiTrack_PlayOnIOSFlutter
* @brief 开启播放(用于iOS Flutter多轨视频播放)
* @para  nPort[IN]                  播放端口号(0~31)
* @para  playM4MultiTrackNum[IN]    取值0
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_MultiTrack_PlayOnIOSFlutter(int nPort, PlayM4_Multi_Track_Num playM4MultiTrackNum);

/*@fun   PlayM4_SetVideoWindowOnIOSFlutterEx
* @brief 设置宽高播放(用于iOS Flutter多轨视频播放)
* @para  nPort[IN]          播放端口号(0~31)
* @para  nWidth[IN]         宽/iOS Flutter没有窗口，需要外部传入宽高
* @para  nHeight[IN]        高/iOS Flutter没有窗口，需要外部传入宽高
* @para  nStreamId[IN]      视频轨道Id
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_SetVideoWindowOnIOSFlutterEx(int nPort,
                                                             unsigned int nWidth,
                                                             unsigned int nHeight,
                                                             unsigned int nStreamId);


/*@fun   PlayM4_SetVideoWindowOnIOSFlutter
* @brief 开启和关闭画中画播放(用于iOS Flutter视频播放)
* @para  nPort[IN]          播放端口号(0~31)
* @para  nRegionNum[IN]     nRegionNum(0～1)
* @para  bWndOn[IN]         true - 开启画中画 / false - 关闭画中画
* @para  nStreamId[IN]      视频轨道Id
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_SetVideoWindowOnIOSFlutter(int nPort,
                                                           unsigned int nRegionNum,
                                                           bool bWndOn,
                                                           unsigned int nStreamId = 0);


/*@fun   PlayM4_FEC_SetWndOnIOSFlutter
* @brief 开启鱼眼矫正窗口播放(用于iOS Flutter视频播放)
* @para  nPort[IN]          播放端口号(0~31)
* @para  nFishPort[IN]      鱼眼子端口nFishPort(2～5)
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_FEC_SetWndOnIOSFlutter(int nPort,
                                                       unsigned int nFishPort);


/*@fun   PlayM4_SetDisplayRegionOnIOSFlutter
* @brief 开启和关闭电子放大(用于iOS Flutter视频播放)
* @para  nPort[IN]          播放端口号(0~31)
* @para  nRegionNum[IN]     nRegionNum(0～1)
* @para  pSrcRect[IN]       电子放大区域(设置NULL，表示关闭电子放大)
* @para  nStreamId[IN]      视频轨道Id
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_SetDisplayRegionOnIOSFlutter(int nPort, 
                                                             unsigned int nRegionNum,
                                                             HKRECT* pSrcRect,
                                                             unsigned int nStreamId = 0);


/*@fun   PlayM4_SetDisplayRegionDSTOnIOSFlutter
* @brief 开启和关闭电子放大，用于窗口切割(用于iOS Flutter视频播放)
* @para  nPort[IN]          播放端口号(0~31)
* @para  nRegionNum[IN]     nRegionNum(0～1)
* @para  pSrcRect[IN]       电子放大区域(设置NULL，表示关闭电子放大)
* @para  nStreamId[IN]      视频轨道Id
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_SetDisplayRegionDSTOnIOSFlutter(int nPort, 
                                                                unsigned int nRegionNum,
                                                                HKRECT* pSrcRect,
                                                                unsigned int nStreamId = 0);

/* @fun   PlayM4_SetIOSHDDecCBOutType
*  @brief 1: 设置iOS硬解码解码回调输出数据类型(默认为NV12)。
*         2: 此接口只只用于iOS硬解码,必须在PlayM4_SetHDPriority之后调用，PlayM4_Play之前调用。
*         3: Android平台调用直接返回不支持错误码，iOS如果是软解直接返回不支持错误码。
* @para   nPort[IN]       播放端口号
* @para   nHDDecCBType    数据类型 见PLAYM4_ENUM_IOS_HD_DEC_CB_OUT_TYPE
* return  0 - fail or 1 - succ
* */
PLAYM4_API int __stdcall PlayM4_SetIOSHDDecCBOutType(int nPort, PLAYM4_ENUM_IOS_HD_DEC_CB_OUT_TYPE nHDDecCBType);

#ifdef __cplusplus
}
#endif

#endif 

