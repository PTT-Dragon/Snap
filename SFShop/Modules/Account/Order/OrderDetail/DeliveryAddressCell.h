//
//  DeliveryAddressCell.h
//  SFShop
//
//  Created by 游挺 on 2021/10/24.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeliveryAddressCell : UITableViewCell
- (void)setContent:(OrderDetailModel *)model;
@end

NS_ASSUME_NONNULL_END
