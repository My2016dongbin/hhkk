/*
* CopyRight:    HangZhou Hikvision System Technology Co., Ltd. All Right Reserved.
* FileName:     HPR_TraceInfoTLS.h
* Desc:         TLS TraceInfo
* Author:       hangangbiao
* Date:         2019-11-13 15:16:12
* Contact:      hangangbiao@hikvision.com.cn
* History:      Created By hangangbiao 2019-11-13 15:16:12
* */

#ifndef __HPR_TRACEINFO_TLS_H__
#define __HPR_TRACEINFO_TLS_H__

#include "HPR_Config.h"
#include "HPR_Types.h"
#include "HPR_Singleton.h"

#ifdef __cplusplus

#define HPR_MAX_TRACEID_LEN     64
#define HPR_MAX_SPANID_LEN      64
#define IN
#define OUT
typedef struct HPR_TRACEINFO
{
    char strTraceID[HPR_MAX_TRACEID_LEN + 1];
    char strSpanID[HPR_MAX_SPANID_LEN + 1];
    char strParentSpanID[HPR_MAX_SPANID_LEN + 1];
    bool bSampled;
    bool bDebugMode;
}HPR_TRACEINFO_T;

namespace hpr
{
    class hpr_tlsTraceInfoOperImpl;
    class HPR_DECLARE_CLASS hpr_tlsTraceInfoOper
    {
    public:
        static hpr_tlsTraceInfoOper* instance();

        HPR_INT32 setTraceInfo(IN const HPR_TRACEINFO_T& traceInfo);
        HPR_INT32 getTraceInfo(OUT HPR_TRACEINFO_T* traceInfo);
        HPR_INT32 eraseTraceInfo();

    private:
        hpr_tlsTraceInfoOper();
        virtual ~hpr_tlsTraceInfoOper();

    private:
        static hpr_tlsTraceInfoOper m_tlsTraceInfoOper;
        hpr_tlsTraceInfoOperImpl* m_impl;
    };

}

#endif

#endif //~__HPR_TRACEINFO_TLS_H__

/*
*sample!

    HPR_VOIDPTR CALLBACK pfnMyThread(HPR_VOIDPTR pParam)
    {
        //>>...
        HPR_TRACEINFO_T traceInfo;
        if (HPR_OK == hpr::hpr_tlsTraceInfoOper::instance()->getTraceInfo(&traceInfo)) {
            MYLOG_INFO("===>\r\ntraceID=%s\r\nspanID=%s\r\nparentSpanID=%s\r\nbSampled=%d\r\nbDebugMode=%d"
                , traceInfo.strTraceID, traceInfo.strSpanID, traceInfo.strParentSpanID, traceInfo.bSampled, traceInfo.bDebugMode);
        }
        return 0;
        //>>...
    }

    int main()
    {
        //>>...
        HPR_TRACEINFO_T traceInfo;
        strncpy(traceInfo.strTraceID, "123123", sizeof(traceInfo.strTraceID));
        strncpy(traceInfo.strSpanID, "456456", sizeof(traceInfo.strSpanID));
        strncpy(traceInfo.strParentSpanID, "789789", sizeof(traceInfo.strParentSpanID));
        traceInfo.bSampled = true;
        traceInfo.bDebugMode = true;
        HPR_INT32 ret = hpr::hpr_tlsTraceInfoOper::instance()->setTraceInfo(traceInfo);

        HPR_Thread_Create(pfnMyThread, NULL, 0);
        //>>...
    }

*/


