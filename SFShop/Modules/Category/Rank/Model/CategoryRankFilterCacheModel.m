//
//  CategoryRankFilterCacheModel.m
//  SFShop
//
//  Created by MasterFly on 2021/10/24.
//

#import "CategoryRankFilterCacheModel.h"
#import "NSString+Fee.h"
#import "CategoryRankModel.h"

@implementation CategoryRankFilterCacheModel

- (NSDictionary *)filterParam {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (_minPrice > 0) {
        [result setObject:@([[NSString stringWithFormat:@"%ld",_minPrice] multiplyCurrencyFloat]) forKey:@"startPrice"];
    }
    if (_maxPrice > 0) {
        [result setObject:@([[NSString stringWithFormat:@"%ld",_maxPrice] multiplyCurrencyFloat]) forKey:@"endPrice"];
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
    
    NSMutableArray *arr = [NSMutableArray array];
    for (CategoryRankAttrModel *model in _offerAttrValues) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (model.idStr.length > 0) {
            [dict setObject:model.idStr forKey:@"attrId"];
        }
        if (model.name.length > 0) {
            [dict setObject:model.name forKey:@"attrValues"];
        }
        [arr addObject:dict];
    }
    if (arr.count) {
        [result setObject:arr forKey:@"offerAttrValues"];
    }
    
    if (_qs && ![_qs isEqualToString:@""]) {
        [result setObject:_qs forKey:@"q"];
    }
    
    return result;
}

@end
