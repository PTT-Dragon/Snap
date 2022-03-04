//
//  MyCouponCell.h
//  SFShop
//
//  Created by 游挺 on 2021/9/26.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^MyCouponCellBlock)(void);

@interface MyCouponCell : UITableViewCell
@property (nonatomic,copy) MyCouponCellBlock block;
- (void)setContent:(CouponModel *)model;
@end

NS_ASSUME_NONNULL_END
