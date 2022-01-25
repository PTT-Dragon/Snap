//
//  DeliveryAddressCell.h
//  SFShop
//
//  Created by 游挺 on 2021/10/24.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "refundModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface DeliveryAddressCell : UITableViewCell
- (void)setContent:(OrderDetailModel *)model;
- (void)setRefundContent:(RefundDetailModel *)model;
@end

NS_ASSUME_NONNULL_END
