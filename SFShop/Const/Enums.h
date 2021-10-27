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

@interface Enums : NSObject

@end

NS_ASSUME_NONNULL_END
