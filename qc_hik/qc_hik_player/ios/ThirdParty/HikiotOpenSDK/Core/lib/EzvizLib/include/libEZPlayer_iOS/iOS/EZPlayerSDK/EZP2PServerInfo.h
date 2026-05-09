//
//  EZP2PServerInfo.h
//  EZVideoPlayer
//
//  Created by kanhaiping on 2017/5/27.
//  Copyright © 2017年. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZP2PServerInfo : NSObject <NSCoding>

@property (nonatomic, strong) NSString *p2pServerIp; /**< p2p服务器地址 */ 

@property (nonatomic, assign) NSInteger p2pServerPort; /**< 端口 */

@end
