//
//  ProductChoosePromotionTitleCell.h
//  SFShop
//
//  Created by 游挺 on 2022/3/6.
//

#import <UIKit/UIKit.h>
#import "ProductDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ProductChoosePromotionTitleCellBlock)(BOOL sel);

@interface ProductChoosePromotionTitleCell : UITableViewCell
@property (nonatomic,copy) ProductChoosePromotionTitleCellBlock block;
@property (nonatomic,strong) cmpBuygetnsModel *model;
@end

NS_ASSUME_NONNULL_END
