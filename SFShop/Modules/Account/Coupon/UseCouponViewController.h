//
//  UseCouponViewController.h
//  SFShop
//
//  Created by 游挺 on 2021/10/29.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"
#import "CartModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UseCouponViewController : UIViewController
@property (nonatomic,copy) NSString *couponId;
@property (nonatomic,weak) BuygetnInfoModel *buygetnInfoModel;

@end

NS_ASSUME_NONNULL_END
