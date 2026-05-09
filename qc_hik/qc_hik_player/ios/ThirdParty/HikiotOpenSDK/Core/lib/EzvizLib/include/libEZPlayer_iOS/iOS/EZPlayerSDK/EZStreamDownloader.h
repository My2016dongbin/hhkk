//
//  EZStreamDownloader.h
//  EZVideoPlayer
//
//  Created by kanhaiping on 2018/5/18.
//  Copyright © 2018年. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "EZPlayerDefines.h"

@class EZStreamDownloader;
@protocol EZStreamDownloaderDelegate <NSObject>

@optional


/**
 下载出现错误回调，请勿在此回调中调用downloader的接口

 @param downloader 下载对象
 @param error 错误对象
 */
- (void)downloader:(EZStreamDownloader *)downloader didReceivedError:(NSError *)error;

/**
 下载的消息回调，比如下载结束的消息在此回调，请勿在此回调中调用downloader的接口

 @param downloader 下载对象
 @param messageCode 消息
 */
- (void)downloader:(EZStreamDownloader *)downloader didReceivedMessage:(EZRecordDownloaderMessage)messageCode;

@end


@class EZPlayerParam;
@interface EZStreamDownloader : NSObject

@property (atomic, weak) id<EZStreamDownloaderDelegate> delegate;

/**
 实例取流对象
 
 @param playID 播放的唯一ID，可以传空
 @param param 取流参数
 @param type 取流类型 当前支持 EZPlayerTypeSDCardDownload
 @return 实例化对象
 */
- (instancetype)initWithID:(NSString *)playID param:(EZPlayerParam *)param path:(NSString *)path type:(EZPlayerType)type ;

/**
 下载SD卡录像，当前支持v3 P2P，内外网直连以及流媒体 ，数据通过 delegate 回调回来 停止下载调用 stopStream
 注意：
 1.如果设备不支持v3P2P下载，需要明确禁止P2P的取流方式（如果不禁止，且设备支持v3P2P，则库内部会尝试P2P下载，最终报错）
 2.内外网直连仅在 iSupportPlayBackEndFlag 为 1 的情况下 才会尝试，并且尝试的时候会以8倍速推流
 3.以上两种情况都不支持的情况下，尝试流媒体下载
 4.对同一个设备的并发下载路数，和对设备的回放路数一起，共用设备的最大回放路数，设备的最大回放路数，视设备的资源情况而定，各个设备并不一致。
 */
- (int)startSDCardDownload;


/**
 *  停止下载，下载成功/失败均必须要调用该接口清理资源；同时取消下载也可以调用该接口，可能产生的下载文件需要外部清理
 */
- (void)stopDownload;



/// 获取下载的统计数据
- (NSString *)statistics;

@end
