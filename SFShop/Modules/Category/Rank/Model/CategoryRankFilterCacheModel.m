//
//  CategoryRankFilterCacheModel.m
//  SFShop
//
//  Created by MasterFly on 2021/10/24.
//

#import "CategoryRankFilterCacheModel.h"

@implementation CategoryRankFilterCacheModel

- (NSDictionary *)filterParam {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (_minPrice > 0) {
        [result setObject:@(_minPrice) forKey:@"startPrice"];
    }
    if (_maxPrice > 0) {
        [result setObject:@(_maxPrice) forKey:@"endPrice"];
    }
    if (_serverId && ![_serverId isEqualToString:@""]) {
        [result setObject:_serverId forKey:@"serviceIds"];
    }
    
    if (_categoryId && ![_categoryId isEqualToString:@""]) {
        [result setObject:_categoryId forKey:@"catgIds"];
    }
    
    if (_brandId && ![_brandId isEqualToString:@""]) {
        [result setObject:_brandId forKey:@"brandIds"];
    }
    
    if (_evaluationId && ![_evaluationId isEqualToString:@""]) {
        [result setObject:_evaluationId forKey:@"evaluationAvgs"];
    }
    
    return result;
}

@end
