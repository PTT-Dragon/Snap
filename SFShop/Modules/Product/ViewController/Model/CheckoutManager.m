//
//  CheckoutManager.m
//  SFShop
//
//  Created by YouHui on 2022/1/7.
//

#import "CheckoutManager.h"
#import "addressModel.h"
#import "ProductDetailModel.h"
#import "SceneManager.h"
#import "UIViewController+Top.h"

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

#pragma mark - 订单、支付
- (void)startPayWithOrderIds:(NSArray *)orderIds shareBuyOrderNbr:(NSString *)shareBuyOrderNbr totalPrice:(NSString *)totalPrice complete:(void(^)(SFPayResult result, NSString *urlOrHtml, NSDictionary *response))complete {
    NSAssert(orderIds.count > 0, @"订单iD 不能为空");
    NSAssert(totalPrice.length > 0, @"订单价格不能为空");

    //第一步：获取支付方式
//    //[MBProgressHUD showHudMsg:@""];
    [SFNetworkManager get:SFNet.order.method success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        NSArray *methods = (NSArray *)response;
        BOOL isShowPayChannel = methods.count > 1;
        if (isShowPayChannel) {
            //第二步：显示支付渠道（配置多个渠道的时候，一般正式环境只会配置一个）
            [self showPaymentAlertWithOrderIds:orderIds shareBuyOrderNbr:shareBuyOrderNbr totalPrice:totalPrice methods:methods complete:complete];
        } else {
            NSDictionary *method = methods.firstObject;
            NSArray *list = [method objectForKey:@"paymentMethodList"];
            NSString *paymentChannelCode = [method objectForKey:@"paymentChannelCode"];
            NSString *paymentMethodCode = [list.firstObject objectForKey:@"paymentMethodCode"];
            //第二步：跳转到web支付 （正式环境会走这里）
            [self jumpToWebPayWithOrderIds:orderIds shareBuyOrderNbr:shareBuyOrderNbr totalPrice:totalPrice paymentChannel:paymentChannelCode paymentMethod:paymentMethodCode complete:complete];
        }
    } failed:^(NSError * _Nonnull error) {
        !complete ?: complete(SFPayResultFailed,nil,nil);
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}

- (void)jumpToWebPayWithOrderIds:(NSArray *)orderIds shareBuyOrderNbr:(NSString *)shareBuyOrderNbr totalPrice:(NSString *)totalPrice paymentChannel:(NSString *)paymentChannel paymentMethod:(NSString *)paymentMethod complete:(void(^)(SFPayResult result,NSString *urlOrHtml, NSDictionary *response))complete {
    //{"orders":["178013","178014"],"totalPrice":106000,"returnUrl":"https://www.smartfrenshop.com/paying?type=back&orderId=178013"}
    NSString *returnUrl = nil;
    if (![shareBuyOrderNbr isKindOfClass:[NSNull class]] && shareBuyOrderNbr.length > 0) {
        returnUrl = [NSString stringWithFormat:@"%@?type=back&orderId=%@&shareBuyOrderNbr=%@",Host,orderIds.firstObject,shareBuyOrderNbr];
    } else {
        returnUrl = [NSString stringWithFormat:@"%@?type=back&orderId=%@",Host,orderIds.firstObject];
    }
    NSDictionary *params = @{
        @"paymentMethod":paymentMethod?paymentMethod:@"-1",
        @"paymentChannel":paymentChannel?paymentChannel:@"-1",
        @"totalPrice": totalPrice,
        @"returnUrl": returnUrl,
        @"orders": orderIds
    };
//    //[MBProgressHUD showHudMsg:@""];
    [SFNetworkManager post:SFNet.h5.pay parameters:params success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        NSString *urlOrHtml = response[@"urlOrHtml"];
        if (![urlOrHtml isKindOfClass:[NSNull class]] && urlOrHtml.length > 0) {
            !complete ?: complete(SFPayResultJumpToWebPay,urlOrHtml,response);
        } else {
            [self confirmPay:orderIds complete:complete];
        }
    } failed:^(NSError * _Nonnull error) {
        !complete ?: complete(SFPayResultFailed,nil,nil);
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}

- (void)confirmPay:(NSArray *)orderIds complete:(void(^)(SFPayResult result,NSString *urlOrHtml, NSDictionary *response))complete {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kLocalizedString(@"Order_payment_processing") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kLocalizedString(@"YES") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //[MBProgressHUD showHudMsg:@""];
        [SFNetworkManager post:SFNet.order.confirm parametersArr:orderIds success:^(id  _Nullable response) {
            [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"PAYMENT_SUCCESS")];
            !complete ?: complete(SFPayResultSuccess,nil,response);
        } failed:^(NSError * _Nonnull error) {
            [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
        }];
    }];
    [alert addAction:okAction];
    UIAlertAction *calcelAction = [UIAlertAction actionWithTitle:kLocalizedString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        !complete ?: complete(SFPayResultFailed,nil,nil);
    }];
    [alert addAction:calcelAction];
    [UIViewController.sf_topViewController presentViewController:alert animated:YES completion:nil];
}

