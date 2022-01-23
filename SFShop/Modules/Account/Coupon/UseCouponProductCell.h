//
//  UseCouponProductCell.h
//  SFShop
//
//  Created by 游挺 on 2021/10/29.
//

#import <UIKit/UIKit.h>
#import "CategoryRankModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^UseCouponProductCellBlock)(CategoryRankPageInfoListModel *model);


@interface UseCouponProductCell : UITableViewCell
@property (nonatomic,copy) UseCouponProductCellBlock block;
- (void)setContent:(CategoryRankPageInfoListModel *)model;
@end

NS_ASSUME_NONNULL_END
