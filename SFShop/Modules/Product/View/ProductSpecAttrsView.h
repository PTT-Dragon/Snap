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

@interface ProductSpecAttrsView : UIView

typedef void(^Block)(void);
typedef void(^ChooseAttrBlock)(void);

@property(nonatomic, strong) ProductDetailModel *model;
@property(nonatomic, strong) NSArray<ProductStockModel *> *stockModel;
@property(nonatomic, strong) ProductItemModel *selProductModel;
@property (nonatomic,strong) ProductCampaignsInfoModel *campaignsModel;
@property (nonatomic, copy) Block dismissBlock;
@property (nonatomic, copy) ChooseAttrBlock chooseAttrBlock;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *selectedAttrValue;

@end

@interface ProductAttrButton : UIButton

@end


NS_ASSUME_NONNULL_END
