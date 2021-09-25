//
//  SFNetworkURL.h
//  SFShop
//
//  Created by MasterFly on 2021/9/23.
//

#import <Foundation/Foundation.h>
#import "SFNetworkUsersModule.h"
#import "SFNetworkPageModule.h"
#import "SFNetworkArticlesModule.h"

NS_ASSUME_NONNULL_BEGIN

#define SFNet SFNetworkURL.shareInstance

@interface SFNetworkURL : NSObject

/// 单例
+ (instancetype)shareInstance;

/// 首页模块
@property (nonatomic, readwrite, strong) SFNetworkPageModule *page;

/// 账户模块
@property (nonatomic, readwrite, strong) SFNetworkUsersModule *account;

/// 文章模块
@property (nonatomic, readwrite, strong) SFNetworkArticlesModule *article;
@end

NS_ASSUME_NONNULL_END
