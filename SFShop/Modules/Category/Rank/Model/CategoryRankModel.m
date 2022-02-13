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
        @"offerAttrValues" : [CategoryRankAttrModel class],
    };
}

- (NSArray<CategoryRankEvaluationModel *> *)evaluations {
    if (_evaluations ==nil) {
        NSMutableArray *result = [NSMutableArray array];
    //    NSInteger fullStar = self.evaluationAvgs.intValue;
    //    if (fullStar <= 0) {return nil;}
    //    if (!(fullStar > 0 && fullStar <= 100)) {//最多支持100颗🌟评价系统 (默认5🌟)
    //        fullStar = 5;
    //    }
        NSInteger fullStar = 5;
        for (NSInteger i = 1; i <= fullStar; i ++) {
            CategoryRankEvaluationModel *model = [CategoryRankEvaluationModel new];
            model.idStr = [NSString stringWithFormat:@"%ld",i];
            [result addObject:model];
        }
        _evaluations = result;
    }

    return _evaluations;
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
    return kLocalizedString(@"CATEGORY");
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"idStr" : @"catgId",
             @"name" : @"catgName",
    };
}
@end

@implementation CategoryRankBrandModel
- (NSString *)groupName {
    return kLocalizedString(@"BRANDS");
}

- (BOOL)isSupportMul {
    return YES;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"idStr" : @"brandId",
             @"name" : @"brandName",
    };
}
@end

@implementation CategoryRankEvaluationModel
- (NSString *)groupName {
    return kLocalizedString(@"RATING");
}

- (NSString *)name {
    return [NSString stringWithFormat:@"%@ %@",self.idStr,kLocalizedString(@"STAR")];
}
@end

@implementation CategoryRankAttrModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"groupName" : @"attrName",
             @"name" : @"attrValues",
             @"idStr" : @"attrId",

    };
}

@end

@implementation CategoryRankPriceModel
- (NSString *)groupName {
    return kLocalizedString(@"Price");
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

- (CGFloat)height{
    CGFloat titleHeight = [NSString jk_heightTextContent:self.offerName withSizeFont:14 withMaxSize:CGSizeMake((MainScreen_width - KScale(12) * 3 - KScale(16) * 2)/2, CGFLOAT_MAX)] + KScale(12);
                    
    CGFloat imageHeight = KScale(160);
    CGFloat tagHeight = 0;
    if (self.sppType.length> 0 || self.promotType.length > 2) {
        tagHeight = KScale(16) + KScale(16);
    }
    
    CGFloat gradeHeight = 0;
    if (self.evaluationAvg > 0 || self.evaluationCnt > 0) {
        gradeHeight = KScale(12) + KScale(12);
    }
    CGFloat priceHeight = KScale(6) + KScale(14);
    CGFloat discountHeight = self.discountPercent.length > 0 ? (KScale(4) + KScale(14)) : 0;
    CGFloat bottomSpace = 10;
    CGFloat theHeight = imageHeight + tagHeight + titleHeight + priceHeight + discountHeight + gradeHeight + bottomSpace;
    return theHeight;
}

- (NSArray *)allTags {
    NSString *formatterPromotType = self.promotType;
    NSMutableArray *formatterTags = [NSMutableArray array];
    NSMutableArray *tags = [NSMutableArray array];
    if (formatterPromotType.length > 2) {
        formatterPromotType = [formatterPromotType stringByReplacingOccurrencesOfString:@"[" withString:@""];
        formatterPromotType = [formatterPromotType stringByReplacingOccurrencesOfString:@"]" withString:@""];
        NSArray *promotArr = [formatterPromotType componentsSeparatedByString:@","];
        [tags addObjectsFromArray:promotArr];
    }
    
    if (self.sppType.length > 0) {
        [tags addObject:self.sppType];
    }
    for (NSString *tag in tags) {
        if ([tag containsString:@"2"]) {
            [formatterTags addObject:@"FLASH"];
        } else if ([tag containsString:@"4"]) {
            [formatterTags addObject:@"GROUP"];
        } else if ([tag containsString:@"C"]) {
            [formatterTags addObject:@"DISCOUNT"];
        } else if ([tag containsString:@"D"]) {
            [formatterTags addObject:@"DISCOUNT"];
        } else if ([tag containsString:@"G"]) {
            [formatterTags addObject:@"GIFT"];
        }
    }
    return formatterTags;
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
