#ifndef __HPR_SHARED_MUTEX_H__
#define __HPR_SHARED_MUTEX_H__

/** @file	HPR_SharedMutex.h
 *  @note   HangZhou Hikvision System Technology Co., Ltd. All Right Reserved.
 *  @brief 	共享锁/读写锁
 *	
 *  @author zhourui9
 *  @data   2018/08/29
 * 
 *	@note 写/独占锁，使用Lock/Unlock进行独占；读/共享锁，使用LockShared/UnlockShared
 *	@note 历史记录：
 *	@note 
 *
 *  @warning 这里填写本文件相关的警告信息
 */

#include "HPR_Config.h"
#include "HPR_Types.h"
#include "HPR_Mutex.h"
#include "HPR_Cond.h"

#ifdef __cplusplus
extern "C" {
#endif

    typedef struct HPR_SHARED_MUTEX_T HPR_SHARED_MUTEX_T;

#ifdef __cplusplus
}
#endif

/**
 * HPR_SharedMutexCreate 创建共享锁
 * @param pMutex (OUT) 创建出来的共享锁
 * @return 0 success, -1 fail.
 * @sa HPR_SharedMutexCreate
 */
HPR_DECLARE HPR_INT32 CALLBACK HPR_SharedMutexCreate(HPR_SHARED_MUTEX_T* pMutex); 

/**
 * HPR_SharedMutexDestroy 销毁通过HPR_SharedMutexCreate创建出来的共享锁.
 * @param pMutex (IN) 通过HPR_SharedMutexCreate创建出来的共享锁.
 * @return 0 success, -1 fail.
 * @sa HPR_SharedMutexCreate
 */
HPR_DECLARE HPR_INT32 CALLBACK HPR_SharedMutexDestroy(HPR_SHARED_MUTEX_T* pMutex); 

/**
 * HPR_SharedMutexLock 独占(写)上锁
 * @param pMutex (IN) 通过HPR_SharedMutexCreate创建出来的共享锁.
 * @return 0 success, -1 fail.
 * @sa HPR_SharedMutexCreate,HPR_SharedMutexTryLock(),HPR_SharedMutexUnlock().
 */
HPR_DECLARE HPR_INT32 CALLBACK HPR_SharedMutexLock(HPR_SHARED_MUTEX_T* pMutex); 

/**
 * HPR_SharedMutexTryLock 尝试独占(写)上锁
 * @param pMutex (IN) 通过HPR_SharedMutexCreate创建出来的共享锁.
 * @return 0 success, -1 fail.
 * @sa HPR_SharedMutexCreate(),HPR_SharedMutexUnlock(),HPR_SharedMutexLock().
 */
HPR_DECLARE HPR_INT32 CALLBACK HPR_SharedMutexTryLock(HPR_SHARED_MUTEX_T* pMutex);

/**
 * HPR_SharedMutexUnlock 独占(写)解锁
 * @param pMutex (IN) 通过HPR_SharedMutexCreate创建出来的共享锁.
 * @return 0 success, -1 fail.
 * @sa HPR_SharedMutexCreate(),HPR_SharedMutexTryLock(),HPR_SharedMutexLock()
 */
HPR_DECLARE HPR_INT32 CALLBACK HPR_SharedMutexUnlock(HPR_SHARED_MUTEX_T* pMutex); 

/**
 * HPR_SharedMutexLockShared 共享(读)上锁
 * @param pMutex (IN) 通过HPR_SharedMutexCreate创建出来的共享锁.
 * @return 0 success, -1 fail.
 * @sa HPR_SharedMutexCreate,HPR_SharedMutexTryLock(),HPR_SharedMutexUnlock().
 */
HPR_DECLARE HPR_INT32 CALLBACK HPR_SharedMutexLockShared(HPR_SHARED_MUTEX_T* pMutex); 

/**
 * HPR_SharedMutexTryLockShared 尝试共享(读)上锁
 * @param pMutex (IN) 通过HPR_SharedMutexCreate创建出来的共享锁.
 * @return 0 success, -1 fail.
 * @sa HPR_SharedMutexCreate(),HPR_SharedMutexUnlock(),HPR_SharedMutexLock().
 */
HPR_DECLARE HPR_INT32 CALLBACK HPR_SharedMutexTryLockShared(HPR_SHARED_MUTEX_T* pMutex);

/**
 * HPR_SharedMutexUnlockShared 共享(读)解锁
 * @param pMutex (IN) 通过HPR_SharedMutexCreate创建出来的共享锁.
 * @return 0 success, -1 fail.
 * @sa HPR_SharedMutexCreate(),HPR_SharedMutexTryLock(),HPR_SharedMutexLock()
 */
HPR_DECLARE HPR_INT32 CALLBACK HPR_SharedMutexUnlockShared(HPR_SHARED_MUTEX_T* pMutex);

#ifdef __cplusplus
// 这里重新写了一个差不多的c++互斥量是为了能获取内部的HPR_MUTEX_T，因为HPR条件变量只能用这个参数
class HPR_DECLARE_CLASS HPR_UniqueMutex
{
public:
    HPR_UniqueMutex();
    HPR_UniqueMutex(HPR_UINT32 nFlag);
    ~HPR_UniqueMutex();

    HPR_INT32 Lock();
    HPR_INT32 Unlock();
    HPR_INT32 TryLock();

    HPR_MUTEX_T m_mutex;

private:
    HPR_UniqueMutex(const HPR_UniqueMutex&);
    const HPR_UniqueMutex& operator=(const HPR_UniqueMutex&);
};

class HPR_DECLARE_CLASS HPR_SharedMutex
{
private:
    class HPR_DECLARE_CLASS CStateData 
    {
    public:
        CStateData();

        unsigned int m_uSharedCount;
        bool m_bExclusive;
        unsigned int m_bExclusiveWaitingBlockedCount;
    };

    HPR_SharedMutex(const HPR_SharedMutex&);
    const HPR_SharedMutex& operator=(const HPR_SharedMutex&);

    CStateData m_cState;
    HPR_UniqueMutex m_cStateChange;
    HPR_Cond m_cSharedCond;
    HPR_Cond m_cExclusiveCond;

public:
    HPR_SharedMutex();
    ~HPR_SharedMutex();

    HPR_INT32 Lock();
    HPR_INT32 Unlock();
    HPR_INT32 TryLock();

    HPR_INT32 LockShared();
    HPR_INT32 UnlockShared();
    HPR_INT32 TryLockShread();

};
#endif

#endif
