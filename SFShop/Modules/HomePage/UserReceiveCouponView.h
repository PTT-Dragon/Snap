//
//  UserReceiveCouponView.h
//  SFShop
//
//  Created by 游挺 on 2022/3/24.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserReceiveCouponView : UIView
@property (nonatomic,strong) NSArray <CouponModel *>*dataSource;

@end

NS_ASSUME_NONNULL_END
