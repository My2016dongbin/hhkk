//
//  EZIntercomPlayer.h
//
//  Created by kanhaiping on 16/10/24.
//  Copyright © 2016年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZPlayerDefines.h"


typedef NS_ENUM(NSUInteger, EZIntercomPlayerMessage) {
    EZIntercomPlayerMessageStart = 101,
    EZIntercomPlayerMessageStop = 102,
    EZIntercomPlayerMessageMoreToken = 107,
};

typedef NS_ENUM(NSUInteger, EZIntercomBusType) {
    EZIntercomBusType_Input = 1, //播放
    EZIntercomBusType_Output = 2, //采集
};


@class EZIntercomPlayer;

@protocol EZIntercomPlayerDelegate <NSObject>

@required
/**
 *  播放器错误回调
 *
 *  @param player 播放器对象
 *  @param error  错误信息
 *
 *  错误码范围：
 本地错误码：
 7是无效取流token，相当于请求了一次取流接口；
 8是无token,相当于本地校验都没有过；
 11代表私有化取流500ms重试3次还是失败；
 15代表15s没来流，判断为取流超时；
 15代表解码超时，可能的原因是设备验证码错误或者是流数据不足以解码成功。
    EZ_ERROR_CAS_BASE					= 10000, //cas库错误起始码从10000-20000
	EZ_ERROR_CAS_STREAM_NOTIFY_BASE		= 17000, //转换CAS库的MsgFuncEx 取流错误起始码(异步错误码)
	EZ_ERROR_CAS_AUDIO_NOTIFY_BASE		= 18000, //转换CAS库的MsgFuncEx 对讲错误起始码(异步错误码)
	EZ_ERROR_CAS_P2P_STATUS_BASE		= 19000, //转换CAS库的P2PStatusEx p2pstatus错误起始码
 
	EZ_ERROR_PRIVATE_STREAM_BASE		= 20000, //stream库错误码从20000-30000
	EZ_ERROR_TTS_BASE					= 30000, //tts库错误起始码
	EZ_ERROR_TTS_NOTIFY_BASE			= 38000, //tts库notify错误起始码(异步错误码)
 */
- (void)intercomPlayer:(EZIntercomPlayer *)player didPlayFailed:(NSError *)error;

/**
 *  播放器状态回调
 *
 *  @param player      播放器对象
 *  @param messageCode 播放器状态信息码
 *
 *  播放器EZMediaPlayer的状态消息定义
 */
- (void)intercomPlayer:(EZIntercomPlayer *)player didReceivedMessage:(EZIntercomPlayerMessage)messageCode;

@optional

/**
 *  收到的对讲声音强度
 *
 *  @param player   播放器对象
 *  @param strongth 声音强度
 */
- (void)intercomPlayer:(EZIntercomPlayer *)player didReceivedSoundStrongth:(double)strongth;



/// 采集时的音频的响度
/// @param player 播放器对象
/// @param loudness 响度值 【-90 ，0】
- (void)intercomPlayer:(EZIntercomPlayer *)player didReceivedSoundLoudness:(float)loudness;



/// 检测到播放时的低音量（设备端发送过来的人声音量偏低）
/// @param player 播放器对象
/// @param loudness 响度值 负值 比如 -50
- (void)intercomPlayer:(EZIntercomPlayer *)player didReceivedLowPlaySoundLoudness:(float)loudness;


@end


@class EZPlayerParam;
@interface EZIntercomPlayer : NSObject

@property (nonatomic, weak) id<EZIntercomPlayerDelegate> delegate;/**< 委托 */

@property (nonatomic, strong, readonly) EZPlayerParam *playerParam;

@property (nonatomic, strong, readonly) NSString *playID;

/// 对讲提示音
@property (nonatomic, assign) BOOL isTipVoiceEnabled;


/// 对讲的编码类型（萤石定义的），默认-1（7是aac、1是G711μ、2是G711a）
/// 对讲start前可以预先设置，设置后对讲发起时会并发处理对讲库开启和取流信令（编码不一致会fallback），不设置的情况下依然会串行
/// 对讲成功后获取的话，可以拿到当前成功时的对讲编码类型
@property (nonatomic, assign) int audioType;

@property (nonatomic, assign) BOOL isQosTrans;//QOS对讲最终是否是qos传输，在对讲成功后生效

/// 对讲提示音的路径，当前需要传入特定的长度为15482的aac文件的路径
@property (nonatomic, strong) NSString *tipVoicePath;


/// 仅采集不播放模式，当前用于国标设备对讲（播放库负责播放音频）,start前调用
@property (nonatomic, assign) BOOL isCaptureOnly;

@property (nonatomic, assign) float loudnessInterval;//响度回调的频率，单位秒；16K采样率下 最低间隔256/16K；8K采样率下 最低为256/8K；默认为0，响度回调不回调


/// 是否开启播放的声音（设备端发送过来的声音）的人声响度检测，默认为NO，在startTalk前调用
/// 在开启的情况下，会通过【】回调告知外部；如果过来的人声响度偏小，则会一直有回调
@property (nonatomic, assign) BOOL enableLowRemoteVoiceDetect;