- (void)showPaymentAlertWithOrderIds:(NSArray *)orderIds shareBuyOrderNbr:(NSString *)shareBuyOrderNbr totalPrice:(NSString *)totalPrice methods:(NSArray *)methodsResponse complete:(void(^)(SFPayResult result,NSString *urlOrHtml, NSDictionary *response))complete {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kLocalizedString(@"Order_payment_processing") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSDictionary *method in methodsResponse) {
        NSString *paymentChannelCode = [method objectForKey:@"paymentChannelCode"];
        NSArray *list = [method objectForKey:@"paymentMethodList"];
        for (NSDictionary *payment in list) {
            NSString *paymentMethodCode = [payment objectForKey:@"paymentMethodCode"];
            NSString *paymentMethodName = [payment objectForKey:@"paymentMethodName"];
            UIAlertAction *action = [UIAlertAction actionWithTitle:paymentMethodName style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self jumpToWebPayWithOrderIds:orderIds shareBuyOrderNbr:shareBuyOrderNbr totalPrice:totalPrice paymentChannel:paymentChannelCode paymentMethod:paymentMethodCode complete:complete];
            }];
            [alert addAction:action];
        }
    }

    UIAlertAction *cencelAction = [UIAlertAction actionWithTitle:kLocalizedString(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cencelAction];
    [UIViewController.sf_topViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 结算
- (void)loadCheckoutData:(ProductCheckoutModel *)model complete:(void(^)(BOOL isSuccess, ProductCheckoutModel *checkoutModel))complete {
    self.cacheData = model;
//    //[MBProgressHUD showHudMsg:@""];
    dispatch_group_t group = dispatch_group_create();

    //请求结算数据
    void (^calcfeeBlock)(void) = ^ {
        dispatch_group_enter(group);
        dispatch_group_async(group, dispatch_get_main_queue(), ^{
            [SFNetworkManager post:SFNet.order.calcfee parameters: self.calcfeeParams success:^(id  _Nullable response) {
                self.cacheData.feeModel = [[ProductCalcFeeModel alloc] initWithDictionary:response error:nil];
                dispatch_group_leave(group);
            } failed:^(NSError * _Nonnull error) {
                [MBProgressHUD showTopErrotMessage: @"Calcfee Failed!"];
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
                [MBProgressHUD showTopErrotMessage: @"logistics Failed!"];
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
            [MBProgressHUD showTopErrotMessage: @"coupons Failed!"];
            dispatch_group_leave(group);
        }];
    });

    //获取数据,并进入结算页面
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideFromKeyWindow];
//        && self.cacheData.logisticsModels
        BOOL isSuccess = self.cacheData.couponsModel  && self.cacheData.feeModel;
        complete(isSuccess,self.cacheData);
    });
}

- (void)calfeeByAddress:(addressModel *)addressModel complete:(void(^)(BOOL isSuccess, ProductCheckoutModel *checkoutModel))complete {
    NSAssert(self.cacheData, @"没初始化ProductCheckoutModel,请在 loadCheckoutData 函数返回数据之后调用");
//    NSAssert(self.cacheData.addressModel.deliveryAddressId.length > 0, @"地址id不能为空");
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
            [MBProgressHUD showTopErrotMessage: @"Calcfee Failed!"];
        }];
    } failed:^(NSError * _Nonnull error) {
        !complete ?: complete(nil,nil);
        [MBProgressHUD showTopErrotMessage: @"logistics Failed!"];
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
        [MBProgressHUD showTopErrotMessage: @"Calcfee Failed!"];
    }];
}

- (void)calfeeByStoreCouponItem:(CouponItem *)storeCouponItem storeId:(NSInteger)storeId complete:(void(^)(BOOL isSuccess, ProductCheckoutModel *checkoutModel))complete {
    NSAssert(self.cacheData, @"没初始化ProductCheckoutModel,请在 loadCheckoutData 函数返回数据之后调用");
    NSAssert(storeId > 0, @"商店id不能为空");
//    NSAssert(storeCouponItem, @"选中店铺优惠券不能为空");
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
        [MBProgressHUD showTopErrotMessage: @"Calcfee Failed!"];
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
        [MBProgressHUD showTopErrotMessage: @"Calcfee Failed!"];
    }];
}

#pragma mark - 参数封装
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
    for (int i = 0; i < model.selectedProducts.count; i ++) {
        ProductItemModel *item = model.selectedProducts[i];
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
