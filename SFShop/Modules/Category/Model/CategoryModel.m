//
//  CategoryModel.m
//  SFShop
//
//  Created by MasterFly on 2021/9/25.
//

#import "CategoryModel.h"

@implementation CategoryInnerModel

@end

@implementation CategoryModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"inner" : @"model"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"children" : [CategoryModel class]};
}

@end


