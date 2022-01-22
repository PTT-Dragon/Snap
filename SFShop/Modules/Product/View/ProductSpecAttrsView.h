//
//  ProductSpecAttrsView.h
//  SFShop
//
//  Created by Jacue on 2021/10/30.
//

#import <UIKit/UIKit.h>
#import "ProductDetailModel.h"
#import "ProductStockModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum :NSUInteger{
    cartType,      //加入购物车
    buyType,        //购买
    groupSingleBuyType,//团购活动单人购买
    groupBuyType,      //团购
}ProductSpecAttrsType;

@interface ProductSpecAttrsView : UIView

typedef void(^Block)(void);
typedef void(^ChooseAttrBlock)(void);
typedef void(^GotoBuyOrCartBlock)(ProductSpecAttrsType type);

@property(nonatomic, strong) ProductDetailModel *model;
@property(nonatomic, strong) NSArray<ProductStockModel *> *stockModel;
@property(nonatomic, strong) ProductItemModel *selProductModel;
@property (nonatomic,strong) ProductCampaignsInfoModel *campaignsModel;
@property (nonatomic, copy) Block dismissBlock;
@property (nonatomic, copy) ChooseAttrBlock chooseAttrBlock;
@property (nonatomic, copy) GotoBuyOrCartBlock buyOrCartBlock;

@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) ProductSpecAttrsType attrsType;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *selectedAttrValue;

@end

@interface ProductAttrButton : UIButton

@end


NS_ASSUME_NONNULL_END
