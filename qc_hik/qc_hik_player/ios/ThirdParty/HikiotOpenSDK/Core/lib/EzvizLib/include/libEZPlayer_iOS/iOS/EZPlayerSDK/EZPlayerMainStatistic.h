//
//  EZPlayerMainStatistic.hpp
//  libezstreamclient
//
//  Created by kanhaiping on 2018/11/19.
//  Copyright © 2018年 linyong. All rights reserved.
//

#ifndef EZPlayerMainStatistic_hpp
#define EZPlayerMainStatistic_hpp

#include "EZPlayerSubStatistic.h"
#include <vector>

namespace ez_stream_sdk {
        
    class EZPlayerMainStatistic : public BaseStatistics{
    public:
        EZPlayerMainStatistic();
        ~EZPlayerMainStatistic();
        virtual string toJson() override;
        virtual void clear() override;
        vector<string> getSubStatistics();
        void addSubStatistics(shared_ptr<EZPlayerSubStatitic> subSsts);
        string getUUID();

        string uuid;
        int64_t via;
        int64_t r;
        int64_t start_st;
        int64_t data_t;
        int64_t decode_t;
        int64_t display_t;
        int64_t sumFlow;
        vector<shared_ptr<EZPlayerSubStatitic>> mSubSsts; //已完成的子表统计
    };
}

#endif /* EZPlayerMainStatistic_hpp */
