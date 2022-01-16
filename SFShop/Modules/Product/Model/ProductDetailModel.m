//
//  ProductDetailModel.m
//  SFShop
//
//  Created by Jacue on 2021/10/23.
//

#import "ProductDetailModel.h"

@implementation ProductCarouselImgModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation ProductAttrValueModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end


@implementation ProductAttrModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation ProductItemModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@interface ProductDetailModel ()
//选中商品
@property(nonatomic, readwrite, strong) ProductItemModel *selProductModel;
//存储当前选中的所有标签模型,⚠️可以通过该模型,查找出被选中商品
@property(nonatomic, readwrite, strong) NSMutableArray <ProdSpcAttrsModel *> <ProdSpcAttrsModel> *currentProdSpcAttrs;
@end

@implementation ProductDetailModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (void)updateCurrentSpcAttsMode:(ProdSpcAttrsModel *)spcAttsMode {
    if (!self.currentProdSpcAttrs) {
        self.currentProdSpcAttrs = [NSMutableArray array];
    }
    
    [self.currentProdSpcAttrs enumerateObjectsUsingBlock:^(ProdSpcAttrsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.attrId isEqualToString:spcAttsMode.attrId]) {
            [self.currentProdSpcAttrs replaceObjectAtIndex:idx withObject:spcAttsMode];
            *stop =YES;
        }
    }];
    
    if (!self.currentProdSpcAttrs.count) {
        [self.currentProdSpcAttrs addObject:spcAttsMode];
    }
}

- (ProductItemModel *)selectedProductItem {
    for (ProductItemModel *item in self.products) {
        BOOL isAdpterAll = YES;//全部标签是否命中
        for (ProdSpcAttrsModel *att in item.prodSpcAttrs) {
            BOOL isAdpterSingle = NO;//单个标签是否命中
            for (ProdSpcAttrsModel *cAtt in self.currentProdSpcAttrs) {
                if ([att.attrId isEqualToString:cAtt.attrId] && [att.value isEqualToString:cAtt.value]) {
                    isAdpterSingle = YES;//当前标签att 命中,继续下个标签
                    break;
                }
            }
            if (!isAdpterSingle) {//没有命中情况下,继续下个产品
                isAdpterAll = NO;
                break;
            }
        }
        if (isAdpterAll) {
            return item;
        }
    }
    return self.products.firstObject;
}

- (void)setLogisticsModel:(OrderLogisticsModel *)logisticsModel {
    _logisticsModel = logisticsModel;
    
    //重新填充地址数据,默认选中第一个配送数据
    OrderLogisticsItem * logisticsItem = logisticsModel.logistics.firstObject;
    logisticsItem.isSelected = YES;
    self.currentLogisticsItem = logisticsItem;
}

@end

@implementation ProductEvalationReplayModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
- (CGFloat)itemHie
{
    //计算label高度
    CGFloat labelHei = 0;
    labelHei = [self.replyComments calHeightWithFont:[UIFont systemFontOfSize:12] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft limitSize:CGSizeMake(MainScreen_width-48, MAXFLOAT)];
    
    return (labelHei+56) > 84 ? labelHei+56: 84;
}
@end

@implementation ProductEvalationModel
- (CGFloat)itemHie
{
    //计算label高度
    CGFloat labelHei = 0;
    labelHei = [self.evaluationComments calHeightWithFont:[UIFont systemFontOfSize:12] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft limitSize:CGSizeMake(MainScreen_width-24, MAXFLOAT)];
    //计算图片高度
    CGFloat itemHei = (MainScreen_width-34-30)/4;
    CGFloat imageHei = 0;
    imageHei = self.evaluationContents.count == 0 ? 0: self.evaluationContents.count < 4 ? itemHei+5: self.evaluationContents.count < 8 ? 2*itemHei+10: 3* itemHei + 15;
    return labelHei + imageHei+78;
}
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation ProductEvalationLabelsModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
- (float)width
{
    return [self.labelName calWidth:[UIFont systemFontOfSize:14] lineMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter limitSize:CGSizeMake(MAXFLOAT, 62)]+24;
}
@end

@implementation ProductEvalationDetailModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end
@implementation ProductCampaignsInfoModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation cmpShareBuysModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end
@implementation ProductGroupListModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end
@implementation ProductGroupModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end




