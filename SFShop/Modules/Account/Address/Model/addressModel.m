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

@end

@implementation AreaModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
