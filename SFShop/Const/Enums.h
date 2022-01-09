//
//  Enums.h
//  SFShop
//
//  Created by Jacue on 2021/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    OrderListType_All = 0,
    OrderListType_ToShip,
    OrderListType_ToPay,
    OrderListType_ToReceive,
    OrderListType_Cancel,
    OrderListType_Successful,
    
} OrderListType;

typedef enum : NSUInteger {
    CouponType_All = 0,
    CouponType_Available,
    CouponType_Expired,
    CouponType_Used,
    
} CouponType;

/// 空页面type
typedef NS_ENUM(NSInteger, EmptyViewType) {
    EmptyViewNoPageType = 0, // 空页面
    EmptyViewNoNetworkType = 1, // 无网络
    EmptyViewNoShoppingCarType = 3, // 无购物车
    EmptyViewNoProductType = 4, // 无商品
    EmptyViewNoDiscountType = 5, // 无折扣
    EmptyViewNoOrderType = 6, // 无订单
    EmptyViewNofavoriteType = 7, // 无喜欢的
    EmptyViewNoReviewType = 8, // 无最近浏览
    EmptyViewNoAddressType = 9, // 无地址
    EmptyViewNoPurchaseType = 10, // 无订单？
    EmptyViewNoMessageType = 11, // 无信息
    EmptyViewNoEventType = 12, // 无活动
    EmptyViewNoPrizeType = 13 // 无奖品
};

static NSString * kLanguageChinese = @"zh-Hans";
static NSString * kLanguageEnglish = @"en";
static NSString * kLanguageHindi = @"id";

@interface Enums : NSObject

@end

NS_ASSUME_NONNULL_END
