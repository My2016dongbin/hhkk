#ifndef __HPR_MEMORY_POOL_GLOBAL_H__
#define __HPR_MEMORY_POOL_GLOBAL_H__

/** @file	HPR_MemoryPoolGlobal.h
 *  @note   HangZhou Hikvision System Technology Co., Ltd. All Right Reserved.
 *  @brief 	全局内存池
 *	
 *  @author zhourui9
 *  @data   2018/09/04
 * 
 *	@note 内部封装了多个不同单位的变长内存池，多个程序可共同使用该接口，使得内存整体得到有效控制
 *	@note 被回收的内存块1分钟空闲自动回收，每次分配支持的最大内存为10MB
 *	@note 
 *
 *  @warning 这里填写本文件相关的警告信息
 */

#include "HPR_Config.h"
#include "HPR_Types.h"

HPR_INT32 HPR_InitMemoryPool_Inter(HPR_SIZE maxBytes);

HPR_INT32 HPR_FiniMemoryPool_Inter(void);


/**
 * HPR_MemoryPoolGlobal_Init 全局内存池初始化
 * @param bytes (IN) 最大总分配大小(单位字节)
 * @return HPR_TRUR：成功；HPR_FALSE：失败(已被初始化)
 * @note 调用HPR_fini时会自动反初始化,最大总内存限制为32位:2G；64位:5G;设置值超过限制值时会被强制等于限制值
 */
HPR_DECLARE HPR_BOOL CALLBACK HPR_MemoryPoolGlobal_Init(HPR_SIZE maxBytes);

/**
 * HPR_MemoryPoolGlobal_Alloc 分配一个块
 * @param bytes (IN) 分配大小(单位字节)
 * @return 块地址指针
 */
HPR_DECLARE HPR_VOIDPTR CALLBACK HPR_MemoryPoolGlobal_Alloc(HPR_SIZE bytes);

/**
 * HPR_MemoryPoolGlobal_Free 释放一个块
 * @param ptr (IN) 块指针
 * @return
 */
HPR_DECLARE HPR_VOID CALLBACK HPR_MemoryPoolGlobal_Free(HPR_VOIDPTR ptr);

/**
 * HPR_MemoryPoolGlobal_Size 获取当前内存占用大小
 * @return 内存占用大小(单位字节)
 */
HPR_DECLARE HPR_SIZE CALLBACK HPR_MemoryPoolGlobal_Size(void);

/**
 * HPR_MemoryPoolGlobal_IdleSize 获取空闲内存占用大小
 * @return 空闲内存大小(单位字节)
 */
HPR_DECLARE HPR_SIZE CALLBACK HPR_MemoryPoolGlobal_IdleSize(void);


#endif
