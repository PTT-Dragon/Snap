//
//  OrderListItemCell.h
//  SFShop
//
//  Created by 游挺 on 2021/10/23.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "refundModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderListItemCell : UITableViewCell
- (void)setContent:(orderItemsModel *)model;
- (void)setRefundContent:(RefundDetailItemsModel *)model;
@end

NS_ASSUME_NONNULL_END
