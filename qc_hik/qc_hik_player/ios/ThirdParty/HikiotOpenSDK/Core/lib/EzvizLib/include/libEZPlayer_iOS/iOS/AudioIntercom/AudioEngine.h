//
//  AudioEngine.h
//  AudioEngine
//
//  Created by wangzhiguang on 14-4-4.
//  Copyright (c) 2014年 pc-wangzhiguang. All rights reserved.
//

#ifndef __AudioEngine__AudioEngine__
#define __AudioEngine__AudioEngine__

#ifndef CALLBACK
#define CALLBACK
#endif

//语言对讲库的使用模式：播放、录音、对讲
typedef enum _CAE_MODE_
{
    CAE_PLAY		= 1,                //只播放
    CAE_RECORD 		= 2,                //只采集
    CAE_INTERCOM	= 3                 //对讲
}CAEMODE;

//音频格式
typedef enum _AUDIO_ENCODE_TYPE
{
    AUDIO_TYPE_PCM    = 0x00,      //PCM
    AUDIO_TYPE_G711A  = 0x01,      //G711A
    AUDIO_TYPE_G711U  = 0x02,      //G711U
    AUDIO_TYPE_G722   = 0x03,      //G722
    AUDIO_TYPE_G726   = 0x04,      //G726
    AUDIO_TYPE_MPEG2  = 0x05,      //MPEG2
    AUDIO_TYPE_AAC    = 0x06,      //AAC
    AUDIO_TYPE_G723   = 0x07,      //G723,not support when on RTP MUX
    AUDIO_TYPE_G729   = 0x08,      //G729,not support when on RTP MUX
    AUDIO_TYPE_OPUS   = 0x09,      //OPUS
    AUDIO_TYPE_AACLD  = 0x0A,      //not support
    AUDIO_TYPE_AMR    = 0x0B,      //AMR notsupport
    AUDIO_TYPE_MP3    = 0x0C,      //MP3
}AudioEncodeType;

///<音频封装类型
typedef enum _AUDIO_MUX_TYPE
{
     MUX_SYSTEM_NULL      = 0x00,            ///< 无封装格式-即裸的音频编码或裸PCM数据
     MUX_SYSTEM_RTP       = 0x01,            ///< RTP封装
}AudioMuxType;

//播放/采集音频格式
typedef struct _AudioCodecParam_
{
    AudioEncodeType 	enAudioEncodeType;  //音频格式
    int                 nBitWidth;          //位宽
    int                 nSampleRate;        //采样率
    int                 nChannel;           //声道个数
    int                 nBitRate;           //比特率
    AudioMuxType        enMuxType;          //封装类型
    int                 reserved[8];        //保留
}AudioCodecParam;

//播放或者录音枚举类型
typedef enum _PARAMMODE_
{
    PARAM_MODE_PLAY 	= 1,            //播放
    PARAM_MODE_RECORD 	= 2             //采集
}PARAMMODE;

enum AUDIO_VAD_CHUNK_SAMPLE_SIZE_TYPE
{
    VAD_CHUNK_SAMPLE_SIZE_512   = 0,
    VAD_CHUNK_SAMPLE_SIZE_1024  = 1,
    VAD_CHUNK_SAMPLE_SIZE_1600  = 2,
    VAD_CHUNK_SAMPLE_SIZE_3200  = 3,
    VAD_CHUNK_SAMPLE_SIZE_4096  = 4,
    VAD_CHUNK_SAMPLE_SIZE_5440  = 5,
    VAD_CHUNK_SAMPLE_SIZE_8000  = 6,
};

typedef struct _VAD_OUTPUT_INFO_
{
    PARAMMODE ae_end;
    int vad_flag;
    unsigned char* p_voice_data;
    int voice_len;
    int relative_start_frame;
    int relative_end_frame;
    int speech_cutoff;
}VAD_OUTPUT_INFO;

//回调的枚举类型
typedef enum _CALLBACK_TYPE_
{
    PLAY_DATA_CALLBACK         = 1,    //播放解码回调
    RECORD_DATA_CALLBACK       = 2,    //采集编码回调
    RECORD_PCMDATA_CALLBACK    = 3,    //采集pcm数据回调
    INTERCOM_PCMDATA_CALLBACK  = 4,    //对讲数据混音回调
    PLAY_DATA_FINAL_CALLBACK   = 5,     //播放所有3A处理后的数据回调
}CALLBACKTYPE;

