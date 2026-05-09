#ifndef _HK_MEDIA_PLATFORM_DEFINE_H_
#define _HK_MEDIA_PLATFORM_DEFINE_H_


#ifdef WIN32
#if defined(_WINDLL)
#define MPFORM_API  __declspec(dllexport)
#else
#define MPFORM_API  __declspec(dllimport)
#endif
#else
#ifndef __stdcall
#define __stdcall
#endif

#ifndef MPFORM_API
#define  MPFORM_API
typedef void * HWND;
#endif
#endif


//Max channel numbers
#define MPFORM_MAX_SUPPORTS 500

//Error code Platform
#define  MPFORM_NOERROR                         0   //no error
#define  MPFORM_PARA_ERROR                      1   //input parameter is invalid;
#define  MPFORM_ORDER_ERROR                     2   //The order of the function to be called is error.
#define  MPFORM_ALLOCMEM_ERROR                  3   //Allocate memory failed.
#define  MPFORM_BUF_OVER                        4   //buffer is overflow.
#define  MPFORM_SYS_NOTSUPPORT                  5   //System not support.
#define  MPFORM_INVALID_PORT                    6   //
//Error code NPC
#define  MPFORM_STREAM_CLOSE                    101   //
#define  MPFORM_TRACK_CLOSE                     102   //
#define  MPFORM_NPCCREATE_ERROR                 103   //
#define  MPFORM_TRSCREATE_ERROR                 104   //
#define  MPFORM_FAIL_UNKNOWN                    9999  //Fail, but the reason is unknown;

///////////////数据回调/////////////////////////////////////////////////////////////////////////
typedef void(__stdcall *MPFORM_DataCallback)(int nPort, int nType, unsigned char* pData, unsigned int nDataLen, void* pUser);
/////////////////////////////////////////////////////////////////////////////////////////////////


typedef struct
{
    unsigned int      nErrorCode;         ///< 错误码
    unsigned char*    pMsg;               ///< 错误的字符描述
    unsigned int      nMsgLen;            ///< 字符描述长度

    unsigned char*    pReserved[12];     ///< 保留字节
    unsigned char     nReserved[12];     ///< 保留字节
}MPFORM_RunTimeInfo;

typedef void (__stdcall* MPFORM_RunTimeInfoCBFun)(int nPort, MPFORM_RunTimeInfo* pstRunTimeInfo, void* pUser);


///< 需要回调的数据类型
typedef enum MPFORM_DataCBType
{
    MPFORM_RAW_DATA    = 0x01,     ///< 裸数据回调
    MPFORM_PACK_DATA   = 0x02,     ///< 封装数据回调
};

typedef enum MPFORM_Data_Type
{
    MPFORM_DATA_HEAD      = 0x01,   ///< 海康40字节媒体信息头
    MPFORM_DATA_VIDEO     = 0x02,   ///< 视频数据包
    MPFORM_DATA_AUDIO     = 0x03,   ///< 音频数据包
    MPFORM_DATA_PRIVA     = 0x04,   ///< 私有数据包
};

typedef struct MPFORM_RECT
{
    unsigned int    nLeft;
    unsigned int    nTop;
    unsigned int    nRight;
    unsigned int    nRottom;
} MPFORM_RECT;

#endif //_MPFORM_H_
