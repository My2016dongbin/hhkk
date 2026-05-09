//
//  EZRecordThumbnailFetcher.hpp
//  TestVideoEditor
//
//  Created by Harper Kan on 2020/9/14.
//  Copyright © 2020 Harper Kan. All rights reserved.
//

#ifndef EZP2PDataTransfer_hpp
#define EZP2PDataTransfer_hpp

#include <stdio.h>
#include <vector>
#include <memory>
#include <mutex>
#include <string>


namespace ez_p2p_core_data_transfer {


class DataBlock {
private:
    size_t length_;
    char *data_;
    bool to_free_;
    
public:
    
    size_t length()
    {
        return length_;
    }
    
    char *data()
    {
        return data_;
    }
    DataBlock():length_(0),data_(nullptr),to_free_(false){
        ;
    }
    
    DataBlock(const char *raw_data, size_t length, bool to_free)
    {
        
        if (length == 0 || raw_data == nullptr) {
            length_ = 0;
            data_ = nullptr;
            to_free_ = false;
            return;
        }
        length_ = length;
        if (to_free) {
            data_ = new char[length_];
            if (data_) {
                to_free_ = true;
                memcpy(data_, raw_data, length_);
            }
        }else {
            data_ = (char *)raw_data;
            to_free_ = false;
        }
    }
    
    DataBlock(const char *raw_data, size_t length){
        new (this)DataBlock(raw_data, length, true);
    }
    
    DataBlock(const DataBlock& dataBlock){
        length_ = dataBlock.length_;
        to_free_ = dataBlock.to_free_;
        
        if (dataBlock.to_free_) {
            data_ = new char[length_];
            if (data_) {
                memcpy(data_, dataBlock.data_, length_);
            }
        }else {
            data_ = dataBlock.data_;
        }
        
    }
    
    DataBlock(DataBlock&& dataBlock){
        data_ = dataBlock.data_;
        length_ = dataBlock.length_;
        to_free_ = dataBlock.to_free_;
        if (to_free_) {
            dataBlock.data_ = nullptr;
            dataBlock.to_free_ = false;
        }
    }
    
    
    DataBlock& operator= (const DataBlock& dataBlock)
    {
        if (this == &dataBlock)
            return *this;
        length_ = dataBlock.length_;
        to_free_ = dataBlock.to_free_;
        
        if (dataBlock.to_free_) {
            data_ = new char[length_];
            if (data_) {
                memcpy(data_, dataBlock.data_, length_);
            }
        }else {
            data_ = dataBlock.data_;
        }

        return *this;
    }
    
    DataBlock& operator= (DataBlock&& dataBlock)
    {
        if (this == &dataBlock)
            return *this;
        data_ = dataBlock.data_;
        length_ = dataBlock.length_;
        to_free_ = dataBlock.to_free_;
        if (to_free_) {
            dataBlock.data_ = nullptr;
            dataBlock.to_free_ = false;
        }
        return *this;
    }
    
    
    ~DataBlock()
    {
        if (to_free_ && data_) {
            delete []data_;
        }
    }
    
};


class EZP2PTransParam {
public:
    std::string serial_;
    int channel_;
    std::string token_;
    std::string relayAddr_;
    int relayPort_;
    unsigned char authType_;
    unsigned char relayPublicKeyVer_;
    DataBlock relayPublicKey_;
    int timeout_;
    
    EZP2PTransParam() {
        channel_ = 0;//通道号初始化为0，如果外层不传入，会使用底层库的默认值
    }
};

enum class TransferState {
    Init,
    Running,
    Stopped,
    Error,
};


enum class EZP2PTransMessage {
    BuildLinkSucceed = 1,
};

typedef void (*errorCBFunc)(int errorCode, void *pUser);
typedef void (*msgCBFunc)(EZP2PTransMessage msg, void *pUser);
typedef void (*dataCBunc)(const void * data, uint32_t length, void *pUser);

class ring_buffer_s;
class EZP2PDataTransfer : public std::enable_shared_from_this<EZP2PDataTransfer> {
private:
    
    std::mutex data_mutex_;
    int cas_handle_;
    TransferState state_;
    int error_code_;
    std::condition_variable condition_;
    std::vector<DataBlock> data_to_send_;
    std::condition_variable send_condition_;
    ring_buffer_s *recv_buffer_;
    
    EZP2PTransParam param_;
    errorCBFunc errorCB_;
    dataCBunc dataCB_;
    msgCBFunc msgCB_;
    void *pUser_;
    
public:
    EZP2PDataTransfer(const EZP2PTransParam *param);
    ~EZP2PDataTransfer();
    void setCallback(msgCBFunc msgCB, errorCBFunc errorCB, dataCBunc dataCB, void *pUser);
    void start();
    int send(const DataBlock &dataBlock);
    int stop();
    
private:
    void startRecvThread(std::shared_ptr<EZP2PDataTransfer> transfer);
    static int MsgFuncEx(int sessionhandle, int opt, void* userdata, void* param1, void* param2, void* param3);
    static int DataFuncEx(int sessionhandle, void* userdata, int datatype, char* pdata, int ilen);
    void postError(int errorCode);
    void postMsg(EZP2PTransMessage msg);
    
};
}

#endif /* EZP2PDataTransfer_hpp */