//输出数据结构体
typedef struct _OUTPUT_DATA_INFO
{
    unsigned char*    pData;            //数据地址
    unsigned int      dwDataLen;        //数据长度
    AudioEncodeType   enDataType;       //回调数据类型
    AudioMuxType      enMuxType;        //封装类型
} OutputDataInfo;

//输出数据回调函数
typedef void (* OutputDataCallBack)(OutputDataInfo* pstDataInfo, void* pUser);

//能量DB值回调函数
typedef void (* EnergyDBCallBack)(float fDBValue, void* pUser);

//音效类型
typedef enum _AUDIO_EFFECT_TYPE_
{
    AUDIO_EFFECT_TYPE_DYNAMICS_PROCESSOR = 1
}AUDIOEFFECTTYPE;

//DynamicsProcessor音效参数
typedef enum _AUDIO_EFFECT_DP_PARAM_
{
    // 单位dB, -40->20, 默认-20
    AUDIO_EFFECT_DP_PARAM_THRESHOLD = 1,
    // 单位dB, 0.1->40.0, 默认5
    AUDIO_EFFECT_DP_PARAM_HEADROOM = 2,
    // 单位rate, 1->50.0, 默认2
    AUDIO_EFFECT_DP_PARAM_EXPANSIONRATIO = 3,
    // 单位dB
    AUDIO_EFFECT_DP_PARAM_EXPANSIONTHRESHOLD = 4,
    // 单位secs, 0.0001->0.2, 默认0.001
    AUDIO_EFFECT_DP_PARAM_ATTACKTIME = 5,
    // 单位secs, 0.01->3, 默认0.05
    AUDIO_EFFECT_DP_PARAM_RELEASETIME = 6,
    // 单位dB, -40->40, 默认0
    AUDIO_EFFECT_DP_PARAM_MASTERGAIN = 7
}AUDIOEFFECTDPPARAM;



namespace CAudioIntercomEngine{
    class CAudioEngine
    {
    public:
        CAudioEngine(int nMode);
        ~CAudioEngine(void);
        
        /*打开对讲库*/
        int Open(void);
        
        /*关闭对讲库*/
        int Close(void);
        
        /*开始播放*/
        int StartPlay(void);
        
        /*停止播放*/
        int StopPlay(void);
        
        //1:输入待播放的音频流数据
        //2:支持带RTP封装的单包数据，不包含四字节长度，不包含海康威视头
        int InputData(unsigned char *pData, unsigned int nLen);
        
        /*开始声音采集*/
        int StartRecord(void);
        
        /*停止声音采集*/
        int StopRecord(void);
        
        //开启双向声音采集
        //int OpenMixRecord(bool bFlag);
        
        /*开启AEC回音消除*/
        int OpenAEC(bool bFlag);
        
        /*开启变声,是否开启变声，以及变声等级*/
        int OpenPitchShifer(bool bPitchShiferEnable, int nPitchShiferLevel);
        
        /*设置音频参数*/
        int SetAudioParam(AudioCodecParam *pstAudioCodecParam, int nType);
        
        /*获取音频参数*/
        int GetAudioParam(AudioCodecParam *pstAudioCodecParam, int nType);
        
        /*设置回调函数*/
        int SetAudioDataCallBack(OutputDataCallBack pfunc, int nType, void *pUser);
        
        int SetChatMic(bool bCapFlag, bool bPlayFlag);
        
        int SetChannel(float nChannel);
        
        int SetPlayBufNum(unsigned int nBufNum);
        
        /*获取版本号*/
        int GetVersion(void);
        
        /*获取版本Build信息*/
        char* GetBuildInfo(void);
        
        /*设置音效参数（目前只支持采集端的DynamicsProcessor，其参数类型参考AUDIOEFFECTDPPARAM）*/
        int SetAudioEffectParam(int nType, AUDIOEFFECTTYPE nEffectType, int nParamType, float fValue);
        
        int setSessionFlag(bool bSessionFlag);
        
        int SetWriteDataFlag(bool bWriteFlag);
        
