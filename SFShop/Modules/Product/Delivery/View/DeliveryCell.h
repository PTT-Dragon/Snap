//
//  DeliveryCell.h
//  SFShop
//
//  Created by YouHui on 2022/1/7.
//

#import <UIKit/UIKit.h>
#import "OrderLogisticsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeliveryCell : UITableViewCell

@property (nonatomic, readwrite, strong) OrderLogisticsItem *item;

@end

NS_ASSUME_NONNULL_END
