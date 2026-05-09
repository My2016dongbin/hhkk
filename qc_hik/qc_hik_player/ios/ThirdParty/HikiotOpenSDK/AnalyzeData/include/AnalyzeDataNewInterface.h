/** @file      AnalyzeDataNewInterface.h
*  @note       Hikvision Digital Technology Co., Ltd. All Right Reserved.
*  @brief      帧分析库接口头文件
*
*  @version    V5.1.1.5
*  @author     余翔5
*  @date       2021/7/2
*  @note       架构重组
*/

#ifndef _ANALYZEDATA_NEW_INTERFACE_H_
#define _ANALYZEDATA_NEW_INTERFACE_H_

#include "AnalyzeDataDefine.h"

#ifdef __cplusplus
extern "C" 
{
#endif

    /** @fn ANALYZEDATA_API void * __stdcall HIKANA_CreateStreamEx(unsigned long dwSize, unsigned char * pHeader)
     *  @brief  <以流或者文件流形式创建分析句柄>
     *  @param  dwSize  [IN] 内部解析缓存大小（默认2M）
     *  @param  pHeader [IN] hik40字节hik头，如果为null表示为无头模式
     *  @return 生成的解析句柄：非空指针，其他值表示错误
     */
    ANALYZEDATA_API void * __stdcall HIKANA_CreateStreamEx(unsigned long dwSize, unsigned char * pHeader);

    /** @fn ANALYZEDATA_API void   __stdcall HIKANA_Destroy(void * hHandle)
     *  @brief  <释放解析句柄资源>
     *  @param  hHandle  [IN] 解析句柄
     *  @return 无
     */
    ANALYZEDATA_API void   __stdcall HIKANA_Destroy(void * hHandle);

    /** @fn ANALYZEDATA_API int   __stdcall HIKANA_InputData(void * hHandle, unsigned char * pBuffer, unsigned long dwSize)
     *  @brief  <输入需要分析的数据，3gp文件不支持调用>
     *  @param  hHandle  [IN] 分析句柄
     *  @param  pBuffer  [IN] 送入数据地址
     *  @param  dwSize   [IN] 送入数据大小
     *  @return 成功返回1，其他返回值表示错误
     */
    ANALYZEDATA_API int   __stdcall HIKANA_InputData(void * hHandle, unsigned char * pBuffer, unsigned long dwSize);

    /** @fn ANALYZEDATA_API int    __stdcall HIKANA_GetOnePacketEx(void * hHandle, PACKET_INFO_EX* pstPacket)
     *  @brief  获取分析得到的一帧数据>
     *  @param  hHandle   [IN] 分析句柄
     *  @param  pstPacket [IN:OUT] 帧信息结构体
     *  @return 成功得到一帧数据返回0，其他返回值表示错误，如果为数据不够需要继续input数据，可以调用HIKANA_GetLastErrorH获取错误类型
     */
    ANALYZEDATA_API int    __stdcall HIKANA_GetOnePacketEx(void * hHandle, PACKET_INFO_EX* pstPacket);

    /** @fn ANALYZEDATA_API int   __stdcall HIKANA_ClearBuffer(void * hHandle)
     *  @brief  <清除解析缓存里面的数据>
     *  @param  hHandle   [IN] 解析句柄
     *  @return 成功返回0，其他返回值表示错误
     */
    ANALYZEDATA_API int   __stdcall HIKANA_ClearBuffer(void * hHandle);

    /** @fn ANALYZEDATA_API int __stdcall HIKANA_GetRemainData(void * hHandle, unsigned char* pData, unsigned long* pdwSize)
     *  @brief  <获取解析缓存里面的剩余数据>
     *  @param  hHandle   [IN] 解析句柄
     *  @param  pData     [IN] 外部缓存指针
     *  @param  pdwSize   [IN:OUT] 外部缓存大小送入，输出值为获取得到的解析缓存里面的剩余数据大小
     *  @return 成功返回0，其他返回值表示错误，可以调用HIKANA_GetLastErrorH获取错误类型；最多能获取外部缓存大小的数据
     */
    ANALYZEDATA_API int    __stdcall HIKANA_GetRemainData(void * hHandle, unsigned char* pData, unsigned long* pdwSize);

    /** @fn ANALYZEDATA_API int __stdcall HIKANA_SetAnalyzeFrameType(void * hHandle, unsigned int nType)
     *  @brief  <设置分析帧类型>
     *  @param  hHandle   [IN] 分析句柄
     *  @param  nType     [IN] 只对svc码流有效 (在头文件AnalyzeDataDefine.h定义的0~3解析类型)
     *  @return 成功返回0，其他返回值表示错误，可以调用HIKANA_GetLastErrorH获取错误类型；
     */
    ANALYZEDATA_API int    __stdcall HIKANA_SetAnalyzeFrameType(void * hHandle, unsigned int nType);

    /** @fn ANALYZEDATA_API int   __stdcall HIKANA_SetOutputPacketType(void * hHandle， unsigned int nType); 
     *  @brief  <设置输出帧是否为带封装或者裸数据>
     *  @param  hHandle   [IN] 分析句柄
     *  @param  nType     [IN] 输出帧类型(ANALYZE_ENCAPSULATED_DATA: 带封装，ANALYZE_RAW_DATA：裸数据)
     *  @return 成功返回0，其他返回值表示错误可以调用HIKANA_GetLastErrorH获取错误类型；对于rtp、3gp封装只能得到裸数据
     */
    ANALYZEDATA_API int   __stdcall HIKANA_SetOutputPacketType(void * hHandle, unsigned int nType); 

    /**	@fn	ANALYZEDATA_API int   __stdcall HIKANA_RegistStreamInforCB(void * hHandle, 
                                            void (__stdcall * pErroeInforCB)(ANA_ERROR_INFOR* pErrorInfor, void* pUser),
                                            void* pUser); 
     *  @brief  <码流错误信息回调>
     *  @param  hHandle           [IN]  分析句柄
     *  @param  pErroeInforCB     [IN]  回调函数
     *  @param  pErrorInfor       [OUT] 回调错误类型
     *  @param	pUser             [OUT] 用户信息
        @param  pUser             [IN]  用户信息    
     *  @return 成功返回0，其他返回值表示错误可以调用HIKANA_GetLastErrorH获取错误类型；
     */
    ANALYZEDATA_API int __stdcall HIKANA_RegistStreamInforCB(void * hHandle, 
                                 void (__stdcall * pErroeInforCB)(ANA_ERROR_INFOR* pErrorInfor, void* pUser),
                                 void* pUser);

    /** @fn ANALYZEDATA_API unsigned int  __stdcall HIKANA_GetLastErrorH(void * hHandle)
     *  @brief  <获取上一个错误值>
     *  @param  hHandle   [IN] 分析句柄
     *  @return 上一个错误的错误类型
     */
    ANALYZEDATA_API unsigned int  __stdcall HIKANA_GetLastErrorH(void * hHandle);

    /** @fn       ANALYZEDATA_API int __stdcall HIKANA_GetVersion();
     * @brief     <获取当前版本>
     * @param     无
     * @note     |baseline|build  year(0~31)|month(1~12)|date(1~31) |major  |minor |modify |test|
                   2bits       5bits          4bits         5bits     4bits   4bits  4bits  4bits
     * @return   返回int型值，不同2进制位代表是否基线、编译日期、版本等信息
     */
    ANALYZEDATA_API int __stdcall HIKANA_GetVersion();

    /** @fn ANALYZEDATA_API void * __stdcall HIKANA_CreateHandleByPath(unsigned long dwSize, const char * szFilePath)
    *   @brief  <3gp文件通过文件路径创建句柄>
    *   @param  dwSize     [IN] 设定内部解析缓存大小（默认2M）
    *   @param  szFilePath [IN] 文件路径
    *   @return 生成的解析句柄：非空指针，其他值表示错误；该接口只支持3gp封装视频文件解析，其他封装暂不支持调用该接口创建句柄
    */
    ANALYZEDATA_API void * __stdcall HIKANA_CreateHandleByPath(unsigned long dwSize, const char * szFilePath);


    /** @fn ANALYZEDATA_API int   __stdcall HIKANA_GetFileInfo(void * hHandle, ANA_FILE_INFO * pstFileInfo); 
     *  @brief  <获取文件信息，只支持MP4文件解析>
     *  @param  hHandle     [IN] 分析句柄
     *  @param  pstFileInfo [IO] 输出的文件信息
     *  @return 成功返回0，其他返回值表示错误可以调用HIKANA_GetLastErrorH获取错误类型；
     */
    ANALYZEDATA_API int __stdcall HIKANA_GetFileInfo(void * hHandle, ANA_FILE_INFO * pstFileInfo);


    /** @fn ANALYZEDATA_API int   __stdcall HIKANA_SetLocationType(void * hHandle， IDMX_SEEK_INFO pstSeekInfo); 
     *  @brief  <设置输出帧是否为带封装或者裸数据>
     *  @param  hHandle       [IN] 分析句柄
     *  @param  pstSeekInfo   [IN] 默认0，不定位，1帧号定位，2时间戳定位)
     *  @return 成功返回0，其他返回值表示错误可以调用HIKANA_GetLastErrorH获取错误类型；
     */
    ANALYZEDATA_API int   __stdcall HIKANA_SetLocationType(void * hHandle, ANA_SEEK_INFO pstSeekInfo); 

#ifdef __cplusplus 
}	
#endif	



#endif//end _ANALYZEDATA_NEW_INTERFACE_H_