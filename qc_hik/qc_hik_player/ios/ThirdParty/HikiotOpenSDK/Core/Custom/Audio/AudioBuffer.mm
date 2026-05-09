//
//  AudioBuffer.cpp
//  iVMS-4500
//
//  Created by shizhiping on 15/7/2.
//  Copyright (c) 2015年 HIKVISION. All rights reserved.
//

#include "AudioBuffer.h"
#include <string.h>


namespace nsTwoWayAudio
{


AudioBuffer::AudioBuffer()
: m_packageQueue()
, m_idleQueue()
, m_mutex()
{
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL);
    pthread_mutex_init(&m_mutex, &attr);
    pthread_mutexattr_destroy(&attr);
}

AudioBuffer::~AudioBuffer()
{
    pthread_mutex_destroy(&m_mutex);
}

bool AudioBuffer::initBuffer(unsigned int bufferPackNum)
{
    if (0 == bufferPackNum)
    {
        return false;
    }
    
    try
    {
        for (int i = 0; i < bufferPackNum; ++i)
        {
            AudioPackage *pack = new AudioPackage;
            memset(pack, 0, sizeof(AudioPackage));
            
            m_idleQueue.push(pack);
        }
    } catch (...) {
        releaseBuffer();
        return false;
    }
    
    
    return true;
}

//释放
void AudioBuffer::releaseBuffer()
{
    while(!m_packageQueue.empty())
    {
        AudioPackage *pack = m_packageQueue.front();
        m_packageQueue.pop();
        delete pack;
    }

    while(!m_idleQueue.empty())
    {
        AudioPackage *pack = m_idleQueue.front();
        m_idleQueue.pop();
        delete pack;
    }
}

bool AudioBuffer::writePackage(unsigned char *dataBuf, unsigned int dataLen)
{
    if (NULL == dataBuf || 0 == dataLen)
    {
        return false;
    }
    
    pthread_mutex_lock(&m_mutex);
    
    //从空闲队列获取一个空的包
    if (m_idleQueue.empty())
    {
        pthread_mutex_unlock(&m_mutex);
        return false;
    }

    AudioPackage *pack = m_idleQueue.front();
    memcpy(pack->szDataBuf, dataBuf, dataLen);
    pack->nDataLen = dataLen;
    
    //从空闲队列出列，加到数据队列
    m_packageQueue.push(pack);
    m_idleQueue.pop();
    
//    printf("AudioBuffer::writePackage---m_packageQueue size: %d\n", (int)m_packageQueue.size());
//    printf("AudioBuffer::writePackage---m_idleQueue size: %d\n", (int)m_idleQueue.size());
    
    pthread_mutex_unlock(&m_mutex);
    return true;
}

bool AudioBuffer::readPackage(AudioPackage *outPackage)
{
    pthread_mutex_lock(&m_mutex);
    
    //从数据队列里获取一个包
    if (m_packageQueue.empty())
    {
        pthread_mutex_unlock(&m_mutex);
        return false;
    }

    AudioPackage *pack = m_packageQueue.front();

    //加到空闲队列，从数据队列出列
    m_idleQueue.push(pack);
    m_packageQueue.pop();

    //拷贝数据
    memcpy(outPackage->szDataBuf, pack->szDataBuf, pack->nDataLen);
    outPackage->nDataLen = pack->nDataLen;
    
    
//    printf("AudioBuffer::readPackage---m_packageQueue size: %d\n", (int)m_packageQueue.size());
//    printf("AudioBuffer::readPackage---m_idleQueue size: %d\n", (int)m_idleQueue.size());
    
    pthread_mutex_unlock(&m_mutex);
    return true;
}
    
}

