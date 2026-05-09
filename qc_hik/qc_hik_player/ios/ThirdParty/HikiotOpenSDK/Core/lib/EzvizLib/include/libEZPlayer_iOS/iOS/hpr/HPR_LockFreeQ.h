/*
* CopyRight:    HangZhou Hikvision System Technology Co., Ltd. All Right Reserved.
* FileName:     HPR_LockFreeQ.h
* Desc:         Lock-Free Queue
* Author:       hangangbiao
* Date:         2019-11-12 10:28:09
* Contact:      hangangbiao@hikvision.com.cn
* History:      Created By hangangbiao 2019-11-12 10:28:09
* */


#ifndef __HPR_LOCKFREE_Q_H__
#define __HPR_LOCKFREE_Q_H__

#include "HPR_Config.h"
#include "HPR_Types.h"
#include "HPR_SmartPtr.h"
#include "HPR_TraceInfoTLS.h"

#ifdef __cplusplus

namespace hpr
{
    class hpr_lockfreeQ;
    class cobject : public shared_object
    {
        friend class hpr_lockfreeQ;
    public:
        cobject() : name_("") {
            memset(&traceInfo_, 0, sizeof(traceInfo_));
        };
        cobject(const char* name) : name_(name) {};
        virtual ~cobject() { name_ = NULL; };

        const char* __getname() const { return name_; };

    private:
        const char* name_;
        HPR_TRACEINFO_T traceInfo_;
    };

    class hpr_lockfreeQImpl;
    class HPR_DECLARE_CLASS hpr_lockfreeQ : public shared_object
    {
    public:
        hpr_lockfreeQ();
    public:
        void push_back(smartptr<cobject> objPtr);
        smartptr<cobject> pop_front();

        bool empty();

        int size();

    private:
        virtual ~hpr_lockfreeQ();
    private:
        hpr_lockfreeQImpl* m_impl;
    };
    typedef smartptr<hpr_lockfreeQ>    hpr_lockfreeQPtr;
}

#endif

#endif //~__HPR_LOCKFREE_Q_H__

/*
 *sample!

    class CYourObj : public hpr::cobject
    {
    public:
        CYourObj(int id) { m_id = id; }
        virtual ~CYourObj() { }
        int m_id;
    };


    hpr::hpr_lockfreeQPtr lfqPtr = new hpr::hpr_lockfreeQ();
    for(int i=0; i<10; ++i)
    {
        smartptr<CYourObj> yourObjPtr(new CYourObj(i));
        lfqPtr->push_back(yourObjPtr.get());
        MYLOG_INFO("push your objID={%d}", i);
    }

    while(!lfqPtr->empty())
    {
        smartptr<CYourObj> yourObjPtr = dynamic_cast<CYourObj*>(lfqPtr->pop_front().get());
        MYLOG_INFO("pop your objID={%d}", yourObjPtr->m_id);
    }

*/

