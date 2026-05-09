//
//  SMLANRecord.h
//  PM_EZOpen_SDKCmp
//
//  Created by Lee on 2022/12/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 手机端录像

@class SMLANRecord;

@protocol SMLANRecordDelegate <NSObject>

// 录像过程中出现异常
- (void)recordException:(SMLANRecord *)record;
// 准备切换录像文件
- (NSString *)filePathOfSwitchingRecord:(SMLANRecord *)record;

-(void)recordDidEnd:(SMLANRecord *)record withLength:(int)length path:(NSString *)filePath;

@end

@interface SMLANRecord : NSObject

@property (nonatomic, weak) id<SMLANRecordDelegate> delegate;

@property (nonatomic, strong) NSString *verifyCode;                                        ///< 设备是否缓存了验证码

- (BOOL)startLocalRecordWithPathExt:(NSString *)path playPort:(int)playPort;

- (void)stopLocalRecordExt:(void (^ _Nullable)(BOOL ret))complete;
    
@end

NS_ASSUME_NONNULL_END
