//
//  ProductCheckoutViewController.h
//  SFShop
//
//  Created by MasterFly on 2021/10/31.
//

#import <UIKit/UIKit.h>
#import "ProductCalcFeeModel.h"
#import "addressModel.h"
#import "ProductDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductCheckoutViewController : UIViewController

- (void)setProductModels:(NSArray<ProductDetailModel *> *)productModels
               attrValues:(NSArray<NSString *> *)attrValues
              productIds:(NSArray<NSNumber *> *) productIds
            addressModel: (addressModel *)addressModel
                feeModel:(ProductCalcFeeModel *)feeModel
                   count: (NSArray<NSNumber *> *) counts;
@end

NS_ASSUME_NONNULL_END
