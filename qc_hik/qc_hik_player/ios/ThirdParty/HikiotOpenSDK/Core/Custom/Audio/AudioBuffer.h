//
//  AudioBuffer.h
//  iVMS-4500
//  音频缓冲区类
//  Created by shizhiping on 15/7/2.
//  Copyright (c) 2015年 HIKVISION. All rights reserved.
//

#ifndef __iVMS_4500__AudioBuffer__
#define __iVMS_4500__AudioBuffer__

#include <stdio.h>
#include <queue>
#include <pthread.h>

using std::queue;

//音频包长度（客户端支持的音频编码类型，每个包编码后都不超过1536）
#define PER_PACKAGE_MAX_SIZE  1536

namespace nsTwoWayAudio
{

    
typedef struct _AudioPackage
{
    char szDataBuf[PER_PACKAGE_MAX_SIZE];
    unsigned int nDataLen;
}AudioPackage;


class AudioBuffer
{
public:
    AudioBuffer();
    ~AudioBuffer();
    //初始化缓冲区，分配内存
    bool initBuffer(unsigned int bufferPackNum);
    //释放缓冲区内存
    void releaseBuffer();
    
    //写数据
    bool writePackage(unsigned char *dataBuf, unsigned int dataLen);
    //读数据
    bool readPackage(AudioPackage *outPackage);
    
private:
    //数据队列
    queue<AudioPackage*> m_packageQueue;
    //空闲队列
    queue<AudioPackage*> m_idleQueue;
    //线程锁
    pthread_mutex_t m_mutex;
};
    
    
}

#endif /* defined(__iVMS_4500__AudioBuffer__) */
