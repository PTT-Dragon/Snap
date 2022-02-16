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

typedef void(^afterSaleBlock)(void);

@interface OrderListItemCell : UITableViewCell
@property (nonatomic,copy) afterSaleBlock block;
- (void)setContent:(orderItemsModel *)model isInAfterSale:(BOOL)isInAfterSale;
- (void)setOrderContent:(orderItemsModel *)model state:(NSString *)state showIsAfterSale:(BOOL)isAfterSale;
- (void)setRefundContent:(RefundDetailItemsModel *)model;
- (void)setRefund2Content:(orderItemsModel *)model;
@end

NS_ASSUME_NONNULL_END
