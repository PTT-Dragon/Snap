//
//  ProductChoosePromotionCell.h
//  SFShop
//
//  Created by 游挺 on 2022/3/6.
//

#import <UIKit/UIKit.h>
#import "ProductDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductChoosePromotionCell : UITableViewCell
- (void)setModel:(cmpBuygetnsModel *)model ruleModel:(PromotionRuleModel *)ruleModel;

@end

NS_ASSUME_NONNULL_END