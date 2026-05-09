//
//  EZTimelapseRecordDownloader.hpp
//  EZPlayerSDK
//
//  Created by Harper Kan on 2023/7/26.
//  Copyright © 2023 Harper Kan. All rights reserved.
//

#ifndef EZTimelapseRecordDownloader_hpp
#define EZTimelapseRecordDownloader_hpp


#include "EZRecordDownloader.h"

using namespace std;
namespace ez_stream_sdk {

    class EZStreamClientProxy;

    class EZTimelapseRecordDownloader : public EZRecordDownloader {
        
        INIT_PARAM mInitParam;  // 取流参数
        EZStreamClientProxy * mpProxy = nullptr;  // 取流对象
        int startStream();
        int stopStream();
        
    public:
        EZTimelapseRecordDownloader() = delete;
        //延时摄影必须将外部的timelapse task_id 传入INIT_PARAM 中的 szFileID 字段。
        EZTimelapseRecordDownloader(INIT_PARAM *param, const string &path);
        ~EZTimelapseRecordDownloader();
        
        
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


#endif /* EZTimelapseRecordDownloader_hpp */
