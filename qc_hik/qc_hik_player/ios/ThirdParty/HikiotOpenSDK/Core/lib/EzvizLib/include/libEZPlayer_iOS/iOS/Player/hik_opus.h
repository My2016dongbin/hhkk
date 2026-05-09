/*******************************************************************************************************************************
* 
* 版权信息：版权所有 (c) 2015, 杭州海康威视软件有限公司, 保留所有权利
* 
* 文件名称：hik_opus.h
* 摘    要：海康威视音频opus编解码接口声明头文件
*
* 当前版本：1.0.3
* 作    者：杨杰24
* 日    期：2020年4月24日
* 备    注：开源扫描整改
*
* 当前版本：1.0.2
* 作    者：杨茜6
* 日    期：2016年12月28日
* 备    注：修改输出点数
*
* 当前版本：1.0.1
* 作    者：杨茜6
* 日    期：2016年7月21日
* 备    注：修改部分接口文件中不合规范的部分
*
* 当前版本：1.0.0
* 作    者：杨茜6
* 日    期：2015年11月24日
* 备    注：
*******************************************************************************************************************************/


#ifndef _HIK_OPUS_H_
#define _HIK_OPUS_H_

#ifdef __cplusplus
extern "C" {
#endif

#include "datatypedef.h"
#include "mem_tab.h"
#include "audio_codec_common.h"

/*******************************************************************************************************************************
*文件版本和时间宏声明
*******************************************************************************************************************************/
/* 当前版本号*/
/* 主版本号，接口改动、功能增加、架构变更时递增，最大63 */
#define HIK_OPUSDEC_MAJOR_VERSION              1
/* 子版本号，性能优化、局部结构调整、模块内集成其他库的主版本提升时递增，最大31 */
#define HIK_OPUSDEC_SUB_VERSION                0
/* 修正版本号，修正bug后递增，最大31 */
#define HIK_OPUSDEC_REVISION_VERSION           3
/* 版本日期*/
#define HIK_OPUSDEC_VER_YEAR                   20           /* 年*/
#define HIK_OPUSDEC_VER_MONTH                  4           /* 月*/
#define HIK_OPUSDEC_VER_DAY                    24           /* 日*/


#define			HIK_OPUSDEC_LIB_E_INDATA_UNDERFLOW			    0x81000000
#define  		HIK_OPUSDEC_LIB_E_INVALID_POINTER               0x81000001
#define  		HIK_OPUSDEC_LIB_E_INVALID_ADTS_HEADER           0x81000002
#define 		HIK_OPUSDEC_LIB_E_INVALID_ADIF_HEADER           0x81000003
#define 		HIK_OPUSDEC_LIB_E_INVALID_FRAME                 0x81000004
#define 		HIK_OPUSDEC_LIB_E_SYNTAX_ELEMENT                0x81000005
#define 		HIK_OPUSDEC_LIB_E_DEQUANT                       0x81000006
#define 		HIK_OPUSDEC_LIB_E_STEREO_PROCESS                0x81000007
#define 		HIK_OPUSDEC_LIB_E_PNS                           0x81000008
#define 		HIK_OPUSDEC_LIB_E_SHORT_BLOCK_DEINT             0x81000009
#define 		HIK_OPUSDEC_LIB_E_MDCT                          0x8100000a
#define 		HIK_OPUSDEC_LIB_E_IMDCT                         0x8100000b
#define 		HIK_OPUSDEC_LIB_E_FRAME_LEN  		            0x8100000c
#define 		HIK_OPUSDEC_LIB_E_SIGNAL_TYPE  		            0x8100000d 
#define 		HIK_OPUSDEC_LIB_E_REPACKET  					0x8100000e
#define 		HIK_OPUSDEC_LIB_E_BAND_WIDTH  					0x8100000f
#define 		HIK_OPUSDEC_LIB_E_INVALID_PACKET  			    0x81000010
#define 		HIK_OPUSDEC_LIB_E_CUT_FREQUENCY  			    0x81000011
#define 		HIK_OPUSDEC_LIB_E_INVALID_CBR_SETTIN  		    0x81000012
#define 		HIK_OPUSDEC_LIB_E_SILK  					    0x81000013
#define 		HIK_OPUSDEC_LIB_E_SILK_SAMPLERATE  			    0x81000014
#define 		HIK_OPUSDEC_LIB_E_SILK_FRAME_LEN  			    0x81000015
#define 		HIK_OPUSDEC_LIB_E_SILK_FILTER_COEF   		    0x81000016
#define 		HIK_OPUSDEC_LIB_E_SILK_FILTER_ORDER   		    0x81000017
#define 		HIK_OPUSDEC_LIB_E_SILK_SUB_NUM  		        0x81000018
#define 		HIK_OPUSDEC_LIB_E_SILK_PARAM  		            0x81000019
#define 		HIK_OPUSDEC_LIB_E_SILK_LTP  		            0x8100001a
#define 		HIK_OPUSDEC_LIB_E_SILK_LPC 		                0x8100001b
#define 		HIK_OPUSDEC_LIB_E_SILK_NSQ  		            0x8100001c
#define 		HIK_OPUSDEC_LIB_E_CELT  					    0x8100001d
#define 		HIK_OPUSDEC_LIB_E_CELT_RATE  		            0x8100001e
#define 		HIK_OPUSDEC_LIB_E_CELT_PVQ  		            0x8100001f
#define 		HIK_OPUSDEC_LIB_E_CELT_PVQ_ENC  		        0x81000020
#define 		HIK_OPUSDEC_LIB_E_CELT_PVQ_DEC  		        0x81000021
#define 		HIK_OPUSDEC_LIB_E_UNKNOWN					    0x81000022

	

/*******************************************************************************************************************************
* 功  能：获取编码一帧输入数据大小
*
* 参  数：info_param   -IO   信息结构指针
*
* 返回值：返回状态码
*******************************************************************************************************************************/
HRESULT HIK_OPUSENC_GetInfoParam(AUDIOENC_INFO *info_param);
/*******************************************************************************************************************************
* 功  能：获取所需内存大小
*
* 参  数：enc_param   -I   参数结构指针
*         mem_tab     -IO  内存申请表
*
* 返回值：返回状态码
*******************************************************************************************************************************/
HRESULT HIK_OPUSENC_GetMemSize(AUDIOENC_PARAM *enc_param, MEM_TAB *mem_tab);
/*******************************************************************************************************************************
* 功  能：创建OPUS编码模块
*
* 参  数： enc_param       -I  编码参数
*          mem_tab         -I  内存申请表
*          handle          -IO 句柄        
*
* 返回值：返回状态码
*******************************************************************************************************************************/
HRESULT HIK_OPUSENC_Create(AUDIOENC_PARAM *enc_param, MEM_TAB *mem_tab, void **handle);
/*******************************************************************************************************************************
* 功  能：OPUS编码模块
*
* 参  数：hEncoder         -I  编码句柄
*         process_param    -IO 处理参数
*
* 返回值：返回状态码
*******************************************************************************************************************************/
HRESULT HIK_OPUSENC_Encode(void* hEncoder, AUDIOENC_PROCESS_PARAM *process_param);
/*******************************************************************************************************************************
* 功  能：获取所需内存大小
*
* 参  数：param       -I   参数结构指针
*         mem_tab     -IO  内存申请表
*
* 返回值：返回状态码
*******************************************************************************************************************************/
HRESULT HIK_OPUSDEC_GetMemSize(AUDIODEC_PARAM *param, MEM_TAB *mem_tab);

/*******************************************************************************************************************************
* 功  能：创建OPUS解码模块
*
* 参  数： param           -I  编码参数
*          mem_tab         -I  内存申请表
*          handle          -IO 句柄        
*
* 返回值：返回状态码
*******************************************************************************************************************************/
HRESULT HIK_OPUSDEC_Create(AUDIODEC_PARAM *param, MEM_TAB *mem_tab, void **handle);

/*******************************************************************************************************************************
* 功  能：OPUS解码
*
* 参  数：handle           -I  编码句柄
*         process_param    -IO 处理参数
*
* 返回值：返回状态码
*******************************************************************************************************************************/
HRESULT	HIK_OPUSDEC_Decode(void *handle, AUDIODEC_PROCESS_PARAM *proc_param);

/*******************************************************************************************************************************
* 功  能：获取当前编码版本信息
*
* 参  数：无
*
* 返回值：返回版本信息
*
* 备  注：版本信息格式为：版本号＋年（7位）＋月（4位）＋日（5位）
*         其中版本号为：主版本号（6位）＋子版本号（5位）＋修正版本号（5位）
*******************************************************************************************************************************/
U32 HIK_OPUSCODEC_GetVersion();

#ifdef __cplusplus
}
#endif

#endif