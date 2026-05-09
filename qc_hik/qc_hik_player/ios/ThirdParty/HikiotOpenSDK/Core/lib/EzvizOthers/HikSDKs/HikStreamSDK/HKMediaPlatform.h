#ifndef _HK_MEDIA_PLATFORM_H_
#define _HK_MEDIA_PLATFORM_H_

#include "HKMediaPlatformDefine.h"

///<初始化
MPFORM_API int __stdcall MPFORM_GetPort(int* nPort);
MPFORM_API int __stdcall MPFORM_FreePort(int nPort);

MPFORM_API int __stdcall MPFORM_SetDataCallBack(int nPort, int nCBType, MPFORM_DataCallback fnDataCB, void* pUser);
///< 运行时报错, MPFORM_OpenURL前设置
MPFORM_API int __stdcall MPFORM_SetRunTimeInfoCallBack(int nPort, MPFORM_RunTimeInfoCBFun fRunTimeInfoCB, void* pUser);
MPFORM_API int __stdcall MPFORM_OpenURL(int nPort, char* pURL);
MPFORM_API int __stdcall MPFORM_CloseURL(int nPort);

// 临时接口,是否只有音频.内部默认false
MPFORM_API int __stdcall MPFORM_AudioOnly(int nPort, int bTrue);


/////////当前版本以下接口不支持/////////////////////
///<播放控制
MPFORM_API int __stdcall MPFORM_Play(int nPort, HWND hWnd);
MPFORM_API int __stdcall MPFORM_Stop(int nPort);

///<声音播放
MPFORM_API int __stdcall MPFORM_PlaySound(int nPort);
MPFORM_API int __stdcall MPFORM_StopSound();
MPFORM_API int __stdcall MPFORM_SetVolume(int nPort,int nVolume);
MPFORM_API int __stdcall MPFORM_GetVolume(int nPort);
MPFORM_API int __stdcall MPFORM_GetJPEG(int nPort, unsigned char* pJpeg, unsigned int nBufSize, unsigned int* pJpegSize);

#define SOFT_DECODE_ENGINE 0 ///<软解码
#define HARD_DECODE_ENGINE 1 ///<硬解码

MPFORM_API int  __stdcall MPFORM_SetDecodeEngine(int nPort, int nDecodeEngine);
MPFORM_API int  __stdcall MPFORM_GetDecodeEngine(int nPort);

///<显示 电子放大
MPFORM_API int __stdcall MPFORM_SetDisplayRegion(int nPort,int nRegionNum, MPFORM_RECT *pSrcRect, HWND hDestWnd, int bEnable);

#endif //_MPFORM_H_
;