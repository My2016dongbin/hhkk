#ifndef __HPR_MEMORY_POOL_EX_H__
#define __HPR_MEMORY_POOL_EX_H__

/** @file	HPR_MemoryPoolEx.h
 *  @note   HangZhou Hikvision System Technology Co., Ltd. All Right Reserved.
 *  @brief  可变长内存池，在固定内存池基础上的扩展，增加一个内存块的多次利用
 *	
 *  @author zhourui9
 *  @data   2018/08/18
 * 
 *	@note 由于用户需要的内存块长度不一致，先分配一个较大的内存块，在其中划分一定的空间给用户
 *	@note 由于内存越界检测需要初始化边界数据，变长下每次分配内存都需要初始化会影响性能，所以变长内存池不打算做上越界检测功能
 *	@note 
 *
 *  @warning 这里填写本文件相关的警告信息
 */

#include "HPR_Config.h"
#include "HPR_Types.h"

/**
 * HPR_MemoryPoolEx_Create 创建一个变长内存池句柄
 * @param minSize (IN) 最小内存(单位sizeUnit，默认MB，该实现下至少为1，用户设为0的话，内部也会转化为1)
 * @param maxSize (IN) 最大内存(单位sizeUnit，默认MB)
 * @param idleTimeoutMillis (IN) 空闲超时回收时间(单位毫秒，默认1分钟回收)
 * @param noLock (IN) 无锁(默认false，当空闲时间<0且此参数设置为true两条件同时满足时才生效，性能更高，但需要用户自己控制线程安全)
 * @param sizeUnit (IN) 大小单位(默认兆，用户也可以自己定义，该单位大小同时也是每次分配允许的最大字节数，在允许范围内可适当设大)
 * @return 内存池句柄
 */
#ifdef __cplusplus
HPR_DECLARE HPR_HANDLE CALLBACK HPR_MemoryPoolEx_Create(HPR_SIZE minSize, // 最小内存(单位sizeUnit，默认MB，该实现下至少为1，用户设为0的话，内部也会转化为1)
                                                        HPR_SIZE maxSize, // 最大内存(单位sizeUnit，默认MB)
                                                        HPR_INT64 idleTimeoutMillis = 60000, // 空闲超时回收时间(单位毫秒，默认1分钟回收)
                                                        HPR_BOOL noLock = HPR_FALSE, // 无锁(默认false，当空闲时间<0且此参数设置为true两条件同时满足时才生效，性能更高，但需要用户自己控制线程安全)
                                                        HPR_SIZE sizeUnit = 1048576); // 大小单位(默认兆，用户也可以自己定义，该单位大小同时也是每次分配允许的最大字节数，在允许范围内可适当设大)
#else
HPR_DECLARE HPR_HANDLE CALLBACK HPR_MemoryPoolEx_Create(HPR_SIZE minSize, // 最小内存(单位sizeUnit，默认MB，该实现下至少为1，用户设为0的话，内部也会转化为1)
                                                        HPR_SIZE maxSize, // 最大内存(单位sizeUnit，默认MB)
                                                        HPR_INT64 idleTimeoutMillis, // 空闲超时回收时间(单位毫秒，默认1分钟回收)
                                                        HPR_BOOL noLock, // 无锁(默认false，当空闲时间<0且此参数设置为true两条件同时满足时才生效，性能更高，但需要用户自己控制线程安全)
                                                        HPR_SIZE sizeUnit); // 大小单位(默认兆，用户也可以自己定义，该单位大小同时也是每次分配允许的最大字节数，在允许范围内可适当设大)
#endif

/**
 * HPR_MemoryPoolEx_Destroy 销毁一个变长内存池
 * @param memoryPoolHandle (IN) 内存池句柄
 * @return
 */
HPR_DECLARE HPR_VOID CALLBACK HPR_MemoryPoolEx_Destroy(HPR_HANDLE memoryPoolHandle);

/**
 * HPR_MemoryPoolEx_Alloc 分配内存
 * @param memoryPoolHandle (IN) 内存池句柄
 * @param bytes (IN) 分配大小(单位字节)
 * @return 内存指针
 */
HPR_DECLARE HPR_VOIDPTR CALLBACK HPR_MemoryPoolEx_Alloc(HPR_HANDLE memoryPoolHandle, HPR_SIZE bytes);

/**
 * HPR_MemoryPoolEx_Free 释放内存
 * @param memoryPoolHandle (IN) 内存池句柄
 * @param ptr (IN) 内存指针
 * @return
 */
HPR_DECLARE HPR_VOID CALLBACK HPR_MemoryPoolEx_Free(HPR_HANDLE memoryPoolHandle, HPR_VOIDPTR ptr);

/**
 * HPR_MemoryPoolEx_Size 获取当前内存占用大小
 * @param memoryPoolHandle (IN) 内存池句柄
 * @return 内存占用大小(单位字节)
 */
HPR_DECLARE HPR_SIZE CALLBACK HPR_MemoryPoolEx_Size(HPR_HANDLE memoryPoolHandle);

/**
 * HPR_MemoryPoolEx_IdleSize 获取当前空闲内存占用大小
 * @param memoryPoolHandle (IN) 内存池句柄
 * @return 空闲内存大小(单位字节)
 */
HPR_DECLARE HPR_SIZE CALLBACK HPR_MemoryPoolEx_IdleSize(HPR_HANDLE memoryPoolHandle);

#ifdef __cplusplus
namespace hpr 
{
    class CRealMemoryPoolEx;
}

class HPR_DECLARE_CLASS HPR_MemoryPoolEx
{
public:
    HPR_MemoryPoolEx(HPR_SIZE minSize, // 最小内存(单位sizeUnit，默认MB，该实现下至少为1，用户设为0的话，内部也会转化为1)
        HPR_SIZE maxSize, // 最大内存(单位sizeUnit，默认MB)
        HPR_INT64 idleTimeoutMillis = 60000, // 空闲超时回收时间(单位毫秒，默认1分钟回收)
        HPR_BOOL noLock = HPR_FALSE, // 无锁(默认false，当空闲时间<0且此参数设置为true两条件同时满足时才生效，性能更高，但需要用户自己控制线程安全)
        HPR_SIZE sizeUnit = 1048576); // 大小单位(默认兆，用户也可以自己定义，该单位大小同时也是每次分配允许的最大字节数，在允许范围内可适当设大)

    virtual ~HPR_MemoryPoolEx();

    HPR_VOIDPTR Alloc(HPR_SIZE bytes); // 分配大小不能超过sizeUnit单位大小，若超出，则返回NULL

    HPR_VOID Free(void* ptr);

    HPR_SIZE Size() const;

    HPR_SIZE IdleSize() const;

private:
    HPR_MemoryPoolEx(const HPR_MemoryPoolEx&);
    const HPR_MemoryPoolEx& operator=(const HPR_MemoryPoolEx&);

    hpr::CRealMemoryPoolEx* const m_pRef; // 为了不用导出所有内部成员
};
#endif

#endif
