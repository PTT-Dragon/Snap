//
//  CheckoutManager.m
//  SFShop
//
//  Created by YouHui on 2022/1/7.
//

#import "CheckoutManager.h"
#import "addressModel.h"
#import "ProductDetailModel.h"

@interface CheckoutManager ()
@property (nonatomic, readwrite, strong) ProductCheckoutModel *cacheData;
@end

@implementation CheckoutManager

static CheckoutManager *_instance = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[CheckoutManager alloc] init];
    });
    return _instance;
}

- (void)loadCheckoutData:(ProductCheckoutModel *)model complete:(void(^)(BOOL isSuccess, ProductCheckoutModel *checkoutModel))complete {
    self.cacheData = model;
    [MBProgressHUD showHudMsg:@""];
    dispatch_group_t group = dispatch_group_create();

    //请求结算数据
    void (^calcfeeBlock)(void) = ^ {
        dispatch_group_enter(group);
        dispatch_group_async(group, dispatch_get_main_queue(), ^{
            [SFNetworkManager post:SFNet.order.calcfee parameters: self.calcfeeParams success:^(id  _Nullable response) {
                self.cacheData.feeModel = [[ProductCalcFeeModel alloc] initWithDictionary:response error:nil];
                dispatch_group_leave(group);
            } failed:^(NSError * _Nonnull error) {
                [MBProgressHUD autoDismissShowHudMsg: @"Calcfee Failed!"];
                dispatch_group_leave(group);
            }];
        });
    };
    
    if (model.addressModel.deliveryAddressId.length > 0) {//⚠️如果有地址,那么请求配送数据、再进行结算
        dispatch_group_enter(group);
        dispatch_group_async(group, dispatch_get_main_queue(), ^{
            [SFNetworkManager post:SFNet.order.logistics parameters:self.logisticsParams success:^(id  _Nullable response) {
                NSMutableArray *logisticsModels = [NSMutableArray array];
                for (NSDictionary *item in response) {
                    OrderLogisticsModel *logisticsModel = [[OrderLogisticsModel alloc] initWithDictionary:item error:nil];
                    [logisticsModels addObject:logisticsModel];
                }
                self.cacheData.logisticsModels = logisticsModels;
                calcfeeBlock();
                dispatch_group_leave(group);
            } failed:^(NSError * _Nonnull error) {
                [MBProgressHUD autoDismissShowHudMsg: @"logistics Failed!"];
                dispatch_group_leave(group);
            }];
        });
    } else {                    //⚠️如果没有地址,那么直接进行结算
        calcfeeBlock();
    }
    
    //请求商品优惠券数据
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
        [SFNetworkManager post:SFNet.order.couponsAvailable parameters:self.couponsAvailableParams success:^(id  _Nullable response) {
            self.cacheData.couponsModel = [[CouponsAvailableModel alloc] initWithDictionary:response error:nil];
            dispatch_group_leave(group);
        } failed:^(NSError * _Nonnull error) {
            [MBProgressHUD autoDismissShowHudMsg: @"coupons Failed!"];
            dispatch_group_leave(group);
        }];
    });

    //获取数据,并进入结算页面
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideFromKeyWindow];
        BOOL isSuccess = self.cacheData.couponsModel && self.cacheData.logisticsModels && self.cacheData.feeModel;
        complete(isSuccess,self.cacheData);
    });
}

- (void)calfeeByAddress:(addressModel *)addressModel complete:(void(^)(BOOL isSuccess, ProductCheckoutModel *checkoutModel))complete {
    NSAssert(self.cacheData, @"没初始化ProductCheckoutModel,请在 loadCheckoutData 函数返回数据之后调用");
    NSAssert(self.cacheData.addressModel.deliveryAddressId.length > 0, @"地址id不能为空");
    self.cacheData.addressModel = addressModel;
    [SFNetworkManager post:SFNet.order.logistics parameters:self.logisticsParams success:^(id  _Nullable response) {
        NSMutableArray *logisticsModels = [NSMutableArray array];
        for (NSDictionary *dict in response) {
            OrderLogisticsModel *logisticsModel = [[OrderLogisticsModel alloc] initWithDictionary:dict error:nil];
            [logisticsModels addObject:logisticsModel];
        }
        self.cacheData.logisticsModels = logisticsModels;
        [SFNetworkManager post:SFNet.order.calcfee parameters: self.calcfeeParams success:^(id  _Nullable response) {
            self.cacheData.feeModel = [[ProductCalcFeeModel alloc] initWithDictionary:response error:nil];
            !complete ?: complete(YES,self.cacheData);
        } failed:^(NSError * _Nonnull error) {
            !complete ?: complete(NO,self.cacheData);
            [MBProgressHUD autoDismissShowHudMsg: @"Calcfee Failed!"];
        }];
    } failed:^(NSError * _Nonnull error) {
        !complete ?: complete(nil,nil);
        [MBProgressHUD autoDismissShowHudMsg: @"logistics Failed!"];
    }];
}

- (void)calfeeByLogistic:(OrderLogisticsItem *)logisticsItem storeId:(NSInteger)storeId complete:(void(^)(BOOL isSuccess, ProductCheckoutModel *checkoutModel))complete {
    NSAssert(self.cacheData, @"没初始化ProductCheckoutModel,请在 loadCheckoutData 函数返回数据之后调用");
    NSAssert(storeId > 0, @"商店id不能为空");
    NSAssert(logisticsItem, @"选中店铺配送不能为空");
    for (ProductDetailModel *item in self.cacheData.productModels) {
        if (item.storeId == storeId) {
            item.currentLogisticsItem = logisticsItem;
        }
    }
    [SFNetworkManager post:SFNet.order.calcfee parameters: self.calcfeeParams success:^(id  _Nullable response) {
        ProductCalcFeeModel *feeModel = [[ProductCalcFeeModel alloc] initWithDictionary:response error:nil];
        self.cacheData.feeModel = feeModel;
        !complete ?: complete(YES,self.cacheData);
    } failed:^(NSError * _Nonnull error) {
        !complete ?: complete(NO,self.cacheData);
        [MBProgressHUD autoDismissShowHudMsg: @"Calcfee Failed!"];
    }];
}

