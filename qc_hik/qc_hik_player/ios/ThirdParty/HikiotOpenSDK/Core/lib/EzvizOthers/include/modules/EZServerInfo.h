//
//  EZServerInfo.h
//  EzvizOpenSDK
//
//  Created by DeJohn Dong on 16/9/5.
//  Copyright © 2016年 Ezviz. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 服务器信息对象，内部接口专用对象（不对外公开，4500等专用），主要用来获取STUN服务器信息，与P2P打洞有关
@interface EZServerInfo : NSObject

@property (nonatomic, copy) NSString *stunIp1; ///STUN IP地址1
@property (nonatomic) NSInteger stunPort1; ///STUN Port1,主要用来处理p2p打洞
@property (nonatomic, copy) NSString *stunIp2; ///STUN IP地址2
@property (nonatomic) NSInteger stunPort2; ///STUN Port2 
@property (nonatomic, copy) NSString *vtmAddr; ///微云模式流媒体服务器地址
@property (nonatomic) NSInteger vtmPort; ///微云模式流媒体端口
@property (nonatomic) BOOL microCloudMode; ///是否为微云模式
@property (nonatomic, copy) NSString *logAddr; ///日志上报服务器地址

// aimediaAddr & aimediaPort为华住私有云专用
@property (nonatomic, copy) NSString *aiMediaAddr; ///AI流媒体服务器地址
@property (nonatomic) NSInteger aiMediaPort; ///AI流媒体端口

@end
