//
//  ProductCheckoutModel.m
//  SFShop
//
//  Created by MasterFly on 2021/10/31.
//

#import "ProductCheckoutModel.h"

@implementation ProductCheckoutSubItemModel

@end

@implementation ProductCheckoutModel

+ (instancetype)initWithsourceType:(NSString *)sourceType
                      addressModel:(addressModel *)addressModel
                     productModels:(NSArray<ProductDetailModel *> *)productModels {
    ProductCheckoutModel *model = [[ProductCheckoutModel alloc] init];
    model.sourceType = sourceType;
    model.addressModel = addressModel;
    model.productModels = productModels;
    model.deliveryMode = @"A";
    return model;
}

- (void)setFeeModel:(ProductCalcFeeModel *)feeModel {
    _feeModel = feeModel;
    [self syncDetailData];
}

- (void)setCouponsModel:(CouponsAvailableModel *)couponsModel {
    _couponsModel = couponsModel;
    [self syncDetailData];
}

- (void)setProductModels:(NSArray<ProductDetailModel *> *)productModels {
    _productModels = productModels;
    [self syncDetailData];
}

- (void)setLogisticsModels:(NSArray<OrderLogisticsModel *> *)logisticsModels {
    _logisticsModels = logisticsModels;
    [self syncDetailDataByLogistics];
}

- (void)syncDetailData {
    if (!self.feeModel || !self.productModels || !self.couponsModel) {
        return;
    }
        
    for (ProductDetailModel *detailModel in self.productModels) {
        for (ProductCalcFeeStoreModel *storeFeeModel in self.feeModel.stores) {
            if ([storeFeeModel.storeId isEqualToString:[NSString stringWithFormat:@"%ld",detailModel.storeId]]) {
                detailModel.feeModel = storeFeeModel;
            }
        }
        
        for (CouponsStoreModel *storeCoupon in self.couponsModel.storeAvailableCoupons) {
            if (storeCoupon.storeId == detailModel.storeId) {
                detailModel.storeCoupon = storeCoupon;
            }
        }
    }
}

- (void)syncDetailDataByLogistics {
    for (ProductDetailModel *detailModel in self.productModels) {
        for (OrderLogisticsModel *logisticsModel in self.logisticsModels) {
            if ([logisticsModel.storeId isEqualToString:[NSString stringWithFormat:@"%ld",detailModel.storeId]]) {
                detailModel.logisticsModel = logisticsModel;
                //重新选择地址时,默认选中第一个配送数据
                OrderLogisticsItem * logisticsItem = logisticsModel.logistics.firstObject;
                logisticsItem.isSelected = YES;
                detailModel.currentLogisticsItem = logisticsItem;
            }
        }
    }
}

@end
