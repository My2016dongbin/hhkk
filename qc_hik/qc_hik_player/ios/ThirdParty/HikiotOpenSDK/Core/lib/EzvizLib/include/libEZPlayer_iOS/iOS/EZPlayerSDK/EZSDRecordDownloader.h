//
//  EZSDRecordDownloader.hpp
//  libezstreamclient
//
//  Created by kanhaiping on 2019/5/5.
//  Copyright © 2019年 linyong. All rights reserved.
//

#ifndef EZSDRecordDownloader_hpp
#define EZSDRecordDownloader_hpp

#include "EZRecordDownloader.h"

using namespace std;
namespace ez_stream_sdk {

    class EZStreamClientProxy;

    class EZSDRecordDownloader : public EZRecordDownloader {
        
        INIT_PARAM mInitParam;  // 取流参数
        EZStreamClientProxy * mpProxy = nullptr;  // 取流对象
        int startStream();
        int stopStream();
        
    public:
        EZSDRecordDownloader() = delete;
        EZSDRecordDownloader(INIT_PARAM *param, const string &path);
        ~EZSDRecordDownloader();
        
        
        /**
         开始下载

         @param startTime 下载的片段的开始时间
         @param stopTime 下载的片段的结束时间
         @return 成功返回 EZ_OK ,失败返回错误码
         */
        int startDownload() override;
        
        /**
         停止下载，下载成功/失败均必须要调用该接口清理资源,但不能在回调的线程调用；
         同时取消下载也可以调用该接口，可能产生的下载文件需要外部清理
         
         @return 成功返回 EZ_OK
         */
        int stopDownload() override;
    };
}

#endif /* EZSDRecordDownloader_hpp */
