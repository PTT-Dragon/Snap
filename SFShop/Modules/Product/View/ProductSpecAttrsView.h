//
//  ProductSpecAttrsView.h
//  SFShop
//
//  Created by Jacue on 2021/10/30.
//

#import <UIKit/UIKit.h>
#import "ProductDetailModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, ProductViewBuyMethod) {
    ProductViewBuyAddToCart = 0,//添加到购物车
    ProductViewBuyMethodPersonal,//个人购买
    ProductViewBuyMethodPersonalWithPrice,//个人购买,带价格
    ProductViewBuyMethodGroupWithPrice,//团购,带价格
};

typedef void(^Block)(void);
typedef void(^ChooseAttrBlock)(NSString *attrId, ProductAttrValueModel *att);
@interface ProductSpecAttrsView : UIView

@property (nonatomic, copy) Block dismissBlock;
@property (nonatomic, copy) ChooseAttrBlock chooseAttrBlock;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *selectedAttrValue;

//初始化
- (instancetype)initWithBuyMethod:(ProductViewBuyMethod)buyMethod model:(ProductDetailModel *)model;

@end

@interface ProductAttrButton : UIButton

@end


NS_ASSUME_NONNULL_END
