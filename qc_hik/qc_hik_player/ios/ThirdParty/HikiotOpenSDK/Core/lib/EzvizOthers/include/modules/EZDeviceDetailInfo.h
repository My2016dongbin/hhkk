//
//  EZDeviceDetailInfo.h
//  EzvizOpenSDK
//
//  Created by DeJohn Dong on 16/9/1.
//  Copyright © 2016年 Ezviz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EZP2PDevInfo;

/// 设备详细信息对象，内部接口专用对象（不对外公开，4500等专用）
@interface EZDeviceDetailInfo : NSObject

@property (nonatomic, copy) NSString *deviceSerial;  //设备ID
@property (nonatomic, copy) NSString *devlogicId;  //设备逻辑ID，国标
@property (nonatomic) NSInteger deviceStatus; //设备状态
@property (nonatomic, copy) NSString *deviceIp;  //设备外网IP
@property (nonatomic) NSInteger devicePort;      //设备端口号
@property (nonatomic) NSInteger devProtoEnum;    //6为国标设备
@property (nonatomic) NSInteger netType;         //设备网络类型
@property (nonatomic, copy) NSString *localIp;   //设备局域网IP
@property (nonatomic) NSInteger localCmdPort;    //设备局域网信令端口
@property (nonatomic) NSInteger localDevicePort; //设备局域网端口
@property (nonatomic) NSInteger localStreamPort; //设备局域网取流端口
@property (nonatomic, copy) NSString *casIp;     //CAS协议中的IP地址
@property (nonatomic) NSInteger casPort;         //CAS协议中的端口号
@property (nonatomic) NSInteger casCommandPort;  //CAS协议中信令传输的端口号
@property (nonatomic) NSInteger casStreamPort;   //CAS协议中取流的端口号
@property (nonatomic, copy) NSString *ttsIp; //设备TTS的服务器地址,如果是域名需要解析IP地址
@property (nonatomic) NSInteger ttsPort;  //设备TTS的服务器端口
@property (nonatomic, copy) NSString *vtmIp; //流媒体服务器IP地址
@property (nonatomic) NSInteger vtmPort; //流媒体服务器的端口号
@property (nonatomic, copy) NSString *encryptPassword; //设备加密密码
@property (nonatomic) BOOL isEncrypt; //设备是否加密
@property (nonatomic) NSInteger isOwner;//是否是设备拥有者 1:设备拥有者 -1:不是设备拥有者，需要鉴权
@property (nonatomic, copy) NSString *belongDeviceSerial; //关联设备序列号，通常是N1、D1、NVR、DVR等的设备序列号
@property (nonatomic) NSInteger belongCameraNo; //关联设备的通道号
@property (nonatomic, strong) EZDeviceDetailInfo *belongDeviceInfo; //关联设备信息对象

@property (nonatomic, readonly) NSArray *abilities; //设备能力集数组，由supportExtShort解析过来
@property (nonatomic, readonly) NSDictionary *ezDeviceSupportExtDic; //设备sdk能力集扩展，由ezDeviceSupportExt解析过来
@property (nonatomic, readonly) NSDictionary *supportExtDic; //设备上报的能力集扩展，由supportExt解析过来

//私有流媒体参数，1-普通用户取流, 2-群组分享取流, 3-视频广场取流, 4-服务内部取流, 5-开放平台普通用户取流, 6-开放平台付费用户取流, 7-设备付费用户取流, 8-值守用户取流
@property (nonatomic, assign) NSInteger streamBiz;
@property (nonatomic, copy) NSString * streamBizUrl;

@property (nonatomic, strong) NSString *saveTime;     //缓存保存下的时间点
@property (nonatomic, assign) BOOL hasRealPermission; // YES:已鉴权 && 拥有预览权限  NO:未鉴权 || (已鉴权 && 没有预览权限)
@property (nonatomic, assign) BOOL hasReplayPermission; // YES:已鉴权 && 拥有回放权限  NO:未鉴权 || (已鉴权 && 没有回放权限)

@property (nonatomic) NSInteger vtduServerKeyVersion;
@property (nonatomic, copy) NSString *vtduServerPublicKey;

@property (nonatomic, strong) EZP2PDevInfo *p2pDevInfo;
// tkToken模式下，内网直连需要传设备级tkToken，预操作过程中还未设置设备级tkToken；调用/detail接口时缓存下设备级tkToken
@property (nonatomic, copy) NSString *accessToken;

#pragma mark - 通道相关的属性
@property (nonatomic) NSInteger videoLevel; //通道清晰度，0-流畅，1-均衡，2-高清，3-超清，4-极清，5-3K，6-4K
@property (nonatomic, copy) NSString *capability; //设备清晰度能力集 例如@“2-2-1” 表示低档和中档质量视频流使用子码流，高档使用主码流，如值为 0 表示不支持
@property (nonatomic) NSInteger cameraNo; //通道号
@property (nonatomic, assign) NSInteger forceStreamType;// =3强制走流媒体取流
@property (nonatomic, strong) NSString *strCameraNo;
@property (nonatomic, strong) NSArray *videoQualityInfos;//通道支持的视频质量信息 EZVideoQualityInfo 对象数组
@property (nonatomic, copy) NSString *rtmpUrl;     //RTMP播放地址
@property (nonatomic, copy) NSString *rtmpTimespan;     //使用RTMP取流时间段
@property (nonatomic, copy) NSString *isShared;//分享状态 0:未分享，1:分享所有者，2:分享接受者（表示此摄像头是别人分享给我的）

#pragma mark - ezDeviceSupportExt 能力集判断

- (BOOL)supportDirectPlaybackEndFlag;// 直连回放结束标记
- (BOOL)supportP2Pv3Preview;
- (BOOL)supportP2Pv3Download;
- (BOOL)supportP2Pv3Playback;
- (BOOL)supportP2Pv3Talk;
- (BOOL)needCycleVerifyPermission;// 是否需要周期鉴权

#pragma mark - supportExt 能力集判断

- (BOOL)supportPreviewViaECDH;
- (BOOL)supportPlaybackViaECDH;
- (BOOL)supportVoiceTalkViaECDH;
- (BOOL)supportSeekPlayback;// 是否支持回放新协议
- (BOOL)supportPtzViaP2Pv3;// 是否支持p2pV3控制云台
- (int)supportWallPlaceValue;// 获取壁装支持的能力值

#pragma mark - supportExtShort 能力集判断

- (NSInteger)isSupportTalk;// 是否支持对讲
- (BOOL)supportChannelTalk;// 是否支持通道对讲
- (BOOL)supportP2P;// 是否支持P2P,只支持P2P V2.0,不考虑P2P V1.0
- (BOOL)supportSdCover;// 是否支持SD卡录像封面


@end
