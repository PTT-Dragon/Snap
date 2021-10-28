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
#import "SFNetworkOffersModule.h"

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

/// 商品模块
@property (nonatomic, readwrite, strong) SFNetworkOffersModule *offer;

/// 收货地址模块
@property (nonatomic, readwrite, strong) SFNetworkUsersAddressModule *address;

/// 红包模块
@property (nonatomic, readwrite, strong) SFNetworkUsersCouponModule *coupon;

/// 评价模块
@property (nonatomic, readwrite, strong) SFNetworkUsersEvaluateModule *evaluate;

/// 收藏模块
@property (nonatomic, readwrite, strong) SFNetworkUsersFavoriteModule *favorite;

/// 邀请模块
@property (nonatomic, readwrite, strong) SFNetworkUsersInviteModule *invite;

/// 订单模块
@property (nonatomic, readwrite, strong) SFNetworkUsersOrderModule *order;

/// 退货模块
@property (nonatomic, readwrite, strong) SFNetworkUsersRefundModule *refund;

/// 浏览模块
@property (nonatomic, readwrite, strong) SFNetworkUsersRecentModule *recent;

/// h5
@property (nonatomic, readwrite, strong) SFNetworkH5Module *h5;
@end

NS_ASSUME_NONNULL_END
