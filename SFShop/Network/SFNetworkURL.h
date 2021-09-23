//
//  SFNetworkURL.h
//  SFShop
//
//  Created by MasterFly on 2021/9/23.
//

#import <Foundation/Foundation.h>
#import "SFNetworkLoginModule.h"
#import "SFNetworkH5Module.h"

NS_ASSUME_NONNULL_BEGIN

#define SFNet SFNetworkURL.shareInstance

@interface SFNetworkURL : NSObject

/// 单例
+ (instancetype)shareInstance;

/// 账户模块
@property (nonatomic, readonly, strong) SFNetworkLoginModule *account;

/// h5模块
@property (nonatomic, readonly, strong) SFNetworkH5Module *h5;

@end

NS_ASSUME_NONNULL_END
