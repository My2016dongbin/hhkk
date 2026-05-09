/** @file       FormatConversionDefine.h
 *  @note       HangZhou Hikvision Digital Technology Co., Ltd. All Right Reserved.
 *  @brief      Definitions of interfaces of Media Format Conversion dynamic library
 *
 *  @author     Media Play SDK Team of Hikvision
 *
 *  @version    V4.1.6
 *  @date       2021/08/01
 *
 *  @warning
 */

#ifndef _FC_INTERFACE_H_
#define _FC_INTERFACE_H_

#include "FormatConversionDefine.h"

#ifdef __cplusplus
extern "C" {
#endif 

/** @fn     FC_GetSDKVersion(void)
 *  @brief  获取格式转换库版本号
 *  @param
 *  @return 版本号
 *  @note   [可选调用]
 */
FC_API unsigned int __stdcall FC_GetSDKVersion(void);


/** @fn     FC_CreateHandle()
 *  @brief  创建库句柄
 *  @param
 *  @return 成功返回有效句柄，失败返回NULL
 *  @note   [必须调用]
 */
FC_API FCHANDLE __stdcall FC_CreateHandle(void);


/** @fn     FC_DestroyHandle(const FCHANDLE hFC)
 *  @brief  销毁库句柄
 *  @param  hFC             [I]             - 库句柄
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [必须调用]
 */
FC_API int __stdcall FC_DestroyHandle(const FCHANDLE hFC);


/** @fn     FC_SetSourceSessionInfo(const FCHANDLE hFC, int nProtocolType, const FC_SESSION_INFO* pstSessionInfo)
 *  @brief  设置描述源数据流的交互信息
 *  @param  hFC             [I]             - 库句柄
 *          nProtocolType   [I]             - 网络协议类型
 *          pstSessionInfo  [I]             - 交互信息
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [流模式输入必须调用]
 */
FC_API int __stdcall FC_SetSourceSessionInfo(const FCHANDLE hFC, int nProtocolType, const FC_SESSION_INFO* pstSessionInfo);


/** @fn     FC_GetSourceMediaInfo(const FCHANDLE hFC, FC_MEDIA_INFO* pstSourceInfo)
 *  @brief  获取源数据的媒体信息
 *  @param  hFC             [I]             - 库句柄
 *          pstSourceInfo   [I|O]           - 描述源数据的媒体信息
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [流模式输入可选调用] 在设置交互信息成功后才能获取源数据的媒体信息
 */
FC_API int __stdcall FC_GetSourceMediaInfo(const FCHANDLE hFC, FC_MEDIA_INFO* pstSourceInfo);


/** @fn     FC_GetFileInfo(const FCHANDLE hFC, const char* szFilePath, FC_MEDIA_INFO* pstSourceInfo)
 *  @brief  获取文件信息
 *  @param  hFC             [I]             - 库句柄
            szFilePath      [I]             - 文件路径
            pstSourceInfo   [I|O]           - 文件信息
 *  @return 成功，返回FC_OK；失败，返回错误码
 *
 *  @note   [文件模式输入可选调用] 在获取句柄后即可调用
 */
FC_API int __stdcall FC_GetFileInfo(const FCHANDLE hFC, const char* szFilePath, FC_MEDIA_INFO* pstSourceInfo);


/** @fn     FC_SetTargetMediaInfo(const FCHANDLE hFC, const FC_MEDIA_INFO* pstTargetInfo)
 *  @brief  设置目标媒体信息
 *  @param  hFC             [I]             - 库句柄
 *          pstTargetInfo   [I]             - 目标媒体信息
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [必须调用]
 */
FC_API int __stdcall FC_SetTargetMediaInfo(const FCHANDLE hFC, const FC_MEDIA_INFO* pstTargetInfo);


/** @fn     FC_GetTargetSessionInfo(const FCHANDLE hFC, int nProtocolType, FC_SESSION_INFO* pstSessionInfo)
 *  @brief  获取描述目标数据流的交互信息
 *  @param  hFC             [I]             - 库句柄
 *          nProtocolType   [I]             - 网络协议类型
 *          pstSessionInfo  [I|O]           - 描述目标数据的交互信息
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [可选调用]
 */
FC_API int __stdcall FC_GetTargetSessionInfo(const FCHANDLE hFC, int nProtocolType, FC_SESSION_INFO* pstSessionInfo);


/** @fn     FC_SetDecryptKey(const FCHANDLE hFC, int nKeyType, const char* pKey, unsigned int nKeyLen)
 *  @brief  设置解密密钥
 *  @param  hFC             [I]             - 库句柄
 *          nKeyType        [I]             - 密钥类型，当前只支持AES加密
 *          pKey            [I]             - 密钥数据
 *          nKeyLen         [I]             - 密钥长度，单位bit，取值范围8-256
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [可选调用]
 */
FC_API int __stdcall FC_SetDecryptKey(const FCHANDLE hFC, int nKeyType, const char* pKey, unsigned int nKeyLen);

/** @fn     FC_SetEncryptKey(const FCHANDLE hFC, int nKeyType, const char* pKey, unsigned int nKeyLen)
 *  @brief  设置加密密钥
 *  @param  hFC             [I]             - 库句柄
 *          nKeyType        [I]             - 密钥类型，当前只支持AES加密
 *          pKey            [I]             - 密钥数据
 *          nKeyLen         [I]             - 密钥长度，单位bit，取值范围8-256
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [可选调用]
 */
FC_API int __stdcall FC_SetEncryptKey(const FCHANDLE hFC, int nKeyType, const char* pKey, unsigned int nKeyLen);

/** @fn    FC_SetPostProcInfo(const FCHANDLE hFC, int nPostProcType, void* pstPostProcData, unsigned int nPostProcDataLen)
*  @brief  设置后处理信息
*          硬转码时，该参数无效
*  @param  hFC              [I]            - 库句柄
*          nKeyType         [I]            - 后处理类型，目前支持FC_POSTPROCTYPE_OVERLAY_TEXT\FC_POSTPROCTYPE_OVERLAY_PPOS
*          pstPostProcData  [I]            - 后处理数据信息
*                                            nPostProcType为FC_POSTPROCTYPE_OVERLAY_TEXT，对应于FC_POS_INFO
*                                            nPostProcType为FC_POSTPROCTYPE_OVERLAY_PPOS，对应外部送入的字体库路径(路径长度不超过256字节)
*          nPostProcDataLen [I]            - 后处理信息长度，pstPostProcData的长度
*  @return 成功返回FC_OK，失败返回错误码
*
*  @note   [可选调用]
*/
FC_API int __stdcall FC_SetPostProcInfo(const FCHANDLE hFC, int nPostProcType, void* pstPostProcData, unsigned int nPostProcDataLen);

/** @fn     FC_RegisterTargetDataCallback(const FCHANDLE  hFC, 
 *                                        void(__stdcall* TargetDataCB)(unsigned int   nTrackIndex,
 *                                                                      unsigned int   nDataType,
 *                                                                      unsigned char* pData,
 *                                                                      unsigned int   nDataLen,
 *                                        void*           pUser)
 *  @brief  注册目标数据调函数
 *  @param  hFC             [I]             - 库句柄
 *          TargetDataCB    [I]             - 回调函数
 *          pUser           [I]             - 用户指针
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [流模式输出必须调用] 该接口只适用于目标数据为数据流的情况
 */
FC_API int __stdcall FC_RegisterTargetDataCallback(const FCHANDLE  hFC,
                                                   void(__stdcall* TargetDataCB)(unsigned int   nTrackIndex,
                                                                                 unsigned int   nDataType,
                                                                                 unsigned char* pData,
                                                                                 unsigned int   nDataLen,
                                                                                 void*          pUser),
                                                   void*           pUser);


/** @fn     FC_Start(const FCHANDLE hFC, const char* szSrcPath, const char* szTgtPath)
 *  @brief  开始转码
 *  @param  hFC             [I]             - 库句柄
 *          szSrcPath       [I]             - 源文件路径
 *          szTgtPath       [I]             - 目标文件路径
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [必须调用]
 */
FC_API int __stdcall FC_Start(const FCHANDLE hFC, const char* szSrcPath, const char* szTgtPath);


/** @fn     FC_Pause(const FCHANDLE hFC, unsigned int nPause)
 *  @brief  暂停转码
 *  @param  hFC             [I]             - 库句柄
 *          nPausse         [I]             - 暂停标记（1：暂停，0：恢复）
 *  @return 成功，返回FC_OK；失败，返回错误码
 *
 *  @note   [选择调用]
 */
FC_API int __stdcall FC_Pause(const FCHANDLE hFC, unsigned int nPause);


/** @fn     FC_Stop(const FCHANDLE hFC)
 *  @brief  停止转码
 *  @param  hFC             [I]              - 库句柄
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [必须调用] 流模式输入时在数据全部输入完毕后调用，文件模式输入时在获取进度为100%后调用
 */
FC_API int __stdcall FC_Stop(const FCHANDLE hFC);


/** @fn     FC_InputSourceData(const FCHANDLE hFC, FC_DataType enType, const unsigned char* pData, unsigned int nDataLen)
 *  @brief  输入数据
 *  @param  hFC             [I]             - 库句柄
 *          enType          [I]             - 流数据类型；
 *          pData           [I]             - 流数据指针；
 *          nDataLen        [I]             - 流数据长度
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [流模式输入必须调用]
 */
FC_API int __stdcall FC_InputSourceData(const FCHANDLE hFC, FC_DataType enType, const unsigned char* pData, unsigned int nDataLen);


/** @fn     FC_GetProgress(const FCHANDLE hFC, float* pfPercent)
 *  @brief  获取进度
 *  @param  hFC             [I]             - 库句柄
 *          pfPercent       [I|O]           - 当前进度百分比
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [可选调用]
 */
FC_API int __stdcall FC_GetProgress(const FCHANDLE hFC, float* pfPercent);

/** @fn     FC_SetCoverRegion(const FCHANDLE hFC, unsigned int nHSections, unsigned int nVSections, unsigned int* pCoverRegionArray)
 *  @brief  设置涂黑区域
 *  @param  hFC                 [I]             - 库句柄
 *          nHSections          [I]             - 水平切割的数目
            nVSections          [I]             - 垂直切割的数目
            pCoverRegionArray   [I]             - 标志切割分块是否涂黑的数组，对应涂黑处置1，不修改处置0，数组大小为nHSections * nVSections
 *  @return 成功返回FC_OK，失败返回错误码
 *
 *  @note   [可选调用]
 */
FC_API int __stdcall FC_SetCoverRegion(const FCHANDLE hFC, unsigned int nHSections, unsigned int nVSections, unsigned int* pCoverRegionArray);

#ifdef __cplusplus
}
#endif 

#endif //_FC_INTERFACE_H_
