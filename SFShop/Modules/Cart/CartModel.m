//
//  CartModel.m
//  SFShop
//
//  Created by 游挺 on 2021/10/31.
//

#import "CartModel.h"

@implementation ProdSpcAttrsModel

@end

@implementation CartItemModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end

@implementation CartListModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}


@end

@implementation CartModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
