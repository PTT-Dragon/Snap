//
//  LastSelAddressModel.m
//  SFShop
//
//  Created by 游挺 on 2022/2/22.
//

#import "LastSelAddressModel.h"

@implementation LastSelAddressModel

singleton_implementation(LastSelAddressModel)

- (NSString *)provinceId
{
    NSArray *arr = [_addrPath componentsSeparatedByString:@"|"];
    return arr.count > 0 ? arr[1] : @"";
}
- (NSString *)cityId
{
    NSArray *arr = [_addrPath componentsSeparatedByString:@"|"];
    return arr.count > 1 ? arr[2] : @"";
}
- (NSString *)districtId
{
    NSArray *arr = [_addrPath componentsSeparatedByString:@"|"];
    return arr.count > 2 ? arr[3] : @"";
}
- (NSString *)streetId
{
    NSArray *arr = [_addrPath componentsSeparatedByString:@"|"];
    return arr.count > 3 ? arr[3] : @"";
}
@end
