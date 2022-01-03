//
//  CouponsCell.h
//  SFShop
//
//  Created by MasterFly on 2022/1/3.
//

#import <UIKit/UIKit.h>
#import "CouponsAvailableModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CouponsCell : UITableViewCell

@property (nonatomic, readwrite, strong) CouponItem *item;

@end

NS_ASSUME_NONNULL_END
