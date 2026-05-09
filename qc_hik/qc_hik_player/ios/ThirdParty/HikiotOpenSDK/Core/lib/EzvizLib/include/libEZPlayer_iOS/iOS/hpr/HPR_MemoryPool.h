#ifndef __HPR_MEMORY_POOL_H__
#define __HPR_MEMORY_POOL_H__

/** @file	HPR_MemoryPool.h
 *  @note   HangZhou Hikvision System Technology Co., Ltd. All Right Reserved.
 *  @brief 	可动态伸缩内存的定长内存池 
 *	
 *  @author zhourui9
 *  @data   2018/08/15
 * 
 *	@note 内存可以在一定的范围内浮动，当内存空闲后，超过一定的时间未被使用则会被归还给系统
 *	@note 历史记录：
 *	@note 
 *
 *  @warning 这里填写本文件相关的警告信息
 */

#include "HPR_Config.h"
#include "HPR_Types.h"

/**
 * HPR_MemoryPool_Create 创建一个定长内存池句柄
 * @param blockSize (IN) 块大小
 * @param minBlockNum (IN) 块最小数量(内存块不会少于该值)
 * @param maxBlockNum (IN) 块最大数量(内存块不会超过该值，若已达到该值，用户调用分配接口回返回空)
 * @param enableCheckBoundaryOverflow (IN) 是否启用检查边界溢出
 * @param idleTimeoutMillis (IN) 块空闲超时回收时间(单位毫秒，默认1分钟回收)
 * @param noLock (IN) 是否有锁(默认false，当空闲时间<0且此参数设置为true两条件同时满足时才生效，性能更高，但需要用户自己控制线程安全)
 * @return 内存池句柄
 */
#ifdef __cplusplus
HPR_DECLARE HPR_HANDLE CALLBACK HPR_MemoryPool_Create(HPR_SIZE blockSize,
                                                      HPR_SIZE minBlockNum,
                                                      HPR_SIZE maxBlockNum,
                                                      HPR_BOOL enableCheckBoundaryOverflow = HPR_TRUE,
                                                      HPR_INT64 idleTimeoutMillis = 60000,
                                                      HPR_BOOL noLock = HPR_FALSE);
#else
HPR_DECLARE HPR_HANDLE CALLBACK HPR_MemoryPool_Create(HPR_SIZE blockSize,
                                                      HPR_SIZE minBlockNum,
                                                      HPR_SIZE maxBlockNum,
                                                      HPR_BOOL enableCheckBoundaryOverflow,
                                                      HPR_INT64 idleTimeoutMillis,
                                                      HPR_BOOL noLock);
#endif

/**
 * HPR_MemoryPool_Destroy 销毁一个定长内存池
 * @param memoryPoolHandle (IN) 内存池句柄
 * @return
 */
HPR_DECLARE HPR_VOID CALLBACK HPR_MemoryPool_Destroy(HPR_HANDLE memoryPoolHandle);

/**
 * HPR_MemoryPool_Alloc 分配一个块
 * @param memoryPoolHandle (IN) 内存池句柄
 * @return 块地址指针
 */
HPR_DECLARE HPR_VOIDPTR CALLBACK HPR_MemoryPool_Alloc(HPR_HANDLE memoryPoolHandle);

/**
 * HPR_MemoryPool_Free 释放一个块
 * @param memoryPoolHandle (IN) 内存池句柄
 * @param ptr (IN) 块指针
 * @return
 */
HPR_DECLARE HPR_VOID CALLBACK HPR_MemoryPool_Free(HPR_HANDLE memoryPoolHandle, HPR_VOIDPTR ptr);

/**
 * HPR_MemoryPool_Size 获取当前内存占用大小
 * @param memoryPoolHandle (IN) 内存池句柄
 * @return 内存占用大小(单位字节)
 */
HPR_DECLARE HPR_SIZE CALLBACK HPR_MemoryPool_Size(HPR_HANDLE memoryPoolHandle);

/**
 * HPR_MemoryPool_IdleSize 获取空闲内存占用大小
 * @param memoryPoolHandle (IN) 内存池句柄
 * @return 空闲内存大小(单位字节)
 */
HPR_DECLARE HPR_SIZE CALLBACK HPR_MemoryPool_IdleSize(HPR_HANDLE memoryPoolHandle);

#ifdef __cplusplus
namespace hpr 
{
    class CRealMemoryPool;
}

class HPR_DECLARE_CLASS HPR_MemoryPool 
{
public:
    HPR_MemoryPool(HPR_SIZE blockSize, // 块大小
        HPR_SIZE minBlockNum, // 块最小数量(内存块不会少于该值)
        HPR_SIZE maxBlockNum, // 块最大数量(内存块不会超过该值，若已达到该值，用户调用分配接口回返回空)
        HPR_BOOL enableCheckBoundaryOverflow = HPR_TRUE, // 启用检查边界溢出
        HPR_INT64 idleTimeoutMillis = 60000, // 空闲超时回收时间(单位毫秒，默认1分钟回收)
        HPR_BOOL noLock = HPR_FALSE); // 无锁(默认false，当空闲时间<0且此参数设置为true两条件同时满足时才生效，性能更高，但需要用户自己控制线程安全)

    virtual ~HPR_MemoryPool();

    HPR_VOIDPTR Alloc();

    HPR_VOID Free(void* ptr);

    HPR_SIZE Size() const;

    HPR_SIZE IdleSize() const;

private:
    HPR_MemoryPool(const HPR_MemoryPool&);
    const HPR_MemoryPool& operator=(const HPR_MemoryPool&);

    hpr::CRealMemoryPool* const m_pRef; // 为了不用导出所有内部成员
};
#endif


#endif