        // AGC开关，采集端在采样率为16K及以下时才生效
        int SetAGCFlag(bool bAGCFlag, PARAMMODE nType);
        
        // 设置AGC参数，新增nGainMax:最大db数，范围[5,90]，内部默认值30;nGain目标幅值，取值[0,30]，默认值24;nNoise默认值-90;nLimit默认值1
        int setAGCParame(int nGainMax ,int nGain, int nNoise ,int nLimit, PARAMMODE nType);
        
        //默认是开启的，设置降噪等级，type：1播放，2采集；降噪等级0-5，默认3
        int SetANRLevel(int nType,int nLevel);
        
        int setALCParam(int value);
        //获取openal播放状态
        int GetALCPlayStatus(int * pValue);
        
        /** @fn     int SetCaptureDBCallBack(EnergyDBCallBack pfnEnergyDBCallBack, int nSamplePointSize, void *pUser)
         *  @brief  设置采集DB值回调函数
         *  @param  pfnEnergyDBCallBack [IN] -回调函数
         *  @param  nSamplePointSize    [IN] -固定采样点,范围[256-10240];
         *  @param  pUser               [IN] -回调用户指针
         *  @return 错误码
         */
        int SetCaptureDBCallBack(EnergyDBCallBack pfnEnergyDBCallBack, int nSamplePointSize, void *pUser);
        
        /** @fn     int ChangeOutputBitrate(int nBitrate)
         *  @brief  变换opus动态码率
         *  @param  nBitrate [IN] - 码率
         *  @return 错误码
         */
        int ChangeOutputBitrate(int nBitrate);
        
        /**
         * @fun     SetPlayDBCallBack
         * @Des     播放端能量DB回调
         * @Param   pfnEnergyDBCallBack [IN] — 能量DB回调
         * @param   nSamplePointSize    [IN] -固定采样点,范围[256-10240];
         * @param   pUser               [IN] -回调用户指针
         * @return  错误码
         */
        int SetPlayDBCallBack(EnergyDBCallBack pfnEnergyDBCallBack, int nSamplePointSize, const void* pUser);

        /**
         * @fun        setVoiceAutoDetectCallBack
         * @Des        开启和关闭语音自动检测功能和设置数据回调
         * @Param      vadProcessEnd [IN] —  采集端或播放端做自动语音检测(取值见AudioEngineParam.PARAMMODE定义)
         * @Param      vadCallBack [IN] — 语音自动检测数据回调，设置not null，开启语音检测，设置null，关闭语音检测
         * @Param      nChunkSampleSize [IN] —  语音自动检测算法每次输入处理的数据Chunk大小(取值见AudioEngineParam.VAD_CHUNK_SAMPLE_SIZE_TYPE定义)
         * @Param      vadModelPath [IN] —  语音自动检测算法网络模型(需要由外部传入,8K采样率需对应vad_8k.net，16K采样率需对应vad_16k.net)
         * @Return     错误码
         */
        int SetVoiceAutoDetectCallBack(PARAMMODE nType,
                                       void(__stdcall* VADDataCallback)(const VAD_OUTPUT_INFO* pVadOutputInfo, const void* pUser),
                                       AUDIO_VAD_CHUNK_SAMPLE_SIZE_TYPE audioVadChunkSampleSizeType,
                                       const char* pFileModelPath,
                                       const void* pUser);
        
        /*@fun   OpenDebugLogByCB
        * @brief 开启回调的调试日志
        * @para  nLevel[IN]         日志信息等级
        * @para  LogCBFun[IN]       回调函数
        * @para  pUser[IN]          用户指针
        * return 0 - fail or 1 - succ
        * */
        int OpenDebugLogByCB(int nLevel,void (CALLBACK* LogCBFun)(int nLogLevel,int nModule,const char* sLog,int nErrCode),
                                                         void* pUser);
        
        //文件夹路径，比如 Documents/SavedIntercomData，SavedIntercomData后不许有/
        static void setDebugFileFolderPath(const char *folderPath);
        
    private:
        int              m_nMode;               //对讲库使用模式
        bool             m_bHasOpen;            //是否打开
        
        void            *m_pcManager;           //管理类
        bool             m_bHasAudioParam;
        bool             m_bModeFlag;
        
    };

}

#endif /* defined(__AudioEngine__AudioEngine__) */
