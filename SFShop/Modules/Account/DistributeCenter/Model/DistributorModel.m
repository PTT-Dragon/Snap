//
//  DistributorModel.m
//  SFShop
//
//  Created by 游挺 on 2021/11/1.
//

#import "DistributorModel.h"

@implementation PosterContentModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end
@implementation PosterPosterModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end
@implementation PosterModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation DistributorRankProductModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation DistributionSettlementDtoModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation KolDayMonthSaleModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation KolOrderStatusNumModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation DistributorModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation DistributorCommissionModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation IncomeOrWithdrawListModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
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
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end


@implementation CashOutHistoryListModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end
