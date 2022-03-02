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
    return [_state isEqualToString:@"B"] ? kLocalizedString(@"TO_SHIP"): ([_state isEqualToString:@"F"] || [_state isEqualToString:@"G"]) ? kLocalizedString(@"TO_SHIP"): [_state isEqualToString:@"C"] ? kLocalizedString(@"TORECEIVE"): [_state isEqualToString:@"E"] ? kLocalizedString(@"CANCELLED"): [_state isEqualToString:@"D"] ? kLocalizedString(@"SUCCESSFUL"): kLocalizedString(@"TO_PAY");
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
- (NSString *)getStateStr
{
    return [_state isEqualToString:@"B"] ? kLocalizedString(@"TO_SHIP"): ([_state isEqualToString:@"F"] || [_state isEqualToString:@"G"]) ? kLocalizedString(@"TO_SHIP"): [_state isEqualToString:@"C"] ? kLocalizedString(@"TO_RECEIVE"): [_state isEqualToString:@"E"] ? kLocalizedString(@"CANCELLED"): [_state isEqualToString:@"D"] ? kLocalizedString(@"SUCCESSFUL"): kLocalizedString(@"TO_PAY");
}
@end
@implementation CancelOrderReasonModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
@implementation OrderGroupModel
- (NSArray <ReviewUserInfoModel>*)showGroupMembers
{
    if ([_state isEqualToString:@"C"]) {
        //已完成
        if (_shareByNum > _groupMembers.count) {
            //已完成  添加假数据
            NSMutableArray *array = [NSMutableArray arrayWithArray:_groupMembers];
            for (NSInteger i = 0; i < _shareByNum - _groupMembers.count; i++) {
                ReviewUserInfoModel *model = [[ReviewUserInfoModel alloc] init];
                model.photo = @"Unknown";
                [array addObject:model];
            }
            return array;
        }
        return _groupMembers;
    }else{
        return _groupMembers;
    }
}
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
@implementation PackageListModel

@end
@implementation OrderDetailLogisticsModel

@end

@implementation RefundChargeModel

@end


