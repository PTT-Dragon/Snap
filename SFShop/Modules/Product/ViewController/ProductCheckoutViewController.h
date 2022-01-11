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
#import "CheckoutInputData.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductCheckoutViewController : BaseViewController

- (void)setProductModels:(NSArray<ProductDetailModel *> *)productModels
              attrValues:(NSArray<NSString *> *)attrValues
              productIds:(NSArray<NSNumber *> *)productIds
          logisticsModel:(OrderLogisticsModel *)logisticsModel
             couponModel:(CouponsAvailableModel *)couponModel
            addressModel:(addressModel *)addressModel
                feeModel:(ProductCalcFeeModel *)feeModel
                   count:(NSArray<NSNumber *> *) counts
            inCmpIdLists:(nullable NSArray<NSNumber *> *)inCmpIdLists
            deliveryMode:(NSString *)deliveryMode
                currency:(NSString *)currency
              sourceType:(NSString *)sourceType;

@end

NS_ASSUME_NONNULL_END
