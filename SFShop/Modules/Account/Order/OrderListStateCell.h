//
//  OrderListStateCell.h
//  SFShop
//
//  Created by 游挺 on 2021/10/23.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderListStateCell : UITableViewCell
- (void)setContent:(OrderModel *)model;
- (void)setOrderDetailContent:(OrderDetailModel *)model;
@end

NS_ASSUME_NONNULL_END