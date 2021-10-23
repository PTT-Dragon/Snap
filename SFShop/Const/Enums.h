//
//  Enums.h
//  SFShop
//
//  Created by Jacue on 2021/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    OrderListType_All,
    OrderListType_ToShip,
    OrderListType_ToPay,
    OrderListType_ToReceive,
    OrderListType_Cancel,
    OrderListType_Successful,
    
} OrderListType;

@interface Enums : NSObject

@end

NS_ASSUME_NONNULL_END
