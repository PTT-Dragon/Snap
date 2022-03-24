//
//  UserReceiveCouponCell.h
//  SFShop
//
//  Created by 游挺 on 2022/3/24.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^UserReceiveCouponCellBlock)(void);

@interface UserReceiveCouponCell : UICollectionViewCell
@property (nonatomic,copy) UserReceiveCouponCellBlock block;
@property (nonatomic,strong) CouponModel *model;
@end

NS_ASSUME_NONNULL_END
