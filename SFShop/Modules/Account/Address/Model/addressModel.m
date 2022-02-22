//
//  addressModel.m
//  SFShop
//
//  Created by 游挺 on 2021/10/19.
//

#import "addressModel.h"

@implementation addressModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

- (NSString *)customAddress {
    return  [NSString stringWithFormat:@"%@  %@\n%@ %@ %@ %@ %@ %@ %@", self.contactName, self.contactNbr, self.postCode, self.contactAddress, self.street, self.district, self.city, self.province, self.country];
}
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

@implementation AreaModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
