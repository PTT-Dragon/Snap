//
//  OrderModel.m
//  SFShop
//
//  Created by 游挺 on 2021/10/22.
//

#import "OrderModel.h"

@implementation orderItemsModel


@end

@implementation OrderModel

- (NSString *)getStateStr
{
    return [_state isEqualToString:@"B"] ? @"To Ship": [_state isEqualToString:@"C"] ? @"To Receive": [_state isEqualToString:@"E"] ? @"Cancelled": [_state isEqualToString:@"D"] ? @"Successful": @"To Pay";
}

@end
@implementation billAddressModel

@end
@implementation deliveryAddress

@end

@implementation OrderDetailModel


@end
