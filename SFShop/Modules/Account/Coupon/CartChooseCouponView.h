//
//  CartChooseCouponView.h
//  SFShop
//
//  Created by 游挺 on 2021/12/26.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CartChooseCouponView : UIView
@property (nonatomic,strong) NSMutableArray <CouponModel *>*couponDataSource;
@end

NS_ASSUME_NONNULL_END