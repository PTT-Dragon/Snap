//
//  ProductCheckoutViewController.h
//  SFShop
//
//  Created by MasterFly on 2021/10/31.
//

#import "BaseViewController.h"
#import "ProductCalcFeeModel.h"
#import "addressModel.h"
#import "ProductDetailModel.h"
#import "OrderLogisticsModel.h"
#import "CouponsAvailableModel.h"
#import "ProductCheckoutModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductCheckoutViewController : BaseViewController

- (instancetype)initWithCheckoutModel:(ProductCheckoutModel *)checkoutModel;

@end

NS_ASSUME_NONNULL_END
