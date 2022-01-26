//
//  CategoryRankModel.m
//  SFShop
//
//  Created by MasterFly on 2021/9/29.
//

#import "CategoryRankModel.h"

@implementation CategoryRankModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"serviceIds" : [CategoryRankServiceModel class],
        @"catgIds" : [CategoryRankCategoryModel class],
        @"brandIds" : [CategoryRankBrandModel class],
    };
}

- (NSArray<CategoryRankEvaluationModel *> *)evaluations {
    NSMutableArray *result = [NSMutableArray array];
    NSInteger fullStar = self.evaluationAvgs.intValue;
    if (fullStar <= 0) {return nil;}
    if (!(fullStar > 0 && fullStar <= 100)) {//最多支持100颗🌟评价系统 (默认5🌟)
        fullStar = 5;
    }
    for (NSInteger i = 1; i <= fullStar; i ++) {
        CategoryRankEvaluationModel *model = [CategoryRankEvaluationModel new];
        model.idStr = [NSString stringWithFormat:@"%ld",i];
        [result addObject:model];
    }
    return result;
}
@end

@implementation CategoryRankFilterModel

@end

@implementation CategoryRankServiceModel
- (NSString *)groupName {
    return @"Service";
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"idStr" : @"serviceId",
             @"name" : @"serviceName",
    };
}
@end

@implementation CategoryRankCategoryModel
- (NSString *)groupName {
    return @"Category";
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"idStr" : @"catgId",
             @"name" : @"catgName",
    };
}
@end

@implementation CategoryRankBrandModel
- (NSString *)groupName {
    return @"Brand";
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"idStr" : @"brandId",
             @"name" : @"brandName",
    };
}
@end

@implementation CategoryRankEvaluationModel
- (NSString *)groupName {
    return @"Evaluation";
}

- (NSString *)name {
    return [NSString stringWithFormat:@"%@ star",self.idStr];
}
@end

@implementation CategoryRankPriceModel
- (NSString *)groupName {
    return @"Price";
}

- (NSString *)minPriceGinseng {
    if (_minPrice < 0) {return @"";}
    return [NSString stringWithFormat:@"%ld",_minPrice];
}

- (NSString *)maxPriceGinseng {
    if (_maxPrice < 0) {return @"";}
    return [NSString stringWithFormat:@"%ld",_maxPrice];
}
@end

@implementation CategoryRankPageInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list" : [CategoryRankPageInfoListModel class],
    };
}
@end

@interface CategoryRankPageInfoListModel ()
@property (nonatomic, readwrite, copy, nullable) NSString *labelPictureUrl;
@end
@implementation CategoryRankPageInfoListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"imgs" : [CategoryRankPageInfoListImgModel class],
        @"services" : [CategoryRankPageInfoListServiceModel class],
        @"labels" : [CategoryRankPageInfoListLabelsModel class],
    };
}

- (nullable NSString *)labelPictureUrl {
    id labelId = self.productImg.labelId.firstObject;
    if (labelId) {
        for (CategoryRankPageInfoListLabelsModel *label in self.labels) {
            if ([label.labelId isEqualToString:[NSString stringWithFormat:@"%@",labelId]]) {
                return label.labelPictureUrl;
            }
        }
    }
    return nil;
}

@end

@implementation CategoryRankPageInfoListImgModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"idStr" : @"id"};
}
@end

@implementation CategoryRankPageInfoListServiceModel
@end

@implementation CategoryRankPageInfoListProductImgModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"idStr" : @"id"};
}
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end

@implementation CategoryRankPageInfoListLabelsModel
@end
