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
    return ([_state isEqualToString:@"F"] || [_state isEqualToString:@"G"]) ? @"To Ship": [_state isEqualToString:@"C"] ? @"To Receive": [_state isEqualToString:@"E"] ? @"Cancelled": [_state isEqualToString:@"D"] ? @"Successful": @"To Pay";
}

@end
@implementation billAddressModel

@end
@implementation deliveryAddress

@end
@implementation OrderDetailPaymentsModel

@end
@implementation DeliveryInfoModel

@end

@implementation OrderDetailModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
@implementation CancelOrderReasonModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
@implementation OrderGroupModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation EvaluatesModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end

@implementation ReviewDetailModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
@implementation PurchaseReviewModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
@implementation EvaluatesContentsModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
@implementation ReviewUserInfoModel

@end

@implementation OrderNumModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}


@end


