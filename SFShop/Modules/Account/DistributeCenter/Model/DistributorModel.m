//
//  DistributorModel.m
//  SFShop
//
//  Created by 游挺 on 2021/11/1.
//

#import "DistributorModel.h"

@implementation DistributorRankProductModel

@end

@implementation DistributionSettlementDtoModel

@end

@implementation KolDayMonthSaleModel

@end

@implementation KolOrderStatusNumModel

@end

@implementation DistributorModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation DistributorCommissionModel

@end

@implementation IncomeOrWithdrawListModel

@end
@implementation RelationOrderItemModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation RelationOrderListModel

- (NSString *)getStateStr
{
    return [_orderState isEqualToString:@"B"] ? kLocalizedString(@"TO_SHIP"): ([_orderState isEqualToString:@"F"] || [_orderState isEqualToString:@"G"]) ? kLocalizedString(@"TO_SHIP"): [_orderState isEqualToString:@"C"] ? kLocalizedString(@"TORECEIVE"): [_orderState isEqualToString:@"E"] ? kLocalizedString(@"CANCELLED"): [_orderState isEqualToString:@"D"] ? kLocalizedString(@"SUCCESSFUL"): kLocalizedString(@"TO_PAY");
}
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation RelationOrderDetailModel

@end
