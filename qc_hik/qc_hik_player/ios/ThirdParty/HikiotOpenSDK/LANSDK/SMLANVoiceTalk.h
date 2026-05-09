//
//  SMLANVoiceTalk.h
//  PM_EZOpen_SDKCmp
//
//  Created by Lee on 2022/12/27.
//

#import <Foundation/Foundation.h>

@interface SMLANVoiceTalk : NSObject

@property (nonatomic, assign, readonly) int talkId;
@property (nonatomic, assign, readonly) BOOL isVoiceTalking;

- (NSInteger)startVoiceTalkWithUserId:(NSInteger)userId cameraNo:(NSInteger)cameraNo needVoiceChannel:(BOOL)needVoiceChannel;

- (BOOL)stopVoiceTalk;

@end

