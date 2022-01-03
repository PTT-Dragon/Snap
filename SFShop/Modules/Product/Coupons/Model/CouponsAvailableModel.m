//
//  CouponsAvailableModel.m
//  SFShop
//
//  Created by MasterFly on 2022/1/2.
//

#import "CouponsAvailableModel.h"

@implementation CouponsAvailableModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation CouponsStoreModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation CouponItem

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
