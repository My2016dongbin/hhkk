//
//  EZRecordThumbnailFetcher.hpp
//  EZStreamSDK
//
//  Created by Harper Kan on 2020/9/17.
//  Copyright © 2020 Harper Kan. All rights reserved.
//

#ifndef EZRecordThumbnailFetcher_hpp
#define EZRecordThumbnailFetcher_hpp

#include <stdio.h>
#include "EZP2PCoreDataTransfer.h"
#include <memory>
#include "libCASClient.h"


namespace ez_record_thumbnail_fetcher {

class EZRecordThumbnailReq {
public:
    int type;
    int cmd;
    int seq;
    std::string serial;
    int channel;
    std::string startTime;//"2020-10-23T13:53:07"
    std::string stopTime;//"2020-10-23T13:53:07"
    std::string timeLapseTaskId;
};

class EZRecordThumbnailRsp {
public:
    int type;
    int cmd;
    int seq;
    int result;
    std::string timeStamp;
    std::string timeLapseTaskId;
    int length;
};


typedef void (*EZRecordThumbnailErrorCBFunc)(int errorCode, void *pUser);
typedef void (*EZRecordThumbnailMsgCBFunc)(ez_p2p_core_data_transfer::EZP2PTransMessage msg, void *pUser);
typedef void (*EZRecordThumbnailRspCBunc)(const EZRecordThumbnailRsp * rsp, const void *picData, uint32_t picLength);

class EZRecordThumbnailFetcher {
private:
    std::shared_ptr<ez_p2p_core_data_transfer::EZP2PDataTransfer> transfer;
    EZRecordThumbnailMsgCBFunc msgCB_ = nullptr;
    EZRecordThumbnailErrorCBFunc errorCB_ = nullptr;
    EZRecordThumbnailRspCBunc dataCB_ = nullptr;
    void *pUser_;
    
    static void msgCBFunc(ez_p2p_core_data_transfer::EZP2PTransMessage msg, void *pUser);
    static void errorCBFunc(int errorCode, void *pUser);
    static void dataCBunc(const void * data, uint32_t length, void *pUser);
    
public:
    EZRecordThumbnailFetcher(const ez_p2p_core_data_transfer::EZP2PTransParam *param);
    ~EZRecordThumbnailFetcher();
    void setCallback(EZRecordThumbnailMsgCBFunc msgCB, EZRecordThumbnailErrorCBFunc errorCB, EZRecordThumbnailRspCBunc dataCB, void *pUser);
    void start();
    int send(EZRecordThumbnailReq req);
    int stop();
};

}


#endif /* EZRecordThumbnailFetcher_hpp */