/// 是否开启对讲时的啸叫抑制，默认为NO，在startTalk前调用，如果需要打开，必须设置vqeModelPath路径
/// 仅适用于16K编码的AAC设备。
@property (nonatomic, assign) BOOL enableHowlingDepress;

/// 内部模型的路径，如果打开enableHowlingDepress 必须设置路径
@property (nonatomic, strong) NSString *vqeModelPath;


/// 在打开enableLowRemoteVoiceDetect的情况下，必须设置算法文件路径回调block，内部会向外部告知当前的采样率，外部需要根据采样率设置对应的算法文件路径
/// 在startTalk前调用
@property (nonatomic, strong) NSString *(^voiceDetectAlgorithmFilePathBlock)(NSInteger sampleRate);

- (instancetype)initWithParam:(EZPlayerParam *)param;

/**
 发起全双工对讲(适用于萤石的全双工和行业的局域网对讲）
 */
- (void)startTalk;


/**
 发起半双工对讲（适用于萤石的半双工,新QOS对讲为全双工对讲，不支持半双工对讲）
 */
//- (void)startSemiduplexTalk;


/**
 设置当前的对讲模式，用于切换全双工和半双工对讲

 @param isSemiduplex YES:切换成半双工 NO:切换成全双工
 */
- (void)changeTalkPatten:(BOOL)isSemiduplex;



/// 在调用stopTalk 接口前，可以先释放底层音频播放资源，本接口是同步耗时接口。
- (void)stopTalkPlayer;

/**
 *  停止对讲
 */
- (void)stopTalk;

/**
 *  全双工对讲时设置手机端是否静音(即设备端听不到手机端的声音)(适用于萤石的全双工和行业的局域网对讲）
 *
 *  @param muted 是否静音
 */
- (void)setTalkMuted:(BOOL)muted;

/**
 全双工对讲时设置手机端是否能听到对端的声音
 
 @param muted 是否静音
 */
- (void)setTalkRemoteMuted:(BOOL)muted;

/**
 设置对讲时的模式

 @param routeToSpeaker YES:使用扬声器 NO:使用听筒
 */
- (void)changeTalkingRouteMode:(BOOL)routeToSpeaker;


/// 对讲时选择设备端的麦克风，注意必须在对讲成功后调用，异步接口 ，成功无返回，失败返回EZ_VIDEOPLAYER_ERROR_SWITCH_DEV_MIC_ERROR
/// @param index 麦克风的编号，0是默认麦克风
- (void)changeDevMicIndex:(NSInteger)index;

/// 对讲时选择设备端的麦克风，注意必须在对讲成功后调用，同步接口
/// @param index 麦克风的编号，0是默认麦克风
- (int)changeDevMicIndexSync:(NSInteger)index;

/**
 *  半双工对讲专用方法（适用于萤石的半双工）
 *
 *  @param pressed 是否按住，默认弹起
 */
- (void)setTalkPressed:(BOOL)pressed;


/// 开启对讲过程中变声功能，支持在对讲成功后打开和关闭，同时支持对讲过程中，调整level，目前只支持8k 16K采样率
/// @param bPitchShiferEnable YES: 打开或者保持打开状态 NO：关闭
/// @param nPitchShiferLevel 等级 -12~12
- (void)openPitchShifer:(BOOL)bPitchShiferEnable atLevel:(int)nPitchShiferLevel;


/// 打开/关闭 AGC， 当前采集和播放AGC 均默认打开
/// 可以在startTalk前调用，也可以在对讲过程中实时开关
/// @param enable 打开/关闭
/// @param type 采集还是播放
- (void)setAGC:(BOOL)enable forBus:(EZIntercomBusType)type;

/// 设置AGC参数，如果需要调大采集的声音大小，可以将nGainMax调大到比如30，同时nGain调整到30，但注意设备端会不会破音
/// 当前默认值：采集：setAGCParam(15, 24, -60, PARAM_MODE_RECORD) 播放：setAGCParame(15, 21, -70, PARAM_MODE_PLAY);
/// 可以在startTalk前调用，也可以在对讲过程中实时开关，仅支持全双工设备的配置
/// nGainMax:最大db数，范围[5,90]
/// nGain:目标幅值，取值[0,30]
/// nNoise:默认值-90
- (void)setAGCGainMax:(NSInteger)nGainMax gain:(NSInteger)nGain noise:(NSInteger)nNoise forBus:(EZIntercomBusType)type;



/// set time out for Qos talk
/// @param timeout timeout in seconds
- (void)setQosTalkTimeout:(NSInteger)timeout;

/**
 获取对讲的统计信息，只在结束对讲、超时、出错时获取即可
 
 @param dataBlock
    字典：     key:"main" value:NSDictionary 部分通用库生成的主表信息 包括【uuid systemName r等】字段(如果字典中没有uuid，说明异常)
              key:"sub" value:NSArray<NSDictionary *> 若干个子表 可能为0个
 */
- (void)gatherStatistic:(void (^)(NSDictionary *data))dataBlock;

/**
 *  清理资源,不要在对讲中
 */
- (void)destroy;


/// 设置写文件的文件夹路径
/// @param folderPath 路径
+ (void)setDebugFileFolderPath:(NSString *)folderPath;
@end
