//
//  CouponCenterCell.h
//  SFShop
//
//  Created by 游挺 on 2021/9/27.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CouponCenterCellBlock)(void);

@interface CouponCenterCell : UITableViewCell
@property (nonatomic,copy) CouponCenterCellBlock block;
- (void)setContent:(CouponModel *)model;
@end

NS_ASSUME_NONNULL_END
