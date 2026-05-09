//
//  EZMeidaCatpure.h
//  H264 Encode and Decode
//
//  Created by kanhaiping on 2018/6/19.
//  Copyright © 2018年 AJB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "EZRTCMediaSessionDefines.h"
#import "EZRTCCameraParam.h"
#import <UIKit/UIKit.h>
#import "EZRTCFilterParam.h"

@class EZMediaCapture;
@class UIView;

@protocol EZMediaCaptureDelegate <NSObject>

//对于EZMediaCaptureAudioType 的数据 必须同步处理sample
- (void)capturer:(EZMediaCapture *)capturer didReceivedMediaData:(CMSampleBufferRef)sample type:(EZMediaCaptureSessionType)type;
- (void)capturer:(EZMediaCapture *)capturer didReceivedError:(NSInteger)error;

@end


@interface EZMediaCapture : NSObject


/// 可选的预览视图，请传入AVSampleBufferDisplayLayer
@property (nonatomic, weak) id displayLayer;


/// 设置采集的摄像头参数，比如采用前置还是后置，在发起任何视频操作前调用生效
@property (nonatomic, strong) EZRTCCameraParam *cameraParam;
/// 最终输出的画面的宽
@property (nonatomic, assign) NSInteger pixelWidth;
/// 最终输出的画面的高
@property (nonatomic, assign) NSInteger pixelHeigth;

/// 帧率
@property (nonatomic, assign) NSInteger fps;

@property (nonatomic, assign) BOOL enableBeauty;//开关
@property (atomic, strong) EZRTCBeautyParam *beautyParam;
@property (nonatomic, assign) EZRTC_Basic_Filter_Type basicFilterType;
@property (atomic, assign) float basicFilterIntensity;//0~1.0 默认 0.5


@property (nonatomic, assign, readonly) BOOL isAudioEnabled;
@property (nonatomic, assign, readonly) BOOL isVideoEnabled;
@property (nonatomic, assign, readonly) UIInterfaceOrientation currentInterfaceOri;

- (instancetype)initWithDelegate:(id<EZMediaCaptureDelegate>)delegate;
//- (NSInteger)startCatpure;
/// 设置本地的预览窗口，支持设置多个
/// @param window 预览View
/// @param regionID 窗口ID，可以填0 、1、
- (NSInteger)setLocalView:(nullable UIView *)window withRegionID:(NSInteger)regionID;
- (NSInteger)setScaleType:(NSInteger)scaleType forLocalView:(NSInteger)regionID;
- (NSInteger)configVideoCapture:(BOOL)open;
- (NSInteger)configAudioCapture:(BOOL)open;
- (void)configScreenShareCapture:(BOOL)open withResultBlock:(EZScreenShareResultBlock)block;
- (NSInteger)stopAllCatpure;
- (void)selectBackCamera:(BOOL)backCameraSelected;
- (void)localScreenShotWithBlock:(void (^)(UIImage *image))block;

@end