- (void)calfeeByStoreCouponItem:(CouponItem *)storeCouponItem storeId:(NSInteger)storeId complete:(void(^)(BOOL isSuccess, ProductCheckoutModel *checkoutModel))complete {
    NSAssert(self.cacheData, @"没初始化ProductCheckoutModel,请在 loadCheckoutData 函数返回数据之后调用");
    NSAssert(storeId > 0, @"商店id不能为空");
    NSAssert(storeCouponItem, @"选中店铺优惠券不能为空");
    for (ProductDetailModel *item in self.cacheData.productModels) {
        if (item.storeId == storeId) {
            item.currentStoreCoupon = storeCouponItem;
        }
    }
    [SFNetworkManager post:SFNet.order.calcfee parameters: self.calcfeeParams success:^(id  _Nullable response) {
        ProductCalcFeeModel *feeModel = [[ProductCalcFeeModel alloc] initWithDictionary:response error:nil];
        self.cacheData.feeModel = feeModel;
        !complete ?: complete(YES,self.cacheData);
    } failed:^(NSError * _Nonnull error) {
        !complete ?: complete(NO,self.cacheData);
        [MBProgressHUD autoDismissShowHudMsg: @"Calcfee Failed!"];
    }];
}

- (void)calfeeByPltCouponItem:(CouponItem *)pltCouponItem complete:(void(^)(BOOL isSuccess, ProductCheckoutModel *checkoutModel))complete {
    NSAssert(self.cacheData, @"没初始化ProductCheckoutModel,请在 loadCheckoutData 函数返回数据之后调用");
    NSAssert(pltCouponItem, @"选中平台优惠券不能为空");
    self.cacheData.currentPltCoupon = pltCouponItem;
    [SFNetworkManager post:SFNet.order.calcfee parameters: self.calcfeeParams success:^(id  _Nullable response) {
        ProductCalcFeeModel *feeModel = [[ProductCalcFeeModel alloc] initWithDictionary:response error:nil];
        self.cacheData.feeModel = feeModel;
        !complete ?: complete(YES,self.cacheData);
    } failed:^(NSError * _Nonnull error) {
        !complete ?: complete(NO,self.cacheData);
        [MBProgressHUD autoDismissShowHudMsg: @"Calcfee Failed!"];
    }];
}

- (NSMutableDictionary *)logisticsParams {
    NSMutableDictionary *params = self.outter;
    NSMutableArray *stores = [NSMutableArray array];
    for (ProductDetailModel *model in self.cacheData.productModels) {
        NSMutableDictionary *store = [self innner:model];
        [stores addObject:store];
    }
    [params setObject:stores forKey:@"stores"];
    return params;
}

- (NSMutableDictionary *)couponsAvailableParams {
    return self.logisticsParams;
}

- (NSDictionary *)calcfeeParams {
    NSMutableDictionary *params = self.outter;
    [params setObject:self.cacheData.sourceType forKey:@"sourceType"];
    if (self.cacheData.currentPltCoupon.userCouponId > 0) {[params setObject:@(self.cacheData.currentPltCoupon.userCouponId) forKey:@"selUserPltCouponId"];}
    NSMutableArray *stores = [NSMutableArray array];
    for (ProductDetailModel *model in self.cacheData.productModels) {
        NSMutableDictionary *store = [self innner:model];
        NSInteger userCouponId = model.currentStoreCoupon.userCouponId;
        NSString *logisticsModeId = model.currentLogisticsItem.logisticsModeId;
        if (userCouponId > 0) {[store setObject:@(userCouponId) forKey:@"selUserCouponId"];}
        if (logisticsModeId.length > 0) {[store setObject:logisticsModeId forKey:@"logisticsModeId"];}
        [stores addObject:store];
    }
    [params setObject:stores forKey:@"stores"];
    return params;
}

#pragma mark - Private
- (NSMutableDictionary *)outter {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.cacheData.addressModel.deliveryAddressId.length > 0) {[params setObject:self.cacheData.addressModel.deliveryAddressId forKey:@"deliveryAddressId"];}
    if (self.cacheData.deliveryMode.length > 0) {[params setObject:self.cacheData.deliveryMode forKey:@"deliveryMode"];}
    return params;
}

- (NSMutableDictionary *)innner:(ProductDetailModel *)model {
    NSMutableDictionary *stores = [NSMutableDictionary dictionary];
    [stores setObject:@(model.storeId) forKey:@"storeId"];
    NSMutableArray *products = [NSMutableArray array];
    for (int i = 0; i < model.products.count; i ++) {
        ProductItemModel *item = model.products[i];
        NSInteger productId = item.productId;
        NSInteger offerCnt = item.currentBuyCount;
        NSArray *inCmpIdLists = item.inCmpIdList;
        if (productId > 0 && offerCnt > 0) {
            if (inCmpIdLists && inCmpIdLists.count > 0) {
                [products addObject:@{@"productId":@(productId),@"offerCnt":@(offerCnt),@"inCmpIdList":inCmpIdLists}];
            } else {
                [products addObject:@{@"productId":@(productId),@"offerCnt":@(offerCnt)}];
            }
        }
    }
    [stores setObject:products forKey:@"products"];
    return stores;
}


@end
