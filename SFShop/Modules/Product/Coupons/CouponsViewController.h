//
//  CouponsViewController.h
//  SFShop
//
//  Created by MasterFly on 2022/1/3.
//

#import <UIKit/UIKit.h>
#import "CouponsAvailableModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CouponsViewController : UIViewController

@property (nonatomic, readwrite, strong) NSMutableArray<CouponItem *> *dataArray;

@property (nonatomic, readwrite, copy) void(^selectedCouponBlock)(CouponItem *_Nullable item);

@end

NS_ASSUME_NONNULL_END
