//
//  EZP2PKeyInfo.h
//  EZVideoPlayer
//
//  Created by kanhaiping on 2017/5/27.
//  Copyright © 2017年. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZP2PKeyInfo : NSObject

@property (nonatomic, strong) NSData *p2pKey; /**< key used to encrypt/decrypt message body while communicate with P2P Server,which need to get from platform same as P2P Serve */

@property (nonatomic, assign) NSInteger saltIndex; /**< salt index, value [0, 7] */

@property (nonatomic, assign) NSInteger saltVer; /**< salt version, only two value: 0 or 1 */

@end
