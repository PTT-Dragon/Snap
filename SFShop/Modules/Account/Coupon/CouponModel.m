//
//  CouponModel.m
//  SFShop
//
//  Created by 游挺 on 2021/10/19.
//

#import "CouponModel.h"
#import "NSDate+Helper.h"

@implementation CouponNumModel

@end

@implementation userCouponsModel

@end

@implementation CouponModel


- (NSString *)expDateStr
{
    NSDate *date = [NSDate dateFromString:self.expDate];
    return [date stringWithFormat:@"YYYY-MM-dd"];
}
- (NSString *)effDateStr
{
    NSDate *date = [NSDate dateFromString:self.effDate];
    return [date stringWithFormat:@"YYYY-MM-dd"];
}



+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end

@implementation CouponCategoryModel

@end

@implementation CouponOrifeeModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
@implementation NextBuyGetnRuleModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end


