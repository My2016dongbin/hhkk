//
//  EZPlayerSubStatistic.hpp
//  libezstreamclient
//
//  Created by kanhaiping on 2018/11/19.
//  Copyright © 2018年 linyong. All rights reserved.
//

#ifndef EZPlayerSubStatistic_hpp
#define EZPlayerSubStatistic_hpp

#include "EZStreamStatistics.h"
#include <memory>

namespace ez_stream_sdk {
    class EZPlayerSubStatitic : public BaseStatistics{
        
    public:
        EZPlayerSubStatitic();
        ~EZPlayerSubStatitic();
        virtual string toJson() override;
        virtual void clear() override;

        //以下均不直接使用，最后统计使用下面的方法
        int64_t startBefore;
        int64_t startAfter;
        int64_t streamHeaderTime;
        int64_t dataTime;
        int64_t decodeTime;
        int64_t decodeEndTime;
        int64_t dataEndTime;
        int64_t decdR;
        int64_t resultR; //播放层产生的错误码，比如23、25 等等
        int64_t flowInBytes;//流量 以字节为单位
        //以上均不直接使用，最后统计使用下面的方法
        
        int64_t b();
        int64_t c();
        int64_t d();
        int64_t e();
        int64_t t();
        int64_t sbt();
        int64_t sst();
        int64_t decd();
        int64_t flow();
        string uuid;
        int64_t seq;
        float delaySlight;
        float delayMiddle;
        float delaySerious;
        float delaySerious1; //按照业界标准，不统计最后一段时间的卡顿，仅统计播放成功的范围内

        
        //以下是取流层上报上来，播放层统计，最后保存到相应的取流层的
//        int isUDPStream;//当次是流媒体并且是udp取流(该标记当前已不需要20191011）
//        int udtConnect;//当次是P2P取流
        
        //取流层子表
        StreamStatistics *streamStt;
        
    private:
        int64_t actualStartBefore();
        int64_t actualStartAfter();
        int64_t validDelter(int64_t end, int64_t start);
        
    };
}

#endif /* EZPlayerSubStatistic_hpp */
