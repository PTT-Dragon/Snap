//
//  CategoryModel.m
//  SFShop
//
//  Created by MasterFly on 2021/9/25.
//

#import "CategoryModel.h"

@implementation CategoryInnerModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end

@implementation CategoryModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"inner" : @"model"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"children" : [CategoryModel class]};
}

@end


