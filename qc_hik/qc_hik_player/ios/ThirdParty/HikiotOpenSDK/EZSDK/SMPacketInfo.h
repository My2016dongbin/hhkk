//
//  SMPacketInfo.h
//  PM_EZOpen_SDKCmp
//
//  Created by hik on 2024/4/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMPacketInfo : NSObject
@property (nonatomic) unsigned int packetType;
@property (nonatomic) unsigned int packetSize;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic) unsigned int timeStamp;
@property (nonatomic) unsigned short width;
@property (nonatomic) unsigned short height;
@property (nonatomic) unsigned char *pPacketBuffer;
@property (nonatomic, strong) NSData *dataBuffer;

@end

NS_ASSUME_NONNULL_END
