#ifndef __HPR_ERROR_H__
#define __HPR_ERROR_H__

#include "HPR_Config.h"
#include "HPR_Types.h"

#define HPR_ERROR_BASE 40000

#define HPR_EPERM		(HPR_ERROR_BASE+1)	//权限不足
#define HPR_EBADARG		(HPR_ERROR_BASE+2)	//参数不合法
#define HPR_EDISORDER	(HPR_ERROR_BASE+3)	//调用顺序不对
#define HPR_ENORESOURCE	(HPR_ERROR_BASE+4)	//资源不足
#define HPR_ENOMEM		(HPR_ERROR_BASE+5)	//没有内存
#define HPR_EWOULDBLOCK	(HPR_ERROR_BASE+6)	//暂时不能完成，需要重试
#define HPR_ETIMEO		(HPR_ERROR_BASE+7)	//超时
#define HPR_EEOF		(HPR_ERROR_BASE+8)	//EOF
#define HPR_EBUSY		(HPR_ERROR_BASE+9)	//系统忙
#define HPR_EINIT		(HPR_ERROR_BASE+10)	//初始化错误
#define HPR_ENOTFOUND	(HPR_ERROR_BASE+11)	//没有找到
#define HPR_EBADPATH	(HPR_ERROR_BASE+12)	//路径错误
#define HPR_EBADIP		(HPR_ERROR_BASE+13)	//不合法的IP地址
#define HPR_EBADMASK	(HPR_ERROR_BASE+14)	//无效掩码
#define HPR_EINVALIDSOCK (HPR_ERROR_BASE+15)//无效套接字
#define HPR_ESOCKET		(HPR_ERROR_BASE+16)	//套接字出错
#define HPR_ESOCKCLOSE	(HPR_ERROR_BASE+17)	//套接字关闭

HPR_INT32 HPR_InitError_Inter();

HPR_INT32 HPR_FiniError_Inter();

/**
 * HPR_GetLastError 获取该线程最后的错误码 mod by zhourui9 2018/09/04
 * @return 错误码值.
 * @note 使用此功能前，必须先调用HPR_Init进行初始化，该错误码存在线程局部存储中，线程安全
 */
HPR_DECLARE HPR_UINT32 CALLBACK HPR_GetLastError();

/**
 * HPR_GetLastError 设置该线程最后的错误码 mod by zhourui9 2018/09/04
 * @return 0:成功 -1:失败
 * @note 使用此功能前，必须先调用HPR_Init进行初始化，该错误码存在线程局部存储中，线程安全
 */
HPR_DECLARE HPR_UINT32 CALLBACK HPR_SetLastError(HPR_UINT32 nErrno);

HPR_DECLARE HPR_UINT32 CALLBACK HPR_GetSystemLastError();

HPR_DECLARE HPR_VOID CALLBACK HPR_SetSystemLastError(HPR_UINT32 nError);

HPR_DECLARE char* CALLBACK HPR_GetSystemErrorString(HPR_INT32 nError);

#endif

