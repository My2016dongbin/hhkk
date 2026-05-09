/** @file    AndroidPlayM4.h
 *  @note    HangZhou Hikvision Software Co., Ltd. All Right Reserved.
 *  @brief   declaration of Android-PlayM4-Special-APIs
 *
 *  @author  HPC-MMT-MSDK
 *
 *  @version V7.4.2
 *  @date    2022/08/25
 *
 *  @note    Android播放库特有接口声明，跟iOS播放库共享的接口声明请参考MobilePlaySDKInterface.h
 */

#ifndef __ANDROID_PLAYM4_H__
#define __ANDROID_PLAYM4_H__

#include "MobilePlaySDKInterface.h"

#ifdef __cplusplus
extern "C"
{
#endif

/*@fun   PlayM4_SurfaceChanged
* @brief 创建或销毁窗口
* @para  nPort[IN]         播放端口号(0~31)
* @para  nRegionNum[IN]    窗口索引
* @para  hWnd[IN]          窗口句柄
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_SurfaceChanged(int nPort, unsigned int nRegionNum, PLAYM4_HWND hWnd, unsigned int nStreamId = 0);


/*@fun   PLAYM4_SetHDSurface
* @brief 设置Android硬解Surface  @Deprecated
* @para  nPort[IN]         播放端口号(0~31)
* @para  hWnd[IN]          硬解ANativeWindow
* return err code or succ
* */
PLAYM4_API int __stdcall  PLAYM4_SetHDSurface(int nPort, PLAYM4_HWND hWnd);


/*@fun   PlayM4_SetWindowTransparency
* @brief 设置透明度 @Deprecated
* @para  nPort[IN]           播放端口号(0~31)
* @para  fTransparency[IN]   透明度
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_SetWindowTransparency(int nPort, float fTransparency);


/*@fun   PlayM4_SwitchToHardDecode
* @brief 软解切换到硬解
* @para  nPort[IN]           播放端口号(0~31)
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_SwitchToHardDecode(int nPort,int nDecodeEngine = 1);


/*@fun   PlayM4_SwitchToSoftDecode
* @brief 硬解切换到软解
* @para  nPort[IN]           播放端口号(0~31)
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_SwitchToSoftDecode(int nPort);


/*@fun   PlayM4_SetDecodeEngine
* @brief 设置硬解码
* @para  nPort[IN]           播放端口号(0~31)
* @para  nDecodeEngine[IN]   0-软解/1-硬解
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_SetDecodeEngine(int nPort, unsigned int nDecodeEngine);

/*@fun   PlayM4_ReleaseWndFlag
* @brief 设置窗口释放flag @Deprecated
* @para  nPort[IN]           播放端口号(0~31)
* @para  bReleaseFlag[IN]    0-不释放/1-释放
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_ReleaseWndFlag(int nPort,int bReleaseFlag);

/*@fun   PlayM4_SetAudioTrackParam
* @brief 设置Android AudioTrack参数
* @para  nPort[IN]             播放端口号(0~31)
* @para  nAudioTrackMode[IN]   AudioTrack模式
* @para  nAudioSessionId[IN]   AudioTrack-Session-ID
* return err code or succ
* */
PLAYM4_API int __stdcall PlayM4_SetAudioTrackParam(int nPort, int nAudioTrackMode, int nAudioSessionId);


/*@fun   PlayM4_GetHDJPEG
* @brief Android硬解码抓图
* @para  nPort[IN]             播放端口号(0~31)
* @para  pJPEGBuf[IN]          JPEG抓图缓存
* @para  nJPEGBufSize[IN]      JPEG抓图缓存大小
* @para  nJPEGQuality[IN]      JPEG质量(0~100)
* @para  nShotWidth[IN]        JPEG抓图-宽
* @para  nShotHeight[IN]       JPEG抓图-高
* @para  pJPEGSize[OUT]        JPEG实际大小
* return err code or succ
* */
PLAYM4_API int __stdcall  PlayM4_GetHDJPEG(int nPort,
                                           unsigned char *pJPEGBuf,
                                           unsigned int nJPEGBufSize,
                                           int nJPEGQuality,
                                           int nShotWidth,
                                           int nShotHeight,
                                           unsigned int *pJPEGSize);

// 设置外部写码流路径 used for Android
int            PlayM4_ConfigureWriteDataPath(int nPort, const char* pWriteDataPath);

#ifdef __cplusplus
}
#endif

#endif 

