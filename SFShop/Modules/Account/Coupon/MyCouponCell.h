//
//  MyCouponCell.h
//  SFShop
//
//  Created by 游挺 on 2021/9/26.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCouponCell : UITableViewCell
- (void)setContent:(CouponModel *)model;
@end

NS_ASSUME_NONNULL_END
